// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_project_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProjectPayload _$UpdateProjectPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectPayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
  visibility: $enumDecode(_$ProjectVisibilityEnumMap, json['visibility']),
  status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
  expectedVersion: (json['expectedVersion'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateProjectPayloadToJson(
  _UpdateProjectPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
  'visibility': _$ProjectVisibilityEnumMap[instance.visibility]!,
  'status': _$ProjectStatusEnumMap[instance.status]!,
  'expectedVersion': instance.expectedVersion,
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
