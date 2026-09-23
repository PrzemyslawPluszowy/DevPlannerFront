import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lokalny owner snapshotu, paginacji i UI rozmowy, bez kolejki transportowej.
final class ChatConversationCubit extends Cubit<ChatConversationState> {
  /// Tworzy Cubit z osobną kolejką dostawy należącą do tego ekranu rozmowy.
  ChatConversationCubit({
    required ChatConversationRepository repository,
    required this.conversationId,
    ChatMessageDeliveryQueue? deliveryQueue,
    this.currentUserId = '',
    this.realtime,
    this.disposeRealtime,
  }) : _repository = repository,
       _deliveryQueue =
           deliveryQueue ??
           ChatMessageDeliveryQueue(repository, userId: currentUserId),
       super(const ChatConversationInitial()) {
    _deliveryQueue.bindConversation(conversationId);
    _deliverySubscription = _deliveryQueue.changes.listen(_onDeliveryChanged);
  }

  final ChatConversationRepository _repository;
  final ChatMessageDeliveryQueue _deliveryQueue;
  final ChatConversationRealtimeReducer _realtimeReducer =
      ChatConversationRealtimeReducer();
  final String conversationId;

  /// Local UserId bieżącej sesji; dzięki niemu odczyt nie dotyczy własnych wiadomości.
  final String currentUserId;

  final ChatConversationRealtimeClient? realtime;
  final Future<void> Function()? disposeRealtime;

  /// Potwierdzenia create-message dla ownerów sesji załączników composera.
  Stream<ChatMessageDeliveryConfirmation> get deliveryConfirmations =>
      _deliveryQueue.confirmations;
  late final StreamSubscription<ChatMessage> _deliverySubscription;
  StreamSubscription<ChatConversationRealtimeEvent>? _realtimeSubscription;
  StreamSubscription<ChatConversationRealtimeError>? _realtimeErrorSubscription;
  Future<void>? _loadInFlight;
  int _loadGeneration = 0;

  /// Pobiera snapshot rozmowy i pierwszą stronę historii bez kasowania retry.
  ///
  /// `replaceHistory` służy wyjściu z trybu okna: historia sprzed okna jest
  /// rozłączna z najnowszą stroną, więc scalanie ich zostawiłoby lukę.
  Future<void> load({bool replaceHistory = false}) async {
    final inFlight = _loadInFlight;
    if (inFlight != null) return inFlight;
    final operation = _loadInternal(
      ++_loadGeneration,
      replaceHistory: replaceHistory,
    );
    _loadInFlight = operation;
    await operation.whenComplete(() => _loadInFlight = null);
    // Po pierwszej stronie historii wznawiamy próby, które przetrwały restart.
    if (!isClosed) await restorePendingSends();
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
    emit(
      ChatConversationReady(
        conversation: current.conversation,
        messages: current.messages,
        nextCursor: current.nextCursor,
        isLoadingMore: true,
        realtimeError: current.realtimeError,
      ),
    );
    final result = await _repository.listConversationMessages(
      conversationId: conversationId,
      cursor: current.nextCursor,
    );
    if (isClosed || state is! ChatConversationReady) {
      return;
    }
    result.fold(
      _handleAccessOrLoadError,
      (page) {
        final latest = state as ChatConversationReady;
        emit(
          ChatConversationReady(
            conversation: latest.conversation,
            messages: _mergeMessages(latest.messages, page.items),
            nextCursor: page.nextCursor,
            realtimeError: latest.realtimeError,
          ),
        );
      },
    );
  }

