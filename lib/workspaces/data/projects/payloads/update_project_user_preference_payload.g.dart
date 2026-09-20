// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_project_user_preference_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProjectUserPreferencePayload
_$UpdateProjectUserPreferencePayloadFromJson(Map<String, dynamic> json) =>
    _UpdateProjectUserPreferencePayload(
      isHidden: json['isHidden'] as bool,
      isPinned: json['isPinned'] as bool,
      expectedVersion: (json['expectedVersion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpdateProjectUserPreferencePayloadToJson(
  _UpdateProjectUserPreferencePayload instance,
) => <String, dynamic>{
  'isHidden': instance.isHidden,
  'isPinned': instance.isPinned,
  'expectedVersion': instance.expectedVersion,
};
