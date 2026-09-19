import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_gateway.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_models.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Samodzielny, osadzalny panel skrzynki Notifications.
///
/// Panel nie rejestruje trasy i nie zna root shella. Integrator dostarcza
/// gateway z composition root, a właścicielem lokalnego Cubita jest provider.
final class StandaloneNotificationsInboxPanel extends StatelessWidget {
  const StandaloneNotificationsInboxPanel({
    required this.gateway,
    super.key,
  });

  final StandaloneNotificationsInboxGateway gateway;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = StandaloneNotificationsInboxCubit(gateway);
        unawaited(cubit.load());
        return cubit;
      },
      child: const _StandaloneNotificationsInboxBody(),
    );
  }
}

final class _StandaloneNotificationsInboxBody extends StatelessWidget {
  const _StandaloneNotificationsInboxBody();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child:
          BlocBuilder<
            StandaloneNotificationsInboxCubit,
            StandaloneNotificationsInboxState
          >(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(state: state),
                  Expanded(child: _Content(state: state)),
                ],
              );
            },
          ),
    );
  }
}

final class _Header extends StatelessWidget {
  const _Header({required this.state});

  final StandaloneNotificationsInboxState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.globalNotificationsTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(l10n.globalNotificationsUnreadCount(state.unreadCount)),
              ],
            ),
          ),
          IconButton(
            onPressed:
                state.status == StandaloneNotificationsInboxStatus.loading
                ? null
                : () =>
                      context.read<StandaloneNotificationsInboxCubit>().retry(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

final class _Content extends StatelessWidget {
  const _Content({required this.state});

  final StandaloneNotificationsInboxState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == StandaloneNotificationsInboxStatus.initial ||
        state.status == StandaloneNotificationsInboxStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == StandaloneNotificationsInboxStatus.failure) {
      return _Failure(error: state.error);
    }
    if (state.items.isEmpty) {
      return _Empty();
    }
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _NotificationTile(
              item: state.items[index],
              onPressed: () => context
                  .read<StandaloneNotificationsInboxCubit>()
                  .markRead(state.items[index].id),
            ),
          ),
        ),
        if (state.hasMore)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: OutlinedButton(
              onPressed: state.isLoadingMore
                  ? null
                  : () => context
                        .read<StandaloneNotificationsInboxCubit>()
                        .loadMore(),
              child: state.isLoadingMore
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(context.l10n.globalNotificationsLoadMore),
            ),
          ),
      ],
    );
  }
}

final class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onPressed});

  final StandaloneNotificationItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(context)
        .formatMediumDate(item.createdAtUtc.toLocal());
    return InkWell(
      onTap: item.isUnread ? onPressed : null,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isUnread
              ? Theme.of(context).colorScheme.primaryContainer
                    .withValues(alpha: .35)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              item.isUnread
                  ? Icons.notifications_active
                  : Icons.notifications_none,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(item.body),
                  const SizedBox(height: 6),
                  Text(date, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_none, size: 40),
            const SizedBox(height: 12),
            Text(context.l10n.globalNotificationsEmptyTitle),
            const SizedBox(height: 4),
            Text(
              context.l10n.globalNotificationsEmptyMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

final class _Failure extends StatelessWidget {
  const _Failure({required this.error});

  final ApiError? error;

  @override
  Widget build(BuildContext context) {
    final message = switch (error?.type) {
      ApiErrorType.unauthorized =>
        context.l10n.globalNotificationsSessionRequired,
      ApiErrorType.forbidden => context.l10n.globalNotificationsAccessDenied,
      _ => context.l10n.globalNotificationsLoadFailureTitle,
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.read<StandaloneNotificationsInboxCubit>().retry(),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
