import 'dart:async';

import 'package:devplanner/foundation/http/http.dart';
import 'package:devplanner/workspaces/data/preferences/shared_preferences_storage_view_store.dart';
import 'package:devplanner/workspaces/data/preferences/shared_preferences_tasks_project_view_store.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_list_api.dart';
import 'package:devplanner/workspaces/data/projects/repositories/projects_gateway_impl.dart';
import 'package:devplanner/workspaces/data/projects/repositories/projects_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_views_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_view_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/data/realtime/storage/storage_realtime_composition.dart';
import 'package:devplanner/workspaces/data/standalone/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/data/standalone/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/data/standalone/workspaces_gateway.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/storage_user_directory_adapter.dart';
import 'package:devplanner/workspaces/data/workspaces/api/workspaces_api.dart';
import 'package:devplanner/workspaces/data/workspaces/repositories/workspaces_repository_impl.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/storage_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';

/// Resolves typed route dependencies and owns per-user view preference loads.
final class DevPlannerRouterDependencies {
  DevPlannerRouterDependencies({
    required this.httpTransport,
    required WorkspacesGateway? workspacesGateway,
    required ProjectsGateway? projectsGateway,
    required WorkspaceNavigationGateway? workspaceNavigationGateway,
    required WorkspaceManagementGateway? workspaceManagementGateway,
    required StorageRepository? storageRepository,
    required TaskViewRepository? taskViewRepository,
    required TasksBoardComposition? tasksBoardComposition,
    required TasksDetailsComposition? tasksDetailsComposition,
    required ProjectSettingsComposition? projectSettingsComposition,
    required TasksProjectViewPreferenceStore? tasksViewPreferenceStore,
    required StorageViewPreferenceStore? filesViewPreferenceStore,
    required this.currentUserId,
  }) : _explicitWorkspacesGateway = workspacesGateway,
       _explicitProjectsGateway = projectsGateway,
       _explicitWorkspaceNavigationGateway = workspaceNavigationGateway,
       _explicitWorkspaceManagementGateway = workspaceManagementGateway,
       _explicitStorageRepository = storageRepository,
       _explicitTaskViewRepository = taskViewRepository,
       resolvedTasksBoardComposition =
           tasksBoardComposition ??
           (httpTransport == null
               ? null
               : TasksBoardComposition.fromTransport(httpTransport)),
       resolvedTasksDetailsComposition =
           tasksDetailsComposition ??
           (httpTransport == null
               ? null
               : TasksDetailsComposition.fromTransport(httpTransport)),
       resolvedProjectSettingsComposition =
           projectSettingsComposition ??
           (httpTransport == null
               ? null
               : ProjectSettingsComposition.fromTransport(httpTransport)),
       _explicitTasksViewPreferenceStore = tasksViewPreferenceStore,
       _explicitFilesViewPreferenceStore = filesViewPreferenceStore;

  final DevPlannerHttpTransport? httpTransport;
  final WorkspacesGateway? _explicitWorkspacesGateway;
  final ProjectsGateway? _explicitProjectsGateway;
  final WorkspaceNavigationGateway? _explicitWorkspaceNavigationGateway;
  final WorkspaceManagementGateway? _explicitWorkspaceManagementGateway;
  final StorageRepository? _explicitStorageRepository;
  final TaskViewRepository? _explicitTaskViewRepository;

  /// Query changes keep the same repositories and mounted task modal.
  final TasksBoardComposition? resolvedTasksBoardComposition;
  final TasksDetailsComposition? resolvedTasksDetailsComposition;
  final ProjectSettingsComposition? resolvedProjectSettingsComposition;
  final TasksProjectViewPreferenceStore? _explicitTasksViewPreferenceStore;
  final StorageViewPreferenceStore? _explicitFilesViewPreferenceStore;
  final String? Function() currentUserId;
  String? _viewPreferenceUserId;

  late final TasksProjectViewPreferenceStore tasksViewPreferenceStore =
      _explicitTasksViewPreferenceStore ??
      SharedPreferencesTasksProjectViewStore(currentUserId: currentUserId);
  late final StorageViewPreferenceStore filesViewPreferenceStore =
      _explicitFilesViewPreferenceStore ??
      SharedPreferencesStorageViewStore(currentUserId: currentUserId);

  WorkspacesGateway? get resolvedWorkspacesGateway {
    final explicit = _explicitWorkspacesGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : DevPlannerWorkspacesGateway(transport: transport);
  }

  WorkspaceNavigationGateway? get resolvedWorkspaceNavigationGateway {
    final explicit = _explicitWorkspaceNavigationGateway;
    if (explicit != null) return explicit;
    final workspaces = resolvedWorkspacesGateway;
    return workspaces == null
        ? null
        : DevPlannerWorkspaceNavigationGateway(workspacesGateway: workspaces);
  }

  WorkspaceManagementGateway? get resolvedWorkspaceManagementGateway {
    final explicit = _explicitWorkspaceManagementGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return DevPlannerWorkspaceManagementGateway(transport: transport);
  }

  ProjectsRepository? get resolvedShellProjectsRepository {
    final transport = httpTransport;
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return ProjectsRepositoryImpl(
      api: ProjectsApi(transport.apiDio, baseUrl: transport.baseUrl),
    );
  }

  ProjectsGateway? get resolvedProjectsGateway {
    final explicit = _explicitProjectsGateway;
    if (explicit != null) return explicit;
    final transport = httpTransport;
    return transport == null
        ? null
        : ProjectsGatewayImpl(
            api: DevPlannerProjectsListApi(transport: transport),
          );
  }

  StorageRepository? get resolvedStorageRepository {
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

  TaskViewRepository? get resolvedTaskViewRepository {
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

  StorageUserDirectoryPort? get resolvedStorageUserDirectory {
    final transport = httpTransport;
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return StorageUserDirectoryAdapter(
      WorkspacesRepositoryImpl(
        api: WorkspacesApi(transport.apiDio, baseUrl: transport.baseUrl),
      ),
    );
  }

  StorageRealtimeClientFactory? get resolvedStorageRealtimeClientFactory =>
      storageRealtimeClientFactory(httpTransport);

  void loadPreferencesForInitialUser() {
    _viewPreferenceUserId = currentUserId();
    unawaited(tasksViewPreferenceStore.load());
    unawaited(filesViewPreferenceStore.load());
  }

  void reloadPreferencesIfUserChanged() {
    final userId = currentUserId();
    if (userId == _viewPreferenceUserId) return;
    _viewPreferenceUserId = userId;
    unawaited(tasksViewPreferenceStore.load());
    unawaited(filesViewPreferenceStore.load());
  }
}
