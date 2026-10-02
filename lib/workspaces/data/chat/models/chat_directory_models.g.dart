// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_directory_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatDirectoryUserResponse _$ChatDirectoryUserResponseFromJson(
  Map<String, dynamic> json,
) => _ChatDirectoryUserResponse(
  userId: json['userId'] as String,
  login: json['login'] as String,
  displayName: json['displayName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  isOnline: json['isOnline'] as bool?,
);

Map<String, dynamic> _$ChatDirectoryUserResponseToJson(
  _ChatDirectoryUserResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'login': instance.login,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'isOnline': instance.isOnline,
};
