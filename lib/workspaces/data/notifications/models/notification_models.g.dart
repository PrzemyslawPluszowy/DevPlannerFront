// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkspaceNotificationResponse _$WorkspaceNotificationResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceNotificationResponse(
  id: json['id'] as String,
  sourceModule: json['sourceModule'] as String,
  eventType: json['eventType'] as String,
  entityType: json['entityType'] as String,
  entityId: json['entityId'] as String,
  workspaceId: json['workspaceId'] as String?,
  title: json['title'] as String,
  body: json['body'] as String,
  deepLink: json['deepLink'] as String?,
  eventId: json['eventId'] as String,
  contractVersion: (json['contractVersion'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  readAtUtc: json['readAtUtc'] == null
      ? null
      : DateTime.parse(json['readAtUtc'] as String),
  isPinned: json['isPinned'] as bool,
  pinnedAtUtc: json['pinnedAtUtc'] == null
      ? null
      : DateTime.parse(json['pinnedAtUtc'] as String),
  category: $enumDecode(_$NotificationCategoryEnumMap, json['category']),
  groupKey: json['groupKey'] as String?,
  metadataJson: json['metadataJson'] as String?,
  priority: $enumDecode(_$NotificationPriorityEnumMap, json['priority']),
  digestOnly: json['digestOnly'] as bool? ?? false,
);

Map<String, dynamic> _$WorkspaceNotificationResponseToJson(
  _WorkspaceNotificationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceModule': instance.sourceModule,
  'eventType': instance.eventType,
  'entityType': instance.entityType,
  'entityId': instance.entityId,
  'workspaceId': instance.workspaceId,
  'title': instance.title,
  'body': instance.body,
  'deepLink': instance.deepLink,
  'eventId': instance.eventId,
  'contractVersion': instance.contractVersion,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'readAtUtc': instance.readAtUtc?.toIso8601String(),
  'isPinned': instance.isPinned,
  'pinnedAtUtc': instance.pinnedAtUtc?.toIso8601String(),
  'category': _$NotificationCategoryEnumMap[instance.category]!,
  'groupKey': instance.groupKey,
  'metadataJson': instance.metadataJson,
  'priority': _$NotificationPriorityEnumMap[instance.priority]!,
  'digestOnly': instance.digestOnly,
};

const _$NotificationCategoryEnumMap = {
  NotificationCategory.invitation: 'invitation',
  NotificationCategory.membership: 'membership',
  NotificationCategory.workspace: 'workspace',
  NotificationCategory.system: 'system',
  NotificationCategory.project: 'project',
  NotificationCategory.task: 'task',
  NotificationCategory.comment: 'comment',
  NotificationCategory.chat: 'chat',
  NotificationCategory.storage: 'storage',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
};

_NotificationActorAvatarResponse _$NotificationActorAvatarResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationActorAvatarResponse(
  coreUserId: json['coreUserId'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$NotificationActorAvatarResponseToJson(
  _NotificationActorAvatarResponse instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'avatarUrl': instance.avatarUrl,
};

_NotificationGroupResponse _$NotificationGroupResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationGroupResponse(
  groupKey: json['groupKey'] as String,
  count: (json['count'] as num).toInt(),
  unreadCount: (json['unreadCount'] as num).toInt(),
  latest: WorkspaceNotificationResponse.fromJson(
    json['latest'] as Map<String, dynamic>,
  ),
  notificationIds: (json['notificationIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  notificationKind: json['notificationKind'] as String?,
  scopeReference: json['scopeReference'] as String?,
  actorAvatars: (json['actorAvatars'] as List<dynamic>?)
      ?.map(
        (e) =>
            NotificationActorAvatarResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  preview: json['preview'] as String?,
  isArchived: json['isArchived'] as bool? ?? false,
  realtimeSequence: (json['realtimeSequence'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationGroupResponseToJson(
  _NotificationGroupResponse instance,
) => <String, dynamic>{
  'groupKey': instance.groupKey,
  'count': instance.count,
  'unreadCount': instance.unreadCount,
  'latest': instance.latest,
  'notificationIds': instance.notificationIds,
  'notificationKind': instance.notificationKind,
  'scopeReference': instance.scopeReference,
  'actorAvatars': instance.actorAvatars,
  'preview': instance.preview,
  'isArchived': instance.isArchived,
  'realtimeSequence': instance.realtimeSequence,
};

_NotificationDigestResponse _$NotificationDigestResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationDigestResponse(
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
  groups: (json['groups'] as List<dynamic>)
      .map((e) => NotificationGroupResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NotificationDigestResponseToJson(
  _NotificationDigestResponse instance,
) => <String, dynamic>{
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
  'groups': instance.groups,
};

_UnreadNotificationCountResponse _$UnreadNotificationCountResponseFromJson(
  Map<String, dynamic> json,
) => _UnreadNotificationCountResponse(count: (json['count'] as num).toInt());

Map<String, dynamic> _$UnreadNotificationCountResponseToJson(
  _UnreadNotificationCountResponse instance,
) => <String, dynamic>{'count': instance.count};

_NotificationEmailCategoryPreference
_$NotificationEmailCategoryPreferenceFromJson(Map<String, dynamic> json) =>
    _NotificationEmailCategoryPreference(
      emailMode: $enumDecode(
        _$NotificationEmailDeliveryModeEnumMap,
        json['emailMode'],
      ),
    );

Map<String, dynamic> _$NotificationEmailCategoryPreferenceToJson(
  _NotificationEmailCategoryPreference instance,
) => <String, dynamic>{
  'emailMode': _$NotificationEmailDeliveryModeEnumMap[instance.emailMode]!,
};

const _$NotificationEmailDeliveryModeEnumMap = {
  NotificationEmailDeliveryMode.none: 'none',
  NotificationEmailDeliveryMode.immediate: 'immediate',
  NotificationEmailDeliveryMode.dailyDigest: 'dailyDigest',
  NotificationEmailDeliveryMode.digest: 'digest',
};

_NotificationDeliveryPreferenceResponse
_$NotificationDeliveryPreferenceResponseFromJson(Map<String, dynamic> json) =>
    _NotificationDeliveryPreferenceResponse(
      coreUserId: json['coreUserId'] as String,
      invitation: NotificationEmailCategoryPreference.fromJson(
        json['invitation'] as Map<String, dynamic>,
      ),
      membership: NotificationEmailCategoryPreference.fromJson(
        json['membership'] as Map<String, dynamic>,
      ),
      workspace: NotificationEmailCategoryPreference.fromJson(
        json['workspace'] as Map<String, dynamic>,
      ),
      project: NotificationEmailCategoryPreference.fromJson(
        json['project'] as Map<String, dynamic>,
      ),
      task: NotificationEmailCategoryPreference.fromJson(
        json['task'] as Map<String, dynamic>,
      ),
      comment: NotificationEmailCategoryPreference.fromJson(
        json['comment'] as Map<String, dynamic>,
      ),
      chat: NotificationEmailCategoryPreference.fromJson(
        json['chat'] as Map<String, dynamic>,
      ),
      storage: NotificationEmailCategoryPreference.fromJson(
        json['storage'] as Map<String, dynamic>,
      ),
      system: NotificationEmailCategoryPreference.fromJson(
        json['system'] as Map<String, dynamic>,
      ),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );

Map<String, dynamic> _$NotificationDeliveryPreferenceResponseToJson(
  _NotificationDeliveryPreferenceResponse instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'invitation': instance.invitation,
  'membership': instance.membership,
  'workspace': instance.workspace,
  'project': instance.project,
  'task': instance.task,
  'comment': instance.comment,
  'chat': instance.chat,
  'storage': instance.storage,
  'system': instance.system,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_UpdateNotificationDeliveryPreferencePayload
_$UpdateNotificationDeliveryPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateNotificationDeliveryPreferencePayload(
  invitation: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['invitation'],
  ),
  membership: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['membership'],
  ),
  workspace: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['workspace'],
  ),
  project: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['project'],
  ),
  task: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['task'],
  ),
  comment: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['comment'],
  ),
  chat: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['chat'],
  ),
  storage: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['storage'],
  ),
  system: $enumDecodeNullable(
    _$NotificationEmailDeliveryModeEnumMap,
    json['system'],
  ),
);

Map<String, dynamic> _$UpdateNotificationDeliveryPreferencePayloadToJson(
  _UpdateNotificationDeliveryPreferencePayload instance,
) => <String, dynamic>{
  'invitation': _$NotificationEmailDeliveryModeEnumMap[instance.invitation],
  'membership': _$NotificationEmailDeliveryModeEnumMap[instance.membership],
  'workspace': _$NotificationEmailDeliveryModeEnumMap[instance.workspace],
  'project': _$NotificationEmailDeliveryModeEnumMap[instance.project],
  'task': _$NotificationEmailDeliveryModeEnumMap[instance.task],
  'comment': _$NotificationEmailDeliveryModeEnumMap[instance.comment],
  'chat': _$NotificationEmailDeliveryModeEnumMap[instance.chat],
  'storage': _$NotificationEmailDeliveryModeEnumMap[instance.storage],
  'system': _$NotificationEmailDeliveryModeEnumMap[instance.system],
};

_StorageNotificationPreferenceResponse
_$StorageNotificationPreferenceResponseFromJson(Map<String, dynamic> json) =>
    _StorageNotificationPreferenceResponse(
      coreUserId: json['coreUserId'] as String,
      mode: $enumDecode(
        _$StorageNotificationPreferenceModeEnumMap,
        json['mode'],
      ),
      isDefault: json['isDefault'] as bool,
      updatedAtUtc: json['updatedAtUtc'] == null
          ? null
          : DateTime.parse(json['updatedAtUtc'] as String),
    );

Map<String, dynamic> _$StorageNotificationPreferenceResponseToJson(
  _StorageNotificationPreferenceResponse instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'mode': _$StorageNotificationPreferenceModeEnumMap[instance.mode]!,
  'isDefault': instance.isDefault,
  'updatedAtUtc': instance.updatedAtUtc?.toIso8601String(),
};

const _$StorageNotificationPreferenceModeEnumMap = {
  StorageNotificationPreferenceMode.immediate: 'immediate',
  StorageNotificationPreferenceMode.digest: 'digest',
  StorageNotificationPreferenceMode.mentionsOnly: 'mentionsOnly',
  StorageNotificationPreferenceMode.disabled: 'disabled',
};

_UpdateStorageNotificationPreferencePayload
_$UpdateStorageNotificationPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateStorageNotificationPreferencePayload(
  mode: $enumDecode(_$StorageNotificationPreferenceModeEnumMap, json['mode']),
);

Map<String, dynamic> _$UpdateStorageNotificationPreferencePayloadToJson(
  _UpdateStorageNotificationPreferencePayload instance,
) => <String, dynamic>{
  'mode': _$StorageNotificationPreferenceModeEnumMap[instance.mode]!,
};

_NotificationQuickActionPayload _$NotificationQuickActionPayloadFromJson(
  Map<String, dynamic> json,
) => _NotificationQuickActionPayload(
  action: $enumDecode(_$NotificationQuickActionKindEnumMap, json['action']),
);

Map<String, dynamic> _$NotificationQuickActionPayloadToJson(
  _NotificationQuickActionPayload instance,
) => <String, dynamic>{
  'action': _$NotificationQuickActionKindEnumMap[instance.action]!,
};

const _$NotificationQuickActionKindEnumMap = {
  NotificationQuickActionKind.markRead: 'markRead',
  NotificationQuickActionKind.archive: 'archive',
  NotificationQuickActionKind.pin: 'pin',
  NotificationQuickActionKind.unpin: 'unpin',
  NotificationQuickActionKind.completeTask: 'completeTask',
  NotificationQuickActionKind.assignTaskToMe: 'assignTaskToMe',
};

_NotificationQuickActionResponse _$NotificationQuickActionResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationQuickActionResponse(
  notificationId: json['notificationId'] as String,
  action: $enumDecode(_$NotificationQuickActionKindEnumMap, json['action']),
  changed: json['changed'] as bool,
);

Map<String, dynamic> _$NotificationQuickActionResponseToJson(
  _NotificationQuickActionResponse instance,
) => <String, dynamic>{
  'notificationId': instance.notificationId,
  'action': _$NotificationQuickActionKindEnumMap[instance.action]!,
  'changed': instance.changed,
};

_NotificationReplyPayload _$NotificationReplyPayloadFromJson(
  Map<String, dynamic> json,
) => _NotificationReplyPayload(
  clientMessageId: json['clientMessageId'] as String,
  text: json['text'] as String,
  deltaJson: json['deltaJson'] as String?,
);

Map<String, dynamic> _$NotificationReplyPayloadToJson(
  _NotificationReplyPayload instance,
) => <String, dynamic>{
  'clientMessageId': instance.clientMessageId,
  'text': instance.text,
  'deltaJson': instance.deltaJson,
};

_CreateAdminNotificationPayload _$CreateAdminNotificationPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateAdminNotificationPayload(
  recipientCoreUserId: json['recipientCoreUserId'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  deepLink: json['deepLink'] as String?,
  workspaceId: json['workspaceId'] as String?,
);

Map<String, dynamic> _$CreateAdminNotificationPayloadToJson(
  _CreateAdminNotificationPayload instance,
) => <String, dynamic>{
  'recipientCoreUserId': instance.recipientCoreUserId,
  'title': instance.title,
  'body': instance.body,
  'deepLink': instance.deepLink,
  'workspaceId': instance.workspaceId,
};
