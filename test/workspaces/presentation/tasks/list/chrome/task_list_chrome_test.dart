
import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_chrome_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium listy notujące zapytania i mutacje.
final class _FakeTasksRepository implements TasksRepository {
  final List<ProjectTasksGroupedQuery> queries = [];
  final List<UpdateTaskListItemPayload> updates = [];
  final List<Map<String, Object?>> bulkSelectionCalls = [];

  @override
  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  }) async {
    queries.add(query);
    return Right(
      ProjectTaskGroupedListResponse(
        totalCount: 2,
        groupBy: TaskSavedViewGroupBy.status,
        groups: [
          ProjectTaskListGroupResponse(
            key: 'status:Todo',
            displayName: 'Do zrobienia',
            color: '#2563EB',
            position: 0,
            totalCount: 2,
            items: [
              _task('task-1'),
              _task('task-2'),
            ],
          ),
        ],
      ),
    );
  }

  ProjectTaskListItemResponse _task(String id) => ProjectTaskListItemResponse(
    id: id,
    number: 1,
    key: 'DEV-$id',
    title: 'Zadanie $id',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    assignees: const [],
    checklistCompletedCount: 0,
    checklistTotalCount: 0,
    updatedAtUtc: DateTime.utc(2026, 9, 19),
    version: 1,
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskListItemResponse>>>
  updateListItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskListItemPayload payload,
  }) async {
    updates.add(payload);
    return Right(
      TaskMutationResponse<ProjectTaskListItemResponse>(
        taskId: taskId,
        taskVersion: payload.expectedVersion + 1,
        taskUpdatedAtUtc: DateTime.utc(2026, 9, 19),
        data: _task(taskId),
      ),
    );
  }

  @override
  Future<Either<ApiError, BulkUpdateTaskSelectionResponse>>
  bulkUpdateTaskSelection({
    required String workspaceId,
    required String projectId,
    required BulkUpdateTaskSelectionPayload payload,
  }) async {
    bulkSelectionCalls.add({
      'status': payload.status,
      'priority': payload.priority,
    });
    return const Right(
      BulkUpdateTaskSelectionResponse(updatedCount: 2),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakePreferencesRepository
    implements TaskListConfigurationRepository {
  final List<UpdateTaskListUserPreferencePayload> saves = [];

  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) async => const Right(
    EffectiveTaskListConfigurationResponse(
      workspaceId: 'workspace-1',
      projectId: 'project-1',
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

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  }) async {
    saves.add(payload);
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
        version: payload.expectedVersion + 1,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeCollaborationRepository
    implements TaskCollaborationRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeRecurrenceRepository implements TaskRecurrenceRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeMetadataRepository implements TaskMetadataRepository {
  @override
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  }) async => const Right(<TaskCustomFieldResponse>[]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _harness({
  required Widget child,
  required _FakeTasksRepository tasks,
  required _FakePreferencesRepository preferences,
  required _FakeMetadataRepository metadata,
}) => MultiRepositoryProvider(
  providers: [
    RepositoryProvider<TasksRepository>.value(value: tasks),
    RepositoryProvider<TaskListConfigurationRepository>.value(
      value: preferences,
    ),
    RepositoryProvider<TaskMetadataRepository>.value(value: metadata),
    RepositoryProvider<TaskCollaborationRepository>.value(
      value: _FakeCollaborationRepository(),
    ),
    RepositoryProvider<TaskRecurrenceRepository>.value(
      value: _FakeRecurrenceRepository(),
    ),
  ],
  child: MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

Future<void> _pumpChrome(
  WidgetTester tester, {
  required _FakeTasksRepository tasks,
  required _FakePreferencesRepository preferences,
  required _FakeMetadataRepository metadata,
  double width = 1280,
  void Function(TaskListChrome chrome)? onChrome,
}) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    _harness(
      tasks: tasks,
      preferences: preferences,
      metadata: metadata,
      child: TaskListChromeHost(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        savedViewId: null,
        groupBy: TaskSavedViewGroupBy.status,
        memberProfilesByUserId: const {},
        builder: (context, chrome) {
          onChrome?.call(chrome);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (chrome.showBulkBar) chrome.bulkBar else chrome.commandBar,
            ],
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('wiersz poleceń pokazuje filtry, sortowanie, grupowanie i kolumny', (
    tester,
  ) async {
    await _pumpChrome(
      tester,
      tasks: _FakeTasksRepository(),
      preferences: _FakePreferencesRepository(),
      metadata: _FakeMetadataRepository(),
    );

    expect(find.byKey(const ValueKey('command_filter_status')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('command_filter_priority')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('command_filter_assignee')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('command_sort')), findsOneWidget);
    expect(find.byKey(const ValueKey('command_group')), findsOneWidget);
    expect(find.byKey(const ValueKey('command_columns')), findsOneWidget);
    // Bez aktywnego filtra nie ma czyszczenia wszystkich.
    expect(find.byKey(const ValueKey('command_clear_filters')), findsNothing);
  });

  testWidgets('filtr statusu korzysta ze wspólnego menu i przeładowuje listę', (
    tester,
  ) async {
    final tasks = _FakeTasksRepository();
    await _pumpChrome(
      tester,
      tasks: tasks,
      preferences: _FakePreferencesRepository(),
      metadata: _FakeMetadataRepository(),
    );
    final loadsBefore = tasks.queries.length;

    await tester.tap(find.byKey(const ValueKey('command_filter_status')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('W toku').last);
    await tester.pumpAndSettle();

    expect(tasks.queries.length, greaterThan(loadsBefore));
    expect(tasks.queries.last.status, ProjectTaskStatus.inProgress.name);
    // Aktywny filtr pokazuje wartość i czyszczenie wszystkiego.
    expect(find.text('W toku'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('command_clear_filters')),
      findsOneWidget,
    );
  });

  testWidgets('„Wyczyść wszystko” zdejmuje filtr statusu', (tester) async {
    final tasks = _FakeTasksRepository();
    await _pumpChrome(
      tester,
      tasks: tasks,
      preferences: _FakePreferencesRepository(),
      metadata: _FakeMetadataRepository(),
    );

    await tester.tap(find.byKey(const ValueKey('command_filter_status')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('W toku').last);
    await tester.pumpAndSettle();
    expect(tasks.queries.last.status, ProjectTaskStatus.inProgress.name);

    // Wiersz poleceń przewija się poziomo, więc przycisk może być poza kadrem.
    await tester.ensureVisible(
      find.byKey(const ValueKey('command_clear_filters')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('command_clear_filters')));
    await tester.pumpAndSettle();

    expect(tasks.queries.last.status, isNull);
    expect(find.byKey(const ValueKey('command_clear_filters')), findsNothing);
  });

  testWidgets('sortowanie zapisuje pole w preferencjach listy', (tester) async {
    final preferences = _FakePreferencesRepository();
    await _pumpChrome(
      tester,
      tasks: _FakeTasksRepository(),
      preferences: preferences,
      metadata: _FakeMetadataRepository(),
    );

    await tester.tap(find.byKey(const ValueKey('command_sort')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Priorytet').last);
    await tester.pumpAndSettle();

    expect(preferences.saves, isNotEmpty);
    expect(preferences.saves.last.sortField, TaskSavedViewSortField.priority);
  });

  testWidgets('wiersz poleceń przewija się poziomo bez overflow', (
    tester,
  ) async {
    await _pumpChrome(
      tester,
      tasks: _FakeTasksRepository(),
      preferences: _FakePreferencesRepository(),
      metadata: _FakeMetadataRepository(),
      width: 640,
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsWidgets);
    expect(find.byKey(const ValueKey('command_columns')), findsOneWidget);
  });

  testWidgets('zaznaczenie przełącza wiersz na pasek akcji masowych', (
    tester,
  ) async {
    final tasks = _FakeTasksRepository();
    TaskListChrome? chrome;
    await _pumpChrome(
      tester,
      tasks: tasks,
      preferences: _FakePreferencesRepository(),
      metadata: _FakeMetadataRepository(),
      onChrome: (value) => chrome = value,
    );
    expect(chrome?.showBulkBar, isFalse);

    chrome!.listCubit!.toggleSelection('task-1');
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('bulk_status')), findsOneWidget);
    expect(find.text('Wybrano: 1'), findsOneWidget);
    expect(find.byKey(const ValueKey('command_columns')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('bulk_status')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('W toku').last);
    await tester.pumpAndSettle();

    expect(tasks.updates, isNotEmpty);
    expect(tasks.updates.last.status, ProjectTaskStatus.inProgress);
  });
}
