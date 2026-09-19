part of 'devplanner_shell.dart';

final class _NavigationTree extends StatelessWidget {
  const _NavigationTree({
    required this.isCollapsed,
    required this.location,
    required this.navigationCubit,
    required this.tasksBoardAvailable,
    required this.expandedNavigationNodeIds,
    required this.onToggleNavigationNode,
  });

  final bool isCollapsed;
  final String location;
  final WorkspaceNavigationTreeCubit? navigationCubit;
  final bool tasksBoardAvailable;
  final Set<String> expandedNavigationNodeIds;
  final ValueChanged<String> onToggleNavigationNode;

  @override
  Widget build(BuildContext context) {
    final cubit = navigationCubit;
    if (cubit == null) return const _UnavailableNavigation();
    return BlocBuilder<
      WorkspaceNavigationTreeCubit,
      WorkspaceNavigationTreeState
    >(
      bloc: cubit,
      builder: (context, state) => switch (state) {
        WorkspaceNavigationTreeInitial() ||
        WorkspaceNavigationTreeLoading() => const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
        WorkspaceNavigationTreeReady(:final tree) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final node in tree.nodes)
              _NavigationTreeNode(
                node: node,
                depth: 0,
                isCollapsed: isCollapsed,
                location: location,
                tasksBoardAvailable: tasksBoardAvailable,
                expandedNavigationNodeIds: expandedNavigationNodeIds,
                onToggleNavigationNode: onToggleNavigationNode,
              ),
          ],
        ),
        WorkspaceNavigationTreeFailure() => _NavigationFailure(
          onRetry: cubit.load,
        ),
      },
    );
  }
}

final class _NavigationTreeNode extends StatelessWidget {
  const _NavigationTreeNode({
    required this.node,
    required this.depth,
    required this.isCollapsed,
    required this.location,
    required this.tasksBoardAvailable,
    required this.expandedNavigationNodeIds,
    required this.onToggleNavigationNode,
  });

  final WorkspaceNavigationNode node;
  final int depth;
  final bool isCollapsed;
  final String location;
  final bool tasksBoardAvailable;
  final Set<String> expandedNavigationNodeIds;
  final ValueChanged<String> onToggleNavigationNode;

