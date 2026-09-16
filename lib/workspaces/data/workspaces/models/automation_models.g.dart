// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AutomationCondition _$AutomationConditionFromJson(Map<String, dynamic> json) =>
    _AutomationCondition(
      type: $enumDecode(_$AutomationConditionTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$ProjectTaskStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      userId: json['userId'] as String?,
      labelId: json['labelId'] as String?,
      days: (json['days'] as num?)?.toInt(),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$AutomationConditionToJson(
  _AutomationCondition instance,
) => <String, dynamic>{
  'type': _$AutomationConditionTypeEnumMap[instance.type]!,
  'status': _$ProjectTaskStatusEnumMap[instance.status],
  'priority': _$TaskPriorityEnumMap[instance.priority],
  'userId': instance.userId,
  'labelId': instance.labelId,
  'days': instance.days,
  'text': instance.text,
};

const _$AutomationConditionTypeEnumMap = {
  AutomationConditionType.taskStatusIs: 'TaskStatusIs',
  AutomationConditionType.taskPriorityIs: 'TaskPriorityIs',
  AutomationConditionType.taskAssigneeIs: 'TaskAssigneeIs',
  AutomationConditionType.taskDueWithinDays: 'TaskDueWithinDays',
  AutomationConditionType.taskHasLabel: 'TaskHasLabel',
  AutomationConditionType.taskTitleContains: 'TaskTitleContains',
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

_AutomationAction _$AutomationActionFromJson(Map<String, dynamic> json) =>
    _AutomationAction(
      type: $enumDecode(_$AutomationActionTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$ProjectTaskStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      userId: json['userId'] as String?,
      labelId: json['labelId'] as String?,
      dueAtUtc: json['dueAtUtc'] == null
          ? null
          : DateTime.parse(json['dueAtUtc'] as String),
      text: json['text'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      conversationId: json['conversationId'] as String?,
      keyResultId: json['keyResultId'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      webhookUrl: json['webhookUrl'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      storageFileId: json['storageFileId'] as String?,
    );

Map<String, dynamic> _$AutomationActionToJson(_AutomationAction instance) =>
    <String, dynamic>{
      'type': _$AutomationActionTypeEnumMap[instance.type]!,
      'status': _$ProjectTaskStatusEnumMap[instance.status],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'userId': instance.userId,
      'labelId': instance.labelId,
      'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
      'text': instance.text,
      'title': instance.title,
      'description': instance.description,
      'conversationId': instance.conversationId,
      'keyResultId': instance.keyResultId,
      'value': instance.value,
      'webhookUrl': instance.webhookUrl,
      'payload': instance.payload,
      'storageFileId': instance.storageFileId,
    };

const _$AutomationActionTypeEnumMap = {
  AutomationActionType.setTaskStatus: 'SetTaskStatus',
  AutomationActionType.setTaskPriority: 'SetTaskPriority',
  AutomationActionType.assignTask: 'AssignTask',
  AutomationActionType.addTaskLabel: 'AddTaskLabel',
  AutomationActionType.removeTaskLabel: 'RemoveTaskLabel',
  AutomationActionType.setTaskDueDate: 'SetTaskDueDate',
  AutomationActionType.notifyUser: 'NotifyUser',
  AutomationActionType.createSubtask: 'CreateSubtask',
  AutomationActionType.sendChatMessage: 'SendChatMessage',
  AutomationActionType.updateOkrKeyResult: 'UpdateOkrKeyResult',
  AutomationActionType.invokeWebhook: 'InvokeWebhook',
  AutomationActionType.createStorageNotification: 'CreateStorageNotification',
};

_CreateAutomationRulePayload _$CreateAutomationRulePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateAutomationRulePayload(
  name: json['name'] as String,
  triggerType: $enumDecode(_$AutomationTriggerTypeEnumMap, json['triggerType']),
  triggerConfig: json['triggerConfig'] as Map<String, dynamic>,
  conditions: (json['conditions'] as List<dynamic>)
      .map((e) => AutomationCondition.fromJson(e as Map<String, dynamic>))
      .toList(),
  actions: (json['actions'] as List<dynamic>)
      .map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CreateAutomationRulePayloadToJson(
  _CreateAutomationRulePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'triggerType': _$AutomationTriggerTypeEnumMap[instance.triggerType]!,
  'triggerConfig': instance.triggerConfig,
  'conditions': instance.conditions,
  'actions': instance.actions,
};

const _$AutomationTriggerTypeEnumMap = {
  AutomationTriggerType.taskCreated: 'TaskCreated',
  AutomationTriggerType.taskStatusChanged: 'TaskStatusChanged',
  AutomationTriggerType.taskKanbanMoved: 'TaskKanbanMoved',
  AutomationTriggerType.taskDueSoon: 'TaskDueSoon',
  AutomationTriggerType.fileUploaded: 'FileUploaded',
  AutomationTriggerType.wikiPublished: 'WikiPublished',
  AutomationTriggerType.whiteboardExported: 'WhiteboardExported',
  AutomationTriggerType.schedule: 'Schedule',
};

_UpdateAutomationRulePayload _$UpdateAutomationRulePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateAutomationRulePayload(
  name: json['name'] as String,
  triggerType: $enumDecode(_$AutomationTriggerTypeEnumMap, json['triggerType']),
  triggerConfig: json['triggerConfig'] as Map<String, dynamic>,
  conditions: (json['conditions'] as List<dynamic>)
      .map((e) => AutomationCondition.fromJson(e as Map<String, dynamic>))
      .toList(),
  actions: (json['actions'] as List<dynamic>)
      .map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
      .toList(),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateAutomationRulePayloadToJson(
  _UpdateAutomationRulePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'triggerType': _$AutomationTriggerTypeEnumMap[instance.triggerType]!,
  'triggerConfig': instance.triggerConfig,
  'conditions': instance.conditions,
  'actions': instance.actions,
  'expectedVersion': instance.expectedVersion,
};

_SetAutomationRuleEnabledPayload _$SetAutomationRuleEnabledPayloadFromJson(
  Map<String, dynamic> json,
) => _SetAutomationRuleEnabledPayload(
  enabled: json['enabled'] as bool,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$SetAutomationRuleEnabledPayloadToJson(
  _SetAutomationRuleEnabledPayload instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'expectedVersion': instance.expectedVersion,
};

_AutomationRuleResponse _$AutomationRuleResponseFromJson(
  Map<String, dynamic> json,
) => _AutomationRuleResponse(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  name: json['name'] as String,
  triggerType: $enumDecode(_$AutomationTriggerTypeEnumMap, json['triggerType']),
  triggerConfig: json['triggerConfig'] as Map<String, dynamic>,
  conditions: (json['conditions'] as List<dynamic>)
      .map((e) => AutomationCondition.fromJson(e as Map<String, dynamic>))
      .toList(),
  actions: (json['actions'] as List<dynamic>)
      .map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
      .toList(),
  isEnabled: json['isEnabled'] as bool,
  executionCount: (json['executionCount'] as num).toInt(),
  lastExecutedAtUtc: json['lastExecutedAtUtc'] == null
      ? null
      : DateTime.parse(json['lastExecutedAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
  archivedAtUtc: json['archivedAtUtc'] == null
      ? null
      : DateTime.parse(json['archivedAtUtc'] as String),
);

Map<String, dynamic> _$AutomationRuleResponseToJson(
  _AutomationRuleResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'name': instance.name,
  'triggerType': _$AutomationTriggerTypeEnumMap[instance.triggerType]!,
  'triggerConfig': instance.triggerConfig,
  'conditions': instance.conditions,
  'actions': instance.actions,
  'isEnabled': instance.isEnabled,
  'executionCount': instance.executionCount,
  'lastExecutedAtUtc': instance.lastExecutedAtUtc?.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
  'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
};

_AutomationRunResponse _$AutomationRunResponseFromJson(
  Map<String, dynamic> json,
) => _AutomationRunResponse(
  id: json['id'] as String,
  ruleId: json['ruleId'] as String,
  triggerEventId: json['triggerEventId'] as String,
  triggerSourceEntity: json['triggerSourceEntity'] as String,
  triggerSourceEntityId: json['triggerSourceEntityId'] as String,
  status: $enumDecode(_$AutomationRunStatusEnumMap, json['status']),
  durationMs: (json['durationMs'] as num).toInt(),
  errorMessage: json['errorMessage'] as String?,
  executionDetails: json['executionDetails'] as Map<String, dynamic>,
  executedAtUtc: DateTime.parse(json['executedAtUtc'] as String),
  correlationId: json['correlationId'] as String,
  chainDepth: (json['chainDepth'] as num).toInt(),
);

Map<String, dynamic> _$AutomationRunResponseToJson(
  _AutomationRunResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'ruleId': instance.ruleId,
  'triggerEventId': instance.triggerEventId,
  'triggerSourceEntity': instance.triggerSourceEntity,
  'triggerSourceEntityId': instance.triggerSourceEntityId,
  'status': _$AutomationRunStatusEnumMap[instance.status]!,
  'durationMs': instance.durationMs,
  'errorMessage': instance.errorMessage,
  'executionDetails': instance.executionDetails,
  'executedAtUtc': instance.executedAtUtc.toIso8601String(),
  'correlationId': instance.correlationId,
  'chainDepth': instance.chainDepth,
};

const _$AutomationRunStatusEnumMap = {
  AutomationRunStatus.queued: 'Queued',
  AutomationRunStatus.running: 'Running',
  AutomationRunStatus.succeeded: 'Succeeded',
  AutomationRunStatus.partiallySucceeded: 'PartiallySucceeded',
  AutomationRunStatus.failed: 'Failed',
  AutomationRunStatus.skippedConditions: 'SkippedConditions',
  AutomationRunStatus.skippedDisabled: 'SkippedDisabled',
  AutomationRunStatus.skippedLoop: 'SkippedLoop',
};

_AutomationDryRunPayload _$AutomationDryRunPayloadFromJson(
  Map<String, dynamic> json,
) => _AutomationDryRunPayload(
  taskId: json['taskId'] as String,
  eventPayload: json['eventPayload'] as Map<String, dynamic>,
);

Map<String, dynamic> _$AutomationDryRunPayloadToJson(
  _AutomationDryRunPayload instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'eventPayload': instance.eventPayload,
};

_AutomationActionPreview _$AutomationActionPreviewFromJson(
  Map<String, dynamic> json,
) => _AutomationActionPreview(
  type: $enumDecode(_$AutomationActionTypeEnumMap, json['type']),
  supported: json['supported'] as bool,
  description: json['description'] as String,
);

Map<String, dynamic> _$AutomationActionPreviewToJson(
  _AutomationActionPreview instance,
) => <String, dynamic>{
  'type': _$AutomationActionTypeEnumMap[instance.type]!,
  'supported': instance.supported,
  'description': instance.description,
};

_AutomationDryRunResponse _$AutomationDryRunResponseFromJson(
  Map<String, dynamic> json,
) => _AutomationDryRunResponse(
  ruleId: json['ruleId'] as String,
  taskId: json['taskId'] as String,
  conditionsMatched: json['conditionsMatched'] as bool,
  actions: (json['actions'] as List<dynamic>)
      .map((e) => AutomationActionPreview.fromJson(e as Map<String, dynamic>))
      .toList(),
  skipReason: json['skipReason'] as String?,
);

Map<String, dynamic> _$AutomationDryRunResponseToJson(
  _AutomationDryRunResponse instance,
) => <String, dynamic>{
  'ruleId': instance.ruleId,
  'taskId': instance.taskId,
  'conditionsMatched': instance.conditionsMatched,
  'actions': instance.actions,
  'skipReason': instance.skipReason,
};

_AutomationRecipe _$AutomationRecipeFromJson(Map<String, dynamic> json) =>
    _AutomationRecipe(
      key: json['key'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      triggerType: $enumDecode(
        _$AutomationTriggerTypeEnumMap,
        json['triggerType'],
      ),
      triggerConfig: json['triggerConfig'] as Map<String, dynamic>,
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) => AutomationCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List<dynamic>)
          .map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AutomationRecipeToJson(_AutomationRecipe instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'description': instance.description,
      'triggerType': _$AutomationTriggerTypeEnumMap[instance.triggerType]!,
      'triggerConfig': instance.triggerConfig,
      'conditions': instance.conditions,
      'actions': instance.actions,
    };

_ApplyAutomationRecipePayload _$ApplyAutomationRecipePayloadFromJson(
  Map<String, dynamic> json,
) => _ApplyAutomationRecipePayload(
  name: json['name'] as String?,
  expectedVersion: (json['expectedVersion'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApplyAutomationRecipePayloadToJson(
  _ApplyAutomationRecipePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'expectedVersion': instance.expectedVersion,
};

_AutomationTriggerDefinition _$AutomationTriggerDefinitionFromJson(
  Map<String, dynamic> json,
) => _AutomationTriggerDefinition(
  type: $enumDecode(_$AutomationTriggerTypeEnumMap, json['type']),
  supported: json['supported'] as bool,
  description: json['description'] as String,
);

Map<String, dynamic> _$AutomationTriggerDefinitionToJson(
  _AutomationTriggerDefinition instance,
) => <String, dynamic>{
  'type': _$AutomationTriggerTypeEnumMap[instance.type]!,
  'supported': instance.supported,
  'description': instance.description,
};

_AutomationConditionDefinition _$AutomationConditionDefinitionFromJson(
  Map<String, dynamic> json,
) => _AutomationConditionDefinition(
  type: $enumDecode(_$AutomationConditionTypeEnumMap, json['type']),
  description: json['description'] as String,
);

Map<String, dynamic> _$AutomationConditionDefinitionToJson(
  _AutomationConditionDefinition instance,
) => <String, dynamic>{
  'type': _$AutomationConditionTypeEnumMap[instance.type]!,
  'description': instance.description,
};

_AutomationActionDefinition _$AutomationActionDefinitionFromJson(
  Map<String, dynamic> json,
) => _AutomationActionDefinition(
  type: $enumDecode(_$AutomationActionTypeEnumMap, json['type']),
  supported: json['supported'] as bool,
  description: json['description'] as String,
);

Map<String, dynamic> _$AutomationActionDefinitionToJson(
  _AutomationActionDefinition instance,
) => <String, dynamic>{
  'type': _$AutomationActionTypeEnumMap[instance.type]!,
  'supported': instance.supported,
  'description': instance.description,
};

_AutomationCatalogResponse _$AutomationCatalogResponseFromJson(
  Map<String, dynamic> json,
) => _AutomationCatalogResponse(
  triggers: (json['triggers'] as List<dynamic>)
      .map(
        (e) => AutomationTriggerDefinition.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  conditions: (json['conditions'] as List<dynamic>)
      .map(
        (e) =>
            AutomationConditionDefinition.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  actions: (json['actions'] as List<dynamic>)
      .map(
        (e) => AutomationActionDefinition.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$AutomationCatalogResponseToJson(
  _AutomationCatalogResponse instance,
) => <String, dynamic>{
  'triggers': instance.triggers,
  'conditions': instance.conditions,
  'actions': instance.actions,
};
