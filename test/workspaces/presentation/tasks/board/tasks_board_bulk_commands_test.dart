import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_bulk_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _BoardRepo extends Mock implements KanbanRepository {}

class _TaskRepo extends Mock implements TasksRepository {}

class _CollaborationRepo extends Mock implements TaskCollaborationRepository {}

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
void main() {
  late _Context context;
  late _BoardRepo board;
  late _TaskRepo tasks;
  late TasksBoardBulkCommands commands;
  setUpAll(() {
    registerFallbackValue(const BulkUpdateKanbanTasksPayload(tasks: []));
    registerFallbackValue(
      const BulkUpdateTaskSelectionPayload(selectionToken: ''),
    );
  });
  setUp(() {
    context = _Context(_state());
    board = _BoardRepo();
    tasks = _TaskRepo();
    commands = TasksBoardBulkCommands(
      context: context,
      repository: board,
      tasksRepository: tasks,
      calendarTimeZoneId: 'Europe/Warsaw',
      boardQueryRevision: () => context.revision,
      scopeRevision: () => context.scopeRevision,
    );
  });
  test(
    'bulk saving blocks every card mutation including follow and unfollow',
    () async {
      final collaboration = _CollaborationRepo();
      final cards = TasksBoardCardCommands(
        context: context,
        tasksRepository: tasks,
        collaborationRepository: collaboration,
      );
      context.currentState = context.ready.copyWith(isBulkSaving: true);
      final card = _card('task-1');
      expect(await cards.togglePinned(card), isFalse);
      expect(await cards.toggleWatching(card), isFalse);
      expect(
        await cards.toggleWatching(card.copyWith(isWatchedByMe: true)),
        isFalse,
      );
      expect(await cards.updatePriority(card.id, TaskPriority.high), isFalse);
      expect(await cards.updateDueDate(card.id, null), isFalse);
      expect(await cards.replaceAssignees(card.id, ['member']), isFalse);
      verifyZeroInteractions(tasks);
      verifyZeroInteractions(collaboration);
      expect(context.ready.pendingTaskIds, isEmpty);
      expect(context.ready.isBulkSaving, isTrue);
    },
  );

  test(
    'unexpected mutation exception preserves selection and releases busy',
    () async {
      when(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).thenThrow(StateError('transport failure'));
      await commands.bulkUpdatePriority(TaskPriority.high);
      expect(context.ready.selectedTaskIds, {'task-1'});
      expect(context.ready.bulkError?.code, 'tasks.bulk.save_failed');
      expect(context.ready.canRetryBulk, isTrue);
      expect(context.ready.isBulkSaving, isFalse);
      expect(context.reloads, 0);
    },
  );

  test(
    'refresh retry does not restore old scope after deferred GET failure',
    () async {
      when(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer(
        (_) async => const Right(
          BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 1),
        ),
      );
      context.failReload = true;
      await commands.bulkUpdatePriority(TaskPriority.high);
      expect(context.ready.canRetryBulk, isTrue);
      context.pendingReload = Completer<void>();
      final retry = commands.retryBulkOperation();
      final next = context.ready.copyWith(
        filter: const KanbanBoardFilter(priority: TaskPriority.low),
        selectedTaskIds: {'task-2'},
        clearBulkError: true,
        canRetryBulk: false,
      );
      context.currentState = next;
      context.scopeRevision++;
      context.pendingReload!.complete();
      await retry;
      // A GET failure may own the global failure state, but must never restore
      // the previous scope snapshot or retry intent.
      expect(context.currentState, isA<TasksBoardFailure>());
      verify(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    },
  );

  test('busy blocks clear and repeat; 400 retains selection and explicit retry uses fresh versions', () async {
    final pending =
        Completer<Either<ApiError, BulkUpdateKanbanTasksResponse>>();
    when(
      () => board.bulkUpdate(
        workspaceId: 'workspace',
        projectId: 'project',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => pending.future);
    final saving = commands.bulkUpdatePriority(TaskPriority.high);
    expect(context.ready.isBulkSaving, isTrue);
    commands.clearSelection();
    commands.toggleSelection(_card('task-2'));
    await commands.bulkUpdatePriority(TaskPriority.low);
    expect(context.ready.selectedTaskIds, {'task-1'});
    pending.complete(
      const Left(
        ApiError(
          type: ApiErrorType.validation,
          statusCode: 400,
          message: 'Termin jest nieprawidłowy',
          traceId: 'trace',
        ),
      ),
    );
    await saving;
    expect(context.ready.isBulkSaving, isFalse);
    expect(context.ready.bulkError?.apiError?.statusCode, 400);
    expect(context.ready.bulkError?.traceId, 'trace');
    expect(context.ready.canRetryBulk, isTrue);
    context.currentState = context.ready.copyWith(
      board: context.ready.board.copyWith(
        columns: [
          context.ready.board.columns.first.copyWith(
            tasks: [_card('task-1', version: 3), _card('task-2')],
          ),
        ],
      ),
    );
    when(
      () => board.bulkUpdate(
        workspaceId: 'workspace',
        projectId: 'project',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 1),
      ),
    );
    await commands.retryBulkOperation();
    final calls = verify(
      () => board.bulkUpdate(
        workspaceId: 'workspace',
        projectId: 'project',
        payload: captureAny(named: 'payload'),
      ),
    ).captured.cast<BulkUpdateKanbanTasksPayload>();
    expect(calls, hasLength(2));
    expect(calls.last.tasks.single.expectedVersion, 3);
    expect(calls.last.priority, TaskPriority.high);
    expect(context.ready.selectedTaskIds, isEmpty);
    expect(context.ready.bulkError, isNull);
    expect(context.ready.isBulkSaving, isFalse);
  });
  test(
    'clear due date is one atomic explicit request with zone and all versions',
    () async {
      context.currentState = context.ready.copyWith(
        selectedTaskIds: {'task-1', 'task-2'},
      );
      when(
        () => tasks.bulkUpdateTaskSelection(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer(
        (_) async => const Right(
          BulkUpdateTaskSelectionResponse(updatedCount: 2),
        ),
      );
      await commands.bulkClearDueDate();
      final payload =
          verify(
                () => tasks.bulkUpdateTaskSelection(
                  workspaceId: 'workspace',
                  projectId: 'project',
                  payload: captureAny(named: 'payload'),
                ),
              ).captured.single
              as BulkUpdateTaskSelectionPayload;
      expect(payload.clearDueAtUtc, isTrue);
      expect(payload.dueAtUtc, isNull);
      expect(payload.selectionToken, isEmpty);
      expect(payload.calendarTimeZoneId, 'Europe/Warsaw');
      expect(payload.tasks!.map((item) => item.taskId), ['task-1', 'task-2']);
      expect(payload.tasks!.map((item) => item.expectedVersion), [1, 1]);
      expect(context.reloads, 1);
      expect(context.ready.selectedTaskIds, isEmpty);
      verifyNever(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      );
    },
  );
  test(
    'stale filter result cannot clear new scope selection; busy is released',
    () async {
      final pending =
          Completer<Either<ApiError, BulkUpdateKanbanTasksResponse>>();
      when(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) => pending.future);
      final saving = commands.bulkUpdatePriority(TaskPriority.high);
      context.revision++;
      context.scopeRevision++;
      context.currentState = context.ready.copyWith(
        filter: const KanbanBoardFilter(priority: TaskPriority.low),
        selectedTaskIds: {'task-2'},
      );
      pending.complete(
        const Right(BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 1)),
      );
      await saving;
      expect(context.ready.selectedTaskIds, {'task-2'});
      expect(context.ready.isBulkSaving, isFalse);
      expect(context.reloads, 0);
      expect(context.ready.canRetryBulk, isFalse);
    },
  );
  test(
    'new selection after rejected operation invalidates retry intention',
    () async {
      when(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(type: ApiErrorType.conflict, message: 'Zmieniona wersja'),
        ),
      );
      await commands.bulkUpdatePriority(TaskPriority.high);
      commands.toggleSelection(_card('task-2'));
      await commands.retryBulkOperation();
      expect(context.ready.selectedTaskIds, {'task-1', 'task-2'});
      expect(context.ready.canRetryBulk, isFalse);
      verify(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    },
  );
  test(
    'saved operation with failed GET retries only GET without another mutation',
    () async {
      context.failReload = true;
      when(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer(
        (_) async => const Right(
          BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 1),
        ),
      );
      await commands.bulkUpdatePriority(TaskPriority.high);
      expect(context.ready.bulkError?.code, 'tasks.view.board_refresh_failed');
      expect(context.ready.canRetryBulk, isTrue);
      expect(context.ready.selectedTaskIds, isEmpty);
      context.failReload = false;
      await commands.retryBulkOperation();
      expect(context.reloads, 2);
      expect(context.ready.bulkError, isNull);
      verify(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    },
  );
  test('closed scope drops pending reply', () async {
    final pending =
        Completer<Either<ApiError, BulkUpdateKanbanTasksResponse>>();
    when(
      () => board.bulkUpdate(
        workspaceId: 'workspace',
        projectId: 'project',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => pending.future);
    final saving = commands.bulkUpdatePriority(TaskPriority.high);
    context.isBoardClosed = true;
    final closedState = context.currentState;
    pending.complete(
      const Right(BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 1)),
    );
    await saving;
    expect(identical(context.currentState, closedState), isTrue);
    expect(context.reloads, 0);
  });
  test('101 cards fail visibly without non atomic requests', () async {
    context.currentState = _state(count: 101);
    commands.selectAllLoaded();
    await commands.bulkClearDueDate();
    expect(context.ready.bulkError?.code, 'tasks.bulk.kanban_selection_limit');
    expect(context.ready.selectedTaskIds, hasLength(101));
    expect(context.ready.canRetryBulk, isFalse);
    verifyNever(
      () => tasks.bulkUpdateTaskSelection(
        workspaceId: 'workspace',
        projectId: 'project',
        payload: any(named: 'payload'),
      ),
    );
  });
  test('assignee grouping uses its loaded cards and deduplicates freshest versions', () async {
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
            displayName: 'One',
            totalTaskCount: 1,
            tasks: [_card('task-3', version: 2)],
          ),
          AssigneeKanbanGroupResponse(
            displayName: 'Two',
            totalTaskCount: 1,
            tasks: [_card('task-3', version: 4)],
          ),
        ],
      ),
    );
    commands.selectAllLoaded();
    expect(context.ready.selectedTaskIds, {'task-3'});
    when(
      () => tasks.bulkUpdateTaskSelection(
        workspaceId: 'workspace',
        projectId: 'project',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer(
      (_) async =>
          const Right(BulkUpdateTaskSelectionResponse(updatedCount: 1)),
    );
    await commands.bulkClearDueDate();
    final payload =
        verify(
              () => tasks.bulkUpdateTaskSelection(
                workspaceId: 'workspace',
                projectId: 'project',
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as BulkUpdateTaskSelectionPayload;
    expect(payload.tasks!.single.taskId, 'task-3');
    expect(payload.tasks!.single.expectedVersion, 4);
    expect(context.reloads, 1);
  });
  test(
    'same-scope realtime resync does not discard successful bulk completion',
    () async {
      final pending =
          Completer<Either<ApiError, BulkUpdateKanbanTasksResponse>>();
      when(
        () => board.bulkUpdate(
          workspaceId: 'workspace',
          projectId: 'project',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) => pending.future);
      final saving = commands.bulkUpdatePriority(TaskPriority.high);
      context.revision++;
      pending.complete(
        const Right(BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 1)),
      );
      await saving;
      expect(context.ready.selectedTaskIds, isEmpty);
      expect(context.reloads, 1);
      expect(context.ready.isBulkSaving, isFalse);
    },
  );
}
