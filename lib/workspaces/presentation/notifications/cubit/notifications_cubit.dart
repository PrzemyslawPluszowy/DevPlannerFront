import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_state.dart';

/// Sesyjny Cubit inboxa: scala strony cursora, ale nie zna widżetów ani routingu.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(
    NotificationsRepository repository, {
    WorkspaceNotificationsRealtimeService? realtime,
  }) : _repository = repository,
       // Keep the public constructor parameter named `realtime`.
       // ignore: prefer_initializing_formals
       _realtime = realtime,
       super(const NotificationsInitial()) {
    _subscription = _realtime?.events.listen(_reduceRealtimeEvent);
    unawaited(_startRealtime());
  }

  final NotificationsRepository _repository;
  final WorkspaceNotificationsRealtimeService? _realtime;
  StreamSubscription<Object>? _subscription;
  Future<void>? _loadInFlight;
  Future<void> _mutationTail = Future<void>.value();
  int _pendingMutations = 0;
  bool _refreshQueued = false;
  int _queryGeneration = 0;
  final Map<String, int> _latestGroupSequences = <String, int>{};
  final Set<String> _seenNotificationEventIds = <String>{};

  Future<void> load() => refresh(showLoading: true);
  Future<void> refresh({bool showLoading = false}) =>
      _load(reset: true, showLoading: showLoading);

  Future<void> loadMore() {
    final inbox = _inbox;
    if (inbox == null || inbox.isLoadingMore || !inbox.canLoadMore) {
      return Future.value();
    }
    return _load(reset: false, showLoading: false);
  }

  void selectView(NotificationsInboxView view) {
    final inbox = _inbox;
    if (inbox == null || inbox.view == view) return;
    _invalidateQuery();
    _emitInbox(inbox.copyWith(view: view, clearRefreshError: true));
    final isEmpty = view == NotificationsInboxView.groups
        ? inbox.groups.isEmpty
        : inbox.items.isEmpty;
    if (isEmpty) {
      unawaited(_load(reset: true, showLoading: false));
    }
  }

  void setFilters({
    NotificationCategory? category,
    bool clearCategory = false,
    bool? unreadOnly,
  }) {
    final inbox = _inbox;
    if (inbox == null) return;
    _invalidateQuery();
    _latestGroupSequences.clear();
    _emitInbox(
      inbox.copyWith(
        groups: const [],
        items: const [],
        clearGroupNextCursor: true,
        clearItemNextCursor: true,
        category: category,
        clearCategory: clearCategory,
        unreadOnly: unreadOnly,
        clearRefreshError: true,
      ),
    );
    unawaited(_load(reset: true, showLoading: false));
  }

  Future<void> _load({required bool reset, required bool showLoading}) {
    final active = _loadInFlight;
    if (active != null) {
      _refreshQueued = true;
      return active;
    }
    final operation = _loadInternal(
      reset: reset,
      showLoading: showLoading,
      generation: _queryGeneration,
    );
    _loadInFlight = operation;
    return operation.whenComplete(() {
      _loadInFlight = null;
      if (_refreshQueued && !isClosed) {
        _refreshQueued = false;
        unawaited(_load(reset: true, showLoading: false));
      }
    });
  }

  Future<void> _loadInternal({
    required bool reset,
    required bool showLoading,
    required int generation,
  }) async {
    if (!_isCurrent(generation)) return;
    var inbox = _inbox ?? _initialInbox;
    if (showLoading && _inbox == null) emit(const NotificationsLoading());
    if (!reset) _emitInbox(inbox.copyWith(isLoadingMore: true));
    final cursor = inbox.view == NotificationsInboxView.groups
        ? (reset ? null : inbox.groupNextCursor)
        : (reset ? null : inbox.itemNextCursor);
    if (inbox.view == NotificationsInboxView.groups) {
      final pageFuture = _repository.listGroups(
        cursor: cursor,
        category: inbox.category,
        unreadOnly: inbox.unreadOnly,
      );
      final count = reset ? await _repository.unreadCount() : null;
      if (!_isCurrent(generation)) return;
      final countError = count?.fold<ApiError?>((error) => error, (_) => null);
      if (countError != null && _isCurrent(generation)) {
        _emitError(countError);
        return;
      }
      final unread =
          count?.fold<int>((_) => inbox.unreadCount, (value) => value) ??
          inbox.unreadCount;
      final page = await pageFuture;
      if (!_isCurrent(generation)) return;
      page.fold(
        (error) {
          if (_isCurrent(generation)) _emitError(error);
        },
        (typed) {
          if (!_isCurrent(generation)) return;
          inbox = inbox.copyWith(
            groups: _mergeGroups(reset ? const [] : inbox.groups, typed.items),
            groupNextCursor: typed.nextCursor,
            clearGroupNextCursor: typed.nextCursor == null,
            unreadCount: unread,
            isLoadingMore: false,
            clearRefreshError: true,
          );
          _emitInbox(inbox);
        },
      );
    } else {
      final pageFuture = _repository.listNotifications(
        cursor: cursor,
        category: inbox.category,
        unreadOnly: inbox.unreadOnly,
      );
      final count = reset ? await _repository.unreadCount() : null;
      if (!_isCurrent(generation)) return;
      final countError = count?.fold<ApiError?>((error) => error, (_) => null);
      if (countError != null && _isCurrent(generation)) {
        _emitError(countError);
        return;
      }
      final unread =
          count?.fold<int>((_) => inbox.unreadCount, (value) => value) ??
          inbox.unreadCount;
      final page = await pageFuture;
      if (!_isCurrent(generation)) return;
      page.fold(
        (error) {
          if (_isCurrent(generation)) _emitError(error);
        },
        (typed) {
          if (!_isCurrent(generation)) return;
          inbox = inbox.copyWith(
            items: _mergeItems(reset ? const [] : inbox.items, typed.items),
            itemNextCursor: typed.nextCursor,
            clearItemNextCursor: typed.nextCursor == null,
            unreadCount: unread,
            isLoadingMore: false,
            clearRefreshError: true,
          );
          _emitInbox(inbox);
        },
      );
    }
  }

  Future<void> markAllRead() => _mutate(_repository.markAllRead, _markAllRead);
  Future<void> markGroupRead(String key) => _mutate(
    () => _repository.markGroupRead(key),
    (inbox) => _markGroupRead(inbox, key),
  );
  Future<void> archiveGroup(String key) => _mutate(
    () => _repository.archiveGroup(key),
    (inbox) => _archiveGroup(inbox, key),
  );
  Future<void> quickAction(String id, NotificationQuickActionKind action) =>
      _mutate(
        () => _repository.quickAction(id, action),
        (inbox) => _quickAction(inbox, id, action),
      );

  Future<void> _mutate(
    Future<Either<ApiError, void>> Function() operation,
    NotificationsInbox Function(NotificationsInbox) optimistic,
  ) {
    final scheduled = _pendingMutations == 0
        ? _performMutation(operation, optimistic)
        : _mutationTail.then((_) => _performMutation(operation, optimistic));
    _pendingMutations++;
    // Żadna awaria pojedynczej mutacji nie może zablokować kolejnych intencji.
    _mutationTail = scheduled.catchError((Object _) {});
    unawaited(scheduled.whenComplete(() => _pendingMutations--));
    return scheduled;
  }

  Future<void> _performMutation(
    Future<Either<ApiError, void>> Function() operation,
    NotificationsInbox Function(NotificationsInbox) optimistic,
  ) async {
    final before = _inbox;
    final generation = _queryGeneration;
    if (!_isCurrent(generation)) return;
    if (before != null) _emitInbox(optimistic(before));
    final result = await operation();
    if (!_isCurrent(generation)) return;
    result.fold(
      (error) => before == null ? _emitError(error) : _rollback(before, error),
      (_) => unawaited(refresh()),
    );
  }

  NotificationsInbox get _initialInbox => const NotificationsInbox(
    groups: [],
    items: [],
    unreadCount: 0,
    groupNextCursor: null,
    itemNextCursor: null,
    view: NotificationsInboxView.groups,
    category: null,
    unreadOnly: false,
  );
  NotificationsInbox? get _inbox => switch (state) {
    NotificationsReady(:final inbox) ||
    NotificationsEmpty(:final inbox) => inbox,
    _ => null,
  };
  bool _isCurrent(int generation) =>
      !isClosed && generation == _queryGeneration;
  void _invalidateQuery() => _queryGeneration++;
  void _emitInbox(NotificationsInbox inbox) {
    if (isClosed) return;
    final visible = inbox.view == NotificationsInboxView.groups
        ? inbox.groups
        : inbox.items;
    emit(
      visible.isEmpty ? NotificationsEmpty(inbox) : NotificationsReady(inbox),
    );
  }

  void _emitError(ApiError error) {
    if (error.type == ApiErrorType.unauthorized) {
      emit(NotificationsUnauthorized(error.message));
      return;
    }
    if (error.type == ApiErrorType.forbidden) {
      emit(NotificationsForbidden(error.message));
      return;
    }
    final inbox = _inbox;
    if (inbox != null) {
      _emitInbox(
        inbox.copyWith(isLoadingMore: false, refreshError: error.message),
      );
    } else {
      emit(NotificationsFailure(error.message));
    }
  }

  void _rollback(NotificationsInbox before, ApiError error) {
    if (error.type == ApiErrorType.unauthorized ||
        error.type == ApiErrorType.forbidden) {
      _emitError(error);
      return;
    }
    _emitInbox(before.copyWith(refreshError: error.message));
  }

  Future<void> _startRealtime() async {
    try {
      await _realtime?.start();
    } catch (_) {}
  }

  /// Scala wyłącznie access-safe zdarzenia; nie odświeża całej skrzynki na każdy
  /// komunikat SignalR, aby nie cofać lokalnych mutacji przez wyścig REST.
  void _reduceRealtimeEvent(Object event) {
    final inbox = _inbox;
    if (inbox == null || isClosed) return;
    switch (event) {
      case NotificationGroupRemovedRealtimeEvent(
        :final groupKey,
        :final realtimeSequence,
      ):
        if (!_acceptRemovedGroup(groupKey, realtimeSequence)) return;
        final removed = inbox.groups.where(
          (group) => group.groupKey == groupKey,
        );
        final unread = removed.fold<int>(
          0,
          (sum, group) => sum + group.unreadCount,
        );
        _emitInbox(
          inbox.copyWith(
            groups: inbox.groups
                .where((group) => group.groupKey != groupKey)
                .toList(growable: false),
            items: inbox.items
                .where((item) => item.groupKey != groupKey)
                .toList(growable: false),
            unreadCount: (inbox.unreadCount - unread).clamp(
              0,
              inbox.unreadCount,
            ),
          ),
        );
      case NotificationGroupUpdatedRealtimeEvent(:final group):
        _emitInbox(inbox.copyWith(groups: _mergeGroups(inbox.groups, [group])));
      case NotificationCreatedRealtimeEvent(:final notification):
        if (!_seenNotificationEventIds.add(notification.eventId)) {
          return;
        }
        _emitInbox(
          inbox.copyWith(
            items: _mergeItems([notification], inbox.items),
            unreadCount:
                inbox.unreadCount + (notification.readAtUtc == null ? 1 : 0),
          ),
        );
      case NotificationUnreadCountReconciledRealtimeEvent(:final unreadCount):
        _emitInbox(inbox.copyWith(unreadCount: unreadCount));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _realtime?.stop();
    return super.close();
  }

  List<NotificationGroupResponse> _mergeGroups(
    List<NotificationGroupResponse> old,
    List<NotificationGroupResponse> fresh,
  ) {
    final entries = <String, NotificationGroupResponse>{
      for (final group in old) group.groupKey: group,
    };
    for (final group in fresh) {
      if (!_acceptGroup(group)) continue;
      entries[group.groupKey] = group;
    }
    return List.unmodifiable(entries.values);
  }

  List<WorkspaceNotificationResponse> _mergeItems(
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

  NotificationsInbox _markAllRead(NotificationsInbox inbox) => inbox.copyWith(
    unreadCount: 0,
    groups: [for (final group in inbox.groups) group.copyWith(unreadCount: 0)],
    items: [
      for (final item in inbox.items)
        item.copyWith(readAtUtc: DateTime.now().toUtc()),
    ],
  );
  NotificationsInbox _markGroupRead(NotificationsInbox inbox, String key) {
    final removed = inbox.groups
        .where((x) => x.groupKey == key)
        .fold(0, (sum, x) => sum + x.unreadCount);
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

  NotificationsInbox _archiveGroup(NotificationsInbox inbox, String key) {
    final removed = inbox.groups
        .where((x) => x.groupKey == key)
        .fold(0, (sum, x) => sum + x.unreadCount);
    return inbox.copyWith(
      unreadCount: (inbox.unreadCount - removed).clamp(0, inbox.unreadCount),
      groups: inbox.groups
          .where((x) => x.groupKey != key)
          .toList(growable: false),
      items: inbox.items
          .where((item) => item.groupKey != key)
          .toList(growable: false),
    );
  }

  NotificationsInbox _quickAction(
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
      NotificationQuickActionKind.markRead => inbox.copyWith(
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
                unreadCount: (group.unreadCount - 1).clamp(
                  0,
                  group.unreadCount,
                ),
                latest: group.latest.id == id
                    ? group.latest.copyWith(readAtUtc: DateTime.now().toUtc())
                    : group.latest,
              )
            else
              group,
        ],
      ),
      NotificationQuickActionKind.archive => _archiveNotification(inbox, id),
      NotificationQuickActionKind.pin || NotificationQuickActionKind.unpin =>
        _setPinned(inbox, id, action == NotificationQuickActionKind.pin),
      _ => inbox,
    };
  }

  NotificationsInbox _archiveNotification(NotificationsInbox inbox, String id) {
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

  NotificationsInbox _setPinned(
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

  bool _acceptGroup(NotificationGroupResponse group) {
    final sequence = group.realtimeSequence;
    if (sequence == null) {
      return !_latestGroupSequences.containsKey(group.groupKey);
    }
    final previous = _latestGroupSequences[group.groupKey];
    if (previous != null && sequence <= previous) return false;
    _latestGroupSequences[group.groupKey] = sequence;
    return true;
  }

  bool _acceptRemovedGroup(String groupKey, int sequence) {
    final previous = _latestGroupSequences[groupKey];
    if (previous != null && sequence <= previous) return false;
    _latestGroupSequences[groupKey] = sequence;
    return true;
  }
}
