// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_arkusz_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostArkuszQuery _$PostArkuszQueryFromJson(Map<String, dynamic> json) =>
    PostArkuszQuery(
      idMiejsca: (json['id_miejsca'] as num).toInt(),
      idFirmy: (json['id_firmy'] as num).toInt(),
      baza: json['baza'] as String,
      scope: json['scope'] as String?,
      numer: json['numer'] as String?,
      komisja: (json['komisja'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PostArkuszQueryToJson(PostArkuszQuery instance) =>
    <String, dynamic>{
      'id_miejsca': instance.idMiejsca,
      'id_firmy': instance.idFirmy,
      'baza': instance.baza,
      'scope': instance.scope,
      'numer': instance.numer,
      'komisja': instance.komisja,
    };

PostArkuszResponseData _$PostArkuszResponseDataFromJson(
  Map<String, dynamic> json,
) => PostArkuszResponseData(
  id: (json['id'] as num).toInt(),
  scope: json['scope'] as String,
  elementyCount: (json['elementy_count'] as num).toInt(),
  komisjaCount: (json['komisja_count'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$PostArkuszResponseDataToJson(
  PostArkuszResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'success': instance.success,
  'scope': instance.scope,
  'elementy_count': instance.elementyCount,
  'komisja_count': instance.komisjaCount,
};
