// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_arkusz_numer_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateArkuszNumerRequest _$UpdateArkuszNumerRequestFromJson(
  Map<String, dynamic> json,
) => UpdateArkuszNumerRequest(numer: json['numer'] as String);

Map<String, dynamic> _$UpdateArkuszNumerRequestToJson(
  UpdateArkuszNumerRequest instance,
) => <String, dynamic>{'numer': instance.numer};

UpdateArkuszNumerResponseData _$UpdateArkuszNumerResponseDataFromJson(
  Map<String, dynamic> json,
) => UpdateArkuszNumerResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$UpdateArkuszNumerResponseDataToJson(
  UpdateArkuszNumerResponseData instance,
) => <String, dynamic>{'id': instance.id, 'success': instance.success};
