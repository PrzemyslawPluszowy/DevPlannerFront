import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_message_preview.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_participant.dart';
import 'package:equatable/equatable.dart';

/// Pojedyncza pozycja serwerowej skrzynki rozmów.
///
/// Wszystkie liczniki, znaczniki odczytu i podgląd pochodzą z backendu; panel
/// nie wylicza nieprzeczytanych samodzielnie.
final class ChatInboxItem extends Equatable {
  /// Tworzy pozycję skrzynki zwróconą przez backend Workspaces.
  const ChatInboxItem({
    required this.conversation,
    required this.lastActivityAtUtc,
    required this.unreadCount,
    required this.isMuted,
    required this.isDraft,
    required this.participantCount,
    this.lastMessage,
    this.lastReadMessageId,
    this.draftText,
    this.role,
    this.participants = const <ChatInboxParticipant>[],
  });

  final ChatConversation conversation;
  final ChatInboxMessagePreview? lastMessage;
  final DateTime lastActivityAtUtc;
  final int unreadCount;
  final String? lastReadMessageId;
  final bool isMuted;
  final bool isDraft;

  /// Bezpieczny, skrócony podgląd prywatnego szkicu użytkownika.
  final String? draftText;

  /// Rola bieżącego użytkownika albo `null` dla kanału bez rekordu członkostwa.
  final String? role;
  final List<ChatInboxParticipant> participants;
  final int participantCount;

  /// Czy pozycja ma nieprzeczytane wiadomości.
  bool get hasUnread => unreadCount > 0;

  /// Uczestnicy rozmowy poza bieżącym użytkownikiem; dla 1:1 to druga osoba.
  List<ChatInboxParticipant> get otherParticipants => participants
      .where((participant) => !participant.isCurrentUser)
      .toList(
        growable: false,
      );

  /// Nazwa do prezentacji nagłówka: nazwa rozmowy albo etykieta rozmówcy.
  String get displayName {
    final name = conversation.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    final others = otherParticipants;
    if (others.isEmpty) return conversation.id;
    return others.map((participant) => participant.label).join(', ');
  }

  @override
  List<Object?> get props => [
    conversation,
    lastMessage,
    lastActivityAtUtc,
    unreadCount,
    lastReadMessageId,
    isMuted,
    isDraft,
    draftText,
    role,
    participants,
    participantCount,
  ];
}
