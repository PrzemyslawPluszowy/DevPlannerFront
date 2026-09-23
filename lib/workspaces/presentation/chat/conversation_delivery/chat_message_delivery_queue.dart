import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_client_message_id_factory.dart';

/// Właściciel lokalnych prób dostawy jednej rozmowy, niezależny od Cubita UI.
///
/// Kolejka zachowuje `clientMessageId` i hash payloadu przez retry. Gdy dostanie
/// magazyn trwały, intencje przeżywają restart aplikacji i są wznawiane po
/// ponownym otwarciu rozmowy; bez magazynu działa jak dotąd, wyłącznie w pamięci.
/// Kolejka nie ponawia automatycznie odpowiedzi 400/401/403/409, bo powtórzenie
/// nie zmieni wyniku — te próby zostają jako `failed` do decyzji użytkownika.
final class ChatMessageDeliveryQueue {
  /// Tworzy kolejkę na domenowym kontrakcie transportu i fabryce UUID.
  ChatMessageDeliveryQueue(
    this._repository, {
    ChatClientMessageIdFactory? idFactory,
    DateTime Function()? clock,
    this._pendingStore,
    this.userId = '',
  }) : _idFactory = idFactory ?? ChatClientMessageIdFactory(),
       _clock = clock ?? DateTime.now;

  final ChatConversationRepository _repository;
  final ChatPendingSendStore? _pendingStore;

  /// Local UserId właściciela kolejki; bez niego nic nie jest utrwalane.
  final String userId;
  final ChatClientMessageIdFactory _idFactory;
  final DateTime Function() _clock;
  final StreamController<ChatMessage> _changes =
      StreamController<ChatMessage>.broadcast();
  final StreamController<ChatMessageDeliveryConfirmation> _confirmations =
      StreamController<ChatMessageDeliveryConfirmation>.broadcast();
  final Map<String, ChatMessage> _messagesByClientId = <String, ChatMessage>{};
  final Map<String, List<String>> _attachmentIdsByClientId =
      <String, List<String>>{};
  bool _isDisposed = false;

  /// Powiadamia o każdej zmianie lokalnego wpisu: sending, sent albo failed.
  Stream<ChatMessage> get changes => _changes.stream;

  /// Emisja następuje wyłącznie po zaakceptowanym przez backend create-message.
  ///
  /// Zawiera stabilny UUID klienta oraz dokładny, uporządkowany snapshot
  /// attachmentów użyty w request. Nie jest emitowana przy optimistic enqueue,
  /// błędzie transportu ani konflikcie potwierdzenia.
  Stream<ChatMessageDeliveryConfirmation> get confirmations =>
      _confirmations.stream;

  /// Tworzy optymistyczny wpis i zaczyna pierwszą próbę bez blokowania UI.
  ChatMessage enqueue({
    required String conversationId,
    required ChatComposerDraft draft,
  }) {
    final clientMessageId = _idFactory.create();
    final message = ChatMessage(
      id: 'local:$clientMessageId',
      conversationId: conversationId,
      authorUserId: '',
      clientMessageId: clientMessageId,
      text: draft.text,
      deltaJson: draft.deltaJson,
      replyToMessageId: draft.replyToMessageId,
      payloadHash: _payloadHash(
        text: draft.text,
        deltaJson: draft.deltaJson,
        replyToMessageId: draft.replyToMessageId,
        attachmentFileIds: draft.attachmentIds,
      ),
      version: 0,
      createdAtUtc: _clock().toUtc(),
      isDeleted: false,
      deliveryState: ChatMessageDeliveryState.sending,
    );
    _messagesByClientId[clientMessageId] = message;
    _attachmentIdsByClientId[clientMessageId] = List.unmodifiable(
      draft.attachmentIds,
    );
    _publish(message);
    unawaited(_persist(message, attempts: 1));
    unawaited(_deliver(message));
    return message;
  }

