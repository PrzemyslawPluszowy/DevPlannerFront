import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_message_merger.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_read_tracker.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_realtime_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lokalny owner snapshotu, paginacji i UI rozmowy, bez kolejki transportowej.
final class ChatConversationCubit extends Cubit<ChatConversationState> {
  /// Tworzy Cubit z osobną kolejką dostawy należącą do tego ekranu rozmowy.
  ChatConversationCubit({
    required ChatConversationRepository repository,
    required this.conversationId,
    required this.currentUserId,
    ChatMessageDeliveryQueue? deliveryQueue,
    this.realtime,
    this.disposeRealtime,
  }) : _repository = repository,
       _deliveryQueue =
           deliveryQueue ??
           ChatMessageDeliveryQueue(repository, userId: currentUserId),
       super(const ChatConversationInitial()) {
    _deliveryQueue.bindConversation(conversationId);
    _readTracker = ChatConversationReadTracker(
      repository: _repository,
      conversationId: conversationId,
      isClosed: () => isClosed,
    );
    _realtimeCoordinator = ChatConversationRealtimeCoordinator(
      conversationId: conversationId,
      repository: _repository,
      realtime: realtime,
      isClosed: () => isClosed,
      currentState: () => state,
      emitReady: emit,
      detach: _detach,
      replaceMessage: _replaceMessage,
      resync: load,
    );
    _deliverySubscription = _deliveryQueue.changes.listen(_onDeliveryChanged);
  }

  final ChatConversationRepository _repository;
  final ChatMessageDeliveryQueue _deliveryQueue;
  late final ChatConversationReadTracker _readTracker;
  late final ChatConversationRealtimeCoordinator _realtimeCoordinator;
  final String conversationId;

  /// Local UserId bieżącej sesji; dzięki niemu odczyt nie dotyczy własnych wiadomości.
  final String currentUserId;

  final ChatConversationRealtimeClient? realtime;
  final Future<void> Function()? disposeRealtime;

  /// Potwierdzenia create-message dla ownerów sesji załączników composera.
  Stream<ChatMessageDeliveryConfirmation> get deliveryConfirmations =>
      _deliveryQueue.confirmations;
  late final StreamSubscription<ChatMessage> _deliverySubscription;
  Future<void>? _loadInFlight;
  bool _replaceHistoryLoadInFlight = false;
  int _loadGeneration = 0;
  int _historyGeneration = 0;

  /// Pobiera pierwszą stronę; replaceHistory odrzuca rozłączne stare okno.
  Future<void> load({bool replaceHistory = false}) async {
    final inFlight = _loadInFlight;
    if (inFlight != null && (!replaceHistory || _replaceHistoryLoadInFlight)) {
      return inFlight;
    }
    final generation = ++_loadGeneration;
    final historyGeneration = ++_historyGeneration;
    final operation = _loadInternal(
      generation,
      historyGeneration,
      replaceHistory: replaceHistory,
    );
    _loadInFlight = operation;
    _replaceHistoryLoadInFlight = replaceHistory;
    try {
      await operation;
    } finally {
      // Starsze żądanie nie może wyczyścić uchwytu nowszego reloadu.
      if (identical(_loadInFlight, operation)) {
        _loadInFlight = null;
        _replaceHistoryLoadInFlight = false;
      }
    }
    // Po najnowszej stronie historii wznawiamy próby po restarcie.
    if (!isClosed &&
        generation == _loadGeneration &&
        historyGeneration == _historyGeneration) {
      await restorePendingSends();
    }
  }

  /// Pobiera kolejną stronę historii przez nieprzezroczysty cursor backendu.
  Future<void> loadMore() async {
    final current = state;
    if (current is! ChatConversationReady ||
        current.nextCursor == null ||
        current.isLoadingMore ||
        isClosed) {
      return;
    }
    final historyGeneration = _historyGeneration;
    emit(current.copyWith(isLoadingMore: true, clearLoadError: true));
    final result = await _repository.listConversationMessages(
      conversationId: conversationId,
      cursor: current.nextCursor,
    );
    if (isClosed ||
        historyGeneration != _historyGeneration ||
        state is! ChatConversationReady) {
      return;
    }
    result.fold(
      (error) => _handleAccessOrLoadError(error, clearLoadingMore: true),
      (page) {
        final latest = state as ChatConversationReady;
        emit(
          latest.copyWith(
            messages: ChatConversationMessageMerger.merge(
              latest.messages,
              page.items,
            ),
            nextCursor: page.nextCursor,
            clearNextCursor: page.nextCursor == null,
            isLoadingMore: false,
            clearLoadError: true,
          ),
        );
      },
    );
  }

