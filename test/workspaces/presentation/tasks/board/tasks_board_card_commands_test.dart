import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_board_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Tasks extends Mock implements TasksRepository {}

class _Kanban extends Mock implements KanbanRepository {}

class _Store extends Mock implements TasksBoardViewPreferenceStore {}

class _Realtime extends Mock implements TaskProjectRealtime {}

class _Collaboration extends Mock implements TaskCollaborationRepository {}

class _Recurrence extends Mock implements TaskRecurrenceResponse {}

class _ListItem extends Mock implements ProjectTaskListItemResponse {}

class _ProjectTask extends Mock implements ProjectTaskResponse {}

class _Context implements TasksBoardCommandContext {
  _Context(this.currentState);
  @override
  String get workspaceId => 'workspace';
  @override
  String get projectId => 'project';
  @override
  TasksBoardState currentState;
  @override
  bool isBoardClosed = false;
  int revision = 0;
  int scopeRevision = 0;
  int reloads = 0;
  bool failReload = false;
  void Function()? afterReload;
  Completer<void>? pendingReload;
  @override
  void publish(TasksBoardState state) => currentState = state;
  @override
  Future<void> reloadBoard({bool force = false}) =>
      reloadActiveBoard(force: force);
  @override
  Future<void> reloadActiveBoard({bool force = false}) async {
    revision++;
    reloads++;
    await pendingReload?.future;
    if (failReload) {
      currentState = const TasksBoardFailure(
        message: 'Brak odczytu',
        kind: TasksBoardFailureKind.offline,
      );
    } else {
      afterReload?.call();
    }
  }

  Future<void> reloadPersons() async {
    reloads++;
    await pendingReload?.future;
    if (failReload) {
      currentState = ready.copyWith(
        error: const TasksViewError(
          code: TasksViewErrorCodes.boardReloadFailed,
        ),
      );
    } else {
      afterReload?.call();
    }
  }

  TasksBoardReady get ready => currentState as TasksBoardReady;
}

KanbanTaskCardResponse _card(String id, {int version = 1}) =>
    KanbanTaskCardResponse(
      id: id,
      number: 1,
      taskCode: 'TASK-1',
      title: id,
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      position: 1,
      checklistTotal: 0,
      checklistCompleted: 0,
      attachmentCount: 0,
      dueAtUtc: DateTime.utc(2026, 10, 9, 17),
      version: version,
    );
TasksBoardReady _state({int count = 2}) => TasksBoardReady(
  board: KanbanBoardResponse(
    projectId: 'project',
    swimlaneMode: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    hiddenColumns: [],
    visibleCardFields: [],
    defaultCardDensity: KanbanCardDensity.comfortable,
    columns: [
      KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        displayName: 'Todo',
        color: '#123456',
        totalTaskCount: count,
        isWipLimitExceeded: false,
        tasks: [for (var i = 1; i <= count; i++) _card('task-$i')],
      ),
    ],
  ),
  connectionState: WorkspaceSignalRConnectionState.connected,
  presence: [],
  selectedTaskIds: {'task-1'},
);

TaskMutationResponse<TaskMutationAcknowledgementResponse> _ack({
  int version = 2,
  bool changed = true,
}) => TaskMutationResponse(
  taskId: 'task-1',
  taskVersion: version,
  taskUpdatedAtUtc: DateTime.utc(2026),
  data: TaskMutationAcknowledgementResponse(changed: changed),
);
TasksBoardReady _replace(TasksBoardReady state, KanbanTaskCardResponse card) =>
    TasksBoardCardStateMutator.replaceCard(state, card);

