import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_realtime_status_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_state.dart';
import 'package:ready_next/workspaces/presentation/notifications/notification_widgets.dart';
import 'package:ready_next/workspaces/presentation/notifications/preferences/notification_preferences_modal.dart';

/// Placeholder globalnej skrzynki powiadomień.
///
/// Docelowy ekran zostanie podłączony przez repository/Cubit. Ta wersja
/// gwarantuje, że globalny deep link ma własny, jawny ekran zamiast fallbacku.
class GlobalNotificationsPage extends StatelessWidget {
  const GlobalNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<NotificationsCubit?>() != null) {
      return const _NotificationsView();
    }
    return BlocProvider(
      create: (context) {
        final cubit = NotificationsCubit(
          context.read<NotificationsRepository>(),
          realtime: context.read<WorkspaceNotificationsRealtimeService>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _NotificationsView(),
    );
  }
}

/// Wejście do istniejącego drawera powiadomień przez wspólny host modalny.
abstract final class AppGlobalNotificationsDrawer {
  /// Otwiera panel nad bieżącą trasą bez zmiany jej location.
  static Future<void> show(
    BuildContext context, {
    required NotificationsRepository repository,
  }) async {
    await AppModalHost.showSideSheet<void>(
      context,
      builder: (context) => Align(
        alignment: Alignment.centerRight,
        child: AppGlobalNotificationsPanel(repository: repository),
      ),
    );
  }
}

/// Ekran globalnej skrzynki z jawnymi stanami API i nawigacją deep linków.
class _NotificationsView extends StatelessWidget {
  const _NotificationsView({this.drawer = false, this.onClose});

  final bool drawer;
  final VoidCallback? onClose;

  Widget _body(BuildContext context) =>
      BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) => Column(
          children: [
            _RefreshErrorBanner(refreshError: _refreshErrorFor(state)),
            Expanded(child: _contentFor(context, state)),
          ],
        ),
      );

  Widget _contentFor(BuildContext context, NotificationsState state) =>
      switch (state) {
        NotificationsInitial() || NotificationsLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        NotificationsEmpty(:final inbox) =>
          inbox.groups.isEmpty && inbox.items.isEmpty
              ? NotificationsMessage(
                  icon: WorkspaceIcons.notifications,
                  title: context.l10n.globalNotificationsEmptyTitle,
                  message: context.l10n.globalNotificationsEmptyMessage,
                )
              : NotificationsList(inbox: inbox),
        NotificationsUnauthorized(:final message) => NotificationsError(
          title: context.l10n.globalNotificationsSessionRequired,
          message: message,
        ),
        NotificationsForbidden(:final message) => NotificationsError(
          title: context.l10n.globalNotificationsAccessDenied,
          message: message,
        ),
        NotificationsFailure(:final message) => NotificationsError(
          title: context.l10n.globalNotificationsLoadFailureTitle,
          message: message,
        ),
        NotificationsReady(:final inbox) => NotificationsList(inbox: inbox),
      };

  String? _refreshErrorFor(NotificationsState state) => switch (state) {
    NotificationsReady(:final refreshError) ||
    NotificationsEmpty(:final refreshError) => refreshError,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    if (!drawer) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.globalNotificationsTitle),
          actions: [
            IconButton(
              tooltip: context.l10n.notificationPreferencesOpen,
              onPressed: () => unawaited(
                AppNotificationPreferencesModal.show(context),
              ),
              icon: const Icon(Symbols.settings_rounded),
            ),
            IconButton(
              tooltip: context.l10n.globalNotificationsMarkAllRead,
              onPressed: () => unawaited(
                context.read<NotificationsCubit>().markAllRead(),
              ),
              icon: const Icon(Symbols.done_all_rounded),
            ),
          ],
        ),
        body: _NotificationsRealtimeScope(child: _body(context)),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 384,
        height: double.infinity,
        margin: const EdgeInsets.all(Sizes.p12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: .16),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 32,
              color: Color(0x33000000),
              offset: Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p16,
                Sizes.p12,
                Sizes.p8,
                Sizes.p8,
              ),
              child: Row(
                children: [
                  const Icon(WorkspaceIcons.notifications, size: 20),
                  Gaps.w8,
                  Expanded(
                    child: Text(
                      context.l10n.globalNotificationsTitle,
                      style: context.text.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.notificationPreferencesOpen,
                    onPressed: () => unawaited(
                      AppNotificationPreferencesModal.show(context),
                    ),
                    icon: const Icon(Symbols.settings_rounded, size: 19),
                  ),
                  IconButton(
                    tooltip: context.l10n.globalNotificationsMarkAllRead,
                    onPressed: () => unawaited(
                      context.read<NotificationsCubit>().markAllRead(),
                    ),
                    icon: const Icon(Symbols.done_all_rounded, size: 19),
                  ),
                  IconButton(
                    tooltip: context.l10n.frameworkClose,
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    icon: const Icon(Symbols.close, size: 19),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _NotificationsRealtimeScope(child: _body(context)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dodaje nieblokujący status transportu nad snapshotem istniejącego inboxa.
class _NotificationsRealtimeScope extends StatelessWidget {
  const _NotificationsRealtimeScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final realtime = context.read<WorkspaceNotificationsRealtimeService?>();
    if (realtime == null) return child;
    return BlocProvider(
      create: (context) => NotificationsRealtimeStatusCubit(realtime),
      child: Column(
        children: [
          const _NotificationsConnectionBanner(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NotificationsConnectionBanner extends StatelessWidget {
  const _NotificationsConnectionBanner();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        NotificationsRealtimeStatusCubit,
        WorkspaceSignalRConnectionState
      >(
        builder: (context, state) {
          final message = switch (state) {
            WorkspaceSignalRConnectionState.connected => null,
            WorkspaceSignalRConnectionState.reconnecting =>
              context.l10n.globalNotificationsReconnecting,
            WorkspaceSignalRConnectionState.connecting =>
              context.l10n.globalNotificationsConnecting,
            WorkspaceSignalRConnectionState.disconnected =>
              context.l10n.globalNotificationsOffline,
          };
          if (message == null) return const SizedBox.shrink();
          return _NotificationsBanner(message: message);
        },
      );
}

class _RefreshErrorBanner extends StatelessWidget {
  const _RefreshErrorBanner({required this.refreshError});

  final String? refreshError;

  @override
  Widget build(BuildContext context) {
    final error = refreshError;
    if (error == null) return const SizedBox.shrink();
    return _NotificationsBanner(
      message: '${context.l10n.globalNotificationsRefreshFailed}: $error',
    );
  }
}

class _NotificationsBanner extends StatelessWidget {
  const _NotificationsBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p12,
          vertical: Sizes.p8,
        ),
        child: Row(
          children: [
            Icon(
              Symbols.info,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Gaps.w8,
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Wielokrotnego użycia zawartość panelu powiadomień bez zmiany trasy.
class AppGlobalNotificationsPanel extends StatelessWidget {
  const AppGlobalNotificationsPanel({
    required this.repository,
    this.onClose,
    super.key,
  });

  final NotificationsRepository repository;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<NotificationsCubit?>();
    if (sessionCubit != null) {
      return _NotificationsView(drawer: true, onClose: onClose);
    }
    return BlocProvider(
      create: (context) {
        final cubit = NotificationsCubit(
          repository,
          realtime: context.read<WorkspaceNotificationsRealtimeService>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: _NotificationsView(drawer: true, onClose: onClose),
    );
  }
}
