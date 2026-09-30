// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddChatMembersPayload _$AddChatMembersPayloadFromJson(
  Map<String, dynamic> json,
) => _AddChatMembersPayload(
  userIds: (json['userIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AddChatMembersPayloadToJson(
  _AddChatMembersPayload instance,
) => <String, dynamic>{'userIds': instance.userIds};

_UpdateChatMemberRolePayload _$UpdateChatMemberRolePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateChatMemberRolePayload(role: json['role'] as String);

Map<String, dynamic> _$UpdateChatMemberRolePayloadToJson(
  _UpdateChatMemberRolePayload instance,
) => <String, dynamic>{'role': instance.role};

_ChatMemberResponse _$ChatMemberResponseFromJson(Map<String, dynamic> json) =>
    _ChatMemberResponse(
      userId: json['userId'] as String,
      role: json['role'] as String,
      joinedAtUtc: DateTime.parse(json['joinedAtUtc'] as String),
      login: json['login'] as String?,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$ChatMemberResponseToJson(_ChatMemberResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'role': instance.role,
      'joinedAtUtc': instance.joinedAtUtc.toIso8601String(),
      'login': instance.login,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
    };

_ChatMentionSuggestionResponse _$ChatMentionSuggestionResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMentionSuggestionResponse(
  userId: json['userId'] as String,
  login: json['login'] as String,
  displayName: json['displayName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$ChatMentionSuggestionResponseToJson(
  _ChatMentionSuggestionResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'login': instance.login,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
};
