import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_gateway.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Orkiestruje wyłącznie stan lokalnej skrzynki Notifications.
final class StandaloneNotificationsInboxCubit
    extends Cubit<StandaloneNotificationsInboxState> {
  StandaloneNotificationsInboxCubit(this._gateway)
    : super(const StandaloneNotificationsInboxState());

  final StandaloneNotificationsInboxGateway _gateway;
  bool _loading = false;
  bool _loadingMore = false;
  int _requestVersion = 0;

  Future<void> load({bool unreadOnly = false}) async {
    if (_loading || _loadingMore) return;
    _loading = true;
    final requestVersion = ++_requestVersion;
    emit(
      state.copyWith(
        status: StandaloneNotificationsInboxStatus.loading,
        unreadOnly: unreadOnly,
        error: null,
      ),
    );

    final pageFuture = _gateway.list(unreadOnly: unreadOnly);
    final countFuture = _gateway.unreadCount();
    final pageResult = await pageFuture;
    final countResult = await countFuture;
    _loading = false;
    if (isClosed || requestVersion != _requestVersion) return;

    pageResult.fold(
      (error) => emit(
        state.copyWith(
          status: StandaloneNotificationsInboxStatus.failure,
          isLoadingMore: false,
          error: error,
        ),
      ),
      (page) => countResult.fold(
        (error) => emit(
          state.copyWith(
            status: StandaloneNotificationsInboxStatus.failure,
            items: page.items,
            nextCursor: page.nextCursor,
            isLoadingMore: false,
            error: error,
          ),
        ),
        (count) => emit(
          state.copyWith(
            status: StandaloneNotificationsInboxStatus.ready,
            items: page.items,
            nextCursor: page.nextCursor,
            unreadCount: count,
            isLoadingMore: false,
            error: null,
          ),
        ),
      ),
    );
  }

  Future<void> retry() => load(unreadOnly: state.unreadOnly);

  Future<void> loadMore() async {
    if (_loading || _loadingMore || !state.hasMore) return;
    _loadingMore = true;
    emit(state.copyWith(isLoadingMore: true, error: null));
    final requestVersion = ++_requestVersion;
    final result = await _gateway.list(
      cursor: state.nextCursor,
      unreadOnly: state.unreadOnly,
    );
    _loadingMore = false;
    if (isClosed || requestVersion != _requestVersion) return;
    result.fold(
      (error) => emit(state.copyWith(isLoadingMore: false, error: error)),
      (page) => emit(
        state.copyWith(
          status: StandaloneNotificationsInboxStatus.ready,
          items: [...state.items, ...page.items],
          nextCursor: page.nextCursor,
          isLoadingMore: false,
          error: null,
        ),
      ),
    );
  }

  Future<void> markRead(String notificationId) async {
    final index = state.items.indexWhere((item) => item.id == notificationId);
    if (index < 0 || !state.items[index].isUnread) return;
    final result = await _gateway.markRead(notificationId);
    if (isClosed) return;
    result.fold(
      (error) => emit(state.copyWith(error: error)),
      (_) {
        final items = [...state.items];
        items[index] = items[index].copyWith(readAtUtc: DateTime.now().toUtc());
        emit(
          state.copyWith(
            items: items,
            unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
            error: null,
          ),
        );
      },
    );
  }

  ApiError? get lastError => state.error;
}
