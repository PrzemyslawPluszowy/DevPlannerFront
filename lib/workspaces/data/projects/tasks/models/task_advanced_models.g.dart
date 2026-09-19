// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_advanced_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskRecurrencePayload _$CreateTaskRecurrencePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskRecurrencePayload(
  mode: $enumDecode(_$TaskRecurrenceModeEnumMap, json['mode']),
  frequency: $enumDecode(_$TaskRecurrenceFrequencyEnumMap, json['frequency']),
  interval: (json['interval'] as num).toInt(),
  timeZoneId: json['timeZoneId'] as String,
  firstOccurrenceAtUtc: json['firstOccurrenceAtUtc'] == null
      ? null
      : DateTime.parse(json['firstOccurrenceAtUtc'] as String),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  occurrenceStatus:
      $enumDecodeNullable(
        _$ProjectTaskStatusEnumMap,
        json['occurrenceStatus'],
      ) ??
      ProjectTaskStatus.todo,
  skipIfPreviousOpen: json['skipIfPreviousOpen'] as bool? ?? true,
);

Map<String, dynamic> _$CreateTaskRecurrencePayloadToJson(
  _CreateTaskRecurrencePayload instance,
) => <String, dynamic>{
  'mode': _$TaskRecurrenceModeEnumMap[instance.mode]!,
  'frequency': _$TaskRecurrenceFrequencyEnumMap[instance.frequency]!,
  'interval': instance.interval,
  'timeZoneId': instance.timeZoneId,
  'firstOccurrenceAtUtc': instance.firstOccurrenceAtUtc?.toIso8601String(),
  'expectedVersion': instance.expectedVersion,
  'occurrenceStatus': _$ProjectTaskStatusEnumMap[instance.occurrenceStatus]!,
  'skipIfPreviousOpen': instance.skipIfPreviousOpen,
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

_UpdateTaskRecurrencePayload _$UpdateTaskRecurrencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskRecurrencePayload(
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
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateTaskRecurrencePayloadToJson(
  _UpdateTaskRecurrencePayload instance,
) => <String, dynamic>{
  'mode': _$TaskRecurrenceModeEnumMap[instance.mode]!,
  'frequency': _$TaskRecurrenceFrequencyEnumMap[instance.frequency]!,
  'interval': instance.interval,
  'timeZoneId': instance.timeZoneId,
  'nextOccurrenceAtUtc': instance.nextOccurrenceAtUtc?.toIso8601String(),
  'occurrenceStatus': _$ProjectTaskStatusEnumMap[instance.occurrenceStatus]!,
  'skipIfPreviousOpen': instance.skipIfPreviousOpen,
  'expectedVersion': instance.expectedVersion,
};

_TaskRecurrenceResponse _$TaskRecurrenceResponseFromJson(
  Map<String, dynamic> json,
) => _TaskRecurrenceResponse(
  id: json['id'] as String,
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  mode: $enumDecode(_$TaskRecurrenceModeEnumMap, json['mode']),
  frequency: $enumDecode(_$TaskRecurrenceFrequencyEnumMap, json['frequency']),
  interval: (json['interval'] as num).toInt(),
  timeZoneId: json['timeZoneId'] as String,
  nextOccurrenceAtUtc: json['nextOccurrenceAtUtc'] == null
      ? null
      : DateTime.parse(json['nextOccurrenceAtUtc'] as String),
  lastCompletedTaskId: json['lastCompletedTaskId'] as String?,
  lastCreatedTaskId: json['lastCreatedTaskId'] as String?,
  occurrenceStatus: $enumDecode(
    _$ProjectTaskStatusEnumMap,
    json['occurrenceStatus'],
  ),
  skipIfPreviousOpen: json['skipIfPreviousOpen'] as bool,
  isActive: json['isActive'] as bool,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$TaskRecurrenceResponseToJson(
  _TaskRecurrenceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'sourceTaskId': instance.sourceTaskId,
  'mode': _$TaskRecurrenceModeEnumMap[instance.mode]!,
  'frequency': _$TaskRecurrenceFrequencyEnumMap[instance.frequency]!,
  'interval': instance.interval,
  'timeZoneId': instance.timeZoneId,
  'nextOccurrenceAtUtc': instance.nextOccurrenceAtUtc?.toIso8601String(),
  'lastCompletedTaskId': instance.lastCompletedTaskId,
  'lastCreatedTaskId': instance.lastCreatedTaskId,
  'occurrenceStatus': _$ProjectTaskStatusEnumMap[instance.occurrenceStatus]!,
  'skipIfPreviousOpen': instance.skipIfPreviousOpen,
  'isActive': instance.isActive,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_ProjectTaskRecurrenceItemResponse _$ProjectTaskRecurrenceItemResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskRecurrenceItemResponse(
  id: json['id'] as String,
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  taskKey: json['taskKey'] as String,
  taskTitle: json['taskTitle'] as String,
  taskStatus: $enumDecode(_$ProjectTaskStatusEnumMap, json['taskStatus']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  assigneeIds:
      (json['assigneeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  mode: $enumDecode(_$TaskRecurrenceModeEnumMap, json['mode']),
  frequency: $enumDecode(_$TaskRecurrenceFrequencyEnumMap, json['frequency']),
  interval: (json['interval'] as num).toInt(),
  timeZoneId: json['timeZoneId'] as String,
  nextOccurrenceAtUtc: json['nextOccurrenceAtUtc'] == null
      ? null
      : DateTime.parse(json['nextOccurrenceAtUtc'] as String),
  lastCompletedTaskId: json['lastCompletedTaskId'] as String?,
  lastCreatedTaskId: json['lastCreatedTaskId'] as String?,
  occurrenceStatus: $enumDecode(
    _$ProjectTaskStatusEnumMap,
    json['occurrenceStatus'],
  ),
  skipIfPreviousOpen: json['skipIfPreviousOpen'] as bool,
  isActive: json['isActive'] as bool,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectTaskRecurrenceItemResponseToJson(
  _ProjectTaskRecurrenceItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'sourceTaskId': instance.sourceTaskId,
  'taskKey': instance.taskKey,
  'taskTitle': instance.taskTitle,
  'taskStatus': _$ProjectTaskStatusEnumMap[instance.taskStatus]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'assigneeIds': instance.assigneeIds,
  'mode': _$TaskRecurrenceModeEnumMap[instance.mode]!,
  'frequency': _$TaskRecurrenceFrequencyEnumMap[instance.frequency]!,
  'interval': instance.interval,
  'timeZoneId': instance.timeZoneId,
  'nextOccurrenceAtUtc': instance.nextOccurrenceAtUtc?.toIso8601String(),
  'lastCompletedTaskId': instance.lastCompletedTaskId,
  'lastCreatedTaskId': instance.lastCreatedTaskId,
  'occurrenceStatus': _$ProjectTaskStatusEnumMap[instance.occurrenceStatus]!,
  'skipIfPreviousOpen': instance.skipIfPreviousOpen,
  'isActive': instance.isActive,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'Low',
  TaskPriority.normal: 'Normal',
  TaskPriority.high: 'High',
  TaskPriority.critical: 'Critical',
};

_ProjectTaskRecurrenceRunResponse _$ProjectTaskRecurrenceRunResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskRecurrenceRunResponse(
  id: json['id'] as String,
  recurrenceRuleId: json['recurrenceRuleId'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  taskKey: json['taskKey'] as String,
  taskTitle: json['taskTitle'] as String,
  scheduledAtUtc: DateTime.parse(json['scheduledAtUtc'] as String),
  executedAtUtc: DateTime.parse(json['executedAtUtc'] as String),
  outcome: $enumDecode(_$TaskRecurrenceRunOutcomeEnumMap, json['outcome']),
  createdTaskId: json['createdTaskId'] as String?,
  createdTaskKey: json['createdTaskKey'] as String?,
);

Map<String, dynamic> _$ProjectTaskRecurrenceRunResponseToJson(
  _ProjectTaskRecurrenceRunResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'recurrenceRuleId': instance.recurrenceRuleId,
  'sourceTaskId': instance.sourceTaskId,
  'taskKey': instance.taskKey,
  'taskTitle': instance.taskTitle,
  'scheduledAtUtc': instance.scheduledAtUtc.toIso8601String(),
  'executedAtUtc': instance.executedAtUtc.toIso8601String(),
  'outcome': _$TaskRecurrenceRunOutcomeEnumMap[instance.outcome]!,
  'createdTaskId': instance.createdTaskId,
  'createdTaskKey': instance.createdTaskKey,
};

const _$TaskRecurrenceRunOutcomeEnumMap = {
  TaskRecurrenceRunOutcome.created: 'Created',
  TaskRecurrenceRunOutcome.skippedPreviousOpen: 'SkippedPreviousOpen',
};

_UpdateProjectTaskWorkflowStatusPayload
_$UpdateProjectTaskWorkflowStatusPayloadFromJson(Map<String, dynamic> json) =>
    _UpdateProjectTaskWorkflowStatusPayload(
      status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
      displayName: json['displayName'] as String,
      color: json['color'] as String,
      position: (json['position'] as num).toInt(),
      isInitial: json['isInitial'] as bool,
      isTerminal: json['isTerminal'] as bool,
      category: $enumDecodeNullable(
        _$TaskStatusCategoryEnumMap,
        json['category'],
      ),
    );

Map<String, dynamic> _$UpdateProjectTaskWorkflowStatusPayloadToJson(
  _UpdateProjectTaskWorkflowStatusPayload instance,
) => <String, dynamic>{
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'displayName': instance.displayName,
  'color': instance.color,
  'position': instance.position,
  'isInitial': instance.isInitial,
  'isTerminal': instance.isTerminal,
  'category': _$TaskStatusCategoryEnumMap[instance.category],
};

const _$TaskStatusCategoryEnumMap = {
  TaskStatusCategory.todo: 'Todo',
  TaskStatusCategory.inProgress: 'InProgress',
  TaskStatusCategory.done: 'Done',
  TaskStatusCategory.cancelled: 'Cancelled',
};

_UpdateProjectTaskWorkflowPayload _$UpdateProjectTaskWorkflowPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectTaskWorkflowPayload(
  statuses: (json['statuses'] as List<dynamic>)
      .map(
        (e) => UpdateProjectTaskWorkflowStatusPayload.fromJson(
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
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateProjectTaskWorkflowPayloadToJson(
  _UpdateProjectTaskWorkflowPayload instance,
) => <String, dynamic>{
  'statuses': instance.statuses,
  'transitions': instance.transitions,
  'expectedVersion': instance.expectedVersion,
};

_TaskHistoryActorResponse _$TaskHistoryActorResponseFromJson(
  Map<String, dynamic> json,
) => _TaskHistoryActorResponse(
  type: $enumDecode(_$TaskActorTypeEnumMap, json['type']),
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$TaskHistoryActorResponseToJson(
  _TaskHistoryActorResponse instance,
) => <String, dynamic>{
  'type': _$TaskActorTypeEnumMap[instance.type]!,
  'userId': instance.userId,
};

const _$TaskActorTypeEnumMap = {
  TaskActorType.user: 'User',
  TaskActorType.system: 'System',
  TaskActorType.automation: 'Automation',
};

_TaskHistoryChangeResponse _$TaskHistoryChangeResponseFromJson(
  Map<String, dynamic> json,
) => _TaskHistoryChangeResponse(
  field: json['field'] as String,
  before: json['before'],
  after: json['after'],
);

Map<String, dynamic> _$TaskHistoryChangeResponseToJson(
  _TaskHistoryChangeResponse instance,
) => <String, dynamic>{
  'field': instance.field,
  'before': instance.before,
  'after': instance.after,
};

_TaskHistoryEventResponse _$TaskHistoryEventResponseFromJson(
  Map<String, dynamic> json,
) => _TaskHistoryEventResponse(
  eventId: json['eventId'] as String,
  eventType: $enumDecode(_$TaskHistoryEventTypeEnumMap, json['eventType']),
  actionLabel: json['actionLabel'] as String,
  actor: TaskHistoryActorResponse.fromJson(
    json['actor'] as Map<String, dynamic>,
  ),
  changes: (json['changes'] as List<dynamic>)
      .map((e) => TaskHistoryChangeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  taskVersion: (json['taskVersion'] as num).toInt(),
  correlationId: json['correlationId'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$TaskHistoryEventResponseToJson(
  _TaskHistoryEventResponse instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'eventType': _$TaskHistoryEventTypeEnumMap[instance.eventType]!,
  'actionLabel': instance.actionLabel,
  'actor': instance.actor,
  'changes': instance.changes,
  'taskVersion': instance.taskVersion,
  'correlationId': instance.correlationId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

const _$TaskHistoryEventTypeEnumMap = {
  TaskHistoryEventType.created: 'Created',
  TaskHistoryEventType.updated: 'Updated',
  TaskHistoryEventType.statusChanged: 'StatusChanged',
  TaskHistoryEventType.assigneesChanged: 'AssigneesChanged',
  TaskHistoryEventType.checklistChanged: 'ChecklistChanged',
  TaskHistoryEventType.watcherChanged: 'WatcherChanged',
  TaskHistoryEventType.labelsChanged: 'LabelsChanged',
  TaskHistoryEventType.customFieldsChanged: 'CustomFieldsChanged',
  TaskHistoryEventType.acceptanceCriteriaChanged: 'AcceptanceCriteriaChanged',
  TaskHistoryEventType.dependencyChanged: 'DependencyChanged',
  TaskHistoryEventType.reordered: 'Reordered',
  TaskHistoryEventType.kanbanMoved: 'KanbanMoved',
  TaskHistoryEventType.kanbanRebalanced: 'KanbanRebalanced',
  TaskHistoryEventType.archived: 'Archived',
  TaskHistoryEventType.restored: 'Restored',
  TaskHistoryEventType.recurrenceChanged: 'RecurrenceChanged',
  TaskHistoryEventType.recurrenceOccurrenceCreated:
      'RecurrenceOccurrenceCreated',
};

_TaskTimelineItemResponse _$TaskTimelineItemResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTimelineItemResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  parentTaskId: json['parentTaskId'] as String?,
  title: json['title'] as String,
  taskType: json['taskType'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  position: (json['position'] as num).toInt(),
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => TaskAssigneeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  checklistCompletedCount: (json['checklistCompletedCount'] as num).toInt(),
  checklistTotalCount: (json['checklistTotalCount'] as num).toInt(),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$TaskTimelineItemResponseToJson(
  _TaskTimelineItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'parentTaskId': instance.parentTaskId,
  'title': instance.title,
  'taskType': instance.taskType,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'estimatedMinutes': instance.estimatedMinutes,
  'position': instance.position,
  'assignees': instance.assignees,
  'checklistCompletedCount': instance.checklistCompletedCount,
  'checklistTotalCount': instance.checklistTotalCount,
  'version': instance.version,
};

_TaskTimelineDependencyResponse _$TaskTimelineDependencyResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTimelineDependencyResponse(
  id: json['id'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  targetTaskId: json['targetTaskId'] as String,
  type: $enumDecode(_$TaskDependencyTypeEnumMap, json['type']),
);

Map<String, dynamic> _$TaskTimelineDependencyResponseToJson(
  _TaskTimelineDependencyResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceTaskId': instance.sourceTaskId,
  'targetTaskId': instance.targetTaskId,
  'type': _$TaskDependencyTypeEnumMap[instance.type]!,
};

const _$TaskDependencyTypeEnumMap = {
  TaskDependencyType.blocks: 'Blocks',
  TaskDependencyType.relatedTo: 'RelatedTo',
  TaskDependencyType.duplicate: 'Duplicate',
};

_TaskTimelineResponse _$TaskTimelineResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTimelineResponse(
  fromUtc: DateTime.parse(json['fromUtc'] as String),
  toUtc: DateTime.parse(json['toUtc'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => TaskTimelineItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  dependencies: (json['dependencies'] as List<dynamic>)
      .map(
        (e) =>
            TaskTimelineDependencyResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  isTruncated: json['isTruncated'] as bool,
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$TaskTimelineResponseToJson(
  _TaskTimelineResponse instance,
) => <String, dynamic>{
  'fromUtc': instance.fromUtc.toIso8601String(),
  'toUtc': instance.toUtc.toIso8601String(),
  'items': instance.items,
  'dependencies': instance.dependencies,
  'isTruncated': instance.isTruncated,
  'nextCursor': instance.nextCursor,
};

_TaskTimeEntryResponse _$TaskTimeEntryResponseFromJson(
  Map<String, dynamic> json,
) => _TaskTimeEntryResponse(
  id: json['id'] as String,
  taskId: json['taskId'] as String,
  userId: json['userId'] as String,
  kind: $enumDecode(_$TaskTimeEntryKindEnumMap, json['kind']),
  startedAtUtc: DateTime.parse(json['startedAtUtc'] as String),
  stoppedAtUtc: json['stoppedAtUtc'] == null
      ? null
      : DateTime.parse(json['stoppedAtUtc'] as String),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  description: json['description'] as String?,
  isBillable: json['isBillable'] as bool,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  approvalStatus: $enumDecode(
    _$TaskTimeEntryApprovalStatusEnumMap,
    json['approvalStatus'],
  ),
  reviewedByUserId: json['reviewedByUserId'] as String?,
  reviewedAtUtc: json['reviewedAtUtc'] == null
      ? null
      : DateTime.parse(json['reviewedAtUtc'] as String),
  reviewComment: json['reviewComment'] as String?,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$TaskTimeEntryResponseToJson(
  _TaskTimeEntryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'taskId': instance.taskId,
  'userId': instance.userId,
  'kind': _$TaskTimeEntryKindEnumMap[instance.kind]!,
  'startedAtUtc': instance.startedAtUtc.toIso8601String(),
  'stoppedAtUtc': instance.stoppedAtUtc?.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'description': instance.description,
  'isBillable': instance.isBillable,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'approvalStatus':
      _$TaskTimeEntryApprovalStatusEnumMap[instance.approvalStatus]!,
  'reviewedByUserId': instance.reviewedByUserId,
  'reviewedAtUtc': instance.reviewedAtUtc?.toIso8601String(),
  'reviewComment': instance.reviewComment,
  'version': instance.version,
};

const _$TaskTimeEntryKindEnumMap = {
  TaskTimeEntryKind.manual: 'Manual',
  TaskTimeEntryKind.timer: 'Timer',
};

const _$TaskTimeEntryApprovalStatusEnumMap = {
  TaskTimeEntryApprovalStatus.draft: 'Draft',
  TaskTimeEntryApprovalStatus.submitted: 'Submitted',
  TaskTimeEntryApprovalStatus.approved: 'Approved',
  TaskTimeEntryApprovalStatus.rejected: 'Rejected',
};

_CreateTaskTimeEntryPayload _$CreateTaskTimeEntryPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskTimeEntryPayload(
  startedAtUtc: json['startedAtUtc'] == null
      ? null
      : DateTime.parse(json['startedAtUtc'] as String),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  description: json['description'] as String?,
  isBillable: json['isBillable'] as bool,
);

Map<String, dynamic> _$CreateTaskTimeEntryPayloadToJson(
  _CreateTaskTimeEntryPayload instance,
) => <String, dynamic>{
  'startedAtUtc': instance.startedAtUtc?.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'description': instance.description,
  'isBillable': instance.isBillable,
};

_StopTaskTimerPayload _$StopTaskTimerPayloadFromJson(
  Map<String, dynamic> json,
) => _StopTaskTimerPayload(
  stoppedAtUtc: json['stoppedAtUtc'] == null
      ? null
      : DateTime.parse(json['stoppedAtUtc'] as String),
);

Map<String, dynamic> _$StopTaskTimerPayloadToJson(
  _StopTaskTimerPayload instance,
) => <String, dynamic>{
  'stoppedAtUtc': instance.stoppedAtUtc?.toIso8601String(),
};

_TimeEntryWorkflowPayload _$TimeEntryWorkflowPayloadFromJson(
  Map<String, dynamic> json,
) => _TimeEntryWorkflowPayload(
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$TimeEntryWorkflowPayloadToJson(
  _TimeEntryWorkflowPayload instance,
) => <String, dynamic>{
  'expectedVersion': instance.expectedVersion,
  'comment': instance.comment,
};
