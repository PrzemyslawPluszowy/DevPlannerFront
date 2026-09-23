// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_extended_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BulkStorageUploadTicketPayload _$BulkStorageUploadTicketPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkStorageUploadTicketPayload(
  files: (json['files'] as List<dynamic>)
      .map(
        (e) =>
            StorageUploadTicketItemPayload.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  module: $enumDecode(_$StorageModuleEnumMap, json['module']),
  resourceType: $enumDecode(_$StorageResourceTypeEnumMap, json['resourceType']),
  resourceId: json['resourceId'] as String?,
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
);

Map<String, dynamic> _$BulkStorageUploadTicketPayloadToJson(
  _BulkStorageUploadTicketPayload instance,
) => <String, dynamic>{
  'files': instance.files,
  'module': _$StorageModuleEnumMap[instance.module]!,
  'resourceType': _$StorageResourceTypeEnumMap[instance.resourceType]!,
  'resourceId': instance.resourceId,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
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

_QuillCleanUnusedImagesPayload _$QuillCleanUnusedImagesPayloadFromJson(
  Map<String, dynamic> json,
) => _QuillCleanUnusedImagesPayload(
  deltaJson: json['deltaJson'] as String,
  resourceType: $enumDecode(_$StorageResourceTypeEnumMap, json['resourceType']),
  resourceId: json['resourceId'] as String,
);

Map<String, dynamic> _$QuillCleanUnusedImagesPayloadToJson(
  _QuillCleanUnusedImagesPayload instance,
) => <String, dynamic>{
  'deltaJson': instance.deltaJson,
  'resourceType': _$StorageResourceTypeEnumMap[instance.resourceType]!,
  'resourceId': instance.resourceId,
};

_UpdateStorageFileDescriptionPayload
_$UpdateStorageFileDescriptionPayloadFromJson(Map<String, dynamic> json) =>
    _UpdateStorageFileDescriptionPayload(
      manualDescription: json['manualDescription'] as String?,
      expectedConcurrencyToken: json['expectedConcurrencyToken'] as String?,
    );

Map<String, dynamic> _$UpdateStorageFileDescriptionPayloadToJson(
  _UpdateStorageFileDescriptionPayload instance,
) => <String, dynamic>{
  'manualDescription': instance.manualDescription,
  'expectedConcurrencyToken': instance.expectedConcurrencyToken,
};

_UpdateStorageFolderPayload _$UpdateStorageFolderPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateStorageFolderPayload(
  name: json['name'] as String?,
  parentFolderId: json['parentFolderId'] as String?,
);

Map<String, dynamic> _$UpdateStorageFolderPayloadToJson(
  _UpdateStorageFolderPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'parentFolderId': instance.parentFolderId,
};

_CreateStorageFolderSharePayload _$CreateStorageFolderSharePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateStorageFolderSharePayload(
  sharedWithUserId: json['sharedWithUserId'] as String,
  accessLevel: $enumDecode(
    _$StorageShareAccessLevelEnumMap,
    json['accessLevel'],
  ),
  expiresAtUtc: json['expiresAtUtc'] == null
      ? null
      : DateTime.parse(json['expiresAtUtc'] as String),
);

Map<String, dynamic> _$CreateStorageFolderSharePayloadToJson(
  _CreateStorageFolderSharePayload instance,
) => <String, dynamic>{
  'sharedWithUserId': instance.sharedWithUserId,
  'accessLevel': _$StorageShareAccessLevelEnumMap[instance.accessLevel]!,
  'expiresAtUtc': instance.expiresAtUtc?.toIso8601String(),
};

const _$StorageShareAccessLevelEnumMap = {
  StorageShareAccessLevel.read: 'Read',
  StorageShareAccessLevel.write: 'Write',
  StorageShareAccessLevel.owner: 'Owner',
  StorageShareAccessLevel.editor: 'Editor',
  StorageShareAccessLevel.commenter: 'Commenter',
  StorageShareAccessLevel.reader: 'Reader',
};

_StorageFolderShareResponse _$StorageFolderShareResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFolderShareResponse(
  id: json['id'] as String,
  folderId: json['folderId'] as String,
  sharedWithUserId: json['sharedWithUserId'] as String,
  accessLevel: $enumDecode(
    _$StorageShareAccessLevelEnumMap,
    json['accessLevel'],
  ),
  expiresAtUtc: json['expiresAtUtc'] == null
      ? null
      : DateTime.parse(json['expiresAtUtc'] as String),
  createdByUserId: json['createdByUserId'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  effectiveAccessLevel: $enumDecode(
    _$StorageEffectiveAccessLevelEnumMap,
    json['effectiveAccessLevel'],
  ),
  canRead: json['canRead'] as bool,
  canComment: json['canComment'] as bool,
  canEdit: json['canEdit'] as bool,
  canShare: json['canShare'] as bool,
  canDelete: json['canDelete'] as bool,
);

Map<String, dynamic> _$StorageFolderShareResponseToJson(
  _StorageFolderShareResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'folderId': instance.folderId,
  'sharedWithUserId': instance.sharedWithUserId,
  'accessLevel': _$StorageShareAccessLevelEnumMap[instance.accessLevel]!,
  'expiresAtUtc': instance.expiresAtUtc?.toIso8601String(),
  'createdByUserId': instance.createdByUserId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'effectiveAccessLevel':
      _$StorageEffectiveAccessLevelEnumMap[instance.effectiveAccessLevel]!,
  'canRead': instance.canRead,
  'canComment': instance.canComment,
  'canEdit': instance.canEdit,
  'canShare': instance.canShare,
  'canDelete': instance.canDelete,
};

const _$StorageEffectiveAccessLevelEnumMap = {
  StorageEffectiveAccessLevel.none: 'None',
  StorageEffectiveAccessLevel.reader: 'Reader',
  StorageEffectiveAccessLevel.commenter: 'Commenter',
  StorageEffectiveAccessLevel.editor: 'Editor',
  StorageEffectiveAccessLevel.owner: 'Owner',
};

_AttachStorageFileToProjectPayload _$AttachStorageFileToProjectPayloadFromJson(
  Map<String, dynamic> json,
) => _AttachStorageFileToProjectPayload(
  folderId: json['folderId'] as String,
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$AttachStorageFileToProjectPayloadToJson(
  _AttachStorageFileToProjectPayload instance,
) => <String, dynamic>{
  'folderId': instance.folderId,
  'displayName': instance.displayName,
};

_PublicShareAccessPayload _$PublicShareAccessPayloadFromJson(
  Map<String, dynamic> json,
) => _PublicShareAccessPayload(password: json['password'] as String?);

Map<String, dynamic> _$PublicShareAccessPayloadToJson(
  _PublicShareAccessPayload instance,
) => <String, dynamic>{'password': instance.password};

_QuillCleanUnusedImagesResponse _$QuillCleanUnusedImagesResponseFromJson(
  Map<String, dynamic> json,
) => _QuillCleanUnusedImagesResponse(
  deletedFileIds: (json['deletedFileIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$QuillCleanUnusedImagesResponseToJson(
  _QuillCleanUnusedImagesResponse instance,
) => <String, dynamic>{'deletedFileIds': instance.deletedFileIds};

_SetUserAvatarPayload _$SetUserAvatarPayloadFromJson(
  Map<String, dynamic> json,
) => _SetUserAvatarPayload(fileId: json['fileId'] as String);

Map<String, dynamic> _$SetUserAvatarPayloadToJson(
  _SetUserAvatarPayload instance,
) => <String, dynamic>{'fileId': instance.fileId};

_StorageScanResultPayload _$StorageScanResultPayloadFromJson(
  Map<String, dynamic> json,
) => _StorageScanResultPayload(
  scanStatus: $enumDecode(_$StorageScanStatusEnumMap, json['scanStatus']),
);

Map<String, dynamic> _$StorageScanResultPayloadToJson(
  _StorageScanResultPayload instance,
) => <String, dynamic>{
  'scanStatus': _$StorageScanStatusEnumMap[instance.scanStatus]!,
};

const _$StorageScanStatusEnumMap = {
  StorageScanStatus.pending: 'Pending',
  StorageScanStatus.clean: 'Clean',
  StorageScanStatus.infected: 'Infected',
  StorageScanStatus.skipped: 'Skipped',
};

_StorageFileVersionResponse _$StorageFileVersionResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileVersionResponse(
  id: json['id'] as String,
  version: (json['version'] as num).toInt(),
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  contentSha256: json['contentSha256'] as String?,
  createdByUserId: json['createdByUserId'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  changeSummary: json['changeSummary'] as String?,
  isCurrent: json['isCurrent'] as bool? ?? false,
  changedByUserId: json['changedByUserId'] as String?,
);

Map<String, dynamic> _$StorageFileVersionResponseToJson(
  _StorageFileVersionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'version': instance.version,
  'fileSizeBytes': instance.fileSizeBytes,
  'contentSha256': instance.contentSha256,
  'createdByUserId': instance.createdByUserId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'changeSummary': instance.changeSummary,
  'isCurrent': instance.isCurrent,
  'changedByUserId': instance.changedByUserId,
};

_RestoreStorageFileVersionPayload _$RestoreStorageFileVersionPayloadFromJson(
  Map<String, dynamic> json,
) => _RestoreStorageFileVersionPayload(
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  changeSummary: json['changeSummary'] as String?,
);

Map<String, dynamic> _$RestoreStorageFileVersionPayloadToJson(
  _RestoreStorageFileVersionPayload instance,
) => <String, dynamic>{
  'expectedVersion': instance.expectedVersion,
  'changeSummary': instance.changeSummary,
};

_StorageFileVersionDownloadTicketResponse
_$StorageFileVersionDownloadTicketResponseFromJson(Map<String, dynamic> json) =>
    _StorageFileVersionDownloadTicketResponse(
      fileId: json['fileId'] as String,
      version: (json['version'] as num).toInt(),
      originalFileName: json['originalFileName'] as String,
      mimeType: json['mimeType'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      contentSha256: json['contentSha256'] as String?,
      downloadUrl: json['downloadUrl'] as String,
      expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
    );

Map<String, dynamic> _$StorageFileVersionDownloadTicketResponseToJson(
  _StorageFileVersionDownloadTicketResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'version': instance.version,
  'originalFileName': instance.originalFileName,
  'mimeType': instance.mimeType,
  'fileSizeBytes': instance.fileSizeBytes,
  'contentSha256': instance.contentSha256,
  'downloadUrl': instance.downloadUrl,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
};

_StorageFilePermissionsResponse _$StorageFilePermissionsResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFilePermissionsResponse(
  accessLevel: $enumDecode(
    _$StorageEffectiveAccessLevelEnumMap,
    json['accessLevel'],
  ),
  canRead: json['canRead'] as bool,
  canComment: json['canComment'] as bool,
  canEdit: json['canEdit'] as bool,
  canShare: json['canShare'] as bool,
  canDelete: json['canDelete'] as bool,
);

Map<String, dynamic> _$StorageFilePermissionsResponseToJson(
  _StorageFilePermissionsResponse instance,
) => <String, dynamic>{
  'accessLevel': _$StorageEffectiveAccessLevelEnumMap[instance.accessLevel]!,
  'canRead': instance.canRead,
  'canComment': instance.canComment,
  'canEdit': instance.canEdit,
  'canShare': instance.canShare,
  'canDelete': instance.canDelete,
};

_StorageFileDetailsResponse _$StorageFileDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileDetailsResponse(
  file: StorageFileResponse.fromJson(json['file'] as Map<String, dynamic>),
  versions: (json['versions'] as List<dynamic>)
      .map(
        (e) => StorageFileVersionResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  canEdit: json['canEdit'] as bool,
  canDelete: json['canDelete'] as bool,
  isOfficeDocument: json['isOfficeDocument'] as bool,
  permissions: StorageFilePermissionsResponse.fromJson(
    json['permissions'] as Map<String, dynamic>,
  ),
  canOpenResourceChat: json['canOpenResourceChat'] as bool? ?? false,
);

Map<String, dynamic> _$StorageFileDetailsResponseToJson(
  _StorageFileDetailsResponse instance,
) => <String, dynamic>{
  'file': instance.file,
  'versions': instance.versions,
  'canEdit': instance.canEdit,
  'canDelete': instance.canDelete,
  'isOfficeDocument': instance.isOfficeDocument,
  'permissions': instance.permissions,
  'canOpenResourceChat': instance.canOpenResourceChat,
};

_StorageFilePlacementResponse _$StorageFilePlacementResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFilePlacementResponse(
  id: json['id'] as String,
  fileId: json['fileId'] as String,
  folderId: json['folderId'] as String,
  displayName: json['displayName'] as String?,
  resourceType: json['resourceType'] as String?,
  resourceId: json['resourceId'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  fileName: json['fileName'] as String?,
  mimeType: json['mimeType'] as String?,
  fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
  permissions: json['permissions'] == null
      ? null
      : StorageFilePermissionsResponse.fromJson(
          json['permissions'] as Map<String, dynamic>,
        ),
  version: (json['version'] as num?)?.toInt(),
);

Map<String, dynamic> _$StorageFilePlacementResponseToJson(
  _StorageFilePlacementResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileId': instance.fileId,
  'folderId': instance.folderId,
  'displayName': instance.displayName,
  'resourceType': instance.resourceType,
  'resourceId': instance.resourceId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'fileName': instance.fileName,
  'mimeType': instance.mimeType,
  'fileSizeBytes': instance.fileSizeBytes,
  'permissions': instance.permissions,
  'version': instance.version,
};

_MoveStorageFilePlacementPayload _$MoveStorageFilePlacementPayloadFromJson(
  Map<String, dynamic> json,
) => _MoveStorageFilePlacementPayload(
  targetFolderId: json['targetFolderId'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$MoveStorageFilePlacementPayloadToJson(
  _MoveStorageFilePlacementPayload instance,
) => <String, dynamic>{
  'targetFolderId': instance.targetFolderId,
  'expectedVersion': instance.expectedVersion,
};

_CreateStorageFilePlacementPayload _$CreateStorageFilePlacementPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateStorageFilePlacementPayload(
  folderId: json['folderId'] as String,
  displayName: json['displayName'] as String?,
  resourceType: json['resourceType'] as String?,
  resourceId: json['resourceId'] as String?,
);

Map<String, dynamic> _$CreateStorageFilePlacementPayloadToJson(
  _CreateStorageFilePlacementPayload instance,
) => <String, dynamic>{
  'folderId': instance.folderId,
  'displayName': instance.displayName,
  'resourceType': instance.resourceType,
  'resourceId': instance.resourceId,
};

_BulkCreateStorageFilePlacementPayload
_$BulkCreateStorageFilePlacementPayloadFromJson(Map<String, dynamic> json) =>
    _BulkCreateStorageFilePlacementPayload(
      fileIds: (json['fileIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      displayNamePrefix: json['displayNamePrefix'] as String?,
    );

Map<String, dynamic> _$BulkCreateStorageFilePlacementPayloadToJson(
  _BulkCreateStorageFilePlacementPayload instance,
) => <String, dynamic>{
  'fileIds': instance.fileIds,
  'displayNamePrefix': instance.displayNamePrefix,
};

_StorageFolderChildrenResponse _$StorageFolderChildrenResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFolderChildrenResponse(
  folder: StorageFolderResponse.fromJson(
    json['folder'] as Map<String, dynamic>,
  ),
  folders: (json['folders'] as List<dynamic>)
      .map((e) => StorageFolderResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  placements: (json['placements'] as List<dynamic>)
      .map(
        (e) => StorageFilePlacementResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$StorageFolderChildrenResponseToJson(
  _StorageFolderChildrenResponse instance,
) => <String, dynamic>{
  'folder': instance.folder,
  'folders': instance.folders,
  'placements': instance.placements,
};

_StorageFileUserStateResponse _$StorageFileUserStateResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileUserStateResponse(
  fileId: json['fileId'] as String,
  isFavorite: json['isFavorite'] as bool,
  favoritedAtUtc: json['favoritedAtUtc'] == null
      ? null
      : DateTime.parse(json['favoritedAtUtc'] as String),
  lastAccessedAtUtc: json['lastAccessedAtUtc'] == null
      ? null
      : DateTime.parse(json['lastAccessedAtUtc'] as String),
);

Map<String, dynamic> _$StorageFileUserStateResponseToJson(
  _StorageFileUserStateResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'isFavorite': instance.isFavorite,
  'favoritedAtUtc': instance.favoritedAtUtc?.toIso8601String(),
  'lastAccessedAtUtc': instance.lastAccessedAtUtc?.toIso8601String(),
};

_SetStorageFileFavoritePayload _$SetStorageFileFavoritePayloadFromJson(
  Map<String, dynamic> json,
) => _SetStorageFileFavoritePayload(isFavorite: json['isFavorite'] as bool);

Map<String, dynamic> _$SetStorageFileFavoritePayloadToJson(
  _SetStorageFileFavoritePayload instance,
) => <String, dynamic>{'isFavorite': instance.isFavorite};

_StorageFileDeepLinkResponse _$StorageFileDeepLinkResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileDeepLinkResponse(
  fileId: json['fileId'] as String,
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  filePath: json['filePath'] as String,
  conversationPath: json['conversationPath'] as String,
);

Map<String, dynamic> _$StorageFileDeepLinkResponseToJson(
  _StorageFileDeepLinkResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'filePath': instance.filePath,
  'conversationPath': instance.conversationPath,
};

_OnlyOfficeSessionResponse _$OnlyOfficeSessionResponseFromJson(
  Map<String, dynamic> json,
) => _OnlyOfficeSessionResponse(
  fileId: json['fileId'] as String,
  documentType: json['documentType'] as String,
  documentServerUrl: json['documentServerUrl'] as String,
  documentKey: json['documentKey'] as String,
  token: json['token'] as String,
  canEdit: json['canEdit'] as bool,
);

Map<String, dynamic> _$OnlyOfficeSessionResponseToJson(
  _OnlyOfficeSessionResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'documentType': instance.documentType,
  'documentServerUrl': instance.documentServerUrl,
  'documentKey': instance.documentKey,
  'token': instance.token,
  'canEdit': instance.canEdit,
};

_OnlyOfficeCallbackPayload _$OnlyOfficeCallbackPayloadFromJson(
  Map<String, dynamic> json,
) => _OnlyOfficeCallbackPayload(
  key: json['key'] as String?,
  status: (json['status'] as num).toInt(),
  url: json['url'] as String?,
  users: (json['users'] as List<dynamic>?)?.map((e) => e as String).toList(),
  actions: (json['actions'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  history: json['history'] as Map<String, dynamic>?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$OnlyOfficeCallbackPayloadToJson(
  _OnlyOfficeCallbackPayload instance,
) => <String, dynamic>{
  'key': instance.key,
  'status': instance.status,
  'url': instance.url,
  'users': instance.users,
  'actions': instance.actions,
  'history': instance.history,
  'token': instance.token,
};

_OnlyOfficeCallbackResponse _$OnlyOfficeCallbackResponseFromJson(
  Map<String, dynamic> json,
) => _OnlyOfficeCallbackResponse(error: (json['error'] as num).toInt());

Map<String, dynamic> _$OnlyOfficeCallbackResponseToJson(
  _OnlyOfficeCallbackResponse instance,
) => <String, dynamic>{'error': instance.error};

_BulkDownloadZipPayload _$BulkDownloadZipPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkDownloadZipPayload(
  fileIds: (json['fileIds'] as List<dynamic>).map((e) => e as String).toList(),
  zipFileName: json['zipFileName'] as String? ?? 'zalaczniki.zip',
);

Map<String, dynamic> _$BulkDownloadZipPayloadToJson(
  _BulkDownloadZipPayload instance,
) => <String, dynamic>{
  'fileIds': instance.fileIds,
  'zipFileName': instance.zipFileName,
};

_StorageSemanticSearchResponse _$StorageSemanticSearchResponseFromJson(
  Map<String, dynamic> json,
) => _StorageSemanticSearchResponse(
  status: json['status'] as String,
  code: json['code'] as String?,
  rankingVersion: json['rankingVersion'] as String,
  hits: (json['hits'] as List<dynamic>)
      .map(
        (e) => StorageSemanticSearchHitResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$StorageSemanticSearchResponseToJson(
  _StorageSemanticSearchResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'code': instance.code,
  'rankingVersion': instance.rankingVersion,
  'hits': instance.hits,
};

_StorageSemanticSearchHitResponse _$StorageSemanticSearchHitResponseFromJson(
  Map<String, dynamic> json,
) => _StorageSemanticSearchHitResponse(
  fileId: json['fileId'] as String,
  fileVersion: (json['fileVersion'] as num).toInt(),
  chunkIndex: (json['chunkIndex'] as num).toInt(),
  text: json['text'] as String,
  distance: (json['distance'] as num).toDouble(),
  score: (json['score'] as num).toDouble(),
  fullTextMatch: json['fullTextMatch'] as bool,
);

Map<String, dynamic> _$StorageSemanticSearchHitResponseToJson(
  _StorageSemanticSearchHitResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'fileVersion': instance.fileVersion,
  'chunkIndex': instance.chunkIndex,
  'text': instance.text,
  'distance': instance.distance,
  'score': instance.score,
  'fullTextMatch': instance.fullTextMatch,
};

_StorageAiReportTypeResponse _$StorageAiReportTypeResponseFromJson(
  Map<String, dynamic> json,
) => _StorageAiReportTypeResponse(
  reportType: json['reportType'] as String,
  promptVersion: json['promptVersion'] as String,
  schemaVersion: (json['schemaVersion'] as num).toInt(),
  description: json['description'] as String,
  contractVersion: json['contractVersion'] as String? ?? 'ai.v1',
  requiredSectionKeys: (json['requiredSectionKeys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  scopeType:
      $enumDecodeNullable(
        _$StorageAiReportScopeTypeEnumMap,
        json['scopeType'],
      ) ??
      StorageAiReportScopeType.project,
);

Map<String, dynamic> _$StorageAiReportTypeResponseToJson(
  _StorageAiReportTypeResponse instance,
) => <String, dynamic>{
  'reportType': instance.reportType,
  'promptVersion': instance.promptVersion,
  'schemaVersion': instance.schemaVersion,
  'description': instance.description,
  'contractVersion': instance.contractVersion,
  'requiredSectionKeys': instance.requiredSectionKeys,
  'scopeType': _$StorageAiReportScopeTypeEnumMap[instance.scopeType]!,
};

const _$StorageAiReportScopeTypeEnumMap = {
  StorageAiReportScopeType.project: 'Project',
};

_CreateStorageAiReportPayload _$CreateStorageAiReportPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateStorageAiReportPayload(
  reportType: json['reportType'] as String? ?? 'project.summary',
  contractVersion: json['contractVersion'] as String? ?? 'ai.v1',
  promptVersion: json['promptVersion'] as String?,
);

Map<String, dynamic> _$CreateStorageAiReportPayloadToJson(
  _CreateStorageAiReportPayload instance,
) => <String, dynamic>{
  'reportType': instance.reportType,
  'contractVersion': instance.contractVersion,
  'promptVersion': instance.promptVersion,
};

_StorageAiReportSourceResponse _$StorageAiReportSourceResponseFromJson(
  Map<String, dynamic> json,
) => _StorageAiReportSourceResponse(
  fileId: json['fileId'] as String,
  fileVersion: (json['fileVersion'] as num).toInt(),
  fileName: json['fileName'] as String,
  contentSha256: json['contentSha256'] as String?,
);

Map<String, dynamic> _$StorageAiReportSourceResponseToJson(
  _StorageAiReportSourceResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'fileVersion': instance.fileVersion,
  'fileName': instance.fileName,
  'contentSha256': instance.contentSha256,
};

_StorageAiReportDocumentSectionResponse
_$StorageAiReportDocumentSectionResponseFromJson(Map<String, dynamic> json) =>
    _StorageAiReportDocumentSectionResponse(
      key: json['key'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$StorageAiReportDocumentSectionResponseToJson(
  _StorageAiReportDocumentSectionResponse instance,
) => <String, dynamic>{
  'key': instance.key,
  'title': instance.title,
  'content': instance.content,
  'order': instance.order,
};

_StorageAiReportDocumentSourceResponse
_$StorageAiReportDocumentSourceResponseFromJson(Map<String, dynamic> json) =>
    _StorageAiReportDocumentSourceResponse(
      sourceType: json['sourceType'] as String,
      sourceId: json['sourceId'] as String,
      version: (json['version'] as num?)?.toInt(),
      contentSha256: json['contentSha256'] as String?,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$StorageAiReportDocumentSourceResponseToJson(
  _StorageAiReportDocumentSourceResponse instance,
) => <String, dynamic>{
  'sourceType': instance.sourceType,
  'sourceId': instance.sourceId,
  'version': instance.version,
  'contentSha256': instance.contentSha256,
  'displayName': instance.displayName,
};

_StorageAiReportDocumentWarningResponse
_$StorageAiReportDocumentWarningResponseFromJson(Map<String, dynamic> json) =>
    _StorageAiReportDocumentWarningResponse(
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$StorageAiReportDocumentWarningResponseToJson(
  _StorageAiReportDocumentWarningResponse instance,
) => <String, dynamic>{'code': instance.code, 'message': instance.message};

_StorageAiReportDocumentResponse _$StorageAiReportDocumentResponseFromJson(
  Map<String, dynamic> json,
) => _StorageAiReportDocumentResponse(
  reportType: json['reportType'] as String,
  contractVersion: json['contractVersion'] as String,
  operationId: json['operationId'] as String,
  promptVersion: json['promptVersion'] as String,
  schemaVersion: (json['schemaVersion'] as num).toInt(),
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
  sections: (json['sections'] as List<dynamic>)
      .map(
        (e) => StorageAiReportDocumentSectionResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  sources: (json['sources'] as List<dynamic>)
      .map(
        (e) => StorageAiReportDocumentSourceResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  warnings: (json['warnings'] as List<dynamic>)
      .map(
        (e) => StorageAiReportDocumentWarningResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  provider: $enumDecode(_$AiProviderKindEnumMap, json['provider']),
  model: json['model'] as String?,
  structuredData: json['structuredData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$StorageAiReportDocumentResponseToJson(
  _StorageAiReportDocumentResponse instance,
) => <String, dynamic>{
  'reportType': instance.reportType,
  'contractVersion': instance.contractVersion,
  'operationId': instance.operationId,
  'promptVersion': instance.promptVersion,
  'schemaVersion': instance.schemaVersion,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
  'sections': instance.sections,
  'sources': instance.sources,
  'warnings': instance.warnings,
  'provider': _$AiProviderKindEnumMap[instance.provider]!,
  'model': instance.model,
  'structuredData': instance.structuredData,
};

const _$AiProviderKindEnumMap = {
  AiProviderKind.disabled: 'Disabled',
  AiProviderKind.aifastApi: 'AifastApi',
  AiProviderKind.openAi: 'OpenAi',
  AiProviderKind.azureOpenAi: 'AzureOpenAi',
  AiProviderKind.anthropic: 'Anthropic',
  AiProviderKind.ollama: 'Ollama',
  AiProviderKind.custom: 'Custom',
};

_StorageAiReportResponse _$StorageAiReportResponseFromJson(
  Map<String, dynamic> json,
) => _StorageAiReportResponse(
  reportId: json['reportId'] as String,
  scopeType: $enumDecode(_$StorageAiReportScopeTypeEnumMap, json['scopeType']),
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  reportType: json['reportType'] as String,
  contractVersion: json['contractVersion'] as String,
  promptVersion: json['promptVersion'] as String,
  status: $enumDecode(_$StorageAiReportJobStatusEnumMap, json['status']),
  attemptCount: (json['attemptCount'] as num).toInt(),
  maxAttempts: (json['maxAttempts'] as num).toInt(),
  retryable: json['retryable'] as bool,
  provider: $enumDecodeNullable(_$AiProviderKindEnumMap, json['provider']),
  outputFileId: json['outputFileId'] as String?,
  resultDocumentJson: json['resultDocumentJson'] as String?,
  resultDocument: json['resultDocument'] == null
      ? null
      : StorageAiReportDocumentResponse.fromJson(
          json['resultDocument'] as Map<String, dynamic>,
        ),
  sources: (json['sources'] as List<dynamic>)
      .map(
        (e) =>
            StorageAiReportSourceResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  deadlineAtUtc: DateTime.parse(json['deadlineAtUtc'] as String),
  nextAttemptAtUtc: json['nextAttemptAtUtc'] == null
      ? null
      : DateTime.parse(json['nextAttemptAtUtc'] as String),
  completedAtUtc: json['completedAtUtc'] == null
      ? null
      : DateTime.parse(json['completedAtUtc'] as String),
  lastError: json['lastError'] as String?,
  failureCode: $enumDecodeNullable(
    _$StorageAiReportFailureCodeEnumMap,
    json['failureCode'],
  ),
  operationId: json['operationId'] as String?,
  jobId: json['jobId'] as String?,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt(),
  scopeId: json['scopeId'] as String?,
  operationStatus: json['operationStatus'] as String?,
  operationLifecycleStatus: $enumDecodeNullable(
    _$AiOperationStatusEnumMap,
    json['operationLifecycleStatus'],
  ),
  error: json['error'] == null
      ? null
      : StorageAiReportErrorResponse.fromJson(
          json['error'] as Map<String, dynamic>,
        ),
  retryAfterSeconds: (json['retryAfterSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$StorageAiReportResponseToJson(
  _StorageAiReportResponse instance,
) => <String, dynamic>{
  'reportId': instance.reportId,
  'scopeType': _$StorageAiReportScopeTypeEnumMap[instance.scopeType]!,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'reportType': instance.reportType,
  'contractVersion': instance.contractVersion,
  'promptVersion': instance.promptVersion,
  'status': _$StorageAiReportJobStatusEnumMap[instance.status]!,
  'attemptCount': instance.attemptCount,
  'maxAttempts': instance.maxAttempts,
  'retryable': instance.retryable,
  'provider': _$AiProviderKindEnumMap[instance.provider],
  'outputFileId': instance.outputFileId,
  'resultDocumentJson': instance.resultDocumentJson,
  'resultDocument': instance.resultDocument,
  'sources': instance.sources,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'deadlineAtUtc': instance.deadlineAtUtc.toIso8601String(),
  'nextAttemptAtUtc': instance.nextAttemptAtUtc?.toIso8601String(),
  'completedAtUtc': instance.completedAtUtc?.toIso8601String(),
  'lastError': instance.lastError,
  'failureCode': _$StorageAiReportFailureCodeEnumMap[instance.failureCode],
  'operationId': instance.operationId,
  'jobId': instance.jobId,
  'schemaVersion': instance.schemaVersion,
  'scopeId': instance.scopeId,
  'operationStatus': instance.operationStatus,
  'operationLifecycleStatus':
      _$AiOperationStatusEnumMap[instance.operationLifecycleStatus],
  'error': instance.error,
  'retryAfterSeconds': instance.retryAfterSeconds,
};

const _$StorageAiReportJobStatusEnumMap = {
  StorageAiReportJobStatus.pending: 'Pending',
  StorageAiReportJobStatus.processing: 'Processing',
  StorageAiReportJobStatus.completed: 'Completed',
  StorageAiReportJobStatus.failed: 'Failed',
};

const _$StorageAiReportFailureCodeEnumMap = {
  StorageAiReportFailureCode.unknown: 'Unknown',
  StorageAiReportFailureCode.sourceAccessRevoked: 'SourceAccessRevoked',
  StorageAiReportFailureCode.sourceSnapshotEmpty: 'SourceSnapshotEmpty',
  StorageAiReportFailureCode.unsupportedProvider: 'UnsupportedProvider',
  StorageAiReportFailureCode.invalidProviderResponse: 'InvalidProviderResponse',
  StorageAiReportFailureCode.providerUnauthorized: 'ProviderUnauthorized',
  StorageAiReportFailureCode.providerRateLimited: 'ProviderRateLimited',
  StorageAiReportFailureCode.providerUnavailable: 'ProviderUnavailable',
  StorageAiReportFailureCode.circuitOpen: 'CircuitOpen',
  StorageAiReportFailureCode.disabled: 'Disabled',
  StorageAiReportFailureCode.outputStorageFailed: 'OutputStorageFailed',
  StorageAiReportFailureCode.sourceContentMismatch: 'SourceContentMismatch',
  StorageAiReportFailureCode.deadlineExceeded: 'DeadlineExceeded',
  StorageAiReportFailureCode.sourceChanged: 'SourceChanged',
};

const _$AiOperationStatusEnumMap = {
  AiOperationStatus.queued: 'Queued',
  AiOperationStatus.processing: 'Processing',
  AiOperationStatus.completed: 'Completed',
  AiOperationStatus.degraded: 'Degraded',
  AiOperationStatus.failedRetryable: 'FailedRetryable',
  AiOperationStatus.failedTerminal: 'FailedTerminal',
  AiOperationStatus.cancelled: 'Cancelled',
};

_StorageAiReportErrorResponse _$StorageAiReportErrorResponseFromJson(
  Map<String, dynamic> json,
) => _StorageAiReportErrorResponse(
  code: json['code'] as String,
  message: json['message'] as String,
  retryable: json['retryable'] as bool,
  retryAfterSeconds: (json['retryAfterSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$StorageAiReportErrorResponseToJson(
  _StorageAiReportErrorResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'retryable': instance.retryable,
  'retryAfterSeconds': instance.retryAfterSeconds,
};
