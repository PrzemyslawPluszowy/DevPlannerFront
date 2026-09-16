// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inwentaryzacja_surplus_conflicts_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInwentaryzacjaSurplusConflictsResponseData
_$GetInwentaryzacjaSurplusConflictsResponseDataFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaSurplusConflictsResponseData(
  meta: GetInwentaryzacjaSurplusConflictsMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => GetInwentaryzacjaSurplusConflictItem.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$GetInwentaryzacjaSurplusConflictsResponseDataToJson(
  GetInwentaryzacjaSurplusConflictsResponseData instance,
) => <String, dynamic>{'meta': instance.meta, 'items': instance.items};

GetInwentaryzacjaSurplusConflictsMeta
_$GetInwentaryzacjaSurplusConflictsMetaFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaSurplusConflictsMeta(
      scope: json['scope'] as String,
      scopeId: (json['scope_id'] as num).toInt(),
      generatedAt: json['generated_at'] as String,
      inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta.fromJson(
        json['inwentaryzacja'] as Map<String, dynamic>,
      ),
      totals: GetInwentaryzacjaSurplusConflictsTotals.fromJson(
        json['totals'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetInwentaryzacjaSurplusConflictsMetaToJson(
  GetInwentaryzacjaSurplusConflictsMeta instance,
) => <String, dynamic>{
  'scope': instance.scope,
  'scope_id': instance.scopeId,
  'generated_at': instance.generatedAt,
  'inwentaryzacja': instance.inwentaryzacja,
  'totals': instance.totals,
};

GetInwentaryzacjaSurplusConflictsTotals
_$GetInwentaryzacjaSurplusConflictsTotalsFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaSurplusConflictsTotals(
      itemsCount: (json['items_count'] as num).toInt(),
    );

Map<String, dynamic> _$GetInwentaryzacjaSurplusConflictsTotalsToJson(
  GetInwentaryzacjaSurplusConflictsTotals instance,
) => <String, dynamic>{'items_count': instance.itemsCount};

GetInwentaryzacjaSurplusConflictItem
_$GetInwentaryzacjaSurplusConflictItemFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaSurplusConflictItem(
      elementId: (json['element_id'] as num).toInt(),
      arkuszId: (json['arkusz_id'] as num?)?.toInt(),
      arkuszNumer: json['arkusz_numer'] as String?,
      arkuszMiejsce: json['arkusz_miejsce'] as String?,
      firma: (json['firma'] as num?)?.toInt(),
      nrewid: json['nrewid'] as String?,
      kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
      nazwa: json['nazwa'] as String?,
      osoba: json['osoba'] as String?,
      stanInwent: json['stan_inwent'] as String?,
      statusSpisu: json['status_spisu'] as String?,
      nadwyzka: json['nadwyzka'] as bool?,
      matchBasis: json['match_basis'] as String?,
    );

Map<String, dynamic> _$GetInwentaryzacjaSurplusConflictItemToJson(
  GetInwentaryzacjaSurplusConflictItem instance,
) => <String, dynamic>{
  'element_id': instance.elementId,
  'arkusz_id': instance.arkuszId,
  'arkusz_numer': instance.arkuszNumer,
  'arkusz_miejsce': instance.arkuszMiejsce,
  'firma': instance.firma,
  'nrewid': instance.nrewid,
  'kod_kreskowy': instance.kodKreskowy,
  'nazwa': instance.nazwa,
  'osoba': instance.osoba,
  'stan_inwent': instance.stanInwent,
  'status_spisu': instance.statusSpisu,
  'nadwyzka': instance.nadwyzka,
  'match_basis': instance.matchBasis,
};
