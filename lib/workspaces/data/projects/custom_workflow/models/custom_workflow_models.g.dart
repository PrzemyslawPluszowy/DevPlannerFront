// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_workflow_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectCustomStatusResponse _$ProjectCustomStatusResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectCustomStatusResponse(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  name: json['name'] as String,
  colorHex: json['colorHex'] as String,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
  position: (json['position'] as num).toInt(),
  wipLimit: (json['wipLimit'] as num?)?.toInt(),
  isDefault: json['isDefault'] as bool,
  taskCount: (json['taskCount'] as num).toInt(),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectCustomStatusResponseToJson(
  _ProjectCustomStatusResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'name': instance.name,
  'colorHex': instance.colorHex,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
  'position': instance.position,
  'wipLimit': instance.wipLimit,
  'isDefault': instance.isDefault,
  'taskCount': instance.taskCount,
  'version': instance.version,
};

const _$TaskStatusCategoryEnumMap = {
  TaskStatusCategory.todo: 'Todo',
  TaskStatusCategory.inProgress: 'InProgress',
  TaskStatusCategory.done: 'Done',
  TaskStatusCategory.cancelled: 'Cancelled',
};

_CreateProjectCustomStatusPayload _$CreateProjectCustomStatusPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateProjectCustomStatusPayload(
  name: json['name'] as String,
  colorHex: json['colorHex'] as String,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
  position: (json['position'] as num?)?.toInt(),
  wipLimit: (json['wipLimit'] as num?)?.toInt(),
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$CreateProjectCustomStatusPayloadToJson(
  _CreateProjectCustomStatusPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'colorHex': instance.colorHex,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
  'position': instance.position,
  'wipLimit': instance.wipLimit,
  'isDefault': instance.isDefault,
};

_UpdateProjectCustomStatusPayload _$UpdateProjectCustomStatusPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectCustomStatusPayload(
  name: json['name'] as String,
  colorHex: json['colorHex'] as String,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
  wipLimit: (json['wipLimit'] as num?)?.toInt(),
  isDefault: json['isDefault'] as bool,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateProjectCustomStatusPayloadToJson(
  _UpdateProjectCustomStatusPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'colorHex': instance.colorHex,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
  'wipLimit': instance.wipLimit,
  'isDefault': instance.isDefault,
  'expectedVersion': instance.expectedVersion,
};

_ReorderProjectCustomStatusesPayload
_$ReorderProjectCustomStatusesPayloadFromJson(Map<String, dynamic> json) =>
    _ReorderProjectCustomStatusesPayload(
      statusIds: (json['statusIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReorderProjectCustomStatusesPayloadToJson(
  _ReorderProjectCustomStatusesPayload instance,
) => <String, dynamic>{'statusIds': instance.statusIds};

_DeleteProjectCustomStatusPayload _$DeleteProjectCustomStatusPayloadFromJson(
  Map<String, dynamic> json,
) => _DeleteProjectCustomStatusPayload(
  fallbackStatusId: json['fallbackStatusId'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$DeleteProjectCustomStatusPayloadToJson(
  _DeleteProjectCustomStatusPayload instance,
) => <String, dynamic>{
  'fallbackStatusId': instance.fallbackStatusId,
  'expectedVersion': instance.expectedVersion,
};

_ApplyWorkflowTemplatePayload _$ApplyWorkflowTemplatePayloadFromJson(
  Map<String, dynamic> json,
) => _ApplyWorkflowTemplatePayload(
  templateKey: json['templateKey'] as String,
  replaceExisting: json['replaceExisting'] as bool? ?? false,
);

Map<String, dynamic> _$ApplyWorkflowTemplatePayloadToJson(
  _ApplyWorkflowTemplatePayload instance,
) => <String, dynamic>{
  'templateKey': instance.templateKey,
  'replaceExisting': instance.replaceExisting,
};

_WorkflowTemplateSummary _$WorkflowTemplateSummaryFromJson(
  Map<String, dynamic> json,
) => _WorkflowTemplateSummary(
  key: json['key'] as String,
  name: json['name'] as String,
  statusNames: (json['statusNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$WorkflowTemplateSummaryToJson(
  _WorkflowTemplateSummary instance,
) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name,
  'statusNames': instance.statusNames,
};

_AdminMutationResponse _$AdminMutationResponseFromJson(
  Map<String, dynamic> json,
) => _AdminMutationResponse(message: json['message'] as String?);

Map<String, dynamic> _$AdminMutationResponseToJson(
  _AdminMutationResponse instance,
) => <String, dynamic>{'message': instance.message};
