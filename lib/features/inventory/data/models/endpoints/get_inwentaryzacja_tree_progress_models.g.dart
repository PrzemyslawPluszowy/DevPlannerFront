// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inwentaryzacja_tree_progress_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInwentaryzacjaTreeProgressResponseData
_$GetInwentaryzacjaTreeProgressResponseDataFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaTreeProgressResponseData(
  meta: GetInwentaryzacjaTreeProgressMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => GetInwentaryzacjaTreeProgressItem.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$GetInwentaryzacjaTreeProgressResponseDataToJson(
  GetInwentaryzacjaTreeProgressResponseData instance,
) => <String, dynamic>{'meta': instance.meta, 'items': instance.items};

GetInwentaryzacjaTreeProgressMeta _$GetInwentaryzacjaTreeProgressMetaFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaTreeProgressMeta(
  scope: json['scope'] as String,
  scopeId: (json['scope_id'] as num).toInt(),
  generatedAt: json['generated_at'] as String,
  inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta.fromJson(
    json['inwentaryzacja'] as Map<String, dynamic>,
  ),
  firmyScope: (json['firmy_scope'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  totals: GetInwentaryzacjaTreeProgressTotals.fromJson(
    json['totals'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GetInwentaryzacjaTreeProgressMetaToJson(
  GetInwentaryzacjaTreeProgressMeta instance,
) => <String, dynamic>{
  'scope': instance.scope,
  'scope_id': instance.scopeId,
  'generated_at': instance.generatedAt,
  'inwentaryzacja': instance.inwentaryzacja,
  'firmy_scope': instance.firmyScope,
  'totals': instance.totals,
};

GetInwentaryzacjaTreeProgressTotals
_$GetInwentaryzacjaTreeProgressTotalsFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaTreeProgressTotals(
      itemsCount: (json['items_count'] as num).toInt(),
      ambiguousPlacesCount:
          (json['ambiguous_places_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GetInwentaryzacjaTreeProgressTotalsToJson(
  GetInwentaryzacjaTreeProgressTotals instance,
) => <String, dynamic>{
  'items_count': instance.itemsCount,
  'ambiguous_places_count': instance.ambiguousPlacesCount,
};

GetInwentaryzacjaTreeProgressItem _$GetInwentaryzacjaTreeProgressItemFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaTreeProgressItem(
  id: (json['id'] as num).toInt(),
  idMiejsca: (json['id_miejsca'] as num).toInt(),
  idFirmy: (json['id_firmy'] as num).toInt(),
  baza: json['baza'] as String,
  productsCount: (json['products_count'] as num).toInt(),
  isAmbiguous: json['is_ambiguous'] as bool,
  arkuszExists: json['arkusz_exists'] as bool,
  idparent: (json['idparent'] as num?)?.toInt(),
  nazwa: json['nazwa'] as String?,
  lvl: json['lvl'] as String?,
  arkuszId: (json['arkusz_id'] as num?)?.toInt(),
  arkuszNumer: json['arkusz_numer'] as String?,
);

Map<String, dynamic> _$GetInwentaryzacjaTreeProgressItemToJson(
  GetInwentaryzacjaTreeProgressItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_miejsca': instance.idMiejsca,
  'idparent': instance.idparent,
  'id_firmy': instance.idFirmy,
  'baza': instance.baza,
  'nazwa': instance.nazwa,
  'lvl': instance.lvl,
  'products_count': instance.productsCount,
  'is_ambiguous': instance.isAmbiguous,
  'arkusz_exists': instance.arkuszExists,
  'arkusz_id': instance.arkuszId,
  'arkusz_numer': instance.arkuszNumer,
};
