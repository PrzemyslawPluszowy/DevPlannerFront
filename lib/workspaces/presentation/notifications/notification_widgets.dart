import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_deep_link.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_state.dart';
import 'package:ready_next/workspaces/presentation/notifications/reply/notification_reply_modal.dart';

/// Listowa prezentacja cursorowego snapshotu; wszystkie intencje trafiają do Cubita.
class NotificationsList extends StatelessWidget {
  const NotificationsList({required this.inbox, super.key});
  final NotificationsInbox inbox;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.symmetric(
      horizontal: Sizes.p12,
      vertical: Sizes.p8,
    ),
    children: [
      _InboxFilters(inbox: inbox),
      if (inbox.unreadCount > 0)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
          child: Text(
            context.l10n.globalNotificationsUnreadCount(inbox.unreadCount),
            style: context.text.labelMedium,
          ),
        ),
      if (inbox.view == NotificationsInboxView.groups)
        for (final group in inbox.groups) _NotificationGroupTile(group: group)
      else
        for (final item in inbox.items) _NotificationItemTile(item: item),
      if (inbox.canLoadMore || inbox.isLoadingMore)
        Padding(
          padding: const EdgeInsets.only(top: Sizes.p8),
          child: FilledButton.tonal(
            onPressed: inbox.isLoadingMore
                ? null
                : () =>
                      unawaited(context.read<NotificationsCubit>().loadMore()),
            child: inbox.isLoadingMore
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.globalNotificationsLoadMore),
          ),
        ),
    ],
  );
}

class _InboxFilters extends StatelessWidget {
  const _InboxFilters({required this.inbox});
  final NotificationsInbox inbox;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<NotificationsInboxView>(
          segments: [
            ButtonSegment(
              value: NotificationsInboxView.groups,
              label: Text(context.l10n.globalNotificationsGroups),
            ),
            ButtonSegment(
              value: NotificationsInboxView.items,
              label: Text(context.l10n.globalNotificationsItems),
            ),
          ],
          selected: {inbox.view},
          onSelectionChanged: (value) => cubit.selectView(value.single),
        ),
        SizedBox(
          width: double.infinity,
          child: DropdownButton<NotificationCategory?>(
            isExpanded: true,
            value: inbox.category,
            hint: Text(context.l10n.globalNotificationsAllCategories),
            items: [
              DropdownMenuItem<NotificationCategory?>(
                child: Text(context.l10n.globalNotificationsAllCategories),
              ),
              for (final category in NotificationCategory.values)
                DropdownMenuItem(value: category, child: Text(category.name)),
            ],
            onChanged: (value) => cubit.setFilters(
              category: value,
              clearCategory: value == null,
            ),
          ),
        ),
        FilterChip(
          label: Text(context.l10n.globalNotificationsUnreadOnly),
          selected: inbox.unreadOnly,
          onSelected: (value) => cubit.setFilters(unreadOnly: value),
        ),
      ],
    );
  }
}

class _NotificationGroupTile extends StatelessWidget {
  const _NotificationGroupTile({required this.group});
  final NotificationGroupResponse group;
  @override
  Widget build(BuildContext context) {
    final latest = group.latest;
    return Card(
      child: ListTile(
        leading: Icon(_NotificationPresentation.categoryIcon(latest.category)),
        title: Text(latest.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          latest.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NotificationReplyAction(notification: latest),
            _GroupMenu(group: group),
          ],
        ),
        onTap: latest.deepLink == null
            ? null
            : () {
                unawaited(
                  context.read<NotificationsCubit>().markGroupRead(
                    group.groupKey,
                  ),
                );
                AppDeepLink.navigate(context.router, latest.deepLink);
              },
      ),
    );
  }
}

class _GroupMenu extends StatelessWidget {
  const _GroupMenu({required this.group});
  final NotificationGroupResponse group;
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: context.l10n.globalNotificationsGroupActions,
    onSelected: (action) {
      final cubit = context.read<NotificationsCubit>();
      switch (action) {
        case 'read':
          unawaited(cubit.markGroupRead(group.groupKey));
        case 'archive':
          unawaited(cubit.archiveGroup(group.groupKey));
        case 'pin':
          unawaited(
            cubit.quickAction(
              group.latest.id,
              group.latest.isPinned
                  ? NotificationQuickActionKind.unpin
                  : NotificationQuickActionKind.pin,
            ),
          );
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'read',
        child: Text(context.l10n.globalNotificationsMarkGroupRead),
      ),
      PopupMenuItem(
        value: 'pin',
        child: Text(
          group.latest.isPinned
              ? context.l10n.globalNotificationsUnpin
              : context.l10n.globalNotificationsPin,
        ),
      ),
      PopupMenuItem(
        value: 'archive',
        child: Text(context.l10n.globalNotificationsArchive),
      ),
    ],
  );
}

class _NotificationItemTile extends StatelessWidget {
  const _NotificationItemTile({required this.item});
  final WorkspaceNotificationResponse item;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(_NotificationPresentation.categoryIcon(item.category)),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.isPinned) const Icon(Symbols.push_pin_rounded, size: 16),
        ],
      ),
      subtitle: Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: NotificationReplyAction(notification: item),
      onTap: item.deepLink == null
          ? null
          : () {
              unawaited(
                context.read<NotificationsCubit>().quickAction(
                  item.id,
                  NotificationQuickActionKind.markRead,
                ),
              );
              AppDeepLink.navigate(context.router, item.deepLink);
            },
    ),
  );
}

abstract final class _NotificationPresentation {
  static IconData categoryIcon(NotificationCategory category) =>
      switch (category) {
        NotificationCategory.task => WorkspaceIcons.tasks,
        NotificationCategory.comment ||
        NotificationCategory.chat => WorkspaceIcons.chat,
        NotificationCategory.invitation ||
        NotificationCategory.membership => WorkspaceIcons.members,
        NotificationCategory.storage => WorkspaceIcons.file,
        NotificationCategory.project => WorkspaceIcons.folders,
        NotificationCategory.workspace => WorkspaceIcons.workspaces,
        _ => WorkspaceIcons.notifications,
      };
}

class NotificationsMessage extends StatelessWidget {
  const NotificationsMessage({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });
  final IconData icon;
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          Gaps.h12,
          Text(
            title,
            style: context.text.titleLarge,
            textAlign: TextAlign.center,
          ),
          Gaps.h8,
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class NotificationsError extends StatelessWidget {
  const NotificationsError({
    required this.title,
    required this.message,
    super.key,
  });
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => NotificationsMessage(
    icon: Symbols.error_outline,
    title: title,
    message: message,
  );
}