  /// Ponawia wyłącznie wpis oznaczony jako failed, z tym samym UUID i payloadem.
  void retry(String clientMessageId) {
    final current = _messagesByClientId[clientMessageId];
    if (current == null ||
        current.deliveryState != ChatMessageDeliveryState.failed ||
        _isDisposed) {
      return;
    }
    final retrying = current.copyWithDelivery(
      deliveryState: ChatMessageDeliveryState.sending,
    );
    _messagesByClientId[clientMessageId] = retrying;
    _publish(retrying);
    unawaited(
      _persist(retrying, attempts: (_attempts[clientMessageId] ?? 1) + 1),
    );
    unawaited(_deliver(retrying));
  }

  /// Usuwa lokalne dane rozmowy po odebraniu autoryzacji albo zamknięciu ekranu.
  void clear() {
    _messagesByClientId.clear();
    _attachmentIdsByClientId.clear();
    _attempts.clear();
  }

  /// Usuwa trwałe intencje bieżącego użytkownika przy wylogowaniu albo zmianie konta.
  ///
  /// Kolejna sesja nie może ponowić cudzej wysyłki, nawet jeśli keychain przetrwał.
  Future<void> clearForSession() async {
    clear();
    final store = _pendingStore;
    if (store == null || userId.isEmpty) return;
    await store.clearForUser(userId: userId);
  }

  /// Zamyka strumień należący wyłącznie do tej kolejki lokalnej.
  Future<void> dispose() async {
    _isDisposed = true;
    _messagesByClientId.clear();
    _attachmentIdsByClientId.clear();
    _attempts.clear();
    await _changes.close();
    await _confirmations.close();
  }

  /// Wznawia trwałe intencje tej rozmowy po restarcie albo ponownym otwarciu.
  ///
  /// Zwraca liczbę wznowionych prób, żeby właściciel ekranu mógł to pokazać.
  Future<int> restorePending() async {
    final store = _pendingStore;
    if (store == null || userId.isEmpty || _isDisposed) return 0;
    final pending = await store.read(
      userId: userId,
      conversationId: _conversationId ?? '',
    );
    var restored = 0;
    for (final entry in pending) {
      if (_isDisposed) break;
      if (_messagesByClientId.containsKey(entry.clientMessageId)) continue;
      final message = ChatMessage(
        id: 'local:${entry.clientMessageId}',
        conversationId: entry.conversationId,
        authorUserId: '',
        clientMessageId: entry.clientMessageId,
        text: entry.draft.text,
        deltaJson: entry.draft.deltaJson,
        replyToMessageId: entry.draft.replyToMessageId,
        payloadHash: _payloadHash(
          text: entry.draft.text,
          deltaJson: entry.draft.deltaJson,
          replyToMessageId: entry.draft.replyToMessageId,
          attachmentFileIds: entry.draft.attachmentIds,
        ),
        version: 0,
        createdAtUtc: _clock().toUtc(),
        isDeleted: false,
        deliveryState: ChatMessageDeliveryState.sending,
      );
      _messagesByClientId[entry.clientMessageId] = message;
      _attachmentIdsByClientId[entry.clientMessageId] = List.unmodifiable(
        entry.draft.attachmentIds,
      );
      _attempts[entry.clientMessageId] = entry.attempts;
      _publish(message);
      unawaited(_deliver(message));
      restored++;
    }
    return restored;
  }

  /// Ustawia rozmowę, do której należą trwałe intencje kolejki.
  void bindConversation(String conversationId) =>
      _conversationId = conversationId;

  String? _conversationId;

  final Map<String, int> _attempts = <String, int>{};

  Future<void> _persist(ChatMessage message, {required int attempts}) async {
    final store = _pendingStore;
    _attempts[message.clientMessageId] = attempts;
    _conversationId ??= message.conversationId;
    if (store == null || userId.isEmpty) return;
    await store.save(
      userId: userId,
      pending: PendingChatSend(
        clientMessageId: message.clientMessageId,
        conversationId: message.conversationId,
        attempts: attempts,
        draft: ChatComposerDraft(
          text: message.text,
          deltaJson: message.deltaJson,
          replyToMessageId: message.replyToMessageId,
          attachmentIds:
              _attachmentIdsByClientId[message.clientMessageId] ??
              const <String>[],
        ),
      ),
    );
  }

