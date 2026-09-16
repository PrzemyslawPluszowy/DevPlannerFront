// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_project_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProjectPayload _$CreateProjectPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateProjectPayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
  visibility: $enumDecode(_$ProjectVisibilityEnumMap, json['visibility']),
  status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
);

Map<String, dynamic> _$CreateProjectPayloadToJson(
  _CreateProjectPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
  'visibility': _$ProjectVisibilityEnumMap[instance.visibility]!,
  'status': _$ProjectStatusEnumMap[instance.status]!,
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
