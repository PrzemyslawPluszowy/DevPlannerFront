// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResolveChatConversationPayload _$ResolveChatConversationPayloadFromJson(
  Map<String, dynamic> json,
) => _ResolveChatConversationPayload(
  type: $enumDecode(_$ChatConversationTypeEnumMap, json['type']),
  scopeKind: $enumDecode(_$ChatScopeKindEnumMap, json['scopeKind']),
  scopeKey: json['scopeKey'] as String,
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  name: json['name'] as String?,
  directConversationKey: json['directConversationKey'] as String?,
  userIds: (json['userIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  discussionRootMessageId: json['discussionRootMessageId'] as String?,
  postingPermission: json['postingPermission'] as String? ?? 'Everyone',
  scopeProvider: json['scopeProvider'] as String?,
  scopeResourceType: json['scopeResourceType'] as String?,
  scopeResourceId: json['scopeResourceId'] as String?,
);

Map<String, dynamic> _$ResolveChatConversationPayloadToJson(
  _ResolveChatConversationPayload instance,
) => <String, dynamic>{
  'type': _$ChatConversationTypeEnumMap[instance.type]!,
  'scopeKind': _$ChatScopeKindEnumMap[instance.scopeKind]!,
  'scopeKey': instance.scopeKey,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'name': instance.name,
  'directConversationKey': instance.directConversationKey,
  'userIds': instance.userIds,
  'discussionRootMessageId': instance.discussionRootMessageId,
  'postingPermission': instance.postingPermission,
  'scopeProvider': instance.scopeProvider,
  'scopeResourceType': instance.scopeResourceType,
  'scopeResourceId': instance.scopeResourceId,
};

const _$ChatConversationTypeEnumMap = {
  ChatConversationType.direct: 'Direct',
  ChatConversationType.group: 'Group',
  ChatConversationType.channel: 'Channel',
  ChatConversationType.broadcast: 'Broadcast',
  ChatConversationType.discussion: 'Discussion',
};

const _$ChatScopeKindEnumMap = {
  ChatScopeKind.global: 'Global',
  ChatScopeKind.workspace: 'Workspace',
  ChatScopeKind.project: 'Project',
  ChatScopeKind.resource: 'Resource',
};

_UpdateChatConversationPayload _$UpdateChatConversationPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateChatConversationPayload(
  name: json['name'] as String?,
  postingPermission: json['postingPermission'] as String? ?? 'Everyone',
);

Map<String, dynamic> _$UpdateChatConversationPayloadToJson(
  _UpdateChatConversationPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'postingPermission': instance.postingPermission,
};

_ChatConversationResponse _$ChatConversationResponseFromJson(
  Map<String, dynamic> json,
) => _ChatConversationResponse(
  id: json['id'] as String,
  type: $enumDecode(_$ChatConversationTypeEnumMap, json['type']),
  scopeKind: $enumDecode(_$ChatScopeKindEnumMap, json['scopeKind']),
  scopeKey: json['scopeKey'] as String,
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  name: json['name'] as String?,
  discussionRootMessageId: json['discussionRootMessageId'] as String?,
  version: (json['version'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  postingPermission: json['postingPermission'] as String? ?? 'Everyone',
  isArchived: json['isArchived'] as bool? ?? false,
);

Map<String, dynamic> _$ChatConversationResponseToJson(
  _ChatConversationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$ChatConversationTypeEnumMap[instance.type]!,
  'scopeKind': _$ChatScopeKindEnumMap[instance.scopeKind]!,
  'scopeKey': instance.scopeKey,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'name': instance.name,
  'discussionRootMessageId': instance.discussionRootMessageId,
  'version': instance.version,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'postingPermission': instance.postingPermission,
  'isArchived': instance.isArchived,
};
