part of 'devplanner_shell.dart';

final class _NavigationTree extends StatelessWidget {
  const _NavigationTree({
    required this.isCollapsed,
    required this.location,
    required this.navigationCubit,
    required this.tasksBoardAvailable,
    required this.expandedNavigationNodeIds,
    required this.onToggleNavigationNode,
    required this.onCreateWorkspace,
    required this.onCreateProject,
  });

  final bool isCollapsed;
  final String location;
  final WorkspaceNavigationTreeCubit? navigationCubit;
  final bool tasksBoardAvailable;
  final Set<String> expandedNavigationNodeIds;
  final ValueChanged<WorkspaceNavigationNode> onToggleNavigationNode;
  final Future<void> Function(BuildContext)? onCreateWorkspace;
  final Future<void> Function(BuildContext, String)? onCreateProject;

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
            if (!isCollapsed && onCreateWorkspace != null)
              _WorkspaceSectionHeader(onCreateWorkspace: onCreateWorkspace!),
            for (final node in tree.nodes)
              _NavigationTreeNode(
                node: node,
                navigationCubit: cubit,
                depth: 0,
                isCollapsed: isCollapsed,
                location: location,
                tasksBoardAvailable: tasksBoardAvailable,
                expandedNavigationNodeIds: expandedNavigationNodeIds,
                onToggleNavigationNode: onToggleNavigationNode,
                loadingProjectWorkspaceIds: state.loadingProjectWorkspaceIds,
                projectFailuresByWorkspace: state.projectFailuresByWorkspace,
                onCreateProject: onCreateProject,
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
    required this.navigationCubit,
    required this.depth,
    required this.isCollapsed,
    required this.location,
    required this.tasksBoardAvailable,
    required this.expandedNavigationNodeIds,
    required this.onToggleNavigationNode,
    required this.loadingProjectWorkspaceIds,
    required this.projectFailuresByWorkspace,
    required this.onCreateProject,
  });

  final WorkspaceNavigationNode node;
  final WorkspaceNavigationTreeCubit navigationCubit;
  final int depth;
  final bool isCollapsed;
  final String location;
  final bool tasksBoardAvailable;
  final Set<String> expandedNavigationNodeIds;
  final ValueChanged<WorkspaceNavigationNode> onToggleNavigationNode;
  final Set<String> loadingProjectWorkspaceIds;
  final Map<String, ProjectsGatewayException> projectFailuresByWorkspace;
  final Future<void> Function(BuildContext, String)? onCreateProject;

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
      onToggle: node.hasChildren ? () => onToggleNavigationNode(node) : null,
      trailingAction:
          node.kind == WorkspaceNavigationNodeKind.projects &&
              node.workspaceId != null &&
              onCreateProject != null
          ? () => unawaited(onCreateProject!(context, node.workspaceId!))
          : null,
    );
    if (isCollapsed || node.children.isEmpty || !expanded) return item;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        item,
        if (node.kind == WorkspaceNavigationNodeKind.projects &&
            node.workspaceId != null &&
            loadingProjectWorkspaceIds.contains(node.workspaceId))
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (node.kind == WorkspaceNavigationNodeKind.projects &&
            node.workspaceId != null &&
            projectFailuresByWorkspace.containsKey(node.workspaceId))
          _ProjectBranchFailure(
            onRetry: () => unawaited(
              navigationCubit.loadProjects(node.workspaceId!, refresh: true),
            ),
          )
        else
          for (final child in node.children)
            _NavigationTreeNode(
              node: child,
              navigationCubit: navigationCubit,
              depth: depth + 1,
              isCollapsed: isCollapsed,
              location: location,
              tasksBoardAvailable: tasksBoardAvailable,
              expandedNavigationNodeIds: expandedNavigationNodeIds,
              onToggleNavigationNode: onToggleNavigationNode,
              loadingProjectWorkspaceIds: loadingProjectWorkspaceIds,
              projectFailuresByWorkspace: projectFailuresByWorkspace,
              onCreateProject: onCreateProject,
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

final class _ProjectBranchFailure extends StatelessWidget {
  const _ProjectBranchFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 36, right: 8, bottom: 6),
    child: TextButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh, size: 16),
      label: Text(AppLocalizations.of(context)!.workspacesRetry),
    ),
  );
}

