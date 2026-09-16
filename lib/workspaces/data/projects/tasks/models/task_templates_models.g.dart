// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_templates_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskTemplatePayload _$CreateTaskTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskTemplatePayload(name: json['name'] as String);

Map<String, dynamic> _$CreateTaskTemplatePayloadToJson(
  _CreateTaskTemplatePayload instance,
) => <String, dynamic>{'name': instance.name};

_ApplyTaskTemplatePayload _$ApplyTaskTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _ApplyTaskTemplatePayload(
  projectId: json['projectId'] as String,
  parentTaskId: json['parentTaskId'] as String?,
  customStatusId: json['customStatusId'] as String?,
  titleOverride: json['titleOverride'] as String?,
  targetStatus: $enumDecodeNullable(
    _$ProjectTaskStatusEnumMap,
    json['targetStatus'],
  ),
);

Map<String, dynamic> _$ApplyTaskTemplatePayloadToJson(
  _ApplyTaskTemplatePayload instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'parentTaskId': instance.parentTaskId,
  'customStatusId': instance.customStatusId,
  'titleOverride': instance.titleOverride,
  'targetStatus': _$ProjectTaskStatusEnumMap[instance.targetStatus],
};

const _$ProjectTaskStatusEnumMap = {
  ProjectTaskStatus.backlog: 'Backlog',
  ProjectTaskStatus.todo: 'Todo',
  ProjectTaskStatus.inProgress: 'InProgress',
  ProjectTaskStatus.blocked: 'Blocked',
  ProjectTaskStatus.done: 'Done',
  ProjectTaskStatus.cancelled: 'Cancelled',
};

_TaskTemplateResponse _$TaskTemplateResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTemplateResponse(
  id: json['id'] as String,
  workspaceId: json['workspaceId'] as String,
  name: json['name'] as String,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
  isDefaultForCurrentUser: json['isDefaultForCurrentUser'] as bool? ?? false,
);

Map<String, dynamic> _$TaskTemplateResponseToJson(
  _TaskTemplateResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceId': instance.workspaceId,
  'name': instance.name,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
  'isDefaultForCurrentUser': instance.isDefaultForCurrentUser,
};

