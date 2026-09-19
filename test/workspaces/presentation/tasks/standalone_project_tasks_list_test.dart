import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/standalone/project_tasks_list_standalone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
  const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';

  setUpAll(() {
    registerFallbackValue(const ProjectTasksGroupedQuery());
  });

  testWidgets('renders the typed empty state from the project task gateway', (
    tester,
  ) async {
    final repository = _MockTasksRepository();
    when(
      () => repository.listProjectTaskGroups(
        workspaceId: workspaceId,
        projectId: projectId,
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async => right(
        const ProjectTaskGroupedListResponse(
          totalCount: 0,
          groupBy: TaskSavedViewGroupBy.status,
          groups: [],
        ),
      ),
    );

    await tester.pumpWidget(
      _LocalizedApp(
        child: StandaloneProjectTasksList(
          repository: repository,
          workspaceId: workspaceId,
          projectId: projectId,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Brak zadań spełniających wybrane filtry.'),
      findsOneWidget,
    );
    verify(
      () => repository.listProjectTaskGroups(
        workspaceId: workspaceId,
        projectId: projectId,
        query: any(named: 'query'),
      ),
    ).called(1);
  });

  testWidgets('renders the typed forbidden state and keeps retry available', (
    tester,
  ) async {
    final repository = _MockTasksRepository();
    when(
      () => repository.listProjectTaskGroups(
        workspaceId: workspaceId,
        projectId: projectId,
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.forbidden,
          statusCode: 403,
          message: 'Brak uprawnień do projektu.',
        ),
      ),
    );

    await tester.pumpWidget(
      _LocalizedApp(
        child: StandaloneProjectTasksList(
          repository: repository,
          workspaceId: workspaceId,
          projectId: projectId,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Brak uprawnień do projektu.'), findsOneWidget);
    expect(find.text('Spróbuj ponownie'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
  });
}

final class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

final class _MockTasksRepository extends Mock implements TasksRepository {}
