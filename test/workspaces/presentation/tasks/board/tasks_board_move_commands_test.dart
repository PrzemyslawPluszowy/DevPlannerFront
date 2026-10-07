import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_move_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _BoardRepo extends Mock implements KanbanRepository {}

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

  @override
  void publish(TasksBoardState state) => currentState = state;
  @override
  Future<void> reloadBoard({bool force = false}) =>
      reloadActiveBoard(force: force);
  @override
  Future<void> reloadActiveBoard({bool force = false}) async {
    revision++;
    reloads++;
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
      const KanbanColumnResponse(
        status: ProjectTaskStatus.inProgress,
        displayName: 'Doing',
        color: '#123456',
        totalTaskCount: 0,
        isWipLimitExceeded: false,
        tasks: [],
      ),
    ],
  ),
  connectionState: WorkspaceSignalRConnectionState.connected,
  presence: [],
  selectedTaskIds: {'task-1'},
);
void main() {
  late _Context context;
  late _BoardRepo repository;
  late TasksBoardMoveCommands commands;
  late Completer<Either<ApiError, MoveKanbanTaskResponse>> pending;
  const error = ApiError(
    type: ApiErrorType.validation,
    message: 'Validation',
    statusCode: 400,
    apiCode: 'kanban.invalid_move',
    traceId: 'trace',
  );
  setUpAll(() {
    registerFallbackValue(
      const MoveKanbanTaskPayload(
        targetStatus: ProjectTaskStatus.todo,
        expectedVersion: 1,
      ),
    );
  });
  setUp(() {
    context = _Context(_state());
    repository = _BoardRepo();
    pending = Completer<Either<ApiError, MoveKanbanTaskResponse>>();
    commands = TasksBoardMoveCommands(
      context: context,
      repository: repository,
      scopeRevision: () => context.scopeRevision,
      canMoveTaskTo: ({required task, required targetColumn}) => true,
    );
    when(
      () => repository.moveTask(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => pending.future);
  });
  Future<void> move({bool sameColumn = false}) => commands.move(
    task: _card('task-1'),
    targetColumn: context.ready.board.columns[sameColumn ? 0 : 1],
    targetIndex: sameColumn ? 2 : 0,
  );
  test(
    'stale target handle uses current column cards instead of overwriting them',
    () async {
      final oldTarget = context.ready.board.columns.last;
      final board = context.ready.board;
      context.currentState = context.ready.copyWith(
        board: board.copyWith(
          columns: [
            board.columns.first,
            oldTarget.copyWith(
              totalTaskCount: 1,
              tasks: [
                _card('task-3').copyWith(status: ProjectTaskStatus.inProgress),
              ],
            ),
          ],
        ),
      );
      final operation = commands.move(
        task: _card('task-1'),
        targetColumn: oldTarget,
        targetIndex: 0,
      );
      expect(context.ready.board.columns.last.tasks.map((e) => e.id), [
        'task-1',
        'task-3',
      ]);
      pending.complete(const Left(error));
      await operation;
      expect(context.ready.board.columns.last.tasks.map((e) => e.id), [
        'task-3',
      ]);
      expect(context.ready.board.columns.last.totalTaskCount, 1);
    },
  );
  test('reverse parallel completion preserves shared column count', () async {
    final board = context.ready.board;
    context.currentState = context.ready.copyWith(
      board: board.copyWith(
        columns: [
          board.columns.first,
          board.columns.last.copyWith(
            totalTaskCount: 1,
            tasks: [
              _card('existing').copyWith(status: ProjectTaskStatus.inProgress),
            ],
          ),
        ],
      ),
    );
    final secondPending = Completer<Either<ApiError, MoveKanbanTaskResponse>>();
    when(
      () => repository.moveTask(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-2',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => secondPending.future);
    final first = move();
    // Both requests use the persisted neighbour, so either server order is valid.
    final second = commands.move(
      task: _card('task-2'),
      targetColumn: context.ready.board.columns.last,
      targetIndex: 2,
    );
    expect(context.ready.board.columns.last.totalTaskCount, 3);
    secondPending.complete(
      Right(
        MoveKanbanTaskResponse(
          task: _card(
            'task-2',
            version: 2,
          ).copyWith(status: ProjectTaskStatus.inProgress),
          targetColumnTaskCount: 2,
          isWipLimitExceeded: false,
        ),
      ),
    );
    await second;
    expect(context.ready.board.columns.last.totalTaskCount, 3);
    expect(context.ready.board.columns.last.tasks, hasLength(3));
    pending.complete(
      Right(
        MoveKanbanTaskResponse(
          task: _card(
            'task-1',
            version: 2,
          ).copyWith(status: ProjectTaskStatus.inProgress),
          targetColumnTaskCount: 3,
          isWipLimitExceeded: false,
        ),
      ),
    );
    await first;
    expect(context.ready.board.columns.last.totalTaskCount, 3);
    expect(context.ready.board.columns.first.totalTaskCount, 0);
    expect(context.ready.pendingTaskIds, isEmpty);
  });
  for (final secondSucceeds in [true, false]) {
    test(
      'parallel moves retain optimistic counts (second succeeds: $secondSucceeds)',
      () async {
        final secondPending =
            Completer<Either<ApiError, MoveKanbanTaskResponse>>();
        when(
          () => repository.moveTask(
            workspaceId: 'workspace',
            projectId: 'project',
            taskId: 'task-2',
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) => secondPending.future);
        final first = move();
        final second = commands.move(
          task: _card('task-2'),
          targetColumn: context.ready.board.columns.last,
          targetIndex: 1,
        );
        expect(context.ready.board.columns.last.totalTaskCount, 2);
        pending.complete(
          Right(
            MoveKanbanTaskResponse(
              task: _card(
                'task-1',
                version: 2,
              ).copyWith(status: ProjectTaskStatus.inProgress),
              targetColumnTaskCount: 1,
              isWipLimitExceeded: false,
            ),
          ),
        );
        await first;
        expect(context.ready.board.columns.last.tasks, hasLength(2));
        expect(context.ready.board.columns.last.totalTaskCount, 2);
        secondPending.complete(
          secondSucceeds
              ? Right(
                  MoveKanbanTaskResponse(
                    task: _card(
                      'task-2',
                      version: 2,
                    ).copyWith(status: ProjectTaskStatus.inProgress),
                    targetColumnTaskCount: 2,
                    isWipLimitExceeded: false,
                  ),
                )
              : const Left(error),
        );
        await second;
        expect(
          context.ready.board.columns.last.totalTaskCount,
          secondSucceeds ? 2 : 1,
        );
        expect(
          context.ready.board.columns.first.totalTaskCount,
          secondSucceeds ? 0 : 1,
        );
        expect(context.ready.pendingTaskIds, isEmpty);
      },
    );
  }
  test('same-task pending guard prevents a second drag', () async {
    final first = move();
    await move();
    verify(
      () => repository.moveTask(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task-1',
        payload: any(named: 'payload'),
      ),
    ).called(1);
    pending.complete(const Left(error));
    await first;
    expect(context.ready.pendingTaskIds, isEmpty);
  });
  test(
    'delayed 400 restores same-column order and preserves typed error',
    () async {
      final operation = move(sameColumn: true);
      expect(context.ready.board.columns.first.tasks.map((e) => e.id), [
        'task-2',
        'task-1',
      ]);
      pending.complete(const Left(error));
      await operation;
      expect(context.ready.board.columns.first.tasks.map((e) => e.id), [
        'task-1',
        'task-2',
      ]);
      expect(context.ready.board.columns.first.totalTaskCount, 2);
      expect(context.ready.pendingTaskIds, isEmpty);
      expect(context.ready.error?.apiError, error);
      expect(context.ready.error?.traceId, 'trace');
    },
  );
  test('delayed failure never overwrites newer realtime card', () async {
    final operation = move();
    final board = context.ready.board;
    context.currentState = context.ready.copyWith(
      board: board.copyWith(
        columns: [
          board.columns.first,
          board.columns.last.copyWith(
            tasks: [
              _card('task-1', version: 5).copyWith(
                status: ProjectTaskStatus.inProgress,
                title: 'Realtime title',
              ),
            ],
          ),
        ],
      ),
    );
    pending.complete(const Left(error));
    await operation;
    final card = context.ready.board.columns.last.tasks.single;
    expect(card.version, 5);
    expect(card.title, 'Realtime title');
    expect(context.ready.board.columns.first.tasks.map((e) => e.id), [
      'task-2',
    ]);
    expect(context.ready.pendingTaskIds, isEmpty);
  });
  test('filter-ready retains pending but stale response releases its own marker only', () async {
    final operation = move();
    final changed = context.ready.copyWith(
      filter: const KanbanBoardFilter(priority: TaskPriority.low),
      selectedTaskIds: {'task-2'},
    );
    context.currentState = changed;
    context.scopeRevision++;
    expect(context.ready.pendingTaskIds, contains('task-1'));
    pending.complete(const Left(error));
    await operation;
    expect(context.ready.board, same(changed.board));
    expect(context.ready.filter, changed.filter);
    expect(context.ready.selectedTaskIds, {'task-2'});
    expect(context.ready.pendingTaskIds, isEmpty);
    expect(context.ready.pendingMoveOwners, isEmpty);
    expect(context.ready.error, isNull);
  });
  test('old response cannot release a newer owner pending marker', () async {
    final operation = move();
    final newerOwner = Object();
    context.currentState = context.ready.copyWith(
      pendingMoveOwners: {'task-1': newerOwner},
    );
    pending.complete(const Left(error));
    await operation;
    expect(context.ready.pendingTaskIds, contains('task-1'));
    expect(context.ready.pendingMoveOwners['task-1'], same(newerOwner));
  });
  test('leave and return scope ignores old failure', () async {
    final operation = move();
    context.scopeRevision += 2;
    final next = _state().copyWith(selectedTaskIds: {'task-2'});
    context.currentState = next;
    pending.complete(const Left(error));
    await operation;
    expect(context.currentState, same(next));
  });
  test('closed scope ignores delayed completion', () async {
    final operation = move();
    final optimistic = context.currentState;
    context.isBoardClosed = true;
    pending.complete(const Left(error));
    await operation;
    expect(context.currentState, same(optimistic));
  });
  test(
    'unexpected exception restores card and releases pending with feedback',
    () async {
      final operation = move();
      pending.completeError(StateError('Transport failed'));
      await operation;
      expect(context.ready.board.columns.first.tasks.map((e) => e.id), [
        'task-1',
        'task-2',
      ]);
      expect(context.ready.board.columns.last.tasks, isEmpty);
      expect(context.ready.pendingTaskIds, isEmpty);
      expect(context.ready.failedTaskIds, contains('task-1'));
      expect(context.ready.error?.code, 'tasks.bulk.save_failed');
    },
  );
}
