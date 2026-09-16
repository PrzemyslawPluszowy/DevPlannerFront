// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_arkusz_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateArkuszRequest _$UpdateArkuszRequestFromJson(Map<String, dynamic> json) =>
    UpdateArkuszRequest(
      dataRozpoczecia: json['data_rozpoczecia'] as String?,
      dataZakonczenia: json['data_zakonczenia'] as String?,
    );

Map<String, dynamic> _$UpdateArkuszRequestToJson(
  UpdateArkuszRequest instance,
) => <String, dynamic>{
  'data_rozpoczecia': instance.dataRozpoczecia,
  'data_zakonczenia': instance.dataZakonczenia,
};

UpdateArkuszResponseData _$UpdateArkuszResponseDataFromJson(
  Map<String, dynamic> json,
) => UpdateArkuszResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$UpdateArkuszResponseDataToJson(
  UpdateArkuszResponseData instance,
) => <String, dynamic>{'id': instance.id, 'success': instance.success};
