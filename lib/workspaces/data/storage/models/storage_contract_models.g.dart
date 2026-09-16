// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_contract_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StorageUploadTicketItemPayload _$StorageUploadTicketItemPayloadFromJson(
  Map<String, dynamic> json,
) => _StorageUploadTicketItemPayload(
  fileName: json['fileName'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  mimeType: json['mimeType'] as String?,
  contentSha256: json['contentSha256'] as String?,
);

Map<String, dynamic> _$StorageUploadTicketItemPayloadToJson(
  _StorageUploadTicketItemPayload instance,
) => <String, dynamic>{
  'fileName': instance.fileName,
  'fileSizeBytes': instance.fileSizeBytes,
  'mimeType': instance.mimeType,
  'contentSha256': instance.contentSha256,
};

_BulkTaskUploadTicketPayload _$BulkTaskUploadTicketPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkTaskUploadTicketPayload(
  files: (json['files'] as List<dynamic>)
      .map(
        (e) =>
            StorageUploadTicketItemPayload.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$BulkTaskUploadTicketPayloadToJson(
  _BulkTaskUploadTicketPayload instance,
) => <String, dynamic>{'files': instance.files};

_StorageUploadTicketResponse _$StorageUploadTicketResponseFromJson(
  Map<String, dynamic> json,
) => _StorageUploadTicketResponse(
  fileId: json['fileId'] as String,
  storageObjectKey: json['storageObjectKey'] as String,
  uploadUrl: json['uploadUrl'] as String,
  expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
  isAlreadyUploaded: json['isAlreadyUploaded'] as bool,
);

Map<String, dynamic> _$StorageUploadTicketResponseToJson(
  _StorageUploadTicketResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'storageObjectKey': instance.storageObjectKey,
  'uploadUrl': instance.uploadUrl,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
  'isAlreadyUploaded': instance.isAlreadyUploaded,
};

_BulkStorageUploadTicketResponse _$BulkStorageUploadTicketResponseFromJson(
  Map<String, dynamic> json,
) => _BulkStorageUploadTicketResponse(
  tickets: (json['tickets'] as List<dynamic>)
      .map(
        (e) => StorageUploadTicketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$BulkStorageUploadTicketResponseToJson(
  _BulkStorageUploadTicketResponse instance,
) => <String, dynamic>{'tickets': instance.tickets};

_BulkCompleteFileItemPayload _$BulkCompleteFileItemPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkCompleteFileItemPayload(
  fileId: json['fileId'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  contentSha256: json['contentSha256'] as String?,
  changeSummary: json['changeSummary'] as String?,
);

Map<String, dynamic> _$BulkCompleteFileItemPayloadToJson(
  _BulkCompleteFileItemPayload instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'fileSizeBytes': instance.fileSizeBytes,
  'contentSha256': instance.contentSha256,
  'changeSummary': instance.changeSummary,
};

_BulkCompleteUploadPayload _$BulkCompleteUploadPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkCompleteUploadPayload(
  files: (json['files'] as List<dynamic>)
      .map(
        (e) => BulkCompleteFileItemPayload.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$BulkCompleteUploadPayloadToJson(
  _BulkCompleteUploadPayload instance,
) => <String, dynamic>{'files': instance.files};

_StorageFileResponse _$StorageFileResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileResponse(
  id: json['id'] as String,
  module: $enumDecode(_$StorageModuleEnumMap, json['module']),
  resourceType: $enumDecode(_$StorageResourceTypeEnumMap, json['resourceType']),
  resourceId: json['resourceId'] as String?,
  originalFileName: json['originalFileName'] as String,
  extension: json['extension'] as String,
  mimeType: json['mimeType'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  contentSha256: json['contentSha256'] as String?,
  version: (json['version'] as num).toInt(),
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  ownerUserId: json['ownerUserId'] as String,
  createdByUserId: json['createdByUserId'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  isDeleted: json['isDeleted'] as bool,
  processingStatus: $enumDecode(
    _$StorageProcessingStatusEnumMap,
    json['processingStatus'],
  ),
  scanStatus: $enumDecode(_$StorageScanStatusEnumMap, json['scanStatus']),
  aiStatus: $enumDecode(_$StorageAiStatusEnumMap, json['aiStatus']),
  aiDescription: json['aiDescription'] as String?,
  aiTags: (json['aiTags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  aiSummary: json['aiSummary'] as String?,
  aiOcrText: json['aiOcrText'] as String?,
  mediaDurationSeconds: (json['mediaDurationSeconds'] as num?)?.toInt(),
  mediaWidth: (json['mediaWidth'] as num?)?.toInt(),
  mediaHeight: (json['mediaHeight'] as num?)?.toInt(),
  accessLevel:
      $enumDecodeNullable(
        _$StorageEffectiveAccessLevelEnumMap,
        json['accessLevel'],
      ) ??
      StorageEffectiveAccessLevel.none,
  canRead: json['canRead'] as bool? ?? false,
  canComment: json['canComment'] as bool? ?? false,
  canEdit: json['canEdit'] as bool? ?? false,
  canShare: json['canShare'] as bool? ?? false,
  canDelete: json['canDelete'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  favoritedAtUtc: json['favoritedAtUtc'] == null
      ? null
      : DateTime.parse(json['favoritedAtUtc'] as String),
  lastAccessedAtUtc: json['lastAccessedAtUtc'] == null
      ? null
      : DateTime.parse(json['lastAccessedAtUtc'] as String),
  manualDescription: json['manualDescription'] as String?,
  manualDescriptionUpdatedByUserId:
      json['manualDescriptionUpdatedByUserId'] as String?,
  manualDescriptionUpdatedAtUtc: json['manualDescriptionUpdatedAtUtc'] == null
      ? null
      : DateTime.parse(json['manualDescriptionUpdatedAtUtc'] as String),
  concurrencyToken: json['concurrencyToken'] as String?,
  aiLanguage: json['aiLanguage'] as String?,
  aiEntities: (json['aiEntities'] as List<dynamic>?)
      ?.map((e) => AiDetectedEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  canPreview: json['canPreview'] as bool? ?? false,
  canEditOnline: json['canEditOnline'] as bool? ?? false,
  canDownload: json['canDownload'] as bool? ?? false,
  canManageVersions: json['canManageVersions'] as bool? ?? false,
  canRestore: json['canRestore'] as bool? ?? false,
  canConvertToPdf: json['canConvertToPdf'] as bool? ?? false,
);

Map<String, dynamic> _$StorageFileResponseToJson(
  _StorageFileResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'module': _$StorageModuleEnumMap[instance.module]!,
  'resourceType': _$StorageResourceTypeEnumMap[instance.resourceType]!,
  'resourceId': instance.resourceId,
  'originalFileName': instance.originalFileName,
  'extension': instance.extension,
  'mimeType': instance.mimeType,
  'fileSizeBytes': instance.fileSizeBytes,
  'contentSha256': instance.contentSha256,
  'version': instance.version,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'ownerUserId': instance.ownerUserId,
  'createdByUserId': instance.createdByUserId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'isDeleted': instance.isDeleted,
  'processingStatus':
      _$StorageProcessingStatusEnumMap[instance.processingStatus]!,
  'scanStatus': _$StorageScanStatusEnumMap[instance.scanStatus]!,
  'aiStatus': _$StorageAiStatusEnumMap[instance.aiStatus]!,
  'aiDescription': instance.aiDescription,
  'aiTags': instance.aiTags,
  'aiSummary': instance.aiSummary,
  'aiOcrText': instance.aiOcrText,
  'mediaDurationSeconds': instance.mediaDurationSeconds,
  'mediaWidth': instance.mediaWidth,
  'mediaHeight': instance.mediaHeight,
  'accessLevel': _$StorageEffectiveAccessLevelEnumMap[instance.accessLevel]!,
  'canRead': instance.canRead,
  'canComment': instance.canComment,
  'canEdit': instance.canEdit,
  'canShare': instance.canShare,
  'canDelete': instance.canDelete,
  'isFavorite': instance.isFavorite,
  'favoritedAtUtc': instance.favoritedAtUtc?.toIso8601String(),
  'lastAccessedAtUtc': instance.lastAccessedAtUtc?.toIso8601String(),
  'manualDescription': instance.manualDescription,
  'manualDescriptionUpdatedByUserId': instance.manualDescriptionUpdatedByUserId,
  'manualDescriptionUpdatedAtUtc': instance.manualDescriptionUpdatedAtUtc
      ?.toIso8601String(),
  'concurrencyToken': instance.concurrencyToken,
  'aiLanguage': instance.aiLanguage,
  'aiEntities': instance.aiEntities,
  'canPreview': instance.canPreview,
  'canEditOnline': instance.canEditOnline,
  'canDownload': instance.canDownload,
  'canManageVersions': instance.canManageVersions,
  'canRestore': instance.canRestore,
  'canConvertToPdf': instance.canConvertToPdf,
};

const _$StorageModuleEnumMap = {
  StorageModule.workspaces: 'Workspaces',
  StorageModule.inventory: 'Inventory',
  StorageModule.bhp: 'Bhp',
  StorageModule.iqc: 'Iqc',
  StorageModule.fleet: 'Fleet',
  StorageModule.shared: 'Shared',
};

const _$StorageResourceTypeEnumMap = {
  StorageResourceType.task: 'Task',
  StorageResourceType.comment: 'Comment',
  StorageResourceType.project: 'Project',
  StorageResourceType.document: 'Document',
  StorageResourceType.sheet: 'Sheet',
  StorageResourceType.accidentProtocol: 'AccidentProtocol',
  StorageResourceType.userAvatar: 'UserAvatar',
  StorageResourceType.privateFile: 'Private',
  StorageResourceType.okrObjective: 'OkrObjective',
  StorageResourceType.portfolio: 'Portfolio',
};

const _$StorageProcessingStatusEnumMap = {
  StorageProcessingStatus.none: 'None',
  StorageProcessingStatus.queued: 'Queued',
  StorageProcessingStatus.processing: 'Processing',
  StorageProcessingStatus.ready: 'Ready',
  StorageProcessingStatus.failed: 'Failed',
};

const _$StorageScanStatusEnumMap = {
  StorageScanStatus.pending: 'Pending',
  StorageScanStatus.clean: 'Clean',
  StorageScanStatus.infected: 'Infected',
  StorageScanStatus.skipped: 'Skipped',
};

const _$StorageAiStatusEnumMap = {
  StorageAiStatus.none: 'None',
  StorageAiStatus.queued: 'Queued',
  StorageAiStatus.processing: 'Processing',
  StorageAiStatus.completed: 'Completed',
  StorageAiStatus.failed: 'Failed',
};

const _$StorageEffectiveAccessLevelEnumMap = {
  StorageEffectiveAccessLevel.none: 'None',
  StorageEffectiveAccessLevel.reader: 'Reader',
  StorageEffectiveAccessLevel.commenter: 'Commenter',
  StorageEffectiveAccessLevel.editor: 'Editor',
  StorageEffectiveAccessLevel.owner: 'Owner',
};

_BulkCompleteFileItemResult _$BulkCompleteFileItemResultFromJson(
  Map<String, dynamic> json,
) => _BulkCompleteFileItemResult(
  fileId: json['fileId'] as String,
  success: json['success'] as bool,
  file: json['file'] == null
      ? null
      : StorageFileResponse.fromJson(json['file'] as Map<String, dynamic>),
  errorCode: json['errorCode'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$BulkCompleteFileItemResultToJson(
  _BulkCompleteFileItemResult instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'success': instance.success,
  'file': instance.file,
  'errorCode': instance.errorCode,
  'errorMessage': instance.errorMessage,
};

_BulkCompleteUploadResponse _$BulkCompleteUploadResponseFromJson(
  Map<String, dynamic> json,
) => _BulkCompleteUploadResponse(
  results: (json['results'] as List<dynamic>)
      .map(
        (e) => BulkCompleteFileItemResult.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  successCount: (json['successCount'] as num).toInt(),
  failedCount: (json['failedCount'] as num).toInt(),
);

Map<String, dynamic> _$BulkCompleteUploadResponseToJson(
  _BulkCompleteUploadResponse instance,
) => <String, dynamic>{
  'results': instance.results,
  'totalCount': instance.totalCount,
  'successCount': instance.successCount,
  'failedCount': instance.failedCount,
};