void main() {
  late _Context context;
  late _Tasks tasks;
  late _Collaboration collaboration;
  late TasksBoardCardCommands commands;
  setUpAll(
    () => registerFallbackValue(
      const UpdateTaskListItemPayload(expectedVersion: 1),
    ),
  );
  setUp(() {
    context = _Context(_state());
    tasks = _Tasks();
    collaboration = _Collaboration();
    commands = TasksBoardCardCommands(
      context: context,
      scopeRevision: () => context.scopeRevision,
      refreshAssigneeBoard: context.reloadPersons,
      tasksRepository: tasks,
      collaborationRepository: collaboration,
      calendarTimeZoneId: 'Europe/Warsaw',
    );
  });
  test(
    'pin uses current card intent and never inverts refreshed desired flag',
    () async {
      context.currentState = _replace(
        context.ready,
        _card('task-1', version: 5).copyWith(isPinned: true),
      );
      final pending = Completer<Either<ApiError, Unit>>();
      when(
        () => collaboration.updatePinned(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          isPinned: false,
        ),
      ).thenAnswer((_) => pending.future);
      final operation = commands.togglePinned(_card('task-1'));
      context.currentState = _replace(
        context.ready,
        _card('task-1', version: 6).copyWith(isPinned: false),
      );
      pending.complete(const Right(unit));
      expect(await operation, isTrue);
      final card = TasksBoardCardStateMutator.findCard(
        context.ready,
        'task-1',
      )!;
      expect(card.isPinned, isFalse);
      expect(card.version, 6);
      expect(context.ready.pendingTaskIds, isEmpty);
    },
  );
  for (final watching in [false, true]) {
    test(
      'watch intent $watching handles snapshot echo before HTTP without double counter',
      () async {
        final initial = _card(
          'task-1',
          version: 4,
        ).copyWith(isWatchedByMe: watching, watcherCount: 2);
        context.currentState = _replace(context.ready, initial);
        final pending =
            Completer<
              Either<
                ApiError,
                TaskMutationResponse<TaskMutationAcknowledgementResponse>
              >
            >();
        if (watching) {
          when(
            () => collaboration.unfollow(
              workspaceId: 'workspace',
              projectId: 'project',
              taskId: 'task-1',
              expectedVersion: 4,
            ),
          ).thenAnswer((_) => pending.future);
        } else {
          when(
            () => collaboration.follow(
              workspaceId: 'workspace',
              projectId: 'project',
              taskId: 'task-1',
              expectedVersion: 4,
            ),
          ).thenAnswer((_) => pending.future);
        }
        final operation = commands.toggleWatching(_card('task-1'));
        context.currentState = _replace(
          context.ready,
          initial.copyWith(
            version: 5,
            isWatchedByMe: !watching,
            watcherCount: watching ? 1 : 3,
          ),
        );
        pending.complete(Right(_ack(version: 5)));
        expect(await operation, isTrue);
        final card = TasksBoardCardStateMutator.findCard(
          context.ready,
          'task-1',
        )!;
        expect(card.isWatchedByMe, !watching);
        expect(card.watcherCount, watching ? 1 : 3);
        expect(card.version, 5);
      },
    );
  }
  test('newer realtime version survives late watch response', () async {
    final pending =
        Completer<
          Either<
            ApiError,
            TaskMutationResponse<TaskMutationAcknowledgementResponse>
          >
        >();
    when(
      () => collaboration.follow(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        expectedVersion: 1,
      ),
    ).thenAnswer((_) => pending.future);
    final operation = commands.toggleWatching(_card('task-1'));
    context.currentState = _replace(
      context.ready,
      _card(
        'task-1',
        version: 9,
      ).copyWith(title: 'newer', isWatchedByMe: false, watcherCount: 5),
    );
    pending.complete(Right(_ack()));
    await operation;
    final card = TasksBoardCardStateMutator.findCard(context.ready, 'task-1')!;
    expect(card.version, 9);
    expect(card.title, 'newer');
    expect(card.watcherCount, 5);
    expect(card.isWatchedByMe, isFalse);
  });
  test(
    'changed false obtains canonical full watcher count without +/- guess',
    () async {
      when(
        () => collaboration.follow(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          expectedVersion: 1,
        ),
      ).thenAnswer((_) async => Right(_ack(version: 1, changed: false)));
      when(
        () => collaboration.listWatchers(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
        ),
      ).thenAnswer(
        (_) async => Right([
          TaskWatcherResponse(userId: 'one', createdAtUtc: DateTime.utc(2026)),
          TaskWatcherResponse(userId: 'two', createdAtUtc: DateTime.utc(2026)),
        ]),
      );
      expect(await commands.toggleWatching(_card('task-1')), isTrue);
      final card = TasksBoardCardStateMutator.findCard(
        context.ready,
        'task-1',
      )!;
      expect(card.isWatchedByMe, isTrue);
      expect(card.watcherCount, 2);
      expect(card.version, 1);
    },
  );
  test('changed false failed canonical read preserves coherent snapshot and diagnostics', () async {
    const error = ApiError(
      type: ApiErrorType.forbidden,
      message: 'denied',
      traceId: 'trace',
    );
    when(
      () => collaboration.follow(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        expectedVersion: 1,
      ),
    ).thenAnswer((_) async => Right(_ack(version: 1, changed: false)));
    when(
      () => collaboration.listWatchers(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
      ),
    ).thenAnswer((_) async => const Left(error));
    await commands.toggleWatching(_card('task-1'));
    final card = TasksBoardCardStateMutator.findCard(context.ready, 'task-1')!;
    expect(card.isWatchedByMe, isFalse);
    expect(card.watcherCount, 0);
    expect(context.ready.error?.apiError, error);
    expect(context.ready.pendingTaskIds, isEmpty);
  });
  test('pending pin blocks other card write and old scope releases own marker only', () async {
    final pending = Completer<Either<ApiError, Unit>>();
    when(
      () => collaboration.updatePinned(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        isPinned: true,
      ),
    ).thenAnswer((_) => pending.future);
    final operation = commands.togglePinned(_card('task-1'));
    expect(await commands.toggleWatching(_card('task-1')), isFalse);
    final changed = context.ready.copyWith(
      filter: const KanbanBoardFilter(priority: TaskPriority.low),
      selectedTaskIds: {'task-2'},
    );
    context.currentState = changed;
    context.scopeRevision++;
    pending.complete(const Right(unit));
    expect(await operation, isFalse);
    expect(context.ready.board, same(changed.board));
    expect(context.ready.selectedTaskIds, {'task-2'});
    expect(context.ready.pendingTaskIds, isEmpty);
    expect(context.ready.pendingCardOwners, isEmpty);
    expect(context.ready.error, isNull);
  });
  test(
    'throw inline releases pending and retains task with localized feedback',
    () async {
      when(
        () => tasks.updateListItem(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          payload: any(named: 'payload'),
        ),
      ).thenThrow(StateError('transport'));
      expect(
        await commands.updatePriority('task-1', TaskPriority.high),
        isFalse,
      );
      expect(context.ready.pendingTaskIds, isEmpty);
      expect(context.ready.pendingCardOwners, isEmpty);
      expect(context.ready.error?.code, 'tasks.bulk.save_failed');
      expect(
        TasksBoardCardStateMutator.findCard(context.ready, 'task-1')!.priority,
        TaskPriority.normal,
      );
    },
  );
  test('inline keeps newer version after HTTP and both snapshots update in persons grouping', () async {
    final initial = _card('task-1', version: 3);
    context.currentState = context.ready.copyWith(
      grouping: TasksBoardGrouping.assignee,
      assigneeBoard: AssigneeKanbanBoardResponse(
        projectId: 'project',
        grouping: KanbanSwimlaneMode.none,
        settingsVersion: 1,
        visibleCardFields: [],
        defaultCardDensity: KanbanCardDensity.comfortable,
        groups: [
          AssigneeKanbanGroupResponse(
            displayName: 'Member',
            totalTaskCount: 1,
            tasks: [initial],
          ),
        ],
      ),
    );
    final data = _ListItem();
    when(() => data.version).thenReturn(4);
    when(() => data.priority).thenReturn(TaskPriority.high);
    when(() => data.dueAtUtc).thenReturn(null);
    when(
      () => tasks.updateListItem(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer(
      (_) async => Right(
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 4,
          taskUpdatedAtUtc: DateTime.utc(2026),
          data: data,
        ),
      ),
    );
    expect(await commands.updatePriority('task-1', TaskPriority.high), isTrue);
    final payload =
        verify(
              () => tasks.updateListItem(
                workspaceId: 'workspace',
                projectId: 'project',
                taskId: 'task-1',
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as UpdateTaskListItemPayload;
    expect(payload.expectedVersion, 3);
    expect(context.ready.assigneeBoard!.groups.single.tasks.single.version, 4);
    expect(
      context.ready.assigneeBoard!.groups.single.tasks.single.priority,
      TaskPriority.high,
    );
    expect(context.ready.board.columns.first.tasks.first.version, 4);
  });
  test(
    'late inline success preserves newer realtime fields and version',
    () async {
      final pending =
          Completer<
            Either<ApiError, TaskMutationResponse<ProjectTaskListItemResponse>>
          >();
      when(
        () => tasks.updateListItem(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) => pending.future);
      final operation = commands.updatePriority('task-1', TaskPriority.high);
      context.currentState = _replace(
        context.ready,
        _card('task-1', version: 8).copyWith(title: 'Realtime'),
      );
      final data = _ListItem();
      when(() => data.version).thenReturn(2);
      pending.complete(
        Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 2,
            taskUpdatedAtUtc: DateTime.utc(2026),
            data: data,
          ),
        ),
      );
      expect(await operation, isTrue);
      final card = TasksBoardCardStateMutator.findCard(
        context.ready,
        'task-1',
      )!;
      expect(card.version, 8);
      expect(card.title, 'Realtime');
      expect(card.priority, TaskPriority.normal);
      expect(context.ready.pendingTaskIds, isEmpty);
    },
  );
  test(
    'replace assignees clears primary and full IDs, and catches throw on retry',
    () async {
      context.currentState = _replace(
        context.ready,
        _card('task-1')
            .copyWith(primaryAssigneeUserId: 'old', assigneeUserIds: ['old']),
      );
      final data = _ProjectTask();
      when(() => data.version).thenReturn(2);
      when(() => data.assignees).thenReturn([]);
      when(
        () => collaboration.replaceAssignees(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          userIds: [],
          expectedVersion: 1,
        ),
      ).thenAnswer(
        (_) async => Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 2,
            taskUpdatedAtUtc: DateTime.utc(2026),
            data: data,
          ),
        ),
      );
      expect(await commands.replaceAssignees('task-1', []), isTrue);
      final card = TasksBoardCardStateMutator.findCard(
        context.ready,
        'task-1',
      )!;
      expect(card.primaryAssigneeUserId, isNull);
      expect(card.assigneeUserIds, isEmpty);
      when(
        () => collaboration.replaceAssignees(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          userIds: [],
          expectedVersion: 2,
        ),
      ).thenThrow(StateError('transport'));
      expect(await commands.replaceAssignees('task-1', []), isFalse);
      expect(context.ready.pendingTaskIds, isEmpty);
      expect(context.ready.error?.code, 'tasks.bulk.save_failed');
    },
  );
  test(
    '400 preserves typed diagnostic and newer owner is never released',
    () async {
      const error = ApiError(
        type: ApiErrorType.validation,
        message: '400',
        statusCode: 400,
        apiCode: 'task.validation',
        traceId: 'trace',
      );
      when(
        () => collaboration.updatePinned(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          isPinned: true,
        ),
      ).thenAnswer((_) async => const Left(error));
      expect(await commands.togglePinned(_card('task-1')), isFalse);
      expect(context.ready.error?.apiError, error);
      expect(context.ready.pendingTaskIds, isEmpty);
      final pending = Completer<Either<ApiError, Unit>>();
      when(
        () => collaboration.updatePinned(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          isPinned: true,
        ),
      ).thenAnswer((_) => pending.future);
      final operation = commands.togglePinned(_card('task-1'));
      final owner = Object();
      context.currentState = context.ready.copyWith(
        pendingCardOwners: {'task-1': owner},
      );
      pending.complete(const Right(unit));
      expect(await operation, isFalse);
      expect(context.ready.pendingTaskIds, contains('task-1'));
      expect(context.ready.pendingCardOwners['task-1'], same(owner));
    },
  );
  test('closed card scope never publishes deferred response', () async {
    final pending = Completer<Either<ApiError, Unit>>();
    when(
      () => collaboration.updatePinned(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        isPinned: true,
      ),
    ).thenAnswer((_) => pending.future);
    final operation = commands.togglePinned(_card('task-1'));
    final before = context.currentState;
    context.isBoardClosed = true;
    pending.complete(const Right(unit));
    expect(await operation, isFalse);
    expect(context.currentState, same(before));
  });
  test(
    'recurrence never replaces newer task version or recreates absent task',
    () {
      context.currentState = _replace(
        context.ready,
        _card('task-1', version: 8),
      );
      final before = context.currentState;
      commands.applyRecurrenceMutation(
        _card('task-1'),
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 2,
          taskUpdatedAtUtc: DateTime.utc(2026),
          data: _Recurrence(),
        ),
      );
      commands.applyRecurrenceMutation(
        _card('missing'),
        TaskMutationResponse(
          taskId: 'missing',
          taskVersion: 9,
          taskUpdatedAtUtc: DateTime.utc(2026),
          data: _Recurrence(),
        ),
      );
      expect(context.currentState, same(before));
    },
  );
  test(
    'inactive-only card or missing persons board cannot begin a write',
    () async {
      context.currentState = context.ready.copyWith(
        grouping: TasksBoardGrouping.assignee,
      );
      expect(await commands.togglePinned(_card('task-1')), isFalse);
      expect(
        await commands.updatePriority('task-1', TaskPriority.high),
        isFalse,
      );
      context.currentState = context.ready.copyWith(
        assigneeBoard: AssigneeKanbanBoardResponse(
          projectId: 'project',
          grouping: KanbanSwimlaneMode.none,
          settingsVersion: 1,
          visibleCardFields: [],
          defaultCardDensity: KanbanCardDensity.comfortable,
          groups: [
            AssigneeKanbanGroupResponse(
              displayName: 'Other',
              totalTaskCount: 1,
              tasks: [_card('task-2')],
            ),
          ],
        ),
      );
      expect(await commands.toggleWatching(_card('task-1')), isFalse);
      verifyZeroInteractions(tasks);
      verifyZeroInteractions(collaboration);
      expect(context.ready.pendingTaskIds, isEmpty);
    },
  );
  for (final fail in [false, true]) {
    test(
      'persons reassignment commits once then canonical refresh failure=$fail',
      () async {
        final initial = _card('task-1')
            .copyWith(primaryAssigneeUserId: 'old', assigneeUserIds: ['old']);
        context.currentState = _replace(context.ready, initial).copyWith(
          grouping: TasksBoardGrouping.assignee,
          assigneeBoard: AssigneeKanbanBoardResponse(
            projectId: 'project',
            grouping: KanbanSwimlaneMode.none,
            settingsVersion: 1,
            visibleCardFields: [],
            defaultCardDensity: KanbanCardDensity.comfortable,
            groups: [
              AssigneeKanbanGroupResponse(
                assigneeUserId: 'old',
                displayName: 'Old',
                totalTaskCount: 1,
                tasks: [initial],
              ),
            ],
          ),
        );
        final data = _ProjectTask();
        when(() => data.version).thenReturn(2);
        when(() => data.assignees).thenReturn([]);
        when(
          () => collaboration.replaceAssignees(
            workspaceId: 'workspace',
            projectId: 'project',
            taskId: 'task-1',
            userIds: [],
            expectedVersion: 1,
          ),
        ).thenAnswer(
          (_) async => Right(
            TaskMutationResponse(
              taskId: 'task-1',
              taskVersion: 2,
              taskUpdatedAtUtc: DateTime.utc(2026),
              data: data,
            ),
          ),
        );
        context.failReload = fail;
        context.afterReload = () {
          final ready = context.ready;
          final updated = TasksBoardCardStateMutator.findCard(ready, 'task-1')!;
          context.currentState = ready.copyWith(
            assigneeBoard: ready.assigneeBoard!.copyWith(
              groups: [
                const AssigneeKanbanGroupResponse(
                  assigneeUserId: 'old',
                  displayName: 'Old',
                  totalTaskCount: 0,
                  tasks: [],
                ),
                AssigneeKanbanGroupResponse(
                  displayName: 'Unassigned',
                  totalTaskCount: 1,
                  tasks: [updated],
                ),
              ],
            ),
          );
        };
        expect(await commands.replaceAssignees('task-1', []), isTrue);
        expect(context.reloads, 1);
        expect(context.ready.pendingTaskIds, isEmpty);
        verify(
          () => collaboration.replaceAssignees(
            workspaceId: 'workspace',
            projectId: 'project',
            taskId: 'task-1',
            userIds: [],
            expectedVersion: 1,
          ),
        ).called(1);
        if (fail) {
          expect(context.ready.error?.code, TasksViewErrorCodes.boardReloadFailed);
          expect(
            TasksBoardCardStateMutator.findCard(
              context.ready,
              'task-1',
            )!.version,
            2,
          );
        } else {
          expect(context.ready.assigneeBoard!.groups.first.tasks, isEmpty);
          expect(
            context
                .ready
                .assigneeBoard!
                .groups
                .last
                .tasks
                .single
                .primaryAssigneeUserId,
            isNull,
          );
          expect(context.ready.assigneeBoard!.groups.last.totalTaskCount, 1);
        }
      },
    );
  }
  test(
    'pin intent uses active personal flag despite newer inactive task version',
    () async {
      final active = _card('task-1', version: 5).copyWith(isPinned: true);
      final inactive = _card(
        'task-1',
        version: 6,
      ).copyWith(isPinned: false, title: 'newer task data');
      final board = context.ready.board;
      context.currentState = context.ready.copyWith(
        board: board.copyWith(
          columns: [
            board.columns.first.copyWith(tasks: [inactive]),
          ],
        ),
        grouping: TasksBoardGrouping.assignee,
        assigneeBoard: AssigneeKanbanBoardResponse(
          projectId: 'project',
          grouping: KanbanSwimlaneMode.none,
          settingsVersion: 1,
          visibleCardFields: [],
          defaultCardDensity: KanbanCardDensity.comfortable,
          groups: [
            AssigneeKanbanGroupResponse(
              displayName: 'Member',
              totalTaskCount: 1,
              tasks: [active],
            ),
          ],
        ),
      );
      when(
        () => collaboration.updatePinned(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          isPinned: false,
        ),
      ).thenAnswer((_) async => const Right(unit));
      expect(await commands.togglePinned(_card('task-1')), isTrue);
      expect(
        context.ready.assigneeBoard!.groups.single.tasks.single.isPinned,
        isFalse,
      );
      expect(
        context.ready.assigneeBoard!.groups.single.tasks.single.version,
        6,
      );
      expect(
        context.ready.assigneeBoard!.groups.single.tasks.single.title,
        'newer task data',
      );
      verify(
        () => collaboration.updatePinned(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task-1',
          isPinned: false,
        ),
      ).called(1);
    },
  );
  test('scope change during canonical changed-false watcher read ignores its late result', () async {
    final read = Completer<Either<ApiError, List<TaskWatcherResponse>>>();
    when(
      () => collaboration.follow(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        expectedVersion: 1,
      ),
    ).thenAnswer((_) async => Right(_ack(version: 1, changed: false)));
    when(
      () => collaboration.listWatchers(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
      ),
    ).thenAnswer((_) => read.future);
    final operation = commands.toggleWatching(_card('task-1'));
    await Future<void>.delayed(Duration.zero);
    final changed = context.ready.copyWith(
      filter: const KanbanBoardFilter(priority: TaskPriority.low),
    );
    context.currentState = changed;
    context.scopeRevision++;
    read.complete(const Right([]));
    expect(await operation, isFalse);
    expect(context.ready.board, same(changed.board));
    expect(context.ready.error, isNull);
    expect(context.ready.pendingTaskIds, isEmpty);
  });
  for (final failureType in [ApiErrorType.connection, ApiErrorType.forbidden]) {
    test(
      'real Cubit persons GET $failureType retains concurrent second-card committed update',
      () async {
        final kanban = _Kanban();
        final realtime = _Realtime();
        when(realtime.dispose).thenAnswer((_) async {});
        final cubit = TasksBoardCubit(
          kanban,
          realtime,
          tasks,
          workspaceId: 'workspace',
          projectId: 'project',
          collaborationRepository: collaboration,
          calendarTimeZoneId: 'Europe/Warsaw',
        );
        final initial = _state();
        cubit.publish(
          initial.copyWith(
            grouping: TasksBoardGrouping.assignee,
            assigneeBoard: AssigneeKanbanBoardResponse(
              projectId: 'project',
              grouping: KanbanSwimlaneMode.none,
              settingsVersion: 1,
              visibleCardFields: [],
              defaultCardDensity: KanbanCardDensity.comfortable,
              groups: [
                AssigneeKanbanGroupResponse(
                  assigneeUserId: 'old',
                  displayName: 'Old',
                  totalTaskCount: 2,
                  tasks: initial.board.columns.first.tasks,
                ),
              ],
            ),
          ),
        );
        final read = Completer<Either<ApiError, AssigneeKanbanBoardResponse>>();
        when(
          () => kanban.getAssigneeBoard(
            workspaceId: 'workspace',
            projectId: 'project',
          ),
        ).thenAnswer((_) => read.future);
        final a = _ProjectTask();
        when(() => a.version).thenReturn(2);
        when(() => a.assignees).thenReturn([]);
        when(
          () => collaboration.replaceAssignees(
            workspaceId: 'workspace',
            projectId: 'project',
            taskId: 'task-1',
            userIds: [],
            expectedVersion: 1,
          ),
        ).thenAnswer(
          (_) async => Right(
            TaskMutationResponse(
              taskId: 'task-1',
              taskVersion: 2,
              taskUpdatedAtUtc: DateTime.utc(2026),
              data: a,
            ),
          ),
        );
        final savingA = cubit.replaceTaskAssignees('task-1', []);
        await Future<void>.delayed(Duration.zero);
        final b = _ListItem();
        when(() => b.version).thenReturn(2);
        when(() => b.priority).thenReturn(TaskPriority.high);
        when(() => b.dueAtUtc).thenReturn(null);
        when(
          () => tasks.updateListItem(
            workspaceId: 'workspace',
            projectId: 'project',
            taskId: 'task-2',
            payload: any(named: 'payload'),
          ),
        ).thenAnswer(
          (_) async => Right(
            TaskMutationResponse(
              taskId: 'task-2',
              taskVersion: 2,
              taskUpdatedAtUtc: DateTime.utc(2026),
              data: b,
            ),
          ),
        );
        expect(
          await cubit.updateTaskPriority('task-2', TaskPriority.high),
          isTrue,
        );
        read.complete(
          Left(
            ApiError(
              type: failureType,
              message: 'Read failed',
              traceId: 'trace',
            ),
          ),
        );
        expect(await savingA, isTrue);
        final ready = cubit.state as TasksBoardReady;
        final actualB = TasksBoardCardStateMutator.findCard(ready, 'task-2')!;
        expect(actualB.version, 2);
        expect(actualB.priority, TaskPriority.high);
        expect(ready.pendingTaskIds, isEmpty);
        expect(ready.pendingCardOwners, isEmpty);
        expect(ready.error?.apiError?.type, failureType);
        expect(ready.error?.traceId, 'trace');
        verifyNever(
          () => kanban.getBoard(
            workspaceId: 'workspace',
            projectId: 'project',
          ),
        );
        verify(
          () => kanban.getAssigneeBoard(
            workspaceId: 'workspace',
            projectId: 'project',
          ),
        ).called(1);
        await cubit.close();
      },
    );
  }
  for (final concurrent in ['priority', 'optimisticMove', 'presence']) {
    test(
      'real Cubit rejects stale successful persons GET after concurrent $concurrent',
      () async {
        final kanban = _Kanban();
        final realtime = _Realtime();
        when(realtime.dispose).thenAnswer((_) async {});
        final cubit = TasksBoardCubit(
          kanban,
          realtime,
          tasks,
          workspaceId: 'workspace',
          projectId: 'project',
          collaborationRepository: collaboration,
          calendarTimeZoneId: 'Europe/Warsaw',
        );
        final initial = _state();
        final a0 = _card('task-1')
            .copyWith(primaryAssigneeUserId: 'old', assigneeUserIds: ['old']);
        final b0 = _card('task-2')
            .copyWith(primaryAssigneeUserId: 'old', assigneeUserIds: ['old']);
        cubit.publish(
          initial.copyWith(
            grouping: TasksBoardGrouping.assignee,
            assigneeBoard: AssigneeKanbanBoardResponse(
              projectId: 'project',
              grouping: KanbanSwimlaneMode.none,
              settingsVersion: 1,
              visibleCardFields: [],
              defaultCardDensity: KanbanCardDensity.comfortable,
              groups: [
                AssigneeKanbanGroupResponse(
                  assigneeUserId: 'old',
                  displayName: 'Old',
                  totalTaskCount: 2,
                  tasks: [a0, b0],
                ),
                const AssigneeKanbanGroupResponse(
                  assigneeUserId: 'new',
                  displayName: 'New',
                  totalTaskCount: 0,
                  tasks: [],
                ),
                const AssigneeKanbanGroupResponse(
                  displayName: 'Unassigned',
                  totalTaskCount: 0,
                  tasks: [],
                ),
              ],
            ),
          ),
        );
        final firstRead =
            Completer<Either<ApiError, AssigneeKanbanBoardResponse>>();
        var reads = 0;
        AssigneeKanbanBoardResponse canonical() {
          final ready = cubit.state as TasksBoardReady;
          final a = TasksBoardCardStateMutator.findCard(ready, 'task-1')!;
          final b = TasksBoardCardStateMutator.findCard(ready, 'task-2')!;
          return ready.assigneeBoard!.copyWith(
            groups: [
              AssigneeKanbanGroupResponse(
                assigneeUserId: 'old',
                displayName: 'Old',
                totalTaskCount: b.primaryAssigneeUserId == 'old' ? 1 : 0,
                tasks: b.primaryAssigneeUserId == 'old' ? [b] : [],
              ),
              AssigneeKanbanGroupResponse(
                assigneeUserId: 'new',
                displayName: 'New',
                totalTaskCount: b.primaryAssigneeUserId == 'new' ? 1 : 0,
                tasks: b.primaryAssigneeUserId == 'new' ? [b] : [],
              ),
              AssigneeKanbanGroupResponse(
                displayName: 'Unassigned',
                totalTaskCount: 1,
                tasks: [a],
              ),
            ],
          );
        }

        when(
          () => kanban.getAssigneeBoard(
            workspaceId: 'workspace',
            projectId: 'project',
          ),
        ).thenAnswer((_) {
          reads++;
          return reads == 1
              ? firstRead.future
              : Future.value(Right(canonical()));
        });
        final a = _ProjectTask();
        when(() => a.version).thenReturn(2);
        when(() => a.assignees).thenReturn([]);
        when(
          () => collaboration.replaceAssignees(
            workspaceId: 'workspace',
            projectId: 'project',
            taskId: 'task-1',
            userIds: [],
            expectedVersion: 1,
          ),
        ).thenAnswer(
          (_) async => Right(
            TaskMutationResponse(
              taskId: 'task-1',
              taskVersion: 2,
              taskUpdatedAtUtc: DateTime.utc(2026),
              data: a,
            ),
          ),
        );
        final savingA = cubit.replaceTaskAssignees('task-1', []);
        await Future<void>.delayed(Duration.zero);
        final captured = canonical();
        Future<bool>? savingB;
        final move =
            Completer<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>>();
        if (concurrent == 'priority') {
          final b = _ListItem();
          when(() => b.version).thenReturn(2);
          when(() => b.priority).thenReturn(TaskPriority.high);
          when(() => b.dueAtUtc).thenReturn(null);
          when(
            () => tasks.updateListItem(
              workspaceId: 'workspace',
              projectId: 'project',
              taskId: 'task-2',
              payload: any(named: 'payload'),
            ),
          ).thenAnswer(
            (_) async => Right(
              TaskMutationResponse(
                taskId: 'task-2',
                taskVersion: 2,
                taskUpdatedAtUtc: DateTime.utc(2026),
                data: b,
              ),
            ),
          );
          expect(
            await cubit.updateTaskPriority('task-2', TaskPriority.high),
            isTrue,
          );
        } else if (concurrent == 'optimisticMove') {
          when(
            () => kanban.changePrimaryAssignee(
              workspaceId: 'workspace',
              projectId: 'project',
              taskId: 'task-2',
              targetUserId: 'new',
              expectedVersion: 1,
            ),
          ).thenAnswer((_) => move.future);
          savingB = cubit.moveTaskToAssignee(task: b0, targetUserId: 'new');
        } else {
          final ready = cubit.state as TasksBoardReady;
          cubit.publish(ready.copyWith(memberPresenceIsFresh: true));
        }
        firstRead.complete(Right(captured));
        expect(await savingA, isTrue);
        final ready = cubit.state as TasksBoardReady;
        expect(ready.isAssigneeBoardLoading, isFalse);
        if (concurrent == 'priority') {
          final b = ready.assigneeBoard!.groups.first.tasks.single;
          expect(b.version, 2);
          expect(b.priority, TaskPriority.high);
          expect(reads, 2);
          expect(ready.assigneeBoard!.groups.first.totalTaskCount, 1);
        } else if (concurrent == 'optimisticMove') {
          expect(reads, 2);
          expect(ready.assigneeBoard!.groups[1].tasks.single.id, 'task-2');
          expect(
            ready.assigneeBoard!.groups[1].tasks.single.primaryAssigneeUserId,
            'new',
          );
          expect(ready.assigneeBoard!.groups[1].totalTaskCount, 1);
          expect(ready.error?.code, TasksViewErrorCodes.boardReloadFailed);
          move.complete(
            Right(
              ChangeKanbanPrimaryAssigneeResponse(
                task: b0.copyWith(
                  version: 2,
                  primaryAssigneeUserId: 'new',
                  assigneeUserIds: ['old', 'new'],
                ),
                previousAssigneeUserId: 'old',
                previousGroupTaskCount: 1,
                targetAssigneeUserId: 'new',
                targetGroupTaskCount: 1,
              ),
            ),
          );
          expect(await savingB!, isTrue);
        } else {
          expect(reads, 1);
          expect(ready.memberPresenceIsFresh, isTrue);
        }
        await cubit.close();
      },
    );
  }
  for (final scenario in ['throw', 'closed', 'scope', 'newerRead']) {
    test(
      'persons load scoped cleanup handles $scenario without clearing newer query',
      () async {
        final kanban = _Kanban();
        context.currentState = context.ready.copyWith(
          grouping: TasksBoardGrouping.assignee,
        );
        final commands = TasksBoardAssigneeCommands(
          context: context,
          repository: kanban,
          viewPreferenceStore: _Store(),
          scopeRevision: () => context.scopeRevision,
        );
        final read = Completer<Either<ApiError, AssigneeKanbanBoardResponse>>();
        final secondRead =
            Completer<Either<ApiError, AssigneeKanbanBoardResponse>>();
        var calls = 0;
        when(
          () => kanban.getAssigneeBoard(
            workspaceId: 'workspace',
            projectId: 'project',
          ),
        ).thenAnswer((_) => ++calls == 1 ? read.future : secondRead.future);
        final loading = commands.loadBoard();
        expect(context.ready.isAssigneeBoardLoading, isTrue);
        final original = context.currentState;
        const board = AssigneeKanbanBoardResponse(
          projectId: 'project',
          grouping: KanbanSwimlaneMode.none,
          settingsVersion: 1,
          visibleCardFields: [],
          defaultCardDensity: KanbanCardDensity.comfortable,
          groups: [],
        );
        if (scenario == 'newerRead') {
          final loadingSecond = commands.loadBoard();
          read.completeError(StateError('old query'));
          await loading;
          expect(context.ready.isAssigneeBoardLoading, isTrue);
          expect(context.ready.error, isNull);
          secondRead.complete(const Right(board));
          await loadingSecond;
          expect(context.ready.isAssigneeBoardLoading, isFalse);
          expect(context.ready.error, isNull);
        } else {
          if (scenario == 'closed') context.isBoardClosed = true;
          if (scenario == 'scope') {
            context.currentState = context.ready.copyWith(
              grouping: TasksBoardGrouping.status,
            );
            context.scopeRevision++;
          }
          if (scenario == 'scope') {
            read.complete(const Right(board));
          } else {
            read.completeError(StateError('query'));
          }
          await loading;
          if (scenario == 'closed') {
            expect(context.currentState, same(original));
          } else {
            expect(context.ready.isAssigneeBoardLoading, isFalse);
            expect(
              context.ready.error?.code,
              scenario == 'throw'
                  ? TasksViewErrorCodes.boardReloadFailed
                  : null,
            );
            expect(
              context.ready.board,
              same((original as TasksBoardReady).board),
            );
          }
        }
        commands.reset();
      },
    );
  }
}
