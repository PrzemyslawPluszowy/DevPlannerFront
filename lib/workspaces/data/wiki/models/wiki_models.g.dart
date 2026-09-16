// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wiki_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateWikiPagePayload _$CreateWikiPagePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWikiPagePayload(
  parentPageId: json['parentPageId'] as String?,
  title: json['title'] as String,
  iconEmoji: json['iconEmoji'] as String?,
  coverImageFileId: json['coverImageFileId'] as String?,
  contentJson: json['contentJson'] as String,
  position: (json['position'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateWikiPagePayloadToJson(
  _CreateWikiPagePayload instance,
) => <String, dynamic>{
  'parentPageId': instance.parentPageId,
  'title': instance.title,
  'iconEmoji': instance.iconEmoji,
  'coverImageFileId': instance.coverImageFileId,
  'contentJson': instance.contentJson,
  'position': instance.position,
};

_UpdateWikiPagePayload _$UpdateWikiPagePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWikiPagePayload(
  title: json['title'] as String?,
  iconEmoji: json['iconEmoji'] as String?,
  coverImageFileId: json['coverImageFileId'] as String?,
  contentJson: json['contentJson'] as String?,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  clearIconEmoji: json['clearIconEmoji'] as bool? ?? false,
  clearCoverImage: json['clearCoverImage'] as bool? ?? false,
);

Map<String, dynamic> _$UpdateWikiPagePayloadToJson(
  _UpdateWikiPagePayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'iconEmoji': instance.iconEmoji,
  'coverImageFileId': instance.coverImageFileId,
  'contentJson': instance.contentJson,
  'expectedVersion': instance.expectedVersion,
  'clearIconEmoji': instance.clearIconEmoji,
  'clearCoverImage': instance.clearCoverImage,
};

_MoveWikiPagePayload _$MoveWikiPagePayloadFromJson(Map<String, dynamic> json) =>
    _MoveWikiPagePayload(
      parentPageId: json['parentPageId'] as String?,
      position: (json['position'] as num).toInt(),
      expectedVersion: (json['expectedVersion'] as num).toInt(),
    );

Map<String, dynamic> _$MoveWikiPagePayloadToJson(
  _MoveWikiPagePayload instance,
) => <String, dynamic>{
  'parentPageId': instance.parentPageId,
  'position': instance.position,
  'expectedVersion': instance.expectedVersion,
};

_RestoreWikiPagePayload _$RestoreWikiPagePayloadFromJson(
  Map<String, dynamic> json,
) => _RestoreWikiPagePayload(
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$RestoreWikiPagePayloadToJson(
  _RestoreWikiPagePayload instance,
) => <String, dynamic>{'expectedVersion': instance.expectedVersion};

_WikiPageTreeNodeResponse _$WikiPageTreeNodeResponseFromJson(
  Map<String, dynamic> json,
) => _WikiPageTreeNodeResponse(
  id: json['id'] as String,
  parentPageId: json['parentPageId'] as String?,
  title: json['title'] as String,
  iconEmoji: json['iconEmoji'] as String?,
  position: (json['position'] as num).toInt(),
  isVerified: json['isVerified'] as bool,
  children: (json['children'] as List<dynamic>)
      .map((e) => WikiPageTreeNodeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WikiPageTreeNodeResponseToJson(
  _WikiPageTreeNodeResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentPageId': instance.parentPageId,
  'title': instance.title,
  'iconEmoji': instance.iconEmoji,
  'position': instance.position,
  'isVerified': instance.isVerified,
  'children': instance.children,
};

_WikiPageResponse _$WikiPageResponseFromJson(Map<String, dynamic> json) =>
    _WikiPageResponse(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      projectId: json['projectId'] as String?,
      parentPageId: json['parentPageId'] as String?,
      createdByUserId: json['createdByUserId'] as String,
      title: json['title'] as String,
      iconEmoji: json['iconEmoji'] as String?,
      coverImageFileId: json['coverImageFileId'] as String?,
      contentJson: json['contentJson'] as String,
      position: (json['position'] as num).toInt(),
      isVerified: json['isVerified'] as bool,
      verifiedByUserId: json['verifiedByUserId'] as String?,
      verifiedAtUtc: json['verifiedAtUtc'] == null
          ? null
          : DateTime.parse(json['verifiedAtUtc'] as String),
      version: (json['version'] as num).toInt(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );

Map<String, dynamic> _$WikiPageResponseToJson(_WikiPageResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'projectId': instance.projectId,
      'parentPageId': instance.parentPageId,
      'createdByUserId': instance.createdByUserId,
      'title': instance.title,
      'iconEmoji': instance.iconEmoji,
      'coverImageFileId': instance.coverImageFileId,
      'contentJson': instance.contentJson,
      'position': instance.position,
      'isVerified': instance.isVerified,
      'verifiedByUserId': instance.verifiedByUserId,
      'verifiedAtUtc': instance.verifiedAtUtc?.toIso8601String(),
      'version': instance.version,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
    };

_WikiPageRevisionSummaryResponse _$WikiPageRevisionSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _WikiPageRevisionSummaryResponse(
  id: json['id'] as String,
  pageId: json['pageId'] as String,
  version: (json['version'] as num).toInt(),
  createdByUserId: json['createdByUserId'] as String,
  title: json['title'] as String,
  snapshotSha256: json['snapshotSha256'] as String,
  changeSummary: json['changeSummary'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$WikiPageRevisionSummaryResponseToJson(
  _WikiPageRevisionSummaryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'pageId': instance.pageId,
  'version': instance.version,
  'createdByUserId': instance.createdByUserId,
  'title': instance.title,
  'snapshotSha256': instance.snapshotSha256,
  'changeSummary': instance.changeSummary,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_WikiPageRevisionResponse _$WikiPageRevisionResponseFromJson(
  Map<String, dynamic> json,
) => _WikiPageRevisionResponse(
  id: json['id'] as String,
  pageId: json['pageId'] as String,
  version: (json['version'] as num).toInt(),
  createdByUserId: json['createdByUserId'] as String,
  title: json['title'] as String,
  snapshotJson: json['snapshotJson'] as String,
  snapshotSha256: json['snapshotSha256'] as String,
  changeSummary: json['changeSummary'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$WikiPageRevisionResponseToJson(
  _WikiPageRevisionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'pageId': instance.pageId,
  'version': instance.version,
  'createdByUserId': instance.createdByUserId,
  'title': instance.title,
  'snapshotJson': instance.snapshotJson,
  'snapshotSha256': instance.snapshotSha256,
  'changeSummary': instance.changeSummary,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_WikiRevisionDiffChangeResponse _$WikiRevisionDiffChangeResponseFromJson(
  Map<String, dynamic> json,
) => _WikiRevisionDiffChangeResponse(
  path: json['path'] as String,
  changeType: json['changeType'] as String,
  fromJson: json['fromJson'] as String?,
  toJsonValue: json['toJson'] as String?,
);

Map<String, dynamic> _$WikiRevisionDiffChangeResponseToJson(
  _WikiRevisionDiffChangeResponse instance,
) => <String, dynamic>{
  'path': instance.path,
  'changeType': instance.changeType,
  'fromJson': instance.fromJson,
  'toJson': instance.toJsonValue,
};

_WikiPageRevisionDiffResponse _$WikiPageRevisionDiffResponseFromJson(
  Map<String, dynamic> json,
) => _WikiPageRevisionDiffResponse(
  pageId: json['pageId'] as String,
  fromRevisionId: json['fromRevisionId'] as String,
  fromVersion: (json['fromVersion'] as num).toInt(),
  fromTitle: json['fromTitle'] as String,
  fromCreatedAtUtc: DateTime.parse(json['fromCreatedAtUtc'] as String),
  toRevisionId: json['toRevisionId'] as String,
  toVersion: (json['toVersion'] as num).toInt(),
  toTitle: json['toTitle'] as String,
  toCreatedAtUtc: DateTime.parse(json['toCreatedAtUtc'] as String),
  titleChanged: json['titleChanged'] as bool,
  contentChanges: (json['contentChanges'] as List<dynamic>)
      .map(
        (e) =>
            WikiRevisionDiffChangeResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  isIdentical: json['isIdentical'] as bool,
);

Map<String, dynamic> _$WikiPageRevisionDiffResponseToJson(
  _WikiPageRevisionDiffResponse instance,
) => <String, dynamic>{
  'pageId': instance.pageId,
  'fromRevisionId': instance.fromRevisionId,
  'fromVersion': instance.fromVersion,
  'fromTitle': instance.fromTitle,
  'fromCreatedAtUtc': instance.fromCreatedAtUtc.toIso8601String(),
  'toRevisionId': instance.toRevisionId,
  'toVersion': instance.toVersion,
  'toTitle': instance.toTitle,
  'toCreatedAtUtc': instance.toCreatedAtUtc.toIso8601String(),
  'titleChanged': instance.titleChanged,
  'contentChanges': instance.contentChanges,
  'isIdentical': instance.isIdentical,
};

_ConvertWikiSelectionToTaskPayload _$ConvertWikiSelectionToTaskPayloadFromJson(
  Map<String, dynamic> json,
) => _ConvertWikiSelectionToTaskPayload(
  selectionText: json['selectionText'] as String,
  blockId: json['blockId'] as String?,
  textStart: (json['textStart'] as num?)?.toInt(),
  textEnd: (json['textEnd'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'] as String?,
  priority:
      $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
      TaskPriority.normal,
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  checklistItems: (json['checklistItems'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ConvertWikiSelectionToTaskPayloadToJson(
  _ConvertWikiSelectionToTaskPayload instance,
) => <String, dynamic>{
  'selectionText': instance.selectionText,
  'blockId': instance.blockId,
  'textStart': instance.textStart,
  'textEnd': instance.textEnd,
  'title': instance.title,
  'description': instance.description,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'checklistItems': instance.checklistItems,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'Low',
  TaskPriority.normal: 'Normal',
  TaskPriority.high: 'High',
  TaskPriority.critical: 'Critical',
};

_WikiProjectTaskReferenceResponse _$WikiProjectTaskReferenceResponseFromJson(
  Map<String, dynamic> json,
) => _WikiProjectTaskReferenceResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  title: json['title'] as String,
  status: json['status'] as String,
  archivedAtUtc: json['archivedAtUtc'] == null
      ? null
      : DateTime.parse(json['archivedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$WikiProjectTaskReferenceResponseToJson(
  _WikiProjectTaskReferenceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'title': instance.title,
  'status': instance.status,
  'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
  'version': instance.version,
};

_WikiPageTaskLinkResponse _$WikiPageTaskLinkResponseFromJson(
  Map<String, dynamic> json,
) => _WikiPageTaskLinkResponse(
  id: json['id'] as String,
  pageId: json['pageId'] as String,
  taskId: json['taskId'] as String,
  selectionText: json['selectionText'] as String,
  blockId: json['blockId'] as String?,
  textStart: (json['textStart'] as num?)?.toInt(),
  textEnd: (json['textEnd'] as num?)?.toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  task: WikiProjectTaskReferenceResponse.fromJson(
    json['task'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WikiPageTaskLinkResponseToJson(
  _WikiPageTaskLinkResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'pageId': instance.pageId,
  'taskId': instance.taskId,
  'selectionText': instance.selectionText,
  'blockId': instance.blockId,
  'textStart': instance.textStart,
  'textEnd': instance.textEnd,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'task': instance.task,
};

_WikiSummarizeResponse _$WikiSummarizeResponseFromJson(
  Map<String, dynamic> json,
) => _WikiSummarizeResponse(
  summary: json['summary'] as String,
  keyPoints: (json['keyPoints'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  provider: json['provider'] as String,
  model: json['model'] as String?,
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
);

Map<String, dynamic> _$WikiSummarizeResponseToJson(
  _WikiSummarizeResponse instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'keyPoints': instance.keyPoints,
  'provider': instance.provider,
  'model': instance.model,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
};

_WikiActionItemResponse _$WikiActionItemResponseFromJson(
  Map<String, dynamic> json,
) => _WikiActionItemResponse(
  title: json['title'] as String,
  description: json['description'] as String?,
  dueHint: json['dueHint'] as String?,
);

Map<String, dynamic> _$WikiActionItemResponseToJson(
  _WikiActionItemResponse instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'dueHint': instance.dueHint,
};

_WikiActionItemsResponse _$WikiActionItemsResponseFromJson(
  Map<String, dynamic> json,
) => _WikiActionItemsResponse(
  actionItems: (json['actionItems'] as List<dynamic>)
      .map((e) => WikiActionItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  provider: json['provider'] as String,
  model: json['model'] as String?,
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
);

Map<String, dynamic> _$WikiActionItemsResponseToJson(
  _WikiActionItemsResponse instance,
) => <String, dynamic>{
  'actionItems': instance.actionItems,
  'provider': instance.provider,
  'model': instance.model,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
};

_ConvertWikiSelectionToTaskResponse
_$ConvertWikiSelectionToTaskResponseFromJson(Map<String, dynamic> json) =>
    _ConvertWikiSelectionToTaskResponse(
      task: ProjectTaskResponse.fromJson(json['task'] as Map<String, dynamic>),
      backlink: WikiPageTaskLinkResponse.fromJson(
        json['backlink'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ConvertWikiSelectionToTaskResponseToJson(
  _ConvertWikiSelectionToTaskResponse instance,
) => <String, dynamic>{'task': instance.task, 'backlink': instance.backlink};
