import 'dart:async';

import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:devplanner/app/theme/theme_preference_cubit.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_node.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_tree_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_tree_state.dart';
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
    this.projectsGateway,
    this.tasksBoardAvailable = false,
    super.key,
  });

  final Widget child;
  final WorkspaceNavigationGateway? workspaceNavigationGateway;
  final ProjectsGateway? projectsGateway;
  final bool tasksBoardAvailable;

  @override
  State<DevPlannerShellRoute> createState() => _DevPlannerShellRouteState();
}

class _DevPlannerShellRouteState extends State<DevPlannerShellRoute> {
  late final WorkspaceNavigationTreeCubit? _navigationCubit =
      _createNavigationCubit();
  final ValueNotifier<bool> _sidebarCollapsed = ValueNotifier(false);
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
    _expandedNavigationNodeIds.dispose();
    super.dispose();
  }

  void _toggleNavigationNode(String nodeId) {
    final next = Set<String>.of(_expandedNavigationNodeIds.value);
    if (!next.add(nodeId)) next.remove(nodeId);
    _expandedNavigationNodeIds.value = Set<String>.unmodifiable(next);
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
            builder: (context, expandedNavigationNodeIds, _) {
              final layout = _DesktopShellLayout(
                key: const ValueKey('devplanner-shell-layout'),
                navigationCubit: _navigationCubit,
                tasksBoardAvailable: widget.tasksBoardAvailable,
                location: location,
                isSidebarCollapsed: isSidebarCollapsed,
                expandedNavigationNodeIds: expandedNavigationNodeIds,
                onToggleNavigationNode: _toggleNavigationNode,
                onToggleSidebar: () {
                  _sidebarCollapsed.value = !isSidebarCollapsed;
                },
                child: widget.child,
              );
              final projectsGateway = widget.projectsGateway;
              return projectsGateway == null
                  ? layout
                  : RepositoryProvider<ProjectsGateway>.value(
                      value: projectsGateway,
                      child: layout,
                    );
            },
          ),
    );
  }
}