final class _WorkspaceSectionHeader extends StatelessWidget {
  const _WorkspaceSectionHeader({required this.onCreateWorkspace});

  final Future<void> Function(BuildContext) onCreateWorkspace;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 10, 8, 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.globalModuleWorkspaces.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: .8,
            ),
          ),
        ),
        IconButton(
          key: const ValueKey('workspace-create-button'),
          tooltip: AppLocalizations.of(context)!.workspacesCreateWorkspace,
          onPressed: () => unawaited(onCreateWorkspace(context)),
          icon: const Icon(Icons.add, size: 18),
          visualDensity: VisualDensity.compact,
        ),
      ],
    ),
  );
}

final class _CreateWorkspaceFromSidebarDialog extends StatefulWidget {
  const _CreateWorkspaceFromSidebarDialog({
    required this.gateway,
    required this.onCreated,
  });

  final WorkspaceManagementGateway gateway;
  final Future<void> Function(String workspaceId) onCreated;

  static Future<void> show(
    BuildContext context, {
    required WorkspaceManagementGateway gateway,
    required Future<void> Function(String workspaceId) onCreated,
  }) => showDialog<void>(
    context: context,
    builder: (_) => _CreateWorkspaceFromSidebarDialog(
      gateway: gateway,
      onCreated: onCreated,
    ),
  );

  @override
  State<_CreateWorkspaceFromSidebarDialog> createState() =>
      _CreateWorkspaceFromSidebarDialogState();
}

final class _CreateProjectFromSidebarDialog extends StatelessWidget {
  const _CreateProjectFromSidebarDialog({
    required this.gateway,
    required this.workspaceId,
    required this.onCreated,
  });

  final ProjectManagementGateway gateway;
  final String workspaceId;
  final Future<void> Function(String projectId) onCreated;

  static Future<void> show(
    BuildContext context, {
    required ProjectManagementGateway gateway,
    required String workspaceId,
    required Future<void> Function(String projectId) onCreated,
  }) => showDialog<void>(
    context: context,
    builder: (_) => _CreateProjectFromSidebarDialog(
      gateway: gateway,
      workspaceId: workspaceId,
      onCreated: onCreated,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.workspacesCreateProjectTitle),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.workspacesProjectNameLabel,
        ),
        onSubmitted: (name) => _submit(context, name.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.workspacesCancelButton),
        ),
        FilledButton(
          onPressed: () => _submit(context, controller.text.trim()),
          child: Text(AppLocalizations.of(context)!.workspacesCreateButton),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context, String name) async {
    if (name.isEmpty) return;
    try {
      final projectId = await gateway.createProject(
        workspaceId: workspaceId,
        name: name,
      );
      await onCreated(projectId);
      if (context.mounted) Navigator.of(context).pop();
    } on ProjectsGatewayException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.workspacesRequestFailedMessage,
            ),
          ),
        );
      }
    }
  }
}

final class _CreateWorkspaceFromSidebarDialogState
    extends State<_CreateWorkspaceFromSidebarDialog> {
  late final TextEditingController _controller;
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final ValueNotifier<String?> _error = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _isSubmitting.dispose();
    _error.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty || _isSubmitting.value) return;
    _isSubmitting.value = true;
    _error.value = null;
    try {
      final workspace = await widget.gateway.createWorkspace(name: name);
      await widget.onCreated(workspace.id);
      if (mounted) Navigator.of(context).pop();
    } on WorkspacesGatewayException catch (_) {
      if (mounted) {
        _error.value = AppLocalizations.of(context)!
            .workspacesRequestFailedMessage;
      }
    } catch (_) {
      if (mounted) {
        _error.value = AppLocalizations.of(context)!
            .workspacesRequestFailedMessage;
      }
    } finally {
      if (mounted) _isSubmitting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.workspacesCreateWorkspaceTitle),
      content: ValueListenableBuilder<String?>(
        valueListenable: _error,
        builder: (context, error, _) => TextField(
          controller: _controller,
          autofocus: true,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: l10n.workspacesNameFieldLabel,
            errorText: error,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.workspacesCancelButton),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isSubmitting,
          builder: (context, isSubmitting, _) => FilledButton(
            onPressed: isSubmitting ? null : _submit,
            child: Text(l10n.workspacesCreateButton),
          ),
        ),
      ],
    );
  }
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
