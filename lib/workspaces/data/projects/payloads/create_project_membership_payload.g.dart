// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_project_membership_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProjectMembershipPayload _$CreateProjectMembershipPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateProjectMembershipPayload(
  workspaceMembershipId: json['workspaceMembershipId'] as String,
  role: $enumDecode(_$ProjectRoleEnumMap, json['role']),
);

Map<String, dynamic> _$CreateProjectMembershipPayloadToJson(
  _CreateProjectMembershipPayload instance,
) => <String, dynamic>{
  'workspaceMembershipId': instance.workspaceMembershipId,
  'role': _$ProjectRoleEnumMap[instance.role]!,
};

const _$ProjectRoleEnumMap = {
  ProjectRole.owner: 'Owner',
  ProjectRole.admin: 'Admin',
  ProjectRole.member: 'Member',
  ProjectRole.observer: 'Observer',
};
