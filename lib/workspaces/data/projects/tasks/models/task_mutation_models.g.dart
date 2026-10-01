// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_mutation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskDependencyPayload _$CreateTaskDependencyPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskDependencyPayload(
  targetTaskId: json['targetTaskId'] as String,
  type: $enumDecode(_$TaskDependencyTypeEnumMap, json['type']),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  dependencyKind:
      $enumDecodeNullable(
        _$TaskDependencyKindEnumMap,
        json['dependencyKind'],
      ) ??
      TaskDependencyKind.finishToStart,
  lagDays: (json['lagDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CreateTaskDependencyPayloadToJson(
  _CreateTaskDependencyPayload instance,
) => <String, dynamic>{
  'targetTaskId': instance.targetTaskId,
  'type': _$TaskDependencyTypeEnumMap[instance.type]!,
  'expectedVersion': instance.expectedVersion,
  'dependencyKind': _$TaskDependencyKindEnumMap[instance.dependencyKind]!,
  'lagDays': instance.lagDays,
};

const _$TaskDependencyTypeEnumMap = {
  TaskDependencyType.blocks: 'Blocks',
  TaskDependencyType.relatedTo: 'RelatedTo',
  TaskDependencyType.duplicate: 'Duplicate',
};

const _$TaskDependencyKindEnumMap = {
  TaskDependencyKind.finishToStart: 'FinishToStart',
  TaskDependencyKind.startToStart: 'StartToStart',
  TaskDependencyKind.finishToFinish: 'FinishToFinish',
  TaskDependencyKind.startToFinish: 'StartToFinish',
};

_UpdateTaskDependencyPayload _$UpdateTaskDependencyPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskDependencyPayload(
  dependencyKind: $enumDecode(
    _$TaskDependencyKindEnumMap,
    json['dependencyKind'],
  ),
  lagDays: (json['lagDays'] as num).toInt(),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateTaskDependencyPayloadToJson(
  _UpdateTaskDependencyPayload instance,
) => <String, dynamic>{
  'dependencyKind': _$TaskDependencyKindEnumMap[instance.dependencyKind]!,
  'lagDays': instance.lagDays,
  'expectedVersion': instance.expectedVersion,
};

_UpdateTaskAssigneesPayload _$UpdateTaskAssigneesPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskAssigneesPayload(
  userIds: (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateTaskAssigneesPayloadToJson(
  _UpdateTaskAssigneesPayload instance,
) => <String, dynamic>{
  'userIds': instance.userIds,
  'expectedVersion': instance.expectedVersion,
};

_CreateTaskChecklistItemPayload _$CreateTaskChecklistItemPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskChecklistItemPayload(
  title: json['title'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$CreateTaskChecklistItemPayloadToJson(
  _CreateTaskChecklistItemPayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'expectedVersion': instance.expectedVersion,
};

_UpdateTaskChecklistItemPayload _$UpdateTaskChecklistItemPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskChecklistItemPayload(
  title: json['title'] as String,
  position: (json['position'] as num).toInt(),
  isCompleted: json['isCompleted'] as bool,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateTaskChecklistItemPayloadToJson(
  _UpdateTaskChecklistItemPayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'position': instance.position,
  'isCompleted': instance.isCompleted,
  'expectedVersion': instance.expectedVersion,
};

_CreateTaskLabelPayload _$CreateTaskLabelPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskLabelPayload(
  name: json['name'] as String,
  color: json['color'] as String,
);

Map<String, dynamic> _$CreateTaskLabelPayloadToJson(
  _CreateTaskLabelPayload instance,
) => <String, dynamic>{'name': instance.name, 'color': instance.color};

_UpdateTaskLabelPayload _$UpdateTaskLabelPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskLabelPayload(
  name: json['name'] as String,
  color: json['color'] as String,
);

Map<String, dynamic> _$UpdateTaskLabelPayloadToJson(
  _UpdateTaskLabelPayload instance,
) => <String, dynamic>{'name': instance.name, 'color': instance.color};

_ReplaceTaskLabelsPayload _$ReplaceTaskLabelsPayloadFromJson(
  Map<String, dynamic> json,
) => _ReplaceTaskLabelsPayload(
  labelIds: (json['labelIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$ReplaceTaskLabelsPayloadToJson(
  _ReplaceTaskLabelsPayload instance,
) => <String, dynamic>{
  'labelIds': instance.labelIds,
  'expectedVersion': instance.expectedVersion,
};

_CreateTaskCustomFieldPayload _$CreateTaskCustomFieldPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskCustomFieldPayload(
  name: json['name'] as String,
  type: $enumDecode(_$TaskCustomFieldTypeEnumMap, json['type']),
  isRequired: json['required'] as bool,
  position: (json['position'] as num).toInt(),
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CreateTaskCustomFieldPayloadToJson(
  _CreateTaskCustomFieldPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': _$TaskCustomFieldTypeEnumMap[instance.type]!,
  'required': instance.isRequired,
  'position': instance.position,
  'options': instance.options,
};

const _$TaskCustomFieldTypeEnumMap = {
  TaskCustomFieldType.text: 'Text',
  TaskCustomFieldType.number: 'Number',
  TaskCustomFieldType.date: 'Date',
  TaskCustomFieldType.boolean: 'Boolean',
  TaskCustomFieldType.singleSelect: 'SingleSelect',
  TaskCustomFieldType.multiSelect: 'MultiSelect',
  TaskCustomFieldType.user: 'User',
};

_UpdateTaskCustomFieldPayload _$UpdateTaskCustomFieldPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskCustomFieldPayload(
  name: json['name'] as String,
  isRequired: json['required'] as bool,
  position: (json['position'] as num).toInt(),
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpdateTaskCustomFieldPayloadToJson(
  _UpdateTaskCustomFieldPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'required': instance.isRequired,
  'position': instance.position,
  'options': instance.options,
};

_TaskCustomFieldResponse _$TaskCustomFieldResponseFromJson(
  Map<String, dynamic> json,
) => _TaskCustomFieldResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$TaskCustomFieldTypeEnumMap, json['type']),
  isRequired: json['required'] as bool,
  position: (json['position'] as num).toInt(),
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TaskCustomFieldResponseToJson(
  _TaskCustomFieldResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$TaskCustomFieldTypeEnumMap[instance.type]!,
  'required': instance.isRequired,
  'position': instance.position,
  'options': instance.options,
};

_ReplaceTaskCustomFieldValuesPayload
_$ReplaceTaskCustomFieldValuesPayloadFromJson(Map<String, dynamic> json) =>
    _ReplaceTaskCustomFieldValuesPayload(
      values: json['values'] as Map<String, dynamic>,
      expectedVersion: (json['expectedVersion'] as num).toInt(),
    );

Map<String, dynamic> _$ReplaceTaskCustomFieldValuesPayloadToJson(
  _ReplaceTaskCustomFieldValuesPayload instance,
) => <String, dynamic>{
  'values': instance.values,
  'expectedVersion': instance.expectedVersion,
};

_TaskCustomFieldValueResponse _$TaskCustomFieldValueResponseFromJson(
  Map<String, dynamic> json,
) => _TaskCustomFieldValueResponse(
  fieldId: json['fieldId'] as String,
  value: json['value'],
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$TaskCustomFieldValueResponseToJson(
  _TaskCustomFieldValueResponse instance,
) => <String, dynamic>{
  'fieldId': instance.fieldId,
  'value': instance.value,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_ReorderProjectTasksPayload _$ReorderProjectTasksPayloadFromJson(
  Map<String, dynamic> json,
) => _ReorderProjectTasksPayload(
  taskIds: (json['taskIds'] as List<dynamic>).map((e) => e as String).toList(),
  parentTaskId: json['parentTaskId'] as String?,
  status: $enumDecodeNullable(_$ProjectTaskStatusEnumMap, json['status']),
  expectedVersions: Map<String, int>.from(json['expectedVersions'] as Map),
);

Map<String, dynamic> _$ReorderProjectTasksPayloadToJson(
  _ReorderProjectTasksPayload instance,
) => <String, dynamic>{
  'taskIds': instance.taskIds,
  'parentTaskId': instance.parentTaskId,
  'status': _$ProjectTaskStatusEnumMap[instance.status],
  'expectedVersions': instance.expectedVersions,
};

const _$ProjectTaskStatusEnumMap = {
  ProjectTaskStatus.backlog: 'Backlog',
  ProjectTaskStatus.todo: 'Todo',
  ProjectTaskStatus.inProgress: 'InProgress',
  ProjectTaskStatus.blocked: 'Blocked',
  ProjectTaskStatus.done: 'Done',
  ProjectTaskStatus.cancelled: 'Cancelled',
};
