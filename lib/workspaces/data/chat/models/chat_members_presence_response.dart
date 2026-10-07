/// Bieżący snapshot obecności uczestników autoryzowanej rozmowy.
final class ChatMembersPresenceResponse {
  const ChatMembersPresenceResponse({
    required this.users,
    required this.snapshotAtUtc,
  });

  factory ChatMembersPresenceResponse.fromJson(Map<String, dynamic> json) {
    final snapshot = DateTime.parse(json['snapshotAtUtc'] as String);
    if (!snapshot.isUtc) {
      throw const FormatException('Presence snapshot must use UTC.');
    }
    final users = <String, bool>{};
    for (final item in json['users'] as List<dynamic>) {
      final user = item as Map<String, dynamic>;
      final id = user['userId'] as String;
      if (id.trim().isEmpty || users.containsKey(id)) {
        throw const FormatException('Invalid presence user identifier.');
      }
      users[id] = user['isOnline'] as bool;
    }
    return ChatMembersPresenceResponse(
      users: Map<String, bool>.unmodifiable(users),
      snapshotAtUtc: snapshot,
    );
  }

  final Map<String, bool> users;
  final DateTime snapshotAtUtc;
}
