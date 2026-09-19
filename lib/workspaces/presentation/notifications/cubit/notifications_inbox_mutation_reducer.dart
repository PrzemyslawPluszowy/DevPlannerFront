import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:devplanner/workspaces/presentation/notifications/cubit/notifications_state.dart';

/// Czyste przejścia optymistycznego stanu skrzynki powiadomień.
///
/// Nie wykonuje I/O ani nie emituje stanu. Dzięki temu Cubit inboxa odpowiada
/// wyłącznie za kolejkę operacji, błędy i lifecycle realtime.
final class NotificationsInboxMutationReducer {
  const NotificationsInboxMutationReducer._();

  static NotificationsInbox markAllRead(NotificationsInbox inbox) =>
      inbox.copyWith(
        unreadCount: 0,
        groups: [
          for (final group in inbox.groups) group.copyWith(unreadCount: 0),
        ],
        items: [
          for (final item in inbox.items)
            item.copyWith(readAtUtc: DateTime.now().toUtc()),
        ],
      );

  static NotificationsInbox markGroupRead(
    NotificationsInbox inbox,
    String key,
  ) {
    final removed = inbox.groups
        .where((group) => group.groupKey == key)
        .fold(0, (sum, group) => sum + group.unreadCount);
    return inbox.copyWith(
      unreadCount: (inbox.unreadCount - removed).clamp(0, inbox.unreadCount),
      groups: [
        for (final group in inbox.groups)
          if (group.groupKey == key) group.copyWith(unreadCount: 0) else group,
      ],
      items: [
        for (final item in inbox.items)
          if (item.groupKey == key && item.readAtUtc == null)
            item.copyWith(readAtUtc: DateTime.now().toUtc())
          else
            item,
      ],
    );
  }

  static NotificationsInbox archiveGroup(NotificationsInbox inbox, String key) {
    final removed = inbox.groups
        .where((group) => group.groupKey == key)
        .fold(0, (sum, group) => sum + group.unreadCount);
    return inbox.copyWith(
      unreadCount: (inbox.unreadCount - removed).clamp(0, inbox.unreadCount),
      groups: inbox.groups
          .where((group) => group.groupKey != key)
          .toList(growable: false),
      items: inbox.items
          .where((item) => item.groupKey != key)
          .toList(growable: false),
    );
  }

  static NotificationsInbox quickAction(
    NotificationsInbox inbox,
    String id,
    NotificationQuickActionKind action,
  ) {
    final matchingGroup = inbox.groups
        .where((group) => group.latest.id == id)
        .firstOrNull;
    final target =
        inbox.items.where((item) => item.id == id).firstOrNull ??
        matchingGroup?.latest;
    final isUnread = target != null && target.readAtUtc == null;
    final groupKey = target?.groupKey ?? matchingGroup?.groupKey;
    return switch (action) {
      NotificationQuickActionKind.markRead => _markNotificationRead(
        inbox,
        id: id,
        isUnread: isUnread,
        groupKey: groupKey,
      ),
      NotificationQuickActionKind.archive => _archiveNotification(inbox, id),
      NotificationQuickActionKind.pin || NotificationQuickActionKind.unpin =>
        _setPinned(inbox, id, action == NotificationQuickActionKind.pin),
      _ => inbox,
    };
  }

  /// Scala strony listy po identyfikatorze bez duplikatów.
  static List<WorkspaceNotificationResponse> mergeItems(
    List<WorkspaceNotificationResponse> old,
    List<WorkspaceNotificationResponse> fresh,
  ) {
    final entries = <String, WorkspaceNotificationResponse>{
      for (final item in old) item.id: item,
    };
    for (final item in fresh) {
      entries[item.id] = item;
    }
    return List.unmodifiable(entries.values);
  }

  static NotificationsInbox _markNotificationRead(
    NotificationsInbox inbox, {
    required String id,
    required bool isUnread,
    required String? groupKey,
  }) => inbox.copyWith(
    unreadCount: isUnread
        ? (inbox.unreadCount - 1).clamp(0, inbox.unreadCount)
        : inbox.unreadCount,
    items: [
      for (final item in inbox.items)
        if (item.id == id && item.readAtUtc == null)
          item.copyWith(readAtUtc: DateTime.now().toUtc())
        else
          item,
    ],
    groups: [
      for (final group in inbox.groups)
        if (group.groupKey == groupKey && isUnread)
          group.copyWith(
            unreadCount: (group.unreadCount - 1).clamp(0, group.unreadCount),
            latest: group.latest.id == id
                ? group.latest.copyWith(readAtUtc: DateTime.now().toUtc())
                : group.latest,
          )
        else
          group,
    ],
  );

  static NotificationsInbox _archiveNotification(
    NotificationsInbox inbox,
    String id,
  ) {
    final matchingGroup = inbox.groups
        .where((group) => group.latest.id == id)
        .firstOrNull;
    final target =
        inbox.items.where((item) => item.id == id).firstOrNull ??
        matchingGroup?.latest;
    final isUnread = target != null && target.readAtUtc == null;
    final groupKey = target?.groupKey ?? matchingGroup?.groupKey;
    final groups = <NotificationGroupResponse>[
      for (final group in inbox.groups)
        if (!group.notificationIds.contains(id))
          group
        else if (group.count > 1)
          group.copyWith(
            count: group.count - 1,
            unreadCount: groupKey == group.groupKey && isUnread
                ? (group.unreadCount - 1).clamp(0, group.unreadCount)
                : group.unreadCount,
            notificationIds: group.notificationIds
                .where((notificationId) => notificationId != id)
                .toList(growable: false),
          ),
    ];
    return inbox.copyWith(
      unreadCount: isUnread
          ? (inbox.unreadCount - 1).clamp(0, inbox.unreadCount)
          : inbox.unreadCount,
      items: inbox.items.where((item) => item.id != id).toList(growable: false),
      groups: groups,
    );
  }

  static NotificationsInbox _setPinned(
    NotificationsInbox inbox,
    String id,
    bool isPinned,
  ) => inbox.copyWith(
    items: [
      for (final item in inbox.items)
        if (item.id == id) item.copyWith(isPinned: isPinned) else item,
    ],
    groups: [
      for (final group in inbox.groups)
        if (group.latest.id == id)
          group.copyWith(latest: group.latest.copyWith(isPinned: isPinned))
        else
          group,
    ],
  );
}
