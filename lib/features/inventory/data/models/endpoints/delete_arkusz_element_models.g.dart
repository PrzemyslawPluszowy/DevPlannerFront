// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_arkusz_element_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteArkuszElementResponseData _$DeleteArkuszElementResponseDataFromJson(
  Map<String, dynamic> json,
) => DeleteArkuszElementResponseData(
  elementId: (json['element_id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$DeleteArkuszElementResponseDataToJson(
  DeleteArkuszElementResponseData instance,
) => <String, dynamic>{
  'success': instance.success,
  'element_id': instance.elementId,
};
