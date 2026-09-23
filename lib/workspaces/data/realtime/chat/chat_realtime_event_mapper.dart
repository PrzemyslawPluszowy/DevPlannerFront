import 'dart:convert';

import 'package:devplanner/workspaces/data/chat/models/chat_link_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';

/// Wersja kontraktu realtime Chat zrozumiała dla tego klienta.
///
/// Envelope z nowszą wersją musi trafić do pełnego resyncu zamiast być
/// zastosowany po staremu: nieznane pole mogłoby zmienić znaczenie zdarzenia.
const int workspaceChatRealtimeContractVersion = 1;

/// Dekoduje envelope SignalR Chat do kontraktu domenowego bez przecieku JSON.
final class ChatRealtimeEventMapper {
  /// Dekoduje snapshot ulotnej obecności z `chat.presence.changed`.
  ChatConversationPresenceSnapshot? mapPresence(
    Map<String, dynamic> payload,
  ) {
    final normalized = _normalizeMap(payload);
    final conversationId = _nonEmptyString(normalized['conversationId']);
    final changedAtUtc = _dateTime(normalized['changedAtUtc']);
    final rawUsers = normalized['users'];
    if (conversationId == null || changedAtUtc == null || rawUsers is! List) {
      return null;
    }
    final users = <ChatConversationPresenceUser>[];
    for (final rawUser in rawUsers) {
      if (rawUser is! Map) return null;
      final user = _normalizeMap(rawUser);
      final userId = _nonEmptyString(user['userId']);
      final connectionCount = _int(user['connectionCount']);
      final isOnline = user['isOnline'];
      if (userId == null ||
          connectionCount == null ||
          connectionCount < 0 ||
          isOnline is! bool) {
        return null;
      }
      users.add(
        ChatConversationPresenceUser(
          userId: userId,
          connectionCount: connectionCount,
          isOnline: isOnline,
        ),
      );
    }
    return ChatConversationPresenceSnapshot(
      conversationId: conversationId,
      users: List<ChatConversationPresenceUser>.unmodifiable(users),
      changedAtUtc: changedAtUtc,
    );
  }

  /// Mapuje `chat.user_status.changed`; null w `status` oznacza wyczyszczenie.
  ChatUserStatusChanged? mapUserStatusChanged(Map<String, dynamic> payload) {
    final normalized = _normalizeMap(payload);
    final userId = _nonEmptyString(normalized['userId']);
    if (userId == null || !normalized.containsKey('status')) return null;
    final rawStatus = normalized['status'];
    if (rawStatus == null) {
      return ChatUserStatusChanged(userId: userId, status: null);
    }
    if (rawStatus is! Map) return null;
    final status = _normalizeMap(rawStatus);
    final statusUserId = _nonEmptyString(status['userId']);
    final updatedAtUtc = _dateTime(status['updatedAtUtc']);
    final isDnd = status['isDnd'];
    if (statusUserId != userId || updatedAtUtc == null || isDnd is! bool) {
      return null;
    }
    final emoji = status['emoji'];
    final text = status['text'];
    final expiresAtUtc = status['expiresAtUtc'];
    if ((emoji != null && emoji is! String) ||
        (text != null && text is! String) ||
        (expiresAtUtc != null && _dateTime(expiresAtUtc) == null)) {
      return null;
    }
    return ChatUserStatusChanged(
      userId: userId,
      status: ChatUserStatus(
        userId: userId,
        emoji: emoji as String?,
        text: text as String?,
        expiresAtUtc: _dateTime(expiresAtUtc),
        isDnd: isDnd,
        updatedAtUtc: updatedAtUtc,
      ),
    );
  }

  /// Rozwija `payloadJson` live envelope'u do payloadu zdarzenia domenowego.
  Map<String, dynamic>? normalizeLiveEnvelope(Map<String, dynamic> envelope) {
    final normalizedEnvelope = _normalizeMap(envelope);
    final decodedPayload = normalizedEnvelope['payload'] is Map
        ? _normalizeMap(normalizedEnvelope['payload'] as Map)
        : _payloadJson(normalizedEnvelope['payloadJson']);
    if (decodedPayload == null) return normalizedEnvelope;
    return <String, dynamic>{
      ...decodedPayload,
      if (normalizedEnvelope['eventId'] != null)
        'eventId': normalizedEnvelope['eventId'],
      if (normalizedEnvelope['sequence'] != null)
        'sequence': normalizedEnvelope['sequence'],
      if (normalizedEnvelope['conversationId'] != null)
        'conversationId': normalizedEnvelope['conversationId'],
      if (normalizedEnvelope['contractVersion'] != null)
        'contractVersion': normalizedEnvelope['contractVersion'],
    };
  }

