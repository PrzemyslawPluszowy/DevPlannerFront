import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Jawny wynik akcji, aby UI reagowało wyłącznie na potwierdzony zapis.
enum ChatMessageSecondaryActionOutcome { succeeded, failed, ignored }

/// Prowadzi akcje drugorzędne wiadomości: przypięcia, zakładki, reakcje i forward.
///
/// Cubit jest osobny od edycji i usunięcia, bo te zmieniają treść i wymagają
/// `Version` oraz rozstrzygnięcia konfliktu. Ten cubit nie zmienia treści
/// wiadomości ani nie ukrywa błędu: każda porażka wraca jako kod domenowy
/// przypisany do wiadomości, więc UI pokazuje realny powód.
final class ChatMessageSecondaryActionsCubit
    extends Cubit<ChatMessageSecondaryActionsState> {
  /// Tworzy cubit na porcie akcji wiadomości.
  ChatMessageSecondaryActionsCubit({required this.repository})
    : super(const ChatMessageSecondaryActionsState());

  final ChatMessageActionsRepository repository;
  int _pinsGeneration = 0;
  int _bookmarksGeneration = 0;

  /// Przypina albo odpina wiadomość w zależności od aktualnego stanu.
  Future<ChatMessageSecondaryActionOutcome> togglePin({
    required String conversationId,
    required String messageId,
    required bool isPinned,
  }) => _run(
    messageId: messageId,
    action: isPinned
        ? ChatMessageSecondaryAction.unpin
        : ChatMessageSecondaryAction.pin,
    call: () => isPinned
        ? repository.unpinMessage(
            conversationId: conversationId,
            messageId: messageId,
          )
        : repository.pinMessage(
            conversationId: conversationId,
            messageId: messageId,
          ),
    onSuccess: () {
      _pinsGeneration++;
      final pinnedIds = Set<String>.of(state.pinnedMessageIds);
      if (isPinned) {
        pinnedIds.remove(messageId);
      } else {
        pinnedIds.add(messageId);
      }
      emit(
        state.copyWith(
          pinnedConversationId: conversationId,
          pinnedMessageIds: pinnedIds,
        ),
      );
    },
  );

  /// Dodaje albo usuwa prywatną zakładkę użytkownika.
  Future<void> toggleBookmark({
    required String messageId,
    required bool isBookmarked,
    String? note,
  }) async {
    await _run(
      messageId: messageId,
      action: isBookmarked
          ? ChatMessageSecondaryAction.removeBookmark
          : ChatMessageSecondaryAction.bookmark,
      call: () => isBookmarked
          ? repository.removeBookmark(messageId)
          : repository.bookmarkMessage(messageId: messageId, note: note),
      onSuccess: () {
        _bookmarksGeneration++;
        final bookmarkedIds = Set<String>.of(state.bookmarkedMessageIds);
        if (isBookmarked) {
          bookmarkedIds.remove(messageId);
        } else {
          bookmarkedIds.add(messageId);
        }
        emit(state.copyWith(bookmarkedMessageIds: bookmarkedIds));
      },
    );
  }

  /// Przekazuje wiadomość do innej rozmowy z nowym idempotency key.
  Future<void> forward({
    required String messageId,
    required String targetConversationId,
    required String clientMessageId,
  }) async {
    await _run(
      messageId: messageId,
      action: ChatMessageSecondaryAction.forward,
      call: () => repository.forwardMessage(
        messageId: messageId,
        targetConversationId: targetConversationId,
        clientMessageId: clientMessageId,
      ),
      onSuccess: () => emit(state.copyWith(forwardedMessageId: messageId)),
    );
  }

  /// Dodaje własną reakcję emoji do wiadomości.
  Future<void> react({
    required String messageId,
    required String emoji,
  }) async {
    await _run(
      messageId: messageId,
      action: ChatMessageSecondaryAction.reaction,
      call: () => repository.addReaction(messageId: messageId, emoji: emoji),
    );
  }

  /// Usuwa własną reakcję emoji z wiadomości.
  Future<void> removeReaction({
    required String messageId,
    required String emoji,
  }) async {
    await _run(
      messageId: messageId,
      action: ChatMessageSecondaryAction.removeReaction,
      call: () => repository.removeReaction(messageId: messageId, emoji: emoji),
    );
  }

  /// Wczytuje przypięcia rozmowy, żeby menu pokazywało realny stan.
  Future<void> loadConversationPins(String conversationId) async {
    if (isClosed) return;
    final generation = ++_pinsGeneration;
    final result = await repository.listPins(conversationId);
    if (isClosed || generation != _pinsGeneration) return;
    result.fold(
      (_) {},
      (pins) => emit(
        state.copyWith(
          pinnedMessageIds: pins.map((pin) => pin.messageId).toSet(),
          pinnedConversationId: conversationId,
        ),
      ),
    );
  }

  /// Wczytuje prywatne zakładki użytkownika.
  Future<void> loadBookmarks() async {
    if (isClosed) return;
    final generation = ++_bookmarksGeneration;
    final result = await repository.listBookmarks();
    if (isClosed || generation != _bookmarksGeneration) return;
    result.fold(
      (_) {},
      (bookmarks) => emit(
        state.copyWith(
          bookmarkedMessageIds: bookmarks
              .map((bookmark) => bookmark.messageId)
              .toSet(),
        ),
      ),
    );
  }

  /// Czyści kod błędu wiadomości po zamknięciu komunikatu w UI.
  void clearFailure(String messageId) {
    if (!state.failures.containsKey(messageId)) return;
    final failures = Map<String, String>.of(state.failures)..remove(messageId);
    emit(state.copyWith(failures: failures));
  }

  Future<ChatMessageSecondaryActionOutcome> _run<T>({
    required String messageId,
    required ChatMessageSecondaryAction action,
    required Future<Either<ApiError, T>> Function() call,
    void Function()? onSuccess,
  }) async {
    if (isClosed || state.pending.containsKey(messageId)) {
      return ChatMessageSecondaryActionOutcome.ignored;
    }
    _clearFailureFor(messageId);
    emit(
      state.copyWith(
        pending: <String, ChatMessageSecondaryAction>{
          ...state.pending,
          messageId: action,
        },
      ),
    );
    try {
      final result = await call();
      if (isClosed) return ChatMessageSecondaryActionOutcome.ignored;
      return await result.fold(
        (error) {
          emit(
            state.copyWith(
              failures: <String, String>{
                ...state.failures,
                messageId: error.apiCode ?? error.message,
              },
            ),
          );
          return ChatMessageSecondaryActionOutcome.failed;
        },
        (_) {
          emit(state.copyWith(lastCompleted: action));
          onSuccess?.call();
          return ChatMessageSecondaryActionOutcome.succeeded;
        },
      );
    } finally {
      if (!isClosed && state.isPending(messageId)) {
        _clearPendingFor(messageId);
      }
    }
  }

  void _clearPendingFor(String messageId) {
    final pending = Map<String, ChatMessageSecondaryAction>.of(state.pending)
      ..remove(messageId);
    emit(state.copyWith(pending: pending));
  }

  void _clearFailureFor(String messageId) {
    if (!state.failures.containsKey(messageId)) return;
    final failures = Map<String, String>.of(state.failures)..remove(messageId);
    emit(state.copyWith(failures: failures));
  }
}