  /// Doładowuje okno wokół wskazanej wiadomości, gdy nie ma jej w historii.
  ///
  /// Skok do starej wiadomości z wyszukiwania, zapisanych albo przypiętych nie
  /// może zależeć od liczby już pobranych stron. Brak dostępu do rozmowy odłącza
  /// historię, a brak samej wiadomości daje komunikat z ponowieniem, nie pustą listę.
  Future<void> ensureTargetLoaded(String messageId) async {
    final current = state;
    if (current is! ChatConversationReady || isClosed || messageId.isEmpty) {
      return;
    }
    if (current.messages.any((message) => message.id == messageId)) return;
    emit(current.copyWith(isJumpingToMessage: true, clearJumpFailure: true));
    final result = await _repository.loadMessageWindow(
      conversationId: conversationId,
      messageId: messageId,
    );
    if (isClosed || state is! ChatConversationReady) return;
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
          // Tryb okna: pokazujemy ciągły zakres wokół wiadomości. Scalanie z
          // najnowszą stroną zostawiłoby niewidoczną lukę, a kursor okna
          // doładowuje wyłącznie starszą część tego samego zakresu.
          messages: window.messages,
          nextCursor: window.beforeCursor,
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
  /// Samo pobranie historii, tło aplikacji ani zamknięty panel nie mogą
  /// oznaczać odczytu, dlatego decyzję podejmuje widok, a metoda jest
  /// idempotentna: powtórzenie dla tej samej wiadomości nie wysyła żądania.
  Future<bool> markVisibleAsRead(String messageId) async {
    final current = state;
    if (current is! ChatConversationReady || isClosed) return false;
    if (messageId.isEmpty ||
        messageId == _lastReadMessageId ||
        _readMarkersInFlight.contains(messageId)) {
      return false;
    }
    final message = current.messages
        .where((item) => item.id == messageId)
        .firstOrNull;
    if (message == null ||
        message.isDeleted ||
        (currentUserId.isNotEmpty && message.authorUserId == currentUserId)) {
      return false;
    }
    if (message.id.startsWith('local:')) return false;
    final readCursor = _lastReadMessage;
    if (readCursor != null && _compareMessages(message, readCursor) <= 0) {
      return false;
    }
    _readMarkersInFlight.add(messageId);
    var marked = false;
    try {
      final result = await _repository.markConversationRead(
        conversationId: conversationId,
        messageId: messageId,
      );
      if (!isClosed) {
        result.fold((_) {}, (_) {
          final latestRead = _lastReadMessage;
          if (latestRead == null || _compareMessages(message, latestRead) > 0) {
            _lastReadMessage = message;
            _lastReadMessageId = messageId;
            marked = true;
          }
        });
      }
    } finally {
      _readMarkersInFlight.remove(messageId);
    }
    return marked;
  }

  /// Ostatnio oznaczona wiadomość; chroni przed powtarzaniem żądania.
  String? _lastReadMessageId;
  ChatMessage? _lastReadMessage;
  final Set<String> _readMarkersInFlight = <String>{};
  final Set<String> _deliveryRefreshInFlight = <String>{};
  final Set<String> _deliveryRefreshPending = <String>{};

  /// Widoczna wiadomość oznaczona lokalnie jako odczytana albo `null`.
  String? get lastReadMessageId => _lastReadMessageId;

  /// Taki sam porządek jak kursor backendu: `(CreatedAtUtc, Id)`.
  static int _compareMessages(ChatMessage left, ChatMessage right) {
    final byTimestamp = left.createdAtUtc.compareTo(right.createdAtUtc);
    return byTimestamp != 0 ? byTimestamp : left.id.compareTo(right.id);
  }

  /// Ponawia konkretną nieudaną wiadomość z tym samym UUID i payload hash.
  void retry(String clientMessageId) => _deliveryQueue.retry(clientMessageId);

  /// Scala autoryzowany wynik mutacji pojedynczej wiadomości do historii.
  void applyMessageActionResult(ChatMessage message) =>
      _replaceMessage(message);

  /// Zgłasza hubowi, że bieżący użytkownik pisze albo przestał pisać.
  ///
  /// Sygnał jest ulotny i nie blokuje wysyłki: brak subskrypcji oznacza brak
  /// wywołania, a serwer i tak trzyma własny TTL.
  Future<void> notifyTyping(bool isTyping) async {
    final client = realtime;
    if (client == null) return;
    try {
      await client.setTyping(isTyping);
    } on Object {
      // Zerwane połączenie nie może przerwać pisania wiadomości.
    }
  }

  /// Odrzuca historię, gdy mutacja wiadomości ujawniła utratę dostępu.
  void detachForMessageAction(String message) => _detach(message);

  /// Wznawia trwałe intencje wysyłki po restarcie albo ponownym otwarciu rozmowy.
  Future<int> restorePendingSends() async {
    final restored = await _deliveryQueue.restorePending();
    if (isClosed || restored == 0) return restored;
    // Kolejka publikuje wpisy przez `changes`, więc stan odświeża się sam; tutaj
    // tylko potwierdzamy liczbę wznowionych prób dla właściciela ekranu.
    return restored;
  }

  /// Czyści lokalne dane wysyłki po wylogowaniu albo zmianie konta.
  Future<void> clearForSignedOutSession() => _deliveryQueue.clearForSession();

  Future<void> _loadInternal(
    int generation, {
    bool replaceHistory = false,
  }) async {
    if (isClosed) return;
    if (state is! ChatConversationReady) emit(const ChatConversationLoading());
    final conversationResult = await _repository.getConversation(
      conversationId,
    );
    if (isClosed || generation != _loadGeneration) return;
    final conversation = conversationResult.fold<ChatConversation?>(
      (error) {
        _handleAccessOrLoadError(error);
        return null;
      },
      (value) => value,
    );
    if (conversation == null || isClosed || generation != _loadGeneration) {
      return;
    }
    final messagesResult = await _repository.listConversationMessages(
      conversationId: conversationId,
    );
    if (isClosed || generation != _loadGeneration) {
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
            messages: _mergeMessages(previousMessages, page.items),
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
        unawaited(_startRealtime());
      },
    );
  }

