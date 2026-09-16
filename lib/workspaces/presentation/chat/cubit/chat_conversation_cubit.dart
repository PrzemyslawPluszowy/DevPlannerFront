import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:ready_next/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_conversation_state.dart';

/// Lokalny owner snapshotu, paginacji i UI rozmowy, bez kolejki transportowej.
final class ChatConversationCubit extends Cubit<ChatConversationState> {
  /// Tworzy Cubit z osobną kolejką dostawy należącą do tego ekranu rozmowy.
  ChatConversationCubit({
    required ChatConversationRepository repository,
    required this.conversationId,
    ChatMessageDeliveryQueue? deliveryQueue,
    this.realtime,
    this.disposeRealtime,
  }) : _repository = repository,
       _deliveryQueue = deliveryQueue ?? ChatMessageDeliveryQueue(repository),
       super(const ChatConversationInitial()) {
    _deliverySubscription = _deliveryQueue.changes.listen(_onDeliveryChanged);
  }

  final ChatConversationRepository _repository;
  final ChatMessageDeliveryQueue _deliveryQueue;
  final ChatConversationRealtimeReducer _realtimeReducer =
      ChatConversationRealtimeReducer();
  final String conversationId;
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
  Future<void> load() async {
    final inFlight = _loadInFlight;
    if (inFlight != null) return inFlight;
    final operation = _loadInternal(++_loadGeneration);
    _loadInFlight = operation;
    await operation.whenComplete(() => _loadInFlight = null);
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

  /// Ponawia konkretną nieudaną wiadomość z tym samym UUID i payload hash.
  void retry(String clientMessageId) => _deliveryQueue.retry(clientMessageId);

  /// Scala autoryzowany wynik mutacji pojedynczej wiadomości do historii.
  void applyMessageActionResult(ChatMessage message) =>
      _replaceMessage(message);

  /// Odrzuca historię, gdy mutacja wiadomości ujawniła utratę dostępu.
  void detachForMessageAction(String message) => _detach(message);

  Future<void> _loadInternal(int generation) async {
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
        final previousMessages = previous is ChatConversationReady
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
      case ChatConversationRealtimeDecision.resyncRequired:
        unawaited(load());
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
