import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';

final class _MockTaskListConfigurationRepository
    implements TaskListConfigurationRepository {
  EffectiveTaskListConfigurationResponse? effectiveConfig;
  TaskListUserPreferenceResponse? userPref;
  int updateCallCount = 0;
  UpdateTaskListUserPreferencePayload? lastUpdatePayload;
  int resetCallCount = 0;
  int? statusCodeToReturnOnUpdate;

  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) async {
    if (effectiveConfig != null) return Right(effectiveConfig!);
    return const Left(
      ApiError(type: ApiErrorType.notFound, message: 'Not found'),
    );
  }

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  }) async {
    updateCallCount++;
    lastUpdatePayload = payload;
    if (statusCodeToReturnOnUpdate != null) {
      return Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: 'Conflict',
          statusCode: statusCodeToReturnOnUpdate,
        ),
      );
    }
    return Right(
      TaskListUserPreferenceResponse(
        workspaceId: workspaceId,
        projectId: projectId,
        coreUserId: 'user-1',
        visibleColumns: payload.visibleColumns,
        columnWidths: payload.columnWidths,
        version: payload.expectedVersion + 1,
      ),
    );
  }

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> resetUserPreference({
    required String workspaceId,
    required String projectId,
  }) async {
    resetCallCount++;
    return const Right(
      TaskListUserPreferenceResponse(
        workspaceId: 'w-1',
        projectId: 'p-1',
        coreUserId: 'user-1',
        visibleColumns: [],
        columnWidths: {},
        version: 1,
      ),
    );
  }

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> getPolicy({
    required String workspaceId,
    required String projectId,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> updatePolicy({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskListPolicyPayload payload,
  }) async => throw UnimplementedError();
}

void main() {
  late _MockTaskListConfigurationRepository mockRepo;
  late TaskListPreferencesCubit cubit;

  const sampleConfig = EffectiveTaskListConfigurationResponse(
    workspaceId: 'w-1',
    projectId: 'p-1',
    effectiveVisibleColumns: ['sys:key', 'sys:title', 'sys:status'],
    effectiveColumnWidths: {
      'sys:key': 90.0,
      'sys:title': 280.0,
      'sys:status': 130.0,
    },
    availableColumns: ['sys:key', 'sys:title', 'sys:status', 'sys:priority'],
    requiredColumns: ['sys:title'],
    sortField: TaskSavedViewSortField.position,
    sortDirection: TaskSavedViewSortDirection.ascending,
    groupBy: TaskSavedViewGroupBy.status,
    userPreferenceVersion: 1,
    policyVersion: 1,
  );

  setUp(() {
    mockRepo = _MockTaskListConfigurationRepository();
    mockRepo.effectiveConfig = sampleConfig;
    cubit = TaskListPreferencesCubit(
      repository: mockRepo,
      workspaceId: 'w-1',
      projectId: 'p-1',
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('load() emituje gotowy stan TaskListPreferencesReady', () async {
    expect(cubit.state, isA<TaskListPreferencesLoading>());
    await cubit.load();

    expect(cubit.state, isA<TaskListPreferencesReady>());
    final ready = cubit.state as TaskListPreferencesReady;
    expect(ready.effectiveVisibleColumns.map((c) => c.id).toList(), [
      'sys:key',
      'sys:title',
      'sys:status',
    ]);
    expect(ready.isColumnRequired('sys:title'), isTrue);
    expect(ready.isColumnRequired('sys:key'), isFalse);
    expect(ready.isColumnAvailable('sys:priority'), isTrue);
    expect(ready.isColumnAvailable('sys:dueAtUtc'), isFalse);
  });

  test('toggleColumn() nie pozwala wyłączyć kolumny wymaganej', () async {
    await cubit.load();
    cubit.toggleColumn(
      const TaskColumnReference.system(TaskSavedViewColumn.title),
    );

    final ready = cubit.state as TaskListPreferencesReady;
    expect(ready.isColumnVisible('sys:title'), isTrue);
  });

  test(
    'toggleColumn() wyłącza kolumnę niewymaganą i dodaje dostępną',
    () async {
      await cubit.load();

      // Wyłączenie sys:status
      cubit.toggleColumn(
        const TaskColumnReference.system(TaskSavedViewColumn.status),
      );
      var ready = cubit.state as TaskListPreferencesReady;
      expect(ready.isColumnVisible('sys:status'), isFalse);

      // Włączenie sys:priority (która jest available)
      cubit.toggleColumn(
        const TaskColumnReference.system(TaskSavedViewColumn.priority),
      );
      ready = cubit.state as TaskListPreferencesReady;
      expect(ready.isColumnVisible('sys:priority'), isTrue);

      // Próba włączenia sys:dueAtUtc (która NIE jest w availableColumns)
      cubit.toggleColumn(
        const TaskColumnReference.system(TaskSavedViewColumn.dueAtUtc),
      );
      ready = cubit.state as TaskListPreferencesReady;
      expect(ready.isColumnVisible('sys:dueAtUtc'), isFalse);
    },
  );

  test('reorderColumns() przestawia kolejność kolumn', () async {
    await cubit.load();
    cubit.reorderColumns(0, 2); // z index 0 na index 2

    final ready = cubit.state as TaskListPreferencesReady;
    expect(ready.effectiveVisibleColumns.map((c) => c.id).toList(), [
      'sys:title',
      'sys:status',
      'sys:key',
    ]);
  });

  test(
    'cycleSort() przełącza cyklicznie sortowanie i natychmiast zapisuje',
    () async {
      await cubit.load();

      // 1. Zmiana pola: priority domyślnie descending (najwyższy priorytet na górze)
      await cubit.cycleSort(TaskSavedViewSortField.priority);
      var ready = cubit.state as TaskListPreferencesReady;
      expect(ready.sortField, TaskSavedViewSortField.priority);
      expect(ready.sortDirection, TaskSavedViewSortDirection.descending);
      expect(mockRepo.updateCallCount, 1);
      expect(ready.userPreferenceVersion, 2);

      // 2. To samo pole: ascending
      await cubit.cycleSort(TaskSavedViewSortField.priority);
      ready = cubit.state as TaskListPreferencesReady;
      expect(ready.sortField, TaskSavedViewSortField.priority);
      expect(ready.sortDirection, TaskSavedViewSortDirection.ascending);
      expect(mockRepo.updateCallCount, 2);
      expect(ready.userPreferenceVersion, 3);

      // 3. To samo pole powtórnie: powrót do domyślnego position
      await cubit.cycleSort(TaskSavedViewSortField.priority);
      ready = cubit.state as TaskListPreferencesReady;
      expect(ready.sortField, TaskSavedViewSortField.position);
      expect(ready.sortDirection, TaskSavedViewSortDirection.ascending);
      expect(mockRepo.updateCallCount, 3);
      expect(ready.userPreferenceVersion, 4);
    },
  );

  test(
    'setGroupBy() natychmiastowo zapisuje nowe grupowanie do repozytorium',
    () async {
      await cubit.load();

      await cubit.setGroupBy(TaskSavedViewGroupBy.priority);
      final ready = cubit.state as TaskListPreferencesReady;
      expect(ready.groupBy, TaskSavedViewGroupBy.priority);
      expect(mockRepo.updateCallCount, 1);
      expect(
        mockRepo.lastUpdatePayload?.groupBy,
        TaskSavedViewGroupBy.priority,
      );
      expect(ready.userPreferenceVersion, 2);
    },
  );

  test('resizeColumn() ogranicza szerokość do bezpiecznego zakresu', () async {
    await cubit.load();

    cubit.resizeColumn('sys:title', 15.0); // poniżej 50
    var ready = cubit.state as TaskListPreferencesReady;
    expect(ready.widthFor('sys:title'), 50.0);

    cubit.resizeColumn('sys:title', 2500.0); // powyżej 1000
    ready = cubit.state as TaskListPreferencesReady;
    expect(ready.widthFor('sys:title'), 1000.0);

    cubit.resizeColumn('sys:title', 350.0);
    ready = cubit.state as TaskListPreferencesReady;
    expect(ready.widthFor('sys:title'), 350.0);
  });

  test('resetToProjectDefaults() wywołuje reset w repozytorium', () async {
    await cubit.load();
    await cubit.resetToProjectDefaults();
    expect(mockRepo.resetCallCount, 1);
  });

  test(
    'autosave wysyła zmiany z expectedVersion po upływie debounce',
    () async {
      await cubit.load();

      cubit.resizeColumn('sys:title', 320.0);
      expect(mockRepo.updateCallCount, 0); // jeszcze przed debounce

      await Future<void>.delayed(const Duration(milliseconds: 600));

      expect(mockRepo.updateCallCount, 1);
      expect(mockRepo.lastUpdatePayload?.expectedVersion, 1);
      expect(mockRepo.lastUpdatePayload?.columnWidths['sys:title'], 320.0);
      final ready = cubit.state as TaskListPreferencesReady;
      expect(ready.userPreferenceVersion, 2);
    },
  );

  test(
    'autosave przy błędzie 409 conflict automatycznie odświeża stan',
    () async {
      await cubit.load();
      mockRepo.statusCodeToReturnOnUpdate = 409;

      cubit.resizeColumn('sys:title', 330.0);
      await Future<void>.delayed(const Duration(milliseconds: 600));

      expect(mockRepo.updateCallCount, 1);
      // Po 409 cubit automatycznie wywołał load(), przywracając świeży stan
      final ready = cubit.state as TaskListPreferencesReady;
      expect(ready.userPreferenceVersion, 1);
    },
  );

  test(
    'autosave serializuje żądania w kolejce dirty-state bez wyścigów sieciowych',
    () async {
      await cubit.load();

      // Wywołujemy pierwszą zmianę
      cubit.resizeColumn('sys:title', 320.0);
      await Future<void>.delayed(const Duration(milliseconds: 600));

      expect(mockRepo.updateCallCount, 1);
      expect(mockRepo.lastUpdatePayload?.expectedVersion, 1);

      // Wywołujemy kolejną zmianę
      cubit.resizeColumn('sys:title', 360.0);
      await Future<void>.delayed(const Duration(milliseconds: 600));

      expect(mockRepo.updateCallCount, 2);
      expect(mockRepo.lastUpdatePayload?.expectedVersion, 2);
      expect(mockRepo.lastUpdatePayload?.columnWidths['sys:title'], 360.0);
    },
  );
}
