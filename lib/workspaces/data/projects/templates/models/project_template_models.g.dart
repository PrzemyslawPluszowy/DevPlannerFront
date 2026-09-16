// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_template_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProjectTemplatePayload _$CreateProjectTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateProjectTemplatePayload(name: json['name'] as String);

Map<String, dynamic> _$CreateProjectTemplatePayloadToJson(
  _CreateProjectTemplatePayload instance,
) => <String, dynamic>{'name': instance.name};

_ApplyProjectTemplatePayload _$ApplyProjectTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _ApplyProjectTemplatePayload(name: json['name'] as String);

Map<String, dynamic> _$ApplyProjectTemplatePayloadToJson(
  _ApplyProjectTemplatePayload instance,
) => <String, dynamic>{'name': instance.name};

_RefreshProjectTemplatePayload _$RefreshProjectTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _RefreshProjectTemplatePayload(
  name: json['name'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$RefreshProjectTemplatePayloadToJson(
  _RefreshProjectTemplatePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'expectedVersion': instance.expectedVersion,
};

_ProjectTemplateResponse _$ProjectTemplateResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTemplateResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectTemplateResponseToJson(
  _ProjectTemplateResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_TemplateIdMappingResponse _$TemplateIdMappingResponseFromJson(
  Map<String, dynamic> json,
) => _TemplateIdMappingResponse(
  sourceId: json['sourceId'] as String,
  createdId: json['createdId'] as String,
);

Map<String, dynamic> _$TemplateIdMappingResponseToJson(
  _TemplateIdMappingResponse instance,
) => <String, dynamic>{
  'sourceId': instance.sourceId,
  'createdId': instance.createdId,
};

_ProjectTemplateWorkflowResponse _$ProjectTemplateWorkflowResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTemplateWorkflowResponse(
  status: json['status'] as String,
  name: json['name'] as String,
  color: json['color'] as String,
  position: (json['position'] as num).toInt(),
  isInitial: json['isInitial'] as bool,
  isTerminal: json['isTerminal'] as bool,
);

Map<String, dynamic> _$ProjectTemplateWorkflowResponseToJson(
  _ProjectTemplateWorkflowResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'color': instance.color,
  'position': instance.position,
  'isInitial': instance.isInitial,
  'isTerminal': instance.isTerminal,
};

_ProjectTemplateTransitionResponse _$ProjectTemplateTransitionResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTemplateTransitionResponse(
  from: json['from'] as String,
  to: json['to'] as String,
);

Map<String, dynamic> _$ProjectTemplateTransitionResponseToJson(
  _ProjectTemplateTransitionResponse instance,
) => <String, dynamic>{'from': instance.from, 'to': instance.to};

_ProjectTemplateDefinitionResponse _$ProjectTemplateDefinitionResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTemplateDefinitionResponse(
  sourceId: json['sourceId'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  color: json['color'] as String?,
  isRequired: json['required'] as bool?,
  position: (json['position'] as num?)?.toInt(),
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ProjectTemplateDefinitionResponseToJson(
  _ProjectTemplateDefinitionResponse instance,
) => <String, dynamic>{
  'sourceId': instance.sourceId,
  'name': instance.name,
  'type': instance.type,
  'color': instance.color,
  'required': instance.isRequired,
  'position': instance.position,
  'options': instance.options,
};

_ProjectTemplateTaskCustomValueResponse
_$ProjectTemplateTaskCustomValueResponseFromJson(Map<String, dynamic> json) =>
    _ProjectTemplateTaskCustomValueResponse(
      fieldSourceId: json['fieldSourceId'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$ProjectTemplateTaskCustomValueResponseToJson(
  _ProjectTemplateTaskCustomValueResponse instance,
) => <String, dynamic>{
  'fieldSourceId': instance.fieldSourceId,
  'value': instance.value,
};

_ProjectTemplateCustomStatusResponse
_$ProjectTemplateCustomStatusResponseFromJson(Map<String, dynamic> json) =>
    _ProjectTemplateCustomStatusResponse(
      sourceId: json['sourceId'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      category: json['category'] as String,
      position: (json['position'] as num).toInt(),
      wipLimit: (json['wipLimit'] as num?)?.toInt(),
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$ProjectTemplateCustomStatusResponseToJson(
  _ProjectTemplateCustomStatusResponse instance,
) => <String, dynamic>{
  'sourceId': instance.sourceId,
  'name': instance.name,
  'color': instance.color,
  'category': instance.category,
  'position': instance.position,
  'wipLimit': instance.wipLimit,
  'isDefault': instance.isDefault,
};

_ProjectTemplateTaskResponse _$ProjectTemplateTaskResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTemplateTaskResponse(
  sourceId: json['sourceId'] as String,
  parentSourceId: json['parentSourceId'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
  status: json['status'] as String,
  priority: json['priority'] as String,
  taskType: json['taskType'] as String?,
  size: (json['size'] as num?)?.toInt(),
  complexity: (json['complexity'] as num?)?.toInt(),
  risk: (json['risk'] as num?)?.toInt(),
  businessValue: (json['businessValue'] as num?)?.toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  position: (json['position'] as num).toInt(),
  checklist: (json['checklist'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  labelSourceIds: (json['labelSourceIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  customStatusSourceId: json['customStatusSourceId'] as String?,
  customFieldValues: (json['customFieldValues'] as List<dynamic>)
      .map(
        (e) => ProjectTemplateTaskCustomValueResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$ProjectTemplateTaskResponseToJson(
  _ProjectTemplateTaskResponse instance,
) => <String, dynamic>{
  'sourceId': instance.sourceId,
  'parentSourceId': instance.parentSourceId,
  'title': instance.title,
  'description': instance.description,
  'descriptionDeltaJson': instance.descriptionDeltaJson,
  'status': instance.status,
  'priority': instance.priority,
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'position': instance.position,
  'checklist': instance.checklist,
  'acceptanceCriteria': instance.acceptanceCriteria,
  'labelSourceIds': instance.labelSourceIds,
  'customStatusSourceId': instance.customStatusSourceId,
  'customFieldValues': instance.customFieldValues,
};

_ProjectTemplateDetailsResponse _$ProjectTemplateDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTemplateDetailsResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
  visibility: json['visibility'] as String,
  status: json['status'] as String,
  workflow: (json['workflow'] as List<dynamic>)
      .map(
        (e) =>
            ProjectTemplateWorkflowResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  transitions: (json['transitions'] as List<dynamic>)
      .map(
        (e) => ProjectTemplateTransitionResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  customStatuses: (json['customStatuses'] as List<dynamic>?)
      ?.map(
        (e) => ProjectTemplateCustomStatusResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  labels: (json['labels'] as List<dynamic>)
      .map(
        (e) => ProjectTemplateDefinitionResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  customFields: (json['customFields'] as List<dynamic>)
      .map(
        (e) => ProjectTemplateDefinitionResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  tasks: (json['tasks'] as List<dynamic>)
      .map(
        (e) => ProjectTemplateTaskResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectTemplateDetailsResponseToJson(
  _ProjectTemplateDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
  'visibility': instance.visibility,
  'status': instance.status,
  'workflow': instance.workflow,
  'transitions': instance.transitions,
  'customStatuses': instance.customStatuses,
  'labels': instance.labels,
  'customFields': instance.customFields,
  'tasks': instance.tasks,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_ApplyProjectTemplateResponse _$ApplyProjectTemplateResponseFromJson(
  Map<String, dynamic> json,
) => _ApplyProjectTemplateResponse(
  project: ProjectResponse.fromJson(json['project'] as Map<String, dynamic>),
  taskIdMappings: (json['taskIdMappings'] as List<dynamic>)
      .map((e) => TemplateIdMappingResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  labelIdMappings: (json['labelIdMappings'] as List<dynamic>)
      .map((e) => TemplateIdMappingResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  customFieldIdMappings: (json['customFieldIdMappings'] as List<dynamic>)
      .map((e) => TemplateIdMappingResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  customStatusIdMappings: (json['customStatusIdMappings'] as List<dynamic>?)
      ?.map(
        (e) => TemplateIdMappingResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ApplyProjectTemplateResponseToJson(
  _ApplyProjectTemplateResponse instance,
) => <String, dynamic>{
  'project': instance.project,
  'taskIdMappings': instance.taskIdMappings,
  'labelIdMappings': instance.labelIdMappings,
  'customFieldIdMappings': instance.customFieldIdMappings,
  'customStatusIdMappings': instance.customStatusIdMappings,
};
