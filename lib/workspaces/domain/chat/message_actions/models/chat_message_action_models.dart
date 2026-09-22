import 'package:equatable/equatable.dart';

/// Pojedyncza reakcja emoji na wiadomość.
final class ChatMessageReaction extends Equatable {
  /// Tworzy reakcję zwróconą przez backend.
  const ChatMessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.createdAtUtc,
  });

  final String id;
  final String messageId;
  final String userId;
  final String emoji;
  final DateTime createdAtUtc;

  @override
  List<Object?> get props => [id, messageId, userId, emoji, createdAtUtc];
}

/// Zagregowany podgląd reakcji emoji dla wiersza wiadomości.
final class ChatReactionSummary extends Equatable {
  /// Tworzy podsumowanie reakcji.
  const ChatReactionSummary({
    required this.emoji,
    required this.count,
    required this.reactedByCurrentUser,
  });

  final String emoji;
  final int count;
  final bool reactedByCurrentUser;

  @override
  List<Object?> get props => [emoji, count, reactedByCurrentUser];
}

/// Przypięta wiadomość rozmowy.
final class ChatPinnedMessage extends Equatable {
  /// Tworzy przypięcie zwrócone przez backend.
  const ChatPinnedMessage({
    required this.id,
    required this.conversationId,
    required this.messageId,
    required this.pinnedByUserId,
    required this.pinnedAtUtc,
  });

  final String id;
  final String conversationId;
  final String messageId;
  final String pinnedByUserId;
  final DateTime pinnedAtUtc;

  @override
  List<Object?> get props => [
    id,
    conversationId,
    messageId,
    pinnedByUserId,
    pinnedAtUtc,
  ];
}

/// Prywatna zakładka użytkownika do wiadomości.
final class ChatBookmark extends Equatable {
  /// Tworzy zakładkę zwróconą przez backend.
  const ChatBookmark({
    required this.id,
    required this.messageId,
    required this.conversationId,
    required this.userId,
    required this.createdAtUtc,
    this.note,
  });

  final String id;
  final String messageId;
  final String conversationId;
  final String userId;
  final String? note;
  final DateTime createdAtUtc;

  @override
  List<Object?> get props => [
    id,
    messageId,
    conversationId,
    userId,
    note,
    createdAtUtc,
  ];
}
