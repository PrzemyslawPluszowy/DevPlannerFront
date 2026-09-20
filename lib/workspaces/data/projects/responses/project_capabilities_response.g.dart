// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_capabilities_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectCapabilitiesResponse _$ProjectCapabilitiesResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectCapabilitiesResponse(
  canManage: json['canManage'] as bool? ?? false,
  canArchive: json['canArchive'] as bool? ?? false,
  canDelete: json['canDelete'] as bool? ?? false,
  canManageMembers: json['canManageMembers'] as bool? ?? false,
  canCreateTemplate: json['canCreateTemplate'] as bool? ?? false,
  canLeave: json['canLeave'] as bool? ?? false,
  canTransfer: json['canTransfer'] as bool? ?? false,
);

Map<String, dynamic> _$ProjectCapabilitiesResponseToJson(
  _ProjectCapabilitiesResponse instance,
) => <String, dynamic>{
  'canManage': instance.canManage,
  'canArchive': instance.canArchive,
  'canDelete': instance.canDelete,
  'canManageMembers': instance.canManageMembers,
  'canCreateTemplate': instance.canCreateTemplate,
  'canLeave': instance.canLeave,
  'canTransfer': instance.canTransfer,
};
