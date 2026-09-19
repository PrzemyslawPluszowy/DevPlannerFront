import 'package:devplanner/admin/data/adapters/admin_user_api_transport.dart';
import 'package:devplanner/admin/data/adapters/admin_user_gateway_api_adapter.dart';
import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/presentation/admin_users_page.dart';
import 'package:devplanner/app/shell/devplanner_shell.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/auth/presentation/auth_route_page.dart';
import 'package:devplanner/foundation/http/http.dart';
import 'package:devplanner/me/me.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_list_api.dart';
import 'package:devplanner/workspaces/data/projects/repositories/projects_gateway_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_views_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_view_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/data/standalone/project_management_gateway.dart';
import 'package:devplanner/workspaces/data/standalone/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/data/standalone/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/data/standalone/workspaces_gateway.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/file_picker_port_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:devplanner/workspaces/domain/ports/project_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/devplanner_workspaces_page.dart';
import 'package:devplanner/workspaces/presentation/private/private_pages.dart';
import 'package:devplanner/workspaces/presentation/projects/workspace_projects_page.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_file_details_page.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_workspace_files_route_page.dart';
import 'package:devplanner/workspaces/presentation/storage/public_share/storage_public_share_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/tasks_details_route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'devplanner_router_pages.part.dart';

/// Standalone route boundary for the DevPlanner application.
class DevPlannerRouter with _DevPlannerRouterPages {
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
    ProjectManagementGateway? projectManagementGateway,
    StorageRepository? storageRepository,
    TaskViewRepository? taskViewRepository,
    TasksBoardComposition? tasksBoardComposition,
    TasksDetailsComposition? tasksDetailsComposition,
  }) : _auth = auth ?? AuthComposition.unavailable(),
       _explicitAdminUsers = adminUsers,
       _explicitMeGateway = meGateway,
       _explicitWorkspacesGateway = workspacesGateway,
       _explicitProjectsGateway = projectsGateway,
       _explicitWorkspaceNavigationGateway = workspaceNavigationGateway,
       _explicitWorkspaceManagementGateway = workspaceManagementGateway,
       _explicitProjectManagementGateway = projectManagementGateway,
       _explicitStorageRepository = storageRepository,
       _explicitTaskViewRepository = taskViewRepository,
       _explicitTasksBoardComposition = tasksBoardComposition,
       _explicitTasksDetailsComposition = tasksDetailsComposition,
       _ownsAuth = auth == null {
    _authGuard = DevPlannerAuthGuard(session: _auth.session);
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
          builder: (_, state) => _publicShareRoutePage(state),
        ),
        ShellRoute(
          builder: (context, _, child) => DevPlannerShellRoute(
            workspaceNavigationGateway: _resolvedWorkspaceNavigationGateway,
            workspaceManagementGateway: _resolvedWorkspaceManagementGateway,
            projectManagementGateway: _resolvedProjectManagementGateway,
            projectsGateway: _resolvedProjectsGateway,
            tasksBoardAvailable: _resolvedTasksBoardComposition != null,
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/workspaces',
              builder: (context, _) => DevPlannerWorkspacesPage(
                gateway: _resolvedWorkspacesGateway,
                onOpenWorkspace: (workspaceId) => context.go(
                  DevPlannerRouteCatalog.workspace(workspaceId),
                ),
              ),
            ),
            GoRoute(
              path: '/workspaces/:workspaceId',
              builder: (_, state) => _workspaceProjectsRoutePage(state),
            ),
            GoRoute(
              path: '/workspaces/:workspaceId/files',
              builder: _workspaceFilesRoutePage,
            ),
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/files',
              builder: _projectFilesRoutePage,
            ),
            // Wcześniejszy router traktował adres projektu jako punkt wejścia
            // do jego zasobów. W standalone lista Tasks jest pierwszym
            // ukończonym widokiem projektu, więc zachowujemy link bez
            // wprowadzania pustego dashboardu projektu.
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId',
              redirect: (_, state) => _projectRootRedirect(state),
            ),
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/tasks',
              builder: (_, state) => _tasksBoardRoutePage(state),
            ),
            // Zachowujemy adres używany przez wcześniejsze menu Workspace.
            // Kanban i lista są dziś dwoma widokami jednego kontraktu Tasks,
            // dlatego historyczna ścieżka ma jeden kanoniczny odpowiednik,
            // zamiast równoległej implementacji ekranu.
            GoRoute(
              path: '/workspaces/:workspaceId/projects/:projectId/kanban',
              redirect: (_, state) => _legacyKanbanRedirect(state),
            ),
            GoRoute(
              path:
                  '/workspaces/:workspaceId/projects/:projectId/tasks/:taskId',
              builder: (_, state) => _tasksDetailsRoutePage(state),
            ),
            GoRoute(
              path: DevPlannerRouteCatalog.myFiles,
              builder: (context, _) => _storageBrowserRoutePage(
                const StorageScope.personal(),
                onOpenFileDetails: (fileId) =>
                    _openFileDetails(context, fileId),
              ),
            ),
            GoRoute(
              path: '/storage/files/:fileId',
              builder: (_, state) => _storageFileDetailsRoutePage(state),
            ),
            GoRoute(
              path: DevPlannerRouteCatalog.myTasks,
              builder: (_, _) => _myTasksRoutePage(),
            ),
            GoRoute(
              path: '/me',
              builder: (_, _) => UserProfilePage(gateway: meGateway),
            ),
            GoRoute(
              path: '/admin',
              builder: (_, _) => _adminUsersRoutePage(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  final AuthComposition _auth;
  @override
  final AdminUsersComposition? _explicitAdminUsers;
  @override
  final MeGateway? _explicitMeGateway;
  final WorkspacesGateway? _explicitWorkspacesGateway;
  final ProjectsGateway? _explicitProjectsGateway;
  final WorkspaceNavigationGateway? _explicitWorkspaceNavigationGateway;
  final WorkspaceManagementGateway? _explicitWorkspaceManagementGateway;
  final ProjectManagementGateway? _explicitProjectManagementGateway;
  final StorageRepository? _explicitStorageRepository;
  final TaskViewRepository? _explicitTaskViewRepository;
  final TasksBoardComposition? _explicitTasksBoardComposition;
  final TasksDetailsComposition? _explicitTasksDetailsComposition;
  @override
  final DevPlannerHttpTransport? httpTransport;
  final bool _ownsAuth;
  late final DevPlannerAuthGuard _authGuard;
  late final GoRouter _router;

  WorkspacesGateway? get _resolvedWorkspacesGateway {
    final explicit = _explicitWorkspacesGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : DevPlannerWorkspacesGateway(transport: transport);
  }

  WorkspaceNavigationGateway? get _resolvedWorkspaceNavigationGateway {
    final explicit = _explicitWorkspaceNavigationGateway;
    if (explicit != null) return explicit;
    final workspaces = _resolvedWorkspacesGateway;
    return workspaces == null
        ? null
        : DevPlannerWorkspaceNavigationGateway(
            workspacesGateway: workspaces,
          );
  }

  WorkspaceManagementGateway? get _resolvedWorkspaceManagementGateway {
    final explicit = _explicitWorkspaceManagementGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return DevPlannerWorkspaceManagementGateway(transport: transport);
  }

  ProjectManagementGateway? get _resolvedProjectManagementGateway {
    final explicit = _explicitProjectManagementGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return DevPlannerProjectManagementGateway(transport: transport);
  }

  @override
  ProjectsGateway? get _resolvedProjectsGateway {
    final explicit = _explicitProjectsGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : ProjectsGatewayImpl(
            api: DevPlannerProjectsListApi(transport: transport),
          );
  }

  @override
  StorageRepository? get _resolvedStorageRepository {
    final explicit = _explicitStorageRepository;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return StorageRepositoryImpl(
      StorageApi(transport.apiDio, baseUrl: transport.baseUrl),
    );
  }

  /// Składa wyłącznie prywatny widok zadań. Nie wymaga repozytoriów Kanban
  /// ani fabryki SignalR, bo endpoint `/me/tasks` jest cursorowym odczytem
  /// bieżącego użytkownika.
  @override
  TaskViewRepository? get _resolvedTaskViewRepository {
    final explicit = _explicitTaskViewRepository;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return TaskViewRepositoryImpl(
      TaskViewsApi(transport.apiDio, baseUrl: transport.baseUrl),
    );
  }

  @override
  TasksBoardComposition? get _resolvedTasksBoardComposition {
    final explicit = _explicitTasksBoardComposition;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : TasksBoardComposition.fromTransport(transport);
  }

  @override
  TasksDetailsComposition? get _resolvedTasksDetailsComposition {
    final explicit = _explicitTasksDetailsComposition;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : TasksDetailsComposition.fromTransport(transport);
  }

  GoRouter get config => _router;

  void dispose() {
    _router.dispose();
    if (_ownsAuth) _auth.session.dispose();
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    return _authGuard.redirectFor(state.uri);
  }
}

/// Loads the authoritative local identity before exposing admin affordances.
///
/// The backend `/me` response is the only production source for the current
/// local `userId` and permissions. A missing/invalid response remains
/// unavailable rather than being replaced by launch context or auth claims.
final class _AdminUsersMeBootstrapPage extends StatefulWidget {
  const _AdminUsersMeBootstrapPage({
    required this.meGateway,
    required this.adminTransport,
  });

  final MeGateway meGateway;
  final AdminUserApiTransport adminTransport;

  @override
  State<_AdminUsersMeBootstrapPage> createState() =>
      _AdminUsersMeBootstrapPageState();
}

final class _AdminUsersMeBootstrapPageState
    extends State<_AdminUsersMeBootstrapPage> {
  late final Future<AdminUsersComposition?> _composition = _loadComposition();

  Future<AdminUsersComposition?> _loadComposition() async {
    try {
      final profile = await widget.meGateway.getProfile();
      final userId = profile.userId.trim();
      if (userId.isEmpty) return null;
      return AdminUsersComposition(
        gateway: AdminUserGatewayApiAdapter(transport: widget.adminTransport),
        currentUserId: userId,
        permissions: profile.permissions,
      );
    } catch (_) {
      // Do not turn a failed `/me` call into guessed identity or permissions.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminUsersComposition?>(
      future: _composition,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final composition = snapshot.data;
        return composition == null
            ? const AdminUsersUnavailablePage()
            : AdminUsersPage(composition: composition);
      },
    );
  }
}

