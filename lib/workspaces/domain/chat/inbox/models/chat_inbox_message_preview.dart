import 'package:equatable/equatable.dart';

/// Bezpieczny podgląd ostatniej wiadomości rozmowy.
final class ChatInboxMessagePreview extends Equatable {
  /// Tworzy podgląd zwrócony przez backend Workspaces.
  const ChatInboxMessagePreview({
    required this.messageId,
    required this.authorUserId,
    required this.createdAtUtc,
    required this.isDeleted,
    required this.hasAttachments,
    this.text,
    this.threadRootMessageId,
  });

  final String messageId;
  final String authorUserId;

  /// Znormalizowana treść bez sekretów; `null` dla wiadomości usuniętej.
  final String? text;
  final bool isDeleted;
  final bool hasAttachments;
  final String? threadRootMessageId;
  final DateTime createdAtUtc;

  /// Czy podgląd dotyczy odpowiedzi w wątku.
  bool get isThreadReply => threadRootMessageId != null;

  @override
  List<Object?> get props => [
    messageId,
    authorUserId,
    text,
    isDeleted,
    hasAttachments,
    threadRootMessageId,
    createdAtUtc,
  ];
}
