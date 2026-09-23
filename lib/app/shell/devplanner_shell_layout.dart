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
    required this.showCompactTree,
    required this.onToggleCompactTree,
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

  /// Czy na wąskim oknie drzewo jest otwarte w nakładce.
  final bool showCompactTree;

  /// Otwiera lub zamyka nakładkę drzewa na wąskim oknie.
  final VoidCallback onToggleCompactTree;

  @override
  Widget build(BuildContext context) {
    final shellTheme = context.devPlannerShellTheme;
    final navigationTheme = context.devPlannerNavigationTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 960;
        // Na wąskim oknie pasek zostaje ikonowy, ale drzewo jest osiągalne
        // w nakładce — zwinięcie nie może odbierać dostępu do nawigacji.
        final collapsed = isSidebarCollapsed || (compact && !showCompactTree);
        return DecoratedBox(
          key: const ValueKey('devplanner-shell-backdrop'),
          decoration: BoxDecoration(
            color: shellTheme.backdropMiddle,
            image: const DecorationImage(
              image: DevPlannerShellTheme.backdropImage,
              fit: BoxFit.cover,
              // Przy bardzo szerokim oknie `cover` przycina pionowo. Trzymaj
              // kadr przy dole, aby nie chować dolnej części tapety pod ramą.
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                if (compact && showCompactTree) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onToggleCompactTree,
                      child: ColoredBox(
                        color: Theme.of(
                          context,
                        ).colorScheme.scrim.withValues(alpha: .35),
                      ),
                    ),
                  ),
                ],
                // Przypięty panel rezerwuje miejsce w treści aplikacji, a nie
                // w całym oknie: tapeta pozostaje jedną warstwą o stałym kadrze
                // niezależnie od otwarcia, zamknięcia i przypięcia panelu.
                AnimatedPadding(
                  duration:
                      MediaQuery.maybeOf(context)?.disableAnimations == true
                      ? Duration.zero
                      : const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(
                    right: DevPlannerPanelsScope.reservedWidthOf(context),
                  ),
                  child: Row(
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
                                // Na wąskim oknie ten sam klawisz otwiera
                                // i zamyka nakładkę z pełnym drzewem.
                                onToggleSidebar: compact
                                    ? onToggleCompactTree
                                    : onToggleSidebar,
                              ),
                            ),
                            Expanded(
                              child: _DevPlannerSidebar(
                                isCollapsed: collapsed,
                                location: location,
                                navigationCubit: navigationCubit,
                                tasksBoardAvailable: tasksBoardAvailable,
                                expandedNavigationNodeIds:
                                    expandedNavigationNodeIds,
                                onToggleNavigationNode: onToggleNavigationNode,
                                onCreateWorkspace: onCreateWorkspace,
                                onCreateProject: onCreateProject,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (compact && showCompactTree) const Spacer(),
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
                                key: const ValueKey(
                                  'devplanner-content-margin',
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Material(
                                  key: const ValueKey(
                                    'devplanner-content-canvas',
                                  ),
                                  color: shellTheme.contentSurface,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: shellTheme.contentBorder,
                                    ),
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
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Ikona czatu z badge serwerowego licznika nieprzeczytanych.
///
/// Licznik jest sesyjny, więc badge działa także przy zamkniętym panelu; brak
/// portu skrzynki oznacza brak badge, a nie lokalne zgadywanie liczby.
class _ChatUnreadBadge extends StatelessWidget {
  const _ChatUnreadBadge({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ChatUnreadCubit?>();
    final unread = cubit?.state.unread ?? 0;
    if (unread <= 0) return child;
    final chat = context.chatTheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -4,
          right: -2,
          child: IgnorePointer(
            child: Semantics(
              label: AppLocalizations.of(context)!.chatInboxUnreadSemantics(
                unread,
              ),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: chat.sendButtonSurface,
                  shape: const StadiumBorder(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 16),
                    child: Center(
                      child: Text(
                        unread > 99 ? '99+' : '$unread',
                        style: chat.metadataStyle.copyWith(
                          color: chat.sendButtonForeground,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
            onPressed: DevPlannerPanelsScope.controllerOf(context)?.toggleChat,
            icon: _ChatUnreadBadge(
              child: Icon(
                Icons.chat_bubble_outline,
                color: shellTheme.sidebarText,
              ),
            ),
          ),
          IconButton(
            key: const ValueKey('devplanner-open-notifications-panel'),
            tooltip: l10n.globalNotificationsTitle,
            onPressed: DevPlannerPanelsScope.controllerOf(context)
                ?.toggleNotifications,
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
///
/// Logotyp zajmuje całą wolną szerokość po lewej, a przycisk zwijania menu
/// domyka wiersz po prawej. Szeroki lockup z nazwą produktu nie zmieściłby się
/// między przyciskiem a krawędzią, więc to przycisk ustępuje mu miejsca.
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
    final toggle = IconButton(
      key: const ValueKey('devplanner-toggle-sidebar'),
      tooltip: isCollapsed
          ? l10n.workspaceShellExpandMenu
          : l10n.workspaceShellCollapseMenu,
      onPressed: onToggleSidebar,
      icon: Icon(
        isCollapsed ? Icons.menu : Icons.menu_open,
        color: shellTheme.sidebarText,
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 0 : navigationTheme.sidebarHorizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          if (isCollapsed)
            toggle
          else ...[
            Expanded(
              child: Center(
                child: Image(
                  key: const ValueKey('devplanner-sidebar-brand-logo'),
                  image: DevPlannerShellTheme.logoImage,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  semanticLabel: l10n.appShellBrandName,
                ),
              ),
            ),
            toggle,
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