  /// Doładowuje okno wokół wskazanej wiadomości, gdy nie ma jej w historii.
  ///
  /// Brak dostępu odłącza historię, a brak celu daje błąd z ponowieniem.
  Future<void> ensureTargetLoaded(String messageId) async {
    final current = state;
    if (current is! ChatConversationReady || isClosed || messageId.isEmpty) {
      return;
    }
    final historyGeneration = ++_historyGeneration;
    if (current.messages.any((message) => message.id == messageId)) {
      emit(
        current.copyWith(
          isJumpingToMessage: false,
          isLoadingMore: false,
          targetMessageId: messageId,
          targetRequestId: current.targetRequestId + 1,
          clearJumpFailure: true,
        ),
      );
      return;
    }
    emit(
      current.copyWith(
        isJumpingToMessage: true,
        isLoadingMore: false,
        clearJumpFailure: true,
        targetMessageId: messageId,
        targetRequestId: current.targetRequestId + 1,
      ),
    );
    final result = await _repository.loadMessageWindow(
      conversationId: conversationId,
      messageId: messageId,
    );
    if (isClosed ||
        historyGeneration != _historyGeneration ||
        state is! ChatConversationReady) {
      return;
    }
    final latest = state as ChatConversationReady;
    result.fold(
      (error) {
        if (error.type == ApiErrorType.unauthorized ||
            error.type == ApiErrorType.forbidden) {
          _detach(error.message);
          return;
        }
        emit(
          latest.copyWith(
            isJumpingToMessage: false,
            jumpFailureCode: error.apiCode ?? error.message,
          ),
        );
      },
      (window) => emit(
        latest.copyWith(
          // Okno i kursor muszą pochodzić z tego samego ciągłego zakresu.
          messages: window.messages,
          nextCursor: window.beforeCursor,
          clearNextCursor: window.beforeCursor == null,
          jumpAnchorMessageId: window.anchorMessageId,
          isJumpingToMessage: false,
          clearJumpFailure: true,
        ),
      ),
    );
  }

  /// Wraca z trybu okna do najnowszej historii rozmowy.
  Future<void> exitWindowHistory() async {
    final current = state;
    if (current is! ChatConversationReady || isClosed) return;
    if (!current.isWindowedHistory) return;
    await load(replaceHistory: true);
  }

  /// Dodaje lokalną wiadomość i zleca dostawę bez blokowania composera.
  String? send(String text) {
    return sendDraft(ChatComposerDraft(text: text.trim()));
  }

  /// Dodaje pełny snapshot composera do kolejki bez utraty Delta ani reply.
  String? sendDraft(ChatComposerDraft draft) {
    final current = state;
    if (draft.isEmpty || current is! ChatConversationReady || isClosed) {
      return null;
    }
    final message = _deliveryQueue.enqueue(
      conversationId: conversationId,
      draft: draft,
    );
    _replaceMessage(message);
    return message.clientMessageId;
  }

  /// Oznacza odczyt, gdy widok potwierdzi, że wiadomość jest faktycznie widoczna.
  ///
  /// Widok decyduje o widoczności; potwierdzenia są idempotentne.
  Future<ChatReadMarkOutcome> markVisibleAsRead(String messageId) {
    final current = state;
    if (current is! ChatConversationReady || isClosed) {
      return Future<ChatReadMarkOutcome>.value(ChatReadMarkOutcome.ignored);
    }
    return _readTracker.markVisibleAsRead(
      current: current,
      messageId: messageId,
    );
  }

  /// Ostatnio oznaczona wiadomość; chroni przed powtarzaniem żądania.
  String? get lastReadMessageId => _readTracker.lastReadMessageId;

  /// Ponawia konkretną nieudaną wiadomość z tym samym UUID i payload hash.
  void retry(String clientMessageId) => _deliveryQueue.retry(clientMessageId);