  /// Mapuje otrzymany event albo zwraca null dla envelope'u bez rozmowy.
  ChatConversationRealtimeEvent? map({
    required String method,
    required Map<String, dynamic> payload,
    required bool isReplay,
  }) {
    final normalizedPayload = _normalizeMap(payload);
    final conversationId = _nonEmptyString(normalizedPayload['conversationId']);
    if (conversationId == null) return null;
    final kind = _isSupportedContractVersion(normalizedPayload)
        ? _kindFor(method)
        : ChatConversationRealtimeEventKind.unsupported;
    final message = switch (kind) {
      ChatConversationRealtimeEventKind.messageCreated ||
      ChatConversationRealtimeEventKind.messageUpdated => _messageFrom(
        normalizedPayload,
      ),
      _ => null,
    };
    return ChatConversationRealtimeEvent(
      eventId: _nonEmptyString(normalizedPayload['eventId']),
      sequence: _int(normalizedPayload['sequence']),
      conversationId: conversationId,
      kind: kind,
      isReplay: isReplay,
      message: message,
      messageId: _nonEmptyString(normalizedPayload['messageId']),
      messageVersion: _int(normalizedPayload['version']),
      typingUserId: kind == ChatConversationRealtimeEventKind.typingChanged
          ? _nonEmptyString(normalizedPayload['userId'])
          : null,
      isTyping: kind == ChatConversationRealtimeEventKind.typingChanged
          ? normalizedPayload['isTyping'] == true
          : null,
      typingExpiresAtUtc:
          kind == ChatConversationRealtimeEventKind.typingChanged
          ? _dateTime(normalizedPayload['expiresAtUtc'])
          : null,
    );
  }

  /// Odtwarza stronę huba, łącznie z obowiązkowym sygnałem pełnego resyncu.
  ChatRealtimeReplayPage decodeReplay(Object? value) {
    final map = value is Map ? _normalizeMap(value) : null;
    final items = map?['items'] ?? map?['events'] ?? const <Object?>[];
    final events = <({String method, Map<String, dynamic> payload})>[];
    if (items is List) {
      for (final item in items) {
        if (item is! Map) continue;
        final raw = _normalizeMap(item);
        final method = _nonEmptyString(raw['eventType'] ?? raw['method']);
        final decodedPayload = raw['payload'] is Map
            ? _normalizeMap(raw['payload'] as Map)
            : _payloadJson(raw['payloadJson']);
        if (method == null || decodedPayload == null) continue;
        events.add((
          method: method,
          payload: <String, dynamic>{
            ...decodedPayload,
            if (raw['eventId'] != null) 'eventId': raw['eventId'],
            if (raw['sequence'] != null) 'sequence': raw['sequence'],
            if (raw['conversationId'] != null)
              'conversationId': raw['conversationId'],
            if (raw['contractVersion'] != null)
              'contractVersion': raw['contractVersion'],
          },
        ));
      }
    }
    return ChatRealtimeReplayPage(
      events: events,
      nextCursor: _nonEmptyString(map?['nextCursor']),
      resyncRequired: map?['resyncRequired'] == true,
    );
  }

  /// Konwertuje tekstowy sequence na backendowy URL-safe cursor replay.
  String cursorForSequence(int sequence) =>
      base64Url.encode(utf8.encode('$sequence')).replaceAll('=', '');

