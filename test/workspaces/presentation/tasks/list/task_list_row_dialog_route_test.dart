import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MemberProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}

void main() {
  testWidgets('wiersz w dialogu używa parametrów aktywnej trasy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/workspaces/workspace-1/projects/project-1/tasks',
      routes: [
        GoRoute(
          path: '/workspaces/:workspaceId/projects/:projectId/tasks',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => Dialog(
                    child: SizedBox(
                      width: 1100,
                      child: TaskListRow(
                        task: ProjectTaskListItemResponse(
                          id: 'task-1',
                          number: 1,
                          key: 'TASK-1',
                          title: 'Zadanie w dialogu',
                          status: ProjectTaskStatus.todo,
                          priority: TaskPriority.normal,
                          assignees: const [],
                          checklistCompletedCount: 0,
                          checklistTotalCount: 0,
                          updatedAtUtc: DateTime.utc(2026, 10),
                          version: 1,
                        ),
                        memberProfilesByUserId: const {},
                        columns: const [
                          TaskSavedViewColumn.key,
                          TaskSavedViewColumn.title,
                        ],
                      ),
                    ),
                  ),
                ),
                child: const Text('Otwórz'),
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      RepositoryProvider<ProjectMemberProfilesRepository>.value(
        value: _MemberProfilesRepository(),
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Otwórz'));
    await tester.pumpAndSettle();

    expect(find.text('Zadanie w dialogu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
