// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corkboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateCorkboardSectionPayload _$CreateCorkboardSectionPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateCorkboardSectionPayload(
  name: json['name'] as String,
  position: (json['position'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CreateCorkboardSectionPayloadToJson(
  _CreateCorkboardSectionPayload instance,
) => <String, dynamic>{'name': instance.name, 'position': instance.position};

_CreateCorkboardCardPayload _$CreateCorkboardCardPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateCorkboardCardPayload(
  content: json['content'] as String,
  color: $enumDecode(_$CorkboardCardColorEnumMap, json['color']),
  position: (json['position'] as num?)?.toInt() ?? 0,
  sectionId: json['sectionId'] as String?,
);

Map<String, dynamic> _$CreateCorkboardCardPayloadToJson(
  _CreateCorkboardCardPayload instance,
) => <String, dynamic>{
  'content': instance.content,
  'color': _$CorkboardCardColorEnumMap[instance.color]!,
  'position': instance.position,
  'sectionId': instance.sectionId,
};

const _$CorkboardCardColorEnumMap = {
  CorkboardCardColor.yellow: 'yellow',
  CorkboardCardColor.blue: 'blue',
  CorkboardCardColor.green: 'green',
  CorkboardCardColor.pink: 'pink',
  CorkboardCardColor.orange: 'orange',
  CorkboardCardColor.purple: 'purple',
  CorkboardCardColor.slate: 'slate',
};

_AttachCorkboardFilePayload _$AttachCorkboardFilePayloadFromJson(
  Map<String, dynamic> json,
) =>
    _AttachCorkboardFilePayload(storageFileId: json['storageFileId'] as String);

Map<String, dynamic> _$AttachCorkboardFilePayloadToJson(
  _AttachCorkboardFilePayload instance,
) => <String, dynamic>{'storageFileId': instance.storageFileId};

_CorkboardSectionResponse _$CorkboardSectionResponseFromJson(
  Map<String, dynamic> json,
) => _CorkboardSectionResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  position: (json['position'] as num).toInt(),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$CorkboardSectionResponseToJson(
  _CorkboardSectionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'position': instance.position,
  'version': instance.version,
};

_CorkboardAttachmentResponse _$CorkboardAttachmentResponseFromJson(
  Map<String, dynamic> json,
) => _CorkboardAttachmentResponse(
  id: json['id'] as String,
  storageFileId: json['storageFileId'] as String,
  attachedAtUtc: DateTime.parse(json['attachedAtUtc'] as String),
);

Map<String, dynamic> _$CorkboardAttachmentResponseToJson(
  _CorkboardAttachmentResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'storageFileId': instance.storageFileId,
  'attachedAtUtc': instance.attachedAtUtc.toIso8601String(),
};

_CorkboardCardResponse _$CorkboardCardResponseFromJson(
  Map<String, dynamic> json,
) => _CorkboardCardResponse(
  id: json['id'] as String,
  sectionId: json['sectionId'] as String?,
  content: json['content'] as String,
  color: $enumDecode(_$CorkboardCardColorEnumMap, json['color']),
  position: (json['position'] as num).toInt(),
  isPinned: json['isPinned'] as bool,
  conversationId: json['conversationId'] as String?,
  convertedToTaskId: json['convertedToTaskId'] as String?,
  version: (json['version'] as num).toInt(),
  attachments: (json['attachments'] as List<dynamic>)
      .map(
        (e) => CorkboardAttachmentResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$CorkboardCardResponseToJson(
  _CorkboardCardResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sectionId': instance.sectionId,
  'content': instance.content,
  'color': _$CorkboardCardColorEnumMap[instance.color]!,
  'position': instance.position,
  'isPinned': instance.isPinned,
  'conversationId': instance.conversationId,
  'convertedToTaskId': instance.convertedToTaskId,
  'version': instance.version,
  'attachments': instance.attachments,
};

_CorkboardAiClusterPayload _$CorkboardAiClusterPayloadFromJson(
  Map<String, dynamic> json,
) => _CorkboardAiClusterPayload(
  cardIds: (json['cardIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  instruction: json['instruction'] as String?,
);

Map<String, dynamic> _$CorkboardAiClusterPayloadToJson(
  _CorkboardAiClusterPayload instance,
) => <String, dynamic>{
  'cardIds': instance.cardIds,
  'instruction': instance.instruction,
};

_CorkboardAiSummarizeToWikiPayload _$CorkboardAiSummarizeToWikiPayloadFromJson(
  Map<String, dynamic> json,
) =>
    _CorkboardAiSummarizeToWikiPayload(sectionId: json['sectionId'] as String?);

Map<String, dynamic> _$CorkboardAiSummarizeToWikiPayloadToJson(
  _CorkboardAiSummarizeToWikiPayload instance,
) => <String, dynamic>{'sectionId': instance.sectionId};

_CorkboardAiClusterGroupResponse _$CorkboardAiClusterGroupResponseFromJson(
  Map<String, dynamic> json,
) => _CorkboardAiClusterGroupResponse(
  sectionId: json['sectionId'] as String,
  name: json['name'] as String,
  cardIds: (json['cardIds'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CorkboardAiClusterGroupResponseToJson(
  _CorkboardAiClusterGroupResponse instance,
) => <String, dynamic>{
  'sectionId': instance.sectionId,
  'name': instance.name,
  'cardIds': instance.cardIds,
};

_CorkboardAiClusterResponse _$CorkboardAiClusterResponseFromJson(
  Map<String, dynamic> json,
) => _CorkboardAiClusterResponse(
  operationId: json['operationId'] as String,
  operationType: json['operationType'] as String,
  provider: json['provider'] as String,
  idempotentReplay: json['idempotentReplay'] as bool,
  groups: (json['groups'] as List<dynamic>)
      .map(
        (e) =>
            CorkboardAiClusterGroupResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$CorkboardAiClusterResponseToJson(
  _CorkboardAiClusterResponse instance,
) => <String, dynamic>{
  'operationId': instance.operationId,
  'operationType': instance.operationType,
  'provider': instance.provider,
  'idempotentReplay': instance.idempotentReplay,
  'groups': instance.groups,
};

_CorkboardAiSummarizeToWikiResponse
_$CorkboardAiSummarizeToWikiResponseFromJson(Map<String, dynamic> json) =>
    _CorkboardAiSummarizeToWikiResponse(
      operationId: json['operationId'] as String,
      operationType: json['operationType'] as String,
      provider: json['provider'] as String,
      idempotentReplay: json['idempotentReplay'] as bool,
      wikiPage: WikiPageResponse.fromJson(
        json['wikiPage'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CorkboardAiSummarizeToWikiResponseToJson(
  _CorkboardAiSummarizeToWikiResponse instance,
) => <String, dynamic>{
  'operationId': instance.operationId,
  'operationType': instance.operationType,
  'provider': instance.provider,
  'idempotentReplay': instance.idempotentReplay,
  'wikiPage': instance.wikiPage,
};

_CorkboardAiConvertToTaskResponse _$CorkboardAiConvertToTaskResponseFromJson(
  Map<String, dynamic> json,
) => _CorkboardAiConvertToTaskResponse(
  operationId: json['operationId'] as String,
  operationType: json['operationType'] as String,
  provider: json['provider'] as String,
  idempotentReplay: json['idempotentReplay'] as bool,
  cardId: json['cardId'] as String,
  task: ProjectTaskResponse.fromJson(json['task'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CorkboardAiConvertToTaskResponseToJson(
  _CorkboardAiConvertToTaskResponse instance,
) => <String, dynamic>{
  'operationId': instance.operationId,
  'operationType': instance.operationType,
  'provider': instance.provider,
  'idempotentReplay': instance.idempotentReplay,
  'cardId': instance.cardId,
  'task': instance.task,
};