/// Stan jawny dla bezpośredniego adresu workspace'u bez poprawnego kontekstu.
///
/// Nie kierujemy błędnego URL na pusty ekran ani nie wykonujemy żądania pod
/// niezweryfikowanym identyfikatorem.
final class _WorkspaceProjectsUnavailablePage extends StatelessWidget {
  const _WorkspaceProjectsUnavailablePage();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'Nie można otworzyć projektów tej przestrzeni roboczej.',
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

/// Central auth boundary. It preserves the requested standalone path without
/// accepting arbitrary schemes, hosts or legacy route names.
class DevPlannerAuthGuard {
  const DevPlannerAuthGuard({required this.session});

  final AuthSessionPort session;

  String? redirectFor(Uri location) {
    if (DevPlannerRouteCatalog.isPublicSharePath(location.path)) {
      return null;
    }
    final isAuthRoute = DevPlannerRouteCatalog.authPaths.contains(
      location.path,
    );
    if (location.path == '/') {
      return null;
    }
    if (isAuthRoute && !session.snapshot.isAuthenticated) return null;
    if (isAuthRoute && location.path == '/login') {
      return AuthReturnTo.sanitize(location.queryParameters['returnTo']) ??
          '/workspaces';
    }
    if (session.snapshot.isAuthenticated &&
        DevPlannerRouteCatalog.isStandalonePath(location.path)) {
      return null;
    }

    final returnTo = Uri(
      path: location.path,
      query: location.query.isEmpty ? null : location.query,
      fragment: location.fragment.isEmpty ? null : location.fragment,
    ).toString();
    return '/login?returnTo=${Uri.encodeComponent(returnTo)}';
  }
}

/// Route inventory owned by DevPlanner. Unimplemented feature paths are absent
/// instead of being presented as placeholder screens.
abstract final class DevPlannerRouteCatalog {
  static const workspaces = '/workspaces';