  @override
  Widget build(BuildContext context) {
    final label = _label(context, node);
    final path = node.isSelectable ? _path(node) : null;
    final expanded =
        !isCollapsed &&
        (expandedNavigationNodeIds.contains(node.id) ||
            _hasSelectedDescendant(node));
    final item = _NavigationTreeItem(
      key: ValueKey<String>('navigation-node-${node.id}'),
      label: label,
      icon: _icon(node.kind),
      depth: isCollapsed ? 0 : depth,
      isCollapsed: isCollapsed,
      isSelected: path != null && _isSelected(path, location),
      isExpandable: node.hasChildren,
      isExpanded: expanded,
      onTap: path == null ? null : () => context.go(path),
      onToggle: node.hasChildren ? () => onToggleNavigationNode(node.id) : null,
    );
    if (isCollapsed || node.children.isEmpty || !expanded) return item;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        item,
        for (final child in node.children)
          _NavigationTreeNode(
            node: child,
            depth: depth + 1,
            isCollapsed: isCollapsed,
            location: location,
            tasksBoardAvailable: tasksBoardAvailable,
            expandedNavigationNodeIds: expandedNavigationNodeIds,
            onToggleNavigationNode: onToggleNavigationNode,
          ),
      ],
    );
  }

  String _label(BuildContext context, WorkspaceNavigationNode node) {
    final l10n = AppLocalizations.of(context)!;
    return switch (node.kind) {
      WorkspaceNavigationNodeKind.overview => l10n.workspacesSectionOverview,
      WorkspaceNavigationNodeKind.personalTasks => l10n.workspacesSectionTasks,
      WorkspaceNavigationNodeKind.personalFiles => l10n.workspacesSectionFiles,
      WorkspaceNavigationNodeKind.workspace ||
      WorkspaceNavigationNodeKind.project =>
        node.label ?? l10n.globalModuleWorkspaces,
      WorkspaceNavigationNodeKind.projects => l10n.workspacesSectionProjects,
      WorkspaceNavigationNodeKind.tasks => l10n.workspacesSectionTasks,
      WorkspaceNavigationNodeKind.taskList => l10n.workspacesTaskList,
      WorkspaceNavigationNodeKind.kanban => l10n.workspacesTaskKanban,
      WorkspaceNavigationNodeKind.whiteboards =>
        l10n.workspacesSectionWhiteboards,
      WorkspaceNavigationNodeKind.corkboard => l10n.workspacesProjectCorkboard,
      WorkspaceNavigationNodeKind.wiki => l10n.workspacesSectionWiki,
      WorkspaceNavigationNodeKind.files => l10n.workspacesSectionFiles,
      WorkspaceNavigationNodeKind.automations => l10n.workspacesTaskAutomations,
    };
  }

  IconData _icon(WorkspaceNavigationNodeKind kind) => switch (kind) {
    WorkspaceNavigationNodeKind.overview => Icons.dashboard_outlined,
    WorkspaceNavigationNodeKind.personalTasks => Icons.task_alt_outlined,
    WorkspaceNavigationNodeKind.personalFiles => Icons.folder_outlined,
    WorkspaceNavigationNodeKind.workspace => Icons.workspaces_outlined,
    WorkspaceNavigationNodeKind.projects => Icons.folder_special_outlined,
    WorkspaceNavigationNodeKind.project => Icons.folder_open_outlined,
    WorkspaceNavigationNodeKind.tasks => Icons.checklist_outlined,
    WorkspaceNavigationNodeKind.taskList => Icons.format_list_bulleted_outlined,
    WorkspaceNavigationNodeKind.kanban => Icons.view_kanban_outlined,
    WorkspaceNavigationNodeKind.whiteboards =>
      Icons.dashboard_customize_outlined,
    WorkspaceNavigationNodeKind.corkboard => Icons.push_pin_outlined,
    WorkspaceNavigationNodeKind.wiki => Icons.menu_book_outlined,
    WorkspaceNavigationNodeKind.files => Icons.description_outlined,
    WorkspaceNavigationNodeKind.automations => Icons.auto_awesome_outlined,
  };

  String? _path(WorkspaceNavigationNode node) => switch (node.kind) {
    WorkspaceNavigationNodeKind.overview => '/workspaces',
    WorkspaceNavigationNodeKind.personalTasks => DevPlannerRouteCatalog.myTasks,
    WorkspaceNavigationNodeKind.workspace =>
      node.workspaceId == null ||
              !DevPlannerRouteCatalog.isUuid(node.workspaceId!)
          ? null
          : DevPlannerRouteCatalog.workspace(node.workspaceId!),
    WorkspaceNavigationNodeKind.personalFiles => DevPlannerRouteCatalog.myFiles,
    WorkspaceNavigationNodeKind.files =>
      node.workspaceId == null ||
              !DevPlannerRouteCatalog.isUuid(node.workspaceId!)
          ? null
          : node.projectId == null
          ? DevPlannerRouteCatalog.workspaceFiles(node.workspaceId!)
          : DevPlannerRouteCatalog.isUuid(node.projectId!)
          ? DevPlannerRouteCatalog.projectFiles(
              node.workspaceId!,
              node.projectId!,
            )
          : null,
    WorkspaceNavigationNodeKind.taskList ||
    WorkspaceNavigationNodeKind.kanban =>
      tasksBoardAvailable &&
              node.workspaceId != null &&
              node.projectId != null &&
              DevPlannerRouteCatalog.isUuid(node.workspaceId!) &&
              DevPlannerRouteCatalog.isUuid(node.projectId!)
          ? node.kind == WorkspaceNavigationNodeKind.kanban
                ? DevPlannerRouteCatalog.projectKanban(
                    node.workspaceId!,
                    node.projectId!,
                  )
                : DevPlannerRouteCatalog.projectTasks(
                    node.workspaceId!,
                    node.projectId!,
                  )
          : null,
    _ => null,
  };

  bool _hasSelectedDescendant(WorkspaceNavigationNode candidate) =>
      candidate.children.any((child) {
        final childPath = child.isSelectable ? _path(child) : null;
        return (childPath != null && _isSelected(childPath, location)) ||
            _hasSelectedDescendant(child);
      });

  bool _isSelected(String path, String currentLocation) =>
      currentLocation == path || currentLocation.startsWith('$path/');
}

final class _SidebarRouteLinks extends StatelessWidget {
  const _SidebarRouteLinks({required this.isCollapsed, required this.location});

  final bool isCollapsed;
  final String location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          _NavigationTreeItem(
            label: l10n.globalModuleSettings,
            icon: Icons.person_outline,
            depth: 0,
            isCollapsed: isCollapsed,
            isSelected: location == '/me' || location.startsWith('/me/'),
            isExpandable: false,
            isExpanded: false,
            onTap: () => context.go('/me'),
            onToggle: null,
          ),
          _NavigationTreeItem(
            label: l10n.adminUsersTitle,
            icon: Icons.manage_accounts_outlined,
            depth: 0,
            isCollapsed: isCollapsed,
            isSelected: location == '/admin' || location.startsWith('/admin/'),
            isExpandable: false,
            isExpanded: false,
            onTap: () => context.go('/admin'),
            onToggle: null,
          ),
        ],
      ),
    );
  }
}

final class _UnavailableNavigation extends StatelessWidget {
  const _UnavailableNavigation();

  @override
  Widget build(BuildContext context) => Tooltip(
    message: AppLocalizations.of(context)!
        .workspacesTransportUnavailableMessage,
    child: const SizedBox(
      height: 80,
      child: Center(child: Icon(Icons.cloud_off_outlined)),
    ),
  );
}

final class _NavigationFailure extends StatelessWidget {
  const _NavigationFailure({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(l10n.workspacesErrorTitle, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          IconButton(
            tooltip: l10n.workspacesRetry,
            onPressed: () => unawaited(onRetry()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
