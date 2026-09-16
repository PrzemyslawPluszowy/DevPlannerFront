// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_firmy_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFirmyResponseData _$GetFirmyResponseDataFromJson(
  Map<String, dynamic> json,
) => GetFirmyResponseData(
  items: (json['items'] as List<dynamic>)
      .map((e) => GetFirmyItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: GetFirmyMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetFirmyResponseDataToJson(
  GetFirmyResponseData instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};

GetFirmyItem _$GetFirmyItemFromJson(Map<String, dynamic> json) => GetFirmyItem(
  id: (_readIdFromJson(json, 'id') as num).toInt(),
  idFirmy: (_readIdFirmyFromJson(json, 'id_firmy') as num).toInt(),
  nazwa: _readNazwaFromJson(json, 'nazwa') as String,
  aktywna: (json['aktywna'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetFirmyItemToJson(GetFirmyItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_firmy': instance.idFirmy,
      'nazwa': instance.nazwa,
      'aktywna': instance.aktywna,
    };

GetFirmyMeta _$GetFirmyMetaFromJson(Map<String, dynamic> json) =>
    GetFirmyMeta(total: (json['total'] as num).toInt());

Map<String, dynamic> _$GetFirmyMetaToJson(GetFirmyMeta instance) =>
    <String, dynamic>{'total': instance.total};
