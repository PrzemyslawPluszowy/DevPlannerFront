// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_setup_request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectSetupSourceRequest _$ProjectSetupSourceRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupSourceRequest(
  kind: $enumDecode(_$ProjectSetupSourceKindEnumMap, json['kind']),
  templateId: json['templateId'] as String?,
  expectedVersion: (json['expectedVersion'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProjectSetupSourceRequestToJson(
  _ProjectSetupSourceRequest instance,
) => <String, dynamic>{
  'kind': _$ProjectSetupSourceKindEnumMap[instance.kind]!,
  'templateId': instance.templateId,
  'expectedVersion': instance.expectedVersion,
};

const _$ProjectSetupSourceKindEnumMap = {
  ProjectSetupSourceKind.blank: 'Blank',
  ProjectSetupSourceKind.projectTemplate: 'ProjectTemplate',
};

_ProjectSetupProjectRequest _$ProjectSetupProjectRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupProjectRequest(
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
  visibility: $enumDecodeNullable(
    _$ProjectVisibilityEnumMap,
    json['visibility'],
  ),
  status: $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']),
);

Map<String, dynamic> _$ProjectSetupProjectRequestToJson(
  _ProjectSetupProjectRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
  'visibility': _$ProjectVisibilityEnumMap[instance.visibility],
  'status': _$ProjectStatusEnumMap[instance.status],
};

const _$ProjectVisibilityEnumMap = {
  ProjectVisibility.shared: 'Shared',
  ProjectVisibility.private: 'Private',
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.planned: 'Planned',
  ProjectStatus.active: 'Active',
  ProjectStatus.onHold: 'OnHold',
  ProjectStatus.completed: 'Completed',
};

_ProjectSetupMemberAssignmentRequest
_$ProjectSetupMemberAssignmentRequestFromJson(Map<String, dynamic> json) =>
    _ProjectSetupMemberAssignmentRequest(
      userId: json['userId'] as String,
      role: $enumDecode(_$ProjectRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$ProjectSetupMemberAssignmentRequestToJson(
  _ProjectSetupMemberAssignmentRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'role': _$ProjectRoleEnumMap[instance.role]!,
};

const _$ProjectRoleEnumMap = {
  ProjectRole.owner: 'Owner',
  ProjectRole.admin: 'Admin',
  ProjectRole.member: 'Member',
  ProjectRole.observer: 'Observer',
};

_ProjectSetupWorkflowRequest _$ProjectSetupWorkflowRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupWorkflowRequest(
  kind: $enumDecode(_$ProjectSetupWorkflowKindEnumMap, json['kind']),
  templateKey: json['templateKey'] as String?,
  statuses: (json['statuses'] as List<dynamic>?)
      ?.map(
        (e) => ProjectSetupWorkflowStatusRequest.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$ProjectSetupWorkflowRequestToJson(
  _ProjectSetupWorkflowRequest instance,
) => <String, dynamic>{
  'kind': _$ProjectSetupWorkflowKindEnumMap[instance.kind]!,
  'templateKey': instance.templateKey,
  'statuses': instance.statuses,
};

const _$ProjectSetupWorkflowKindEnumMap = {
  ProjectSetupWorkflowKind.systemDefault: 'Default',
  ProjectSetupWorkflowKind.catalogTemplate: 'CatalogTemplate',
  ProjectSetupWorkflowKind.explicitStatuses: 'ExplicitStatuses',
};

_ProjectSetupWorkflowStatusRequest _$ProjectSetupWorkflowStatusRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupWorkflowStatusRequest(
  name: json['name'] as String,
  color: json['color'] as String,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
  wipLimit: (json['wipLimit'] as num?)?.toInt(),
  isDefault: json['isDefault'] as bool,
);

Map<String, dynamic> _$ProjectSetupWorkflowStatusRequestToJson(
  _ProjectSetupWorkflowStatusRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'color': instance.color,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
  'wipLimit': instance.wipLimit,
  'isDefault': instance.isDefault,
};

const _$TaskStatusCategoryEnumMap = {
  TaskStatusCategory.todo: 'Todo',
  TaskStatusCategory.inProgress: 'InProgress',
  TaskStatusCategory.done: 'Done',
  TaskStatusCategory.cancelled: 'Cancelled',
};

_ProjectSetupTaskViewRequest _$ProjectSetupTaskViewRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupTaskViewRequest(
  defaultView: $enumDecode(
    _$ProjectSetupTaskViewKindEnumMap,
    json['defaultView'],
  ),
  list: json['list'] == null
      ? null
      : ProjectSetupListSettingsRequest.fromJson(
          json['list'] as Map<String, dynamic>,
        ),
  board: json['board'] == null
      ? null
      : ProjectSetupBoardSettingsRequest.fromJson(
          json['board'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ProjectSetupTaskViewRequestToJson(
  _ProjectSetupTaskViewRequest instance,
) => <String, dynamic>{
  'defaultView': _$ProjectSetupTaskViewKindEnumMap[instance.defaultView]!,
  'list': instance.list,
  'board': instance.board,
};

const _$ProjectSetupTaskViewKindEnumMap = {
  ProjectSetupTaskViewKind.list: 'List',
  ProjectSetupTaskViewKind.board: 'Board',
};

_ProjectSetupListSettingsRequest _$ProjectSetupListSettingsRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupListSettingsRequest(
  defaultColumns: (json['defaultColumns'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  defaultSortField: $enumDecodeNullable(
    _$TaskSavedViewSortFieldEnumMap,
    json['defaultSortField'],
  ),
  defaultSortDirection: $enumDecodeNullable(
    _$TaskSavedViewSortDirectionEnumMap,
    json['defaultSortDirection'],
  ),
  defaultGroupBy: $enumDecodeNullable(
    _$TaskSavedViewGroupByEnumMap,
    json['defaultGroupBy'],
  ),
);

Map<String, dynamic> _$ProjectSetupListSettingsRequestToJson(
  _ProjectSetupListSettingsRequest instance,
) => <String, dynamic>{
  'defaultColumns': instance.defaultColumns,
  'defaultSortField':
      _$TaskSavedViewSortFieldEnumMap[instance.defaultSortField],
  'defaultSortDirection':
      _$TaskSavedViewSortDirectionEnumMap[instance.defaultSortDirection],
  'defaultGroupBy': _$TaskSavedViewGroupByEnumMap[instance.defaultGroupBy],
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

_ProjectSetupBoardSettingsRequest _$ProjectSetupBoardSettingsRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupBoardSettingsRequest(
  swimlaneMode: $enumDecodeNullable(
    _$KanbanSwimlaneModeEnumMap,
    json['swimlaneMode'],
  ),
  visibleCardFields: (json['visibleCardFields'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$KanbanCardFieldEnumMap, e))
      .toList(),
  defaultCardDensity: $enumDecodeNullable(
    _$KanbanCardDensityEnumMap,
    json['defaultCardDensity'],
  ),
);

Map<String, dynamic> _$ProjectSetupBoardSettingsRequestToJson(
  _ProjectSetupBoardSettingsRequest instance,
) => <String, dynamic>{
  'swimlaneMode': _$KanbanSwimlaneModeEnumMap[instance.swimlaneMode],
  'visibleCardFields': instance.visibleCardFields
      ?.map((e) => _$KanbanCardFieldEnumMap[e]!)
      .toList(),
  'defaultCardDensity': _$KanbanCardDensityEnumMap[instance.defaultCardDensity],
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

_ProjectSetupScheduleRequest _$ProjectSetupScheduleRequestFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupScheduleRequest(
  mode: $enumDecode(_$AutoScheduleModeEnumMap, json['mode']),
  defaultDailyCapacityMinutes: (json['defaultDailyCapacityMinutes'] as num?)
      ?.toInt(),
);

Map<String, dynamic> _$ProjectSetupScheduleRequestToJson(
  _ProjectSetupScheduleRequest instance,
) => <String, dynamic>{
  'mode': _$AutoScheduleModeEnumMap[instance.mode]!,
  'defaultDailyCapacityMinutes': instance.defaultDailyCapacityMinutes,
};

const _$AutoScheduleModeEnumMap = {
  AutoScheduleMode.manual: 'Manual',
  AutoScheduleMode.pushSuccessorsOnly: 'PushSuccessorsOnly',
  AutoScheduleMode.strictCascade: 'StrictCascade',
};

_CreateProjectSetupRequest _$CreateProjectSetupRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProjectSetupRequest(
  source: ProjectSetupSourceRequest.fromJson(
    json['source'] as Map<String, dynamic>,
  ),
  project: ProjectSetupProjectRequest.fromJson(
    json['project'] as Map<String, dynamic>,
  ),
  memberAssignments: (json['memberAssignments'] as List<dynamic>?)
      ?.map(
        (e) => ProjectSetupMemberAssignmentRequest.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  workflow: json['workflow'] == null
      ? null
      : ProjectSetupWorkflowRequest.fromJson(
          json['workflow'] as Map<String, dynamic>,
        ),
  taskView: json['taskView'] == null
      ? null
      : ProjectSetupTaskViewRequest.fromJson(
          json['taskView'] as Map<String, dynamic>,
        ),
  schedule: json['schedule'] == null
      ? null
      : ProjectSetupScheduleRequest.fromJson(
          json['schedule'] as Map<String, dynamic>,
        ),
  automationRecipeKeys: (json['automationRecipeKeys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CreateProjectSetupRequestToJson(
  _CreateProjectSetupRequest instance,
) => <String, dynamic>{
  'source': instance.source,
  'project': instance.project,
  'memberAssignments': instance.memberAssignments,
  'workflow': instance.workflow,
  'taskView': instance.taskView,
  'schedule': instance.schedule,
  'automationRecipeKeys': instance.automationRecipeKeys,
};
