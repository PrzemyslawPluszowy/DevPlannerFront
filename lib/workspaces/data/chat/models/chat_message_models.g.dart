// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendChatMessagePayload _$SendChatMessagePayloadFromJson(
  Map<String, dynamic> json,
) => _SendChatMessagePayload(
  clientMessageId: json['clientMessageId'] as String,
  text: json['text'] as String,
  deltaJson: json['deltaJson'] as String?,
  replyToMessageId: json['replyToMessageId'] as String?,
  attachmentFileIds: (json['attachmentFileIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SendChatMessagePayloadToJson(
  _SendChatMessagePayload instance,
) => <String, dynamic>{
  'clientMessageId': instance.clientMessageId,
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'replyToMessageId': instance.replyToMessageId,
  'attachmentFileIds': instance.attachmentFileIds,
};

_UpdateChatMessagePayload _$UpdateChatMessagePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateChatMessagePayload(
  text: json['text'] as String,
  deltaJson: json['deltaJson'] as String?,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$UpdateChatMessagePayloadToJson(
  _UpdateChatMessagePayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'version': instance.version,
};

_ChatMessageResponse _$ChatMessageResponseFromJson(Map<String, dynamic> json) =>
    _ChatMessageResponse(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      authorUserId: json['authorUserId'] as String,
      clientMessageId: json['clientMessageId'] as String,
      text: json['text'] as String,
      deltaJson: json['deltaJson'] as String?,
      replyToMessageId: json['replyToMessageId'] as String?,
      payloadHash: json['payloadHash'] as String,
      version: (json['version'] as num).toInt(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      isDeleted: json['isDeleted'] as bool,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => ChatLinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map(
            (e) =>
                ChatReactionSummaryResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map(
            (e) => ChatAttachmentResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      threadRootMessageId: json['threadRootMessageId'] as String?,
      isEdited: json['isEdited'] as bool? ?? false,
      deletedAtUtc: json['deletedAtUtc'] == null
          ? null
          : DateTime.parse(json['deletedAtUtc'] as String),
      deliveredToCount: (json['deliveredToCount'] as num?)?.toInt() ?? 0,
      readByCount: (json['readByCount'] as num?)?.toInt() ?? 0,
      mentionLabels: (json['mentionLabels'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      replyPreview: json['replyPreview'] == null
          ? null
          : ChatMessageReplyPreviewResponse.fromJson(
              json['replyPreview'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ChatMessageResponseToJson(
  _ChatMessageResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'authorUserId': instance.authorUserId,
  'clientMessageId': instance.clientMessageId,
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'replyToMessageId': instance.replyToMessageId,
  'payloadHash': instance.payloadHash,
  'version': instance.version,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'isDeleted': instance.isDeleted,
  'links': instance.links,
  'reactions': instance.reactions,
  'attachments': instance.attachments,
  'threadRootMessageId': instance.threadRootMessageId,
  'isEdited': instance.isEdited,
  'deletedAtUtc': instance.deletedAtUtc?.toIso8601String(),
  'deliveredToCount': instance.deliveredToCount,
  'readByCount': instance.readByCount,
  'mentionLabels': instance.mentionLabels,
  'replyPreview': instance.replyPreview,
};

_ChatMessageReplyPreviewResponse _$ChatMessageReplyPreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMessageReplyPreviewResponse(
  messageId: json['messageId'] as String,
  authorUserId: json['authorUserId'] as String,
  authorLabel: json['authorLabel'] as String?,
  text: json['text'] as String,
  isDeleted: json['isDeleted'] as bool,
  hasAttachments: json['hasAttachments'] as bool,
  mentionLabels: (json['mentionLabels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$ChatMessageReplyPreviewResponseToJson(
  _ChatMessageReplyPreviewResponse instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'authorUserId': instance.authorUserId,
  'authorLabel': instance.authorLabel,
  'text': instance.text,
  'isDeleted': instance.isDeleted,
  'hasAttachments': instance.hasAttachments,
  'mentionLabels': instance.mentionLabels,
};

_ChatMessageDeliveryResponse _$ChatMessageDeliveryResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMessageDeliveryResponse(
  messageId: json['messageId'] as String,
  recipientUserId: json['recipientUserId'] as String,
  deviceId: json['deviceId'] as String?,
  status: $enumDecode(_$ChatMessageDeliveryStatusEnumMap, json['status']),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  lastError: json['lastError'] as String?,
);

Map<String, dynamic> _$ChatMessageDeliveryResponseToJson(
  _ChatMessageDeliveryResponse instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'recipientUserId': instance.recipientUserId,
  'deviceId': instance.deviceId,
  'status': _$ChatMessageDeliveryStatusEnumMap[instance.status]!,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'lastError': instance.lastError,
};

const _$ChatMessageDeliveryStatusEnumMap = {
  ChatMessageDeliveryStatus.sending: 'Sending',
  ChatMessageDeliveryStatus.sent: 'Sent',
  ChatMessageDeliveryStatus.delivered: 'Delivered',
  ChatMessageDeliveryStatus.read: 'Read',
  ChatMessageDeliveryStatus.failed: 'Failed',
};
