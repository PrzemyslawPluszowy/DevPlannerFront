// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inwentaryzacja_details_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInwentaryzacjaDetailsResponseData
_$GetInwentaryzacjaDetailsResponseDataFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaDetailsResponseData(
  inwentaryzacja: GetInwentaryzacjaDetailsHeader.fromJson(
    json['inwentaryzacja'] as Map<String, dynamic>,
  ),
  komisja: (json['komisja'] as List<dynamic>)
      .map(
        (e) => GetInwentaryzacjaDetailsKomisjaItem.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  arkusze: (json['arkusze'] as List<dynamic>)
      .map(
        (e) => GetInwentaryzacjaDetailsArkuszItem.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$GetInwentaryzacjaDetailsResponseDataToJson(
  GetInwentaryzacjaDetailsResponseData instance,
) => <String, dynamic>{
  'inwentaryzacja': instance.inwentaryzacja,
  'komisja': instance.komisja,
  'arkusze': instance.arkusze,
};

GetInwentaryzacjaDetailsHeader _$GetInwentaryzacjaDetailsHeaderFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaDetailsHeader(
  id: (json['id'] as num).toInt(),
  numer: json['numer'] as String,
  status: (json['status'] as num).toInt(),
  dataOd: json['data_od'] as String?,
  dataDo: json['data_do'] as String?,
  firma: (json['firma'] as num?)?.toInt(),
  firmaNazwa: json['firma_nazwa'] as String?,
  firmy:
      (json['firmy'] as List<dynamic>?)
          ?.map(
            (e) => GetInwentaryzacjaDetailsFirmaItem.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$GetInwentaryzacjaDetailsHeaderToJson(
  GetInwentaryzacjaDetailsHeader instance,
) => <String, dynamic>{
  'id': instance.id,
  'data_od': instance.dataOd,
  'data_do': instance.dataDo,
  'firma': instance.firma,
  'firma_nazwa': instance.firmaNazwa,
  'firmy': instance.firmy,
  'numer': instance.numer,
  'uwagi': instance.uwagi,
  'status': instance.status,
};

GetInwentaryzacjaDetailsFirmaItem _$GetInwentaryzacjaDetailsFirmaItemFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaDetailsFirmaItem(
  id: (json['id'] as num).toInt(),
  nazwaFirmy: json['nazwa_firmy'] as String?,
);

Map<String, dynamic> _$GetInwentaryzacjaDetailsFirmaItemToJson(
  GetInwentaryzacjaDetailsFirmaItem instance,
) => <String, dynamic>{'id': instance.id, 'nazwa_firmy': instance.nazwaFirmy};

GetInwentaryzacjaDetailsKomisjaItem
_$GetInwentaryzacjaDetailsKomisjaItemFromJson(Map<String, dynamic> json) =>
    GetInwentaryzacjaDetailsKomisjaItem(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      displayName: json['display_name'] as String,
    );

Map<String, dynamic> _$GetInwentaryzacjaDetailsKomisjaItemToJson(
  GetInwentaryzacjaDetailsKomisjaItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'display_name': instance.displayName,
};

GetInwentaryzacjaDetailsArkuszKomisjaItem
_$GetInwentaryzacjaDetailsArkuszKomisjaItemFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaDetailsArkuszKomisjaItem(
  userId: (json['user_id'] as num).toInt(),
  displayName: json['display_name'] as String,
);

Map<String, dynamic> _$GetInwentaryzacjaDetailsArkuszKomisjaItemToJson(
  GetInwentaryzacjaDetailsArkuszKomisjaItem instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'display_name': instance.displayName,
};

GetInwentaryzacjaDetailsArkuszItem _$GetInwentaryzacjaDetailsArkuszItemFromJson(
  Map<String, dynamic> json,
) => GetInwentaryzacjaDetailsArkuszItem(
  id: (json['id'] as num).toInt(),
  numer: json['numer'] as String?,
  idMiejsca: (json['id_miejsca'] as num?)?.toInt(),
  nazwaMiejsca: json['nazwa_miejsca'] as String?,
  lvlMiejsca: json['lvl_miejsca'] as String?,
  firma: (json['firma'] as num?)?.toInt(),
  wczytanest: (json['wczytanest'] as num?)?.toInt(),
  rozpoczecie: json['rozpoczecie'] as String?,
  zakonczenie: json['zakonczenie'] as String?,
  elementyCount: (json['elementy_count'] as num?)?.toInt() ?? 0,
  komisja:
      (json['komisja'] as List<dynamic>?)
          ?.map(
            (e) => GetInwentaryzacjaDetailsArkuszKomisjaItem.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$GetInwentaryzacjaDetailsArkuszItemToJson(
  GetInwentaryzacjaDetailsArkuszItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'numer': instance.numer,
  'id_miejsca': instance.idMiejsca,
  'nazwa_miejsca': instance.nazwaMiejsca,
  'lvl_miejsca': instance.lvlMiejsca,
  'firma': instance.firma,
  'wczytanest': instance.wczytanest,
  'rozpoczecie': instance.rozpoczecie,
  'zakonczenie': instance.zakonczenie,
  'elementy_count': instance.elementyCount,
  'komisja': instance.komisja,
};
