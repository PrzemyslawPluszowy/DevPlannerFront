// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_setup_result_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectSetupAutomationRuleResponse
_$ProjectSetupAutomationRuleResponseFromJson(Map<String, dynamic> json) =>
    _ProjectSetupAutomationRuleResponse(
      id: json['id'] as String,
      recipeKey: json['recipeKey'] as String,
      name: json['name'] as String,
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$ProjectSetupAutomationRuleResponseToJson(
  _ProjectSetupAutomationRuleResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'recipeKey': instance.recipeKey,
  'name': instance.name,
  'isEnabled': instance.isEnabled,
};

_ProjectSetupWorkflowResponse _$ProjectSetupWorkflowResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupWorkflowResponse(
  kind: $enumDecode(_$ProjectSetupWorkflowKindEnumMap, json['kind']),
  templateKey: json['templateKey'] as String?,
  customStatusCount: (json['customStatusCount'] as num).toInt(),
  systemStatusCount: (json['systemStatusCount'] as num).toInt(),
);

Map<String, dynamic> _$ProjectSetupWorkflowResponseToJson(
  _ProjectSetupWorkflowResponse instance,
) => <String, dynamic>{
  'kind': _$ProjectSetupWorkflowKindEnumMap[instance.kind]!,
  'templateKey': instance.templateKey,
  'customStatusCount': instance.customStatusCount,
  'systemStatusCount': instance.systemStatusCount,
};

const _$ProjectSetupWorkflowKindEnumMap = {
  ProjectSetupWorkflowKind.systemDefault: 'Default',
  ProjectSetupWorkflowKind.catalogTemplate: 'CatalogTemplate',
  ProjectSetupWorkflowKind.explicitStatuses: 'ExplicitStatuses',
};

_ProjectSetupTaskViewResponse _$ProjectSetupTaskViewResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupTaskViewResponse(
  defaultView: $enumDecode(
    _$ProjectSetupTaskViewKindEnumMap,
    json['defaultView'],
  ),
  listPolicyVersion: (json['listPolicyVersion'] as num).toInt(),
  boardSettingsVersion: (json['boardSettingsVersion'] as num).toInt(),
);

Map<String, dynamic> _$ProjectSetupTaskViewResponseToJson(
  _ProjectSetupTaskViewResponse instance,
) => <String, dynamic>{
  'defaultView': _$ProjectSetupTaskViewKindEnumMap[instance.defaultView]!,
  'listPolicyVersion': instance.listPolicyVersion,
  'boardSettingsVersion': instance.boardSettingsVersion,
};

const _$ProjectSetupTaskViewKindEnumMap = {
  ProjectSetupTaskViewKind.list: 'List',
  ProjectSetupTaskViewKind.board: 'Board',
};

_ProjectSetupResponse _$ProjectSetupResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectSetupResponse(
  project: ProjectResponse.fromJson(json['project'] as Map<String, dynamic>),
  workflow: ProjectSetupWorkflowResponse.fromJson(
    json['workflow'] as Map<String, dynamic>,
  ),
  taskView: ProjectSetupTaskViewResponse.fromJson(
    json['taskView'] as Map<String, dynamic>,
  ),
  scheduleMode: json['scheduleMode'] as String,
  memberCount: (json['memberCount'] as num).toInt(),
  automationRules: (json['automationRules'] as List<dynamic>)
      .map(
        (e) => ProjectSetupAutomationRuleResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  idempotencyKey: json['idempotencyKey'] as String,
  replayed: json['replayed'] as bool,
  completedAtUtc: DateTime.parse(json['completedAtUtc'] as String),
);

Map<String, dynamic> _$ProjectSetupResponseToJson(
  _ProjectSetupResponse instance,
) => <String, dynamic>{
  'project': instance.project,
  'workflow': instance.workflow,
  'taskView': instance.taskView,
  'scheduleMode': instance.scheduleMode,
  'memberCount': instance.memberCount,
  'automationRules': instance.automationRules,
  'idempotencyKey': instance.idempotencyKey,
  'replayed': instance.replayed,
  'completedAtUtc': instance.completedAtUtc.toIso8601String(),
};
