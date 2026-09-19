// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

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

_TaskAssigneeResponse _$TaskAssigneeResponseFromJson(
  Map<String, dynamic> json,
) => _TaskAssigneeResponse(
  userId: json['userId'] as String,
  isPrimary: json['isPrimary'] as bool,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$TaskAssigneeResponseToJson(
  _TaskAssigneeResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'isPrimary': instance.isPrimary,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_TaskChecklistItemResponse _$TaskChecklistItemResponseFromJson(
  Map<String, dynamic> json,
) => _TaskChecklistItemResponse(
  id: json['id'] as String,
  title: json['title'] as String,
  position: (json['position'] as num).toInt(),
  isCompleted: json['isCompleted'] as bool,
  completedByUserId: json['completedByUserId'] as String?,
  completedAtUtc: json['completedAtUtc'] == null
      ? null
      : DateTime.parse(json['completedAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$TaskChecklistItemResponseToJson(
  _TaskChecklistItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'position': instance.position,
  'isCompleted': instance.isCompleted,
  'completedByUserId': instance.completedByUserId,
  'completedAtUtc': instance.completedAtUtc?.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_ProjectTaskListItemResponse _$ProjectTaskListItemResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskListItemResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  parentTaskId: json['parentTaskId'] as String?,
  title: json['title'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => TaskAssigneeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  checklistCompletedCount: (json['checklistCompletedCount'] as num).toInt(),
  checklistTotalCount: (json['checklistTotalCount'] as num).toInt(),
  subtaskCount: (json['subtaskCount'] as num?)?.toInt() ?? 0,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
  isPinned: json['isPinned'] as bool? ?? false,
  customStatusId: json['customStatusId'] as String?,
  customFields:
      (json['customFields'] as List<dynamic>?)
          ?.map(
            (e) => TaskCustomFieldValueResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  createdAtUtc: json['createdAtUtc'] == null
      ? null
      : DateTime.parse(json['createdAtUtc'] as String),
  taskType: json['taskType'] as String?,
  size: (json['size'] as num?)?.toInt(),
  complexity: (json['complexity'] as num?)?.toInt(),
  risk: (json['risk'] as num?)?.toInt(),
  businessValue: (json['businessValue'] as num?)?.toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  actualMinutes: (json['actualMinutes'] as num?)?.toInt(),
  labels:
      (json['labels'] as List<dynamic>?)
          ?.map((e) => TaskLabelResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customStatusName: json['customStatusName'] as String?,
  customStatusColor: json['customStatusColor'] as String?,
  watcherCount: (json['watcherCount'] as num?)?.toInt() ?? 0,
  isWatchedByMe: json['isWatchedByMe'] as bool? ?? false,
  recurrence: json['recurrence'] == null
      ? null
      : TaskRecurrenceSummaryResponse.fromJson(
          json['recurrence'] as Map<String, dynamic>,
        ),
  milestoneId: json['milestoneId'] as String?,
);

Map<String, dynamic> _$ProjectTaskListItemResponseToJson(
  _ProjectTaskListItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'parentTaskId': instance.parentTaskId,
  'title': instance.title,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'assignees': instance.assignees,
  'checklistCompletedCount': instance.checklistCompletedCount,
  'checklistTotalCount': instance.checklistTotalCount,
  'subtaskCount': instance.subtaskCount,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
  'isPinned': instance.isPinned,
  'customStatusId': instance.customStatusId,
  'customFields': instance.customFields,
  'createdAtUtc': instance.createdAtUtc?.toIso8601String(),
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'actualMinutes': instance.actualMinutes,
  'labels': instance.labels,
  'customStatusName': instance.customStatusName,
  'customStatusColor': instance.customStatusColor,
  'watcherCount': instance.watcherCount,
  'isWatchedByMe': instance.isWatchedByMe,
  'recurrence': instance.recurrence,
  'milestoneId': instance.milestoneId,
};

_ProjectTaskListGroupResponse _$ProjectTaskListGroupResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskListGroupResponse(
  key: json['key'] as String,
  displayName: json['displayName'] as String,
  color: json['color'] as String?,
  position: (json['position'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => ProjectTaskListItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$ProjectTaskListGroupResponseToJson(
  _ProjectTaskListGroupResponse instance,
) => <String, dynamic>{
  'key': instance.key,
  'displayName': instance.displayName,
  'color': instance.color,
  'position': instance.position,
  'totalCount': instance.totalCount,
  'items': instance.items,
  'nextCursor': instance.nextCursor,
};

_ProjectTaskGroupedListResponse _$ProjectTaskGroupedListResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskGroupedListResponse(
  totalCount: (json['totalCount'] as num).toInt(),
  groupBy: $enumDecode(_$TaskSavedViewGroupByEnumMap, json['groupBy']),
  groups: (json['groups'] as List<dynamic>)
      .map(
        (e) => ProjectTaskListGroupResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ProjectTaskGroupedListResponseToJson(
  _ProjectTaskGroupedListResponse instance,
) => <String, dynamic>{
  'totalCount': instance.totalCount,
  'groupBy': _$TaskSavedViewGroupByEnumMap[instance.groupBy]!,
  'groups': instance.groups,
};

const _$TaskSavedViewGroupByEnumMap = {
  TaskSavedViewGroupBy.none: 'None',
  TaskSavedViewGroupBy.status: 'Status',
  TaskSavedViewGroupBy.customStatus: 'CustomStatus',
  TaskSavedViewGroupBy.priority: 'Priority',
  TaskSavedViewGroupBy.assignee: 'Assignee',
};

_CreateTaskSelectionTokenPayload _$CreateTaskSelectionTokenPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskSelectionTokenPayload(
  query: TaskSelectionQueryPayload.fromJson(
    json['query'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateTaskSelectionTokenPayloadToJson(
  _CreateTaskSelectionTokenPayload instance,
) => <String, dynamic>{'query': instance.query};

_TaskSelectionQueryPayload _$TaskSelectionQueryPayloadFromJson(
  Map<String, dynamic> json,
) => _TaskSelectionQueryPayload(
  savedViewId: json['savedViewId'] as String?,
  status: json['status'] as String?,
  priority: json['priority'] as String?,
  assigneeUserId: json['assigneeUserId'] as String?,
  myInvolvement: json['myInvolvement'] as String?,
  search: json['search'] as String?,
  dueFromUtc: json['dueFromUtc'] == null
      ? null
      : DateTime.parse(json['dueFromUtc'] as String),
  dueToUtc: json['dueToUtc'] == null
      ? null
      : DateTime.parse(json['dueToUtc'] as String),
  includeArchived: json['includeArchived'] as bool? ?? false,
  pinnedOnly: json['pinnedOnly'] as bool? ?? false,
  unassignedOnly: json['unassignedOnly'] as bool? ?? false,
);

Map<String, dynamic> _$TaskSelectionQueryPayloadToJson(
  _TaskSelectionQueryPayload instance,
) => <String, dynamic>{
  'savedViewId': instance.savedViewId,
  'status': instance.status,
  'priority': instance.priority,
  'assigneeUserId': instance.assigneeUserId,
  'myInvolvement': instance.myInvolvement,
  'search': instance.search,
  'dueFromUtc': instance.dueFromUtc?.toIso8601String(),
  'dueToUtc': instance.dueToUtc?.toIso8601String(),
  'includeArchived': instance.includeArchived,
  'pinnedOnly': instance.pinnedOnly,
  'unassignedOnly': instance.unassignedOnly,
};

_TaskSelectionTokenResponse _$TaskSelectionTokenResponseFromJson(
  Map<String, dynamic> json,
) => _TaskSelectionTokenResponse(
  token: json['token'] as String,
  totalCount: (json['totalCount'] as num).toInt(),
  expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
);

Map<String, dynamic> _$TaskSelectionTokenResponseToJson(
  _TaskSelectionTokenResponse instance,
) => <String, dynamic>{
  'token': instance.token,
  'totalCount': instance.totalCount,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
};

_BulkUpdateTaskSelectionPayload _$BulkUpdateTaskSelectionPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkUpdateTaskSelectionPayload(
  selectionToken: json['selectionToken'] as String,
  status: $enumDecodeNullable(_$ProjectTaskStatusEnumMap, json['status']),
  customStatusId: json['customStatusId'] as String?,
  clearCustomStatus: json['clearCustomStatus'] as bool? ?? false,
  priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  clearDueAtUtc: json['clearDueAtUtc'] as bool? ?? false,
  assigneeIds: (json['assigneeIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  archive: json['archive'] as bool? ?? false,
  returnTaskIds:
      (json['returnTaskIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$BulkUpdateTaskSelectionPayloadToJson(
  _BulkUpdateTaskSelectionPayload instance,
) => <String, dynamic>{
  'selectionToken': instance.selectionToken,
  'status': _$ProjectTaskStatusEnumMap[instance.status],
  'customStatusId': instance.customStatusId,
  'clearCustomStatus': instance.clearCustomStatus,
  'priority': _$TaskPriorityEnumMap[instance.priority],
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'clearDueAtUtc': instance.clearDueAtUtc,
  'assigneeIds': instance.assigneeIds,
  'archive': instance.archive,
  'returnTaskIds': instance.returnTaskIds,
};

_BulkUpdateTaskSelectionResponse _$BulkUpdateTaskSelectionResponseFromJson(
  Map<String, dynamic> json,
) => _BulkUpdateTaskSelectionResponse(
  updatedCount: (json['updatedCount'] as num).toInt(),
  updatedTasks:
      (json['updatedTasks'] as List<dynamic>?)
          ?.map(
            (e) => BulkUpdatedTaskVersionResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <BulkUpdatedTaskVersionResponse>[],
);

Map<String, dynamic> _$BulkUpdateTaskSelectionResponseToJson(
  _BulkUpdateTaskSelectionResponse instance,
) => <String, dynamic>{
  'updatedCount': instance.updatedCount,
  'updatedTasks': instance.updatedTasks,
};

_BulkUpdatedTaskVersionResponse _$BulkUpdatedTaskVersionResponseFromJson(
  Map<String, dynamic> json,
) => _BulkUpdatedTaskVersionResponse(
  taskId: json['taskId'] as String,
  version: (json['version'] as num).toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$BulkUpdatedTaskVersionResponseToJson(
  _BulkUpdatedTaskVersionResponse instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'version': instance.version,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_UpdateTaskListItemPayload _$UpdateTaskListItemPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskListItemPayload(
  title: json['title'] as String?,
  status: $enumDecodeNullable(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  clearStartAtUtc: json['clearStartAtUtc'] as bool? ?? false,
  clearDueAtUtc: json['clearDueAtUtc'] as bool? ?? false,
  taskType: json['taskType'] as String?,
  size: (json['size'] as num?)?.toInt(),
  complexity: (json['complexity'] as num?)?.toInt(),
  risk: (json['risk'] as num?)?.toInt(),
  businessValue: (json['businessValue'] as num?)?.toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  clearSize: json['clearSize'] as bool? ?? false,
  clearComplexity: json['clearComplexity'] as bool? ?? false,
  clearRisk: json['clearRisk'] as bool? ?? false,
  clearBusinessValue: json['clearBusinessValue'] as bool? ?? false,
  clearEstimatedMinutes: json['clearEstimatedMinutes'] as bool? ?? false,
  milestoneId: json['milestoneId'] as String?,
  clearMilestone: json['clearMilestone'] as bool? ?? false,
  customStatusId: json['customStatusId'] as String?,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateTaskListItemPayloadToJson(
  _UpdateTaskListItemPayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'status': ?_$ProjectTaskStatusEnumMap[instance.status],
  'priority': _$TaskPriorityEnumMap[instance.priority],
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'clearStartAtUtc': instance.clearStartAtUtc,
  'clearDueAtUtc': instance.clearDueAtUtc,
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'clearSize': instance.clearSize,
  'clearComplexity': instance.clearComplexity,
  'clearRisk': instance.clearRisk,
  'clearBusinessValue': instance.clearBusinessValue,
  'clearEstimatedMinutes': instance.clearEstimatedMinutes,
  'milestoneId': instance.milestoneId,
  'clearMilestone': instance.clearMilestone,
  'customStatusId': ?instance.customStatusId,
  'expectedVersion': instance.expectedVersion,
};

_MoveProjectTaskPayload _$MoveProjectTaskPayloadFromJson(
  Map<String, dynamic> json,
) => _MoveProjectTaskPayload(
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  parentTaskId: json['parentTaskId'] as String?,
  previousTaskId: json['previousTaskId'] as String?,
  nextTaskId: json['nextTaskId'] as String?,
  status: $enumDecodeNullable(_$ProjectTaskStatusEnumMap, json['status']),
  customStatusId: json['customStatusId'] as String?,
);

Map<String, dynamic> _$MoveProjectTaskPayloadToJson(
  _MoveProjectTaskPayload instance,
) => <String, dynamic>{
  'expectedVersion': instance.expectedVersion,
  'parentTaskId': instance.parentTaskId,
  'previousTaskId': instance.previousTaskId,
  'nextTaskId': instance.nextTaskId,
  'status': _$ProjectTaskStatusEnumMap[instance.status],
  'customStatusId': instance.customStatusId,
};

_MovedProjectTaskResponse _$MovedProjectTaskResponseFromJson(
  Map<String, dynamic> json,
) => _MovedProjectTaskResponse(
  taskId: json['taskId'] as String,
  parentTaskId: json['parentTaskId'] as String?,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  position: (json['position'] as num).toInt(),
  version: (json['version'] as num).toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  customStatusId: json['customStatusId'] as String?,
);

Map<String, dynamic> _$MovedProjectTaskResponseToJson(
  _MovedProjectTaskResponse instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'parentTaskId': instance.parentTaskId,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'position': instance.position,
  'version': instance.version,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'customStatusId': instance.customStatusId,
};

_ProjectTaskResponse _$ProjectTaskResponseFromJson(Map<String, dynamic> json) =>
    _ProjectTaskResponse(
      id: json['id'] as String,
      number: (json['number'] as num).toInt(),
      key: json['key'] as String,
      workspaceId: json['workspaceId'] as String,
      projectId: json['projectId'] as String,
      parentTaskId: json['parentTaskId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
      status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      taskType: json['taskType'] as String,
      size: (json['size'] as num?)?.toInt(),
      complexity: (json['complexity'] as num?)?.toInt(),
      risk: (json['risk'] as num?)?.toInt(),
      businessValue: (json['businessValue'] as num?)?.toInt(),
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      actualMinutes: (json['actualMinutes'] as num?)?.toInt(),
      position: (json['position'] as num).toInt(),
      startAtUtc: json['startAtUtc'] == null
          ? null
          : DateTime.parse(json['startAtUtc'] as String),
      dueAtUtc: json['dueAtUtc'] == null
          ? null
          : DateTime.parse(json['dueAtUtc'] as String),
      createdByUserId: json['createdByUserId'] as String,
      assignees: (json['assignees'] as List<dynamic>)
          .map((e) => TaskAssigneeResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      checklistItems: (json['checklistItems'] as List<dynamic>)
          .map(
            (e) =>
                TaskChecklistItemResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      recurrence: json['recurrence'] == null
          ? null
          : TaskRecurrenceSummaryResponse.fromJson(
              json['recurrence'] as Map<String, dynamic>,
            ),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      archivedAtUtc: json['archivedAtUtc'] == null
          ? null
          : DateTime.parse(json['archivedAtUtc'] as String),
      version: (json['version'] as num).toInt(),
      customStatusId: json['customStatusId'] as String?,
    );

Map<String, dynamic> _$ProjectTaskResponseToJson(
  _ProjectTaskResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'parentTaskId': instance.parentTaskId,
  'title': instance.title,
  'description': instance.description,
  'descriptionDeltaJson': instance.descriptionDeltaJson,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'actualMinutes': instance.actualMinutes,
  'position': instance.position,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'createdByUserId': instance.createdByUserId,
  'assignees': instance.assignees,
  'checklistItems': instance.checklistItems,
  'recurrence': instance.recurrence,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
  'version': instance.version,
  'customStatusId': instance.customStatusId,
};

_TaskMutationResponse<T> _$TaskMutationResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _TaskMutationResponse<T>(
  taskId: json['taskId'] as String,
  taskVersion: (json['taskVersion'] as num).toInt(),
  taskUpdatedAtUtc: DateTime.parse(json['taskUpdatedAtUtc'] as String),
  data: fromJsonT(json['data']),
);

Map<String, dynamic> _$TaskMutationResponseToJson<T>(
  _TaskMutationResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'taskVersion': instance.taskVersion,
  'taskUpdatedAtUtc': instance.taskUpdatedAtUtc.toIso8601String(),
  'data': toJsonT(instance.data),
};

_ReorderedTaskVersionResponse _$ReorderedTaskVersionResponseFromJson(
  Map<String, dynamic> json,
) => _ReorderedTaskVersionResponse(
  taskId: json['taskId'] as String,
  taskVersion: (json['taskVersion'] as num).toInt(),
  taskUpdatedAtUtc: DateTime.parse(json['taskUpdatedAtUtc'] as String),
);

Map<String, dynamic> _$ReorderedTaskVersionResponseToJson(
  _ReorderedTaskVersionResponse instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'taskVersion': instance.taskVersion,
  'taskUpdatedAtUtc': instance.taskUpdatedAtUtc.toIso8601String(),
};

_TaskDependencyResponse _$TaskDependencyResponseFromJson(
  Map<String, dynamic> json,
) => _TaskDependencyResponse(
  id: json['id'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  targetTaskId: json['targetTaskId'] as String,
  type: $enumDecode(_$TaskDependencyTypeEnumMap, json['type']),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  dependencyKind:
      $enumDecodeNullable(
        _$TaskDependencyKindEnumMap,
        json['dependencyKind'],
      ) ??
      TaskDependencyKind.finishToStart,
  lagDays: (json['lagDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TaskDependencyResponseToJson(
  _TaskDependencyResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceTaskId': instance.sourceTaskId,
  'targetTaskId': instance.targetTaskId,
  'type': _$TaskDependencyTypeEnumMap[instance.type]!,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
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

_TaskLabelResponse _$TaskLabelResponseFromJson(Map<String, dynamic> json) =>
    _TaskLabelResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
    );

Map<String, dynamic> _$TaskLabelResponseToJson(_TaskLabelResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
    };

_TaskAcceptanceCriterionResponse _$TaskAcceptanceCriterionResponseFromJson(
  Map<String, dynamic> json,
) => _TaskAcceptanceCriterionResponse(
  id: json['id'] as String,
  text: json['text'] as String,
  position: (json['position'] as num).toInt(),
  isAccepted: json['isAccepted'] as bool,
  acceptedByUserId: json['acceptedByUserId'] as String?,
  acceptedAtUtc: json['acceptedAtUtc'] == null
      ? null
      : DateTime.parse(json['acceptedAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$TaskAcceptanceCriterionResponseToJson(
  _TaskAcceptanceCriterionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'position': instance.position,
  'isAccepted': instance.isAccepted,
  'acceptedByUserId': instance.acceptedByUserId,
  'acceptedAtUtc': instance.acceptedAtUtc?.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_TaskWatcherResponse _$TaskWatcherResponseFromJson(Map<String, dynamic> json) =>
    _TaskWatcherResponse(
      userId: json['userId'] as String,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
    );

Map<String, dynamic> _$TaskWatcherResponseToJson(
  _TaskWatcherResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_TaskMutationAcknowledgementResponse
_$TaskMutationAcknowledgementResponseFromJson(Map<String, dynamic> json) =>
    _TaskMutationAcknowledgementResponse(changed: json['changed'] as bool);

Map<String, dynamic> _$TaskMutationAcknowledgementResponseToJson(
  _TaskMutationAcknowledgementResponse instance,
) => <String, dynamic>{'changed': instance.changed};

_CreateTaskAcceptanceCriterionPayload
_$CreateTaskAcceptanceCriterionPayloadFromJson(Map<String, dynamic> json) =>
    _CreateTaskAcceptanceCriterionPayload(
      text: json['text'] as String,
      expectedVersion: (json['expectedVersion'] as num).toInt(),
    );

Map<String, dynamic> _$CreateTaskAcceptanceCriterionPayloadToJson(
  _CreateTaskAcceptanceCriterionPayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'expectedVersion': instance.expectedVersion,
};

_UpdateTaskAcceptanceCriterionPayload
_$UpdateTaskAcceptanceCriterionPayloadFromJson(Map<String, dynamic> json) =>
    _UpdateTaskAcceptanceCriterionPayload(
      text: json['text'] as String,
      position: (json['position'] as num).toInt(),
      isAccepted: json['isAccepted'] as bool,
      expectedVersion: (json['expectedVersion'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateTaskAcceptanceCriterionPayloadToJson(
  _UpdateTaskAcceptanceCriterionPayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'position': instance.position,
  'isAccepted': instance.isAccepted,
  'expectedVersion': instance.expectedVersion,
};

_UpdateTaskUserPreferencePayload _$UpdateTaskUserPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskUserPreferencePayload(isPinned: json['isPinned'] as bool);

Map<String, dynamic> _$UpdateTaskUserPreferencePayloadToJson(
  _UpdateTaskUserPreferencePayload instance,
) => <String, dynamic>{'isPinned': instance.isPinned};

_ProjectTaskDetailsResponse _$ProjectTaskDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskDetailsResponse(
  task: ProjectTaskResponse.fromJson(json['task'] as Map<String, dynamic>),
  labels: (json['labels'] as List<dynamic>)
      .map((e) => TaskLabelResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  customFields: (json['customFields'] as List<dynamic>)
      .map(
        (e) => TaskCustomFieldDefinitionValueResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>)
      .map(
        (e) =>
            TaskAcceptanceCriterionResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  dependencies: (json['dependencies'] as List<dynamic>)
      .map(
        (e) =>
            TaskDependencyDetailsResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  watchers: (json['watchers'] as List<dynamic>)
      .map((e) => TaskWatcherResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  isWatchedByMe: json['isWatchedByMe'] as bool,
  isPinnedByMe: json['isPinnedByMe'] as bool,
  subtasks: (json['subtasks'] as List<dynamic>)
      .map(
        (e) => ProjectTaskSubtaskSummaryResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  workflow: ProjectTaskWorkflowResponse.fromJson(
    json['workflow'] as Map<String, dynamic>,
  ),
  includedUsers: (json['includedUsers'] as List<dynamic>)
      .map((e) => UserReferenceResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProjectTaskDetailsResponseToJson(
  _ProjectTaskDetailsResponse instance,
) => <String, dynamic>{
  'task': instance.task,
  'labels': instance.labels,
  'customFields': instance.customFields,
  'acceptanceCriteria': instance.acceptanceCriteria,
  'dependencies': instance.dependencies,
  'watchers': instance.watchers,
  'isWatchedByMe': instance.isWatchedByMe,
  'isPinnedByMe': instance.isPinnedByMe,
  'subtasks': instance.subtasks,
  'workflow': instance.workflow,
  'includedUsers': instance.includedUsers,
};

_UserReferenceResponse _$UserReferenceResponseFromJson(
  Map<String, dynamic> json,
) => _UserReferenceResponse(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$UserReferenceResponseToJson(
  _UserReferenceResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'isActive': instance.isActive,
};

_TaskCustomFieldDefinitionValueResponse
_$TaskCustomFieldDefinitionValueResponseFromJson(Map<String, dynamic> json) =>
    _TaskCustomFieldDefinitionValueResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$TaskCustomFieldTypeEnumMap, json['type']),
      isRequired: json['required'] as bool,
      position: (json['position'] as num).toInt(),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      value: json['value'],
      valueUpdatedAtUtc: json['valueUpdatedAtUtc'] == null
          ? null
          : DateTime.parse(json['valueUpdatedAtUtc'] as String),
    );

Map<String, dynamic> _$TaskCustomFieldDefinitionValueResponseToJson(
  _TaskCustomFieldDefinitionValueResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$TaskCustomFieldTypeEnumMap[instance.type]!,
  'required': instance.isRequired,
  'position': instance.position,
  'options': instance.options,
  'value': instance.value,
  'valueUpdatedAtUtc': instance.valueUpdatedAtUtc?.toIso8601String(),
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

_TaskDependencyDetailsResponse _$TaskDependencyDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _TaskDependencyDetailsResponse(
  id: json['id'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  targetTaskId: json['targetTaskId'] as String,
  type: $enumDecode(_$TaskDependencyTypeEnumMap, json['type']),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  relatedTask: ProjectTaskReferenceResponse.fromJson(
    json['relatedTask'] as Map<String, dynamic>,
  ),
  dependencyKind:
      $enumDecodeNullable(
        _$TaskDependencyKindEnumMap,
        json['dependencyKind'],
      ) ??
      TaskDependencyKind.finishToStart,
  lagDays: (json['lagDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TaskDependencyDetailsResponseToJson(
  _TaskDependencyDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceTaskId': instance.sourceTaskId,
  'targetTaskId': instance.targetTaskId,
  'type': _$TaskDependencyTypeEnumMap[instance.type]!,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'relatedTask': instance.relatedTask,
  'dependencyKind': _$TaskDependencyKindEnumMap[instance.dependencyKind]!,
  'lagDays': instance.lagDays,
};

_ProjectTaskReferenceResponse _$ProjectTaskReferenceResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskReferenceResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  title: json['title'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  archivedAtUtc: json['archivedAtUtc'] == null
      ? null
      : DateTime.parse(json['archivedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectTaskReferenceResponseToJson(
  _ProjectTaskReferenceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'title': instance.title,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
  'version': instance.version,
};

_ProjectTaskSubtaskSummaryResponse _$ProjectTaskSubtaskSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskSubtaskSummaryResponse(
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

Map<String, dynamic> _$ProjectTaskSubtaskSummaryResponseToJson(
  _ProjectTaskSubtaskSummaryResponse instance,
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