  static const authPaths = <String>[
    '/login',
    '/auth/activate',
    '/auth/reset',
    '/auth/mfa',
  ];

  static const topLevelPaths = <String>[
    '/workspaces',
    '/me',
    '/admin',
  ];

  static const publicSharePrefix = '/storage/public/';
  static const storageFileDetailsPrefix = '/storage/files/';

  /// Canonical nested Workspaces paths used by presentation widgets.
  ///
  /// These builders keep identifiers in the URL contract without exposing a
  /// router implementation to feature widgets.
  static String workspace(String workspaceId) =>
      '/workspaces/${Uri.encodeComponent(workspaceId)}';

  static String workspaceFiles(String workspaceId) =>
      '${workspace(workspaceId)}/files';

  /// Sprawdza kanoniczny UUID wymagany przez workspace-scoped backend route.
  static bool isUuid(String value) => RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  ).hasMatch(value);

  static String project(String workspaceId, String projectId) =>
      '${workspace(workspaceId)}/projects/${Uri.encodeComponent(projectId)}';

  static String projectTasks(String workspaceId, String projectId) =>
      '${project(workspaceId, projectId)}/tasks';

  static String projectFiles(String workspaceId, String projectId) =>
      '${project(workspaceId, projectId)}/files';

  /// Kanoniczny szczegół pliku, pozostający w globalnym shellu standalone.
  static String storageFileDetails(String fileId) =>
      '$storageFileDetailsPrefix${Uri.encodeComponent(fileId)}';

