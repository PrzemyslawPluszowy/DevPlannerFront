// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanban_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KanbanCardLabelResponse _$KanbanCardLabelResponseFromJson(
  Map<String, dynamic> json,
) => _KanbanCardLabelResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  color: json['color'] as String,
);

Map<String, dynamic> _$KanbanCardLabelResponseToJson(
  _KanbanCardLabelResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
};

_KanbanCardCustomFieldResponse _$KanbanCardCustomFieldResponseFromJson(
  Map<String, dynamic> json,
) => _KanbanCardCustomFieldResponse(
  fieldId: json['fieldId'] as String,
  name: json['name'] as String,
  valueJson: json['valueJson'] as String,
);

Map<String, dynamic> _$KanbanCardCustomFieldResponseToJson(
  _KanbanCardCustomFieldResponse instance,
) => <String, dynamic>{
  'fieldId': instance.fieldId,
  'name': instance.name,
  'valueJson': instance.valueJson,
};

_KanbanTaskCardResponse _$KanbanTaskCardResponseFromJson(
  Map<String, dynamic> json,
) => _KanbanTaskCardResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  taskCode: json['taskCode'] as String,
  title: json['title'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  position: (json['position'] as num).toInt(),
  primaryAssigneeUserId: json['primaryAssigneeUserId'] as String?,
  milestoneId: json['milestoneId'] as String?,
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  checklistTotal: (json['checklistTotal'] as num).toInt(),
  checklistCompleted: (json['checklistCompleted'] as num).toInt(),
  attachmentCount: (json['attachmentCount'] as num).toInt(),
  version: (json['version'] as num).toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
  loggedMinutes: (json['loggedMinutes'] as num?)?.toInt(),
  subtaskTotal: (json['subtaskTotal'] as num?)?.toInt() ?? 0,
  subtaskCompleted: (json['subtaskCompleted'] as num?)?.toInt() ?? 0,
  isBlocked: json['isBlocked'] as bool? ?? false,
  blockedByTaskIds: (json['blockedByTaskIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  labels: (json['labels'] as List<dynamic>?)
      ?.map((e) => KanbanCardLabelResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  customFieldsSummary: (json['customFieldsSummary'] as List<dynamic>?)
      ?.map(
        (e) =>
            KanbanCardCustomFieldResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  coverAttachmentId: json['coverAttachmentId'] as String?,
  customStatusId: json['customStatusId'] as String?,
  recurrence: json['recurrence'] == null
      ? null
      : TaskRecurrenceSummaryResponse.fromJson(
          json['recurrence'] as Map<String, dynamic>,
        ),
  isPinned: json['isPinned'] as bool? ?? false,
  watcherCount: (json['watcherCount'] as num?)?.toInt() ?? 0,
  isWatchedByMe: json['isWatchedByMe'] as bool? ?? false,
);

Map<String, dynamic> _$KanbanTaskCardResponseToJson(
  _KanbanTaskCardResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'taskCode': instance.taskCode,
  'title': instance.title,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'position': instance.position,
  'primaryAssigneeUserId': instance.primaryAssigneeUserId,
  'milestoneId': instance.milestoneId,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'checklistTotal': instance.checklistTotal,
  'checklistCompleted': instance.checklistCompleted,
  'attachmentCount': instance.attachmentCount,
  'version': instance.version,
  'estimatedMinutes': instance.estimatedMinutes,
  'loggedMinutes': instance.loggedMinutes,
  'subtaskTotal': instance.subtaskTotal,
  'subtaskCompleted': instance.subtaskCompleted,
  'isBlocked': instance.isBlocked,
  'blockedByTaskIds': instance.blockedByTaskIds,
  'labels': instance.labels,
  'customFieldsSummary': instance.customFieldsSummary,
  'coverAttachmentId': instance.coverAttachmentId,
  'customStatusId': instance.customStatusId,
  'recurrence': instance.recurrence,
  'isPinned': instance.isPinned,
  'watcherCount': instance.watcherCount,
  'isWatchedByMe': instance.isWatchedByMe,
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

_KanbanColumnResponse _$KanbanColumnResponseFromJson(
  Map<String, dynamic> json,
) => _KanbanColumnResponse(
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  displayName: json['displayName'] as String,
  color: json['color'] as String,
  wipLimit: (json['wipLimit'] as num?)?.toInt(),
  totalTaskCount: (json['totalTaskCount'] as num).toInt(),
  isWipLimitExceeded: json['isWipLimitExceeded'] as bool,
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => KanbanTaskCardResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['nextCursor'] as String?,
  customStatusId: json['customStatusId'] as String?,
);

Map<String, dynamic> _$KanbanColumnResponseToJson(
  _KanbanColumnResponse instance,
) => <String, dynamic>{
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'displayName': instance.displayName,
  'color': instance.color,
  'wipLimit': instance.wipLimit,
  'totalTaskCount': instance.totalTaskCount,
  'isWipLimitExceeded': instance.isWipLimitExceeded,
  'tasks': instance.tasks,
  'nextCursor': instance.nextCursor,
  'customStatusId': instance.customStatusId,
};

_KanbanBoardResponse _$KanbanBoardResponseFromJson(Map<String, dynamic> json) =>
    _KanbanBoardResponse(
      projectId: json['projectId'] as String,
      swimlaneMode: $enumDecode(
        _$KanbanSwimlaneModeEnumMap,
        json['swimlaneMode'],
      ),
      settingsVersion: (json['settingsVersion'] as num).toInt(),
      hiddenColumns: (json['hiddenColumns'] as List<dynamic>)
          .map((e) => $enumDecode(_$ProjectTaskStatusEnumMap, e))
          .toList(),
      visibleCardFields: (json['visibleCardFields'] as List<dynamic>)
          .map((e) => $enumDecode(_$KanbanCardFieldEnumMap, e))
          .toList(),
      defaultCardDensity: $enumDecode(
        _$KanbanCardDensityEnumMap,
        json['defaultCardDensity'],
      ),
      columns: (json['columns'] as List<dynamic>)
          .map((e) => KanbanColumnResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KanbanBoardResponseToJson(
  _KanbanBoardResponse instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'swimlaneMode': _$KanbanSwimlaneModeEnumMap[instance.swimlaneMode]!,
  'settingsVersion': instance.settingsVersion,
  'hiddenColumns': instance.hiddenColumns
      .map((e) => _$ProjectTaskStatusEnumMap[e]!)
      .toList(),
  'visibleCardFields': instance.visibleCardFields
      .map((e) => _$KanbanCardFieldEnumMap[e]!)
      .toList(),
  'defaultCardDensity':
      _$KanbanCardDensityEnumMap[instance.defaultCardDensity]!,
  'columns': instance.columns,
};

const _$KanbanSwimlaneModeEnumMap = {
  KanbanSwimlaneMode.none: 'None',
  KanbanSwimlaneMode.assignee: 'Assignee',
  KanbanSwimlaneMode.priority: 'Priority',
  KanbanSwimlaneMode.milestone: 'Milestone',
};

const _$KanbanCardFieldEnumMap = {
  KanbanCardField.assignee: 'Assignee',
  KanbanCardField.dueDate: 'DueDate',
  KanbanCardField.labels: 'Labels',
  KanbanCardField.checklist: 'Checklist',
  KanbanCardField.subtasks: 'Subtasks',
  KanbanCardField.timeTracking: 'TimeTracking',
  KanbanCardField.blockers: 'Blockers',
  KanbanCardField.coverAttachment: 'CoverAttachment',
  KanbanCardField.customFields: 'CustomFields',
};

const _$KanbanCardDensityEnumMap = {
  KanbanCardDensity.compact: 'Compact',
  KanbanCardDensity.comfortable: 'Comfortable',
  KanbanCardDensity.detailed: 'Detailed',
};

_MoveKanbanTaskPayload _$MoveKanbanTaskPayloadFromJson(
  Map<String, dynamic> json,
) => _MoveKanbanTaskPayload(
  targetStatus: $enumDecode(_$ProjectTaskStatusEnumMap, json['targetStatus']),
  previousTaskId: json['previousTaskId'] as String?,
  nextTaskId: json['nextTaskId'] as String?,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  customStatusId: json['customStatusId'] as String?,
);

Map<String, dynamic> _$MoveKanbanTaskPayloadToJson(
  _MoveKanbanTaskPayload instance,
) => <String, dynamic>{
  'targetStatus': _$ProjectTaskStatusEnumMap[instance.targetStatus]!,
  'previousTaskId': instance.previousTaskId,
  'nextTaskId': instance.nextTaskId,
  'expectedVersion': instance.expectedVersion,
  'customStatusId': instance.customStatusId,
};

_MoveKanbanTaskResponse _$MoveKanbanTaskResponseFromJson(
  Map<String, dynamic> json,
) => _MoveKanbanTaskResponse(
  task: KanbanTaskCardResponse.fromJson(json['task'] as Map<String, dynamic>),
  targetColumnTaskCount: (json['targetColumnTaskCount'] as num).toInt(),
  targetColumnWipLimit: (json['targetColumnWipLimit'] as num?)?.toInt(),
  isWipLimitExceeded: json['isWipLimitExceeded'] as bool,
);

Map<String, dynamic> _$MoveKanbanTaskResponseToJson(
  _MoveKanbanTaskResponse instance,
) => <String, dynamic>{
  'task': instance.task,
  'targetColumnTaskCount': instance.targetColumnTaskCount,
  'targetColumnWipLimit': instance.targetColumnWipLimit,
  'isWipLimitExceeded': instance.isWipLimitExceeded,
};

_BulkMoveKanbanTaskItemPayload _$BulkMoveKanbanTaskItemPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkMoveKanbanTaskItemPayload(
  taskId: json['taskId'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$BulkMoveKanbanTaskItemPayloadToJson(
  _BulkMoveKanbanTaskItemPayload instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'expectedVersion': instance.expectedVersion,
};

_BulkMoveKanbanTasksPayload _$BulkMoveKanbanTasksPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkMoveKanbanTasksPayload(
  targetStatus: $enumDecode(_$ProjectTaskStatusEnumMap, json['targetStatus']),
  tasks: (json['tasks'] as List<dynamic>)
      .map(
        (e) =>
            BulkMoveKanbanTaskItemPayload.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  customStatusId: json['customStatusId'] as String?,
);

Map<String, dynamic> _$BulkMoveKanbanTasksPayloadToJson(
  _BulkMoveKanbanTasksPayload instance,
) => <String, dynamic>{
  'targetStatus': _$ProjectTaskStatusEnumMap[instance.targetStatus]!,
  'tasks': instance.tasks,
  'customStatusId': instance.customStatusId,
};

_BulkMoveKanbanTasksResponse _$BulkMoveKanbanTasksResponseFromJson(
  Map<String, dynamic> json,
) => _BulkMoveKanbanTasksResponse(
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => KanbanTaskCardResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  targetColumnTaskCount: (json['targetColumnTaskCount'] as num).toInt(),
  targetColumnWipLimit: (json['targetColumnWipLimit'] as num?)?.toInt(),
  isWipLimitExceeded: json['isWipLimitExceeded'] as bool,
);

Map<String, dynamic> _$BulkMoveKanbanTasksResponseToJson(
  _BulkMoveKanbanTasksResponse instance,
) => <String, dynamic>{
  'tasks': instance.tasks,
  'targetColumnTaskCount': instance.targetColumnTaskCount,
  'targetColumnWipLimit': instance.targetColumnWipLimit,
  'isWipLimitExceeded': instance.isWipLimitExceeded,
};

_BulkUpdateKanbanTaskItemPayload _$BulkUpdateKanbanTaskItemPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkUpdateKanbanTaskItemPayload(
  taskId: json['taskId'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$BulkUpdateKanbanTaskItemPayloadToJson(
  _BulkUpdateKanbanTaskItemPayload instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'expectedVersion': instance.expectedVersion,
};

_BulkUpdateKanbanTasksPayload _$BulkUpdateKanbanTasksPayloadFromJson(
  Map<String, dynamic> json,
) => _BulkUpdateKanbanTasksPayload(
  tasks: (json['tasks'] as List<dynamic>)
      .map(
        (e) =>
            BulkUpdateKanbanTaskItemPayload.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  assigneeIds: (json['assigneeIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  labelIds: (json['labelIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$BulkUpdateKanbanTasksPayloadToJson(
  _BulkUpdateKanbanTasksPayload instance,
) => <String, dynamic>{
  'tasks': instance.tasks,
  'priority': _$TaskPriorityEnumMap[instance.priority],
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'assigneeIds': instance.assigneeIds,
  'labelIds': instance.labelIds,
};

_BulkUpdateKanbanTasksResponse _$BulkUpdateKanbanTasksResponseFromJson(
  Map<String, dynamic> json,
) => _BulkUpdateKanbanTasksResponse(
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => KanbanTaskCardResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  updatedCount: (json['updatedCount'] as num).toInt(),
);

Map<String, dynamic> _$BulkUpdateKanbanTasksResponseToJson(
  _BulkUpdateKanbanTasksResponse instance,
) => <String, dynamic>{
  'tasks': instance.tasks,
  'updatedCount': instance.updatedCount,
};

_UpdateProjectKanbanSettingsPayload
_$UpdateProjectKanbanSettingsPayloadFromJson(Map<String, dynamic> json) =>
    _UpdateProjectKanbanSettingsPayload(
      swimlaneMode: $enumDecode(
        _$KanbanSwimlaneModeEnumMap,
        json['swimlaneMode'],
      ),
      columnWipLimits: Map<String, int>.from(json['columnWipLimits'] as Map),
      hiddenColumns: (json['hiddenColumns'] as List<dynamic>)
          .map((e) => $enumDecode(_$ProjectTaskStatusEnumMap, e))
          .toList(),
      expectedVersion: (json['expectedVersion'] as num).toInt(),
      visibleCardFields: (json['visibleCardFields'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$KanbanCardFieldEnumMap, e))
          .toList(),
      defaultCardDensity:
          $enumDecodeNullable(
            _$KanbanCardDensityEnumMap,
            json['defaultCardDensity'],
          ) ??
          KanbanCardDensity.comfortable,
    );

Map<String, dynamic> _$UpdateProjectKanbanSettingsPayloadToJson(
  _UpdateProjectKanbanSettingsPayload instance,
) => <String, dynamic>{
  'swimlaneMode': _$KanbanSwimlaneModeEnumMap[instance.swimlaneMode]!,
  'columnWipLimits': instance.columnWipLimits,
  'hiddenColumns': instance.hiddenColumns
      .map((e) => _$ProjectTaskStatusEnumMap[e]!)
      .toList(),
  'expectedVersion': instance.expectedVersion,
  'visibleCardFields': instance.visibleCardFields
      ?.map((e) => _$KanbanCardFieldEnumMap[e]!)
      .toList(),
  'defaultCardDensity':
      _$KanbanCardDensityEnumMap[instance.defaultCardDensity]!,
};

_ProjectKanbanSettingsResponse _$ProjectKanbanSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectKanbanSettingsResponse(
  projectId: json['projectId'] as String,
  swimlaneMode: $enumDecode(_$KanbanSwimlaneModeEnumMap, json['swimlaneMode']),
  columnWipLimits: Map<String, int>.from(json['columnWipLimits'] as Map),
  hiddenColumns: (json['hiddenColumns'] as List<dynamic>)
      .map((e) => $enumDecode(_$ProjectTaskStatusEnumMap, e))
      .toList(),
  visibleCardFields: (json['visibleCardFields'] as List<dynamic>)
      .map((e) => $enumDecode(_$KanbanCardFieldEnumMap, e))
      .toList(),
  defaultCardDensity: $enumDecode(
    _$KanbanCardDensityEnumMap,
    json['defaultCardDensity'],
  ),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectKanbanSettingsResponseToJson(
  _ProjectKanbanSettingsResponse instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'swimlaneMode': _$KanbanSwimlaneModeEnumMap[instance.swimlaneMode]!,
  'columnWipLimits': instance.columnWipLimits,
  'hiddenColumns': instance.hiddenColumns
      .map((e) => _$ProjectTaskStatusEnumMap[e]!)
      .toList(),
  'visibleCardFields': instance.visibleCardFields
      .map((e) => _$KanbanCardFieldEnumMap[e]!)
      .toList(),
  'defaultCardDensity':
      _$KanbanCardDensityEnumMap[instance.defaultCardDensity]!,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_UpdateUserKanbanPreferencePayload _$UpdateUserKanbanPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateUserKanbanPreferencePayload(
  collapsedColumns: (json['collapsedColumns'] as List<dynamic>)
      .map((e) => $enumDecode(_$ProjectTaskStatusEnumMap, e))
      .toList(),
  quickFilter: $enumDecode(_$KanbanQuickFilterEnumMap, json['quickFilter']),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
  collapsedCustomStatusIds: (json['collapsedCustomStatusIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpdateUserKanbanPreferencePayloadToJson(
  _UpdateUserKanbanPreferencePayload instance,
) => <String, dynamic>{
  'collapsedColumns': instance.collapsedColumns
      .map((e) => _$ProjectTaskStatusEnumMap[e]!)
      .toList(),
  'quickFilter': _$KanbanQuickFilterEnumMap[instance.quickFilter]!,
  'expectedVersion': instance.expectedVersion,
  'collapsedCustomStatusIds': instance.collapsedCustomStatusIds,
};

const _$KanbanQuickFilterEnumMap = {
  KanbanQuickFilter.all: 'All',
  KanbanQuickFilter.mine: 'Mine',
  KanbanQuickFilter.unassigned: 'Unassigned',
  KanbanQuickFilter.blocked: 'Blocked',
  KanbanQuickFilter.dueSoon: 'DueSoon',
};

_UserKanbanPreferenceResponse _$UserKanbanPreferenceResponseFromJson(
  Map<String, dynamic> json,
) => _UserKanbanPreferenceResponse(
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  userId: json['userId'] as String,
  collapsedColumns: (json['collapsedColumns'] as List<dynamic>)
      .map((e) => $enumDecode(_$ProjectTaskStatusEnumMap, e))
      .toList(),
  quickFilter: $enumDecode(_$KanbanQuickFilterEnumMap, json['quickFilter']),
  updatedAtUtc: json['updatedAtUtc'] == null
      ? null
      : DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
  collapsedCustomStatusIds: (json['collapsedCustomStatusIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserKanbanPreferenceResponseToJson(
  _UserKanbanPreferenceResponse instance,
) => <String, dynamic>{
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'userId': instance.userId,
  'collapsedColumns': instance.collapsedColumns
      .map((e) => _$ProjectTaskStatusEnumMap[e]!)
      .toList(),
  'quickFilter': _$KanbanQuickFilterEnumMap[instance.quickFilter]!,
  'updatedAtUtc': instance.updatedAtUtc?.toIso8601String(),
  'version': instance.version,
  'collapsedCustomStatusIds': instance.collapsedCustomStatusIds,
};
