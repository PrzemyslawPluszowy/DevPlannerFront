import 'package:equatable/equatable.dart';

/// Stan aktywnych połączeń uczestnika zwrócony przez Chat Hub.
final class ChatConversationPresenceUser extends Equatable {
  const ChatConversationPresenceUser({
    required this.userId,
    required this.connectionCount,
    required this.isOnline,
  });

  final String userId;
  final int connectionCount;
  final bool isOnline;

  @override
  List<Object?> get props => [userId, connectionCount, isOnline];
}

/// Snapshot online dla uczestników jednej rozmowy.
///
/// Snapshot emituje serwer po dołączeniu, odłączeniu i wygaśnięciu lease'u.
/// Brak użytkownika na liście oznacza offline dopiero po otrzymaniu snapshotu;
/// przed nim klient nie powinien zgadywać stanu.
final class ChatConversationPresenceSnapshot extends Equatable {
  const ChatConversationPresenceSnapshot({
    required this.conversationId,
    required this.users,
    required this.changedAtUtc,
  });

  final String conversationId;
  final List<ChatConversationPresenceUser> users;
  final DateTime changedAtUtc;

  Set<String> get onlineUserIds => users
      .where((user) => user.isOnline && user.connectionCount > 0)
      .map((user) => user.userId)
      .toSet();

  @override
  List<Object?> get props => [conversationId, users, changedAtUtc];
}
