// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_workflow_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskRecurrenceSummaryResponse _$TaskRecurrenceSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _TaskRecurrenceSummaryResponse(
  id: json['id'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  mode: $enumDecode(_$TaskRecurrenceModeEnumMap, json['mode']),
  frequency: $enumDecode(_$TaskRecurrenceFrequencyEnumMap, json['frequency']),
  interval: (json['interval'] as num).toInt(),
  timeZoneId: json['timeZoneId'] as String,
  nextOccurrenceAtUtc: json['nextOccurrenceAtUtc'] == null
      ? null
      : DateTime.parse(json['nextOccurrenceAtUtc'] as String),
  occurrenceStatus: $enumDecode(
    _$ProjectTaskStatusEnumMap,
    json['occurrenceStatus'],
  ),
  skipIfPreviousOpen: json['skipIfPreviousOpen'] as bool,
  isActive: json['isActive'] as bool,
  isSourceTask: json['isSourceTask'] as bool,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$TaskRecurrenceSummaryResponseToJson(
  _TaskRecurrenceSummaryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceTaskId': instance.sourceTaskId,
  'mode': _$TaskRecurrenceModeEnumMap[instance.mode]!,
  'frequency': _$TaskRecurrenceFrequencyEnumMap[instance.frequency]!,
  'interval': instance.interval,
  'timeZoneId': instance.timeZoneId,
  'nextOccurrenceAtUtc': instance.nextOccurrenceAtUtc?.toIso8601String(),
  'occurrenceStatus': _$ProjectTaskStatusEnumMap[instance.occurrenceStatus]!,
  'skipIfPreviousOpen': instance.skipIfPreviousOpen,
  'isActive': instance.isActive,
  'isSourceTask': instance.isSourceTask,
  'version': instance.version,
};

const _$TaskRecurrenceModeEnumMap = {
  TaskRecurrenceMode.scheduled: 'Scheduled',
  TaskRecurrenceMode.afterCompletion: 'AfterCompletion',
};

const _$TaskRecurrenceFrequencyEnumMap = {
  TaskRecurrenceFrequency.daily: 'Daily',
  TaskRecurrenceFrequency.weekly: 'Weekly',
  TaskRecurrenceFrequency.monthly: 'Monthly',
};

const _$ProjectTaskStatusEnumMap = {
  ProjectTaskStatus.backlog: 'Backlog',
  ProjectTaskStatus.todo: 'Todo',
  ProjectTaskStatus.inProgress: 'InProgress',
  ProjectTaskStatus.blocked: 'Blocked',
  ProjectTaskStatus.done: 'Done',
  ProjectTaskStatus.cancelled: 'Cancelled',
};

_ProjectTaskWorkflowStatusResponse _$ProjectTaskWorkflowStatusResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskWorkflowStatusResponse(
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  displayName: json['displayName'] as String,
  color: json['color'] as String,
  position: (json['position'] as num).toInt(),
  isInitial: json['isInitial'] as bool,
  isTerminal: json['isTerminal'] as bool,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
);

Map<String, dynamic> _$ProjectTaskWorkflowStatusResponseToJson(
  _ProjectTaskWorkflowStatusResponse instance,
) => <String, dynamic>{
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'displayName': instance.displayName,
  'color': instance.color,
  'position': instance.position,
  'isInitial': instance.isInitial,
  'isTerminal': instance.isTerminal,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
};

const _$TaskStatusCategoryEnumMap = {
  TaskStatusCategory.todo: 'Todo',
  TaskStatusCategory.inProgress: 'InProgress',
  TaskStatusCategory.done: 'Done',
  TaskStatusCategory.cancelled: 'Cancelled',
};

_ProjectTaskWorkflowTransitionResponse
_$ProjectTaskWorkflowTransitionResponseFromJson(Map<String, dynamic> json) =>
    _ProjectTaskWorkflowTransitionResponse(
      fromStatus: $enumDecode(_$ProjectTaskStatusEnumMap, json['fromStatus']),
      toStatus: $enumDecode(_$ProjectTaskStatusEnumMap, json['toStatus']),
    );

Map<String, dynamic> _$ProjectTaskWorkflowTransitionResponseToJson(
  _ProjectTaskWorkflowTransitionResponse instance,
) => <String, dynamic>{
  'fromStatus': _$ProjectTaskStatusEnumMap[instance.fromStatus]!,
  'toStatus': _$ProjectTaskStatusEnumMap[instance.toStatus]!,
};

_ProjectTaskWorkflowResponse _$ProjectTaskWorkflowResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskWorkflowResponse(
  statuses: (json['statuses'] as List<dynamic>)
      .map(
        (e) => ProjectTaskWorkflowStatusResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  transitions: (json['transitions'] as List<dynamic>)
      .map(
        (e) => ProjectTaskWorkflowTransitionResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectTaskWorkflowResponseToJson(
  _ProjectTaskWorkflowResponse instance,
) => <String, dynamic>{
  'statuses': instance.statuses,
  'transitions': instance.transitions,
  'version': instance.version,
};

_CreateProjectTaskPayload _$CreateProjectTaskPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateProjectTaskPayload(
  title: json['title'] as String,
  description: json['description'] as String?,
  parentTaskId: json['parentTaskId'] as String?,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  assigneeUserIds: (json['assigneeUserIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  checklistItems: (json['checklistItems'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  taskType: json['taskType'] as String?,
  size: (json['size'] as num?)?.toInt(),
  complexity: (json['complexity'] as num?)?.toInt(),
  risk: (json['risk'] as num?)?.toInt(),
  businessValue: (json['businessValue'] as num?)?.toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  actualMinutes: (json['actualMinutes'] as num?)?.toInt(),
  descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
  milestoneId: json['milestoneId'] as String?,
  targetStatus: $enumDecodeNullable(
    _$ProjectTaskStatusEnumMap,
    json['targetStatus'],
  ),
  customStatusId: json['customStatusId'] as String?,
  previousTaskId: json['previousTaskId'] as String?,
  nextTaskId: json['nextTaskId'] as String?,
);

Map<String, dynamic> _$CreateProjectTaskPayloadToJson(
  _CreateProjectTaskPayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'parentTaskId': instance.parentTaskId,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'assigneeUserIds': instance.assigneeUserIds,
  'checklistItems': instance.checklistItems,
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'actualMinutes': instance.actualMinutes,
  'descriptionDeltaJson': instance.descriptionDeltaJson,
  'milestoneId': instance.milestoneId,
  'targetStatus': _$ProjectTaskStatusEnumMap[instance.targetStatus],
  'customStatusId': instance.customStatusId,
  'previousTaskId': instance.previousTaskId,
  'nextTaskId': instance.nextTaskId,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'Low',
  TaskPriority.normal: 'Normal',
  TaskPriority.high: 'High',
  TaskPriority.critical: 'Critical',
};

_QuickCreateProjectTaskPayload _$QuickCreateProjectTaskPayloadFromJson(
  Map<String, dynamic> json,
) => _QuickCreateProjectTaskPayload(
  title: json['title'] as String,
  parentTaskId: json['parentTaskId'] as String?,
  taskTemplateId: json['taskTemplateId'] as String?,
  useDefaultTemplate: json['useDefaultTemplate'] as bool? ?? true,
  targetStatus: $enumDecodeNullable(
    _$ProjectTaskStatusEnumMap,
    json['targetStatus'],
  ),
  customStatusId: json['customStatusId'] as String?,
  previousTaskId: json['previousTaskId'] as String?,
  nextTaskId: json['nextTaskId'] as String?,
);

Map<String, dynamic> _$QuickCreateProjectTaskPayloadToJson(
  _QuickCreateProjectTaskPayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'parentTaskId': ?instance.parentTaskId,
  'taskTemplateId': ?instance.taskTemplateId,
  'useDefaultTemplate': instance.useDefaultTemplate,
  'targetStatus': ?_$ProjectTaskStatusEnumMap[instance.targetStatus],
  'customStatusId': ?instance.customStatusId,
  'previousTaskId': ?instance.previousTaskId,
  'nextTaskId': ?instance.nextTaskId,
};

_UpdateProjectTaskPayload _$UpdateProjectTaskPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectTaskPayload(
  title: json['title'] as String,
  description: json['description'] as String?,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  calendarTimeZoneId: json['calendarTimeZoneId'] as String?,
  position: (json['position'] as num).toInt(),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  taskType: json['taskType'] as String?,
  size: (json['size'] as num?)?.toInt(),
  complexity: (json['complexity'] as num?)?.toInt(),
  risk: (json['risk'] as num?)?.toInt(),
  businessValue: (json['businessValue'] as num?)?.toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  actualMinutes: (json['actualMinutes'] as num?)?.toInt(),
  descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
  milestoneId: json['milestoneId'] as String?,
  customStatusId: json['customStatusId'] as String?,
  clearMilestone: json['clearMilestone'] as bool? ?? false,
);

Map<String, dynamic> _$UpdateProjectTaskPayloadToJson(
  _UpdateProjectTaskPayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'calendarTimeZoneId': ?instance.calendarTimeZoneId,
  'position': instance.position,
  'expectedVersion': instance.expectedVersion,
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'actualMinutes': instance.actualMinutes,
  'descriptionDeltaJson': instance.descriptionDeltaJson,
  'milestoneId': instance.milestoneId,
  'customStatusId': instance.customStatusId,
  'clearMilestone': instance.clearMilestone,
};
