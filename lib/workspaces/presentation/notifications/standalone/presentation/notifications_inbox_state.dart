import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_models.dart';
import 'package:equatable/equatable.dart';

enum StandaloneNotificationsInboxStatus { initial, loading, ready, failure }

/// Stan lokalnej skrzynki powiadomień; nie jest globalnym stanem aplikacji.
final class StandaloneNotificationsInboxState extends Equatable {
  const StandaloneNotificationsInboxState({
    this.status = StandaloneNotificationsInboxStatus.initial,
    this.items = const <StandaloneNotificationItem>[],
    this.nextCursor,
    this.unreadCount = 0,
    this.isLoadingMore = false,
    this.error,
    this.unreadOnly = false,
  });

  final StandaloneNotificationsInboxStatus status;
  final List<StandaloneNotificationItem> items;
  final String? nextCursor;
  final int unreadCount;
  final bool isLoadingMore;
  final ApiError? error;
  final bool unreadOnly;

  bool get isEmpty => items.isEmpty;
  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;

  StandaloneNotificationsInboxState copyWith({
    StandaloneNotificationsInboxStatus? status,
    List<StandaloneNotificationItem>? items,
    Object? nextCursor = _unset,
    int? unreadCount,
    bool? isLoadingMore,
    Object? error = _unset,
    bool? unreadOnly,
  }) {
    return StandaloneNotificationsInboxState(
      status: status ?? this.status,
      items: items ?? this.items,
      nextCursor: identical(nextCursor, _unset)
          ? this.nextCursor
          : nextCursor as String?,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: identical(error, _unset) ? this.error : error as ApiError?,
      unreadOnly: unreadOnly ?? this.unreadOnly,
    );
  }

  static const Object _unset = Object();

  @override
  List<Object?> get props => [
    status,
    items,
    nextCursor,
    unreadCount,
    isLoadingMore,
    error,
    unreadOnly,
  ];
}
