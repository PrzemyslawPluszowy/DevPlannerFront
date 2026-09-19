import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:equatable/equatable.dart';

/// Typ zdarzenia Chat, który ma znaczenie dla lokalnej historii rozmowy.
enum ChatConversationRealtimeEventKind {
  messageCreated,
  messageUpdated,
  messageDeleted,
  membershipChanged,
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
  });

  final String? eventId;
  final int? sequence;
  final String conversationId;
  final ChatConversationRealtimeEventKind kind;
  final bool isReplay;
  final ChatMessage? message;
  final String? messageId;
  final int? messageVersion;

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
  ];
}
