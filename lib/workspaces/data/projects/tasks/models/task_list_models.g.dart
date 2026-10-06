// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
  tasks: (json['tasks'] as List<dynamic>?)
      ?.map(
        (e) => BulkUpdateTaskItemPayload.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  status: $enumDecodeNullable(_$ProjectTaskStatusEnumMap, json['status']),
  customStatusId: json['customStatusId'] as String?,
  clearCustomStatus: json['clearCustomStatus'] as bool? ?? false,
  priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  calendarTimeZoneId: json['calendarTimeZoneId'] as String?,
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
  'tasks': ?instance.tasks,
  'status': _$ProjectTaskStatusEnumMap[instance.status],
  'customStatusId': instance.customStatusId,
  'clearCustomStatus': instance.clearCustomStatus,
  'priority': _$TaskPriorityEnumMap[instance.priority],
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'calendarTimeZoneId': ?instance.calendarTimeZoneId,
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
  calendarTimeZoneId: json['calendarTimeZoneId'] as String?,
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
  'calendarTimeZoneId': ?instance.calendarTimeZoneId,
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

_BulkUpdateTaskItemPayload _$BulkUpdateTaskItemPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkUpdateTaskItemPayload(
  taskId: json['taskId'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$BulkUpdateTaskItemPayloadToJson(
  _BulkUpdateTaskItemPayload instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'expectedVersion': instance.expectedVersion,
};
