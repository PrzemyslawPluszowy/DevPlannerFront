import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/app/shell/changelog/app_shell_changelog_body.dart';
import 'package:ready_next/app/shell/overlay/app_modal_coordinator.dart';
import 'package:ready_next/app/shell/panels/app_global_panels_controller.dart';
import 'package:ready_next/app/shell/panels/app_global_panels_scope.dart';
import 'package:ready_next/app/shell/top_bar/top_bar_export.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_module_rail.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_navigation_preference_key.dart';
import 'package:ready_next/shared/presentation/widgets/app_overlay_route_lifecycle.dart';
import 'package:ready_next/shared/presentation/widgets/app_shell_wallpaper.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_open_request.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/chat_drawer.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/global_notifications_page.dart';

/// Prywatny chrome aplikacji osadzany przez authenticated `ShellRoute`.
///
/// Pasek górny ma własny zarezerwowany slot, a zwinięty rail własną szerokość
/// w obszarze roboczym. Shell jest potomkiem root Navigatora, dlatego dialogi
/// i side sheety otwierane przez root navigator pozostają nad całym chrome'em.
class AppGlobalShell extends StatefulWidget {
  const AppGlobalShell({
    required this.child,
    required this.appRouter,
    super.key,
  });

  final Widget child;
  final AppRouter appRouter;

  @override
  State<AppGlobalShell> createState() => _AppGlobalShellState();
}

/// Stan prywatnego shellu oraz właściciel lokalnego okna changeloga.
class _AppGlobalShellState extends State<AppGlobalShell> {
  static const _changelogAssetPath = 'assets/changelog.md';
  static const _railPreferenceId = 'global.moduleRail';
  late final AppModalCoordinator _modalCoordinator = AppModalCoordinator();
  late final AppOverlayRouteLifecycle _routeLifecycle =
      AppOverlayRouteLifecycle();
  late final AppBubbleToastController _toastController =
      AppBubbleToastController(_modalCoordinator);
  late final AppGlobalPanelsController _panelsController =
      AppGlobalPanelsController();
  NotificationsCubit? _notificationsCubit;
  ResourceChatFileContext? _resourceChatContext;
  bool _compactChatCloseScheduled = false;

  @override
  void initState() {
    super.initState();
    widget.appRouter.addListener(_routeLifecycle.didChangeRoute);
    final repository = context.read<NotificationsRepository?>();
    if (repository == null) return;
    _notificationsCubit = NotificationsCubit(
      repository,
      realtime: context.read<WorkspaceNotificationsRealtimeService?>(),
    );
    unawaited(_notificationsCubit!.load());
  }

  @override
  void dispose() {
    widget.appRouter.removeListener(_routeLifecycle.didChangeRoute);
    unawaited(_notificationsCubit?.close());
    _toastController.dispose();
    _routeLifecycle.dispose();
    _modalCoordinator.dispose();
    _panelsController.dispose();
    super.dispose();
  }

  void _openChat(BuildContext context) {
    final repository = context.read<ChatRepository?>();
    if (repository == null) {
      unawaited(widget.appRouter.navigatePath('/chat'));
      return;
    }
    final isWide =
        AppShellMetrics.of(context).viewportFor(
          MediaQuery.sizeOf(context).width,
        ) ==
        AppShellViewport.wide;
    _panelsController.showChat(pinned: isWide);
    if (isWide) {
      unawaited(
        context.read<LocalSettingsCubit>().setGlobalChatPanelPreferences(
          pinned: true,
          width: _panelsController.chatWidth,
          lastConversationId: _panelsController.lastChatConversationId,
        ),
      );
    }
    if (isWide) return;
    unawaited(
      AppGlobalChatDrawer.show(
        context,
        repository: repository,
        router: widget.appRouter,
        onConversationSelected: (conversationId) =>
            _recordChatConversation(context, conversationId),
        initialConversationId: _panelsController.lastChatConversationId,
        resourceConversationId: _resourceChatContext == null
            ? null
            : _panelsController.lastChatConversationId,
        resourceContext: _resourceChatContext,
        onResourceContextDismissed: _clearResourceChatContext,
      ).whenComplete(_panelsController.close),
    );
  }

  void _openNotifications(BuildContext context) {
    final repository = context.read<NotificationsRepository?>();
    if (repository == null) {
      unawaited(widget.appRouter.navigatePath('/notifications'));
      return;
    }
    _panelsController.showNotifications();
    unawaited(
      AppGlobalNotificationsDrawer.show(
        context,
        repository: repository,
      ).whenComplete(_panelsController.close),
    );
  }

  void _openResolvedConversation(
    BuildContext context,
    ResourceChatOpenRequest request,
  ) {
    setState(() => _resourceChatContext = request.fileContext);
    _panelsController.selectLastConversation(request.conversationId);
    _recordChatConversation(
      context,
      request.conversationId,
      preserveResourceContext: true,
    );
    _openChat(context);
  }

