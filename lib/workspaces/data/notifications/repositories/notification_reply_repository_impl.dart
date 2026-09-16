import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/data/notifications/api/notifications_api.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_reply_command.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_reply_repository.dart';

/// Adapter odpowiedzi z powiadomienia, który izoluje kontrakt Chat od UI.
final class NotificationReplyRepositoryImpl extends ApiRepository
    implements NotificationReplyRepository {
  /// Tworzy adapter na prywatnym kliencie powiadomień Workspaces.
  NotificationReplyRepositoryImpl(NotificationsApi api) : _api = api;

  final NotificationsApi _api;

  @override
  Future<Either<ApiError, ChatMessage>> reply(
    NotificationReplyCommand command,
  ) => guardApiCall(
    () async => _toMessage(
      await _api.reply(
        command.notificationId,
        NotificationReplyPayload(
          clientMessageId: command.clientMessageId,
          text: command.text,
          deltaJson: command.deltaJson,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się wysłać odpowiedzi do rozmowy Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź Chat.',
  );

  ChatMessage _toMessage(ChatMessageResponse response) => ChatMessage(
    id: response.id,
    conversationId: response.conversationId,
    authorCoreUserId: response.authorCoreUserId,
    clientMessageId: response.clientMessageId,
    text: response.text,
    deltaJson: response.deltaJson,
    replyToMessageId: response.replyToMessageId,
    payloadHash: response.payloadHash,
    version: response.version,
    createdAtUtc: response.createdAtUtc,
    isDeleted: response.isDeleted,
    threadRootMessageId: response.threadRootMessageId,
    isEdited: response.isEdited,
    deletedAtUtc: response.deletedAtUtc,
    deliveryState: ChatMessageDeliveryState.sent,
    attachments:
        response.attachments
            ?.map(
              (attachment) => ChatMessageAttachment(
                id: attachment.id,
                messageId: attachment.messageId,
                storageFileId: attachment.storageFileId,
                attachedByCoreUserId: attachment.attachedByCoreUserId,
                position: attachment.position,
                createdAtUtc: attachment.createdAtUtc,
              ),
            )
            .toList(growable: false) ??
        const <ChatMessageAttachment>[],
  );
}
