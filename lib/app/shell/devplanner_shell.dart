import 'dart:async';

import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:devplanner/app/theme/theme_preference_cubit.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_node.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_unread_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_tree_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_tree_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/tasks/tasks_project_view_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'devplanner_shell_layout.dart';
part 'devplanner_shell_navigation.dart';
part 'devplanner_shell_navigation_item.dart';

/// Authenticated desktop shell for the standalone DevPlanner routes.
///
/// The shell owns layout state only. Workspace data is supplied by the clean
/// navigation ports and composed by [WorkspaceNavigationTreeCubit].
class DevPlannerShellRoute extends StatefulWidget {
  const DevPlannerShellRoute({
    required this.child,
    this.workspaceNavigationGateway,
    this.workspaceManagementGateway,
    this.projectsRepository,
    this.projectsGateway,
    this.tasksBoardAvailable = false,
    super.key,
  });

  final Widget child;
  final WorkspaceNavigationGateway? workspaceNavigationGateway;
  final WorkspaceManagementGateway? workspaceManagementGateway;

  /// Port tworzenia projektu. Sidebar otwiera dokładnie ten sam formularz co
  /// drzewo projektów, więc nie ma drugiego, uproszczonego flow.
  final ProjectsRepository? projectsRepository;
  final ProjectsGateway? projectsGateway;
  final bool tasksBoardAvailable;

  @override
  State<DevPlannerShellRoute> createState() => _DevPlannerShellRouteState();
}

class _DevPlannerShellRouteState extends State<DevPlannerShellRoute> {
  late final WorkspaceNavigationTreeCubit? _navigationCubit =
      _createNavigationCubit();
  final ValueNotifier<bool> _sidebarCollapsed = ValueNotifier(false);
  final ValueNotifier<bool> _compactTreeOpen = ValueNotifier(false);
  final ValueNotifier<Set<String>> _expandedNavigationNodeIds = ValueNotifier(
    const <String>{},
  );

  WorkspaceNavigationTreeCubit? _createNavigationCubit() {
    final workspaceGateway = widget.workspaceNavigationGateway;
    final projectsGateway = widget.projectsGateway;
    if (workspaceGateway == null || projectsGateway == null) return null;
    final cubit = WorkspaceNavigationTreeCubit(
      workspaceGateway: workspaceGateway,
      projectsGateway: projectsGateway,
    );
    unawaited(cubit.load());
    return cubit;
  }

  @override
  void dispose() {
    final cubit = _navigationCubit;
    if (cubit != null) unawaited(cubit.close());
    _sidebarCollapsed.dispose();
    _compactTreeOpen.dispose();
    _expandedNavigationNodeIds.dispose();
    super.dispose();
  }

  void _toggleNavigationNode(WorkspaceNavigationNode node) {
    final nodeId = node.id;
    final next = Set<String>.of(_expandedNavigationNodeIds.value);
    if (!next.add(nodeId)) next.remove(nodeId);
    _expandedNavigationNodeIds.value = Set<String>.unmodifiable(next);
    if (node.kind == WorkspaceNavigationNodeKind.projects &&
        node.workspaceId != null &&
        next.contains(nodeId)) {
      unawaited(
        _navigationCubit?.loadProjects(node.workspaceId!) ??
            Future<void>.value(),
      );
    }
  }

  Future<void> _createWorkspace(BuildContext context) async {
    final gateway = widget.workspaceManagementGateway;
    final cubit = _navigationCubit;
    if (gateway == null || cubit == null) return;
    await _CreateWorkspaceFromSidebarDialog.show(
      context,
      gateway: gateway,
      onCreated: (workspaceId) async {
        await cubit.load();
        if (!mounted || !context.mounted) return;
        _expandedNavigationNodeIds.value = Set<String>.unmodifiable({
          ..._expandedNavigationNodeIds.value,
          'workspace:$workspaceId',
        });
        context.go(DevPlannerRouteCatalog.workspace(workspaceId));
      },
    );
  }

  Future<void> _createProject(BuildContext context, String workspaceId) async {
    final repository = widget.projectsRepository;
    final cubit = _navigationCubit;
    if (repository == null || cubit == null) return;
    // Ten sam formularz co w drzewie projektów: sidebar nie utrzymuje drugiego,
    // uproszczonego flow tworzenia projektu.
    await ProjectResourceCreationDialogs.showCreateProject(
      context,
      workspaceId: workspaceId,
      repository: repository,
      // Drzewo projektów po utworzeniu odświeża gałąź workspace'u; sidebar robi
      // to samo, żeby oba wejścia kończyły się identycznym stanem nawigacji.
      onCreated: () => cubit.loadProjects(workspaceId, refresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Query jest częścią stanu nawigacji Tasks: `?view=kanban` musi
    // zaznaczać Kanban, a nie ogólną pozycję Lista.
    final location = GoRouterState.of(context).uri.toString();
    return ValueListenableBuilder<bool>(
      valueListenable: _sidebarCollapsed,
      builder: (context, isSidebarCollapsed, _) =>
          ValueListenableBuilder<Set<String>>(
            valueListenable: _expandedNavigationNodeIds,
            builder: (context, expandedNavigationNodeIds, _) =>
                ValueListenableBuilder<bool>(
                  valueListenable: _compactTreeOpen,
                  builder: (context, compactTreeOpen, _) {
                    final layout = _DesktopShellLayout(
                      key: const ValueKey('devplanner-shell-layout'),
                      navigationCubit: _navigationCubit,
                      tasksBoardAvailable: widget.tasksBoardAvailable,
                      location: location,
                      isSidebarCollapsed: isSidebarCollapsed,
                      expandedNavigationNodeIds: expandedNavigationNodeIds,
                      onToggleNavigationNode: _toggleNavigationNode,
                      onCreateWorkspace:
                          widget.workspaceManagementGateway == null
                          ? null
                          : _createWorkspace,
                      onCreateProject: widget.projectsRepository == null
                          ? null
                          : _createProject,
                      showCompactTree: compactTreeOpen,
                      onToggleCompactTree: () {
                        _compactTreeOpen.value = !compactTreeOpen;
                      },
                      onToggleSidebar: () {
                        _sidebarCollapsed.value = !isSidebarCollapsed;
                      },
                      child: widget.child,
                    );
                    final projectsGateway = widget.projectsGateway;
                    final projectsRepository = widget.projectsRepository;
                    // Port projektów jest udostępniany potomkom, bo menu projektu
                    // w drzewie mutuje przez ten kontrakt; bez providera akcje
                    // byłyby wyłączone w całym sidebarze.
                    if (projectsRepository == null && projectsGateway == null) {
                      return layout;
                    }
                    return MultiRepositoryProvider(
                      providers: [
                        if (projectsRepository != null)
                          RepositoryProvider<ProjectsRepository>.value(
                            value: projectsRepository,
                          ),
                        if (projectsGateway != null)
                          RepositoryProvider<ProjectsGateway>.value(
                            value: projectsGateway,
                          ),
                      ],
                      child: layout,
                    );
                  },
                ),
          ),
    );
  }
}
