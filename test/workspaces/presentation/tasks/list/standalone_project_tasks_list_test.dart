import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/standalone/project_tasks_list_standalone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeTasksRepository implements TasksRepository {
  _FakeTasksRepository(this._loader, {this.creationResult});

  final Future<Either<ApiError, ProjectTaskGroupedListResponse>> Function(
    String workspaceId,
    String projectId,
    ProjectTasksGroupedQuery query,
  )
  _loader;

  String? lastWorkspaceId;
  String? lastProjectId;
  ProjectTasksGroupedQuery? lastQuery;
  final Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  Function(
    String workspaceId,
    String projectId,
    QuickCreateProjectTaskPayload payload,
  )?
  creationResult;
  int createCalls = 0;
  QuickCreateProjectTaskPayload? lastCreatePayload;

  @override
  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  }) {
    lastWorkspaceId = workspaceId;
    lastProjectId = projectId;
    lastQuery = query;
    return _loader(workspaceId, projectId, query);
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  }) {
    createCalls++;
    lastCreatePayload = payload;
    final result = creationResult;
    if (result != null) return result(workspaceId, projectId, payload);
    return Future.value(
      Right<ApiError, TaskMutationResponse<ProjectTaskResponse>>(
        _createdMutation(payload.title),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _Harness extends StatelessWidget {
  const _Harness({required this.repository});

  final TasksRepository repository;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: StandaloneProjectTasksList(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders loading then a real task row with scoped ids', (
    tester,
  ) async {
    final completer =
        Completer<Either<ApiError, ProjectTaskGroupedListResponse>>();
    final repository = _FakeTasksRepository((_, _, _) => completer.future);

    await tester.pumpWidget(_Harness(repository: repository));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(_readyResult);
    await tester.pumpAndSettle();

    expect(find.text('DP-17'), findsOneWidget);
    expect(find.text('Przygotować listę zadań'), findsOneWidget);
    expect(repository.lastWorkspaceId, 'workspace-1');
    expect(repository.lastProjectId, 'project-1');
    expect(repository.lastQuery?.groupBy, 'Status');
  });

  testWidgets('renders the backend-backed empty boundary', (tester) async {
    final repository = _FakeTasksRepository(
      (_, _, _) async => const Right<ApiError, ProjectTaskGroupedListResponse>(
        ProjectTaskGroupedListResponse(
          totalCount: 0,
          groupBy: TaskSavedViewGroupBy.status,
          groups: [],
        ),
      ),
    );

    await tester.pumpWidget(_Harness(repository: repository));
    await tester.pumpAndSettle();

    expect(
      find.text('Brak zadań spełniających wybrane filtry.'),
      findsOneWidget,
    );
  });

  testWidgets('renders typed forbidden failure without pretending success', (
    tester,
  ) async {
    final repository = _FakeTasksRepository(
      (_, _, _) async => const Left<ApiError, ProjectTaskGroupedListResponse>(
        ApiError(
          type: ApiErrorType.forbidden,
          statusCode: 403,
          message: 'Brak dostępu do projektu',
        ),
      ),
    );

    await tester.pumpWidget(_Harness(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Brak dostępu do projektu'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.text('Brak zadań spełniających wybrane filtry.'), findsNothing);
  });

  testWidgets('requires a title before sending create request', (tester) async {
    final repository = _FakeTasksRepository(
      (_, _, _) async => _readyResult,
    );

    await tester.pumpWidget(_Harness(repository: repository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Utwórz'));
    await tester.pump();

    expect(find.text('Tytuł zadania jest wymagany.'), findsOneWidget);
    expect(repository.createCalls, 0);
  });

  testWidgets(
    'reconciles only after confirmed create and blocks duplicate submit',
    (
      tester,
    ) async {
      final completer =
          Completer<
            Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>
          >();
      final repository = _FakeTasksRepository(
        (_, _, _) async => const Right(
          ProjectTaskGroupedListResponse(
            totalCount: 0,
            groupBy: TaskSavedViewGroupBy.status,
            groups: [],
          ),
        ),
        creationResult: (_, _, _) => completer.future,
      );

      await tester.pumpWidget(_Harness(repository: repository));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Nowe zadanie');
      await tester.tap(find.text('Utwórz'));
      await tester.pump();
      await tester.tap(find.text('Utwórz'));
      await tester.pump();

      expect(repository.createCalls, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Right(_createdMutation('Nowe zadanie')));
      await tester.pumpAndSettle();

      expect(repository.createCalls, 1);
      expect(find.text('Nowe zadanie'), findsOneWidget);
      expect(find.text('Tytuł zadania jest wymagany.'), findsNothing);
    },
  );

  testWidgets('maps typed create failures to localized messages', (
    tester,
  ) async {
    final cases = <(ApiError, String)>[
      (
        const ApiError(
          type: ApiErrorType.forbidden,
          statusCode: 403,
          message: 'Brak dostępu',
        ),
        'Nie masz uprawnień do utworzenia zadania.',
      ),
      (
        const ApiError(
          type: ApiErrorType.conflict,
          statusCode: 409,
          message: 'Konflikt',
        ),
        'Wystąpił konflikt danych. Odśwież listę i spróbuj ponownie.',
      ),
      (
        const ApiError(
          type: ApiErrorType.validation,
          statusCode: 422,
          message: 'Nieprawidłowe dane',
        ),
        'Dane zadania są nieprawidłowe.',
      ),
    ];

    for (final (error, expectedMessage) in cases) {
      final repository = _FakeTasksRepository(
        (_, _, _) async => _readyResult,
        creationResult: (_, _, _) async => Left(error),
      );
      await tester.pumpWidget(_Harness(repository: repository));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Błędne zadanie');
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();

      expect(find.text(expectedMessage), findsOneWidget);
    }
  });
}

TaskMutationResponse<ProjectTaskResponse> _createdMutation(String title) {
  final response = ProjectTaskResponse(
    id: 'created-task',
    number: 18,
    key: 'DP-18',
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    title: title,
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    taskType: 'Task',
    position: 1000,
    createdByUserId: 'user-1',
    assignees: const [],
    checklistItems: const [],
    createdAtUtc: DateTime.utc(2026, 9, 18),
    updatedAtUtc: DateTime.utc(2026, 9, 18),
    version: 1,
  );
  return TaskMutationResponse(
    taskId: response.id,
    taskVersion: response.version,
    taskUpdatedAtUtc: response.updatedAtUtc,
    data: response,
  );
}

final _readyResult = Right<ApiError, ProjectTaskGroupedListResponse>(
  ProjectTaskGroupedListResponse(
    totalCount: 1,
    groupBy: TaskSavedViewGroupBy.status,
    groups: [
      ProjectTaskListGroupResponse(
        key: 'status:Todo',
        displayName: 'Do zrobienia',
        color: '#2563EB',
        position: 0,
        totalCount: 1,
        items: [
          ProjectTaskListItemResponse(
            id: 'task-17',
            number: 17,
            key: 'DP-17',
            title: 'Przygotować listę zadań',
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.normal,
            assignees: [],
            checklistCompletedCount: 0,
            checklistTotalCount: 0,
            updatedAtUtc: DateTime.utc(2026, 9, 18),
            version: 1,
          ),
        ],
      ),
    ],
  ),
);
