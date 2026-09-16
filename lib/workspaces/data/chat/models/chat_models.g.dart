// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

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
  coreUserIds: (json['coreUserIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  discussionRootMessageId: json['discussionRootMessageId'] as String?,
  postingPermission: json['postingPermission'] as String? ?? 'Everyone',
  scopeProvider: json['scopeProvider'] as String?,
  scopeResourceType: json['scopeResourceType'] as String?,
  scopeResourceId: json['scopeResourceId'] as String?,
  readyUserIds: (json['readyUserIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
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
  'coreUserIds': instance.coreUserIds,
  'discussionRootMessageId': instance.discussionRootMessageId,
  'postingPermission': instance.postingPermission,
  'scopeProvider': instance.scopeProvider,
  'scopeResourceType': instance.scopeResourceType,
  'scopeResourceId': instance.scopeResourceId,
  'readyUserIds': instance.readyUserIds,
};

const _$ChatConversationTypeEnumMap = {
  ChatConversationType.direct: 'direct',
  ChatConversationType.group: 'group',
  ChatConversationType.channel: 'channel',
  ChatConversationType.broadcast: 'broadcast',
  ChatConversationType.discussion: 'discussion',
};

const _$ChatScopeKindEnumMap = {
  ChatScopeKind.global: 'global',
  ChatScopeKind.workspace: 'workspace',
  ChatScopeKind.project: 'project',
  ChatScopeKind.resource: 'resource',
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

_AddChatMembersPayload _$AddChatMembersPayloadFromJson(
  Map<String, dynamic> json,
) => _AddChatMembersPayload(
  coreUserIds: (json['coreUserIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  readyUserIds: (json['readyUserIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$AddChatMembersPayloadToJson(
  _AddChatMembersPayload instance,
) => <String, dynamic>{
  'coreUserIds': instance.coreUserIds,
  'readyUserIds': instance.readyUserIds,
};

_UpdateChatMemberRolePayload _$UpdateChatMemberRolePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateChatMemberRolePayload(role: json['role'] as String);

Map<String, dynamic> _$UpdateChatMemberRolePayloadToJson(
  _UpdateChatMemberRolePayload instance,
) => <String, dynamic>{'role': instance.role};

_ChatMemberResponse _$ChatMemberResponseFromJson(Map<String, dynamic> json) =>
    _ChatMemberResponse(
      coreUserId: json['coreUserId'] as String,
      role: json['role'] as String,
      joinedAtUtc: DateTime.parse(json['joinedAtUtc'] as String),
    );

Map<String, dynamic> _$ChatMemberResponseToJson(_ChatMemberResponse instance) =>
    <String, dynamic>{
      'coreUserId': instance.coreUserId,
      'role': instance.role,
      'joinedAtUtc': instance.joinedAtUtc.toIso8601String(),
    };

_ChatMentionSuggestionResponse _$ChatMentionSuggestionResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMentionSuggestionResponse(
  coreUserId: json['coreUserId'] as String,
  login: json['login'] as String,
  displayName: json['displayName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$ChatMentionSuggestionResponseToJson(
  _ChatMentionSuggestionResponse instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'login': instance.login,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
};

_SendChatMessagePayload _$SendChatMessagePayloadFromJson(
  Map<String, dynamic> json,
) => _SendChatMessagePayload(
  clientMessageId: json['clientMessageId'] as String,
  text: json['text'] as String,
  deltaJson: json['deltaJson'] as String?,
  replyToMessageId: json['replyToMessageId'] as String?,
  attachmentFileIds: (json['attachmentFileIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SendChatMessagePayloadToJson(
  _SendChatMessagePayload instance,
) => <String, dynamic>{
  'clientMessageId': instance.clientMessageId,
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'replyToMessageId': instance.replyToMessageId,
  'attachmentFileIds': instance.attachmentFileIds,
};

_UpdateChatMessagePayload _$UpdateChatMessagePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateChatMessagePayload(
  text: json['text'] as String,
  deltaJson: json['deltaJson'] as String?,
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$UpdateChatMessagePayloadToJson(
  _UpdateChatMessagePayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'version': instance.version,
};

_ForwardChatMessagePayload _$ForwardChatMessagePayloadFromJson(
  Map<String, dynamic> json,
) => _ForwardChatMessagePayload(
  targetConversationId: json['targetConversationId'] as String,
  clientMessageId: json['clientMessageId'] as String,
);

Map<String, dynamic> _$ForwardChatMessagePayloadToJson(
  _ForwardChatMessagePayload instance,
) => <String, dynamic>{
  'targetConversationId': instance.targetConversationId,
  'clientMessageId': instance.clientMessageId,
};

_ChatMessageRevisionResponse _$ChatMessageRevisionResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMessageRevisionResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  authorCoreUserId: json['authorCoreUserId'] as String,
  editedByCoreUserId: json['editedByCoreUserId'] as String,
  text: json['text'] as String,
  deltaJson: json['deltaJson'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  version: (json['version'] as num).toInt(),
  newVersion: (json['newVersion'] as num).toInt(),
);

Map<String, dynamic> _$ChatMessageRevisionResponseToJson(
  _ChatMessageRevisionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'authorCoreUserId': instance.authorCoreUserId,
  'editedByCoreUserId': instance.editedByCoreUserId,
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'version': instance.version,
  'newVersion': instance.newVersion,
};

_ChatLinkResponse _$ChatLinkResponseFromJson(Map<String, dynamic> json) =>
    _ChatLinkResponse(
      url: json['url'] as String,
      host: json['host'] as String?,
      isHttps: json['isHttps'] as bool,
      isInternal: json['isInternal'] as bool,
      previewAllowed: json['previewAllowed'] as bool,
    );

Map<String, dynamic> _$ChatLinkResponseToJson(_ChatLinkResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
      'host': instance.host,
      'isHttps': instance.isHttps,
      'isInternal': instance.isInternal,
      'previewAllowed': instance.previewAllowed,
    };

_ChatLinkPreviewResponse _$ChatLinkPreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ChatLinkPreviewResponse(
  finalUrl: json['finalUrl'] as String,
  title: json['title'] as String?,
  description: json['description'] as String?,
  contentType: json['contentType'] as String?,
  fetchedAtUtc: DateTime.parse(json['fetchedAtUtc'] as String),
);

Map<String, dynamic> _$ChatLinkPreviewResponseToJson(
  _ChatLinkPreviewResponse instance,
) => <String, dynamic>{
  'finalUrl': instance.finalUrl,
  'title': instance.title,
  'description': instance.description,
  'contentType': instance.contentType,
  'fetchedAtUtc': instance.fetchedAtUtc.toIso8601String(),
};

_ChatSnippetPayload _$ChatSnippetPayloadFromJson(Map<String, dynamic> json) =>
    _ChatSnippetPayload(
      text: json['text'] as String,
      format: json['format'] as String? ?? 'PlainText',
      force: json['force'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatSnippetPayloadToJson(_ChatSnippetPayload instance) =>
    <String, dynamic>{
      'text': instance.text,
      'format': instance.format,
      'force': instance.force,
    };

_ChatSnippetResponse _$ChatSnippetResponseFromJson(Map<String, dynamic> json) =>
    _ChatSnippetResponse(
      isSnippet: json['isSnippet'] as bool,
      originalLength: (json['originalLength'] as num).toInt(),
      suggestedFileName: json['suggestedFileName'] as String?,
      mimeType: json['mimeType'] as String?,
      content: json['content'] as String?,
      isTruncated: json['isTruncated'] as bool,
    );

Map<String, dynamic> _$ChatSnippetResponseToJson(
  _ChatSnippetResponse instance,
) => <String, dynamic>{
  'isSnippet': instance.isSnippet,
  'originalLength': instance.originalLength,
  'suggestedFileName': instance.suggestedFileName,
  'mimeType': instance.mimeType,
  'content': instance.content,
  'isTruncated': instance.isTruncated,
};

_ChatSnippetAttachmentResponse _$ChatSnippetAttachmentResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSnippetAttachmentResponse(
  attachment: ChatAttachmentResponse.fromJson(
    json['attachment'] as Map<String, dynamic>,
  ),
  fileName: json['fileName'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  scanStatus: $enumDecode(_$StorageScanStatusEnumMap, json['scanStatus']),
);

Map<String, dynamic> _$ChatSnippetAttachmentResponseToJson(
  _ChatSnippetAttachmentResponse instance,
) => <String, dynamic>{
  'attachment': instance.attachment,
  'fileName': instance.fileName,
  'fileSizeBytes': instance.fileSizeBytes,
  'scanStatus': _$StorageScanStatusEnumMap[instance.scanStatus]!,
};

const _$StorageScanStatusEnumMap = {
  StorageScanStatus.pending: 'Pending',
  StorageScanStatus.clean: 'Clean',
  StorageScanStatus.infected: 'Infected',
  StorageScanStatus.skipped: 'Skipped',
};

_ChatReactionSummaryResponse _$ChatReactionSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _ChatReactionSummaryResponse(
  emoji: json['emoji'] as String,
  count: (json['count'] as num).toInt(),
  reactedByCurrentUser: json['reactedByCurrentUser'] as bool,
);

Map<String, dynamic> _$ChatReactionSummaryResponseToJson(
  _ChatReactionSummaryResponse instance,
) => <String, dynamic>{
  'emoji': instance.emoji,
  'count': instance.count,
  'reactedByCurrentUser': instance.reactedByCurrentUser,
};

_ChatMessageResponse _$ChatMessageResponseFromJson(Map<String, dynamic> json) =>
    _ChatMessageResponse(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      authorCoreUserId: json['authorCoreUserId'] as String,
      clientMessageId: json['clientMessageId'] as String,
      text: json['text'] as String,
      deltaJson: json['deltaJson'] as String?,
      replyToMessageId: json['replyToMessageId'] as String?,
      payloadHash: json['payloadHash'] as String,
      version: (json['version'] as num).toInt(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      isDeleted: json['isDeleted'] as bool,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => ChatLinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map(
            (e) =>
                ChatReactionSummaryResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map(
            (e) => ChatAttachmentResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      threadRootMessageId: json['threadRootMessageId'] as String?,
      isEdited: json['isEdited'] as bool? ?? false,
      deletedAtUtc: json['deletedAtUtc'] == null
          ? null
          : DateTime.parse(json['deletedAtUtc'] as String),
    );

Map<String, dynamic> _$ChatMessageResponseToJson(
  _ChatMessageResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'authorCoreUserId': instance.authorCoreUserId,
  'clientMessageId': instance.clientMessageId,
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'replyToMessageId': instance.replyToMessageId,
  'payloadHash': instance.payloadHash,
  'version': instance.version,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'isDeleted': instance.isDeleted,
  'links': instance.links,
  'reactions': instance.reactions,
  'attachments': instance.attachments,
  'threadRootMessageId': instance.threadRootMessageId,
  'isEdited': instance.isEdited,
  'deletedAtUtc': instance.deletedAtUtc?.toIso8601String(),
};

_ChatTemporaryAttachmentSessionResponse
_$ChatTemporaryAttachmentSessionResponseFromJson(Map<String, dynamic> json) =>
    _ChatTemporaryAttachmentSessionResponse(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
    );

Map<String, dynamic> _$ChatTemporaryAttachmentSessionResponseToJson(
  _ChatTemporaryAttachmentSessionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
};

_ChatMessageDeliveryResponse _$ChatMessageDeliveryResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMessageDeliveryResponse(
  messageId: json['messageId'] as String,
  recipientCoreUserId: json['recipientCoreUserId'] as String,
  deviceId: json['deviceId'] as String?,
  status: $enumDecode(_$ChatMessageDeliveryStatusEnumMap, json['status']),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  lastError: json['lastError'] as String?,
);

Map<String, dynamic> _$ChatMessageDeliveryResponseToJson(
  _ChatMessageDeliveryResponse instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'recipientCoreUserId': instance.recipientCoreUserId,
  'deviceId': instance.deviceId,
  'status': _$ChatMessageDeliveryStatusEnumMap[instance.status]!,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'lastError': instance.lastError,
};

const _$ChatMessageDeliveryStatusEnumMap = {
  ChatMessageDeliveryStatus.sending: 'sending',
  ChatMessageDeliveryStatus.sent: 'sent',
  ChatMessageDeliveryStatus.delivered: 'delivered',
  ChatMessageDeliveryStatus.read: 'read',
  ChatMessageDeliveryStatus.failed: 'failed',
};

_AddChatReactionPayload _$AddChatReactionPayloadFromJson(
  Map<String, dynamic> json,
) => _AddChatReactionPayload(emoji: json['emoji'] as String);

Map<String, dynamic> _$AddChatReactionPayloadToJson(
  _AddChatReactionPayload instance,
) => <String, dynamic>{'emoji': instance.emoji};

_ChatReactionResponse _$ChatReactionResponseFromJson(
  Map<String, dynamic> json,
) => _ChatReactionResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  coreUserId: json['coreUserId'] as String,
  emoji: json['emoji'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatReactionResponseToJson(
  _ChatReactionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'coreUserId': instance.coreUserId,
  'emoji': instance.emoji,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ChatMutePayload _$ChatMutePayloadFromJson(Map<String, dynamic> json) =>
    _ChatMutePayload(
      untilUtc: json['untilUtc'] == null
          ? null
          : DateTime.parse(json['untilUtc'] as String),
    );

Map<String, dynamic> _$ChatMutePayloadToJson(_ChatMutePayload instance) =>
    <String, dynamic>{'untilUtc': instance.untilUtc?.toIso8601String()};

_ChatThreadMutePayload _$ChatThreadMutePayloadFromJson(
  Map<String, dynamic> json,
) => _ChatThreadMutePayload(
  untilUtc: json['untilUtc'] == null
      ? null
      : DateTime.parse(json['untilUtc'] as String),
);

Map<String, dynamic> _$ChatThreadMutePayloadToJson(
  _ChatThreadMutePayload instance,
) => <String, dynamic>{'untilUtc': instance.untilUtc?.toIso8601String()};

_AddChatPlacementPayload _$AddChatPlacementPayloadFromJson(
  Map<String, dynamic> json,
) => _AddChatPlacementPayload(
  provider: json['provider'] as String,
  resourceType: json['resourceType'] as String,
  resourceId: json['resourceId'] as String,
  label: json['label'] as String?,
  deepLink: json['deepLink'] as String?,
);

Map<String, dynamic> _$AddChatPlacementPayloadToJson(
  _AddChatPlacementPayload instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'resourceType': instance.resourceType,
  'resourceId': instance.resourceId,
  'label': instance.label,
  'deepLink': instance.deepLink,
};

_ChatPlacementResponse _$ChatPlacementResponseFromJson(
  Map<String, dynamic> json,
) => _ChatPlacementResponse(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  provider: json['provider'] as String,
  resourceType: json['resourceType'] as String,
  resourceId: json['resourceId'] as String,
  label: json['label'] as String?,
  deepLink: json['deepLink'] as String?,
  createdByCoreUserId: json['createdByCoreUserId'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatPlacementResponseToJson(
  _ChatPlacementResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'provider': instance.provider,
  'resourceType': instance.resourceType,
  'resourceId': instance.resourceId,
  'label': instance.label,
  'deepLink': instance.deepLink,
  'createdByCoreUserId': instance.createdByCoreUserId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_UpsertChatUserStatusPayload _$UpsertChatUserStatusPayloadFromJson(
  Map<String, dynamic> json,
) => _UpsertChatUserStatusPayload(
  emoji: json['emoji'] as String?,
  text: json['text'] as String?,
  expiresAtUtc: json['expiresAtUtc'] == null
      ? null
      : DateTime.parse(json['expiresAtUtc'] as String),
  isDnd: json['isDnd'] as bool? ?? false,
);

Map<String, dynamic> _$UpsertChatUserStatusPayloadToJson(
  _UpsertChatUserStatusPayload instance,
) => <String, dynamic>{
  'emoji': instance.emoji,
  'text': instance.text,
  'expiresAtUtc': instance.expiresAtUtc?.toIso8601String(),
  'isDnd': instance.isDnd,
};

_ChatUserStatusResponse _$ChatUserStatusResponseFromJson(
  Map<String, dynamic> json,
) => _ChatUserStatusResponse(
  coreUserId: json['coreUserId'] as String,
  emoji: json['emoji'] as String?,
  text: json['text'] as String?,
  expiresAtUtc: json['expiresAtUtc'] == null
      ? null
      : DateTime.parse(json['expiresAtUtc'] as String),
  isDnd: json['isDnd'] as bool,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$ChatUserStatusResponseToJson(
  _ChatUserStatusResponse instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'emoji': instance.emoji,
  'text': instance.text,
  'expiresAtUtc': instance.expiresAtUtc?.toIso8601String(),
  'isDnd': instance.isDnd,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_ChatUserNotificationPreferenceResponse
_$ChatUserNotificationPreferenceResponseFromJson(Map<String, dynamic> json) =>
    _ChatUserNotificationPreferenceResponse(
      coreUserId: json['coreUserId'] as String,
      inAppEnabled: json['inAppEnabled'] as bool,
      emailEnabled: json['emailEnabled'] as bool,
      pushEnabled: json['pushEnabled'] as bool,
      digestEnabled: json['digestEnabled'] as bool,
    );

Map<String, dynamic> _$ChatUserNotificationPreferenceResponseToJson(
  _ChatUserNotificationPreferenceResponse instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'inAppEnabled': instance.inAppEnabled,
  'emailEnabled': instance.emailEnabled,
  'pushEnabled': instance.pushEnabled,
  'digestEnabled': instance.digestEnabled,
};

_UpdateChatUserNotificationPreferencePayload
_$UpdateChatUserNotificationPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateChatUserNotificationPreferencePayload(
  inAppEnabled: json['inAppEnabled'] as bool?,
  emailEnabled: json['emailEnabled'] as bool?,
  pushEnabled: json['pushEnabled'] as bool?,
  digestEnabled: json['digestEnabled'] as bool?,
);

Map<String, dynamic> _$UpdateChatUserNotificationPreferencePayloadToJson(
  _UpdateChatUserNotificationPreferencePayload instance,
) => <String, dynamic>{
  'inAppEnabled': instance.inAppEnabled,
  'emailEnabled': instance.emailEnabled,
  'pushEnabled': instance.pushEnabled,
  'digestEnabled': instance.digestEnabled,
};

_ChatNotificationPreferenceResponse
_$ChatNotificationPreferenceResponseFromJson(Map<String, dynamic> json) =>
    _ChatNotificationPreferenceResponse(
      conversationId: json['conversationId'] as String,
      coreUserId: json['coreUserId'] as String,
      preference: $enumDecode(
        _$ChatNotificationPreferenceEnumMap,
        json['preference'],
      ),
    );

Map<String, dynamic> _$ChatNotificationPreferenceResponseToJson(
  _ChatNotificationPreferenceResponse instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'coreUserId': instance.coreUserId,
  'preference': _$ChatNotificationPreferenceEnumMap[instance.preference]!,
};

const _$ChatNotificationPreferenceEnumMap = {
  ChatNotificationPreference.all: 'all',
  ChatNotificationPreference.mentionsOnly: 'mentionsOnly',
  ChatNotificationPreference.muted: 'muted',
  ChatNotificationPreference.highOnly: 'highOnly',
};

_UpdateChatNotificationPreferencePayload
_$UpdateChatNotificationPreferencePayloadFromJson(Map<String, dynamic> json) =>
    _UpdateChatNotificationPreferencePayload(
      preference: $enumDecode(
        _$ChatNotificationPreferenceEnumMap,
        json['preference'],
      ),
    );

Map<String, dynamic> _$UpdateChatNotificationPreferencePayloadToJson(
  _UpdateChatNotificationPreferencePayload instance,
) => <String, dynamic>{
  'preference': _$ChatNotificationPreferenceEnumMap[instance.preference]!,
};

_AttachChatFilePayload _$AttachChatFilePayloadFromJson(
  Map<String, dynamic> json,
) => _AttachChatFilePayload(
  storageFileId: json['storageFileId'] as String,
  position: (json['position'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AttachChatFilePayloadToJson(
  _AttachChatFilePayload instance,
) => <String, dynamic>{
  'storageFileId': instance.storageFileId,
  'position': instance.position,
};

_ChatAttachmentResponse _$ChatAttachmentResponseFromJson(
  Map<String, dynamic> json,
) => _ChatAttachmentResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  storageFileId: json['storageFileId'] as String,
  attachedByCoreUserId: json['attachedByCoreUserId'] as String,
  position: (json['position'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatAttachmentResponseToJson(
  _ChatAttachmentResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'storageFileId': instance.storageFileId,
  'attachedByCoreUserId': instance.attachedByCoreUserId,
  'position': instance.position,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ChatInviteResponse _$ChatInviteResponseFromJson(Map<String, dynamic> json) =>
    _ChatInviteResponse(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      email: json['email'] as String,
      status: $enumDecode(_$ChatInvitationStatusEnumMap, json['status']),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      expiresAtUtc: DateTime.parse(json['expiresAtUtc'] as String),
      respondedAtUtc: json['respondedAtUtc'] == null
          ? null
          : DateTime.parse(json['respondedAtUtc'] as String),
    );

Map<String, dynamic> _$ChatInviteResponseToJson(_ChatInviteResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'email': instance.email,
      'status': _$ChatInvitationStatusEnumMap[instance.status]!,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'expiresAtUtc': instance.expiresAtUtc.toIso8601String(),
      'respondedAtUtc': instance.respondedAtUtc?.toIso8601String(),
    };

const _$ChatInvitationStatusEnumMap = {
  ChatInvitationStatus.pending: 'pending',
  ChatInvitationStatus.accepted: 'accepted',
  ChatInvitationStatus.expired: 'expired',
  ChatInvitationStatus.cancelled: 'cancelled',
};

_ChatBookmarkPayload _$ChatBookmarkPayloadFromJson(Map<String, dynamic> json) =>
    _ChatBookmarkPayload(note: json['note'] as String?);

Map<String, dynamic> _$ChatBookmarkPayloadToJson(
  _ChatBookmarkPayload instance,
) => <String, dynamic>{'note': instance.note};

_ChatBookmarkResponse _$ChatBookmarkResponseFromJson(
  Map<String, dynamic> json,
) => _ChatBookmarkResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  conversationId: json['conversationId'] as String,
  coreUserId: json['coreUserId'] as String,
  note: json['note'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatBookmarkResponseToJson(
  _ChatBookmarkResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'conversationId': instance.conversationId,
  'coreUserId': instance.coreUserId,
  'note': instance.note,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ChatPinnedMessageResponse _$ChatPinnedMessageResponseFromJson(
  Map<String, dynamic> json,
) => _ChatPinnedMessageResponse(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  messageId: json['messageId'] as String,
  pinnedByCoreUserId: json['pinnedByCoreUserId'] as String,
  pinnedAtUtc: DateTime.parse(json['pinnedAtUtc'] as String),
);

Map<String, dynamic> _$ChatPinnedMessageResponseToJson(
  _ChatPinnedMessageResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'messageId': instance.messageId,
  'pinnedByCoreUserId': instance.pinnedByCoreUserId,
  'pinnedAtUtc': instance.pinnedAtUtc.toIso8601String(),
};

_CreateChatInvitePayload _$CreateChatInvitePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateChatInvitePayload(
  email: json['email'] as String,
  ttlHours: (json['ttlHours'] as num?)?.toInt() ?? 72,
);

Map<String, dynamic> _$CreateChatInvitePayloadToJson(
  _CreateChatInvitePayload instance,
) => <String, dynamic>{'email': instance.email, 'ttlHours': instance.ttlHours};

_AcceptChatInvitePayload _$AcceptChatInvitePayloadFromJson(
  Map<String, dynamic> json,
) => _AcceptChatInvitePayload(token: json['token'] as String);

Map<String, dynamic> _$AcceptChatInvitePayloadToJson(
  _AcceptChatInvitePayload instance,
) => <String, dynamic>{'token': instance.token};

_UpsertChatDraftPayload _$UpsertChatDraftPayloadFromJson(
  Map<String, dynamic> json,
) => _UpsertChatDraftPayload(
  text: json['text'] as String?,
  deltaJson: json['deltaJson'] as String?,
  replyToMessageId: json['replyToMessageId'] as String?,
  version: (json['version'] as num?)?.toInt() ?? 0,
  attachmentStorageFileIds: (json['attachmentStorageFileIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpsertChatDraftPayloadToJson(
  _UpsertChatDraftPayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'replyToMessageId': instance.replyToMessageId,
  'version': instance.version,
  'attachmentStorageFileIds': instance.attachmentStorageFileIds,
};

_ChatDraftResponse _$ChatDraftResponseFromJson(Map<String, dynamic> json) =>
    _ChatDraftResponse(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      text: json['text'] as String?,
      deltaJson: json['deltaJson'] as String?,
      replyToMessageId: json['replyToMessageId'] as String?,
      version: (json['version'] as num).toInt(),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map(
            (e) =>
                ChatDraftAttachmentResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ChatDraftResponseToJson(_ChatDraftResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'text': instance.text,
      'deltaJson': instance.deltaJson,
      'replyToMessageId': instance.replyToMessageId,
      'version': instance.version,
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'attachments': instance.attachments,
    };

_ChatDraftAttachmentResponse _$ChatDraftAttachmentResponseFromJson(
  Map<String, dynamic> json,
) => _ChatDraftAttachmentResponse(
  id: json['id'] as String,
  storageFileId: json['storageFileId'] as String,
  position: (json['position'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatDraftAttachmentResponseToJson(
  _ChatDraftAttachmentResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'storageFileId': instance.storageFileId,
  'position': instance.position,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ChatContextResponse _$ChatContextResponseFromJson(Map<String, dynamic> json) =>
    _ChatContextResponse(
      conversationId: json['conversationId'] as String,
      summary: json['summary'] as String,
      compactedMessageCount: (json['compactedMessageCount'] as num).toInt(),
      participantCount: (json['participantCount'] as num).toInt(),
      earliestMessageAtUtc: json['earliestMessageAtUtc'] == null
          ? null
          : DateTime.parse(json['earliestMessageAtUtc'] as String),
      latestMessageAtUtc: json['latestMessageAtUtc'] == null
          ? null
          : DateTime.parse(json['latestMessageAtUtc'] as String),
      recentMessages: (json['recentMessages'] as List<dynamic>)
          .map((e) => ChatMessageResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
    );

Map<String, dynamic> _$ChatContextResponseToJson(
  _ChatContextResponse instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'summary': instance.summary,
  'compactedMessageCount': instance.compactedMessageCount,
  'participantCount': instance.participantCount,
  'earliestMessageAtUtc': instance.earliestMessageAtUtc?.toIso8601String(),
  'latestMessageAtUtc': instance.latestMessageAtUtc?.toIso8601String(),
  'recentMessages': instance.recentMessages,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
};

_ChatSearchItemResponse _$ChatSearchItemResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSearchItemResponse(
  messageId: json['messageId'] as String,
  conversationId: json['conversationId'] as String,
  authorCoreUserId: json['authorCoreUserId'] as String,
  conversationType: $enumDecode(
    _$ChatConversationTypeEnumMap,
    json['conversationType'],
  ),
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  conversationName: json['conversationName'] as String?,
  text: json['text'] as String,
  highlight: json['highlight'] as String?,
  score: (json['score'] as num).toDouble(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  hasMention: json['hasMention'] as bool,
);

Map<String, dynamic> _$ChatSearchItemResponseToJson(
  _ChatSearchItemResponse instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'conversationId': instance.conversationId,
  'authorCoreUserId': instance.authorCoreUserId,
  'conversationType': _$ChatConversationTypeEnumMap[instance.conversationType]!,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'conversationName': instance.conversationName,
  'text': instance.text,
  'highlight': instance.highlight,
  'score': instance.score,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'hasMention': instance.hasMention,
};

_ChatSearchFacetBucketResponse _$ChatSearchFacetBucketResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSearchFacetBucketResponse(
  id: json['id'] as String,
  label: json['label'] as String?,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$ChatSearchFacetBucketResponseToJson(
  _ChatSearchFacetBucketResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'count': instance.count,
};

_ChatSearchResponse _$ChatSearchResponseFromJson(Map<String, dynamic> json) =>
    _ChatSearchResponse(
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => ChatSearchItemResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      totalApproximate: (json['totalApproximate'] as num).toInt(),
      indexVersion: json['indexVersion'] as String,
    );

Map<String, dynamic> _$ChatSearchResponseToJson(_ChatSearchResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': instance.nextCursor,
      'totalApproximate': instance.totalApproximate,
      'indexVersion': instance.indexVersion,
    };

_ChatSearchFacetsResponse _$ChatSearchFacetsResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSearchFacetsResponse(
  total: (json['total'] as num).toInt(),
  conversations: (json['conversations'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  senders: (json['senders'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  workspaces: (json['workspaces'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  projects: (json['projects'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ChatSearchFacetsResponseToJson(
  _ChatSearchFacetsResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'conversations': instance.conversations,
  'senders': instance.senders,
  'workspaces': instance.workspaces,
  'projects': instance.projects,
};