  Future<void> _startRealtime() async {
    final service = realtime;
    if (service == null || _realtimeSubscription != null || isClosed) return;
    try {
      _realtimeSubscription = service.conversationEvents.listen(
        _onRealtimeEvent,
      );
      _realtimeErrorSubscription = service.conversationErrors.listen((error) {
        if (error.kind == ChatConversationRealtimeErrorKind.accessRevoked) {
          _detach(error.message);
          return;
        }
        final current = state;
        if (isClosed || current is! ChatConversationReady) return;
        emit(
          ChatConversationReady(
            conversation: current.conversation,
            messages: current.messages,
            nextCursor: current.nextCursor,
            realtimeError: error.message,
          ),
        );
      });
      await service.start(conversationId);
    } catch (error) {
      await _stopRealtime();
      final current = state;
      if (!isClosed && current is ChatConversationReady) {
        emit(
          ChatConversationReady(
            conversation: current.conversation,
            messages: current.messages,
            nextCursor: current.nextCursor,
            realtimeError: error.toString(),
          ),
        );
      }
    }
  }

  void _onDeliveryChanged(ChatMessage message) {
    if (!isClosed && message.conversationId == conversationId) {
      _replaceMessage(message);
    }
  }

  void _onRealtimeEvent(ChatConversationRealtimeEvent event) {
    final current = state;
    if (isClosed ||
        current is! ChatConversationReady ||
        event.conversationId != conversationId) {
      return;
    }
    // W trybie okna nowe wiadomości nie sąsiadują z pokazanym zakresem.
    // Zdarzenia dostarczenia/odczytu mogą jednak odświeżyć konkretną wiadomość.
    if (current.isWindowedHistory &&
        event.kind !=
            ChatConversationRealtimeEventKind.messageDeliveryChanged) {
      return;
    }
    final reduction = _realtimeReducer.apply(
      messages: current.messages,
      event: event,
    );
    switch (reduction.decision) {
      case ChatConversationRealtimeDecision.applied:
        emit(
          ChatConversationReady(
            conversation: current.conversation,
            messages: reduction.messages,
            nextCursor: current.nextCursor,
            isLoadingMore: current.isLoadingMore,
            realtimeError: current.realtimeError,
          ),
        );
      case ChatConversationRealtimeDecision.ignored:
        return;
      case ChatConversationRealtimeDecision.refreshMessageDelivery:
        final messageId = event.messageId;
        if (messageId != null &&
            current.messages.any((message) => message.id == messageId)) {
          unawaited(_refreshMessageDelivery(messageId));
        }
        return;
      case ChatConversationRealtimeDecision.resyncRequired:
        unawaited(load());
    }
  }