  /// Parsuje znacznik czasu UTC z payloadu; niepoprawna wartość jest `null`.
  static DateTime? _dateTime(Object? value) {
    if (value is! String || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    return parsed?.toUtc();
  }

  /// Czy envelope deklaruje wersję kontraktu, którą ten klient rozumie.
  ///
  /// Brak pola oznacza kontrakt bieżący; uznajemy go za zgodny, bo replay i
  /// starsze envelope'y huba nie muszą go powtarzać w payloadzie.
  bool _isSupportedContractVersion(Map<String, dynamic> payload) {
    final version = _int(payload['contractVersion']);
    return version == null || version == workspaceChatRealtimeContractVersion;
  }

  ChatConversationRealtimeEventKind _kindFor(String method) => switch (method) {
    'chat.message.created' => ChatConversationRealtimeEventKind.messageCreated,
    'chat.message.updated' => ChatConversationRealtimeEventKind.messageUpdated,
    'chat.message.deleted' => ChatConversationRealtimeEventKind.messageDeleted,
    'chat.typing.changed' => ChatConversationRealtimeEventKind.typingChanged,
    'chat.member.access_revoked' ||
    'chat.member.added' ||
    'chat.member.left' ||
    'chat.member.rejoined' ||
    'chat.member.removed' ||
    'chat.member.role_changed' =>
      ChatConversationRealtimeEventKind.membershipChanged,
    _ => ChatConversationRealtimeEventKind.unsupported,
  };

  ChatMessage? _messageFrom(Map<String, dynamic> payload) {
    try {
      final response = ChatMessageResponse.fromJson(payload);
      return ChatMessage(
        id: response.id,
        conversationId: response.conversationId,
        authorUserId: response.authorUserId,
        clientMessageId: response.clientMessageId,
        text: response.text,
        deltaJson: response.deltaJson,
        replyToMessageId: response.replyToMessageId,
        payloadHash: response.payloadHash,
        version: response.version,
        createdAtUtc: response.createdAtUtc,
        isDeleted: response.isDeleted,
        threadRootMessageId: response.threadRootMessageId,
        isEdited: response.isEdited,
        deletedAtUtc: response.deletedAtUtc,
        deliveryState: ChatMessageDeliveryState.sent,
        links: ChatLinkMapper.toDomain(response.links),
      );
    } on Object {
      // Wygenerowany fromJson może rzucić także TypeError dla brakującego lub
      // błędnie typowanego pola. Tylko granica deserializacji jest fail-closed;
      // transport i replay raportują własne błędy poza tym mapperem.
      return null;
    }
  }

  Map<String, dynamic>? _payloadJson(Object? value) {
    if (value is! String || value.isEmpty) return null;
    try {
      final decoded = jsonDecode(value);
      return decoded is Map ? _normalizeMap(decoded) : null;
    } on FormatException {
      return null;
    }
  }

  String? _nonEmptyString(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  int? _int(Object? value) => value is int ? value : int.tryParse('$value');

  /// Dopasowuje JSON outboxa C# (PascalCase) do camelCase wygenerowanego API.
  ///
  /// Payload jest serializowany niezależnie od opcji Web API, więc zarówno jego
  /// pola, jak i zagnieżdżone DTO mogą mieć PascalCase. Normalizacja jest
  /// ograniczona do granicy transportu; modele domenowe pozostają typowane.
  Map<String, dynamic> _normalizeMap(Map<Object?, Object?> value) {
    final normalized = <String, dynamic>{};
    for (final entry in value.entries) {
      final key = entry.key;
      if (key is! String) continue;
      normalized[_normalizeKey(key)] = _normalizeValue(entry.value);
    }
    return normalized;
  }

  Object? _normalizeValue(Object? value) => switch (value) {
    Map() => _normalizeMap(value),
    List() => List<Object?>.unmodifiable(
      value.map<Object?>(_normalizeValue),
    ),
    _ => value,
  };

  String _normalizeKey(String key) {
    if (key.isEmpty) return key;
    return '${key[0].toLowerCase()}${key.substring(1)}';
  }
}

/// Jedna strona replayu zwrócona przez ChatEventsHub.
final class ChatRealtimeReplayPage {
  /// Tworzy zdekodowaną stronę i sygnał utraty cursoru z backendu.
  const ChatRealtimeReplayPage({
    required this.events,
    required this.resyncRequired,
    this.nextCursor,
  });

  final List<({String method, Map<String, dynamic> payload})> events;
  final String? nextCursor;
  final bool resyncRequired;
}
