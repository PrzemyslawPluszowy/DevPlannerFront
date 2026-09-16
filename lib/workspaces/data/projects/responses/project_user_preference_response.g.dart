// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_user_preference_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectUserPreferenceResponse _$ProjectUserPreferenceResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectUserPreferenceResponse(
  projectId: json['projectId'] as String,
  isHidden: json['isHidden'] as bool,
  isPinned: json['isPinned'] as bool,
  sortPosition: (json['sortPosition'] as num?)?.toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$ProjectUserPreferenceResponseToJson(
  _ProjectUserPreferenceResponse instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'isHidden': instance.isHidden,
  'isPinned': instance.isPinned,
  'sortPosition': instance.sortPosition,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};
