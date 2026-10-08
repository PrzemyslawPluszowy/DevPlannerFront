import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_schedule_repository_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dependency_dialogs.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_properties.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_properties_planning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../test_support/task_detail_visual_fixture.dart';
import '../../../../../../test_support/tasks_board_route_fixture.dart';

void main() {
  setUpAll(registerTasksBoardRouteFallbacks);
  testWidgets('root task dependency dialog has a project-scoped search port', (
    tester,
  ) async {
    final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
    addTearDown(fixture.dispose);
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = fixture.boardFixture.composition.viewRepository;
    when(
      () => repository.searchTasks(
        query: 'QA',
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        limit: 20,
      ),
    ).thenAnswer(
      (_) async => const Right(
        CursorPageResponse<GlobalTaskSearchItemResponse>(items: []),
      ),
    );
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: fixture.router.config,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: MaterialTheme.crm().light(),
        builder: (context, child) => DevPlannerGlobalPanelsHost(
          navigation: DevPlannerNavigation(fixture.router.config),
          authSession: fixture.authSession,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    await _pumpUntil(tester, find.byType(TaskProperties));
    expect(
      tester.element(find.byType(TaskProperties)).read<TaskViewRepository>(),
      same(repository),
    );
    final l10n = AppLocalizations.of(
      tester.element(find.byType(TaskProperties)),
    )!;
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byTooltip(l10n.taskDetailsAddDependency),
      180,
      scrollable: find
          .descendant(
            of: find.byKey(const PageStorageKey<String>('task-details-work')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byTooltip(l10n.taskDetailsAddDependency));
    await _pumpUntil(tester, find.byType(CreateDependencyDialog));
    final search = find
        .descendant(
          of: find.byType(CreateDependencyDialog),
          matching: find.byType(TextField),
        )
        .first;
    await tester.enterText(search, 'QA');
    await tester.pumpAndSettle();
    expect(find.text(l10n.taskDetailsDependencySearchEmpty), findsOneWidget);
    verify(
      () => repository.searchTasks(
        query: 'QA',
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        limit: 20,
      ),
    ).called(1);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'root planning dialog receives schedule port captured from task scope',
    (tester) async {
      final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
      addTearDown(fixture.dispose);
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: fixture.router.config,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: MaterialTheme.crm().light(),
          darkTheme: MaterialTheme.crm().dark(),
          builder: (context, child) => DevPlannerGlobalPanelsHost(
            navigation: DevPlannerNavigation(fixture.router.config),
            authSession: fixture.authSession,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      );
      await _pumpUntil(tester, find.byType(TaskProperties));
      expect(find.byType(TaskProperties), findsOneWidget);

      final l10n = AppLocalizations.of(
        tester.element(find.byType(Scaffold).first),
      )!;
      expect(find.byTooltip(l10n.taskDetailsEditPlanning), findsOneWidget);
      final scheduleRepository = tester
          .element(find.byType(TaskProperties))
          .read<TaskScheduleRepository>();
      await tester.tap(find.byTooltip(l10n.taskDetailsEditPlanning));
      await _pumpUntil(tester, find.byType(EditPlanningDialog));

      expect(find.byType(EditPlanningDialog), findsOneWidget);
      final dialogContext = tester.element(find.byType(EditPlanningDialog));
      expect(
        dialogContext.read<TaskScheduleRepository>(),
        same(scheduleRepository),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('new root dialog captures replaced schedule repository', (
    tester,
  ) async {
    final first = _ScheduleRepositoryMock();
    final next = _ScheduleRepositoryMock();
    final repository = ValueNotifier<TaskScheduleRepository>(first);
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ValueListenableBuilder<TaskScheduleRepository>(
          valueListenable: repository,
          builder: (context, value, _) =>
              RepositoryProvider<TaskScheduleRepository>.value(
                value: value,
                child: TaskDetailScheduleRepositoryScope(
                  repository: value,
                  child: const _OpenScopeDialog(),
                ),
              ),
        ),
      ),
    );
    await tester.tap(find.text('Open planning'));
    await tester.pumpAndSettle();
    expect(
      tester
          .element(find.byKey(const Key('schedule-dialog')))
          .read<TaskScheduleRepository>(),
      same(first),
    );
    await tester.tap(find.text('Close planning'));
    await tester.pumpAndSettle();
    repository.value = next;
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open planning'));
    await tester.pumpAndSettle();
    expect(
      tester
          .element(find.byKey(const Key('schedule-dialog')))
          .read<TaskScheduleRepository>(),
      same(next),
    );
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpUntil(WidgetTester tester, Finder target) async {
  for (var frame = 0; frame < 30; frame++) {
    if (target.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(target, findsOneWidget);
}

final class _ScheduleRepositoryMock extends Mock
    implements TaskScheduleRepository {}

final class _OpenScopeDialog extends StatelessWidget {
  const _OpenScopeDialog();

  void _open(BuildContext context) {
    unawaited(
      DevPlannerModalHost.showDialog<void>(
        context,
        builder: (dialogContext) => AlertDialog(
          key: const Key('schedule-dialog'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close planning'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => _open(context),
      child: const Text('Open planning'),
    ),
  );
}
