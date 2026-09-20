import 'package:devplanner/app/shell/devplanner_shell.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_project_dialog.dart';
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
    final tasksNode = find.byKey(
      const ValueKey('navigation-node-workspace:alpha:project:project-a:tasks'),
    );
    expect(tasksNode, findsOneWidget);
    // Jeden węzeł Zadania zamiast dwóch gałęzi Lista/Kanban.
    expect(
      find.descendant(of: tasksNode, matching: find.text('Tasks')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: tasksNode, matching: find.byIcon(Icons.chevron_right)),
      findsNothing,
    );
    expect(find.text('List'), findsNothing);
    expect(find.text('Kanban'), findsNothing);
    // Projekt pokazuje wyłącznie pozycje z aktywną trasą: Zadania i Pliki.
    expect(find.text('Files and documents'), findsAtLeastNWidgets(1));
    expect(find.text('Whiteboards'), findsNothing);
    expect(find.text('Corkboard'), findsNothing);
    expect(find.text('Wiki'), findsNothing);
    expect(find.text('Automations'), findsNothing);
  });

  testWidgets('keeps the single Tasks node selected for every module view', (
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

    const tasksNodeId = 'workspace:$workspaceId:project:$projectId:tasks';

    // Moduł Zadania ma jeden wiersz, więc jest zaznaczony niezależnie od tego,
    // który widok modułu (`?view=`) otworzył adres.
    expect(_nodeLabelWeight(tester, tasksNodeId, 'Tasks'), FontWeight.w600);

    router.go(_tasksPath);
    await tester.pumpAndSettle();
    expect(_nodeLabelWeight(tester, tasksNodeId, 'Tasks'), FontWeight.w600);

    router.go('$_tasksPath?view=list');
    await tester.pumpAndSettle();
    expect(_nodeLabelWeight(tester, tasksNodeId, 'Tasks'), FontWeight.w600);

    // Projekt nie podświetla się drugi raz, gdy zaznaczone jest jego dziecko:
    // oba wiersze prowadzą do tego samego adresu modułu.
    expect(
      _nodeLabelWeight(
        tester,
        'workspace:$workspaceId:project:$projectId',
        'Project A',
      ),
      FontWeight.w400,
    );
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

  testWidgets('sidebar opens the same project form as the project tree', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: '/workspaces',
      routes: [
        ShellRoute(
          builder: (_, _, child) => DevPlannerShellRoute(
            workspaceNavigationGateway: _WorkspaceGateway(),
            projectsGateway: _ProjectsGateway(),
            projectsRepository: _StubProjectsRepository(),
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
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('navigation-node-workspace:alpha')),
        matching: find.byIcon(Icons.chevron_right),
      ),
    );
    await tester.pumpAndSettle();

    // Sidebar używa tego samego formularza co drzewo projektów — nie ma już
    // drugiego, uproszczonego dialogu tworzenia projektu.
    await tester.tap(find.byTooltip('New project'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateProjectDialog), findsOneWidget);
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

/// Waga etykiety konkretnego wiersza drzewa.
///
/// Etykiety takie jak „Tasks” występują w drzewie więcej niż raz (sekcja
/// osobista i moduł projektu), więc adresowanie idzie po kluczu wiersza.
FontWeight? _nodeLabelWeight(
  WidgetTester tester,
  String nodeId,
  String label,
) => tester
    .widget<Text>(
      find.descendant(
        of: find.byKey(ValueKey<String>('navigation-node-$nodeId')),
        matching: find.text(label),
      ),
    )
    .style
    ?.fontWeight;

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
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    bool? includeHidden,
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

/// Repozytorium projektów dla shella: test sprawdza wyłącznie, że sidebar
/// otwiera wspólny formularz, więc żadna metoda nie jest wołana.
final class _StubProjectsRepository implements ProjectsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    bool? includeHidden,
  }) async => const [
    ProjectListItem(
      id: 'project-a',
      workspaceId: 'alpha',
      name: 'Project Alpha',
    ),
  ];
}
