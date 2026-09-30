// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_content_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatLinkResponse _$ChatLinkResponseFromJson(Map<String, dynamic> json) =>
    _ChatLinkResponse(
      url: json['url'] as String,
      host: json['host'] as String?,
      isHttps: json['isHttps'] as bool,
      isInternal: json['isInternal'] as bool,
      previewAllowed: json['previewAllowed'] as bool,
    );

Map<String, dynamic> _$ChatLinkResponseToJson(_ChatLinkResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
      'host': instance.host,
      'isHttps': instance.isHttps,
      'isInternal': instance.isInternal,
      'previewAllowed': instance.previewAllowed,
    };

_ChatLinkPreviewResponse _$ChatLinkPreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ChatLinkPreviewResponse(
  finalUrl: json['finalUrl'] as String,
  title: json['title'] as String?,
  description: json['description'] as String?,
  contentType: json['contentType'] as String?,
  fetchedAtUtc: DateTime.parse(json['fetchedAtUtc'] as String),
);

Map<String, dynamic> _$ChatLinkPreviewResponseToJson(
  _ChatLinkPreviewResponse instance,
) => <String, dynamic>{
  'finalUrl': instance.finalUrl,
  'title': instance.title,
  'description': instance.description,
  'contentType': instance.contentType,
  'fetchedAtUtc': instance.fetchedAtUtc.toIso8601String(),
};

_ChatSnippetPayload _$ChatSnippetPayloadFromJson(Map<String, dynamic> json) =>
    _ChatSnippetPayload(
      text: json['text'] as String,
      format: json['format'] as String? ?? 'PlainText',
      force: json['force'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatSnippetPayloadToJson(_ChatSnippetPayload instance) =>
    <String, dynamic>{
      'text': instance.text,
      'format': instance.format,
      'force': instance.force,
    };

_ChatSnippetResponse _$ChatSnippetResponseFromJson(Map<String, dynamic> json) =>
    _ChatSnippetResponse(
      isSnippet: json['isSnippet'] as bool,
      originalLength: (json['originalLength'] as num).toInt(),
      suggestedFileName: json['suggestedFileName'] as String?,
      mimeType: json['mimeType'] as String?,
      content: json['content'] as String?,
      isTruncated: json['isTruncated'] as bool,
    );

Map<String, dynamic> _$ChatSnippetResponseToJson(
  _ChatSnippetResponse instance,
) => <String, dynamic>{
  'isSnippet': instance.isSnippet,
  'originalLength': instance.originalLength,
  'suggestedFileName': instance.suggestedFileName,
  'mimeType': instance.mimeType,
  'content': instance.content,
  'isTruncated': instance.isTruncated,
};

_ChatSnippetAttachmentResponse _$ChatSnippetAttachmentResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSnippetAttachmentResponse(
  attachment: ChatAttachmentResponse.fromJson(
    json['attachment'] as Map<String, dynamic>,
  ),
  fileName: json['fileName'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  scanStatus: $enumDecode(_$StorageScanStatusEnumMap, json['scanStatus']),
);

Map<String, dynamic> _$ChatSnippetAttachmentResponseToJson(
  _ChatSnippetAttachmentResponse instance,
) => <String, dynamic>{
  'attachment': instance.attachment,
  'fileName': instance.fileName,
  'fileSizeBytes': instance.fileSizeBytes,
  'scanStatus': _$StorageScanStatusEnumMap[instance.scanStatus]!,
};

const _$StorageScanStatusEnumMap = {
  StorageScanStatus.pending: 'Pending',
  StorageScanStatus.clean: 'Clean',
  StorageScanStatus.infected: 'Infected',
  StorageScanStatus.skipped: 'Skipped',
};
