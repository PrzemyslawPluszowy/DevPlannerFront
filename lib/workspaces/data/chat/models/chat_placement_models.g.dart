// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_placement_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
  createdByUserId: json['createdByUserId'] as String,
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
  'createdByUserId': instance.createdByUserId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};
