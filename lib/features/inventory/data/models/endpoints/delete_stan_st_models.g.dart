// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_stan_st_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteStanStResponseData _$DeleteStanStResponseDataFromJson(
  Map<String, dynamic> json,
) => DeleteStanStResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$DeleteStanStResponseDataToJson(
  DeleteStanStResponseData instance,
) => <String, dynamic>{'success': instance.success, 'id': instance.id};
