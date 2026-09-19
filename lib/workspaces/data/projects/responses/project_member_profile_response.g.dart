// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_member_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectMemberProfileResponse _$ProjectMemberProfileResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectMemberProfileResponse(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  role: $enumDecode(_$ProjectRoleEnumMap, json['role']),
);

Map<String, dynamic> _$ProjectMemberProfileResponseToJson(
  _ProjectMemberProfileResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'role': _$ProjectRoleEnumMap[instance.role]!,
};

const _$ProjectRoleEnumMap = {
  ProjectRole.owner: 'Owner',
  ProjectRole.admin: 'Admin',
  ProjectRole.member: 'Member',
  ProjectRole.observer: 'Observer',
};