  void _openConversation(BuildContext context, String conversationId) {
    _recordChatConversation(context, conversationId);
    _openChat(context);
  }

  void _recordChatConversation(
    BuildContext context,
    String conversationId, {
    bool preserveResourceContext = false,
  }) {
    if (!preserveResourceContext) _clearResourceChatContext();
    _panelsController.selectLastConversation(conversationId);
    unawaited(
      context.read<LocalSettingsCubit>().setGlobalChatPanelPreferences(
        pinned: _panelsController.isChatPinned,
        width: _panelsController.chatWidth,
        lastConversationId: conversationId,
      ),
    );
  }

  void _clearResourceChatContext() {
    if (_resourceChatContext == null || !mounted) return;
    setState(() => _resourceChatContext = null);
  }

  void _persistChatPanelPreferences(BuildContext context) {
    unawaited(
      context.read<LocalSettingsCubit>().setGlobalChatPanelPreferences(
        pinned: _panelsController.isChatPinned,
        width: _panelsController.chatWidth,
        lastConversationId: _panelsController.lastChatConversationId,
      ),
    );
  }

  Future<void> _showChangelogModal(BuildContext presentationContext) async {
    await AppModalSheet.show<void>(
      presentationContext,
      title: presentationContext.l10n.appShellChangelogTitle,
      size: AppModalSheetSize.large,
      maxBodyHeight: 680,
      body: const AppShellChangelogBody(assetPath: _changelogAssetPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final permissions = switch (authState) {
      AuthAuthenticated(:final user) => user?.permissions ?? const <String>{},
      _ => const <String>{},
    };
    final modules = AppModulesCatalog.globalRailModulesFor(permissions);
    final order = [for (final module in modules) module.routePath];
    final intl = context.l10n;
    final labels = <String, String>{
      for (final module in modules) module.routePath: module.label(intl),
    };
    final icons = <String, IconData>{
      for (final module in modules) module.routePath: module.icon,
    };
    final preferenceKey = appNavigationPreferenceKey(
      context,
      _railPreferenceId,
    );
    final metrics = AppShellMetrics.of(context);

    return AppModalCoordinatorScope(
      coordinator: _modalCoordinator,
      child: AppOverlayRouteLifecycleScope(
        lifecycle: _routeLifecycle,
        child: AppBubbleToastScope(
          controller: _toastController,
          child: Builder(
            builder: (shellContext) => AppGlobalPanelsScope(
              controller: _panelsController,
              openConversation: (conversationId) =>
                  _openConversation(shellContext, conversationId),
              openResourceConversation: (request) =>
                  _openResolvedConversation(shellContext, request),
              child: _notificationsScope(
                BlocBuilder<LocalSettingsCubit, LocalSettingsModel>(
                  builder: (context, settings) {
                    _panelsController.restore(
                      chatPinned: settings.globalChatPinned,
                      chatWidth: settings.globalChatWidth,
                      lastChatConversationId:
                          settings.globalChatLastConversationId,
                    );
                    final isExpanded =
                        !(settings.sideMenuCollapsed[preferenceKey] ?? true);
                    return AppShellWallpaper(
                      refreshListenable: widget.appRouter,
                      child: SizedBox.expand(
                        child: Column(
                          children: [
                            AppShellTopBar(
                              key: AppShellMetrics.topBarSlotKey,
                              router: widget.appRouter,
                              topInset: MediaQuery.viewPaddingOf(context).top,
                              leftInset: MediaQuery.viewPaddingOf(context).left,
                              rightInset: MediaQuery.viewPaddingOf(context)
                                  .right,
                              onOpenChat: () => _openChat(context),
                              onOpenNotifications: () =>
                                  _openNotifications(context),
                            ),
                            Expanded(
                              child: MediaQuery.removeViewPadding(
                                context: context,
                                removeTop: true,
                                child: ListenableBuilder(
                                  listenable: _panelsController,
                                  builder: (context, _) {
                                    final isWide =
                                        metrics.viewportFor(
                                          MediaQuery.sizeOf(context).width,
                                        ) ==
                                        AppShellViewport.wide;
                                    _closePinnedChatAfterCompactResize(isWide);
                                    final pinnedChatWidth = _pinnedChatWidth(
                                      isWide,
                                    );
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned.fill(
                                          left: metrics.collapsedRailWidth,
                                          right: pinnedChatWidth,
                                          child: RepaintBoundary(
                                            child: KeyedSubtree(
                                              key: AppShellMetrics
                                                  .routedContentKey,
                                              child: widget.child,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          width: isExpanded
                                              ? metrics.expandedRailWidth
                                              : metrics.collapsedRailWidth,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 180,
                                            ),
                                            curve: Curves.easeOutCubic,
                                            child: AppGlobalModuleRail(
                                              isExpanded: isExpanded,
                                              router: widget.appRouter,
                                              defaultModuleOrder: order,
                                              moduleLabels: labels,
                                              moduleIcons: icons,
                                              onToggleExpanded: () => unawaited(
                                                context
                                                    .read<LocalSettingsCubit>()
                                                    .setNavigationPanelExpanded(
                                                      preferenceKey:
                                                          preferenceKey,
                                                      expanded: !isExpanded,
                                                    ),
                                              ),
                                              onCollapse: () => unawaited(
                                                context
                                                    .read<LocalSettingsCubit>()
                                                    .setNavigationPanelExpanded(
                                                      preferenceKey:
                                                          preferenceKey,
                                                      expanded: false,
                                                    ),
                                              ),
                                              onShowChangelog: () => unawaited(
                                                _showChangelogModal(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (isWide &&
                                            _panelsController
                                                .isPinnedChatVisible)
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            bottom: 0,
                                            width: _panelsController.chatWidth,
                                            child: _PinnedChatPane(
                                              router: widget.appRouter,
                                              onClose: _panelsController.close,
                                              initialConversationId:
                                                  _panelsController
                                                      .lastChatConversationId,
                                              onConversationSelected:
                                                  (conversationId) =>
                                                      _recordChatConversation(
                                                        context,
                                                        conversationId,
                                                      ),
                                              resourceConversationId:
                                                  _resourceChatContext == null
                                                  ? null
                                                  : _panelsController
                                                        .lastChatConversationId,
                                              resourceContext:
                                                  _resourceChatContext,
                                              onResourceContextDismissed:
                                                  _clearResourceChatContext,
                                              onWidthDelta: _panelsController
                                                  .adjustChatWidth,
                                              onWidthSettled: () =>
                                                  _persistChatPanelPreferences(
                                                    context,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Udostępnia jeden Cubit sesji wszystkim elementom prywatnego shellu.
  Widget _notificationsScope(Widget child) {
    final cubit = _notificationsCubit;
    return cubit == null
        ? child
        : BlocProvider<NotificationsCubit>.value(
            value: cubit,
            child: child,
          );
  }

  /// Zamyka wyłącznie bieżącą prezentację persistent pane po zmianie viewportu.
  ///
  /// Preferencja przypięcia pozostaje w settings, lecz compact nie może
  /// rezerwować desktopowej szerokości ani otwierać modalu w trakcie `build`.
  void _closePinnedChatAfterCompactResize(bool isWide) {
    if (isWide) {
      _compactChatCloseScheduled = false;
      return;
    }
    if (!_panelsController.isPinnedChatVisible || _compactChatCloseScheduled) {
      return;
    }
    _compactChatCloseScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _compactChatCloseScheduled = false;
      if (mounted && _panelsController.isPinnedChatVisible) {
        _panelsController.close();
      }
    });
  }

  double _pinnedChatWidth(bool isWide) {
    return isWide && _panelsController.isPinnedChatVisible
        ? _panelsController.chatWidth
        : 0;
  }
}

/// Przypięty pane Chat zachowujący trasę i zarezerwowaną szerokość contentu.
class _PinnedChatPane extends StatelessWidget {
  const _PinnedChatPane({
    required this.router,
    required this.onClose,
    required this.initialConversationId,
    required this.onConversationSelected,
    required this.onWidthDelta,
    required this.onWidthSettled,
    required this.resourceConversationId,
    required this.resourceContext,
    required this.onResourceContextDismissed,
  });

  final AppRouter router;
  final VoidCallback onClose;
  final String? initialConversationId;
  final ValueChanged<String> onConversationSelected;
  final ValueChanged<double> onWidthDelta;
  final VoidCallback onWidthSettled;
  final String? resourceConversationId;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback onResourceContextDismissed;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ChatRepository?>();
    if (repository == null) return const SizedBox.shrink();
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) =>
                onWidthDelta(-details.delta.dx),
            onHorizontalDragEnd: (_) => onWidthSettled(),
            child: const SizedBox(width: 8),
          ),
        ),
        Expanded(
          child: AppGlobalChatPanel(
            repository: repository,
            router: router,
            onClose: onClose,
            initialConversationId: initialConversationId,
            onConversationSelected: onConversationSelected,
            resourceConversationId: resourceConversationId,
            resourceContext: resourceContext,
            onResourceContextDismissed: onResourceContextDismissed,
            onOpenFullView: (conversationId) {
              onClose();
              unawaited(
                router.navigatePath('/chat/conversations/$conversationId'),
              );
            },
            fillAvailableWidth: true,
          ),
        ),
      ],
    );
  }
}
