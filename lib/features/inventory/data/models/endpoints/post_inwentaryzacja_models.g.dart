// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_inwentaryzacja_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostInwentaryzacjaQuery _$PostInwentaryzacjaQueryFromJson(
  Map<String, dynamic> json,
) => PostInwentaryzacjaQuery(
  firmy: (json['firmy'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  numer: json['numer'] as String,
  komisja: (json['komisja'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  dataOd: json['data_od'] as String,
  dataDo: json['data_do'] as String?,
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$PostInwentaryzacjaQueryToJson(
  PostInwentaryzacjaQuery instance,
) => <String, dynamic>{
  'firmy': instance.firmy,
  'numer': instance.numer,
  'komisja': instance.komisja,
  'data_od': instance.dataOd,
  'data_do': instance.dataDo,
  'uwagi': instance.uwagi,
};

PostInwentaryzacjaResponseData _$PostInwentaryzacjaResponseDataFromJson(
  Map<String, dynamic> json,
) => PostInwentaryzacjaResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$PostInwentaryzacjaResponseDataToJson(
  PostInwentaryzacjaResponseData instance,
) => <String, dynamic>{'id': instance.id, 'success': instance.success};
