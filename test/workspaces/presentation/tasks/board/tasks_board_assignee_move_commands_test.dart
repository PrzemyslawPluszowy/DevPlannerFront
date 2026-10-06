import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_move_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements KanbanRepository {}

class _Context implements TasksBoardCommandContext {
  _Context() : currentState = _state();
  @override
  String get workspaceId => 'workspace';
  @override
  String get projectId => 'project';
  @override
  TasksBoardState currentState;
  @override
  bool isBoardClosed = false;
  int scope = 0;
  int reloads = 0;
  TasksBoardReady get ready => currentState as TasksBoardReady;
  @override
  void publish(TasksBoardState state) => currentState = state;
  @override
  Future<void> reloadBoard({bool force = false}) async => reloads++;
  @override
  Future<void> reloadActiveBoard({bool force = false}) =>
      reloadBoard(force: force);
}

KanbanTaskCardResponse _card({int version = 4}) => KanbanTaskCardResponse(
  id: 'task',
  number: 1,
  taskCode: 'TASK-1',
  title: 'Task',
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  position: 1,
  checklistTotal: 0,
  checklistCompleted: 0,
  attachmentCount: 0,
  version: version,
  primaryAssigneeUserId: 'a',
  assigneeUserIds: const ['a'],
);

TasksBoardReady _state() => TasksBoardReady(
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
        totalTaskCount: 1,
        isWipLimitExceeded: false,
        tasks: [_card()],
      ),
    ],
  ),
  connectionState: WorkspaceSignalRConnectionState.disconnected,
  presence: const [],
  grouping: TasksBoardGrouping.assignee,
  assigneeBoard: AssigneeKanbanBoardResponse(
    projectId: 'project',
    grouping: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    visibleCardFields: [],
    defaultCardDensity: KanbanCardDensity.comfortable,
    groups: [
      AssigneeKanbanGroupResponse(
        assigneeUserId: 'a',
        displayName: 'A',
        totalTaskCount: 1,
        tasks: [_card()],
      ),
      const AssigneeKanbanGroupResponse(
        assigneeUserId: 'b',
        displayName: 'B',
        totalTaskCount: 0,
        tasks: [],
      ),
      const AssigneeKanbanGroupResponse(
        displayName: 'None',
        totalTaskCount: 0,
        tasks: [],
      ),
    ],
  ),
);

ChangeKanbanPrimaryAssigneeResponse _response({
  int version = 5,
  int sourceCount = 0,
  int targetCount = 1,
}) => ChangeKanbanPrimaryAssigneeResponse(
  task: _card(version: version)
      .copyWith(primaryAssigneeUserId: 'b', assigneeUserIds: ['a', 'b']),
  previousAssigneeUserId: 'a',
  targetAssigneeUserId: 'b',
  previousGroupTaskCount: sourceCount,
  targetGroupTaskCount: targetCount,
);

