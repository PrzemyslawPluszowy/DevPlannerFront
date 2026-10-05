import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_subtasks.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_parent_navigation_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

final class _Tasks extends Mock implements TasksRepository {}

final class _Acceptance extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _Checklist extends Mock implements TaskChecklistRepository {}

const _workspace = '11111111-1111-4111-8111-111111111111';
const _project = '22222222-2222-4222-8222-222222222222';
const _parent = '33333333-3333-4333-8333-333333333333';
const _child = '44444444-4444-4444-8444-444444444444';
const _path = '/workspaces/$_workspace/projects/$_project/tasks';

void main() {
  testWidgets(
    'opening a subtask resets the tab and keeps board and return context',
    (
      tester,
    ) async {
      final cubit = TaskDetailsCubit(
        repository: _Tasks(),
        acceptanceCriteriaRepository: _Acceptance(),
        checklistRepository: _Checklist(),
        workspaceId: _workspace,
        projectId: _project,
        taskId: _parent,
      );
      addTearDown(cubit.close);
      final initial = Uri(
        path: _path,
        queryParameters: {
          'task': _parent,
          'taskTab': 'history',
          'taskReturn': '/me/tasks',
          'view': 'kanban',
          'filter': 'mine',
        },
      );
      final router = GoRouter(
        initialLocation: initial.toString(),
        routes: [
          GoRoute(
            path: _path,
            builder: (_, _) => BlocProvider.value(
              value: cubit,
              child: const Scaffold(
                body: SubtasksSection(
                  isSaving: true,
                  subtasks: [
                    ProjectTaskSubtaskSummaryResponse(
                      id: _child,
                      number: 2,
                      key: 'TASK-2',
                      title: 'Child task',
                      status: ProjectTaskStatus.todo,
                      priority: TaskPriority.normal,
                      version: 1,
                    ),
                    ProjectTaskSubtaskSummaryResponse(
                      id: 'custom-child',
                      number: 3,
                      key: 'TASK-3',
                      title: 'Review child',
                      status: ProjectTaskStatus.inProgress,
                      priority: TaskPriority.normal,
                      version: 1,
                      customStatusName: 'Weryfikacja',
                      customStatusId: 'custom-status',
                      customStatusColor: '#123ABC',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: MaterialTheme.crm().light(),
        ),
      );
      final labels = AppLocalizations.of(
        tester.element(find.byType(SubtasksSection)),
      )!;
      expect(find.text('TASK-2 · ${labels.taskStatusTodo}'), findsOneWidget);
      expect(find.text('TASK-3 · Weryfikacja'), findsOneWidget);
      await tester.tap(find.text('Child task'));
      await tester.pumpAndSettle();

      final uri = router.routerDelegate.currentConfiguration.uri;
      expect(uri.path, _path);
      expect(uri.queryParameters['task'], _child);
      expect(uri.queryParameters['taskTab'], isNull);
      expect(uri.queryParameters['taskReturn'], '/me/tasks');
      expect(uri.queryParameters['view'], 'kanban');
      expect(uri.queryParameters['filter'], 'mine');
      expect(tester.takeException(), isNull);
    },
  );

  for (final enabled in [true, false]) {
    testWidgets('parent navigation enabled=$enabled preserves context', (
      tester,
    ) async {
      final initial = Uri(
        path: _path,
        queryParameters: {
          'task': _child,
          'taskTab': 'history',
          'taskReturn': '/me/tasks',
          'view': 'kanban',
          'filter': 'mine',
        },
      );
      final router = GoRouter(
        initialLocation: initial.toString(),
        routes: [
          GoRoute(
            path: _path,
            builder: (_, _) => Scaffold(
              body: TaskParentNavigationLink(
                workspaceId: _workspace,
                projectId: _project,
                parentTaskId: _parent,
                enabled: enabled,
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: MaterialTheme.crm().light(),
        ),
      );
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed == null, !enabled);
      if (enabled) await tester.tap(find.text('Parent task'));
      await tester.pumpAndSettle();
      final uri = router.routerDelegate.currentConfiguration.uri;
      expect(uri.queryParameters['task'], enabled ? _parent : _child);
      expect(uri.queryParameters['taskTab'], enabled ? isNull : 'history');
      expect(uri.queryParameters['taskReturn'], '/me/tasks');
      expect(uri.queryParameters['view'], 'kanban');
      expect(uri.queryParameters['filter'], 'mine');
      expect(tester.takeException(), isNull);
    });
  }

  for (final invalidReturn in [
    '/admin',
    'https://foreign.example',
    '/me/tasks,/admin',
  ]) {
    test('subtask intent drops unsupported return $invalidReturn', () {
      final uri = Uri.parse(
        const TaskDetailOpenIntent(
          workspaceId: _workspace,
          projectId: _project,
          taskId: _child,
          source: TaskDetailOpenSource.subtask,
        ).toLocation(
          currentLocation: Uri(
            path: _path,
            queryParameters: {'taskReturn': invalidReturn},
          ),
        ),
      );
      expect(uri.queryParameters['taskReturn'], isNull);
    });
  }
}
