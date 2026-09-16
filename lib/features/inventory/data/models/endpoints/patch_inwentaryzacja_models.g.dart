// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_inwentaryzacja_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchInwentaryzacjaRequest _$PatchInwentaryzacjaRequestFromJson(
  Map<String, dynamic> json,
) => PatchInwentaryzacjaRequest(
  dataOd: json['data_od'] as String?,
  dataDo: json['data_do'] as String?,
  numer: json['numer'] as String?,
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$PatchInwentaryzacjaRequestToJson(
  PatchInwentaryzacjaRequest instance,
) => <String, dynamic>{
  'data_od': instance.dataOd,
  'data_do': instance.dataDo,
  'numer': instance.numer,
  'uwagi': instance.uwagi,
};

PatchInwentaryzacjaResponseData _$PatchInwentaryzacjaResponseDataFromJson(
  Map<String, dynamic> json,
) => PatchInwentaryzacjaResponseData(
  id: (json['id'] as num).toInt(),
  dataOd: json['data_od'] as String?,
  dataDo: json['data_do'] as String?,
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$PatchInwentaryzacjaResponseDataToJson(
  PatchInwentaryzacjaResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'data_od': instance.dataOd,
  'data_do': instance.dataDo,
  'success': instance.success,
};
