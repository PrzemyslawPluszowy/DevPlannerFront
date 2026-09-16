// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_user_detail_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpUserStandardItem _$GetBhpUserStandardItemFromJson(
  Map<String, dynamic> json,
) => GetBhpUserStandardItem(
  id: (json['id'] as num).toInt(),
  stanowiskoId: (json['stanowisko_id'] as num?)?.toInt(),
  kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num?)?.toInt(),
  kartaWyposazeniaSymbol: json['karta_wyposazenia_symbol'] as String?,
  kartaWyposazeniaNazwa: json['karta_wyposazenia_nazwa'] as String?,
  kartaWyposazeniaJm: json['karta_wyposazenia_jm'] as String?,
  kartaAktywna: json['karta_aktywna'] as bool? ?? true,
  kartaOkresUzywalnosci: json['karta_okres_uzywalnosci'] as String?,
  kartaIloscDomyslna: json['karta_ilosc_domyslna'] as String?,
  kartaEkwiwalent: json['karta_ekwiwalent'] as String?,
  kartaCena: json['karta_cena'] as String?,
  okres: (json['okres'] as num?)?.toInt(),
  ilosc: json['ilosc'] as String?,
  uwagi: json['uwagi'] as String?,
  aktywny: json['aktywny'] as bool,
  legacyStatus: (json['legacy_status'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetBhpUserStandardItemToJson(
  GetBhpUserStandardItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'stanowisko_id': instance.stanowiskoId,
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'karta_wyposazenia_symbol': instance.kartaWyposazeniaSymbol,
  'karta_wyposazenia_nazwa': instance.kartaWyposazeniaNazwa,
  'karta_wyposazenia_jm': instance.kartaWyposazeniaJm,
  'karta_aktywna': instance.kartaAktywna,
  'karta_okres_uzywalnosci': instance.kartaOkresUzywalnosci,
  'karta_ilosc_domyslna': instance.kartaIloscDomyslna,
  'karta_ekwiwalent': instance.kartaEkwiwalent,
  'karta_cena': instance.kartaCena,
  'okres': instance.okres,
  'ilosc': instance.ilosc,
  'uwagi': instance.uwagi,
  'aktywny': instance.aktywny,
  'legacy_status': instance.legacyStatus,
};

GetBhpUserDetail _$GetBhpUserDetailFromJson(
  Map<String, dynamic> json,
) => GetBhpUserDetail(
  nrEwidencyjny: json['nr_ewidencyjny'] as String?,
  pesel: json['pesel'] as String?,
  numerTelefonu: json['numer_telefonu'] as String?,
  readyId: (json['ready_id'] as num?)?.toInt(),
  imie: json['imie'] as String?,
  nazwisko: json['nazwisko'] as String?,
  aktywny: json['aktywny'] as bool,
  dataRozpPracy: json['data_rozp_pracy'] as String?,
  dataZakPracy: json['data_zak_pracy'] as String?,
  miejsceZamieszkania: json['miejsce_zamieszkania'] as String?,
  wzrost: json['wzrost'] as String?,
  obwodKlatkiPiers: json['obwod_klatki_piers'] as String?,
  obwodPasa: json['obwod_pasa'] as String?,
  obwodGlowy: json['obwod_glowy'] as String?,
  dlStopy: json['dl_stopy'] as String?,
  uwagi: json['uwagi'] as String?,
  stanowiskoId: (json['stanowisko_id'] as num?)?.toInt(),
  stanowiskoNazwa: json['stanowisko_nazwa'] as String?,
  stanowiskoLegacyLabel: json['stanowisko_legacy_label'] as String?,
  legacyStatus: (json['legacy_status'] as num?)?.toInt(),
  archivedAt: json['archived_at'] as String?,
  isArchived: json['is_archived'] as bool,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  stanowisko: json['stanowisko'] == null
      ? null
      : GetBhpUserPosition.fromJson(json['stanowisko'] as Map<String, dynamic>),
  standardWyposazenia: (json['standard_wyposazenia'] as List<dynamic>)
      .map((e) => GetBhpUserStandardItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  wydaniaAktywne: (json['wydania_aktywne'] as List<dynamic>)
      .map((e) => GetBhpUserIssue.fromJson(e as Map<String, dynamic>))
      .toList(),
  historiaWydan: (json['historia_wydan'] as List<dynamic>)
      .map((e) => GetBhpUserIssue.fromJson(e as Map<String, dynamic>))
      .toList(),
  operacje: (json['operacje'] as List<dynamic>)
      .map((e) => GetBhpUserOperation.fromJson(e as Map<String, dynamic>))
      .toList(),
  liczbaPozycjiStandardu: (json['liczba_pozycji_standardu'] as num).toInt(),
  liczbaAktywnychWydan: (json['liczba_aktywnych_wydan'] as num).toInt(),
  maAktywneWydania: json['ma_aktywne_wydania'] as bool,
  canReceiveIssues: json['can_receive_issues'] as bool,
);

Map<String, dynamic> _$GetBhpUserDetailToJson(GetBhpUserDetail instance) =>
    <String, dynamic>{
      'nr_ewidencyjny': instance.nrEwidencyjny,
      'pesel': instance.pesel,
      'numer_telefonu': instance.numerTelefonu,
      'ready_id': instance.readyId,
      'imie': instance.imie,
      'nazwisko': instance.nazwisko,
      'aktywny': instance.aktywny,
      'data_rozp_pracy': instance.dataRozpPracy,
      'data_zak_pracy': instance.dataZakPracy,
      'miejsce_zamieszkania': instance.miejsceZamieszkania,
      'wzrost': instance.wzrost,
      'obwod_klatki_piers': instance.obwodKlatkiPiers,
      'obwod_pasa': instance.obwodPasa,
      'obwod_glowy': instance.obwodGlowy,
      'dl_stopy': instance.dlStopy,
      'uwagi': instance.uwagi,
      'stanowisko_id': instance.stanowiskoId,
      'stanowisko_nazwa': instance.stanowiskoNazwa,
      'stanowisko_legacy_label': instance.stanowiskoLegacyLabel,
      'legacy_status': instance.legacyStatus,
      'archived_at': instance.archivedAt,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'stanowisko': instance.stanowisko,
      'standard_wyposazenia': instance.standardWyposazenia,
      'wydania_aktywne': instance.wydaniaAktywne,
      'historia_wydan': instance.historiaWydan,
      'operacje': instance.operacje,
      'liczba_pozycji_standardu': instance.liczbaPozycjiStandardu,
      'liczba_aktywnych_wydan': instance.liczbaAktywnychWydan,
      'ma_aktywne_wydania': instance.maAktywneWydania,
      'can_receive_issues': instance.canReceiveIssues,
    };

GetBhpUserPosition _$GetBhpUserPositionFromJson(Map<String, dynamic> json) =>
    GetBhpUserPosition(
      id: (json['id'] as num).toInt(),
      nazwa: json['nazwa'] as String,
      aktywny: json['aktywny'] as bool,
    );

Map<String, dynamic> _$GetBhpUserPositionToJson(GetBhpUserPosition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nazwa': instance.nazwa,
      'aktywny': instance.aktywny,
    };
