// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CurrentUserResponse _$CurrentUserResponseFromJson(Map<String, dynamic> json) =>
    _CurrentUserResponse(
      userId: json['userId'] as String,
      readyUserId: (json['readyUserId'] as num?)?.toInt(),
      login: json['login'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CurrentUserResponseToJson(
  _CurrentUserResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'readyUserId': instance.readyUserId,
  'login': instance.login,
  'permissions': instance.permissions,
};
