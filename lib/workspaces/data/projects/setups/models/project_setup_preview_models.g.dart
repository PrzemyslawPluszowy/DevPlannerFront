// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_setup_preview_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectSetupWarningResponse _$ProjectSetupWarningResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupWarningResponse(
  code: json['code'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$ProjectSetupWarningResponseToJson(
  _ProjectSetupWarningResponse instance,
) => <String, dynamic>{'code': instance.code, 'message': instance.message};

_ProjectSetupMemberPreviewResponse _$ProjectSetupMemberPreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupMemberPreviewResponse(
  userId: json['userId'] as String,
  role: $enumDecode(_$ProjectRoleEnumMap, json['role']),
  isCreator: json['isCreator'] as bool,
);

Map<String, dynamic> _$ProjectSetupMemberPreviewResponseToJson(
  _ProjectSetupMemberPreviewResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'role': _$ProjectRoleEnumMap[instance.role]!,
  'isCreator': instance.isCreator,
};

const _$ProjectRoleEnumMap = {
  ProjectRole.owner: 'Owner',
  ProjectRole.admin: 'Admin',
  ProjectRole.member: 'Member',
  ProjectRole.observer: 'Observer',
};

_ProjectSetupTemplatePreviewResponse
_$ProjectSetupTemplatePreviewResponseFromJson(Map<String, dynamic> json) =>
    _ProjectSetupTemplatePreviewResponse(
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      version: (json['version'] as num).toInt(),
      taskCount: (json['taskCount'] as num).toInt(),
      labelCount: (json['labelCount'] as num).toInt(),
      customFieldCount: (json['customFieldCount'] as num).toInt(),
      customStatusCount: (json['customStatusCount'] as num).toInt(),
    );

Map<String, dynamic> _$ProjectSetupTemplatePreviewResponseToJson(
  _ProjectSetupTemplatePreviewResponse instance,
) => <String, dynamic>{
  'templateId': instance.templateId,
  'name': instance.name,
  'version': instance.version,
  'taskCount': instance.taskCount,
  'labelCount': instance.labelCount,
  'customFieldCount': instance.customFieldCount,
  'customStatusCount': instance.customStatusCount,
};

_ProjectSetupProjectPreviewResponse
_$ProjectSetupProjectPreviewResponseFromJson(Map<String, dynamic> json) =>
    _ProjectSetupProjectPreviewResponse(
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      primaryColor: json['primaryColor'] as String?,
      visibility: $enumDecode(_$ProjectVisibilityEnumMap, json['visibility']),
      status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
      inheritsWorkspaceMembers: json['inheritsWorkspaceMembers'] as bool,
      memberCount: (json['memberCount'] as num).toInt(),
      members: (json['members'] as List<dynamic>)
          .map(
            (e) => ProjectSetupMemberPreviewResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$ProjectSetupProjectPreviewResponseToJson(
  _ProjectSetupProjectPreviewResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
  'visibility': _$ProjectVisibilityEnumMap[instance.visibility]!,
  'status': _$ProjectStatusEnumMap[instance.status]!,
  'inheritsWorkspaceMembers': instance.inheritsWorkspaceMembers,
  'memberCount': instance.memberCount,
  'members': instance.members,
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

_ProjectSetupWorkflowStatusPreviewResponse
_$ProjectSetupWorkflowStatusPreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupWorkflowStatusPreviewResponse(
  name: json['name'] as String,
  color: json['color'] as String,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
  position: (json['position'] as num).toInt(),
  wipLimit: (json['wipLimit'] as num?)?.toInt(),
  isDefault: json['isDefault'] as bool,
);

Map<String, dynamic> _$ProjectSetupWorkflowStatusPreviewResponseToJson(
  _ProjectSetupWorkflowStatusPreviewResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'color': instance.color,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
  'position': instance.position,
  'wipLimit': instance.wipLimit,
  'isDefault': instance.isDefault,
};

const _$TaskStatusCategoryEnumMap = {
  TaskStatusCategory.todo: 'Todo',
  TaskStatusCategory.inProgress: 'InProgress',
  TaskStatusCategory.done: 'Done',
  TaskStatusCategory.cancelled: 'Cancelled',
};

_ProjectSetupWorkflowPreviewResponse
_$ProjectSetupWorkflowPreviewResponseFromJson(Map<String, dynamic> json) =>
    _ProjectSetupWorkflowPreviewResponse(
      kind: $enumDecode(_$ProjectSetupWorkflowKindEnumMap, json['kind']),
      templateKey: json['templateKey'] as String?,
      templateName: json['templateName'] as String?,
      systemStatusCount: (json['systemStatusCount'] as num).toInt(),
      customStatuses: (json['customStatuses'] as List<dynamic>)
          .map(
            (e) => ProjectSetupWorkflowStatusPreviewResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$ProjectSetupWorkflowPreviewResponseToJson(
  _ProjectSetupWorkflowPreviewResponse instance,
) => <String, dynamic>{
  'kind': _$ProjectSetupWorkflowKindEnumMap[instance.kind]!,
  'templateKey': instance.templateKey,
  'templateName': instance.templateName,
  'systemStatusCount': instance.systemStatusCount,
  'customStatuses': instance.customStatuses,
};

const _$ProjectSetupWorkflowKindEnumMap = {
  ProjectSetupWorkflowKind.systemDefault: 'Default',
  ProjectSetupWorkflowKind.catalogTemplate: 'CatalogTemplate',
  ProjectSetupWorkflowKind.explicitStatuses: 'ExplicitStatuses',
};

_ProjectSetupTaskViewPreviewResponse
_$ProjectSetupTaskViewPreviewResponseFromJson(Map<String, dynamic> json) =>
    _ProjectSetupTaskViewPreviewResponse(
      defaultView: $enumDecode(
        _$ProjectSetupTaskViewKindEnumMap,
        json['defaultView'],
      ),
      listDefaultColumns: (json['listDefaultColumns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      listSortField: json['listSortField'] as String,
      listSortDirection: json['listSortDirection'] as String,
      listGroupBy: json['listGroupBy'] as String,
      boardSwimlaneMode: $enumDecode(
        _$KanbanSwimlaneModeEnumMap,
        json['boardSwimlaneMode'],
      ),
      boardCardDensity: $enumDecode(
        _$KanbanCardDensityEnumMap,
        json['boardCardDensity'],
      ),
      boardVisibleCardFields: (json['boardVisibleCardFields'] as List<dynamic>)
          .map((e) => $enumDecode(_$KanbanCardFieldEnumMap, e))
          .toList(),
      boardWipLimitCount: (json['boardWipLimitCount'] as num).toInt(),
      boardHiddenColumnCount: (json['boardHiddenColumnCount'] as num).toInt(),
    );

Map<String, dynamic> _$ProjectSetupTaskViewPreviewResponseToJson(
  _ProjectSetupTaskViewPreviewResponse instance,
) => <String, dynamic>{
  'defaultView': _$ProjectSetupTaskViewKindEnumMap[instance.defaultView]!,
  'listDefaultColumns': instance.listDefaultColumns,
  'listSortField': instance.listSortField,
  'listSortDirection': instance.listSortDirection,
  'listGroupBy': instance.listGroupBy,
  'boardSwimlaneMode': _$KanbanSwimlaneModeEnumMap[instance.boardSwimlaneMode]!,
  'boardCardDensity': _$KanbanCardDensityEnumMap[instance.boardCardDensity]!,
  'boardVisibleCardFields': instance.boardVisibleCardFields
      .map((e) => _$KanbanCardFieldEnumMap[e]!)
      .toList(),
  'boardWipLimitCount': instance.boardWipLimitCount,
  'boardHiddenColumnCount': instance.boardHiddenColumnCount,
};

const _$ProjectSetupTaskViewKindEnumMap = {
  ProjectSetupTaskViewKind.list: 'List',
  ProjectSetupTaskViewKind.board: 'Board',
};

const _$KanbanSwimlaneModeEnumMap = {
  KanbanSwimlaneMode.none: 'None',
  KanbanSwimlaneMode.assignee: 'Assignee',
  KanbanSwimlaneMode.priority: 'Priority',
  KanbanSwimlaneMode.milestone: 'Milestone',
};

const _$KanbanCardDensityEnumMap = {
  KanbanCardDensity.compact: 'Compact',
  KanbanCardDensity.comfortable: 'Comfortable',
  KanbanCardDensity.detailed: 'Detailed',
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

_ProjectSetupRecipePreviewResponse _$ProjectSetupRecipePreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupRecipePreviewResponse(
  key: json['key'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$ProjectSetupRecipePreviewResponseToJson(
  _ProjectSetupRecipePreviewResponse instance,
) => <String, dynamic>{'key': instance.key, 'name': instance.name};

_ProjectSetupPreviewResponse _$ProjectSetupPreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupPreviewResponse(
  source: $enumDecode(_$ProjectSetupSourceKindEnumMap, json['source']),
  template: json['template'] == null
      ? null
      : ProjectSetupTemplatePreviewResponse.fromJson(
          json['template'] as Map<String, dynamic>,
        ),
  project: ProjectSetupProjectPreviewResponse.fromJson(
    json['project'] as Map<String, dynamic>,
  ),
  workflow: ProjectSetupWorkflowPreviewResponse.fromJson(
    json['workflow'] as Map<String, dynamic>,
  ),
  taskView: ProjectSetupTaskViewPreviewResponse.fromJson(
    json['taskView'] as Map<String, dynamic>,
  ),
  scheduleMode: json['scheduleMode'] as String,
  defaultDailyCapacityMinutes: (json['defaultDailyCapacityMinutes'] as num?)
      ?.toInt(),
  automationRecipes: (json['automationRecipes'] as List<dynamic>)
      .map(
        (e) => ProjectSetupRecipePreviewResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  warnings: (json['warnings'] as List<dynamic>)
      .map(
        (e) => ProjectSetupWarningResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  tasks: (json['tasks'] as List<dynamic>?)
      ?.map(
        (e) =>
            ProjectSetupTaskPreviewResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ProjectSetupPreviewResponseToJson(
  _ProjectSetupPreviewResponse instance,
) => <String, dynamic>{
  'source': _$ProjectSetupSourceKindEnumMap[instance.source]!,
  'template': instance.template,
  'project': instance.project,
  'workflow': instance.workflow,
  'taskView': instance.taskView,
  'scheduleMode': instance.scheduleMode,
  'defaultDailyCapacityMinutes': instance.defaultDailyCapacityMinutes,
  'automationRecipes': instance.automationRecipes,
  'warnings': instance.warnings,
  'tasks': instance.tasks,
};

const _$ProjectSetupSourceKindEnumMap = {
  ProjectSetupSourceKind.blank: 'Blank',
  ProjectSetupSourceKind.projectTemplate: 'ProjectTemplate',
};

_ProjectSetupTaskPreviewResponse _$ProjectSetupTaskPreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupTaskPreviewResponse(
  title: json['title'] as String,
  statusName: json['statusName'] as String,
  priority: json['priority'] as String,
  labels: (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ProjectSetupTaskPreviewResponseToJson(
  _ProjectSetupTaskPreviewResponse instance,
) => <String, dynamic>{
  'title': instance.title,
  'statusName': instance.statusName,
  'priority': instance.priority,
  'labels': instance.labels,
};
