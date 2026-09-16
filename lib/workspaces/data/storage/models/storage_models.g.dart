// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateStorageDocumentPayload _$CreateStorageDocumentPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateStorageDocumentPayload(
  name: json['name'] as String,
  format: $enumDecode(_$StorageDocumentFormatEnumMap, json['format']),
  module: $enumDecode(_$StorageModuleEnumMap, json['module']),
  resourceType: $enumDecode(_$StorageResourceTypeEnumMap, json['resourceType']),
  projectId: json['projectId'] as String?,
  workspaceId: json['workspaceId'] as String?,
  folderId: json['folderId'] as String?,
);

Map<String, dynamic> _$CreateStorageDocumentPayloadToJson(
  _CreateStorageDocumentPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'format': _$StorageDocumentFormatEnumMap[instance.format]!,
  'module': _$StorageModuleEnumMap[instance.module]!,
  'resourceType': _$StorageResourceTypeEnumMap[instance.resourceType]!,
  'projectId': instance.projectId,
  'workspaceId': instance.workspaceId,
  'folderId': instance.folderId,
};

const _$StorageDocumentFormatEnumMap = {
  StorageDocumentFormat.txt: 'Txt',
  StorageDocumentFormat.odt: 'Odt',
  StorageDocumentFormat.ods: 'Ods',
  StorageDocumentFormat.odp: 'Odp',
  StorageDocumentFormat.docx: 'Docx',
  StorageDocumentFormat.xlsx: 'Xlsx',
  StorageDocumentFormat.pptx: 'Pptx',
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

_StorageUploadTicketPayload _$StorageUploadTicketPayloadFromJson(
  Map<String, dynamic> json,
) => _StorageUploadTicketPayload(
  module: $enumDecode(_$StorageModuleEnumMap, json['module']),
  resourceType: $enumDecode(_$StorageResourceTypeEnumMap, json['resourceType']),
  resourceId: json['resourceId'] as String?,
  fileName: json['fileName'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  mimeType: json['mimeType'] as String?,
  contentSha256: json['contentSha256'] as String?,
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
);

Map<String, dynamic> _$StorageUploadTicketPayloadToJson(
  _StorageUploadTicketPayload instance,
) => <String, dynamic>{
  'module': _$StorageModuleEnumMap[instance.module]!,
  'resourceType': _$StorageResourceTypeEnumMap[instance.resourceType]!,
  'resourceId': instance.resourceId,
  'fileName': instance.fileName,
  'fileSizeBytes': instance.fileSizeBytes,
  'mimeType': instance.mimeType,
  'contentSha256': instance.contentSha256,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
};

_CompleteStorageUploadPayload _$CompleteStorageUploadPayloadFromJson(
  Map<String, dynamic> json,
) => _CompleteStorageUploadPayload(
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  contentSha256: json['contentSha256'] as String?,
  changeSummary: json['changeSummary'] as String?,
);

Map<String, dynamic> _$CompleteStorageUploadPayloadToJson(
  _CompleteStorageUploadPayload instance,
) => <String, dynamic>{
  'fileSizeBytes': instance.fileSizeBytes,
  'contentSha256': instance.contentSha256,
  'changeSummary': instance.changeSummary,
};

_StorageDownloadTicketResponse _$StorageDownloadTicketResponseFromJson(
  Map<String, dynamic> json,
) => _StorageDownloadTicketResponse(
  fileId: json['fileId'] as String,
  originalFileName: json['originalFileName'] as String,
  mimeType: json['mimeType'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  downloadUrl: json['downloadUrl'] as String,
  expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
  previewUrl: json['previewUrl'] as String?,
);

Map<String, dynamic> _$StorageDownloadTicketResponseToJson(
  _StorageDownloadTicketResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'originalFileName': instance.originalFileName,
  'mimeType': instance.mimeType,
  'fileSizeBytes': instance.fileSizeBytes,
  'downloadUrl': instance.downloadUrl,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
  'previewUrl': instance.previewUrl,
};

_CreateStorageFileSharePayload _$CreateStorageFileSharePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateStorageFileSharePayload(
  shareType: $enumDecode(_$StorageShareTypeEnumMap, json['shareType']),
  accessLevel: $enumDecode(
    _$StorageShareAccessLevelEnumMap,
    json['accessLevel'],
  ),
  sharedWithUserId: json['sharedWithUserId'] as String?,
  sharedWithWorkspaceId: json['sharedWithWorkspaceId'] as String?,
  sharedWithProjectId: json['sharedWithProjectId'] as String?,
  password: json['password'] as String?,
  expiresAtUtc: json['expiresAtUtc'] == null
      ? null
      : DateTime.parse(json['expiresAtUtc'] as String),
);

Map<String, dynamic> _$CreateStorageFileSharePayloadToJson(
  _CreateStorageFileSharePayload instance,
) => <String, dynamic>{
  'shareType': _$StorageShareTypeEnumMap[instance.shareType]!,
  'accessLevel': _$StorageShareAccessLevelEnumMap[instance.accessLevel]!,
  'sharedWithUserId': instance.sharedWithUserId,
  'sharedWithWorkspaceId': instance.sharedWithWorkspaceId,
  'sharedWithProjectId': instance.sharedWithProjectId,
  'password': instance.password,
  'expiresAtUtc': instance.expiresAtUtc?.toIso8601String(),
};

const _$StorageShareTypeEnumMap = {
  StorageShareType.user: 'User',
  StorageShareType.publicLink: 'PublicLink',
  StorageShareType.workspace: 'Workspace',
  StorageShareType.project: 'Project',
};

const _$StorageShareAccessLevelEnumMap = {
  StorageShareAccessLevel.read: 'Read',
  StorageShareAccessLevel.write: 'Write',
  StorageShareAccessLevel.owner: 'Owner',
  StorageShareAccessLevel.editor: 'Editor',
  StorageShareAccessLevel.commenter: 'Commenter',
  StorageShareAccessLevel.reader: 'Reader',
};

_StorageFileShareResponse _$StorageFileShareResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileShareResponse(
  id: json['id'] as String,
  fileId: json['fileId'] as String,
  shareType: $enumDecode(_$StorageShareTypeEnumMap, json['shareType']),
  accessLevel: $enumDecode(
    _$StorageShareAccessLevelEnumMap,
    json['accessLevel'],
  ),
  sharedWithUserId: json['sharedWithUserId'] as String?,
  sharedWithWorkspaceId: json['sharedWithWorkspaceId'] as String?,
  sharedWithProjectId: json['sharedWithProjectId'] as String?,
  shareToken: json['shareToken'] as String?,
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

Map<String, dynamic> _$StorageFileShareResponseToJson(
  _StorageFileShareResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileId': instance.fileId,
  'shareType': _$StorageShareTypeEnumMap[instance.shareType]!,
  'accessLevel': _$StorageShareAccessLevelEnumMap[instance.accessLevel]!,
  'sharedWithUserId': instance.sharedWithUserId,
  'sharedWithWorkspaceId': instance.sharedWithWorkspaceId,
  'sharedWithProjectId': instance.sharedWithProjectId,
  'shareToken': instance.shareToken,
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

_CreateStorageFolderPayload _$CreateStorageFolderPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateStorageFolderPayload(
  folderType: $enumDecode(_$StorageFolderTypeEnumMap, json['folderType']),
  name: json['name'] as String,
  parentFolderId: json['parentFolderId'] as String?,
  ownerUserId: json['ownerUserId'] as String?,
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
);

Map<String, dynamic> _$CreateStorageFolderPayloadToJson(
  _CreateStorageFolderPayload instance,
) => <String, dynamic>{
  'folderType': _$StorageFolderTypeEnumMap[instance.folderType]!,
  'name': instance.name,
  'parentFolderId': instance.parentFolderId,
  'ownerUserId': instance.ownerUserId,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
};

const _$StorageFolderTypeEnumMap = {
  StorageFolderType.personal: 'Personal',
  StorageFolderType.workspace: 'Workspace',
  StorageFolderType.project: 'Project',
  StorageFolderType.shared: 'Shared',
};

_StorageFolderResponse _$StorageFolderResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFolderResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  folderType: $enumDecode(_$StorageFolderTypeEnumMap, json['folderType']),
  parentFolderId: json['parentFolderId'] as String?,
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  canRead: json['canRead'] as bool,
  canComment: json['canComment'] as bool,
  canEdit: json['canEdit'] as bool,
  canShare: json['canShare'] as bool,
  canDelete: json['canDelete'] as bool,
  itemCount: (json['itemCount'] as num).toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  accessLevel: $enumDecode(
    _$StorageEffectiveAccessLevelEnumMap,
    json['accessLevel'],
  ),
);

Map<String, dynamic> _$StorageFolderResponseToJson(
  _StorageFolderResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'folderType': _$StorageFolderTypeEnumMap[instance.folderType]!,
  'parentFolderId': instance.parentFolderId,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'canRead': instance.canRead,
  'canComment': instance.canComment,
  'canEdit': instance.canEdit,
  'canShare': instance.canShare,
  'canDelete': instance.canDelete,
  'itemCount': instance.itemCount,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'accessLevel': _$StorageEffectiveAccessLevelEnumMap[instance.accessLevel]!,
};
