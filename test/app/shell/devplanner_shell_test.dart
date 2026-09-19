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
    final logoFinder = find.byKey(
      const ValueKey('devplanner-sidebar-brand-logo'),
    );
    final toggleFinder = find.byKey(
      const ValueKey('devplanner-toggle-sidebar'),
    );
    final logo = tester.widget<Image>(logoFinder);
    expect(logo.image, isA<AssetImage>());
    expect(logo.semanticLabel, 'DevPlanner');
    // Logotyp dzieli wiersz belki z przyciskiem menu: zajmuje wolną szerokość
    // po lewej, a przycisk domyka ten sam wiersz po prawej.
    expect(
      tester.getTopRight(logoFinder).dx,
      tester.getTopLeft(toggleFinder).dx,
    );
    expect(
      tester.getTopLeft(toggleFinder).dx,
      greaterThan(tester.getTopLeft(logoFinder).dx),
    );
    expect(
      tester.widget<Text>(find.text('Settings')).style?.fontSize,
      12,
    );
    expect(find.byTooltip('Notifications'), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-topbar'))).height,
      56,
    );
    expect(
      tester.getSize(
        find.byKey(const ValueKey('devplanner-sidebar-header')),
      ),
      const Size(224, 56),
    );
    expect(
      tester
          .getTopLeft(
            find.byKey(const ValueKey('devplanner-sidebar-header')),
          )
          .dy,
      0,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('devplanner-topbar'))).dy,
      0,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-topbar'))).width,
      800,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-sidebar'))).width,
      224,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-content-margin'))),
      const Size(800, 712),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-content-canvas'))),
      const Size(776, 688),
    );

    await tester.tap(find.byTooltip('Collapse menu'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('devplanner-sidebar'))).width,
      56,
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
    // Projekt pokazuje wyłącznie pozycje z aktywną trasą: Lista, Kanban i Pliki.
    expect(find.text('List'), findsOneWidget);
    expect(find.text('Files and documents'), findsAtLeastNWidgets(1));
    expect(find.text('Whiteboards'), findsNothing);
    expect(find.text('Corkboard'), findsNothing);
    expect(find.text('Wiki'), findsNothing);
    expect(find.text('Automations'), findsNothing);
  });

  testWidgets('selects the Tasks view that the URL actually opens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: _kanbanLocation,
      routes: [
        ShellRoute(
          builder: (_, _, child) => DevPlannerShellRoute(
            workspaceNavigationGateway: _UuidWorkspaceGateway(),
            projectsGateway: _UuidProjectsGateway(),
            tasksBoardAvailable: true,
            child: child,
          ),
          routes: [
            GoRoute(
              path: _tasksPath,
              builder: (_, _) => const Text('tasks content'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_LocalizedRouter(router));
    await tester.pumpAndSettle();
    await _expandProjectBranch(tester);

    // Kanban jest zaznaczony, bo to jego adres otworzył shell.
    expect(_labelWeight(tester, 'Kanban'), FontWeight.w600);
    expect(_labelWeight(tester, 'List'), FontWeight.w400);

    router.go(_tasksPath);
    await tester.pumpAndSettle();

    expect(_labelWeight(tester, 'List'), FontWeight.w600);
    expect(_labelWeight(tester, 'Kanban'), FontWeight.w400);

    router.go('$_tasksPath?view=list');
    await tester.pumpAndSettle();

    // `?view=list` musi zaznaczać Listę, a nie gubić zaznaczenia.
    expect(_labelWeight(tester, 'List'), FontWeight.w600);
    expect(_labelWeight(tester, 'Kanban'), FontWeight.w400);
  });

  testWidgets('opens the Tasks List when the project row is clicked', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: '/workspaces',
      routes: [
        ShellRoute(
          builder: (_, _, child) => DevPlannerShellRoute(
            workspaceNavigationGateway: _UuidWorkspaceGateway(),
            projectsGateway: _UuidProjectsGateway(),
            tasksBoardAvailable: true,
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/workspaces',
              builder: (_, _) => const Text('workspaces content'),
            ),
            GoRoute(
              path: _tasksPath,
              builder: (_, _) => const Text('tasks content'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_LocalizedRouter(router));
    await tester.pumpAndSettle();
    await _expandProjectBranch(tester);

    await tester.tap(find.text('Project A'));
    await tester.pumpAndSettle();

    expect(find.text('tasks content'), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      _tasksPath,
    );
  });

  testWidgets('na wąskim oknie drzewo jest osiągalne w nakładce', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: '/workspaces',
      routes: [
        ShellRoute(
          builder: (_, _, child) => DevPlannerShellRoute(
            workspaceNavigationGateway: _WorkspaceGateway(),
            projectsGateway: _ProjectsGateway(),
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/workspaces',
              builder: (_, _) => const Text('workspaces content'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_LocalizedRouter(router));
    await tester.pumpAndSettle();

    // Compact shell zwija pasek do ikon, więc drzewo nie jest widoczne...
    expect(find.byTooltip('Expand menu'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);

    // ...ale ten sam klawisz otwiera je w nakładce z pełnym drzewem.
    await tester.tap(find.byTooltip('Expand menu'));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.byTooltip('Collapse menu'), findsOneWidget);

    // Ponowne kliknięcie zamyka nakładkę i wraca do paska ikonowego.
    await tester.tap(find.byTooltip('Collapse menu'));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsNothing);
    expect(find.byTooltip('Expand menu'), findsOneWidget);
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

/// Rozwija gałąź projektu tylko tam, gdzie shell nie zrobił tego sam.
///
/// Węzły przodków bieżącej trasy rozwijają się automatycznie, więc helper
/// sprawdza stan chevronu zamiast przełączać go w ciemno.
Future<void> _expandProjectBranch(WidgetTester tester) async {
  for (final id in const [
    'workspace:$workspaceId',
    'workspace:$workspaceId:projects',
    'workspace:$workspaceId:project:$projectId',
    'workspace:$workspaceId:project:$projectId:tasks',
  ]) {
    final chevron = find.descendant(
      of: find.byKey(ValueKey<String>('navigation-node-$id')),
      matching: find.byIcon(Icons.chevron_right),
    );
    if (chevron.evaluate().isEmpty) continue;
    await tester.tap(chevron);
    await tester.pumpAndSettle();
  }
}

/// Waga etykiety wiersza drzewa jest kontraktem zaznaczenia shella.
FontWeight? _labelWeight(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style?.fontWeight;

const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
const _tasksPath = '/workspaces/$workspaceId/projects/$projectId/tasks';
const _kanbanLocation = '$_tasksPath?view=kanban';

final class _UuidWorkspaceGateway implements WorkspaceNavigationGateway {
  @override
  Future<List<WorkspaceSummary>> listWorkspaces() async => const [
    WorkspaceSummary(
      id: workspaceId,
      name: 'Projektowy',
      isPinned: true,
      isHidden: false,
      isOwner: true,
    ),
  ];
}

final class _UuidProjectsGateway implements ProjectsGateway {
  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) async => [
    ProjectListItem(
      id: projectId,
      workspaceId: workspaceId,
      name: 'Project A',
    ),
  ];
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
