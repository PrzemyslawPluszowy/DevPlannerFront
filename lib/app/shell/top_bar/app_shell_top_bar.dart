import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/app/shell/top_bar/app_shell_top_bar_actions.dart';
import 'package:ready_next/app/shell/top_bar/app_shell_top_bar_breadcrumb.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_state.dart';

/// Zarezerwowany pasek górny prywatnego shellu z własnym kontraktem geometrii.
class AppShellTopBar extends StatelessWidget {
  const AppShellTopBar({
    required this.router,
    required this.topInset,
    this.leftInset = 0,
    this.rightInset = 0,
    this.onOpenNotifications,
    this.onOpenChat,
    super.key,
  });

  /// Klucz rzeczywistego panelu belki, odrębnego od zarezerwowanego slotu.
  static const panelKey = ValueKey<String>('app-shell-top-bar-panel');

  final AppRouter router;
  final double topInset;
  final double leftInset;
  final double rightInset;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenChat;

  @override
  Widget build(BuildContext context) {
    final metrics = AppShellMetrics.of(context);
    final chatRepository = context.read<ChatRepository?>();

    return SizedBox(
      height: topInset + metrics.topBarSlotHeight,
      child: Padding(
        padding: EdgeInsets.only(
          left:
              leftInset +
              metrics.collapsedRailWidth +
              metrics.topBarHorizontalInset,
          top: topInset + metrics.topBarTopInset,
          right: rightInset + metrics.topBarHorizontalInset,
          bottom: metrics.topBarBottomInset,
        ),
        child: _AppShellTopBarSurface(
          panelKey: panelKey,
          child: ListenableBuilder(
            listenable: router,
            builder: (context, _) => _AppShellTopBarUnreadScope(
              router: router,
              chatRepository: chatRepository,
              onOpenNotifications: onOpenNotifications,
              onOpenChat: onOpenChat,
            ),
          ),
        ),
      ),
    );
  }
}

/// Jedyna dekoracyjna powierzchnia belki, niewpływająca na warstwę overlay.
class _AppShellTopBarSurface extends StatelessWidget {
  const _AppShellTopBarSurface({
    required this.child,
    required this.panelKey,
  });

  final Widget child;
  final Key panelKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.theme.brightness == Brightness.dark;
    return Material(
      key: panelKey,
      color: isDark
          ? colors.surfaceContainer.withValues(alpha: .82)
          : colors.surfaceContainerLowest.withValues(alpha: .86),
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? colors.outlineVariant.withValues(alpha: .55)
                : colors.outlineVariant.withValues(alpha: .42),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .22 : .06),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Krótko żyjący scope licznika powiadomień należący do UI belki sesji.
class _AppShellTopBarUnreadScope extends StatelessWidget {
  const _AppShellTopBarUnreadScope({
    required this.router,
    required this.chatRepository,
    required this.onOpenNotifications,
    required this.onOpenChat,
  });

  final AppRouter router;
  final ChatRepository? chatRepository;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenChat;

  @override
  Widget build(BuildContext context) {
    final notificationRepository = context.read<NotificationsRepository?>();
    final cubit = context.read<NotificationsCubit?>();
    if (cubit == null) {
      return _AppShellTopBarLayout(
        router: router,
        unreadNotifications: null,
        notificationRepository: notificationRepository,
        chatRepository: chatRepository,
        onOpenNotifications: onOpenNotifications,
        onOpenChat: onOpenChat,
      );
    }
    return BlocSelector<NotificationsCubit, NotificationsState, int?>(
      selector: (state) => switch (state) {
        NotificationsReady(:final unreadCount) => unreadCount,
        NotificationsEmpty(:final unreadCount) => unreadCount,
        _ => null,
      },
      builder: (context, unreadNotifications) => _AppShellTopBarLayout(
        router: router,
        unreadNotifications: unreadNotifications,
        notificationRepository: notificationRepository,
        chatRepository: chatRepository,
        onOpenNotifications: onOpenNotifications,
        onOpenChat: onOpenChat,
      ),
    );
  }
}

/// Układ sekcji belki, który reaguje na klasę szerokości i skalę tekstu.
class _AppShellTopBarLayout extends StatelessWidget {
  const _AppShellTopBarLayout({
    required this.router,
    required this.unreadNotifications,
    required this.notificationRepository,
    required this.chatRepository,
    required this.onOpenNotifications,
    required this.onOpenChat,
  });

  final AppRouter router;
  final int? unreadNotifications;
  final NotificationsRepository? notificationRepository;
  final ChatRepository? chatRepository;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenChat;

  @override
  Widget build(BuildContext context) {
    final metrics = AppShellMetrics.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = metrics.viewportFor(MediaQuery.sizeOf(context).width);
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: metrics.topBarHorizontalInset,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppShellTopBarBreadcrumb(
                  router: router,
                  viewport: viewport,
                ),
              ),
              AppShellTopBarActions(
                router: router,
                unreadNotifications: unreadNotifications,
                notificationRepository: notificationRepository,
                chatRepository: chatRepository,
                onOpenNotifications: onOpenNotifications,
                onOpenChat: onOpenChat,
              ),
            ],
          ),
        );
      },
    );
  }
}
