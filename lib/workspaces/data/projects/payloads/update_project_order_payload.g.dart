// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_project_order_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProjectOrderPayload _$UpdateProjectOrderPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectOrderPayload(
  projectIds: (json['projectIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpdateProjectOrderPayloadToJson(
  _UpdateProjectOrderPayload instance,
) => <String, dynamic>{'projectIds': instance.projectIds};
