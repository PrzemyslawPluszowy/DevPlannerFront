part of 'app_global_utility_bar.dart';

/// Segment okruszków nawigacyjnych paska górnego.
class AppGlobalBreadcrumb extends StatelessWidget {
  /// Tworzy interaktywny pasek okruszków nawigacyjnych.
  const AppGlobalBreadcrumb({required this.router, super.key});

  /// Router aplikacji do odczytu ścieżki i nawigacji.
  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;
    final currentPath = router.currentPath;
    final activeModule = AppModulesCatalog.findByPath(currentPath);

    final moduleLabel = activeModule?.label(intl) ?? intl.globalModuleDashboard;
    final moduleRoute = activeModule?.routePath ?? AppRoutePaths.dashboard;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Główny brand Ready Next — nawiguje do Dashboardu
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          onTap: () => unawaited(router.navigatePath(AppRoutePaths.dashboard)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x336366F1),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      AppIcons.workspaces,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                Gaps.w8,
                Text(
                  intl.appShellBrandName,
                  style: context.text.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '›',
            style: TextStyle(
              fontSize: 16,
              color: colors.onSurfaceVariant.withValues(alpha: .4),
            ),
          ),
        ),
        // Etykieta aktywnego modułu pobierana dynamicznie z AppModulesCatalog
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          onTap: () => unawaited(router.navigatePath(moduleRoute)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              moduleLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Nowoczesna, biała kapsułka wyszukiwania na szklanym pasku górnym.
class AppGlobalSearchCapsule extends StatelessWidget {
  /// Tworzy nieaktywną zapowiedź command palette do czasu jej wdrożenia.
  const AppGlobalSearchCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Material(
          color: isDark ? const Color(0xFF1E2138) : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Semantics(
            enabled: false,
            label: context.l10n.appShellCommandPaletteUnavailable,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2138) : Colors.white,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: .14)
                      : const Color(0xFFE2E8F0),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .20 : .04),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    AppIcons.search,
                    size: 14,
                    color: Color(0xFF6366F1),
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Text(
                      context.l10n.appShellCommandPaletteUnavailable,
                      style: context.text.bodySmall?.copyWith(
                        fontSize: 12,
                        color: colors.onSurfaceVariant.withValues(alpha: .75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Grupa przycisków akcji po prawej stronie paska górnego.
class AppGlobalUtilityActions extends StatelessWidget {
  /// Tworzy akcje powiadomień i czatu.
  const AppGlobalUtilityActions({
    required this.router,
    required this.count,
    required this.repository,
    required this.chatRepository,
    this.onOpenNotifications,
    this.onOpenChat,
    super.key,
  });

  /// Router aplikacji do nawigacji szuflad.
  final AppRouter router;

  /// Licznik nieprzeczytanych powiadomień.
  final int? count;

  /// Repozytorium powiadomień.
  final NotificationsRepository? repository;

  /// Repozytorium czatu.
  final ChatRepository? chatRepository;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenChat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _UtilityAction(
          tooltip: context.l10n.workspacesSectionNotifications,
          icon: AppIcons.notifications,
          badge: count,
          onPressed: () {
            if (onOpenNotifications != null) {
              onOpenNotifications!();
              return;
            }
            final navContext = router.navigatorKey.currentContext ?? context;
            unawaited(
              repository == null
                  ? router.navigatePath(AppRoutePaths.notifications)
                  : AppGlobalNotificationsDrawer.show(
                      navContext,
                      repository: repository!,
                    ),
            );
          },
        ),
        const SizedBox(width: Sizes.p4),
        _UtilityAction(
          tooltip: context.l10n.workspacesSectionChat,
          icon: AppIcons.chat,
          onPressed: () {
            if (onOpenChat != null) {
              onOpenChat!();
              return;
            }
            final navContext = router.navigatorKey.currentContext ?? context;
            unawaited(
              chatRepository == null
                  ? router.navigatePath(AppRoutePaths.chat)
                  : AppGlobalChatDrawer.show(
                      navContext,
                      repository: chatRepository!,
                      router: router,
                    ),
            );
          },
        ),
      ],
    );
  }
}

/// Mały przycisk paska globalnego z zachowaniem hover/focus dla Web/Desktop.
class _UtilityAction extends StatelessWidget {
  const _UtilityAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.badge,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final tooltipText = Overlay.maybeOf(context) == null ? null : tooltip;
    return Badge(
      isLabelVisible: badge != null && badge! > 0,
      label: Text(badge != null && badge! > 99 ? '99+' : '${badge ?? 0}'),
      child: IconButton(
        tooltip: tooltipText,
        constraints: BoxConstraints.tightFor(
          width: AppShellMetrics.of(context).minimumTouchTarget,
          height: AppShellMetrics.of(context).minimumTouchTarget,
        ),
        visualDensity: VisualDensity.standard,
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
      ),
    );
  }
}
