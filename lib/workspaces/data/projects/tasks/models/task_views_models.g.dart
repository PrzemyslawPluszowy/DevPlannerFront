// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_views_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskSavedViewFilter _$TaskSavedViewFilterFromJson(Map<String, dynamic> json) =>
    _TaskSavedViewFilter(
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ProjectTaskStatusEnumMap, e))
          .toList(),
      priorities: (json['priorities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$TaskPriorityEnumMap, e))
          .toList(),
      assigneeUserIds: (json['assigneeUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      labelIds: (json['labelIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      parentTaskId: json['parentTaskId'] as String?,
      myInvolvement: $enumDecodeNullable(
        _$TaskInvolvementFilterEnumMap,
        json['myInvolvement'],
      ),
      dueFromUtc: json['dueFromUtc'] == null
          ? null
          : DateTime.parse(json['dueFromUtc'] as String),
      dueToUtc: json['dueToUtc'] == null
          ? null
          : DateTime.parse(json['dueToUtc'] as String),
      search: json['search'] as String?,
      includeArchived: json['includeArchived'] as bool? ?? false,
      pinnedOnly: json['pinnedOnly'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskSavedViewFilterToJson(
  _TaskSavedViewFilter instance,
) => <String, dynamic>{
  'statuses': instance.statuses
      ?.map((e) => _$ProjectTaskStatusEnumMap[e]!)
      .toList(),
  'priorities': instance.priorities
      ?.map((e) => _$TaskPriorityEnumMap[e]!)
      .toList(),
  'assigneeUserIds': instance.assigneeUserIds,
  'labelIds': instance.labelIds,
  'parentTaskId': instance.parentTaskId,
  'myInvolvement': _$TaskInvolvementFilterEnumMap[instance.myInvolvement],
  'dueFromUtc': instance.dueFromUtc?.toIso8601String(),
  'dueToUtc': instance.dueToUtc?.toIso8601String(),
  'search': instance.search,
  'includeArchived': instance.includeArchived,
  'pinnedOnly': instance.pinnedOnly,
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

const _$TaskInvolvementFilterEnumMap = {
  TaskInvolvementFilter.any: 'Any',
  TaskInvolvementFilter.primaryAssignee: 'PrimaryAssignee',
  TaskInvolvementFilter.collaborator: 'Collaborator',
  TaskInvolvementFilter.assignee: 'Assignee',
  TaskInvolvementFilter.watcher: 'Watcher',
};

_TaskSavedViewDefinition _$TaskSavedViewDefinitionFromJson(
  Map<String, dynamic> json,
) => _TaskSavedViewDefinition(
  filter: TaskSavedViewFilter.fromJson(json['filter'] as Map<String, dynamic>),
  sortField: $enumDecode(_$TaskSavedViewSortFieldEnumMap, json['sortField']),
  sortDirection: $enumDecode(
    _$TaskSavedViewSortDirectionEnumMap,
    json['sortDirection'],
  ),
  groupBy: $enumDecode(_$TaskSavedViewGroupByEnumMap, json['groupBy']),
  columns: (json['columns'] as List<dynamic>)
      .map((e) => $enumDecode(_$TaskSavedViewColumnEnumMap, e))
      .toList(),
  customFieldIds:
      (json['customFieldIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  columnOrder: (json['columnOrder'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TaskSavedViewDefinitionToJson(
  _TaskSavedViewDefinition instance,
) => <String, dynamic>{
  'filter': instance.filter,
  'sortField': _$TaskSavedViewSortFieldEnumMap[instance.sortField]!,
  'sortDirection': _$TaskSavedViewSortDirectionEnumMap[instance.sortDirection]!,
  'groupBy': _$TaskSavedViewGroupByEnumMap[instance.groupBy]!,
  'columns': instance.columns
      .map((e) => _$TaskSavedViewColumnEnumMap[e]!)
      .toList(),
  'customFieldIds': instance.customFieldIds,
  'columnOrder': instance.columnOrder,
};

const _$TaskSavedViewSortFieldEnumMap = {
  TaskSavedViewSortField.position: 'Position',
  TaskSavedViewSortField.updatedAtUtc: 'UpdatedAtUtc',
  TaskSavedViewSortField.dueAtUtc: 'DueAtUtc',
  TaskSavedViewSortField.priority: 'Priority',
  TaskSavedViewSortField.title: 'Title',
};

const _$TaskSavedViewSortDirectionEnumMap = {
  TaskSavedViewSortDirection.ascending: 'Ascending',
  TaskSavedViewSortDirection.descending: 'Descending',
};

const _$TaskSavedViewGroupByEnumMap = {
  TaskSavedViewGroupBy.none: 'None',
  TaskSavedViewGroupBy.status: 'Status',
  TaskSavedViewGroupBy.customStatus: 'CustomStatus',
  TaskSavedViewGroupBy.priority: 'Priority',
  TaskSavedViewGroupBy.assignee: 'Assignee',
};

const _$TaskSavedViewColumnEnumMap = {
  TaskSavedViewColumn.key: 'Key',
  TaskSavedViewColumn.title: 'Title',
  TaskSavedViewColumn.status: 'Status',
  TaskSavedViewColumn.customStatus: 'CustomStatus',
  TaskSavedViewColumn.priority: 'Priority',
  TaskSavedViewColumn.assignees: 'Assignees',
  TaskSavedViewColumn.owner: 'Owner',
  TaskSavedViewColumn.collaborators: 'Collaborators',
  TaskSavedViewColumn.labels: 'Labels',
  TaskSavedViewColumn.watchers: 'Watchers',
  TaskSavedViewColumn.startAtUtc: 'StartAtUtc',
  TaskSavedViewColumn.dueAtUtc: 'DueAtUtc',
  TaskSavedViewColumn.checklistProgress: 'ChecklistProgress',
  TaskSavedViewColumn.updatedAtUtc: 'UpdatedAtUtc',
  TaskSavedViewColumn.createdAtUtc: 'CreatedAtUtc',
  TaskSavedViewColumn.taskType: 'TaskType',
  TaskSavedViewColumn.size: 'Size',
  TaskSavedViewColumn.complexity: 'Complexity',
  TaskSavedViewColumn.risk: 'Risk',
  TaskSavedViewColumn.businessValue: 'BusinessValue',
  TaskSavedViewColumn.estimatedMinutes: 'EstimatedMinutes',
  TaskSavedViewColumn.actualMinutes: 'ActualMinutes',
  TaskSavedViewColumn.milestone: 'Milestone',
};

_CreateTaskSavedViewPayload _$CreateTaskSavedViewPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskSavedViewPayload(
  name: json['name'] as String,
  view: TaskSavedViewDefinition.fromJson(json['view'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateTaskSavedViewPayloadToJson(
  _CreateTaskSavedViewPayload instance,
) => <String, dynamic>{'name': instance.name, 'view': instance.view};

_UpdateTaskSavedViewPayload _$UpdateTaskSavedViewPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskSavedViewPayload(
  name: json['name'] as String,
  view: TaskSavedViewDefinition.fromJson(json['view'] as Map<String, dynamic>),
  expectedVersion: (json['expectedVersion'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateTaskSavedViewPayloadToJson(
  _UpdateTaskSavedViewPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'view': instance.view,
  'expectedVersion': instance.expectedVersion,
};

_TaskSavedViewResponse _$TaskSavedViewResponseFromJson(
  Map<String, dynamic> json,
) => _TaskSavedViewResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  view: TaskSavedViewDefinition.fromJson(json['view'] as Map<String, dynamic>),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$TaskSavedViewResponseToJson(
  _TaskSavedViewResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'view': instance.view,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_MyTaskListItemResponse _$MyTaskListItemResponseFromJson(
  Map<String, dynamic> json,
) => _MyTaskListItemResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  workspaceId: json['workspaceId'] as String,
  workspaceName: json['workspaceName'] as String,
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String,
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
  involvement: $enumDecode(_$TaskInvolvementFilterEnumMap, json['involvement']),
  checklistCompletedCount: (json['checklistCompletedCount'] as num).toInt(),
  checklistTotalCount: (json['checklistTotalCount'] as num).toInt(),
  isPinned: json['isPinned'] as bool,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$MyTaskListItemResponseToJson(
  _MyTaskListItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'workspaceId': instance.workspaceId,
  'workspaceName': instance.workspaceName,
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'parentTaskId': instance.parentTaskId,
  'title': instance.title,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'involvement': _$TaskInvolvementFilterEnumMap[instance.involvement]!,
  'checklistCompletedCount': instance.checklistCompletedCount,
  'checklistTotalCount': instance.checklistTotalCount,
  'isPinned': instance.isPinned,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_GlobalTaskSearchItemResponse _$GlobalTaskSearchItemResponseFromJson(
  Map<String, dynamic> json,
) => _GlobalTaskSearchItemResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  workspaceId: json['workspaceId'] as String,
  workspaceName: json['workspaceName'] as String,
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String,
  parentTaskId: json['parentTaskId'] as String?,
  title: json['title'] as String,
  descriptionPreview: json['descriptionPreview'] as String?,
  titleHighlight: json['titleHighlight'] as String?,
  descriptionHighlight: json['descriptionHighlight'] as String?,
  matchedLabels: (json['matchedLabels'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  score: (json['score'] as num).toDouble(),
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  startAtUtc: json['startAtUtc'] == null
      ? null
      : DateTime.parse(json['startAtUtc'] as String),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$GlobalTaskSearchItemResponseToJson(
  _GlobalTaskSearchItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'workspaceId': instance.workspaceId,
  'workspaceName': instance.workspaceName,
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'parentTaskId': instance.parentTaskId,
  'title': instance.title,
  'descriptionPreview': instance.descriptionPreview,
  'titleHighlight': instance.titleHighlight,
  'descriptionHighlight': instance.descriptionHighlight,
  'matchedLabels': instance.matchedLabels,
  'score': instance.score,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};
