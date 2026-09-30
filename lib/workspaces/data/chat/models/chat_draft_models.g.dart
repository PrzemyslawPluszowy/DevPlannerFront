// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_draft_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpsertChatDraftPayload _$UpsertChatDraftPayloadFromJson(
  Map<String, dynamic> json,
) => _UpsertChatDraftPayload(
  text: json['text'] as String?,
  deltaJson: json['deltaJson'] as String?,
  replyToMessageId: json['replyToMessageId'] as String?,
  version: (json['version'] as num?)?.toInt() ?? 0,
  attachmentStorageFileIds: (json['attachmentStorageFileIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpsertChatDraftPayloadToJson(
  _UpsertChatDraftPayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'replyToMessageId': instance.replyToMessageId,
  'version': instance.version,
  'attachmentStorageFileIds': instance.attachmentStorageFileIds,
};

_ChatDraftResponse _$ChatDraftResponseFromJson(Map<String, dynamic> json) =>
    _ChatDraftResponse(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      text: json['text'] as String?,
      deltaJson: json['deltaJson'] as String?,
      replyToMessageId: json['replyToMessageId'] as String?,
      version: (json['version'] as num).toInt(),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map(
            (e) =>
                ChatDraftAttachmentResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ChatDraftResponseToJson(_ChatDraftResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'text': instance.text,
      'deltaJson': instance.deltaJson,
      'replyToMessageId': instance.replyToMessageId,
      'version': instance.version,
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'attachments': instance.attachments,
    };

_ChatDraftAttachmentResponse _$ChatDraftAttachmentResponseFromJson(
  Map<String, dynamic> json,
) => _ChatDraftAttachmentResponse(
  id: json['id'] as String,
  storageFileId: json['storageFileId'] as String,
  position: (json['position'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatDraftAttachmentResponseToJson(
  _ChatDraftAttachmentResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'storageFileId': instance.storageFileId,
  'position': instance.position,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};