void main() {
  late _Repository repository;
  late _Context context;
  late TasksBoardAssigneeMoveCommands commands;
  late Completer<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>> pending;
  setUp(() {
    repository = _Repository();
    context = _Context();
    pending =
        Completer<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>>();
    when(
      () => repository.changePrimaryAssignee(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
        taskId: any(named: 'taskId'),
        targetUserId: any(named: 'targetUserId'),
        expectedVersion: any(named: 'expectedVersion'),
      ),
    ).thenAnswer((_) => pending.future);
    commands = TasksBoardAssigneeMoveCommands(
      context: context,
      repository: repository,
      scopeRevision: () => context.scope,
      reloadAfterSettingsConflict: () async {
        context.reloads++;
      },
    );
  });

  Future<bool> start() =>
      commands.move(task: _card(version: 1), targetUserId: 'b');
  void expectReleased() {
    expect(context.ready.pendingTaskIds, isEmpty);
    expect(context.ready.pendingMoveOwners, isEmpty);
  }

  void newerActive({int version = 9}) {
    final board = context.ready.assigneeBoard!;
    context.publish(
      context.ready.copyWith(
        assigneeBoard: board.copyWith(
          groups: [
            for (final group in board.groups)
              group.copyWith(
                tasks: [
                  for (final card in group.tasks)
                    card.copyWith(version: version),
                ],
              ),
          ],
        ),
      ),
    );
  }

  test('status grouping with old assignee cache cannot move', () async {
    context.publish(
      context.ready.copyWith(grouping: TasksBoardGrouping.status),
    );
    expect(await start(), isFalse);
    verifyNever(
      () => repository.changePrimaryAssignee(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
        taskId: any(named: 'taskId'),
        targetUserId: any(named: 'targetUserId'),
        expectedVersion: any(named: 'expectedVersion'),
      ),
    );
  });

  test(
    'active presence reconciles newer inactive task version for request',
    () async {
      final board = context.ready.board;
      context.publish(
        context.ready.copyWith(
          board: board.copyWith(
            columns: [
              board.columns.single.copyWith(tasks: [_card(version: 6)]),
            ],
          ),
        ),
      );
      final operation = start();
      verify(
        () => repository.changePrimaryAssignee(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task',
          targetUserId: 'b',
          expectedVersion: 6,
        ),
      ).called(1);
      pending.complete(Right(_response(version: 7)));
      expect(await operation, isTrue);
      expect(context.ready.assigneeBoard!.groups[1].tasks.single.version, 7);
      expectReleased();
    },
  );

  test(
    'canonical same-version GET is moved on success without stale counts',
    () async {
      final operation = start();
      final canonical = _state().assigneeBoard!;
      context.publish(
        context.ready.copyWith(
          assigneeBoard: canonical.copyWith(
            groups: [
              canonical.groups[0].copyWith(
                totalTaskCount: 22,
                tasks: [_card().copyWith(isPinned: true)],
              ),
              canonical.groups[1].copyWith(totalTaskCount: 33),
              canonical.groups[2],
            ],
          ),
        ),
      );
      pending.complete(Right(_response(sourceCount: 100, targetCount: 200)));
      expect(await operation, isTrue);
      final groups = context.ready.assigneeBoard!.groups;
      expect(groups[0].tasks, isEmpty);
      expect(groups[0].totalTaskCount, 21);
      expect(groups[1].tasks.single.version, 5);
      expect(groups[1].tasks.single.primaryAssigneeUserId, 'b');
      expect(groups[1].tasks.single.isPinned, isTrue);
      expect(groups[1].totalTaskCount, 34);
      expect(context.ready.pendingTaskIds, isEmpty);
    },
  );

  test('closed bulk and pending ingress send no request', () async {
    context.publish(context.ready.copyWith(isBulkSaving: true));
    expect(await start(), isFalse);
    context.publish(
      context.ready.copyWith(isBulkSaving: false, pendingTaskIds: {'task'}),
    );
    expect(await commands.move(task: _card(), targetUserId: 'a'), isFalse);
    context.publish(context.ready.copyWith(pendingTaskIds: {}));
    context.isBoardClosed = true;
    expect(await start(), isFalse);
    verifyZeroInteractions(repository);
  });

  test(
    'success uses current version and settles own owner with server counts',
    () async {
      final operation = start();
      expect(context.ready.pendingMoveOwners['task'], isNotNull);
      pending.complete(Right(_response(sourceCount: 10, targetCount: 20)));
      expect(await operation, isTrue);
      verify(
        () => repository.changePrimaryAssignee(
          workspaceId: 'workspace',
          projectId: 'project',
          taskId: 'task',
          targetUserId: 'b',
          expectedVersion: 4,
        ),
      ).called(1);
      expect(context.ready.assigneeBoard!.groups[1].tasks.single.version, 5);
      expect(context.ready.board.columns.single.tasks.single.version, 5);
      expect(
        context.ready.assigneeBoard!.groups.map(
          (group) => group.totalTaskCount,
        ),
        [10, 20, 0],
      );
      expectReleased();
    },
  );

  test(
    'newer other-card snapshot counts are not overwritten by success',
    () async {
      final operation = start();
      final board = context.ready.assigneeBoard!;
      context.publish(
        context.ready.copyWith(
          assigneeBoard: board.copyWith(
            groups: [
              board.groups[0].copyWith(totalTaskCount: 22),
              board.groups[1].copyWith(totalTaskCount: 33),
              board.groups[2],
            ],
          ),
        ),
      );
      pending.complete(Right(_response(sourceCount: 10, targetCount: 20)));
      expect(await operation, isTrue);
      expect(
        context.ready.assigneeBoard!.groups.map(
          (group) => group.totalTaskCount,
        ),
        [22, 33, 0],
      );
      expectReleased();
    },
  );

  test('filtered success keeps optimistic counts without applying full-project counts twice', () async {
    context.publish(
      context.ready.copyWith(
        filter: const KanbanBoardFilter(priority: TaskPriority.high),
      ),
    );
    final operation = start();
    pending.complete(Right(_response(sourceCount: 100, targetCount: 200)));
    expect(await operation, isTrue);
    expect(
      context.ready.assigneeBoard!.groups.map((group) => group.totalTaskCount),
      [0, 1, 0],
    );
    expectReleased();
  });

  for (final success in [true, false]) {
    test(
      'newer task version survives delayed ${success ? 'success' : 'failure'}',
      () async {
        final operation = start();
        newerActive();
        pending.complete(
          success
              ? Right(_response())
              : const Left(
                  ApiError(type: ApiErrorType.server, message: 'Rejected'),
                ),
        );
        await operation;
        expect(context.ready.assigneeBoard!.groups[1].tasks.single.version, 9);
        expect(context.ready.assigneeBoard!.groups[0].tasks, isEmpty);
        expectReleased();
      },
    );
    test(
      'removed active card is not resurrected by delayed ${success ? 'success' : 'failure'}',
      () async {
        final operation = start();
        final board = context.ready.assigneeBoard!;
        context.publish(
          context.ready.copyWith(
            assigneeBoard: board.copyWith(
              groups: [
                for (final group in board.groups)
                  group.copyWith(tasks: [], totalTaskCount: 0),
              ],
            ),
          ),
        );
        pending.complete(
          success
              ? Right(_response())
              : const Left(
                  ApiError(type: ApiErrorType.server, message: 'Rejected'),
                ),
        );
        await operation;
        expect(
          context.ready.assigneeBoard!.groups.expand((group) => group.tasks),
          isEmpty,
        );
        expectReleased();
      },
    );
  }

  test('rollback preserves newer same-version personal flags and changes counts only on real membership', () async {
    final operation = start();
    final original = _state().assigneeBoard!;
    context.publish(
      context.ready.copyWith(
        assigneeBoard: original.copyWith(
          groups: [
            original.groups[0].copyWith(
              tasks: [_card().copyWith(isPinned: true)],
            ),
            original.groups[1],
            original.groups[2],
          ],
        ),
      ),
    );
    pending.complete(
      const Left(ApiError(type: ApiErrorType.server, message: 'Rejected')),
    );
    expect(await operation, isFalse);
    expect(
      context.ready.assigneeBoard!.groups.map((group) => group.totalTaskCount),
      [1, 0, 0],
    );
    expect(
      context.ready.assigneeBoard!.groups[0].tasks.single.isPinned,
      isTrue,
    );
    expectReleased();
  });

  test('unexpected exception rolls back and always releases pending', () async {
    final operation = start();
    pending.completeError(StateError('Unexpected'));
    expect(await operation, isFalse);
    expect(context.ready.assigneeBoard!.groups[0].tasks.single.id, 'task');
    expect(context.ready.error?.code, 'tasks.bulk.save_failed');
    expectReleased();
  });

  test(
    'scope leave and return suppresses old completion but releases own marker',
    () async {
      final operation = start();
      context.scope += 2;
      newerActive();
      pending.complete(Right(_response()));
      expect(await operation, isFalse);
      expect(context.ready.assigneeBoard!.groups[1].tasks.single.version, 9);
      expectReleased();
    },
  );

  test('old completion cannot release a newer operation owner', () async {
    final operation = start();
    final newer = Object();
    context.publish(context.ready.copyWith(pendingMoveOwners: {'task': newer}));
    pending.complete(Right(_response()));
    expect(await operation, isFalse);
    expect(context.ready.pendingTaskIds, {'task'});
    expect(identical(context.ready.pendingMoveOwners['task'], newer), isTrue);
  });
}
