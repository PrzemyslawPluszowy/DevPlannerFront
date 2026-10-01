import 'package:devplanner/admin/data/adapters/admin_user_api_transport.dart';
import 'package:devplanner/admin/data/adapters/admin_user_gateway_api_adapter.dart';
import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/presentation/admin_users_page.dart';
import 'package:devplanner/app/router/devplanner_route_catalog.dart';
import 'package:devplanner/app/router/devplanner_router_dependencies.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/foundation/http/http.dart';
import 'package:devplanner/me/me.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/file_picker_port_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/storage_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/private/private_pages.dart';
import 'package:devplanner/workspaces/presentation/projects/workspace_projects_page.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_file_details_page.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_workspace_files_route_page.dart';
import 'package:devplanner/workspaces/presentation/storage/public_share/storage_public_share_page.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Buduje widoki tras z jawnie przekazanych, typowanych zależności.
///
/// Router zachowuje odpowiedzialność za konfigurację tras i lifecycle sesji;
/// fabryka składa wyłącznie strony oraz historyczne przekierowania widoków.
final class DevPlannerRouterPages {
  DevPlannerRouterPages({
    required this.auth,
    required this.explicitAdminUsers,
    required this.explicitMeGateway,
    required this.dependencies,
  });

  final AuthComposition auth;
  final AdminUsersComposition? explicitAdminUsers;
  final MeGateway? explicitMeGateway;
  final DevPlannerRouterDependencies dependencies;

  DevPlannerHttpTransport? get httpTransport => dependencies.httpTransport;
  ProjectsGateway? get _resolvedProjectsGateway =>
      dependencies.resolvedProjectsGateway;
  StorageRepository? get _resolvedStorageRepository =>
      dependencies.resolvedStorageRepository;
  StorageViewPreferenceStore get _resolvedStorageViewPreferenceStore =>
      dependencies.filesViewPreferenceStore;
  StorageUserDirectoryPort? get _resolvedStorageUserDirectory =>
      dependencies.resolvedStorageUserDirectory;
  StorageRealtimeClientFactory? get _resolvedStorageRealtimeClientFactory =>
      dependencies.resolvedStorageRealtimeClientFactory;
  TaskViewRepository? get _resolvedTaskViewRepository =>
      dependencies.resolvedTaskViewRepository;
  TasksBoardComposition? get _resolvedTasksBoardComposition =>
      dependencies.resolvedTasksBoardComposition;
  TasksDetailsComposition? get _resolvedTasksDetailsComposition =>
      dependencies.resolvedTasksDetailsComposition;
  ProjectSettingsComposition? get _resolvedProjectSettingsComposition =>
      dependencies.resolvedProjectSettingsComposition;
  TasksProjectViewPreferenceStore get _resolvedTasksViewPreferenceStore =>
      dependencies.tasksViewPreferenceStore;

