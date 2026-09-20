part of 'devplanner_router.dart';

/// Buduje strony realnych tras standalone bez mieszania ich z konfiguracją
/// guardów, katalogiem adresów i lifecycle `GoRouter`.
mixin _DevPlannerRouterPages {
  AuthComposition get _auth;
  AdminUsersComposition? get _explicitAdminUsers;
  MeGateway? get _explicitMeGateway;
  DevPlannerHttpTransport? get httpTransport;
  ProjectsGateway? get _resolvedProjectsGateway;
  StorageRepository? get _resolvedStorageRepository;
  TaskViewRepository? get _resolvedTaskViewRepository;
  TasksBoardComposition? get _resolvedTasksBoardComposition;
  TasksDetailsComposition? get _resolvedTasksDetailsComposition;
  ProjectSettingsComposition? get _resolvedProjectSettingsComposition;
  TasksProjectViewPreferenceStore get _resolvedTasksViewPreferenceStore;

  Widget _workspaceFilesRoutePage(BuildContext context, GoRouterState state) {
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

  Widget _projectFilesRoutePage(BuildContext context, GoRouterState state) {
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
    final desktopUpload = _desktopStorageUploadComposition;
    return StorageReadOnlyBrowserPage(
      repository: repository,
      initialScope: scope,
      filePicker: desktopUpload ? const FilePickerPortImpl() : null,
      uploadTransport: desktopUpload ? PresignedUploadTransport() : null,
      downloadTransport: desktopUpload ? const DownloadTransportImpl() : null,
      allowDownload: desktopUpload,
      allowVersionManagement: desktopUpload,
      allowSharing: desktopUpload,
      allowFolderCreation: desktopUpload,
      allowFolderRename: desktopUpload,
      allowDeletion: desktopUpload,
      onOpenFileDetails: onOpenFileDetails,
    );
  }

  Widget _storageFileDetailsRoutePage(GoRouterState state) {
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

  Widget _workspaceProjectsRoutePage(GoRouterState state) {
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

  Widget _publicShareRoutePage(GoRouterState state) {
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

  Widget _myTasksRoutePage() {
    final repository = _resolvedTaskViewRepository;
    if (repository == null) return const TasksBoardTransportUnavailablePage();
    return RepositoryProvider<TaskViewRepository>.value(
      value: repository,
      child: const PersonalSectionPage(section: 'tasks'),
    );
  }

  /// Upload presigned jest składany wyłącznie dla desktopowego klienta,
  /// który ma bezpieczne źródło Bearera. Web BFF pozostaje read-only w Files:
  /// cookie/CSRF nie może udawać standalone API dla bezpośredniego PUT.
  bool get _desktopStorageUploadComposition {
    final transport = httpTransport;
    return transport != null &&
        !transport.isBffCookieTransport &&
        transport.supportsStandaloneApiClients;
  }

  Widget _tasksBoardRoutePage(GoRouterState state) {
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
    return TasksBoardRoutePage(
      composition: composition,
      projectSettings: projectSettings,
      workspaceId: workspaceId,
      projectId: projectId,
      authSession: _auth.session,
      initialView: state.uri.queryParameters['view'],
      viewPreferenceStore: _resolvedTasksViewPreferenceStore,
    );
  }

  /// Historyczny adres widoku modułu Zadania prowadzi do jednej kanonicznej
  /// trasy z jawnym `?view=`, bez drugiej implementacji ekranu.
  String _legacyTasksViewRedirect(GoRouterState state, String view) {
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

  String _legacyKanbanRedirect(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId)) {
      return DevPlannerRouteCatalog.workspaces;
    }
    return DevPlannerRouteCatalog.projectKanban(workspaceId, projectId);
  }

  String _projectRootRedirect(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId)) {
      return DevPlannerRouteCatalog.workspaces;
    }
    return DevPlannerRouteCatalog.projectTasks(workspaceId, projectId);
  }

  Widget _tasksDetailsRoutePage(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    final taskId = state.pathParameters['taskId'] ?? '';
    if (!DevPlannerRouteCatalog.isUuid(workspaceId) ||
        !DevPlannerRouteCatalog.isUuid(projectId) ||
        !DevPlannerRouteCatalog.isUuid(taskId)) {
      return const TasksBoardTransportUnavailablePage();
    }
    final composition = _resolvedTasksDetailsComposition;
    if (composition == null) return const TasksBoardTransportUnavailablePage();
    return TasksDetailsRoutePage(
      composition: composition,
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );
  }

  /// Zwraca wyłącznie jawną kompozycję podaną przez hosta/test.
  ///
  /// Produkcyjna trasa buduje composition asynchronicznie dopiero po odczycie
  /// `/me`; synchroniczny fallback z launch contextu lub sesji auth byłby
  /// niewystarczająco autorytatywny dla administracji.
  AdminUsersComposition? get adminUsers => _explicitAdminUsers;

  /// Zwraca bramę profilu i sesji użytkownika.
  ///
  /// Jeśli nie przekazano jawnej bramy, tworzy instancję [MeApiAdapter]
  /// zasilaną przez [httpTransport].
  MeGateway? get meGateway {
    final explicit = _explicitMeGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : MeApiAdapter(transport: transport.asMeTransport);
  }

  Widget _adminUsersRoutePage() {
    final explicit = _explicitAdminUsers;
    if (explicit != null) return AdminUsersPage(composition: explicit);

    final transport = httpTransport;
    final gateway = meGateway;
    final adminTransport = transport?.asAdminTransport;
    final session = _auth.session.snapshot;

    // `/admin` must never compose from launch context, AuthUser claims or a
    // desktop bearer transport. Until a verified BFF session and `/me` are
    // present, fail closed with no substitute data.
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
