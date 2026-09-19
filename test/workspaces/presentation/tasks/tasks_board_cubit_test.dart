import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_error_messages.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';
import 'package:flutter_test/flutter_test.dart';

final class _KanbanRepository implements KanbanRepository {
  _KanbanRepository(this.board);

  final KanbanBoardResponse board;
  int boardCalls = 0;
  final List<KanbanBoardFilter> boardFilters = [];
  final List<KanbanColumnQuery> systemColumnQueries = [];
  Either<ApiError, KanbanBoardResponse>? boardResult;
  MoveKanbanTaskPayload? movePayload;
  Either<ApiError, MoveKanbanTaskResponse>? moveResult;
  BulkMoveKanbanTasksPayload? bulkMovePayload;
  BulkUpdateKanbanTasksPayload? bulkUpdatePayload;
  UserKanbanPreferenceResponse preference = _preference();
  UpdateUserKanbanPreferencePayload? preferencePayload;
  final List<UpdateUserKanbanPreferencePayload> preferencePayloads = [];
  final List<Either<ApiError, UserKanbanPreferenceResponse>>
  preferenceUpdateResults = [];
  int preferenceGetCalls = 0;
  ApiError? preferenceGetError;
  Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>?
  systemColumnResult;

  @override
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) async {
    boardCalls++;
    boardFilters.add(filter);
    return boardResult ?? Right(board);
  }

  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  Function()?
  systemColumnLoader;
  Map<String, Either<ApiError, MoveKanbanTaskResponse>> moveResultsByTaskId =
      {};

  @override
  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getSystemColumn({
    required String workspaceId,
    required String projectId,
    required ProjectTaskStatus status,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  }) async {
    systemColumnQueries.add(query);
    if (systemColumnLoader != null) {
      return systemColumnLoader!();
    }
    return systemColumnResult ??
        Right(CursorPageResponse(items: [_card(id: 'task-2', version: 1)]));
  }

  @override
  Future<Either<ApiError, MoveKanbanTaskResponse>> moveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required MoveKanbanTaskPayload payload,
  }) async {
    movePayload = payload;
    if (moveResultsByTaskId.containsKey(taskId)) {
      return moveResultsByTaskId[taskId]!;
    }
    return moveResult ??
        Right(
          MoveKanbanTaskResponse(
            task: _card(
              id: taskId,
              version: payload.expectedVersion + 1,
              status: payload.targetStatus,
            ),
            targetColumnTaskCount: 1,
            isWipLimitExceeded: false,
          ),
        );
  }

  @override
  Future<Either<ApiError, BulkMoveKanbanTasksResponse>> bulkMove({
    required String workspaceId,
    required String projectId,
    required BulkMoveKanbanTasksPayload payload,
  }) async {
    bulkMovePayload = payload;
    return Right(
      BulkMoveKanbanTasksResponse(
        tasks: [
          for (final item in payload.tasks)
            _card(
              id: item.taskId,
              version: item.expectedVersion + 1,
              status: payload.targetStatus,
            ),
        ],
        targetColumnTaskCount: payload.tasks.length,
        isWipLimitExceeded: false,
      ),
    );
  }

  @override
  Future<Either<ApiError, BulkUpdateKanbanTasksResponse>> bulkUpdate({
    required String workspaceId,
    required String projectId,
    required BulkUpdateKanbanTasksPayload payload,
  }) async {
    bulkUpdatePayload = payload;
    return const Right(
      BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 1),
    );
  }

  @override
  Future<Either<ApiError, UserKanbanPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) async {
    preferenceGetCalls++;
    if (preferenceGetError case final error?) return Left(error);
    return Right(preference);
  }

  @override
  Future<Either<ApiError, UserKanbanPreferenceResponse>> updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateUserKanbanPreferencePayload payload,
  }) async {
    preferencePayload = payload;
    preferencePayloads.add(payload);
    if (preferenceUpdateResults.isNotEmpty) {
      final result = preferenceUpdateResults.removeAt(0);
      if (result.isLeft()) return result;
    }
    preference = preference.copyWith(
      collapsedColumns: payload.collapsedColumns,
      collapsedCustomStatusIds: payload.collapsedCustomStatusIds ?? const [],
      quickFilter: payload.quickFilter,
      version: preference.version + 1,
    );
    return Right(preference);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _Realtime implements TaskProjectRealtime {
  final updatesController =
      StreamController<TaskProjectRealtimeUpdate>.broadcast();
  final statesController =
      StreamController<WorkspaceSignalRConnectionState>.broadcast();

  @override
  Stream<TaskProjectRealtimeUpdate> get updates => updatesController.stream;

  @override
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      statesController.stream;

  @override
  Stream<WorkspaceScopedRealtimeError> get errors => const Stream.empty();

  @override
  Future<void> start({
    required String workspaceId,
    required String projectId,
  }) async => statesController.add(WorkspaceSignalRConnectionState.connected);

  @override
  Future<void> dispose() async {
    await updatesController.close();
    await statesController.close();
  }
}

final class _TaskCollaborationRepository
    implements TaskCollaborationRepository {
  int? followExpectedVersion;
  bool? pinned;

  @override
  Future<Either<ApiError, Unit>> updatePinned({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required bool isPinned,
  }) async {
    pinned = isPinned;
    return const Right(unit);
  }

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  follow({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) async {
    followExpectedVersion = expectedVersion;
    return Right(
      TaskMutationResponse(
        taskId: taskId,
        taskVersion: expectedVersion + 1,
        taskUpdatedAtUtc: DateTime.utc(2026, 8, 31),
        data: const TaskMutationAcknowledgementResponse(changed: true),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _TasksRepository implements TasksRepository {
  QuickCreateProjectTaskPayload? createPayload;

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  }) async {
    createPayload = payload;
    return const Left(
      ApiError(type: ApiErrorType.validation, message: 'Walidacja'),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _WorkflowRepository implements TaskWorkflowRepository {
  const _WorkflowRepository(this.workflow);

  final ProjectTaskWorkflowResponse workflow;

  @override
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> getWorkflow({
    required String workspaceId,
    required String projectId,
  }) async => Right(workflow);

  @override
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> updateWorkflow({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskWorkflowPayload payload,
  }) => throw UnimplementedError();
}

KanbanTaskCardResponse _card({
  required String id,
  required int version,
  ProjectTaskStatus status = ProjectTaskStatus.todo,
}) => KanbanTaskCardResponse(
  id: id,
  number: 1,
  taskCode: 'TASK-1',
  title: 'Pierwsze zadanie',
  status: status,
  priority: TaskPriority.normal,
  position: 100,
  checklistTotal: 0,
  checklistCompleted: 0,
  attachmentCount: 0,
  version: version,
);

KanbanBoardResponse _board() => KanbanBoardResponse(
  projectId: 'project-1',
  swimlaneMode: KanbanSwimlaneMode.none,
  settingsVersion: 0,
  hiddenColumns: const [],
  visibleCardFields: const [],
  defaultCardDensity: KanbanCardDensity.comfortable,
  columns: [
    KanbanColumnResponse(
      status: ProjectTaskStatus.todo,
      displayName: 'Do zrobienia',
      color: '#6C5CE7',
      totalTaskCount: 2,
      isWipLimitExceeded: false,
      tasks: [_card(id: 'task-1', version: 1)],
      nextCursor: 'next-page',
    ),
    const KanbanColumnResponse(
      status: ProjectTaskStatus.inProgress,
      displayName: 'W toku',
      color: '#0984E3',
      totalTaskCount: 0,
      isWipLimitExceeded: false,
      tasks: [],
    ),
  ],
);

KanbanBoardResponse _largeBoard() => _board().copyWith(
  columns: [
    for (var columnIndex = 0; columnIndex < 20; columnIndex++)
      KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        customStatusId: 'custom-status-$columnIndex',
        displayName: 'Etap ${columnIndex + 1}',
        color: '#6C5CE7',
        totalTaskCount: 50,
        isWipLimitExceeded: false,
        tasks: [
          for (var taskIndex = 0; taskIndex < 50; taskIndex++)
            _card(
              id: 'large-task-${columnIndex * 50 + taskIndex}',
              version: 1,
            ),
        ],
      ),
  ],
);

UserKanbanPreferenceResponse _preference() =>
    const UserKanbanPreferenceResponse(
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      userId: 'user-1',
      collapsedColumns: [],
      collapsedCustomStatusIds: [],
      quickFilter: KanbanQuickFilter.all,
      version: 1,
    );

void main() {
  test('przypina i obserwuje kartę lokalnie bez odczytu boarda', () async {
    final repository = _KanbanRepository(_board());
    final collaboration = _TaskCollaborationRepository();
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      collaborationRepository: collaboration,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(cubit.close);
    await cubit.load();
    final task =
        (cubit.state as TasksBoardReady).board.columns.first.tasks.single;

    expect(await cubit.togglePinned(task), isTrue);
    var updated =
        (cubit.state as TasksBoardReady).board.columns.first.tasks.single;
    expect(collaboration.pinned, isTrue);
    expect(updated.isPinned, isTrue);
    expect(repository.boardCalls, 1);

    expect(await cubit.toggleWatching(updated), isTrue);
    updated = (cubit.state as TasksBoardReady).board.columns.first.tasks.single;
    expect(collaboration.followExpectedVersion, 1);
    expect(updated.isWatchedByMe, isTrue);
    expect(updated.watcherCount, 1);
    expect(updated.version, 2);
    expect(repository.boardCalls, 1);
  });

  test(
    'podmienia cykliczność tylko lokalnej karty po zapisie edytora',
    () async {
      final repository = _KanbanRepository(_board());
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      addTearDown(cubit.close);
      await cubit.load();
      final task =
          (cubit.state as TasksBoardReady).board.columns.first.tasks.single;
      final recurrence = TaskRecurrenceResponse(
        id: 'rule-1',
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        sourceTaskId: task.id,
        mode: TaskRecurrenceMode.scheduled,
        frequency: TaskRecurrenceFrequency.weekly,
        interval: 2,
        timeZoneId: 'Europe/Warsaw',
        nextOccurrenceAtUtc: DateTime.utc(2026, 9, 8, 8),
        occurrenceStatus: ProjectTaskStatus.todo,
        skipIfPreviousOpen: true,
        isActive: true,
        createdAtUtc: DateTime.utc(2026, 9),
        updatedAtUtc: DateTime.utc(2026, 9, 1, 1),
        version: 4,
      );

      cubit.applyRecurrenceMutation(
        task,
        TaskMutationResponse(
          taskId: task.id,
          taskVersion: 2,
          taskUpdatedAtUtc: DateTime.utc(2026, 9, 1, 1),
          data: recurrence,
        ),
      );

      final updated =
          (cubit.state as TasksBoardReady).board.columns.first.tasks.single;
      expect(updated.version, 2);
      expect(updated.recurrence?.id, recurrence.id);
      expect(updated.recurrence?.interval, 2);
      expect(repository.boardCalls, 1);
    },
  );

  test('ładuje snapshot, presence i kolejną stronę jednej kolumny', () async {
    final repository = _KanbanRepository(_board());
    final realtime = _Realtime();
    final cubit = TasksBoardCubit(
      repository,
      realtime,
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );

    await cubit.start();
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<TasksBoardReady>());
    expect(
      (cubit.state as TasksBoardReady).connectionState,
      WorkspaceSignalRConnectionState.connected,
    );

    realtime.updatesController.add(
      TaskProjectPresence(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        users: const [
          TaskProjectPresenceUser(userId: 'user-1', connectionCount: 2),
        ],
        updatedAtUtc: DateTime.utc(2026, 8, 26),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(
      (cubit.state as TasksBoardReady).presence.single.userId,
      'user-1',
    );

    final column = (cubit.state as TasksBoardReady).board.columns.first;
    await cubit.loadMore(column);
    expect(
      (cubit.state as TasksBoardReady).board.columns.first.tasks,
      hasLength(2),
    );

    await cubit.close();
  });

  test(
    'zachowuje błąd kolejnej strony wyłącznie przy danej kolumnie',
    () async {
      final repository = _KanbanRepository(_board())
        ..systemColumnResult = const Left(
          ApiError(type: ApiErrorType.connection, message: 'Brak połączenia'),
        );
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      final column = (cubit.state as TasksBoardReady).board.columns.first;
      await cubit.loadMore(column);

      final ready = cubit.state as TasksBoardReady;
      expect(ready.loadingColumnKeys, isEmpty);
      expect(ready.columnLoadErrors['todo'], 'Brak połączenia');
      expect(ready.board.columns.first.tasks, hasLength(1));
      await cubit.close();
    },
  );

  test(
    'przy aktywnym filtrze nie wysyła ruchu do kolumny o ukrytej zawartości',
    () async {
      final repository = _KanbanRepository(_board());
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      await cubit.setFilterPriority(TaskPriority.high);

      final ready = cubit.state as TasksBoardReady;
      final card = ready.board.columns.first.tasks.single;
      final emptyColumn = ready.board.columns.last;
      expect(emptyColumn.tasks, isEmpty);

      await cubit.moveTask(
        task: card,
        targetColumn: emptyColumn,
        targetIndex: 0,
      );

      expect(
        repository.movePayload,
        isNull,
        reason: 'Backend waliduje pełną kolumnę, więc ruch bez sąsiadów musiałby wrócić 400',
      );
      final after = cubit.state as TasksBoardReady;
      expect(after.error?.code, TasksBoardErrorCodes.moveBlockedByFilter);
      expect(after.pendingTaskIds, isEmpty);

      await cubit.close();
    },
  );

  test(
    'bez filtra ruch do pustej kolumny nadal wysyła żądanie',
    () async {
      final repository = _KanbanRepository(_board());
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      final ready = cubit.state as TasksBoardReady;
      final card = ready.board.columns.first.tasks.single;
      final emptyColumn = ready.board.columns.last;

      await cubit.moveTask(
        task: card,
        targetColumn: emptyColumn,
        targetIndex: 0,
      );

      expect(repository.movePayload, isNotNull);
      expect(repository.movePayload?.previousTaskId, isNull);
      expect(repository.movePayload?.nextTaskId, isNull);

      await cubit.close();
    },
  );

  test(
    'konflikt wersji preferencji odświeża wersję i powtarza zapis raz',
    () async {
      final repository = _KanbanRepository(_board())
        ..preferenceUpdateResults.add(
          const Left(
            ApiError(
              type: ApiErrorType.conflict,
              message: 'Karta lub ustawienia zostały równolegle zmienione.',
              apiCode: 'kanban.version_conflict',
            ),
          ),
        );
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      await Future<void>.delayed(Duration.zero);
      // Ktoś zmienił preferencje równolegle: serwer ma już wersję 7.
      repository.preference = repository.preference.copyWith(version: 7);

      await cubit.setQuickFilter(KanbanQuickFilter.mine);

      expect(repository.preferencePayloads, hasLength(2));
      expect(repository.preferencePayloads.first.expectedVersion, 1);
      expect(
        repository.preferencePayloads.last.expectedVersion,
        7,
        reason: 'ponowienie używa wersji odczytanej po konflikcie',
      );
      final ready = cubit.state as TasksBoardReady;
      expect(ready.userPreference?.quickFilter, KanbanQuickFilter.mine);
      expect(ready.savingUserPreference, isFalse);
      expect(ready.error, isNull);

      await cubit.close();
    },
  );

  test(
    'ponowienie po konflikcie nie nadpisuje równoległej zmiany w innym polu',
    () async {
      final repository = _KanbanRepository(_board())
        ..preferenceUpdateResults.add(
          const Left(
            ApiError(
              type: ApiErrorType.conflict,
              message: 'Konflikt',
              apiCode: 'kanban.version_conflict',
            ),
          ),
        );
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      await Future<void>.delayed(Duration.zero);
      // Inna sesja ustawiła szybki filtr i podniosła wersję.
      repository.preference = repository.preference.copyWith(
        quickFilter: KanbanQuickFilter.blocked,
        version: 9,
      );

      final column = (cubit.state as TasksBoardReady).board.columns.first;
      await cubit.toggleColumnCollapsed(column);

      expect(repository.preferencePayloads, hasLength(2));
      final retry = repository.preferencePayloads.last;
      expect(retry.expectedVersion, 9);
      expect(retry.collapsedColumns, contains(ProjectTaskStatus.todo));
      expect(
        retry.quickFilter,
        KanbanQuickFilter.blocked,
        reason:
            'nieaktualny szybki filtr z lokalnego snapshotu nie może nadpisać zmiany z innej sesji',
      );
      final ready = cubit.state as TasksBoardReady;
      expect(ready.userPreference?.quickFilter, KanbanQuickFilter.blocked);
      expect(ready.userPreference?.collapsedColumns, [
        ProjectTaskStatus.todo,
      ]);

      await cubit.close();
    },
  );

  test('kliknięcie w trakcie zapisu preferencji nie jest ignorowane', () async {
    final repository = _KanbanRepository(_board());
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    await Future<void>.delayed(Duration.zero);

    final column = (cubit.state as TasksBoardReady).board.columns.first;
    // Dwie zmiany zgłoszone jedna po drugiej, bez czekania na pierwszą.
    final first = cubit.toggleColumnCollapsed(column);
    final second = cubit.setQuickFilter(KanbanQuickFilter.mine);
    await first;
    await second;

    expect(repository.preferencePayloads, hasLength(2));
    final last = repository.preferencePayloads.last;
    expect(last.collapsedColumns, contains(ProjectTaskStatus.todo));
    expect(last.quickFilter, KanbanQuickFilter.mine);
    final ready = cubit.state as TasksBoardReady;
    expect(ready.savingUserPreference, isFalse);
    expect(ready.userPreference?.quickFilter, KanbanQuickFilter.mine);
    expect(ready.userPreference?.collapsedColumns, [ProjectTaskStatus.todo]);

    await cubit.close();
  });

  test('resync tablicy nie ukrywa trwałego błędu ani nie cofa rewizji', () async {
    final repository = _KanbanRepository(_board())
      ..preferenceUpdateResults.addAll([
        const Left(
          ApiError(
            type: ApiErrorType.conflict,
            message: 'Konflikt',
            apiCode: 'kanban.version_conflict',
          ),
        ),
        const Left(
          ApiError(
            type: ApiErrorType.conflict,
            message: 'Konflikt',
            apiCode: 'kanban.version_conflict',
          ),
        ),
      ]);
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );

    await cubit.start();
    await Future<void>.delayed(Duration.zero);
    repository.preference = repository.preference.copyWith(version: 4);
    final column = (cubit.state as TasksBoardReady).board.columns.first;
    await cubit.toggleColumnCollapsed(column);

    final before = cubit.state as TasksBoardReady;
    expect(before.error?.code, TasksViewErrorCodes.versionConflict);
    expect(before.savingUserPreference, isFalse);
    repository.preferenceUpdateResults.clear();

    // Niezwiązany z ustawieniami odczyt tablicy, np. resync po realtime.
    await cubit.load(force: true);

    final after = cubit.state as TasksBoardReady;
    expect(
      after.error?.code,
      TasksViewErrorCodes.versionConflict,
      reason: 'odczyt tablicy nie może ukryć błędu niezapisanej preferencji',
    );
    expect(after.userPreference?.quickFilter, before.userPreference?.quickFilter);
    expect(
      after.taskDataRevision,
      before.taskDataRevision,
      reason: 'odczyt nie zeruje licznika zmian danych',
    );

    await cubit.close();
  });

  test('nieudany odczyt preferencji pokazuje trwały błąd i da się ponowić', () async {
    final repository = _KanbanRepository(_board())
      ..preferenceGetError = const ApiError(
        type: ApiErrorType.server,
        message: 'Błąd serwera',
      );
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );

    await cubit.start();
    await Future<void>.delayed(Duration.zero);

    final ready = cubit.state as TasksBoardReady;
    expect(ready.userPreference, isNull);
    expect(
      ready.error?.code,
      TasksViewErrorCodes.loadFailed,
      reason: 'bez preferencji kontrolki są wyłączone, więc użytkownik musi wiedzieć dlaczego',
    );

    repository.preferenceGetError = null;
    await cubit.retryFailedOperation();

    final afterRetry = cubit.state as TasksBoardReady;
    expect(afterRetry.userPreference, isNotNull);
    expect(afterRetry.error, isNull);

    await cubit.close();
  });

  test(
    'drugi konflikt przerywa ponawianie i zachowuje intencję użytkownika',
    () async {
      final repository = _KanbanRepository(_board())
        ..preferenceUpdateResults.addAll([
          const Left(
            ApiError(
              type: ApiErrorType.conflict,
              message: 'Konflikt',
              apiCode: 'kanban.version_conflict',
            ),
          ),
          const Left(
            ApiError(
              type: ApiErrorType.conflict,
              message: 'Konflikt',
              apiCode: 'kanban.version_conflict',
            ),
          ),
        ]);
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      await Future<void>.delayed(Duration.zero);
      repository.preference = repository.preference.copyWith(version: 4);

      await cubit.setQuickFilter(KanbanQuickFilter.blocked);

      expect(repository.preferenceGetCalls, greaterThanOrEqualTo(2));
      final ready = cubit.state as TasksBoardReady;
      expect(ready.savingUserPreference, isFalse);
      expect(ready.error?.code, TasksViewErrorCodes.versionConflict);
      expect(
        ready.error?.canRetry,
        isTrue,
        reason: 'intencja czeka w kolejce, więc ponowienie ma sens',
      );
      expect(
        ready.userPreference?.quickFilter,
        KanbanQuickFilter.blocked,
        reason:
            'użytkownik nadal widzi swoją zmianę — nie jest cicho porzucana, tylko niezapisana',
      );
      expect(
        ready.userPreference?.version,
        4,
        reason: 'stan przyjmuje wersję serwera, żeby ponowienie nie konfliktowało od nowa',
      );
      expect(
        ready.taskDataRevision,
        0,
        reason:
            'błąd ustawień nie zmienia danych zadań, więc Lista nie ma po czym się przeładowywać',
      );

      final writesBeforeRetry = repository.preferencePayloads.length;
      await cubit.retryFailedOperation();

      expect(repository.preferencePayloads.length, writesBeforeRetry + 1);
      expect(
        repository.preferencePayloads.last.quickFilter,
        KanbanQuickFilter.blocked,
        reason:
            '„Ponów” ponawia intencję użytkownika, a nie zapisuje odświeżonego stanu serwera',
      );
      expect(repository.preferencePayloads.last.expectedVersion, 4);
      final afterRetry = cubit.state as TasksBoardReady;
      expect(afterRetry.error, isNull);
      expect(afterRetry.userPreference?.quickFilter, KanbanQuickFilter.blocked);

      await cubit.close();
    },
  );

  test(
    'filtr tablicy jedzie do getBoard i do stron kolumn, a „Wyczyść wszystko” go zdejmuje',
    () async {
      final repository = _KanbanRepository(_board());
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      expect(repository.boardFilters.single, KanbanBoardFilter.none);

      await cubit.setFilterPriority(TaskPriority.high);
      await cubit.setFilterAssignee('user-9');
      await cubit.setFilterMilestone('milestone-3');

      expect(
        repository.boardCalls,
        4,
        reason: 'każda zmiana filtra odświeża tablicę',
      );
      final active = repository.boardFilters.last;
      expect(active.priority, TaskPriority.high);
      expect(active.assigneeUserId, 'user-9');
      expect(active.milestoneId, 'milestone-3');
      expect(active.activeCount, 3);
      expect((cubit.state as TasksBoardReady).filter, active);
      expect((cubit.state as TasksBoardReady).loadingFilter, isFalse);

      // Doładowanie kolumny musi nieść ten sam filtr co licznik kolumny.
      final column = (cubit.state as TasksBoardReady).board.columns.first;
      await cubit.loadMore(column);

      final columnQuery = repository.systemColumnQueries.last;
      expect(columnQuery.cursor, 'next-page');
      expect(columnQuery.priority, TaskPriority.high);
      expect(columnQuery.assigneeUserId, 'user-9');
      expect(columnQuery.milestoneId, 'milestone-3');

      await cubit.clearFilters();

      expect(repository.boardFilters.last, KanbanBoardFilter.none);
      expect((cubit.state as TasksBoardReady).filter.isActive, isFalse);

      await cubit.close();
    },
  );

  test(
    'ustawienie tego samego filtra nie powoduje zbędnego odczytu tablicy',
    () async {
      final repository = _KanbanRepository(_board());
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      final callsAfterStart = repository.boardCalls;

      await cubit.setFilterPriority(TaskPriority.high);
      await cubit.setFilterPriority(TaskPriority.high);

      expect(repository.boardCalls, callsAfterStart + 1);
      expect(
        (cubit.state as TasksBoardReady).filter.priority,
        TaskPriority.high,
      );

      await cubit.close();
    },
  );

  test(
    'odrzucenie filtra przez Backend zostawia stan błędu, a nie pustą tablicę',
    () async {
      final repository = _KanbanRepository(_board())
        ..boardResult = const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Filtr jest nieprawidłowy',
          ),
        );
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      await cubit.setFilterMilestone('milestone-blad');

      expect(cubit.state, isA<TasksBoardFailure>());
      expect(
        (cubit.state as TasksBoardFailure).message,
        'Filtr jest nieprawidłowy',
      );

      // Filtr przeżywa nieudany odczyt, więc ponowienie nie wraca po cichu do
      // pełnego projektu.
      repository.boardResult = null;
      await cubit.reloadBoard(force: true);

      expect(repository.boardFilters.last.milestoneId, 'milestone-blad');
      expect(
        (cubit.state as TasksBoardReady).filter.milestoneId,
        'milestone-blad',
      );

      await cubit.close();
    },
  );

  test(
    'resync po status realtime zachowuje jego rewizję dla widoku listy',
    () async {
      final repository = _KanbanRepository(_board());
      final realtime = _Realtime();
      final cubit = TasksBoardCubit(
        repository,
        realtime,
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();
      realtime.updatesController.add(
        TaskRealtimeMutation(
          eventId: 'status-event-1',
          type: TaskRealtimeMutationType.statusChanged,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: 'task-1',
          number: 1,
          key: 'TASK-1',
          version: 2,
          occurredAtUtc: DateTime.utc(2026, 8, 30),
          status: ProjectTaskStatus.inProgress,
          isReplay: false,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect((cubit.state as TasksBoardReady).realtimeRevision, 1);

      await Future<void>.delayed(const Duration(milliseconds: 2200));

      final state = cubit.state as TasksBoardReady;
      expect(repository.boardCalls, greaterThanOrEqualTo(2));
      expect(state.realtimeRevision, 1);
      expect(state.latestRealtimeMutation?.eventId, 'status-event-1');
      await cubit.close();
      await realtime.dispose();
    },
  );

  test('mapuje odmowę dostępu do jawnego stanu tablicy', () async {
    final repository = _KanbanRepository(_board())
      ..boardResult = const Left(
        ApiError(type: ApiErrorType.forbidden, message: 'Brak dostępu'),
      );
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );

    await cubit.load();

    final failure = cubit.state as TasksBoardFailure;
    expect(failure.kind, TasksBoardFailureKind.forbidden);
    expect(failure.message, 'Brak dostępu');
    await cubit.close();
  });

  test('przenosi kartę optymistycznie i zapisuje wersję odpowiedzi', () async {
    final repository = _KanbanRepository(_board());
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();

    final ready = cubit.state as TasksBoardReady;
    await cubit.moveTask(
      task: ready.board.columns.first.tasks.first,
      targetColumn: ready.board.columns.last,
      targetIndex: 0,
    );

    final moved = cubit.state as TasksBoardReady;
    expect(moved.board.columns.first.tasks, isEmpty);
    expect(moved.board.columns.first.totalTaskCount, 1);
    expect(moved.board.columns.last.tasks.single.id, 'task-1');
    expect(moved.board.columns.last.tasks.single.version, 2);
    expect(repository.movePayload?.targetStatus, ProjectTaskStatus.inProgress);
    expect(repository.movePayload?.expectedVersion, 1);
    expect(repository.movePayload?.previousTaskId, isNull);
    expect(repository.movePayload?.nextTaskId, isNull);

    await cubit.close();
  });

  test('koryguje indeks dropu przy sortowaniu w tej samej kolumnie', () async {
    final board = _board().copyWith(
      columns: [
        _board().columns.first.copyWith(
          tasks: [
            _card(id: 'task-1', version: 1),
            _card(id: 'task-2', version: 1),
            _card(id: 'task-3', version: 1),
          ],
        ),
      ],
    );
    final repository = _KanbanRepository(board);
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    final column = (cubit.state as TasksBoardReady).board.columns.single;

    await cubit.moveTask(
      task: column.tasks.first,
      targetColumn: column,
      targetIndex: 3,
    );

    expect(repository.movePayload?.previousTaskId, 'task-3');
    expect(repository.movePayload?.nextTaskId, isNull);

    await cubit.close();
  });

  test('przy błędzie przywraca tablicę sprzed optimistic move', () async {
    final repository = _KanbanRepository(_board())
      ..moveResult = const Left(
        ApiError(type: ApiErrorType.conflict, message: 'Konflikt wersji'),
      );
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    final original = (cubit.state as TasksBoardReady).board;

    await cubit.moveTask(
      task: original.columns.first.tasks.first,
      targetColumn: original.columns.last,
      targetIndex: 0,
    );

    final rolledBack = cubit.state as TasksBoardReady;
    expect(rolledBack.board, original);
    expect(rolledBack.error?.code, 'Konflikt wersji');
    expect(
      rolledBack.taskDataRevision,
      0,
      reason:
          'nieudany ruch nie zmienił danych zadań, więc widoki listowe nie mają po czym się przeładowywać',
    );

    await cubit.close();
  });

  test('zapisuje osobiste zwinięcie kolumny z wersją preferencji', () async {
    final repository = _KanbanRepository(_board());
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    await Future<void>.delayed(Duration.zero);

    final column = (cubit.state as TasksBoardReady).board.columns.first;
    await cubit.toggleColumnCollapsed(column);

    final preference = (cubit.state as TasksBoardReady).userPreference;
    expect(preference?.collapsedColumns, [ProjectTaskStatus.todo]);
    expect(repository.preferencePayload?.expectedVersion, 1);
    expect(repository.preferencePayload?.collapsedColumns, [
      ProjectTaskStatus.todo,
    ]);

    await cubit.close();
  });

  test(
    'zmienia szybki filtr, zachowuje zwinięte kolumny i odświeża snapshot',
    () async {
      final repository = _KanbanRepository(_board());
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();
      await Future<void>.delayed(Duration.zero);
      final beforeRefresh = repository.boardCalls;

      await cubit.setQuickFilter(KanbanQuickFilter.mine);

      final ready = cubit.state as TasksBoardReady;
      expect(ready.userPreference?.quickFilter, KanbanQuickFilter.mine);
      expect(repository.preferencePayload?.quickFilter, KanbanQuickFilter.mine);
      expect(
        repository.preferencePayload?.collapsedColumns,
        repository.preference.collapsedColumns,
      );
      expect(repository.boardCalls, beforeRefresh + 1);

      await cubit.close();
    },
  );

  test('quick create używa statusu systemowej kolumny', () async {
    final repository = _KanbanRepository(_board());
    final tasksRepository = _TasksRepository();
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      tasksRepository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();

    await cubit.createQuickTask(
      column: (cubit.state as TasksBoardReady).board.columns.first,
      title: '  Nowy task  ',
    );

    expect(tasksRepository.createPayload?.title, 'Nowy task');
    expect(tasksRepository.createPayload?.targetStatus, ProjectTaskStatus.todo);
    expect(tasksRepository.createPayload?.useDefaultTemplate, isTrue);
    expect(tasksRepository.createPayload?.taskTemplateId, isNull);
    expect((cubit.state as TasksBoardReady).error?.code, 'Walidacja');

    await cubit.close();
  });

  test(
    'quick create przekazuje wybrany szablon i flagę useDefaultTemplate',
    () async {
      final repository = _KanbanRepository(_board());
      final tasksRepository = _TasksRepository();
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        tasksRepository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();

      await cubit.createQuickTask(
        column: (cubit.state as TasksBoardReady).board.columns.first,
        title: 'Zadanie z dedykowanym szablonem',
        taskTemplateId: 'template-custom-1',
        useDefaultTemplate: false,
      );

      expect(
        tasksRepository.createPayload?.title,
        'Zadanie z dedykowanym szablonem',
      );
      expect(
        tasksRepository.createPayload?.targetStatus,
        ProjectTaskStatus.todo,
      );
      expect(
        tasksRepository.createPayload?.taskTemplateId,
        'template-custom-1',
      );
      expect(tasksRepository.createPayload?.useDefaultTemplate, isFalse);

      await cubit.close();
    },
  );

  test('zaznacza karty i przesyła ich aktualne wersje do bulk move', () async {
    final repository = _KanbanRepository(_board());
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    final board = (cubit.state as TasksBoardReady).board;
    final card = board.columns.first.tasks.single;

    cubit.toggleTaskSelection(card);
    expect((cubit.state as TasksBoardReady).selectedTaskIds, {card.id});
    await cubit.bulkMoveTasks(board.columns.last);

    expect(
      repository.bulkMovePayload?.targetStatus,
      ProjectTaskStatus.inProgress,
    );
    expect(repository.bulkMovePayload?.tasks.single.taskId, card.id);
    expect(repository.bulkMovePayload?.tasks.single.expectedVersion, 1);
    expect((cubit.state as TasksBoardReady).selectedTaskIds, isEmpty);
    await cubit.close();
  });

  test('aktualizuje priorytet wszystkich zaznaczonych kart atomowo', () async {
    final repository = _KanbanRepository(_board());
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    final card =
        (cubit.state as TasksBoardReady).board.columns.first.tasks.single;
    cubit.toggleTaskSelection(card);

    await cubit.bulkUpdatePriority(TaskPriority.critical);

    expect(repository.bulkUpdatePayload?.priority, TaskPriority.critical);
    expect(repository.bulkUpdatePayload?.tasks.single.taskId, card.id);
    expect(repository.bulkUpdatePayload?.tasks.single.expectedVersion, 1);
    await cubit.close();
  });

  test('normalizuje termin bulk update do UTC', () async {
    final repository = _KanbanRepository(_board());
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    final card =
        (cubit.state as TasksBoardReady).board.columns.first.tasks.single;
    cubit.toggleTaskSelection(card);
    final dueAt = DateTime(2026, 9, 1, 12, 30);

    await cubit.bulkUpdateDueDate(dueAt);

    expect(repository.bulkUpdatePayload?.dueAtUtc, dueAt.toUtc());
    expect(repository.bulkUpdatePayload?.tasks.single.taskId, card.id);
    await cubit.close();
  });

  test(
    'zaznacza wyłącznie aktualnie wczytane karty i pozwala je wyczyścić',
    () async {
      final cubit = TasksBoardCubit(
        _KanbanRepository(_board()),
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();
      final firstColumn = (cubit.state as TasksBoardReady).board.columns.first;
      await cubit.loadMore(firstColumn);

      cubit.selectAllLoadedTasks();

      expect((cubit.state as TasksBoardReady).selectedTaskIds, {
        'task-1',
        'task-2',
      });
      cubit.clearTaskSelection();
      expect((cubit.state as TasksBoardReady).selectedTaskIds, isEmpty);
      await cubit.close();
    },
  );

  test(
    'obsługuje snapshot wielu kolumn i tysiąca kart bez duplikatów',
    () async {
      final cubit = TasksBoardCubit(
        _KanbanRepository(_largeBoard()),
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );

      await cubit.start();
      cubit.selectAllLoadedTasks();

      final ready = cubit.state as TasksBoardReady;
      expect(ready.board.columns, hasLength(20));
      expect(
        ready.board.columns.expand((column) => column.tasks),
        hasLength(1000),
      );
      expect(ready.selectedTaskIds, hasLength(1000));
      expect(ready.selectedTaskIds, contains('large-task-999'));

      cubit.toggleTaskSelection(ready.board.columns.last.tasks.last);
      expect((cubit.state as TasksBoardReady).selectedTaskIds, hasLength(999));
      await cubit.close();
    },
  );

  test('nie wysyła DnD niedozwolonego przez workflow', () async {
    final repository = _KanbanRepository(_board());
    final cubit = TasksBoardCubit(
      repository,
      _Realtime(),
      _TasksRepository(),
      workflowRepository: const _WorkflowRepository(
        ProjectTaskWorkflowResponse(statuses: [], transitions: [], version: 1),
      ),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    await cubit.start();
    await Future<void>.delayed(Duration.zero);
    final board = (cubit.state as TasksBoardReady).board;

    expect(
      cubit.canMoveTaskTo(
        task: board.columns.first.tasks.first,
        targetColumn: board.columns.last,
      ),
      isFalse,
    );

    await cubit.moveTask(
      task: board.columns.first.tasks.first,
      targetColumn: board.columns.last,
      targetIndex: 0,
    );

    expect(repository.movePayload, isNull);
    expect(
      (cubit.state as TasksBoardReady).error?.code,
      'To przejście statusu nie jest dozwolone w workflow.',
    );

    await cubit.close();
  });

  test(
    'błąd przeniesienia karty A cofa wyłącznie kartę A i nie cofa operacji karty B',
    () async {
      final board = _board().copyWith(
        columns: [
          _board().columns.first.copyWith(
            tasks: [
              _card(id: 'task-A', version: 1),
              _card(id: 'task-B', version: 1),
            ],
          ),
          _board().columns.last.copyWith(tasks: []),
        ],
      );
      final repository = _KanbanRepository(board)
        ..moveResultsByTaskId = {
          'task-A': const Left(
            ApiError(type: ApiErrorType.conflict, message: 'Konflikt wersji'),
          ),
          'task-B': Right(
            MoveKanbanTaskResponse(
              task: _card(
                id: 'task-B',
                version: 2,
                status: ProjectTaskStatus.inProgress,
              ),
              targetColumnTaskCount: 1,
              isWipLimitExceeded: false,
            ),
          ),
        };
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();

      // Przenosimy najpierw kartę B do drugiej kolumny (sukces)
      await cubit.moveTask(
        task: _card(id: 'task-B', version: 1),
        targetColumn: (cubit.state as TasksBoardReady).board.columns.last,
        targetIndex: 0,
      );
      var ready = cubit.state as TasksBoardReady;
      expect(
        ready.board.columns.last.tasks.map((t) => t.id),
        contains('task-B'),
      );

      // Następnie przenosimy kartę A (błąd)
      await cubit.moveTask(
        task: _card(id: 'task-A', version: 1),
        targetColumn: ready.board.columns.last,
        targetIndex: 0,
      );

      ready = cubit.state as TasksBoardReady;
      // Karta A została wycofana do pierwszej kolumny
      expect(
        ready.board.columns.first.tasks.map((t) => t.id),
        contains('task-A'),
      );
      // Karta B NADAL pozostaje w drugiej kolumnie i nie została cofnięta!
      expect(
        ready.board.columns.last.tasks.map((t) => t.id),
        contains('task-B'),
      );
      expect(ready.error?.code, 'Konflikt wersji');

      await cubit.close();
    },
  );

  test(
    'odrzuca spóźnioną odpowiedź loadMore po ponownym załadowaniu tablicy',
    () async {
      final completer =
          Completer<
            Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>
          >();
      final repository = _KanbanRepository(_board());
      repository.systemColumnResult = null;
      repository.systemColumnLoader = () => completer.future;

      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();

      final ready = cubit.state as TasksBoardReady;
      final firstCol = ready.board.columns.first.copyWith(
        nextCursor: 'cursor-1',
      );

      // Uruchomienie loadMore, które czeka na completer
      final loadMoreFuture = cubit.loadMore(firstCol);

      // W międzyczasie następuje przeładowanie tablicy (np. zmiana filtra)
      await cubit.load(force: true);

      // Dopiero teraz spóźniona odpowiedź loadMore powraca
      completer.complete(
        Right(CursorPageResponse(items: [_card(id: 'stale-task', version: 1)])),
      );
      await loadMoreFuture;

      // Spóźnione zadanie NIE zostało doklejone do świeżego stanu tablicy
      final current = cubit.state as TasksBoardReady;
      expect(
        current.board.columns.expand((col) => col.tasks).map((t) => t.id),
        isNot(contains('stale-task')),
      );

      await cubit.close();
    },
  );

  test(
    'zeruje termin karty gdy realtime przekazuje hasDueAtUtc: true i dueAtUtc: null',
    () async {
      final realtime = _Realtime();
      final cubit = TasksBoardCubit(
        _KanbanRepository(_board()),
        realtime,
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();

      // Emisja mutacji zerującej termin
      realtime.updatesController.add(
        TaskRealtimeMutation(
          eventId: 'mutation-clear-due',
          type: TaskRealtimeMutationType.updated,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: 'task-1',
          number: 1,
          key: 'EX-1',
          version: 2,
          occurredAtUtc: DateTime.now().toUtc(),
          isReplay: false,
          hasDueAtUtc: true,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final ready = cubit.state as TasksBoardReady;
      final task = ready.board.columns.first.tasks.firstWhere(
        (t) => t.id == 'task-1',
      );
      expect(task.dueAtUtc, isNull);
      expect(task.version, 2);

      await cubit.close();
      await realtime.dispose();
    },
  );

  test(
    'quick create tworzy zadanie we własnej kolumnie workflow z customStatusId',
    () async {
      final tasksRepo = _TasksRepository();
      final cubit = TasksBoardCubit(
        _KanbanRepository(_board()),
        _Realtime(),
        tasksRepo,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();

      const customCol = KanbanColumnResponse(
        status: ProjectTaskStatus.inProgress,
        displayName: 'Weryfikacja',
        color: '#8B5CF6',
        totalTaskCount: 0,
        isWipLimitExceeded: false,
        tasks: [],
        customStatusId: 'custom-status-uuid-1',
      );

      await cubit.createQuickTask(column: customCol, title: 'Nowe zadanie');

      expect(tasksRepo.createPayload?.customStatusId, 'custom-status-uuid-1');
      expect(tasksRepo.createPayload?.targetStatus, isNull);
      expect(tasksRepo.createPayload?.title, 'Nowe zadanie');

      await cubit.close();
    },
  );

  test(
    'blokuje DnD karty znajdującej się w trakcie operacji (pendingTaskIds)',
    () async {
      final repository = _KanbanRepository(_board());
      final cubit = TasksBoardCubit(
        repository,
        _Realtime(),
        _TasksRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.start();

      final ready = cubit.state as TasksBoardReady;
      final task = ready.board.columns.first.tasks.first;
      final targetCol = ready.board.columns.last;

      // Początkowo ruch jest dozwolony
      expect(cubit.canMoveTaskTo(task: task, targetColumn: targetCol), isTrue);

      // Po dodaniu do pendingTaskIds
      cubit.emit(ready.copyWith(pendingTaskIds: {task.id}));
      expect(cubit.canMoveTaskTo(task: task, targetColumn: targetCol), isFalse);

      await cubit.close();
    },
  );
}
