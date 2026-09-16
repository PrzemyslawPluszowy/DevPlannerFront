// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_arkusz_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteArkuszResponseData _$DeleteArkuszResponseDataFromJson(
  Map<String, dynamic> json,
) => DeleteArkuszResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$DeleteArkuszResponseDataToJson(
  DeleteArkuszResponseData instance,
) => <String, dynamic>{'success': instance.success, 'id': instance.id};