  Widget workspaceFilesRoutePage(BuildContext context, GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId)) {
      return const StorageWorkspaceFilesUnavailablePage(
        failure: StorageWorkspaceFilesRouteFailure.invalidWorkspaceId,
      );
    }
    return _storageBrowserRoutePage(
      StorageScope.workspace(workspaceId),
      onOpenFileDetails: (fileId) => _openFileDetails(context, fileId),
    );
  }

  Widget projectFilesRoutePage(BuildContext context, GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId)) {
      return const StorageWorkspaceFilesUnavailablePage(
        failure: StorageWorkspaceFilesRouteFailure.invalidWorkspaceId,
      );
    }
    return _storageBrowserRoutePage(
      StorageScope.project(workspaceId: workspaceId, projectId: projectId),
      onOpenFileDetails: (fileId) => _openFileDetails(context, fileId),
    );
  }

  Widget _storageBrowserRoutePage(
    StorageScope scope, {
    required ValueChanged<String> onOpenFileDetails,
  }) {
    final repository = _resolvedStorageRepository;
    if (repository == null) {
      return const StorageWorkspaceFilesUnavailablePage(
        failure: StorageWorkspaceFilesRouteFailure.repositoryUnavailable,
      );
    }
    final desktopComposition = _desktopStorageUploadComposition;
    return StorageShellPage(
      initialScope: scope,
      storageRepository: repository,
      capabilities: desktopComposition
          ? StorageShellCapabilities.desktop
          : StorageShellCapabilities.readOnly,
      filePicker: desktopComposition ? const FilePickerPortImpl() : null,
      uploadTransport: desktopComposition ? PresignedUploadTransport() : null,
      downloadTransport: desktopComposition
          ? const DownloadTransportImpl()
          : null,
      viewPreferenceStore: _resolvedStorageViewPreferenceStore,
      userDirectory: _resolvedStorageUserDirectory,
      realtimeClientFactory: _resolvedStorageRealtimeClientFactory,
      onOpenFileDetails: onOpenFileDetails,
    );
  }

  Widget storageFileDetailsRoutePage(GoRouterState state) {
    final fileId = state.pathParameters['fileId'] ?? '';
    final repository = _resolvedStorageRepository;
    if (!DevPlannerRouteCatalog.isUuid(fileId) || repository == null) {
      return const StorageWorkspaceFilesUnavailablePage(
        failure: StorageWorkspaceFilesRouteFailure.repositoryUnavailable,
      );
    }
    return StorageFileDetailsPage(repository: repository, fileId: fileId);
  }

  void _openFileDetails(BuildContext context, String fileId) {
    if (!DevPlannerRouteCatalog.isUuid(fileId)) return;
    context.go(DevPlannerRouteCatalog.storageFileDetails(fileId));
  }

  Widget workspaceProjectsRoutePage(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final gateway = _resolvedProjectsGateway;
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) || gateway == null) {
      return const _WorkspaceProjectsUnavailablePage();
    }
    return RepositoryProvider<ProjectsGateway>.value(
      value: gateway,
      child: WorkspaceProjectsPageView(workspaceId: workspaceId),
    );
  }

  Widget publicShareRoutePage(GoRouterState state) {
    final shareToken = state.pathParameters['shareToken']?.trim() ?? '';
    final repository = _resolvedStorageRepository;
    if (shareToken.isEmpty || repository == null) {
      return const StoragePublicShareUnavailablePage();
    }
    return StoragePublicSharePage(
      shareToken: shareToken,
      repository: repository,
    );
  }

  Widget myTasksRoutePage() {
    final repository = _resolvedTaskViewRepository;
    if (repository == null) return const TasksBoardTransportUnavailablePage();
    return RepositoryProvider<TaskViewRepository>.value(
      value: repository,
      child: const PersonalSectionPage(section: 'tasks'),
    );
  }

  Widget myFilesRoutePage(BuildContext context) => _storageBrowserRoutePage(
    const StorageScope.personal(),
    onOpenFileDetails: (fileId) => _openFileDetails(context, fileId),
  );

  bool get _desktopStorageUploadComposition {
    final transport = httpTransport;
    return transport != null &&
        !transport.isBffCookieTransport &&
        transport.supportsStandaloneApiClients;
  }

  Widget tasksBoardRoutePage(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId)) {
      return const TasksBoardTransportUnavailablePage();
    }
    final composition = _resolvedTasksBoardComposition;
    if (composition == null) return const TasksBoardTransportUnavailablePage();
    final projectSettings = _resolvedProjectSettingsComposition;
    if (projectSettings == null) {
      return const TasksBoardTransportUnavailablePage();
    }
    final requestedTaskId = state.uri.queryParameters['task'];
    final taskId =
        requestedTaskId != null &&
            DevPlannerRouteCatalog.isUuid(requestedTaskId)
        ? requestedTaskId
        : null;
    final detailsComposition = taskId == null
        ? null
        : _resolvedTasksDetailsComposition;
    return TasksBoardRoutePage(
      composition: composition,
      projectSettings: projectSettings,
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      detailsComposition: detailsComposition,
      authSession: auth.session,
      initialView: state.uri.queryParameters['view'],
      viewPreferenceStore: _resolvedTasksViewPreferenceStore,
    );
  }

  String legacyTasksViewRedirect(GoRouterState state, String view) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId)) {
      return DevPlannerRouteCatalog.workspaces;
    }
    return DevPlannerRouteCatalog.projectTasksView(
      workspaceId,
      projectId,
      view,
    );
  }

  String legacyKanbanRedirect(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId)) {
      return DevPlannerRouteCatalog.workspaces;
    }
    return DevPlannerRouteCatalog.projectKanban(workspaceId, projectId);
  }

  String projectRootRedirect(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId)) {
      return DevPlannerRouteCatalog.workspaces;
    }
    return DevPlannerRouteCatalog.projectTasks(workspaceId, projectId);
  }

  MeGateway? get meGateway {
    final explicit = explicitMeGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : MeApiAdapter(transport: transport.asMeTransport);
  }

  Widget adminUsersRoutePage() {
    final explicit = explicitAdminUsers;
    if (explicit != null) return AdminUsersPage(composition: explicit);

    final transport = httpTransport;
    final gateway = meGateway;
    final adminTransport = transport?.asAdminTransport;
    final session = auth.session.snapshot;
    if (!session.isAuthenticated ||
        session.clientKind != AuthClientKind.webBff ||
        transport == null ||
        !transport.isBffCookieTransport ||
        gateway == null ||
        adminTransport == null) {
      return const AdminUsersUnavailablePage();
    }
    return _AdminUsersMeBootstrapPage(
      meGateway: gateway,
      adminTransport: adminTransport,
    );
  }
}

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
      return null;
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<AdminUsersComposition?>(
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
