import 'package:devplanner/workspaces/data/chat/models/chat_link_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_reply_preview_mapper.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';

/// Jedno mapowanie wiadomości API dla historii i realtime.
abstract final class ChatMessageResponseMapper {
  /// Przenosi wszystkie pola serwerowe do modelu domenowego.
  static ChatMessage toDomain(ChatMessageResponse response) => ChatMessage(
    id: response.id,
    conversationId: response.conversationId,
    authorUserId: response.authorUserId,
    clientMessageId: response.clientMessageId,
    text: response.text,
    deltaJson: response.deltaJson,
    replyToMessageId: response.replyToMessageId,
    replyPreview: ChatReplyPreviewMapper.toDomain(response.replyPreview),
    payloadHash: response.payloadHash,
    version: response.version,
    createdAtUtc: response.createdAtUtc,
    isDeleted: response.isDeleted,
    threadRootMessageId: response.threadRootMessageId,
    isEdited: response.isEdited,
    deliveredToCount: response.deliveredToCount,
    readByCount: response.readByCount,
    mentionLabels: response.mentionLabels ?? const <String, String>{},
    links: ChatLinkMapper.toDomain(response.links),
    deletedAtUtc: response.deletedAtUtc,
    deliveryState: ChatMessageDeliveryState.sent,
    reactions:
        response.reactions
            ?.map(
              (reaction) => ChatReactionSummary(
                emoji: reaction.emoji,
                count: reaction.count,
                reactedByCurrentUser: reaction.reactedByCurrentUser,
              ),
            )
            .toList(growable: false) ??
        const <ChatReactionSummary>[],
    attachments:
        response.attachments
            ?.map(
              (attachment) => ChatMessageAttachment(
                id: attachment.id,
                messageId: attachment.messageId,
                storageFileId: attachment.storageFileId,
                attachedByUserId: attachment.attachedByUserId,
                position: attachment.position,
                createdAtUtc: attachment.createdAtUtc,
                fileName: attachment.fileName,
                fileSizeBytes: attachment.fileSizeBytes,
                contentType: attachment.contentType,
                isAvailable: attachment.isAvailable,
                isOfficeDocument: attachment.isOfficeDocument,
              ),
            )
            .toList(growable: false) ??
        const <ChatMessageAttachment>[],
  );
}
