// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_invitation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
