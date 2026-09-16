// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_arkusz_details_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArkuszDetailsResponseData _$GetArkuszDetailsResponseDataFromJson(
  Map<String, dynamic> json,
) => GetArkuszDetailsResponseData(
  arkusz: GetArkuszDetailsHeader.fromJson(
    json['arkusz'] as Map<String, dynamic>,
  ),
  komisja: (json['komisja'] as List<dynamic>)
      .map(
        (e) => GetArkuszDetailsKomisjaItem.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  elementy: (json['elementy'] as List<dynamic>)
      .map(
        (e) => GetArkuszDetailsElementItem.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$GetArkuszDetailsResponseDataToJson(
  GetArkuszDetailsResponseData instance,
) => <String, dynamic>{
  'arkusz': instance.arkusz,
  'komisja': instance.komisja,
  'elementy': instance.elementy,
};

GetArkuszDetailsHeader _$GetArkuszDetailsHeaderFromJson(
  Map<String, dynamic> json,
) => GetArkuszDetailsHeader(
  id: (json['id'] as num).toInt(),
  idInwentaryzacja: (json['id_inwentaryzacja'] as num).toInt(),
  numer: json['numer'] as String?,
  idMiejsca: (json['id_miejsca'] as num?)?.toInt(),
  nazwaMiejsca: json['nazwa_miejsca'] as String?,
  lvlMiejsca: json['lvl_miejsca'] as String?,
  firma: (json['firma'] as num?)?.toInt(),
  wczytanest: (json['wczytanest'] as num?)?.toInt(),
  rozpoczecie: json['rozpoczecie'] as String?,
  zakonczenie: json['zakonczenie'] as String?,
);

Map<String, dynamic> _$GetArkuszDetailsHeaderToJson(
  GetArkuszDetailsHeader instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_inwentaryzacja': instance.idInwentaryzacja,
  'numer': instance.numer,
  'id_miejsca': instance.idMiejsca,
  'nazwa_miejsca': instance.nazwaMiejsca,
  'lvl_miejsca': instance.lvlMiejsca,
  'firma': instance.firma,
  'wczytanest': instance.wczytanest,
  'rozpoczecie': instance.rozpoczecie,
  'zakonczenie': instance.zakonczenie,
};

GetArkuszDetailsKomisjaItem _$GetArkuszDetailsKomisjaItemFromJson(
  Map<String, dynamic> json,
) => GetArkuszDetailsKomisjaItem(
  userId: (json['user_id'] as num).toInt(),
  displayName: json['display_name'] as String,
);

Map<String, dynamic> _$GetArkuszDetailsKomisjaItemToJson(
  GetArkuszDetailsKomisjaItem instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'display_name': instance.displayName,
};

GetArkuszDetailsElementItem _$GetArkuszDetailsElementItemFromJson(
  Map<String, dynamic> json,
) => GetArkuszDetailsElementItem(
  id: (json['id'] as num).toInt(),
  idarkuszSpisu: (json['idarkusz_spisu'] as num?)?.toInt(),
  firma: (json['firma'] as num?)?.toInt(),
  nazwa: json['nazwa'] as String?,
  nrewid: json['nrewid'] as String?,
  osoba: json['osoba'] as String?,
  aktualnyStan: _srodekTrwalyStatusFromJson(json['aktualny_stan']),
  idmiejsce: (json['idmiejsce'] as num?)?.toInt(),
  miejsce: json['miejsce'] as String?,
  lvl: json['lvl'] as String?,
  kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
  wartoscP: _decimalStringFromJson(json['wartosc_p']),
  wartoscA: _decimalStringFromJson(json['wartosc_a']),
  dataZakupu: json['data_zakupu'] as String?,
  stanInwent: _arkuszElementInwentStatusFromJson(json['stan_inwent']),
  statusSpisu: const ArkuszElementStatusSpisuConverter().fromJson(
    json['status_spisu'] as String?,
  ),
  likwidacja: _boolFromJson(json['likwidacja']),
  nadwyzka: _boolFromJson(json['nadwyzka']),
  nowyKodKreskowy: json['nowy_kod_kreskowy'] as String?,
  nowaOsoba: json['nowa_osoba'] as String?,
  nowaNazwa: json['nowa_nazwa'] as String?,
  uwagiLoc: json['uwagi_loc'] as String?,
  kkWczytany: _boolFromJson(json['kk_wczytany']),
  nadwIdmiejsce: (json['nadw_idmiejsce'] as num?)?.toInt(),
  nadwMiejsce: json['nadw_miejsce'] as String?,
  nadwLvl: json['nadw_lvl'] as String?,
  nadwIdFirmy: (json['nadw_id_firmy'] as num?)?.toInt(),
  nadwFirma: json['nadw_firma'] as String?,
  foundInArkuszNumer: json['found_in_arkusz_numer'] as String?,
  foundInMiejsce: json['found_in_miejsce'] as String?,
);

Map<String, dynamic> _$GetArkuszDetailsElementItemToJson(
  GetArkuszDetailsElementItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'idarkusz_spisu': instance.idarkuszSpisu,
  'firma': instance.firma,
  'nazwa': instance.nazwa,
  'nrewid': instance.nrewid,
  'osoba': instance.osoba,
  'aktualny_stan': _srodekTrwalyStatusToJson(instance.aktualnyStan),
  'idmiejsce': instance.idmiejsce,
  'miejsce': instance.miejsce,
  'lvl': instance.lvl,
  'kod_kreskowy': instance.kodKreskowy,
  'wartosc_p': _decimalStringToJson(instance.wartoscP),
  'wartosc_a': _decimalStringToJson(instance.wartoscA),
  'data_zakupu': instance.dataZakupu,
  'stan_inwent': _arkuszElementInwentStatusToJson(instance.stanInwent),
  'status_spisu': const ArkuszElementStatusSpisuConverter().toJson(
    instance.statusSpisu,
  ),
  'likwidacja': _boolToJson(instance.likwidacja),
  'nadwyzka': _boolToJson(instance.nadwyzka),
  'nowy_kod_kreskowy': instance.nowyKodKreskowy,
  'nowa_osoba': instance.nowaOsoba,
  'nowa_nazwa': instance.nowaNazwa,
  'uwagi_loc': instance.uwagiLoc,
  'kk_wczytany': _boolToJson(instance.kkWczytany),
  'nadw_idmiejsce': instance.nadwIdmiejsce,
  'nadw_miejsce': instance.nadwMiejsce,
  'nadw_lvl': instance.nadwLvl,
  'nadw_id_firmy': instance.nadwIdFirmy,
  'nadw_firma': instance.nadwFirma,
  'found_in_arkusz_numer': instance.foundInArkuszNumer,
  'found_in_miejsce': instance.foundInMiejsce,
};
