import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';

/// Aktywny, niezależnie stronicowany widok skrzynki.
enum NotificationsInboxView { groups, items }

/// Niezmienny snapshot skrzynki; kursory są nieprzezroczystymi danymi backendu.
class NotificationsInbox {
  const NotificationsInbox({
    required this.groups,
    required this.items,
    required this.unreadCount,
    required this.groupNextCursor,
    required this.itemNextCursor,
    required this.view,
    required this.category,
    required this.unreadOnly,
    this.isLoadingMore = false,
    this.refreshError,
  });

  final List<NotificationGroupResponse> groups;
  final List<WorkspaceNotificationResponse> items;
  final int unreadCount;
  final String? groupNextCursor;
  final String? itemNextCursor;
  final NotificationsInboxView view;
  final NotificationCategory? category;
  final bool unreadOnly;
  final bool isLoadingMore;
  final String? refreshError;

  bool get canLoadMore => switch (view) {
    NotificationsInboxView.groups => groupNextCursor != null,
    NotificationsInboxView.items => itemNextCursor != null,
  };

  NotificationsInbox copyWith({
    List<NotificationGroupResponse>? groups,
    List<WorkspaceNotificationResponse>? items,
    int? unreadCount,
    String? groupNextCursor,
    bool clearGroupNextCursor = false,
    String? itemNextCursor,
    bool clearItemNextCursor = false,
    NotificationsInboxView? view,
    NotificationCategory? category,
    bool clearCategory = false,
    bool? unreadOnly,
    bool? isLoadingMore,
    String? refreshError,
    bool clearRefreshError = false,
  }) => NotificationsInbox(
    groups: groups ?? this.groups,
    items: items ?? this.items,
    unreadCount: unreadCount ?? this.unreadCount,
    groupNextCursor: clearGroupNextCursor
        ? null
        : groupNextCursor ?? this.groupNextCursor,
    itemNextCursor: clearItemNextCursor
        ? null
        : itemNextCursor ?? this.itemNextCursor,
    view: view ?? this.view,
    category: clearCategory ? null : category ?? this.category,
    unreadOnly: unreadOnly ?? this.unreadOnly,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    refreshError: clearRefreshError ? null : refreshError ?? this.refreshError,
  );
}

sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsReady extends NotificationsState {
  const NotificationsReady(this.inbox);
  final NotificationsInbox inbox;
  List<NotificationGroupResponse> get groups => inbox.groups;
  List<WorkspaceNotificationResponse> get items => inbox.items;
  int get unreadCount => inbox.unreadCount;
  String? get refreshError => inbox.refreshError;
}

final class NotificationsEmpty extends NotificationsState {
  const NotificationsEmpty(this.inbox);
  final NotificationsInbox inbox;
  int get unreadCount => inbox.unreadCount;
  String? get refreshError => inbox.refreshError;
}

final class NotificationsUnauthorized extends NotificationsState {
  const NotificationsUnauthorized(this.message);
  final String message;
}

final class NotificationsForbidden extends NotificationsState {
  const NotificationsForbidden(this.message);
  final String message;
}

final class NotificationsFailure extends NotificationsState {
  const NotificationsFailure(this.message);
  final String message;
}
