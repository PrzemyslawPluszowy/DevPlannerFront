import 'package:equatable/equatable.dart';

/// Agregat nieprzeczytanych wiadomości Chat dla belki i listy rozmów.
final class ChatInboxUnreadCount extends Equatable {
  /// Tworzy agregat zwrócony przez backend Workspaces.
  const ChatInboxUnreadCount({
    required this.totalUnreadCount,
    required this.unreadConversationCount,
    required this.generatedAtUtc,
  });

  final int totalUnreadCount;
  final int unreadConversationCount;
  final DateTime generatedAtUtc;

  /// Czy belka powinna pokazać badge.
  bool get hasUnread => totalUnreadCount > 0;

  @override
  List<Object?> get props => [
    totalUnreadCount,
    unreadConversationCount,
    generatedAtUtc,
  ];
}
