import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_reply_preview.dart';

/// Mapuje backendowy podgląd cytowanej wiadomości na model historii.
abstract final class ChatReplyPreviewMapper {
  static ChatMessageReplyTargetPreview? toDomain(
    ChatMessageReplyPreviewResponse? response,
  ) {
    if (response == null) return null;
    return ChatMessageReplyTargetPreview(
      messageId: response.messageId,
      authorUserId: response.authorUserId,
      authorLabel: response.authorLabel,
      text: response.text,
      isDeleted: response.isDeleted,
      hasAttachments: response.hasAttachments,
      mentionLabels: response.mentionLabels ?? const <String, String>{},
    );
  }
}
