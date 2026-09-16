// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_payloads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateWorkspacePayload _$CreateWorkspacePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWorkspacePayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
);

Map<String, dynamic> _$CreateWorkspacePayloadToJson(
  _CreateWorkspacePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
};

_UpdateWorkspacePayload _$UpdateWorkspacePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWorkspacePayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
);

Map<String, dynamic> _$UpdateWorkspacePayloadToJson(
  _UpdateWorkspacePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
};

_UpdateWorkspaceUserPreferencePayload
_$UpdateWorkspaceUserPreferencePayloadFromJson(Map<String, dynamic> json) =>
    _UpdateWorkspaceUserPreferencePayload(
      isHidden: json['isHidden'] as bool?,
      isPinned: json['isPinned'] as bool?,
    );

Map<String, dynamic> _$UpdateWorkspaceUserPreferencePayloadToJson(
  _UpdateWorkspaceUserPreferencePayload instance,
) => <String, dynamic>{
  'isHidden': instance.isHidden,
  'isPinned': instance.isPinned,
};

_UpdateWorkspaceOrderPayload _$UpdateWorkspaceOrderPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWorkspaceOrderPayload(
  workspaceIds: (json['workspaceIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpdateWorkspaceOrderPayloadToJson(
  _UpdateWorkspaceOrderPayload instance,
) => <String, dynamic>{'workspaceIds': instance.workspaceIds};

_UpdateWorkspaceNotificationPreferencePayload
_$UpdateWorkspaceNotificationPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWorkspaceNotificationPreferencePayload(
  inAppEnabled: json['inAppEnabled'] as bool?,
  emailEnabled: json['emailEnabled'] as bool?,
  tasksEnabled: json['tasksEnabled'] as bool?,
  projectsEnabled: json['projectsEnabled'] as bool?,
  workspaceEnabled: json['workspaceEnabled'] as bool?,
  membershipEnabled: json['membershipEnabled'] as bool?,
  invitationsEnabled: json['invitationsEnabled'] as bool?,
  adminEnabled: json['adminEnabled'] as bool?,
  ownerEnabled: json['ownerEnabled'] as bool?,
);

Map<String, dynamic> _$UpdateWorkspaceNotificationPreferencePayloadToJson(
  _UpdateWorkspaceNotificationPreferencePayload instance,
) => <String, dynamic>{
  'inAppEnabled': instance.inAppEnabled,
  'emailEnabled': instance.emailEnabled,
  'tasksEnabled': instance.tasksEnabled,
  'projectsEnabled': instance.projectsEnabled,
  'workspaceEnabled': instance.workspaceEnabled,
  'membershipEnabled': instance.membershipEnabled,
  'invitationsEnabled': instance.invitationsEnabled,
  'adminEnabled': instance.adminEnabled,
  'ownerEnabled': instance.ownerEnabled,
};

_CreateWorkspaceInvitationPayload _$CreateWorkspaceInvitationPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWorkspaceInvitationPayload(
  readyUserId: (json['readyUserId'] as num).toInt(),
  role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
  message: json['message'] as String?,
);

Map<String, dynamic> _$CreateWorkspaceInvitationPayloadToJson(
  _CreateWorkspaceInvitationPayload instance,
) => <String, dynamic>{
  'readyUserId': instance.readyUserId,
  'role': _$WorkspaceRoleEnumMap[instance.role]!,
  'message': instance.message,
};

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.owner: 'Owner',
  WorkspaceRole.admin: 'Admin',
  WorkspaceRole.member: 'Member',
  WorkspaceRole.observer: 'Observer',
};

_ChangeWorkspaceMemberRolePayload _$ChangeWorkspaceMemberRolePayloadFromJson(
  Map<String, dynamic> json,
) => _ChangeWorkspaceMemberRolePayload(
  role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
);

Map<String, dynamic> _$ChangeWorkspaceMemberRolePayloadToJson(
  _ChangeWorkspaceMemberRolePayload instance,
) => <String, dynamic>{'role': _$WorkspaceRoleEnumMap[instance.role]!};
