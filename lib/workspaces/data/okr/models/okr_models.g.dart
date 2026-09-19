// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'okr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateObjectivePayload _$CreateObjectivePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateObjectivePayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  targetDate: json['targetDate'] == null
      ? null
      : DateTime.parse(json['targetDate'] as String),
);

Map<String, dynamic> _$CreateObjectivePayloadToJson(
  _CreateObjectivePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'targetDate': instance.targetDate?.toIso8601String(),
};

_UpdateObjectivePayload _$UpdateObjectivePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateObjectivePayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  targetDate: json['targetDate'] == null
      ? null
      : DateTime.parse(json['targetDate'] as String),
);

Map<String, dynamic> _$UpdateObjectivePayloadToJson(
  _UpdateObjectivePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'targetDate': instance.targetDate?.toIso8601String(),
};

_CreateKeyResultPayload _$CreateKeyResultPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateKeyResultPayload(
  name: json['name'] as String,
  type: $enumDecode(_$KeyResultTypeEnumMap, json['type']),
  targetValue: (json['targetValue'] as num).toDouble(),
  linkedProjectId: json['linkedProjectId'] as String?,
  linkedMilestoneId: json['linkedMilestoneId'] as String?,
  weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$CreateKeyResultPayloadToJson(
  _CreateKeyResultPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': _$KeyResultTypeEnumMap[instance.type]!,
  'targetValue': instance.targetValue,
  'linkedProjectId': instance.linkedProjectId,
  'linkedMilestoneId': instance.linkedMilestoneId,
  'weight': instance.weight,
};

const _$KeyResultTypeEnumMap = {
  KeyResultType.manual: 'manual',
  KeyResultType.projectProgress: 'projectProgress',
  KeyResultType.milestoneProgress: 'milestoneProgress',
};

_UpdateKeyResultPayload _$UpdateKeyResultPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateKeyResultPayload(
  name: json['name'] as String,
  targetValue: (json['targetValue'] as num).toDouble(),
  weight: (json['weight'] as num).toDouble(),
  currentValue: (json['currentValue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UpdateKeyResultPayloadToJson(
  _UpdateKeyResultPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'targetValue': instance.targetValue,
  'weight': instance.weight,
  'currentValue': instance.currentValue,
};

_KeyResultResponse _$KeyResultResponseFromJson(Map<String, dynamic> json) =>
    _KeyResultResponse(
      id: json['id'] as String,
      objectiveId: json['objectiveId'] as String,
      workspaceId: json['workspaceId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$KeyResultTypeEnumMap, json['type']),
      currentValue: (json['currentValue'] as num).toDouble(),
      targetValue: (json['targetValue'] as num).toDouble(),
      linkedProjectId: json['linkedProjectId'] as String?,
      linkedMilestoneId: json['linkedMilestoneId'] as String?,
      weight: (json['weight'] as num).toDouble(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$KeyResultResponseToJson(_KeyResultResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'objectiveId': instance.objectiveId,
      'workspaceId': instance.workspaceId,
      'name': instance.name,
      'type': _$KeyResultTypeEnumMap[instance.type]!,
      'currentValue': instance.currentValue,
      'targetValue': instance.targetValue,
      'linkedProjectId': instance.linkedProjectId,
      'linkedMilestoneId': instance.linkedMilestoneId,
      'weight': instance.weight,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'version': instance.version,
    };

_ObjectiveResponse _$ObjectiveResponseFromJson(Map<String, dynamic> json) =>
    _ObjectiveResponse(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      createdByUserId: json['createdByUserId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      progress: (json['progress'] as num).toDouble(),
      keyResults: (json['keyResults'] as List<dynamic>)
          .map((e) => KeyResultResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$ObjectiveResponseToJson(_ObjectiveResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'createdByUserId': instance.createdByUserId,
      'name': instance.name,
      'description': instance.description,
      'targetDate': instance.targetDate?.toIso8601String(),
      'progress': instance.progress,
      'keyResults': instance.keyResults,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'version': instance.version,
    };
