// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stan_st_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStanStQuery _$GetStanStQueryFromJson(Map<String, dynamic> json) =>
    GetStanStQuery(
      firma: (json['firma'] as num?)?.toInt(),
      baza: json['baza'] as String?,
      idmiejsce: (json['idmiejsce'] as num?)?.toInt(),
      stan: json['stan'] as String?,
      q: json['q'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
      nazwa: json['nazwa'] as String?,
      nrewid: json['nrewid'] as String?,
      kodKreskowy: json['kod_kreskowy'] as String?,
    );

Map<String, dynamic> _$GetStanStQueryToJson(GetStanStQuery instance) =>
    <String, dynamic>{
      'firma': instance.firma,
      'baza': instance.baza,
      'idmiejsce': instance.idmiejsce,
      'stan': instance.stan,
      'q': instance.q,
      'limit': instance.limit,
      'offset': instance.offset,
      'nazwa': instance.nazwa,
      'nrewid': instance.nrewid,
      'kod_kreskowy': instance.kodKreskowy,
    };

GetStanStResponseData _$GetStanStResponseDataFromJson(
  Map<String, dynamic> json,
) => GetStanStResponseData(
  items: (json['items'] as List<dynamic>)
      .map((e) => GetStanStItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: GetStanStMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetStanStResponseDataToJson(
  GetStanStResponseData instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};

GetStanStItem _$GetStanStItemFromJson(Map<String, dynamic> json) =>
    GetStanStItem(
      id: (json['id'] as num).toInt(),
      firma: (json['firma'] as num?)?.toInt(),
      nazwa: json['nazwa'] as String?,
      nrewid: json['nrewid'] as String?,
      osoba: json['osoba'] as String?,
      dataZakupu: json['data_zakupu'] as String?,
      stan: (json['stan'] as num?)?.toInt(),
      idmiejsce: (json['idmiejsce'] as num?)?.toInt(),
      miejsce: json['miejsce'] as String?,
      kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
      wartoscP: _decimalStringFromJson(json['wartosc_p']),
      wartoscA: _decimalStringFromJson(json['wartosc_a']),
      lvl: json['lvl'] as String?,
      dataImportu: json['data_importu'] as String?,
    );

Map<String, dynamic> _$GetStanStItemToJson(GetStanStItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firma': instance.firma,
      'nazwa': instance.nazwa,
      'nrewid': instance.nrewid,
      'osoba': instance.osoba,
      'data_zakupu': instance.dataZakupu,
      'stan': instance.stan,
      'idmiejsce': instance.idmiejsce,
      'miejsce': instance.miejsce,
      'kod_kreskowy': instance.kodKreskowy,
      'wartosc_p': _decimalStringToJson(instance.wartoscP),
      'wartosc_a': _decimalStringToJson(instance.wartoscA),
      'lvl': instance.lvl,
      'data_importu': instance.dataImportu,
    };

GetStanStMeta _$GetStanStMetaFromJson(Map<String, dynamic> json) =>
    GetStanStMeta(
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$GetStanStMetaToJson(GetStanStMeta instance) =>
    <String, dynamic>{
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };
