part of 'devplanner_shell.dart';

final class _DesktopShellLayout extends StatelessWidget {
  const _DesktopShellLayout({
    required this.child,
    required this.navigationCubit,
    required this.tasksBoardAvailable,
    required this.location,
    required this.isSidebarCollapsed,
    required this.expandedNavigationNodeIds,
    required this.onToggleNavigationNode,
    required this.onCreateWorkspace,
    required this.onCreateProject,
    required this.onToggleSidebar,
    super.key,
  });

  final Widget child;
  final WorkspaceNavigationTreeCubit? navigationCubit;
  final bool tasksBoardAvailable;
  final String location;
  final bool isSidebarCollapsed;
  final Set<String> expandedNavigationNodeIds;
  final ValueChanged<WorkspaceNavigationNode> onToggleNavigationNode;
  final Future<void> Function(BuildContext)? onCreateWorkspace;
  final Future<void> Function(BuildContext, String)? onCreateProject;
  final VoidCallback onToggleSidebar;

  @override
  Widget build(BuildContext context) {
    final shellTheme = context.devPlannerShellTheme;
    final navigationTheme = context.devPlannerNavigationTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 960;
        final collapsed = isSidebarCollapsed || compact;
        return DecoratedBox(
          key: const ValueKey('devplanner-shell-backdrop'),
          decoration: BoxDecoration(gradient: shellTheme.backdropGradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: collapsed
                      ? navigationTheme.collapsedSidebarWidth
                      : navigationTheme.sidebarWidth,
                  child: Column(
                    children: [
                      SizedBox(
                        key: const ValueKey('devplanner-sidebar-header'),
                        height: navigationTheme.headerHeight,
                        child: _DevPlannerSidebarHeader(
                          isCollapsed: collapsed,
                          onToggleSidebar: onToggleSidebar,
                        ),
                      ),
                      Expanded(
                        child: _DevPlannerSidebar(
                          isCollapsed: collapsed,
                          location: location,
                          navigationCubit: navigationCubit,
                          tasksBoardAvailable: tasksBoardAvailable,
                          expandedNavigationNodeIds: expandedNavigationNodeIds,
                          onToggleNavigationNode: onToggleNavigationNode,
                          onCreateWorkspace: onCreateWorkspace,
                          onCreateProject: onCreateProject,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        key: const ValueKey('devplanner-topbar'),
                        height: navigationTheme.headerHeight,
                        child: _DevPlannerTopBar(location: location),
                      ),
                      Expanded(
                        child: Padding(
                          key: const ValueKey('devplanner-content-margin'),
                          padding: const EdgeInsets.all(12),
                          child: Material(
                            key: const ValueKey('devplanner-content-canvas'),
                            color: shellTheme.contentSurface,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: shellTheme.contentBorder),
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _DevPlannerTopBar extends StatelessWidget {
  const _DevPlannerTopBar({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final shellTheme = context.devPlannerShellTheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _sectionTitle(l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(
                    height: 20 / 12,
                    fontSize: 12,
                    color: shellTheme.sidebarText,
                  ),
            ),
          ),
          _ThemePreferenceToggle(sidebarText: shellTheme.sidebarText),
          IconButton(
            key: const ValueKey('devplanner-open-chat-panel'),
            tooltip: l10n.workspacesSectionChat,
            onPressed: DevPlannerPanelsScope.controllerOf(context)?.showChat,
            icon: Icon(
              Icons.chat_bubble_outline,
              color: shellTheme.sidebarText,
            ),
          ),
          IconButton(
            key: const ValueKey('devplanner-open-notifications-panel'),
            tooltip: l10n.globalNotificationsTitle,
            onPressed: DevPlannerPanelsScope.controllerOf(context)
                ?.showNotifications,
            icon: Icon(Icons.notifications_none, color: shellTheme.sidebarText),
          ),
        ],
      ),
    );
  }

  String _sectionTitle(AppLocalizations l10n) {
    if (location == '/me' || location.startsWith('/me/')) {
      return l10n.globalModuleSettings;
    }
    if (location == '/admin' || location.startsWith('/admin/')) {
      return l10n.adminUsersTitle;
    }
    return l10n.globalModuleWorkspaces;
  }
}

/// Lewa część ramy nad sidebarem. Jest częścią tej samej kolumny co menu,
/// dzięki czemu tło pozostaje ciągłe jak w referencji Gmail-inspired.
final class _DevPlannerSidebarHeader extends StatelessWidget {
  const _DevPlannerSidebarHeader({
    required this.isCollapsed,
    required this.onToggleSidebar,
  });

  final bool isCollapsed;
  final VoidCallback onToggleSidebar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shellTheme = context.devPlannerShellTheme;
    final navigationTheme = context.devPlannerNavigationTheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 0 : navigationTheme.sidebarHorizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          IconButton(
            key: const ValueKey('devplanner-toggle-sidebar'),
            tooltip: isCollapsed
                ? l10n.workspaceShellExpandMenu
                : l10n.workspaceShellCollapseMenu,
            onPressed: onToggleSidebar,
            icon: Icon(
              isCollapsed ? Icons.menu : Icons.menu_open,
              color: shellTheme.sidebarText,
            ),
          ),
          if (!isCollapsed) ...[
            Icon(
              Icons.hub_outlined,
              size: 22,
              color: shellTheme.sidebarIcon,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.appShellBrandName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  height: 22 / 16,
                  fontWeight: FontWeight.w600,
                  color: shellTheme.sidebarText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mała akcja belki: przełącza wyłącznie jasny i ciemny motyw DevPlanner.
final class _ThemePreferenceToggle extends StatelessWidget {
  const _ThemePreferenceToggle({required this.sidebarText});

  final Color sidebarText;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ThemePreferenceCubit?>();
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<ThemePreferenceCubit, DevPlannerThemePreference>(
      bloc: cubit,
      builder: (context, preference) {
        final l10n = AppLocalizations.of(context)!;
        final changesToDark = preference == DevPlannerThemePreference.light;
        return IconButton(
          key: const ValueKey('devplanner-toggle-theme'),
          tooltip: changesToDark
              ? l10n.settingsThemeDark
              : l10n.settingsThemeLight,
          onPressed: () => unawaited(cubit.toggle()),
          icon: Icon(
            changesToDark
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            color: sidebarText,
          ),
        );
      },
    );
  }
}

final class _DevPlannerSidebar extends StatelessWidget {
  const _DevPlannerSidebar({
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
    final navigationTheme = context.devPlannerNavigationTheme;
    return AnimatedContainer(
      key: const ValueKey('devplanner-sidebar'),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              key: const PageStorageKey<String>('devplanner-sidebar-scroll'),
              padding: EdgeInsets.symmetric(
                vertical: navigationTheme.sidebarHorizontalPadding,
              ),
              child: _NavigationTree(
                isCollapsed: isCollapsed,
                location: location,
                navigationCubit: navigationCubit,
                tasksBoardAvailable: tasksBoardAvailable,
                expandedNavigationNodeIds: expandedNavigationNodeIds,
                onToggleNavigationNode: onToggleNavigationNode,
                onCreateWorkspace: onCreateWorkspace,
                onCreateProject: onCreateProject,
              ),
            ),
          ),
          _SidebarRouteLinks(isCollapsed: isCollapsed, location: location),
        ],
      ),
    );
  }
}
