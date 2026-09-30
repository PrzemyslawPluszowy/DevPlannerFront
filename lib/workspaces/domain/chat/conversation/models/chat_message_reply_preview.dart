import 'package:equatable/equatable.dart';

/// Bezpieczny podgląd autora i cytatu odpowiedzi zwracany przez Backend.
///
/// Pozwala oznaczyć powiązanie także wtedy, gdy oryginalny post nie należy do
/// aktualnie załadowanej strony historii.
final class ChatMessageReplyTargetPreview extends Equatable {
  const ChatMessageReplyTargetPreview({
    required this.messageId,
    required this.authorUserId,
    required this.text,
    required this.isDeleted,
    required this.hasAttachments,
    this.authorLabel,
    this.mentionLabels = const <String, String>{},
  });

  final String messageId;
  final String authorUserId;
  final String? authorLabel;
  final String text;
  final bool isDeleted;
  final bool hasAttachments;
  final Map<String, String> mentionLabels;

  ChatMessageReplyTargetPreview copyWithDeleted() =>
      ChatMessageReplyTargetPreview(
        messageId: messageId,
        authorUserId: authorUserId,
        authorLabel: authorLabel,
        text: '',
        isDeleted: true,
        hasAttachments: hasAttachments,
      );

  @override
  List<Object?> get props => [
    messageId,
    authorUserId,
    authorLabel,
    text,
    isDeleted,
    hasAttachments,
    mentionLabels,
  ];
}
