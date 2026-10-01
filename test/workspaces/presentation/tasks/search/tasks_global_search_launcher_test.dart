import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements TaskViewRepository {}

void main() {
  for (final mode in ['replacement', 'disposal', 'current']) {
    testWidgets(
      'result navigation respects owner scope: $mode',
      (tester) async {
        final source = ValueNotifier<TaskViewRepository?>(_Repository());
        addTearDown(source.dispose);
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => ValueListenableBuilder<TaskViewRepository?>(
                valueListenable: source,
                builder: (_, repository, _) => repository == null
                    ? const SizedBox.shrink()
                    : TasksGlobalSearchLauncher(repository: repository),
              ),
            ),
            GoRoute(
              path: '/workspaces/:w/projects/:p/tasks',
              builder: (_, _) => const Text('Task opened'),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
            theme: MaterialTheme.crm().light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
        await tester.tap(
          find.byKey(const ValueKey('tasks-global-search-launcher')),
        );
        await tester.pumpAndSettle();
        final dialog = tester.widget<TasksGlobalSearchDialog>(
          find.byType(TasksGlobalSearchDialog),
        );
        final owner = tester
            .element(find.byType(TasksGlobalSearchDialog))
            .read<TasksGlobalSearchCubit>();
        if (mode != 'current') {
          source.value = mode == 'disposal' ? null : _Repository();
        }
        await tester.pump();
        dialog.onOpenTask(_item);
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          mode == 'current' ? '/workspaces/w/projects/p/tasks' : '/',
        );
        expect(
          find.text('Task opened'),
          mode == 'current' ? findsOneWidget : findsNothing,
        );
        if (mode == 'current') {
          expect(
            router.routeInformationProvider.value.uri.queryParameters['task'],
            'task-1',
          );
        }
        // A stale dialog can still be dismissed, releasing its owned Cubit.
        if (find.byType(TasksGlobalSearchDialog).evaluate().isNotEmpty) {
          Navigator.of(tester.element(find.byType(TasksGlobalSearchDialog)))
              .pop();
          await tester.pumpAndSettle();
        }
        expect(owner.isClosed, isTrue);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}

final _item = GlobalTaskSearchItemResponse(
  id: 'task-1',
  number: 1,
  key: 'DP-1',
  workspaceId: 'w',
  workspaceName: 'Workspace',
  projectId: 'p',
  projectName: 'Project',
  title: 'Task',
  matchedLabels: const [],
  score: 1,
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);