  Future<void> _forget(String clientMessageId) async {
    final store = _pendingStore;
    if (store == null || userId.isEmpty) return;
    await store.remove(userId: userId, clientMessageId: clientMessageId);
  }

  Future<void> _deliver(ChatMessage optimisticMessage) async {
    final attachmentFileIds =
        _attachmentIdsByClientId[optimisticMessage.clientMessageId] ??
        const <String>[];
    final result = await _repository.sendConversationMessage(
      ChatSendMessageCommand(
        conversationId: optimisticMessage.conversationId,
        clientMessageId: optimisticMessage.clientMessageId,
        text: optimisticMessage.text,
        payloadHash: optimisticMessage.payloadHash,
        deltaJson: optimisticMessage.deltaJson,
        replyToMessageId: optimisticMessage.replyToMessageId,
        attachmentFileIds: attachmentFileIds,
      ),
    );
    if (_isDisposed ||
        _messagesByClientId[optimisticMessage.clientMessageId] !=
            optimisticMessage) {
      return;
    }
    result.fold(
      (error) => _publishFailure(optimisticMessage, error),
      (confirmedMessage) => _publishConfirmation(
        optimisticMessage,
        confirmedMessage,
      ),
    );
  }

  void _publishFailure(ChatMessage message, ApiError error) {
    final failed = message.copyWithDelivery(
      deliveryState: ChatMessageDeliveryState.failed,
      deliveryError: error.message,
    );
    _messagesByClientId[message.clientMessageId] = failed;
    _publish(failed);
  }

  void _publishConfirmation(
    ChatMessage optimisticMessage,
    ChatMessage confirmedMessage,
  ) {
    if (confirmedMessage.clientMessageId != optimisticMessage.clientMessageId ||
        confirmedMessage.payloadHash != optimisticMessage.payloadHash) {
      _publishFailure(
        optimisticMessage,
        const ApiError(
          type: ApiErrorType.conflict,
          message: 'Potwierdzenie wiadomości nie pasuje do lokalnej próby.',
        ),
      );
      return;
    }
    final sent = optimisticMessage.copyWithDelivery(
      deliveryState: ChatMessageDeliveryState.sent,
      confirmedMessage: confirmedMessage,
    );
    _messagesByClientId[sent.clientMessageId] = sent;
    _attempts.remove(sent.clientMessageId);
    unawaited(_forget(sent.clientMessageId));
    _publish(sent);
    _publishDeliveryConfirmation(
      ChatMessageDeliveryConfirmation(
        clientMessageId: sent.clientMessageId,
        attachmentFileIds:
            _attachmentIdsByClientId[sent.clientMessageId] ?? const <String>[],
      ),
    );
  }

  String _payloadHash({
    required String text,
    String? deltaJson,
    String? replyToMessageId,
    List<String> attachmentFileIds = const <String>[],
  }) => sha256
      .convert(
        utf8.encode(
          '$text\n${deltaJson ?? ''}\n${replyToMessageId ?? ''}\n'
          '${attachmentFileIds.join('\u0000')}',
        ),
      )
      .toString()
      .toUpperCase();

  void _publish(ChatMessage message) {
    if (!_isDisposed && !_changes.isClosed) _changes.add(message);
  }

  void _publishDeliveryConfirmation(
    ChatMessageDeliveryConfirmation confirmation,
  ) {
    if (!_isDisposed && !_confirmations.isClosed) {
      _confirmations.add(confirmation);
    }
  }
}

/// Potwierdzenie bezpiecznej dostawy, przeznaczone dla ownerów sesji uploadu.
final class ChatMessageDeliveryConfirmation {
  ChatMessageDeliveryConfirmation({
    required this.clientMessageId,
    required List<String> attachmentFileIds,
  }) : attachmentFileIds = List.unmodifiable(attachmentFileIds);

  final String clientMessageId;
  final List<String> attachmentFileIds;
}
