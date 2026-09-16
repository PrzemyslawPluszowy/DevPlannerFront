// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateMilestonePayload _$CreateMilestonePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateMilestonePayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
);

Map<String, dynamic> _$CreateMilestonePayloadToJson(
  _CreateMilestonePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
};

_UpdateMilestonePayload _$UpdateMilestonePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateMilestonePayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  status: $enumDecode(_$MilestoneStatusEnumMap, json['status']),
);

Map<String, dynamic> _$UpdateMilestonePayloadToJson(
  _UpdateMilestonePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'status': _$MilestoneStatusEnumMap[instance.status]!,
};

const _$MilestoneStatusEnumMap = {
  MilestoneStatus.active: 'Active',
  MilestoneStatus.completed: 'Completed',
  MilestoneStatus.cancelled: 'Cancelled',
};

_MilestoneResponse _$MilestoneResponseFromJson(Map<String, dynamic> json) =>
    _MilestoneResponse(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      workspaceId: json['workspaceId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      dueAtUtc: json['dueAtUtc'] == null
          ? null
          : DateTime.parse(json['dueAtUtc'] as String),
      status: $enumDecode(_$MilestoneStatusEnumMap, json['status']),
      progress: (json['progress'] as num).toDouble(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$MilestoneResponseToJson(_MilestoneResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'workspaceId': instance.workspaceId,
      'name': instance.name,
      'description': instance.description,
      'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
      'status': _$MilestoneStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'version': instance.version,
    };

_MilestoneTaskResponse _$MilestoneTaskResponseFromJson(
  Map<String, dynamic> json,
) => _MilestoneTaskResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  title: json['title'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$MilestoneTaskResponseToJson(
  _MilestoneTaskResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'title': instance.title,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'version': instance.version,
};

const _$ProjectTaskStatusEnumMap = {
  ProjectTaskStatus.backlog: 'Backlog',
  ProjectTaskStatus.todo: 'Todo',
  ProjectTaskStatus.inProgress: 'InProgress',
  ProjectTaskStatus.blocked: 'Blocked',
  ProjectTaskStatus.done: 'Done',
  ProjectTaskStatus.cancelled: 'Cancelled',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'Low',
  TaskPriority.normal: 'Normal',
  TaskPriority.high: 'High',
  TaskPriority.critical: 'Critical',
};
