import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MockTasksRepo implements TasksRepository {
  int listCalls = 0;
  ProjectTasksGroupedQuery? lastGroupedQuery;

  @override
  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  }) async {
    listCalls++;
    lastGroupedQuery = query;
    return const Right(
      ProjectTaskGroupedListResponse(
        totalCount: 0,
        groupBy: TaskSavedViewGroupBy.status,
        groups: [
          ProjectTaskListGroupResponse(
            key: 'status:Todo',
            displayName: 'Do zrobienia',
            color: '#2563EB',
            position: 0,
            totalCount: 0,
            items: [],
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MockConfigRepo implements TaskListConfigurationRepository {
  int getEffectiveCalls = 0;
  int updatePrefCalls = 0;
  UpdateTaskListUserPreferencePayload? lastPayload;
  EffectiveTaskListConfigurationResponse? effectiveConfigOverride;

  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) async {
    getEffectiveCalls++;
    return Right(
      effectiveConfigOverride ??
          const EffectiveTaskListConfigurationResponse(
            workspaceId: 'w-1',
            projectId: 'p-1',
            effectiveVisibleColumns: ['sys:key', 'sys:title'],
            effectiveColumnWidths: {'sys:key': 90.0, 'sys:title': 280.0},
            availableColumns: ['sys:key', 'sys:title'],
            requiredColumns: ['sys:title'],
            sortField: TaskSavedViewSortField.position,
            sortDirection: TaskSavedViewSortDirection.ascending,
            groupBy: TaskSavedViewGroupBy.status,
            userPreferenceVersion: 1,
            policyVersion: 1,
          ),
    );
  }

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  }) async {
    updatePrefCalls++;
    lastPayload = payload;
    return Right(
      TaskListUserPreferenceResponse(
        workspaceId: workspaceId,
        projectId: projectId,
        userId: 'u-1',
        visibleColumns: payload.visibleColumns,
        columnWidths: payload.columnWidths,
        sortField: payload.sortField,
        sortDirection: payload.sortDirection,
        groupBy: payload.groupBy,
        version: payload.expectedVersion + 1,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MockMetadataRepo implements TaskMetadataRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MockCollaborationRepo implements TaskCollaborationRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MockRecurrenceRepo implements TaskRecurrenceRepository {
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

final class _KanbanRepo implements KanbanRepository {
  @override
  Future<Either<ApiError, AssigneeKanbanBoardResponse>> getAssigneeBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getAssigneeGroup({
    required String workspaceId,
    required String projectId,
    String? assigneeUserId,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>>
  changePrimaryAssignee({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String? targetUserId,
    required int expectedVersion,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) async => const Right(
    KanbanBoardResponse(
      projectId: 'p-1',
      swimlaneMode: KanbanSwimlaneMode.none,
      settingsVersion: 0,
      hiddenColumns: [],
      visibleCardFields: [],
      defaultCardDensity: KanbanCardDensity.comfortable,
      columns: [],
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'zmiana sortowania i grupowania wywołuje natychmiastowy zapis i przeładowanie danych',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final tasksRepo = _MockTasksRepo();
      final configRepo = _MockConfigRepo();
      final realtime = _Realtime();
      addTearDown(realtime.dispose);
      final boardCubit = TasksBoardCubit(
        _KanbanRepo(),
        realtime,
        tasksRepo,
        workspaceId: 'w-1',
        projectId: 'p-1',
      );
      addTearDown(boardCubit.close);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<TasksRepository>.value(value: tasksRepo),
              RepositoryProvider<TaskListConfigurationRepository>.value(
                value: configRepo,
              ),
              RepositoryProvider<TaskMetadataRepository>.value(
                value: _MockMetadataRepo(),
              ),
              RepositoryProvider<TaskCollaborationRepository>.value(
                value: _MockCollaborationRepo(),
              ),
              RepositoryProvider<TaskRecurrenceRepository>.value(
                value: _MockRecurrenceRepo(),
              ),
            ],
            child: BlocProvider<TasksBoardCubit>.value(
              value: boardCubit,
              child: const Scaffold(
                body: ProjectTasksList(
                  workspaceId: 'w-1',
                  projectId: 'p-1',
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Początkowe ładowanie danych i preferencji
      expect(configRepo.getEffectiveCalls, 1);
      final initialListCalls = tasksRepo.listCalls;
      expect(initialListCalls, greaterThanOrEqualTo(1));

      // Pobieramy TaskListPreferencesCubit z drzewa kontekstu
      final prefCubit = tester
          .element(find.byType(TaskListTable))
          .read<TaskListPreferencesCubit>();

      // 1. Zmiana sortowania: wywołanie cycleSort natychmiast zapisuje preferencję
      await prefCubit.cycleSort(TaskSavedViewSortField.priority);
      await tester.pumpAndSettle();

      expect(configRepo.updatePrefCalls, 1);
      expect(
        configRepo.lastPayload?.sortField,
        TaskSavedViewSortField.priority,
      );
      // Przeładowanie danych po udanym zapisie
      expect(tasksRepo.listCalls, initialListCalls + 1);

      // 2. Zmiana grupowania: wywołanie setGroupBy natychmiast zapisuje i przeładowuje listę
      await prefCubit.setGroupBy(TaskSavedViewGroupBy.priority);
      await tester.pumpAndSettle();

      expect(configRepo.updatePrefCalls, 2);
      expect(configRepo.lastPayload?.groupBy, TaskSavedViewGroupBy.priority);
      expect(tasksRepo.listCalls, initialListCalls + 2);
      expect(tasksRepo.lastGroupedQuery?.groupBy, 'Priority');
    },
  );

  testWidgets(
    'początkowe pobranie preferencji z innym grupowaniem niż widok aktualizuje grupowanie',
    (tester) async {
      final tasksRepo = _MockTasksRepo();
      final configRepo = _MockConfigRepo();
      final realtime = _Realtime();
      addTearDown(realtime.dispose);
      final boardCubit = TasksBoardCubit(
        _KanbanRepo(),
        realtime,
        tasksRepo,
        workspaceId: 'w-1',
        projectId: 'p-1',
      );
      addTearDown(boardCubit.close);

      // Konfiguracja w repo zwraca groupBy: priority
      configRepo.effectiveConfigOverride =
          const EffectiveTaskListConfigurationResponse(
            workspaceId: 'w-1',
            projectId: 'p-1',
            effectiveVisibleColumns: ['sys:key', 'sys:title'],
            effectiveColumnWidths: {'sys:key': 90.0, 'sys:title': 280.0},
            availableColumns: ['sys:key', 'sys:title'],
            requiredColumns: ['sys:title'],
            sortField: TaskSavedViewSortField.position,
            sortDirection: TaskSavedViewSortDirection.ascending,
            groupBy: TaskSavedViewGroupBy.priority,
            userPreferenceVersion: 1,
            policyVersion: 1,
          );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<TasksRepository>.value(value: tasksRepo),
              RepositoryProvider<TaskListConfigurationRepository>.value(
                value: configRepo,
              ),
              RepositoryProvider<TaskMetadataRepository>.value(
                value: _MockMetadataRepo(),
              ),
              RepositoryProvider<TaskCollaborationRepository>.value(
                value: _MockCollaborationRepo(),
              ),
              RepositoryProvider<TaskRecurrenceRepository>.value(
                value: _MockRecurrenceRepo(),
              ),
            ],
            child: BlocProvider<TasksBoardCubit>.value(
              value: boardCubit,
              child: const Scaffold(
                body: ProjectTasksList(
                  workspaceId: 'w-1',
                  projectId: 'p-1',
                  groupBy: TaskSavedViewGroupBy.status,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Cubit powinien automatycznie zsynchronizować grupowanie do 'priority'
      expect(tasksRepo.lastGroupedQuery?.groupBy, 'Priority');
    },
  );

  testWidgets(
    'zmiana układu kolumn (szerokość, kolejność) nie powoduje ponownego ładowania danych zadań',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final tasksRepo = _MockTasksRepo();
      final configRepo = _MockConfigRepo();
      final realtime = _Realtime();
      addTearDown(realtime.dispose);
      final boardCubit = TasksBoardCubit(
        _KanbanRepo(),
        realtime,
        tasksRepo,
        workspaceId: 'w-1',
        projectId: 'p-1',
      );
      addTearDown(boardCubit.close);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<TasksRepository>.value(value: tasksRepo),
              RepositoryProvider<TaskListConfigurationRepository>.value(
                value: configRepo,
              ),
              RepositoryProvider<TaskMetadataRepository>.value(
                value: _MockMetadataRepo(),
              ),
              RepositoryProvider<TaskCollaborationRepository>.value(
                value: _MockCollaborationRepo(),
              ),
              RepositoryProvider<TaskRecurrenceRepository>.value(
                value: _MockRecurrenceRepo(),
              ),
            ],
            child: BlocProvider<TasksBoardCubit>.value(
              value: boardCubit,
              child: const Scaffold(
                body: ProjectTasksList(
                  workspaceId: 'w-1',
                  projectId: 'p-1',
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final initialListCalls = tasksRepo.listCalls;

      final prefCubit = tester
          .element(find.byType(TaskListTable))
          .read<TaskListPreferencesCubit>();

      // 1. Zmiana szerokości kolumny
      prefCubit.resizeColumn(TaskSavedViewColumn.title.name, 260);
      await tester.pumpAndSettle();

      // Liczba zapytań o listę zadań NIE może wzrosnąć
      expect(tasksRepo.listCalls, initialListCalls);

      // 2. Zmiana kolejności kolumn
      prefCubit.reorderColumns(0, 1);
      await tester.pumpAndSettle();

      // Liczba zapytań o listę zadań nadal NIE może wzrosnąć
      expect(tasksRepo.listCalls, initialListCalls);
    },
  );
}