  /// Scala autoryzowany wynik mutacji pojedynczej wiadomości do historii.
  void applyMessageActionResult(ChatMessage message) =>
      _replaceMessage(message);

  /// Zgłasza hubowi, że bieżący użytkownik pisze albo przestał pisać.
  ///
  /// Ulotny sygnał nie blokuje wysyłki; serwer utrzymuje TTL.
  Future<void> notifyTyping(bool isTyping) =>
      _realtimeCoordinator.notifyTyping(isTyping);

  /// Odrzuca historię, gdy mutacja wiadomości ujawniła utratę dostępu.
  void detachForMessageAction(String message) => _detach(message);

  /// Wznawia trwałe intencje wysyłki po restarcie albo ponownym otwarciu rozmowy.
  Future<int> restorePendingSends() async {
    final restored = await _deliveryQueue.restorePending();
    if (isClosed || restored == 0) return restored;
    // Kolejka publikuje wpisy przez changes.
    return restored;
  }

  /// Czyści lokalne dane wysyłki po wylogowaniu albo zmianie konta.
  Future<void> clearForSignedOutSession() => _deliveryQueue.clearForSession();

  Future<void> _loadInternal(
    int generation,
    int historyGeneration, {
    bool replaceHistory = false,
  }) async {
    if (isClosed) return;
    if (state is! ChatConversationReady) emit(const ChatConversationLoading());
    final conversationResult = await _repository.getConversation(
      conversationId,
    );
    if (isClosed ||
        generation != _loadGeneration ||
        historyGeneration != _historyGeneration) {
      return;
    }
    final conversation = conversationResult.fold<ChatConversation?>(
      (error) {
        _handleAccessOrLoadError(error);
        return null;
      },
      (value) => value,
    );
    if (conversation == null ||
        isClosed ||
        generation != _loadGeneration ||
        historyGeneration != _historyGeneration) {
      return;
    }
    final messagesResult = await _repository.listConversationMessages(
      conversationId: conversationId,
    );
    if (isClosed ||
        generation != _loadGeneration ||
        historyGeneration != _historyGeneration) {
      return;
    }
    messagesResult.fold(
      _handleAccessOrLoadError,
      (page) {
        final previous = state;
        final previousMessages =
            previous is ChatConversationReady && !replaceHistory
            ? previous.messages
            : const <ChatMessage>[];
        emit(
          ChatConversationReady(
            conversation: conversation,
            messages: ChatConversationMessageMerger.merge(
              previousMessages,
              page.items,
            ),
            nextCursor: page.nextCursor,
            realtimeError: previous is ChatConversationReady
                ? previous.realtimeError
                : null,
            jumpAnchorMessageId: replaceHistory
                ? null
                : previous is ChatConversationReady
                ? previous.jumpAnchorMessageId
                : null,
          ),
        );
        unawaited(_realtimeCoordinator.start());
      },
    );
  }

  void _onDeliveryChanged(ChatMessage message) {
    if (!isClosed && message.conversationId == conversationId) {
      _replaceMessage(message);
    }
  }

  void _replaceMessage(ChatMessage message) {
    final current = state;
    if (current is! ChatConversationReady || isClosed) return;
    emit(
      current.copyWith(
        messages: ChatConversationMessageMerger.merge(
          current.messages,
          [message],
        ),
      ),
    );
  }

  void _handleAccessOrLoadError(
    ApiError error, {
    bool clearLoadingMore = false,
  }) {
    if (error.type == ApiErrorType.unauthorized ||
        error.type == ApiErrorType.forbidden) {
      _detach(error.message);
      return;
    }
    final current = state;
    if (current is ChatConversationReady) {
      emit(
        current.copyWith(
          loadError: error.message,
          isLoadingMore: clearLoadingMore ? false : null,
        ),
      );
    } else {
      emit(ChatConversationFailure(error.message));
    }
  }

  void _detach(String message) {
    ++_historyGeneration;
    ++_loadGeneration;
    _deliveryQueue.clear();
    unawaited(_realtimeCoordinator.stop());
    if (!isClosed) emit(ChatConversationDetached(message));
  }

  @override
  Future<void> close() async {
    await _deliverySubscription.cancel();
    await _realtimeCoordinator.stop();
    await _deliveryQueue.dispose();
    await disposeRealtime?.call();
    return super.close();
  }
}
