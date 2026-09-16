// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkspaceListItemResponse _$WorkspaceListItemResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceListItemResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
  primaryColor: json['primaryColor'] as String?,
  isPinned: json['isPinned'] as bool,
  isHidden: json['isHidden'] as bool? ?? false,
  sortPosition: (json['sortPosition'] as num?)?.toInt(),
  createdByCoreUserId: json['createdByCoreUserId'] as String?,
  isOwner: json['isOwner'] as bool? ?? false,
);

Map<String, dynamic> _$WorkspaceListItemResponseToJson(
  _WorkspaceListItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'primaryColor': instance.primaryColor,
  'isPinned': instance.isPinned,
  'isHidden': instance.isHidden,
  'sortPosition': instance.sortPosition,
  'createdByCoreUserId': instance.createdByCoreUserId,
  'isOwner': instance.isOwner,
};

_WorkspaceResponse _$WorkspaceResponseFromJson(Map<String, dynamic> json) =>
    _WorkspaceResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      primaryColor: json['primaryColor'] as String?,
      createdByCoreUserId: json['createdByCoreUserId'] as String,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      archivedAtUtc: json['archivedAtUtc'] == null
          ? null
          : DateTime.parse(json['archivedAtUtc'] as String),
    );

Map<String, dynamic> _$WorkspaceResponseToJson(_WorkspaceResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'primaryColor': instance.primaryColor,
      'createdByCoreUserId': instance.createdByCoreUserId,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
    };

_WorkspaceUserPreferenceResponse _$WorkspaceUserPreferenceResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceUserPreferenceResponse(
  workspaceId: json['workspaceId'] as String,
  isHidden: json['isHidden'] as bool,
  isPinned: json['isPinned'] as bool,
  sortPosition: (json['sortPosition'] as num?)?.toInt(),
);

Map<String, dynamic> _$WorkspaceUserPreferenceResponseToJson(
  _WorkspaceUserPreferenceResponse instance,
) => <String, dynamic>{
  'workspaceId': instance.workspaceId,
  'isHidden': instance.isHidden,
  'isPinned': instance.isPinned,
  'sortPosition': instance.sortPosition,
};

_WorkspaceNotificationPreferenceResponse
_$WorkspaceNotificationPreferenceResponseFromJson(Map<String, dynamic> json) =>
    _WorkspaceNotificationPreferenceResponse(
      workspaceId: json['workspaceId'] as String,
      inAppEnabled: json['inAppEnabled'] as bool,
      emailEnabled: json['emailEnabled'] as bool,
      tasksEnabled: json['tasksEnabled'] as bool,
      projectsEnabled: json['projectsEnabled'] as bool,
      workspaceEnabled: json['workspaceEnabled'] as bool,
      membershipEnabled: json['membershipEnabled'] as bool,
      invitationsEnabled: json['invitationsEnabled'] as bool,
      adminEnabled: json['adminEnabled'] as bool,
      ownerEnabled: json['ownerEnabled'] as bool,
    );

Map<String, dynamic> _$WorkspaceNotificationPreferenceResponseToJson(
  _WorkspaceNotificationPreferenceResponse instance,
) => <String, dynamic>{
  'workspaceId': instance.workspaceId,
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

_WorkspaceMemberResponse _$WorkspaceMemberResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceMemberResponse(
  id: json['id'] as String,
  coreUserId: json['coreUserId'] as String,
  readyUserId: (json['readyUserId'] as num?)?.toInt(),
  role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$WorkspaceMemberResponseToJson(
  _WorkspaceMemberResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'coreUserId': instance.coreUserId,
  'readyUserId': instance.readyUserId,
  'role': _$WorkspaceRoleEnumMap[instance.role]!,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.owner: 'Owner',
  WorkspaceRole.admin: 'Admin',
  WorkspaceRole.member: 'Member',
  WorkspaceRole.observer: 'Observer',
};

_WorkspaceMemberRevocationResponse _$WorkspaceMemberRevocationResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceMemberRevocationResponse(
  membershipId: json['membershipId'] as String,
  revokedAtUtc: DateTime.parse(json['revokedAtUtc'] as String),
);

Map<String, dynamic> _$WorkspaceMemberRevocationResponseToJson(
  _WorkspaceMemberRevocationResponse instance,
) => <String, dynamic>{
  'membershipId': instance.membershipId,
  'revokedAtUtc': instance.revokedAtUtc.toIso8601String(),
};

_ReadyDirectoryUserResponse _$ReadyDirectoryUserResponseFromJson(
  Map<String, dynamic> json,
) => _ReadyDirectoryUserResponse(
  readyUserId: (json['readyUserId'] as num).toInt(),
  coreUserId: json['coreUserId'] as String?,
  login: json['login'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String?,
  emailVerified: json['emailVerified'] as bool,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$ReadyDirectoryUserResponseToJson(
  _ReadyDirectoryUserResponse instance,
) => <String, dynamic>{
  'readyUserId': instance.readyUserId,
  'coreUserId': instance.coreUserId,
  'login': instance.login,
  'displayName': instance.displayName,
  'email': instance.email,
  'emailVerified': instance.emailVerified,
  'avatarUrl': instance.avatarUrl,
};

_WorkspaceInvitationResponse _$WorkspaceInvitationResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceInvitationResponse(
  id: json['id'] as String,
  workspaceId: json['workspaceId'] as String,
  readyUserId: (json['readyUserId'] as num).toInt(),
  role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
  status: $enumDecode(_$WorkspaceInvitationStatusEnumMap, json['status']),
  login: json['login'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String?,
  message: json['message'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
  respondedAtUtc: json['respondedAtUtc'] == null
      ? null
      : DateTime.parse(json['respondedAtUtc'] as String),
);

Map<String, dynamic> _$WorkspaceInvitationResponseToJson(
  _WorkspaceInvitationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceId': instance.workspaceId,
  'readyUserId': instance.readyUserId,
  'role': _$WorkspaceRoleEnumMap[instance.role]!,
  'status': _$WorkspaceInvitationStatusEnumMap[instance.status]!,
  'login': instance.login,
  'displayName': instance.displayName,
  'email': instance.email,
  'message': instance.message,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
  'respondedAtUtc': instance.respondedAtUtc?.toIso8601String(),
};

const _$WorkspaceInvitationStatusEnumMap = {
  WorkspaceInvitationStatus.pending: 'Pending',
  WorkspaceInvitationStatus.accepted: 'Accepted',
  WorkspaceInvitationStatus.declined: 'Declined',
  WorkspaceInvitationStatus.cancelled: 'Cancelled',
  WorkspaceInvitationStatus.expired: 'Expired',
};
