import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/cubit/task_saved_views_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskViewRepository {
  UpdateTaskSavedViewPayload? updated;
  CreateTaskSavedViewPayload? created;
  String? deletedId;
  Either<ApiError, TaskSavedViewResponse>? createResult;
  Either<ApiError, TaskSavedViewResponse>? updateResult;
  Either<ApiError, Unit>? deleteResult;

  @override
  Future<Either<ApiError, List<TaskSavedViewResponse>>> list({
    required String workspaceId,
    required String projectId,
  }) async => Right([_view]);

  @override
  Future<Either<ApiError, TaskSavedViewResponse>> create({
    required String workspaceId,
    required String projectId,
    required CreateTaskSavedViewPayload payload,
  }) async {
    created = payload;
    return createResult ??
        Right(
          TaskSavedViewResponse(
            id: 'view-new',
            name: payload.name,
            createdAtUtc: DateTime.utc(2026),
            updatedAtUtc: DateTime.utc(2026),
            view: payload.view,
          ),
        );
  }

  @override
  Future<Either<ApiError, TaskSavedViewResponse>> update({
    required String workspaceId,
    required String projectId,
    required String viewId,
    required UpdateTaskSavedViewPayload payload,
  }) async {
    updated = payload;
    return updateResult ??
        Right(
          _view.copyWith(
            name: payload.name,
            view: payload.view,
            version: (_view.version) + 1,
          ),
        );
  }

  @override
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String projectId,
    required String viewId,
  }) async {
    deletedId = viewId;
    return deleteResult ?? const Right(unit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MockPreferencesRepository
    implements TaskListConfigurationRepository {
  _MockPreferencesRepository({this.initialActiveSavedViewId});

  String? initialActiveSavedViewId;
  UpdateTaskListUserPreferencePayload? lastUpdatedPayload;

  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) async => Right(
    EffectiveTaskListConfigurationResponse(
      workspaceId: workspaceId,
      projectId: projectId,
      effectiveVisibleColumns: ['sys:title'],
      effectiveColumnWidths: const {'sys:title': 280.0},
      availableColumns: const ['sys:title'],
      requiredColumns: const ['sys:title'],
      sortField: TaskSavedViewSortField.position,
      sortDirection: TaskSavedViewSortDirection.ascending,
      groupBy: TaskSavedViewGroupBy.status,
      activeSavedViewId: initialActiveSavedViewId,
      userPreferenceVersion: 1,
      policyVersion: 1,
    ),
  );

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) async => Right(
    TaskListUserPreferenceResponse(
      workspaceId: workspaceId,
      projectId: projectId,
      userId: 'user-1',
      visibleColumns: const ['sys:title'],
      columnWidths: const {'sys:title': 280.0},
      sortField: TaskSavedViewSortField.position,
      sortDirection: TaskSavedViewSortDirection.ascending,
      groupBy: TaskSavedViewGroupBy.status,
      activeSavedViewId: initialActiveSavedViewId,
      version: 1,
    ),
  );

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  }) async {
    lastUpdatedPayload = payload;
    initialActiveSavedViewId = payload.activeSavedViewId;
    return Right(
      TaskListUserPreferenceResponse(
        workspaceId: workspaceId,
        projectId: projectId,
        userId: 'user-1',
        visibleColumns: payload.visibleColumns,
        columnWidths: payload.columnWidths,
        sortField: payload.sortField,
        sortDirection: payload.sortDirection,
        groupBy: payload.groupBy,
        activeSavedViewId: payload.activeSavedViewId,
        version: payload.expectedVersion + 1,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _view = TaskSavedViewResponse(
  id: 'view-1',
  name: 'Ważne',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  view: const TaskSavedViewDefinition(
    filter: TaskSavedViewFilter(),
    sortField: TaskSavedViewSortField.position,
    sortDirection: TaskSavedViewSortDirection.ascending,
    groupBy: TaskSavedViewGroupBy.none,
    columns: [TaskSavedViewColumn.title],
  ),
);

void main() {
  test(
    'create dodaje nowy widok, zaznacza go i odsyła do preferencji',
    () async {
      final repository = _Repository();
      final preferencesRepository = _MockPreferencesRepository();
      final cubit = TaskSavedViewsCubit(
        repository: repository,
        preferencesRepository: preferencesRepository,
        workspaceId: 'workspace',
        projectId: 'project',
      );
      await cubit.load();

      const newDefinition = TaskSavedViewDefinition(
        filter: TaskSavedViewFilter(pinnedOnly: true),
        sortField: TaskSavedViewSortField.dueAtUtc,
        sortDirection: TaskSavedViewSortDirection.descending,
        groupBy: TaskSavedViewGroupBy.priority,
        columns: [TaskSavedViewColumn.title, TaskSavedViewColumn.dueAtUtc],
      );

      await cubit.create(
        const CreateTaskSavedViewPayload(
          name: '  Nowy widok  ',
          view: newDefinition,
        ),
      );

      expect(repository.created?.name, 'Nowy widok');
      expect(repository.created?.view, newDefinition);

      final state = cubit.state as TaskSavedViewsReady;
      expect(state.activeViewId, 'view-new');
      expect(state.views.any((v) => v.id == 'view-new'), isTrue);
      expect(state.successMessage, 'Widok zapisany');

      await pumpEventQueue();
      expect(
        preferencesRepository.lastUpdatedPayload?.activeSavedViewId,
        'view-new',
      );

      await cubit.close();
    },
  );

  test(
    'aktualizacja zapisuje pełną definicję widoku i zachowuje wybór',
    () async {
      final repository = _Repository();
      final cubit = TaskSavedViewsCubit(
        repository: repository,
        workspaceId: 'workspace',
        projectId: 'project',
      );
      await cubit.load();
      cubit.select(_view.id);
      final definition = _view.view.copyWith(
        sortField: TaskSavedViewSortField.dueAtUtc,
        sortDirection: TaskSavedViewSortDirection.descending,
        groupBy: TaskSavedViewGroupBy.priority,
        columns: [TaskSavedViewColumn.title, TaskSavedViewColumn.dueAtUtc],
        filter: const TaskSavedViewFilter(pinnedOnly: true),
      );

      await cubit.update(
        _view.id,
        UpdateTaskSavedViewPayload(name: '  Terminowe  ', view: definition),
      );

      expect(repository.updated?.name, 'Terminowe');
      expect(repository.updated?.view, definition);
      final state = cubit.state as TaskSavedViewsReady;
      expect(state.activeViewId, _view.id);
      expect(state.views.single.name, 'Terminowe');
      await cubit.close();
    },
  );

  test(
    'update obsługuje błąd 409 conflict i ustawia komunikat o nowszej wersji',
    () async {
      final repository = _Repository();
      repository.updateResult = const Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: 'Widok został zmieniony przez kogoś innego',
          statusCode: 409,
        ),
      );
      final cubit = TaskSavedViewsCubit(
        repository: repository,
        workspaceId: 'workspace',
        projectId: 'project',
      );
      await cubit.load();

      await cubit.update(
        _view.id,
        UpdateTaskSavedViewPayload(name: 'Zmieniony', view: _view.view),
      );

      final state = cubit.state as TaskSavedViewsReady;
      expect(state.error, contains('Widok został zmodyfikowany'));
      await cubit.close();
    },
  );

  test(
    'delete usuwa widok i jeśli był aktywny, przełącza na domyślny',
    () async {
      final repository = _Repository();
      final preferencesRepository = _MockPreferencesRepository(
        initialActiveSavedViewId: _view.id,
      );
      final cubit = TaskSavedViewsCubit(
        repository: repository,
        preferencesRepository: preferencesRepository,
        workspaceId: 'workspace',
        projectId: 'project',
      );
      await cubit.load();
      expect((cubit.state as TaskSavedViewsReady).activeViewId, _view.id);

      await cubit.delete(_view.id);

      expect(repository.deletedId, _view.id);
      final state = cubit.state as TaskSavedViewsReady;
      expect(state.views.isEmpty, isTrue);
      expect(state.activeViewId, isNull);

      await pumpEventQueue();
      expect(
        preferencesRepository.lastUpdatedPayload?.activeSavedViewId,
        isNull,
      );

      await cubit.close();
    },
  );

  test(
    'load odzyskuje activeViewId z konfiguracji backendu',
    () async {
      final repository = _Repository();
      final preferencesRepository = _MockPreferencesRepository(
        initialActiveSavedViewId: _view.id,
      );
      final cubit = TaskSavedViewsCubit(
        repository: repository,
        preferencesRepository: preferencesRepository,
        workspaceId: 'workspace',
        projectId: 'project',
      );
      await cubit.load();
      final state = cubit.state as TaskSavedViewsReady;
      expect(state.activeViewId, _view.id);
      await cubit.close();
    },
  );

  test(
    'select zapisuje activeSavedViewId w preferencjach użytkownika',
    () async {
      final repository = _Repository();
      final preferencesRepository = _MockPreferencesRepository();
      final cubit = TaskSavedViewsCubit(
        repository: repository,
        preferencesRepository: preferencesRepository,
        workspaceId: 'workspace',
        projectId: 'project',
      );
      await cubit.load();
      cubit.select(_view.id);
      // Poczekaj na asynchroniczny zapis preferencji
      await pumpEventQueue();

      expect(
        preferencesRepository.lastUpdatedPayload?.activeSavedViewId,
        _view.id,
      );
      final state = cubit.state as TaskSavedViewsReady;
      expect(state.activeViewId, _view.id);

      cubit.select(null);
      await pumpEventQueue();

      expect(
        preferencesRepository.lastUpdatedPayload?.activeSavedViewId,
        isNull,
      );
      final clearedState = cubit.state as TaskSavedViewsReady;
      expect(clearedState.activeViewId, isNull);

      await cubit.close();
    },
  );
}
