// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrantResourceAccessPayload _$GrantResourceAccessPayloadFromJson(
  Map<String, dynamic> json,
) => _GrantResourceAccessPayload(
  accessLevel: $enumDecode(_$ResourceAccessLevelEnumMap, json['accessLevel']),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$GrantResourceAccessPayloadToJson(
  _GrantResourceAccessPayload instance,
) => <String, dynamic>{
  'accessLevel': _$ResourceAccessLevelEnumMap[instance.accessLevel]!,
  'expectedVersion': instance.expectedVersion,
};

const _$ResourceAccessLevelEnumMap = {
  ResourceAccessLevel.reader: 'Reader',
  ResourceAccessLevel.editor: 'Editor',
};

_WikiPageAccessGrantResponse _$WikiPageAccessGrantResponseFromJson(
  Map<String, dynamic> json,
) => _WikiPageAccessGrantResponse(
  id: json['id'] as String,
  wikiPageId: json['wikiPageId'] as String,
  coreUserId: json['coreUserId'] as String,
  accessLevel: $enumDecode(_$ResourceAccessLevelEnumMap, json['accessLevel']),
  grantedByUserId: json['grantedByUserId'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$WikiPageAccessGrantResponseToJson(
  _WikiPageAccessGrantResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'wikiPageId': instance.wikiPageId,
  'coreUserId': instance.coreUserId,
  'accessLevel': _$ResourceAccessLevelEnumMap[instance.accessLevel]!,
  'grantedByUserId': instance.grantedByUserId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

_WhiteboardAccessGrantResponse _$WhiteboardAccessGrantResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardAccessGrantResponse(
  id: json['id'] as String,
  whiteboardId: json['whiteboardId'] as String,
  coreUserId: json['coreUserId'] as String,
  accessLevel: $enumDecode(_$ResourceAccessLevelEnumMap, json['accessLevel']),
  grantedByUserId: json['grantedByUserId'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$WhiteboardAccessGrantResponseToJson(
  _WhiteboardAccessGrantResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'whiteboardId': instance.whiteboardId,
  'coreUserId': instance.coreUserId,
  'accessLevel': _$ResourceAccessLevelEnumMap[instance.accessLevel]!,
  'grantedByUserId': instance.grantedByUserId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};
