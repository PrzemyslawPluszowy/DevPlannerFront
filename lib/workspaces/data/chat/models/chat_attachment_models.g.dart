// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_attachment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatTemporaryAttachmentSessionResponse
_$ChatTemporaryAttachmentSessionResponseFromJson(Map<String, dynamic> json) =>
    _ChatTemporaryAttachmentSessionResponse(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
    );

Map<String, dynamic> _$ChatTemporaryAttachmentSessionResponseToJson(
  _ChatTemporaryAttachmentSessionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
};

_CopyPrivateFileToChatAttachmentResponse
_$CopyPrivateFileToChatAttachmentResponseFromJson(Map<String, dynamic> json) =>
    _CopyPrivateFileToChatAttachmentResponse(
      storageFileId: json['storageFileId'] as String,
      sessionId: json['sessionId'] as String,
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
    );

Map<String, dynamic> _$CopyPrivateFileToChatAttachmentResponseToJson(
  _CopyPrivateFileToChatAttachmentResponse instance,
) => <String, dynamic>{
  'storageFileId': instance.storageFileId,
  'sessionId': instance.sessionId,
  'fileName': instance.fileName,
  'mimeType': instance.mimeType,
  'fileSizeBytes': instance.fileSizeBytes,
};

_CopyPrivateFileToChatAttachmentPayload
_$CopyPrivateFileToChatAttachmentPayloadFromJson(Map<String, dynamic> json) =>
    _CopyPrivateFileToChatAttachmentPayload(
      storageFileId: json['storageFileId'] as String,
    );

Map<String, dynamic> _$CopyPrivateFileToChatAttachmentPayloadToJson(
  _CopyPrivateFileToChatAttachmentPayload instance,
) => <String, dynamic>{'storageFileId': instance.storageFileId};

_AttachChatFilePayload _$AttachChatFilePayloadFromJson(
  Map<String, dynamic> json,
) => _AttachChatFilePayload(
  storageFileId: json['storageFileId'] as String,
  position: (json['position'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AttachChatFilePayloadToJson(
  _AttachChatFilePayload instance,
) => <String, dynamic>{
  'storageFileId': instance.storageFileId,
  'position': instance.position,
};

_ChatAttachmentResponse _$ChatAttachmentResponseFromJson(
  Map<String, dynamic> json,
) => _ChatAttachmentResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  storageFileId: json['storageFileId'] as String,
  attachedByUserId: json['attachedByUserId'] as String,
  position: (json['position'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  fileName: json['fileName'] as String?,
  fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
  contentType: json['contentType'] as String?,
  isAvailable: json['isAvailable'] as bool? ?? false,
  isOfficeDocument: json['isOfficeDocument'] as bool? ?? false,
);

Map<String, dynamic> _$ChatAttachmentResponseToJson(
  _ChatAttachmentResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'storageFileId': instance.storageFileId,
  'attachedByUserId': instance.attachedByUserId,
  'position': instance.position,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'fileName': instance.fileName,
  'fileSizeBytes': instance.fileSizeBytes,
  'contentType': instance.contentType,
  'isAvailable': instance.isAvailable,
  'isOfficeDocument': instance.isOfficeDocument,
};

_SaveChatAttachmentToStorageResponse
_$SaveChatAttachmentToStorageResponseFromJson(Map<String, dynamic> json) =>
    _SaveChatAttachmentToStorageResponse(
      storageFileId: json['storageFileId'] as String,
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      canEditOnline: json['canEditOnline'] as bool,
    );

Map<String, dynamic> _$SaveChatAttachmentToStorageResponseToJson(
  _SaveChatAttachmentToStorageResponse instance,
) => <String, dynamic>{
  'storageFileId': instance.storageFileId,
  'fileName': instance.fileName,
  'mimeType': instance.mimeType,
  'fileSizeBytes': instance.fileSizeBytes,
  'canEditOnline': instance.canEditOnline,
};
