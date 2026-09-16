// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inwentaryzacja_search_arkusze_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInwentaryzacjaSearchArkuszeResponseData
_$GetInwentaryzacjaSearchArkuszeResponseDataFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaSearchArkuszeResponseData(
  meta: GetInwentaryzacjaSearchArkuszeMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => GetInwentaryzacjaSearchArkuszeGroup.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$GetInwentaryzacjaSearchArkuszeResponseDataToJson(
  GetInwentaryzacjaSearchArkuszeResponseData instance,
) => <String, dynamic>{'meta': instance.meta, 'items': instance.items};

GetInwentaryzacjaSearchArkuszeMeta _$GetInwentaryzacjaSearchArkuszeMetaFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaSearchArkuszeMeta(
  scope: json['scope'] as String,
  scopeId: (json['scope_id'] as num).toInt(),
  generatedAt: json['generated_at'] as String,
  inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta.fromJson(
    json['inwentaryzacja'] as Map<String, dynamic>,
  ),
  filters: GetInwentaryzacjaSearchArkuszeFilters.fromJson(
    json['filters'] as Map<String, dynamic>,
  ),
  totals: GetInwentaryzacjaSearchArkuszeTotals.fromJson(
    json['totals'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GetInwentaryzacjaSearchArkuszeMetaToJson(
  GetInwentaryzacjaSearchArkuszeMeta instance,
) => <String, dynamic>{
  'scope': instance.scope,
  'scope_id': instance.scopeId,
  'generated_at': instance.generatedAt,
  'inwentaryzacja': instance.inwentaryzacja,
  'filters': instance.filters,
  'totals': instance.totals,
};

GetInwentaryzacjaSearchArkuszeInventoryMeta
_$GetInwentaryzacjaSearchArkuszeInventoryMetaFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaSearchArkuszeInventoryMeta(
  id: (json['id'] as num).toInt(),
  numer: json['numer'] as String?,
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetInwentaryzacjaSearchArkuszeInventoryMetaToJson(
  GetInwentaryzacjaSearchArkuszeInventoryMeta instance,
) => <String, dynamic>{
  'id': instance.id,
  'numer': instance.numer,
  'status': instance.status,
};

GetInwentaryzacjaSearchArkuszeFilters
_$GetInwentaryzacjaSearchArkuszeFiltersFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaSearchArkuszeFilters(
      q: json['q'] as String,
      sortBy: json['sort_by'] as String,
      sortDir: json['sort_dir'] as String,
    );

Map<String, dynamic> _$GetInwentaryzacjaSearchArkuszeFiltersToJson(
  GetInwentaryzacjaSearchArkuszeFilters instance,
) => <String, dynamic>{
  'q': instance.q,
  'sort_by': instance.sortBy,
  'sort_dir': instance.sortDir,
};

GetInwentaryzacjaSearchArkuszeTotals
_$GetInwentaryzacjaSearchArkuszeTotalsFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaSearchArkuszeTotals(
      groupsCount: (json['groups_count'] as num).toInt(),
      matchesCount: (json['matches_count'] as num).toInt(),
    );

Map<String, dynamic> _$GetInwentaryzacjaSearchArkuszeTotalsToJson(
  GetInwentaryzacjaSearchArkuszeTotals instance,
) => <String, dynamic>{
  'groups_count': instance.groupsCount,
  'matches_count': instance.matchesCount,
};

GetInwentaryzacjaSearchArkuszeGroup
_$GetInwentaryzacjaSearchArkuszeGroupFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaSearchArkuszeGroup(
  identityKey: json['identity_key'] as String,
  matchesCount: (json['matches_count'] as num).toInt(),
  hasMultipleMatches: json['has_multiple_matches'] as bool,
  hasMixedStatuses: json['has_mixed_statuses'] as bool,
  uiStatuses: (json['ui_statuses'] as List<dynamic>)
      .map((e) => const SearchArkuszeUiStatusConverter().fromJson(e as String?))
      .toList(),
  matches: (json['matches'] as List<dynamic>)
      .map(
        (e) => GetInwentaryzacjaSearchArkuszeMatch.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  firma: (json['firma'] as num?)?.toInt(),
  nrewid: json['nrewid'] as String?,
  kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
  nazwa: json['nazwa'] as String?,
  osoba: json['osoba'] as String?,
);

Map<String, dynamic> _$GetInwentaryzacjaSearchArkuszeGroupToJson(
  GetInwentaryzacjaSearchArkuszeGroup instance,
) => <String, dynamic>{
  'identity_key': instance.identityKey,
  'firma': instance.firma,
  'nrewid': instance.nrewid,
  'kod_kreskowy': instance.kodKreskowy,
  'nazwa': instance.nazwa,
  'osoba': instance.osoba,
  'matches_count': instance.matchesCount,
  'has_multiple_matches': instance.hasMultipleMatches,
  'has_mixed_statuses': instance.hasMixedStatuses,
  'ui_statuses': instance.uiStatuses
      .map(const SearchArkuszeUiStatusConverter().toJson)
      .toList(),
  'matches': instance.matches,
};

GetInwentaryzacjaSearchArkuszeMatch
_$GetInwentaryzacjaSearchArkuszeMatchFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaSearchArkuszeMatch(
      elementId: (json['element_id'] as num).toInt(),
      uiStatus: const SearchArkuszeUiStatusConverter().fromJson(
        json['ui_status'] as String?,
      ),
      arkuszId: (json['arkusz_id'] as num?)?.toInt(),
      arkuszNumer: json['arkusz_numer'] as String?,
      arkuszMiejsce: json['arkusz_miejsce'] as String?,
      firma: (json['firma'] as num?)?.toInt(),
      nrewid: json['nrewid'] as String?,
      nazwa: json['nazwa'] as String?,
      osoba: json['osoba'] as String?,
      kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
      stanInwent: _arkuszElementInwentStatusFromJson(json['stan_inwent']),
      statusSpisu: const ArkuszElementStatusSpisuConverter().fromJson(
        json['status_spisu'] as String?,
      ),
      likwidacja: _boolFromJson(json['likwidacja']),
      nadwyzka: _boolFromJson(json['nadwyzka']),
      foundInArkuszNumer: json['found_in_arkusz_numer'] as String?,
      foundInMiejsce: json['found_in_miejsce'] as String?,
    );

Map<String, dynamic> _$GetInwentaryzacjaSearchArkuszeMatchToJson(
  GetInwentaryzacjaSearchArkuszeMatch instance,
) => <String, dynamic>{
  'element_id': instance.elementId,
  'arkusz_id': instance.arkuszId,
  'arkusz_numer': instance.arkuszNumer,
  'arkusz_miejsce': instance.arkuszMiejsce,
  'firma': instance.firma,
  'nrewid': instance.nrewid,
  'nazwa': instance.nazwa,
  'osoba': instance.osoba,
  'kod_kreskowy': instance.kodKreskowy,
  'stan_inwent': _arkuszElementInwentStatusToJson(instance.stanInwent),
  'status_spisu': const ArkuszElementStatusSpisuConverter().toJson(
    instance.statusSpisu,
  ),
  'likwidacja': _boolToJson(instance.likwidacja),
  'nadwyzka': _boolToJson(instance.nadwyzka),
  'found_in_arkusz_numer': instance.foundInArkuszNumer,
  'found_in_miejsce': instance.foundInMiejsce,
  'ui_status': const SearchArkuszeUiStatusConverter().toJson(instance.uiStatus),
};