_CreateTaskTemplateDefinitionPayload
_$CreateTaskTemplateDefinitionPayloadFromJson(Map<String, dynamic> json) =>
    _CreateTaskTemplateDefinitionPayload(
      name: json['name'] as String,
      status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      startAtUtc: json['startAtUtc'] == null
          ? null
          : DateTime.parse(json['startAtUtc'] as String),
      dueAtUtc: json['dueAtUtc'] == null
          ? null
          : DateTime.parse(json['dueAtUtc'] as String),
      taskType: json['taskType'] as String?,
      size: (json['size'] as num?)?.toInt(),
      complexity: (json['complexity'] as num?)?.toInt(),
      risk: (json['risk'] as num?)?.toInt(),
      businessValue: (json['businessValue'] as num?)?.toInt(),
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      assigneeCoreUserIds: (json['assigneeCoreUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      checklistItems: (json['checklistItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      labels: (json['labels'] as List<dynamic>?)
          ?.map(
            (e) =>
                TaskTemplateLabelResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      customFieldValues: (json['customFieldValues'] as List<dynamic>?)
          ?.map(
            (e) => TaskTemplateCustomFieldValueResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      customStatus: json['customStatus'] == null
          ? null
          : TaskTemplateCustomStatusResponse.fromJson(
              json['customStatus'] as Map<String, dynamic>,
            ),
      title: json['title'] as String?,
      description: json['description'] as String?,
      descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
    );

Map<String, dynamic> _$CreateTaskTemplateDefinitionPayloadToJson(
  _CreateTaskTemplateDefinitionPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'assigneeCoreUserIds': instance.assigneeCoreUserIds,
  'checklistItems': instance.checklistItems,
  'acceptanceCriteria': instance.acceptanceCriteria,
  'labels': instance.labels,
  'customFieldValues': instance.customFieldValues,
  'customStatus': instance.customStatus,
  'title': ?instance.title,
  'description': ?instance.description,
  'descriptionDeltaJson': ?instance.descriptionDeltaJson,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'Low',
  TaskPriority.normal: 'Normal',
  TaskPriority.high: 'High',
  TaskPriority.critical: 'Critical',
};

_SetDefaultTaskTemplatePayload _$SetDefaultTaskTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _SetDefaultTaskTemplatePayload(
  taskTemplateId: json['taskTemplateId'] as String?,
);

Map<String, dynamic> _$SetDefaultTaskTemplatePayloadToJson(
  _SetDefaultTaskTemplatePayload instance,
) => <String, dynamic>{'taskTemplateId': instance.taskTemplateId};

_DefaultTaskTemplateResponse _$DefaultTaskTemplateResponseFromJson(
  Map<String, dynamic> json,
) => _DefaultTaskTemplateResponse(
  taskTemplateId: json['taskTemplateId'] as String?,
  updatedAtUtc: json['updatedAtUtc'] == null
      ? null
      : DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$DefaultTaskTemplateResponseToJson(
  _DefaultTaskTemplateResponse instance,
) => <String, dynamic>{
  'taskTemplateId': instance.taskTemplateId,
  'updatedAtUtc': instance.updatedAtUtc?.toIso8601String(),
};

_TaskTemplateLabelResponse _$TaskTemplateLabelResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTemplateLabelResponse(
  name: json['name'] as String,
  color: json['color'] as String,
);

Map<String, dynamic> _$TaskTemplateLabelResponseToJson(
  _TaskTemplateLabelResponse instance,
) => <String, dynamic>{'name': instance.name, 'color': instance.color};

_TaskTemplateCustomFieldValueResponse
_$TaskTemplateCustomFieldValueResponseFromJson(Map<String, dynamic> json) =>
    _TaskTemplateCustomFieldValueResponse(
      fieldName: json['fieldName'] as String,
      fieldType: $enumDecode(_$TaskCustomFieldTypeEnumMap, json['fieldType']),
      value: json['value'] as Object,
    );

Map<String, dynamic> _$TaskTemplateCustomFieldValueResponseToJson(
  _TaskTemplateCustomFieldValueResponse instance,
) => <String, dynamic>{
  'fieldName': instance.fieldName,
  'fieldType': _$TaskCustomFieldTypeEnumMap[instance.fieldType]!,
  'value': instance.value,
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

_TaskTemplateCustomStatusResponse _$TaskTemplateCustomStatusResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTemplateCustomStatusResponse(
  name: json['name'] as String,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
);

Map<String, dynamic> _$TaskTemplateCustomStatusResponseToJson(
  _TaskTemplateCustomStatusResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
};

const _$TaskStatusCategoryEnumMap = {
  TaskStatusCategory.todo: 'Todo',
  TaskStatusCategory.inProgress: 'InProgress',
  TaskStatusCategory.done: 'Done',
  TaskStatusCategory.cancelled: 'Cancelled',
};

_TaskTemplateDetailsResponse _$TaskTemplateDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTemplateDetailsResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  title: json['title'] as String?,
  description: json['description'] as String?,
  descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  taskType: json['taskType'] as String?,
  size: (json['size'] as num?)?.toInt(),
  complexity: (json['complexity'] as num?)?.toInt(),
  risk: (json['risk'] as num?)?.toInt(),
  businessValue: (json['businessValue'] as num?)?.toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  assigneeCoreUserIds: (json['assigneeCoreUserIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  checklistItems: (json['checklistItems'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  labels: (json['labels'] as List<dynamic>)
      .map((e) => TaskTemplateLabelResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  customFieldValues: (json['customFieldValues'] as List<dynamic>)
      .map(
        (e) => TaskTemplateCustomFieldValueResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  customStatus: json['customStatus'] == null
      ? null
      : TaskTemplateCustomStatusResponse.fromJson(
          json['customStatus'] as Map<String, dynamic>,
        ),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$TaskTemplateDetailsResponseToJson(
  _TaskTemplateDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'title': instance.title,
  'description': instance.description,
  'descriptionDeltaJson': instance.descriptionDeltaJson,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'assigneeCoreUserIds': instance.assigneeCoreUserIds,
  'checklistItems': instance.checklistItems,
  'acceptanceCriteria': instance.acceptanceCriteria,
  'labels': instance.labels,
  'customFieldValues': instance.customFieldValues,
  'customStatus': instance.customStatus,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_UpdateTaskTemplatePayload _$UpdateTaskTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskTemplatePayload(
  name: json['name'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  taskType: json['taskType'] as String?,
  size: (json['size'] as num?)?.toInt(),
  complexity: (json['complexity'] as num?)?.toInt(),
  risk: (json['risk'] as num?)?.toInt(),
  businessValue: (json['businessValue'] as num?)?.toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  assigneeCoreUserIds: (json['assigneeCoreUserIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  checklistItems: (json['checklistItems'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  labels: (json['labels'] as List<dynamic>?)
      ?.map(
        (e) => TaskTemplateLabelResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  customFieldValues: (json['customFieldValues'] as List<dynamic>?)
      ?.map(
        (e) => TaskTemplateCustomFieldValueResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  customStatus: json['customStatus'] == null
      ? null
      : TaskTemplateCustomStatusResponse.fromJson(
          json['customStatus'] as Map<String, dynamic>,
        ),
  clearCustomStatus: json['clearCustomStatus'] as bool? ?? false,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  title: json['title'] as String?,
  description: json['description'] as String?,
  descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
);

Map<String, dynamic> _$UpdateTaskTemplatePayloadToJson(
  _UpdateTaskTemplatePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'assigneeCoreUserIds': instance.assigneeCoreUserIds,
  'checklistItems': instance.checklistItems,
  'acceptanceCriteria': instance.acceptanceCriteria,
  'labels': instance.labels,
  'customFieldValues': instance.customFieldValues,
  'customStatus': instance.customStatus,
  'clearCustomStatus': instance.clearCustomStatus,
  'expectedVersion': instance.expectedVersion,
  'title': ?instance.title,
  'description': ?instance.description,
  'descriptionDeltaJson': ?instance.descriptionDeltaJson,
};
