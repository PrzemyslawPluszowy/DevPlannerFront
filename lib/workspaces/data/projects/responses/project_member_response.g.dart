// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectMemberResponse _$ProjectMemberResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectMemberResponse(
  id: json['id'] as String,
  workspaceMembershipId: json['workspaceMembershipId'] as String,
  coreUserId: json['coreUserId'] as String,
  readyUserId: (json['readyUserId'] as num?)?.toInt(),
  role: $enumDecode(_$ProjectRoleEnumMap, json['role']),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  revokedAtUtc: json['revokedAtUtc'] == null
      ? null
      : DateTime.parse(json['revokedAtUtc'] as String),
);

Map<String, dynamic> _$ProjectMemberResponseToJson(
  _ProjectMemberResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceMembershipId': instance.workspaceMembershipId,
  'coreUserId': instance.coreUserId,
  'readyUserId': instance.readyUserId,
  'role': _$ProjectRoleEnumMap[instance.role]!,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'revokedAtUtc': instance.revokedAtUtc?.toIso8601String(),
};

const _$ProjectRoleEnumMap = {
  ProjectRole.owner: 'Owner',
  ProjectRole.admin: 'Admin',
  ProjectRole.member: 'Member',
  ProjectRole.observer: 'Observer',
};
