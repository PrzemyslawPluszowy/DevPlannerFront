/// Surowe zdarzenie z Chat Huba. Payload pozostaje mapą, ponieważ backend
/// może rozszerzać poszczególne zdarzenia bez wymuszania zmiany UI.
final class ChatRealtimeEvent {
  /// Tworzy zdarzenie odebrane z podaną nazwą metody SignalR.
  const ChatRealtimeEvent({
    required this.method,
    required this.payload,
    this.isReplay = false,
  });

  /// Nazwa metody klienta, np. `chat.message.created`.
  final String method;

  /// Znormalizowany payload zdarzenia.
  final Map<String, dynamic> payload;

  /// Czy zdarzenie pochodzi z `GetConversationEvents`.
  final bool isReplay;

  /// Id zdarzenia, jeśli backend je dostarczył.
  String? get eventId => _nonEmptyString(
    payload['eventId'] ?? payload['EventId'] ?? payload['id'],
  );

  /// Kursor sekwencji wykorzystywany przy kolejnym replayu.
  int? get sequence => _toInt(
    payload['realtimeSequence'] ??
        payload['sequence'] ??
        payload['Sequence'] ??
        payload['revision'] ??
        payload['Revision'],
  );

  static String? _nonEmptyString(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  static int? _toInt(Object? value) =>
      value is int ? value : int.tryParse('$value');
}

/// Błąd transportu, dekodowania albo replayu Chat.
final class WorkspaceChatRealtimeError {
  /// Zachowuje oryginalny błąd i stack trace dla warstwy stanu.
  const WorkspaceChatRealtimeError(this.error, this.stackTrace);

  /// Oryginalny błąd — UI nie powinno go zastępować fallbackiem.
  final Object error;

  /// Ślad diagnostyczny błędu.
  final StackTrace stackTrace;
}
