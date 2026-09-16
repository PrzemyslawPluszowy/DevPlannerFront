// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_inwentaryzacja_status_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchInwentaryzacjaStatusResponseData
_$PatchInwentaryzacjaStatusResponseDataFromJson(Map<String, dynamic> json) =>
    PatchInwentaryzacjaStatusResponseData(
      id: (json['id'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$PatchInwentaryzacjaStatusResponseDataToJson(
  PatchInwentaryzacjaStatusResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'success': instance.success,
};
