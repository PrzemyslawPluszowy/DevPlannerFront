// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inwentaryzacja_presence_conflicts_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInwentaryzacjaPresenceConflictsResponseData
_$GetInwentaryzacjaPresenceConflictsResponseDataFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaPresenceConflictsResponseData(
  meta: GetInwentaryzacjaPresenceConflictsMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => GetInwentaryzacjaPresenceConflictsGroup.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$GetInwentaryzacjaPresenceConflictsResponseDataToJson(
  GetInwentaryzacjaPresenceConflictsResponseData instance,
) => <String, dynamic>{'meta': instance.meta, 'items': instance.items};

GetInwentaryzacjaPresenceConflictsMeta
_$GetInwentaryzacjaPresenceConflictsMetaFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaPresenceConflictsMeta(
      scope: json['scope'] as String,
      scopeId: (json['scope_id'] as num).toInt(),
      generatedAt: json['generated_at'] as String,
      inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta.fromJson(
        json['inwentaryzacja'] as Map<String, dynamic>,
      ),
      totals: GetInwentaryzacjaPresenceConflictsTotals.fromJson(
        json['totals'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GetInwentaryzacjaPresenceConflictsMetaToJson(
  GetInwentaryzacjaPresenceConflictsMeta instance,
) => <String, dynamic>{
  'scope': instance.scope,
  'scope_id': instance.scopeId,
  'generated_at': instance.generatedAt,
  'inwentaryzacja': instance.inwentaryzacja,
  'totals': instance.totals,
};

GetInwentaryzacjaPresenceConflictsTotals
_$GetInwentaryzacjaPresenceConflictsTotalsFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaPresenceConflictsTotals(
      itemsCount: (json['items_count'] as num).toInt(),
    );

Map<String, dynamic> _$GetInwentaryzacjaPresenceConflictsTotalsToJson(
  GetInwentaryzacjaPresenceConflictsTotals instance,
) => <String, dynamic>{'items_count': instance.itemsCount};

GetInwentaryzacjaPresenceConflictsGroup
_$GetInwentaryzacjaPresenceConflictsGroupFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaPresenceConflictsGroup(
      identityKey: json['identity_key'] as String,
      presenceCount: (json['presence_count'] as num).toInt(),
      arkuszeCount: (json['arkusze_count'] as num).toInt(),
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

Map<String, dynamic> _$GetInwentaryzacjaPresenceConflictsGroupToJson(
  GetInwentaryzacjaPresenceConflictsGroup instance,
) => <String, dynamic>{
  'identity_key': instance.identityKey,
  'firma': instance.firma,
  'nrewid': instance.nrewid,
  'kod_kreskowy': instance.kodKreskowy,
  'nazwa': instance.nazwa,
  'osoba': instance.osoba,
  'presence_count': instance.presenceCount,
  'arkusze_count': instance.arkuszeCount,
  'matches': instance.matches,
};
