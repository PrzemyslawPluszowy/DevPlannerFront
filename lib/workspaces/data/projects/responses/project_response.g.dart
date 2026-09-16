// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectResponse _$ProjectResponseFromJson(Map<String, dynamic> json) =>
    _ProjectResponse(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      primaryColor: json['primaryColor'] as String?,
      visibility: $enumDecode(_$ProjectVisibilityEnumMap, json['visibility']),
      status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
      createdByCoreUserId: json['createdByCoreUserId'] as String,
      myRole: $enumDecodeNullable(_$ProjectRoleEnumMap, json['myRole']),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      archivedAtUtc: json['archivedAtUtc'] == null
          ? null
          : DateTime.parse(json['archivedAtUtc'] as String),
    );

Map<String, dynamic> _$ProjectResponseToJson(_ProjectResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'primaryColor': instance.primaryColor,
      'visibility': _$ProjectVisibilityEnumMap[instance.visibility]!,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'createdByCoreUserId': instance.createdByCoreUserId,
      'myRole': _$ProjectRoleEnumMap[instance.myRole],
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
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

const _$ProjectRoleEnumMap = {
  ProjectRole.owner: 'Owner',
  ProjectRole.admin: 'Admin',
  ProjectRole.member: 'Member',
  ProjectRole.observer: 'Observer',
};
