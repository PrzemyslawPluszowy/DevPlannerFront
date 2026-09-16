// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inwentaryzacje_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInwentaryzacjeQuery _$GetInwentaryzacjeQueryFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjeQuery(
  firma: (json['firma'] as num?)?.toInt(),
  status: (json['status'] as num?)?.toInt(),
  numer: json['numer'] as String?,
  dataOdFrom: json['data_od_from'] as String?,
  dataOdTo: json['data_od_to'] as String?,
  sortBy: $enumDecodeNullable(
    _$GetInwentaryzacjeSortByEnumMap,
    json['sort_by'],
  ),
  sortDir: $enumDecodeNullable(
    _$GetInwentaryzacjeSortDirectionEnumMap,
    json['sort_dir'],
  ),
);

Map<String, dynamic> _$GetInwentaryzacjeQueryToJson(
  GetInwentaryzacjeQuery instance,
) => <String, dynamic>{
  'firma': instance.firma,
  'status': instance.status,
  'numer': instance.numer,
  'data_od_from': instance.dataOdFrom,
  'data_od_to': instance.dataOdTo,
  'sort_by': _$GetInwentaryzacjeSortByEnumMap[instance.sortBy],
  'sort_dir': _$GetInwentaryzacjeSortDirectionEnumMap[instance.sortDir],
};

const _$GetInwentaryzacjeSortByEnumMap = {
  GetInwentaryzacjeSortBy.id: 'id',
  GetInwentaryzacjeSortBy.dataOd: 'data_od',
  GetInwentaryzacjeSortBy.dataDo: 'data_do',
  GetInwentaryzacjeSortBy.numer: 'numer',
  GetInwentaryzacjeSortBy.status: 'status',
};

const _$GetInwentaryzacjeSortDirectionEnumMap = {
  GetInwentaryzacjeSortDirection.asc: 'ASC',
  GetInwentaryzacjeSortDirection.desc: 'DESC',
};

GetInwentaryzacjeResponseData _$GetInwentaryzacjeResponseDataFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjeResponseData(
  items: (json['items'] as List<dynamic>)
      .map((e) => GetInwentaryzacjeItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: GetInwentaryzacjeMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetInwentaryzacjeResponseDataToJson(
  GetInwentaryzacjeResponseData instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};

GetInwentaryzacjeItem _$GetInwentaryzacjeItemFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjeItem(
  id: (json['id'] as num).toInt(),
  firma: (json['firma'] as num).toInt(),
  numer: json['numer'] as String,
  status: $enumDecode(
    _$InwentaryzacjaStatusEnumMap,
    json['status'],
    unknownValue: InwentaryzacjaStatus.nieznany,
  ),
  dataOd: json['data_od'] as String?,
  dataDo: json['data_do'] as String?,
  firmy:
      (json['firmy'] as List<dynamic>?)
          ?.map(
            (e) =>
                GetInwentaryzacjeFirmaItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  uwagi: json['uwagi'] as String?,
  komisjaCount: (json['komisja_count'] as num?)?.toInt() ?? 0,
  arkuszeCount: (json['arkusze_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GetInwentaryzacjeItemToJson(
  GetInwentaryzacjeItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'data_od': instance.dataOd,
  'data_do': instance.dataDo,
  'firma': instance.firma,
  'firmy': instance.firmy,
  'numer': instance.numer,
  'uwagi': instance.uwagi,
  'status': _$InwentaryzacjaStatusEnumMap[instance.status]!,
  'komisja_count': instance.komisjaCount,
  'arkusze_count': instance.arkuszeCount,
};

const _$InwentaryzacjaStatusEnumMap = {
  InwentaryzacjaStatus.nowa: 0,
  InwentaryzacjaStatus.wToku: 1,
  InwentaryzacjaStatus.zakonczona: 2,
  InwentaryzacjaStatus.nieznany: -1,
};

GetInwentaryzacjeFirmaItem _$GetInwentaryzacjeFirmaItemFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjeFirmaItem(
  idFirmy: (_readIdFirmyFromJson(json, 'id_firmy') as num).toInt(),
  nazwa: json['nazwa'] as String?,
);

Map<String, dynamic> _$GetInwentaryzacjeFirmaItemToJson(
  GetInwentaryzacjeFirmaItem instance,
) => <String, dynamic>{'id_firmy': instance.idFirmy, 'nazwa': instance.nazwa};

GetInwentaryzacjeMeta _$GetInwentaryzacjeMetaFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjeMeta(
  total: (json['total'] as num).toInt(),
  sortBy: json['sort_by'] as String,
  sortDir: json['sort_dir'] as String,
);

Map<String, dynamic> _$GetInwentaryzacjeMetaToJson(
  GetInwentaryzacjeMeta instance,
) => <String, dynamic>{
  'total': instance.total,
  'sort_by': instance.sortBy,
  'sort_dir': instance.sortDir,
};