  static String projectKanban(String workspaceId, String projectId) =>
      '${projectTasks(workspaceId, projectId)}?view=kanban';

  static String task(String workspaceId, String projectId, String taskId) =>
      '${projectTasks(workspaceId, projectId)}/${Uri.encodeComponent(taskId)}';

  static String projectResource(
    String workspaceId,
    String projectId,
    String resourceKind,
  ) => '${project(workspaceId, projectId)}/$resourceKind';

  static String projectResourceItem(
    String workspaceId,
    String projectId,
    String resourceKind,
    String resourceId,
  ) =>
      '${projectResource(workspaceId, projectId, resourceKind)}/${Uri.encodeComponent(resourceId)}';

  static const myTasks = '/me/tasks';
  static const myFiles = '/me/files';

  static String safeInitialLocation(String? value) {
    final uri = Uri.tryParse(value?.trim() ?? '');
    final path = uri?.path ?? '';
    if (!isStandalonePath(path) && !authPaths.contains(path)) return '/';

    // `?view=kanban` jest częścią kontraktu trasy, a nie stanem widgetu.
    // Zachowanie query jest konieczne dla desktopowego deep linku i restartu
    // aplikacji; fragment nie należy do kontraktu GoRoutera.
    return uri!.hasQuery ? '$path?${uri.query}' : path;
  }

  static bool isStandalonePath(String path) {
    return topLevelPaths.any(
          (candidate) => path == candidate || path.startsWith('$candidate/'),
        ) ||
        isPublicSharePath(path) ||
        isStorageFileDetailsPath(path);
  }

  static bool isPublicSharePath(String path) {
    final token = path.startsWith(publicSharePrefix)
        ? path.substring(publicSharePrefix.length)
        : '';
    return token.isNotEmpty && !token.contains('/');
  }

  static bool isStorageFileDetailsPath(String path) {
    final fileId = path.startsWith(storageFileDetailsPrefix)
        ? path.substring(storageFileDetailsPrefix.length)
        : '';
    return isUuid(fileId);
  }
}