  Future<void> _refreshMessageDelivery(String messageId) async {
    if (!_deliveryRefreshInFlight.add(messageId)) {
      _deliveryRefreshPending.add(messageId);
      return;
    }
    try {
      do {
        _deliveryRefreshPending.remove(messageId);
        final current = state;
        if (isClosed ||
            current is! ChatConversationReady ||
            !current.messages.any((message) => message.id == messageId)) {
          return;
        }
        final result = await _repository.loadMessageWindow(
          conversationId: conversationId,
          messageId: messageId,
        );
        if (isClosed || state is! ChatConversationReady) return;
        result.fold(
          (error) {
            if (error.type == ApiErrorType.unauthorized ||
                error.type == ApiErrorType.forbidden) {
              _detach(error.message);
            }
          },
          (window) {
            final latest = state;
            final refreshed = window.messages
                .where((message) => message.id == messageId)
                .firstOrNull;
            if (latest is ChatConversationReady && refreshed != null) {
              _replaceMessage(refreshed);
            }
          },
        );
      } while (_deliveryRefreshPending.contains(messageId) && !isClosed);
    } finally {
      _deliveryRefreshInFlight.remove(messageId);
      _deliveryRefreshPending.remove(messageId);
    }
  }

  void _replaceMessage(ChatMessage message) {
    final current = state;
    if (current is! ChatConversationReady || isClosed) return;
    emit(
      ChatConversationReady(
        conversation: current.conversation,
        messages: _mergeMessages(current.messages, [message]),
        nextCursor: current.nextCursor,
        isLoadingMore: current.isLoadingMore,
        realtimeError: current.realtimeError,
      ),
    );
  }

  List<ChatMessage> _mergeMessages(
    List<ChatMessage> current,
    List<ChatMessage> incoming,
  ) {
    final merged = List<ChatMessage>.of(current);
    for (final message in incoming) {
      final index = merged.indexWhere(
        (item) =>
            item.id == message.id ||
            item.clientMessageId == message.clientMessageId,
      );
      if (index == -1) {
        merged.add(message);
      } else {
        merged[index] = message;
      }
    }
    return List<ChatMessage>.unmodifiable(merged);
  }

  void _handleAccessOrLoadError(ApiError error) {
    if (error.type == ApiErrorType.unauthorized ||
        error.type == ApiErrorType.forbidden) {
      _detach(error.message);
      return;
    }
    final current = state;
    if (current is ChatConversationReady) {
      emit(
        ChatConversationReady(
          conversation: current.conversation,
          messages: current.messages,
          nextCursor: current.nextCursor,
          realtimeError: current.realtimeError,
          loadError: error.message,
        ),
      );
    } else {
      emit(ChatConversationFailure(error.message));
    }
  }

  void _detach(String message) {
    _deliveryQueue.clear();
    unawaited(_stopRealtime());
    if (!isClosed) emit(ChatConversationDetached(message));
  }

  Future<void> _stopRealtime() async {
    await _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    await _realtimeErrorSubscription?.cancel();
    _realtimeErrorSubscription = null;
    _realtimeReducer.clear();
    await realtime?.stop();
  }

  @override
  Future<void> close() async {
    await _deliverySubscription.cancel();
    await _stopRealtime();
    await _deliveryQueue.dispose();
    await disposeRealtime?.call();
    return super.close();
  }
}
