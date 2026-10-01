import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/app/router/devplanner_auth_guard.dart';
import 'package:devplanner/app/router/devplanner_route_catalog.dart';
import 'package:devplanner/app/router/devplanner_router_dependencies.dart';
import 'package:devplanner/app/router/devplanner_router_pages.dart';
import 'package:devplanner/app/shell/devplanner_shell.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/presentation/auth_route_page.dart';
import 'package:devplanner/foundation/http/http.dart';
import 'package:devplanner/me/me.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/storage_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/devplanner_workspaces_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_route_policy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'package:devplanner/app/router/devplanner_auth_guard.dart';
export 'package:devplanner/app/router/devplanner_route_catalog.dart';

/// Standalone route boundary for the DevPlanner application.
class DevPlannerRouter {
  DevPlannerRouter({
    String? initialLocation,
    AuthComposition? auth,
    AdminUsersComposition? adminUsers,
    MeGateway? meGateway,
    this.httpTransport,
    WorkspacesGateway? workspacesGateway,
    ProjectsGateway? projectsGateway,
    WorkspaceNavigationGateway? workspaceNavigationGateway,
    WorkspaceManagementGateway? workspaceManagementGateway,
    StorageRepository? storageRepository,
    TaskViewRepository? taskViewRepository,
    TasksBoardComposition? tasksBoardComposition,
    TasksDetailsComposition? tasksDetailsComposition,
    ProjectSettingsComposition? projectSettingsComposition,
    TasksProjectViewPreferenceStore? tasksViewPreferenceStore,
    StorageViewPreferenceStore? filesViewPreferenceStore,
  }) : _auth = auth ?? AuthComposition.unavailable(),
       _explicitAdminUsers = adminUsers,
       _explicitMeGateway = meGateway,
       _ownsAuth = auth == null {
    _dependencies = DevPlannerRouterDependencies(
      httpTransport: httpTransport,
      workspacesGateway: workspacesGateway,
      projectsGateway: projectsGateway,
      workspaceNavigationGateway: workspaceNavigationGateway,
      workspaceManagementGateway: workspaceManagementGateway,
      storageRepository: storageRepository,
      taskViewRepository: taskViewRepository,
      tasksBoardComposition: tasksBoardComposition,
      tasksDetailsComposition: tasksDetailsComposition,
      projectSettingsComposition: projectSettingsComposition,
      tasksViewPreferenceStore: tasksViewPreferenceStore,
      filesViewPreferenceStore: filesViewPreferenceStore,
      currentUserId: () => _auth.session.snapshot.user?.userId,
    );
    _authGuard = DevPlannerAuthGuard(session: _auth.session);
    _dependencies.loadPreferencesForInitialUser();
    _routePages = DevPlannerRouterPages(
      auth: _auth,
      explicitAdminUsers: _explicitAdminUsers,
      explicitMeGateway: _explicitMeGateway,
      dependencies: _dependencies,
    );
    _auth.session.addListener(_reloadViewPreferenceOnUserChange);
    _router = GoRouter(
      initialLocation: DevPlannerRouteCatalog.safeInitialLocation(
        initialLocation,
      ),
      redirect: _redirect,
      refreshListenable: _auth.session,
      routes: [
        GoRoute(path: '/', redirect: (_, _) => '/workspaces'),
        GoRoute(
          path: '/login',
          builder: (_, state) => AuthRoutePage(
            kind: AuthRouteKind.login,
            useCases: _auth.useCases,
            session: _auth.session,
            returnTo: AuthReturnTo.sanitize(
              state.uri.queryParameters['returnTo'],
            ),
          ),
        ),
        GoRoute(
          path: '/auth/activate',
          builder: (_, _) => AuthRoutePage(
            kind: AuthRouteKind.activation,
            useCases: _auth.useCases,
            session: _auth.session,
          ),
        ),
        GoRoute(
          path: '/auth/reset',
          builder: (_, _) => AuthRoutePage(
            kind: AuthRouteKind.reset,
            useCases: _auth.useCases,
            session: _auth.session,
          ),
        ),
        GoRoute(
          path: '/auth/mfa',
          builder: (_, _) => AuthRoutePage(
            kind: AuthRouteKind.mfa,
            useCases: _auth.useCases,
            session: _auth.session,
          ),
        ),
        GoRoute(
          path: '/storage/public/:shareToken',
          builder: (_, state) => _routePages.publicShareRoutePage(state),
        ),
        ShellRoute(
          builder: (context, _, child) => DevPlannerShellRoute(
            workspaceNavigationGateway:
                _dependencies.resolvedWorkspaceNavigationGateway,
            workspaceManagementGateway:
                _dependencies.resolvedWorkspaceManagementGateway,
            projectsRepository: _dependencies.resolvedShellProjectsRepository,
            projectsGateway: _dependencies.resolvedProjectsGateway,
            tasksBoardAvailable:
                _dependencies.resolvedTasksBoardComposition != null,
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/workspaces',
              builder: (context, _) => DevPlannerWorkspacesPage(
                gateway: _dependencies.resolvedWorkspacesGateway,
                onOpenWorkspace: (workspaceId) => context.go(
                  DevPlannerRouteCatalog.workspace(workspaceId),
                ),
              ),
            ),
            GoRoute(
              path: '/workspaces/:workspaceId',
              builder: (_, state) =>
                  _routePages.workspaceProjectsRoutePage(state),
            ),
            GoRoute(
              path: '/workspaces/:workspaceId/files',
              builder: _routePages.workspaceFilesRoutePage,
            ),
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/files',
              builder: _routePages.projectFilesRoutePage,
            ),
            // Wcześniejszy router traktował adres projektu jako punkt wejścia
            // do jego zasobów. W standalone lista Tasks jest pierwszym
            // ukończonym widokiem projektu, więc zachowujemy link bez
            // wprowadzania pustego dashboardu projektu.
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId',
              redirect: (_, state) => _routePages.projectRootRedirect(state),
            ),
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/tasks',
              builder: (_, state) => _routePages.tasksBoardRoutePage(state),
              redirect: (_, state) =>
                  _taskDetailRoutePolicy.invalidTaskQueryRedirect(state),
            ),
            // Historyczne adresy widoków modułu Zadania. Muszą stać przed
            // trasą szczegółu zadania, inaczej `list` zostałoby odczytane jako
            // `taskId` i stary link kończyłby się ekranem braku transportu.
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/tasks/list',
              redirect: (_, state) =>
                  _routePages.legacyTasksViewRedirect(state, 'list'),
            ),
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/tasks/kanban',
              redirect: (_, state) =>
                  _routePages.legacyTasksViewRedirect(state, 'kanban'),
            ),
            // Zachowujemy adres używany przez wcześniejsze menu Workspace.
            // Kanban i lista są dziś dwoma widokami jednego kontraktu Tasks,
            // dlatego historyczna ścieżka ma jeden kanoniczny odpowiednik,
            // zamiast równoległej implementacji ekranu.
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/kanban',
              redirect: (_, state) => _routePages.legacyKanbanRedirect(state),
            ),
            GoRoute(
              path:
                  '/workspaces/:workspaceId/projects/:projectId/tasks/:taskId',
              redirect: (_, state) =>
                  _taskDetailRoutePolicy.legacyTaskRedirect(state),
            ),
            GoRoute(
              path: DevPlannerRouteCatalog.myFiles,
              builder: (context, _) => _routePages.myFilesRoutePage(context),
            ),
            GoRoute(
              path: '/storage/files/:fileId',
              builder: (_, state) =>
                  _routePages.storageFileDetailsRoutePage(state),
            ),
            GoRoute(
              path: DevPlannerRouteCatalog.myTasks,
              builder: (_, _) => _routePages.myTasksRoutePage(),
            ),
            GoRoute(
              path: '/me',
              builder: (_, _) => UserProfilePage(gateway: meGateway),
            ),
            GoRoute(
              path: '/admin',
              builder: (_, _) => _routePages.adminUsersRoutePage(),
            ),
          ],
        ),
      ],
    );
  }

  final AuthComposition _auth;
  final AdminUsersComposition? _explicitAdminUsers;
  final MeGateway? _explicitMeGateway;
  final DevPlannerHttpTransport? httpTransport;
  final bool _ownsAuth;
  final TaskDetailRoutePolicy _taskDetailRoutePolicy = TaskDetailRoutePolicy();
  late final DevPlannerRouterDependencies _dependencies;
  late final DevPlannerAuthGuard _authGuard;
  late final DevPlannerRouterPages _routePages;
  late final GoRouter _router;

  void _reloadViewPreferenceOnUserChange() {
    _dependencies.reloadPreferencesIfUserChanged();
  }

  GoRouter get config => _router;

  void dispose() {
    _auth.session.removeListener(_reloadViewPreferenceOnUserChange);
    _router.dispose();
    if (_ownsAuth) _auth.session.dispose();
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    if (!state.uri.queryParametersAll.containsKey('task')) {
      _taskDetailRoutePolicy.rememberLocation(state.uri);
    }
    return _authGuard.redirectFor(state.uri);
  }
}
