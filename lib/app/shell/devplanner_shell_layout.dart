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
    required this.onToggleSidebar,
    super.key,
  });

  static const _topBarHeight = 64.0;
  static const _expandedSidebarWidth = 256.0;
  static const _collapsedSidebarWidth = 72.0;

  final Widget child;
  final WorkspaceNavigationTreeCubit? navigationCubit;
  final bool tasksBoardAvailable;
  final String location;
  final bool isSidebarCollapsed;
  final Set<String> expandedNavigationNodeIds;
  final ValueChanged<String> onToggleNavigationNode;
  final VoidCallback onToggleSidebar;

  @override
  Widget build(BuildContext context) {
    final shellTheme = context.devPlannerShellTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 960;
        final collapsed = isSidebarCollapsed || compact;
        return DecoratedBox(
          key: const ValueKey('devplanner-shell-backdrop'),
          decoration: BoxDecoration(gradient: shellTheme.backdropGradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                SizedBox(
                  key: const ValueKey('devplanner-topbar'),
                  height: _topBarHeight,
                  child: _DevPlannerTopBar(
                    location: location,
                    isSidebarCollapsed: collapsed,
                    onToggleSidebar: onToggleSidebar,
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DevPlannerSidebar(
                        isCollapsed: collapsed,
                        expandedWidth: _expandedSidebarWidth,
                        collapsedWidth: _collapsedSidebarWidth,
                        location: location,
                        navigationCubit: navigationCubit,
                        tasksBoardAvailable: tasksBoardAvailable,
                        expandedNavigationNodeIds: expandedNavigationNodeIds,
                        onToggleNavigationNode: onToggleNavigationNode,
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
  const _DevPlannerTopBar({
    required this.location,
    required this.isSidebarCollapsed,
    required this.onToggleSidebar,
  });

  final String location;
  final bool isSidebarCollapsed;
  final VoidCallback onToggleSidebar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shellTheme = context.devPlannerShellTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: shellTheme.topBar,
        border: Border(bottom: BorderSide(color: shellTheme.contentBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            IconButton(
              key: const ValueKey('devplanner-toggle-sidebar'),
              tooltip: isSidebarCollapsed
                  ? l10n.workspaceShellExpandMenu
                  : l10n.workspaceShellCollapseMenu,
              onPressed: onToggleSidebar,
              icon: Icon(
                isSidebarCollapsed ? Icons.menu : Icons.menu_open,
                color: shellTheme.sidebarText,
              ),
            ),
            Icon(Icons.hub_outlined, color: shellTheme.sidebarIcon),
            const SizedBox(width: 10),
            Text(
              l10n.appShellBrandName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: shellTheme.sidebarText,
              ),
            ),
            const SizedBox(width: 18),
            SizedBox(
              height: 24,
              child: VerticalDivider(color: shellTheme.contentBorder),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                _sectionTitle(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: shellTheme.sidebarText),
              ),
            ),
            _ThemePreferenceToggle(
              sidebarText: shellTheme.sidebarText,
            ),
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
              onPressed: DevPlannerPanelsScope.controllerOf(
                context,
              )?.showNotifications,
              icon: Icon(
                Icons.notifications_none,
                color: shellTheme.sidebarText,
              ),
            ),
          ],
        ),
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
    required this.expandedWidth,
    required this.collapsedWidth,
    required this.location,
    required this.navigationCubit,
    required this.tasksBoardAvailable,
    required this.expandedNavigationNodeIds,
    required this.onToggleNavigationNode,
  });

  final bool isCollapsed;
  final double expandedWidth;
  final double collapsedWidth;
  final String location;
  final WorkspaceNavigationTreeCubit? navigationCubit;
  final bool tasksBoardAvailable;
  final Set<String> expandedNavigationNodeIds;
  final ValueChanged<String> onToggleNavigationNode;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: const ValueKey('devplanner-sidebar'),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: isCollapsed ? collapsedWidth : expandedWidth,
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              key: const PageStorageKey<String>('devplanner-sidebar-scroll'),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _NavigationTree(
                isCollapsed: isCollapsed,
                location: location,
                navigationCubit: navigationCubit,
                tasksBoardAvailable: tasksBoardAvailable,
                expandedNavigationNodeIds: expandedNavigationNodeIds,
                onToggleNavigationNode: onToggleNavigationNode,
              ),
            ),
          ),
          _SidebarRouteLinks(isCollapsed: isCollapsed, location: location),
        ],
      ),
    );
  }
}
