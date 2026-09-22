import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:equatable/equatable.dart';

/// Typ zdarzenia Chat, który ma znaczenie dla lokalnej historii rozmowy.
enum ChatConversationRealtimeEventKind {
  messageCreated,
  messageUpdated,
  messageDeleted,
  membershipChanged,

  /// Zmiana stanu pisania innego uczestnika; nie zmienia historii wiadomości.
  typingChanged,

  resyncRequired,
  unsupported,
}

/// Znormalizowane zdarzenie SignalR bez szczegółów protokołu transportowego.
final class ChatConversationRealtimeEvent extends Equatable {
  /// Tworzy event po walidacji envelope'u i payloadu w warstwie data.
  const ChatConversationRealtimeEvent({
    required this.eventId,
    required this.sequence,
    required this.conversationId,
    required this.kind,
    required this.isReplay,
    this.message,
    this.messageId,
    this.messageVersion,
    this.typingUserId,
    this.isTyping,
    this.typingExpiresAtUtc,
  });

  final String? eventId;
  final int? sequence;
  final String conversationId;
  final ChatConversationRealtimeEventKind kind;
  final bool isReplay;
  final ChatMessage? message;
  final String? messageId;
  final int? messageVersion;

  /// UUID uczestnika, którego dotyczy stan pisania.
  final String? typingUserId;

  /// Czy uczestnik nadal pisze.
  final bool? isTyping;

  /// Koniec TTL pisania podany przez serwer albo `null`, gdy pisanie ustało.
  final DateTime? typingExpiresAtUtc;

  @override
  List<Object?> get props => [
    eventId,
    sequence,
    conversationId,
    kind,
    isReplay,
    message,
    messageId,
    messageVersion,
    typingUserId,
    isTyping,
    typingExpiresAtUtc,
  ];
}
