// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatUserNotificationPreferenceResponse
_$ChatUserNotificationPreferenceResponseFromJson(Map<String, dynamic> json) =>
    _ChatUserNotificationPreferenceResponse(
      userId: json['userId'] as String,
      inAppEnabled: json['inAppEnabled'] as bool,
      emailEnabled: json['emailEnabled'] as bool,
      pushEnabled: json['pushEnabled'] as bool,
      digestEnabled: json['digestEnabled'] as bool,
    );

Map<String, dynamic> _$ChatUserNotificationPreferenceResponseToJson(
  _ChatUserNotificationPreferenceResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
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
      userId: json['userId'] as String,
      preference: $enumDecode(
        _$ChatNotificationPreferenceEnumMap,
        json['preference'],
      ),
    );

Map<String, dynamic> _$ChatNotificationPreferenceResponseToJson(
  _ChatNotificationPreferenceResponse instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'userId': instance.userId,
  'preference': _$ChatNotificationPreferenceEnumMap[instance.preference]!,
};

const _$ChatNotificationPreferenceEnumMap = {
  ChatNotificationPreference.all: 'All',
  ChatNotificationPreference.mentionsOnly: 'MentionsOnly',
  ChatNotificationPreference.muted: 'Muted',
  ChatNotificationPreference.highOnly: 'HighOnly',
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
