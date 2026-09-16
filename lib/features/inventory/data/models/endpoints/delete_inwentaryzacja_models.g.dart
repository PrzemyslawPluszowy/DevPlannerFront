// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_inwentaryzacja_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteInwentaryzacjaResponseData _$DeleteInwentaryzacjaResponseDataFromJson(
  Map<String, dynamic> json,
) => DeleteInwentaryzacjaResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$DeleteInwentaryzacjaResponseDataToJson(
  DeleteInwentaryzacjaResponseData instance,
) => <String, dynamic>{'success': instance.success, 'id': instance.id};
