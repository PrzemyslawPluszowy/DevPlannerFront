// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_presence_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
  userId: json['userId'] as String,
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
  'userId': instance.userId,
  'emoji': instance.emoji,
  'text': instance.text,
  'expiresAtUtc': instance.expiresAtUtc?.toIso8601String(),
  'isDnd': instance.isDnd,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};
