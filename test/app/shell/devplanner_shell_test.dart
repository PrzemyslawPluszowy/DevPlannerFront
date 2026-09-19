import 'package:devplanner/app/shell/devplanner_shell.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('renders desktop shell geometry and collapsible sidebar', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const DevPlannerShellRoute(
            child: Text('route content'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_LocalizedRouter(router));
    await tester.pumpAndSettle();

    expect(find.text('route content'), findsOneWidget);
    expect(find.text('DevPlanner'), findsOneWidget);
    expect(find.byTooltip('Notifications'), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-topbar'))).height,
      64,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-sidebar'))).width,
      256,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-content-margin'))),
      const Size(768, 704),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-content-canvas'))),
      const Size(744, 680),
    );

    await tester.tap(find.byTooltip('Collapse menu'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-sidebar'))).width,
      72,
    );
    expect(find.byTooltip('Expand menu'), findsOneWidget);
  });

  testWidgets('keeps route selection and content after navigating in shell', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: '/workspaces',
      routes: [
        ShellRoute(
          builder: (_, _, child) => DevPlannerShellRoute(child: child),
          routes: [
            GoRoute(
              path: '/workspaces',
              builder: (_, _) => const Text('workspaces content'),
            ),
            GoRoute(
              path: '/me',
              builder: (_, _) => const Text('profile content'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_LocalizedRouter(router));
    await tester.pumpAndSettle();

    expect(find.text('workspaces content'), findsOneWidget);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();

    expect(find.text('profile content'), findsOneWidget);
    expect(find.text('Settings'), findsNWidgets(2));
    expect(
      find.byKey(const ValueKey('devplanner-content-canvas')),
      findsOneWidget,
    );
  });

  testWidgets('renders the clean navigation tree from injected ports', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: '/workspaces',
      routes: [
        GoRoute(
          path: '/workspaces',
          builder: (_, _) => DevPlannerShellRoute(
            workspaceNavigationGateway: _WorkspaceGateway(),
            projectsGateway: _ProjectsGateway(),
            child: const Text('workspace content'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_LocalizedRouter(router));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('navigation-node-workspace:alpha')),
        matching: find.byIcon(Icons.chevron_right),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey('navigation-node-workspace:alpha:projects'),
        ),
        matching: find.byIcon(Icons.chevron_right),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(
        const ValueKey('navigation-node-workspace:alpha:project:project-a'),
      ),
      findsOneWidget,
    );
    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey('navigation-node-workspace:alpha:project:project-a'),
        ),
        matching: find.byIcon(Icons.chevron_right),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey(
            'navigation-node-workspace:alpha:project:project-a:tasks',
          ),
        ),
        matching: find.byIcon(Icons.chevron_right),
      ),
    );
    await tester.pumpAndSettle();
    final kanbanNode = find.byKey(
      const ValueKey(
        'navigation-node-workspace:alpha:project:project-a:tasks:kanban',
      ),
    );
    expect(kanbanNode, findsOneWidget);
    expect(find.text('Whiteboards'), findsOneWidget);
    expect(find.text('Corkboard'), findsOneWidget);
    expect(find.text('Wiki'), findsOneWidget);
    expect(find.text('Files and documents'), findsAtLeastNWidgets(1));
  });

  testWidgets('publishes injected projects gateway for descendant routes', (
    tester,
  ) async {
    final gateway = _ProjectsGateway();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => DevPlannerShellRoute(
            projectsGateway: gateway,
            child: Builder(
              builder: (context) => Text(
                identical(context.read<ProjectsGateway>(), gateway)
                    ? 'projects gateway available'
                    : 'wrong projects gateway',
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_LocalizedRouter(router));
    await tester.pumpAndSettle();

    expect(find.text('projects gateway available'), findsOneWidget);
  });
}

final class _LocalizedRouter extends StatelessWidget {
  const _LocalizedRouter(this.router);

  final GoRouter router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
  );
}

final class _WorkspaceGateway implements WorkspaceNavigationGateway {
  @override
  Future<List<WorkspaceSummary>> listWorkspaces() async => const [
    WorkspaceSummary(
      id: 'alpha',
      name: 'Alpha',
      isPinned: true,
      isHidden: false,
      isOwner: true,
    ),
  ];
}

final class _ProjectsGateway implements ProjectsGateway {
  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) async => const [
    ProjectListItem(
      id: 'project-a',
      workspaceId: 'alpha',
      name: 'Project Alpha',
    ),
  ];
}
