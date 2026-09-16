// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_project_member_role_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangeProjectMemberRolePayload _$ChangeProjectMemberRolePayloadFromJson(
  Map<String, dynamic> json,
) => _ChangeProjectMemberRolePayload(
  role: $enumDecode(_$ProjectRoleEnumMap, json['role']),
);

Map<String, dynamic> _$ChangeProjectMemberRolePayloadToJson(
  _ChangeProjectMemberRolePayload instance,
) => <String, dynamic>{'role': _$ProjectRoleEnumMap[instance.role]!};

const _$ProjectRoleEnumMap = {
  ProjectRole.owner: 'Owner',
  ProjectRole.admin: 'Admin',
  ProjectRole.member: 'Member',
  ProjectRole.observer: 'Observer',
};
