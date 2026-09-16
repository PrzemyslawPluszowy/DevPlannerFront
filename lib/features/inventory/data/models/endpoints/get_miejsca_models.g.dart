// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_miejsca_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMiejscaQuery _$GetMiejscaQueryFromJson(Map<String, dynamic> json) =>
    GetMiejscaQuery(firma: (json['firma'] as num?)?.toInt());

Map<String, dynamic> _$GetMiejscaQueryToJson(GetMiejscaQuery instance) =>
    <String, dynamic>{'firma': instance.firma};

GetMiejscaResponseData _$GetMiejscaResponseDataFromJson(
  Map<String, dynamic> json,
) => GetMiejscaResponseData(
  items: (json['items'] as List<dynamic>)
      .map((e) => GetMiejscaItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: GetMiejscaMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetMiejscaResponseDataToJson(
  GetMiejscaResponseData instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};

GetMiejscaItem _$GetMiejscaItemFromJson(Map<String, dynamic> json) =>
    GetMiejscaItem(
      id: (json['id'] as num).toInt(),
      idMiejsca: (json['id_miejsca'] as num).toInt(),
      idFirmy: (json['id_firmy'] as num).toInt(),
      idparent: (json['idparent'] as num?)?.toInt(),
      baza: json['baza'] as String?,
      nazwa: json['nazwa'] as String?,
      lvl: json['lvl'] as String?,
    );

Map<String, dynamic> _$GetMiejscaItemToJson(GetMiejscaItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_miejsca': instance.idMiejsca,
      'idparent': instance.idparent,
      'id_firmy': instance.idFirmy,
      'baza': instance.baza,
      'nazwa': instance.nazwa,
      'lvl': instance.lvl,
    };

GetMiejscaMeta _$GetMiejscaMetaFromJson(Map<String, dynamic> json) =>
    GetMiejscaMeta(total: (json['total'] as num).toInt());

Map<String, dynamic> _$GetMiejscaMetaToJson(GetMiejscaMeta instance) =>
    <String, dynamic>{'total': instance.total};
