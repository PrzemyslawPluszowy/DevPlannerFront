// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_firma_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteFirmaResponseData _$DeleteFirmaResponseDataFromJson(
  Map<String, dynamic> json,
) => DeleteFirmaResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$DeleteFirmaResponseDataToJson(
  DeleteFirmaResponseData instance,
) => <String, dynamic>{'success': instance.success, 'id': instance.id};
