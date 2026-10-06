import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_navigation_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_collaboration.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../../../../test_support/task_detail_visual_fixture.dart';
import '../../../../../../test_support/tasks_board_route_fixture.dart';

const _taskId = '550e8400-e29b-41d4-a716-446655440002';

void main() {
  setUpAll(registerTasksBoardRouteFallbacks);

  testWidgets('same task resnapshots a replaced profiles repository', (
    tester,
  ) async {
    final firstRepository = _ProjectMemberProfilesRepositoryMock();
    final nextRepository = _ProjectMemberProfilesRepositoryMock();
    final repository = ValueNotifier<ProjectMemberProfilesRepository>(
      firstRepository,
    );
    addTearDown(repository.dispose);
    final router = GoRouter(
      initialLocation: '/tasks?task=$_taskId',
      routes: [
        GoRoute(
          path: '/tasks',
          builder: (context, state) => ValueListenableBuilder(
            valueListenable: repository,
            builder: (context, activeRepository, _) =>
                TaskDetailModalNavigationHost(
                  workspaceId: 'ws-1',
                  projectId: 'project-1',
                  taskId: state.uri.queryParameters['task'],
                  detailsComposition: null,
                  memberProfilesRepository: activeRepository,
                  child: const Text('Board'),
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
      ),
    );
    await tester.pumpAndSettle();
    var contentContext = tester.element(
      find.byType(TaskDetailModalUnavailableContent),
    );
    expect(
      Provider.of<ProjectMemberProfilesRepository>(
        contentContext,
        listen: false,
      ),
      same(firstRepository),
    );

    repository.value = nextRepository;
    await tester.pumpAndSettle();
    contentContext = tester.element(
      find.byType(TaskDetailModalUnavailableContent),
    );
    expect(
      Provider.of<ProjectMemberProfilesRepository>(
        contentContext,
        listen: false,
      ),
      same(nextRepository),
    );
  });

  testWidgets(
    'root assignee dialog receives profiles port captured from board scope',
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
      expect(find.byTooltip(l10n.taskDetailsEditAssignees), findsOneWidget);
      await tester.tap(find.byTooltip(l10n.taskDetailsEditAssignees));
      await _pumpUntil(tester, find.byType(EditAssigneesDialog));
      await _pumpUntil(tester, find.text('Marta Nowak'));

      expect(find.byType(EditAssigneesDialog), findsOneWidget);
      expect(
        Provider.of<ProjectMemberProfilesRepository>(
          tester.element(find.byType(EditAssigneesDialog)),
          listen: false,
        ),
        same(fixture.memberProfilesRepository),
      );
      expect(find.text('Marta Nowak'), findsWidgets);
      expect(tester.takeException(), isNull);
      verify(
        () => fixture.memberProfilesRepository.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
          forceRefresh: true,
        ),
      ).called(greaterThanOrEqualTo(1)); // Rail omija cache; timer może odświeżyć ponownie.
    },
  );
}

Future<void> _pumpUntil(WidgetTester tester, Finder target) async {
  for (var frame = 0; frame < 30; frame++) {
    if (target.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(target, findsOneWidget);
}

final class _ProjectMemberProfilesRepositoryMock extends Mock
    implements ProjectMemberProfilesRepository {}
