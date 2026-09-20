// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectListItemResponse _$ProjectListItemResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectListItemResponse(
  id: json['id'] as String,
  workspaceId: json['workspaceId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
  visibility: $enumDecode(_$ProjectVisibilityEnumMap, json['visibility']),
  status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
  myRole: $enumDecodeNullable(_$ProjectRoleEnumMap, json['myRole']),
  isPinned: json['isPinned'] as bool,
  sortPosition: (json['sortPosition'] as num?)?.toInt(),
  isHidden: json['isHidden'] as bool? ?? false,
  archivedAtUtc: json['archivedAtUtc'] == null
      ? null
      : DateTime.parse(json['archivedAtUtc'] as String),
  version: (json['version'] as num?)?.toInt(),
  capabilities: json['capabilities'] == null
      ? null
      : ProjectCapabilitiesResponse.fromJson(
          json['capabilities'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ProjectListItemResponseToJson(
  _ProjectListItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceId': instance.workspaceId,
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
  'visibility': _$ProjectVisibilityEnumMap[instance.visibility]!,
  'status': _$ProjectStatusEnumMap[instance.status]!,
  'myRole': _$ProjectRoleEnumMap[instance.myRole],
  'isPinned': instance.isPinned,
  'sortPosition': instance.sortPosition,
  'isHidden': instance.isHidden,
  'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
  'version': instance.version,
  'capabilities': instance.capabilities,
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
