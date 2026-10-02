import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_forward_targets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Niezależne, krótkotrwałe wyszukiwanie rozmów dla jednego pickera.
final class ChatForwardTargetsCubit extends Cubit<ChatForwardTargetsState> {
  ChatForwardTargetsCubit({
    required this._repository,
    required this.excludedConversationId,
    this.pageSize = 30,
    this.queryDebounce = const Duration(milliseconds: 250),
  }) : super(const ChatForwardTargetsLoading(null));

  final ChatInboxRepository _repository;
  final String excludedConversationId;
  final int pageSize;
  final Duration queryDebounce;

  String? _query;
  int _generation = 0;

  /// Zapytanie poniżej dwóch znaków oznacza pełną listę rozmów.
  Future<void> load() => _loadFirstPage(++_generation);

  Future<void> setQuery(String? value) async {
    final trimmed = value?.trim();
    final normalized = trimmed == null || trimmed.length < 2 ? null : trimmed;
    if (_query == normalized || isClosed) return;
    _query = normalized;
    final generation = ++_generation;
    emit(ChatForwardTargetsLoading(_query));
    if (queryDebounce > Duration.zero) {
      await Future<void>.delayed(queryDebounce);
    }
    await _loadFirstPage(generation);
  }

  Future<void> retry() => _loadFirstPage(++_generation);

  Future<void> loadMore() async {
    final current = state;
    if (current is! ChatForwardTargetsReady ||
        !current.hasMore ||
        current.nextCursor == null ||
        current.isLoadingMore) {
      return;
    }
    final generation = _generation;
    emit(_copyReady(current, isLoadingMore: true, clearLoadMoreError: true));
    final result = await _repository.loadInbox(
      cursor: current.nextCursor,
      limit: pageSize,
      query: _query,
    );
    if (isClosed || generation != _generation) return;
    result.fold(
      (error) => emit(_copyReady(current, loadMoreError: error)),
      (page) {
        final knownIds = current.items
            .map((item) => item.conversation.id)
            .toSet();
        final additions = page.items.where(
          (item) =>
              item.conversation.id != excludedConversationId &&
              !knownIds.contains(item.conversation.id),
        );
        emit(
          ChatForwardTargetsReady(
            items: List.unmodifiable(<ChatInboxItem>[
              ...current.items,
              ...additions,
            ]),
            query: _query,
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }

  Future<void> _loadFirstPage(int generation) async {
    if (isClosed || generation != _generation) return;
    final query = _query;
    final result = await _repository.loadInbox(
      limit: pageSize,
      query: query,
    );
    if (isClosed || generation != _generation) return;
    result.fold(
      (error) => emit(
        ChatForwardTargetsFailure(query: query, error: error),
      ),
      (page) {
        final items = List<ChatInboxItem>.unmodifiable(
          page.items.where(
            (item) => item.conversation.id != excludedConversationId,
          ),
        );
        if (items.isEmpty && !page.hasMore) {
          emit(ChatForwardTargetsEmpty(query));
          return;
        }
        emit(
          ChatForwardTargetsReady(
            items: items,
            query: query,
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }

  ChatForwardTargetsReady _copyReady(
    ChatForwardTargetsReady state, {
    bool? isLoadingMore,
    ApiError? loadMoreError,
    bool clearLoadMoreError = false,
  }) => ChatForwardTargetsReady(
    items: state.items,
    query: state.query,
    hasMore: state.hasMore,
    nextCursor: state.nextCursor,
    isLoadingMore: isLoadingMore ?? state.isLoadingMore,
    loadMoreError: clearLoadMoreError
        ? null
        : loadMoreError ?? state.loadMoreError,
  );

  @override
  Future<void> close() {
    _generation++;
    return super.close();
  }
}
