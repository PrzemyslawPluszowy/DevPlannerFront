import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';

part 'get_arkusz_details_models.g.dart';

/// Data dla `GET /api/v1/inwentaryzacja/arkusze/{arkusz_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetArkuszDetailsResponseData {
  const GetArkuszDetailsResponseData({
    required this.arkusz,
    required this.komisja,
    required this.elementy,
  });

  factory GetArkuszDetailsResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetArkuszDetailsResponseDataFromJson(json);

  final GetArkuszDetailsHeader arkusz;
  final List<GetArkuszDetailsKomisjaItem> komisja;
  final List<GetArkuszDetailsElementItem> elementy;
  Map<String, dynamic> toJson() => _$GetArkuszDetailsResponseDataToJson(this);
}

/// Naglowek arkusza.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetArkuszDetailsHeader {
  const GetArkuszDetailsHeader({
    required this.id,
    required this.idInwentaryzacja,
    this.numer,
    this.idMiejsca,
    this.nazwaMiejsca,
    this.lvlMiejsca,
    this.firma,
    this.wczytanest,
    this.rozpoczecie,
    this.zakonczenie,
  });

  factory GetArkuszDetailsHeader.fromJson(Map<String, dynamic> json) =>
      _$GetArkuszDetailsHeaderFromJson(json);

  final int id;
  final int idInwentaryzacja;
  final String? numer;
  final int? idMiejsca;
  final String? nazwaMiejsca;
  final String? lvlMiejsca;
  final int? firma;
  final int? wczytanest;
  final String? rozpoczecie;
  final String? zakonczenie;
  Map<String, dynamic> toJson() => _$GetArkuszDetailsHeaderToJson(this);
}

/// Czlonek komisji dla arkusza.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetArkuszDetailsKomisjaItem {
  const GetArkuszDetailsKomisjaItem({
    required this.userId,
    required this.displayName,
  });

  factory GetArkuszDetailsKomisjaItem.fromJson(Map<String, dynamic> json) =>
      _$GetArkuszDetailsKomisjaItemFromJson(json);

  final int userId;
  final String displayName;
  Map<String, dynamic> toJson() => _$GetArkuszDetailsKomisjaItemToJson(this);
}

/// Status inwentaryzacyjny elementu arkusza zgodny z `stan_inwent`.
enum ArkuszElementInwentStatus {
  brak,
  zgodny,
  przeniesiony,
  ;

  /// Tworzy status na podstawie wartosci `stan_inwent` z API.
  static ArkuszElementInwentStatus? fromApi(Object? value) => switch (value) {
    null || '' || 0 || '0' => brak,
    'confirmed' || 1 || '1' => zgodny,
    'discrepancy' || 2 || '2' => przeniesiony,
    _ => null,
  };

  /// Wartosc statusu zgodna z API backendowym.
  String? get apiValue => switch (this) {
    ArkuszElementInwentStatus.brak => null,
    ArkuszElementInwentStatus.zgodny => 'confirmed',
    ArkuszElementInwentStatus.przeniesiony => 'discrepancy',
  };
}

/// Status spisu elementu zgodny z `status_spisu` API.
enum ArkuszElementStatusSpisu {
  nadwyzka,
  nowy,
  znalezionyWInnejFirmie,
  niejednoznacznyKod,
  sprzedanyWTrakcie,
  zakupionyWTrakcie,
  ;

  /// Tworzy status spisu na podstawie wartosci zwroconej przez backend.
  static ArkuszElementStatusSpisu? fromApi(String? value) => switch (value) {
    'nadwyzka' => ArkuszElementStatusSpisu.nadwyzka,
    'nowy' => ArkuszElementStatusSpisu.nowy,
    'znaleziony_w_innej_firmie' =>
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie,
    'niejednoznaczny_kod' => ArkuszElementStatusSpisu.niejednoznacznyKod,
    'sprzedany_w_trakcie' => ArkuszElementStatusSpisu.sprzedanyWTrakcie,
    'zakupiony_w_trakcie' => ArkuszElementStatusSpisu.zakupionyWTrakcie,
    _ => null,
  };

  /// Wartosc statusu spisu zgodna z API backendowym.
  String get apiValue => switch (this) {
    ArkuszElementStatusSpisu.nadwyzka => 'nadwyzka',
    ArkuszElementStatusSpisu.nowy => 'nowy',
    ArkuszElementStatusSpisu.znalezionyWInnejFirmie =>
      'znaleziony_w_innej_firmie',
    ArkuszElementStatusSpisu.niejednoznacznyKod => 'niejednoznaczny_kod',
    ArkuszElementStatusSpisu.sprzedanyWTrakcie => 'sprzedany_w_trakcie',
    ArkuszElementStatusSpisu.zakupionyWTrakcie => 'zakupiony_w_trakcie',
  };
}

/// Konwerter JSON dla [ArkuszElementStatusSpisu].
class ArkuszElementStatusSpisuConverter
    implements JsonConverter<ArkuszElementStatusSpisu?, String?> {
  /// Tworzy konwerter statusu spisu.
  const ArkuszElementStatusSpisuConverter();

  @override
  ArkuszElementStatusSpisu? fromJson(String? json) =>
      ArkuszElementStatusSpisu.fromApi(json);

  @override
  String? toJson(ArkuszElementStatusSpisu? object) => object?.apiValue;
}

/// Element arkusza.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetArkuszDetailsElementItem {
  const GetArkuszDetailsElementItem({
    required this.id,
    this.idarkuszSpisu,
    this.firma,
    this.nazwa,
    this.nrewid,
    this.osoba,
    this.aktualnyStan,
    this.idmiejsce,
    this.miejsce,
    this.lvl,
    this.kodKreskowy,
    this.wartoscP,
    this.wartoscA,
    this.dataZakupu,
    this.stanInwent,
    this.statusSpisu,
    this.likwidacja,
    this.nadwyzka,
    this.nowyKodKreskowy,
    this.nowaOsoba,
    this.nowaNazwa,
    this.uwagiLoc,
    this.kkWczytany,
    this.nadwIdmiejsce,
    this.nadwMiejsce,
    this.nadwLvl,
    this.nadwIdFirmy,
    this.nadwFirma,
    this.foundInArkuszNumer,
    this.foundInMiejsce,
  });

  factory GetArkuszDetailsElementItem.fromJson(Map<String, dynamic> json) =>
      _$GetArkuszDetailsElementItemFromJson(json);

  final int id;
  final int? idarkuszSpisu;
  final int? firma;
  final String? nazwa;
  final String? nrewid;
  final String? osoba;

  /// Aktualny stan ST zwrocony przez backend dla tego elementu.
  @JsonKey(
    name: 'aktualny_stan',
    fromJson: _srodekTrwalyStatusFromJson,
    toJson: _srodekTrwalyStatusToJson,
  )
  final SrodekTrwalyStatus? aktualnyStan;
  final int? idmiejsce;
  final String? miejsce;
  final String? lvl;
  final int? kodKreskowy;
  @JsonKey(fromJson: _decimalStringFromJson, toJson: _decimalStringToJson)
  final String? wartoscP;
  @JsonKey(fromJson: _decimalStringFromJson, toJson: _decimalStringToJson)
  final String? wartoscA;
  final String? dataZakupu;

  /// Kod stanu inwentaryzacyjnego dla tego elementu.
  @JsonKey(
    name: 'stan_inwent',
    fromJson: _arkuszElementInwentStatusFromJson,
    toJson: _arkuszElementInwentStatusToJson,
  )
  final ArkuszElementInwentStatus? stanInwent;

  /// Status spisu elementu.
  @JsonKey(name: 'status_spisu')
  @ArkuszElementStatusSpisuConverter()
  final ArkuszElementStatusSpisu? statusSpisu;

  /// Flaga usuniecia/likwidacji w backendzie.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? likwidacja;

  /// Flaga oznaczajaca element jako nadwyzke.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? nadwyzka;
  final String? nowyKodKreskowy;
  final String? nowaOsoba;
  final String? nowaNazwa;
  final String? uwagiLoc;

  /// Flaga informujaca, czy element zostal wczytany skanerem.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? kkWczytany;
  final int? nadwIdmiejsce;
  final String? nadwMiejsce;
  final String? nadwLvl;
  final int? nadwIdFirmy;
  final String? nadwFirma;
  final String? foundInArkuszNumer;
  final String? foundInMiejsce;

  /// Zmapowany status inwentaryzacyjny na potrzeby UI.
  ArkuszElementInwentStatus? get inventoryStatus => stanInwent;

  /// Zmapowany aktualny stan ST na potrzeby UI.
  SrodekTrwalyStatus? get assetStatus => aktualnyStan;

  /// Czy element jest oznaczony jako zlikwidowany.
  bool get isLiquidated => likwidacja ?? false;

  /// Czy element jest oznaczony jako nadwyzka.
  bool get hasSurplus => nadwyzka ?? false;

  /// Czy element zostal wczytany przez skaner.
  bool get isScanned => kkWczytany ?? false;

  Map<String, dynamic> toJson() => _$GetArkuszDetailsElementItemToJson(this);
}

/// Mapuje wartosc backendowa statusu ST na enum UI.
SrodekTrwalyStatus? _srodekTrwalyStatusFromJson(Object? value) =>
    SrodekTrwalyStatus.fromApi(value);

/// Mapuje enum statusu ST na kod backendowy.
int? _srodekTrwalyStatusToJson(SrodekTrwalyStatus? status) => status?.apiValue;

ArkuszElementInwentStatus? _arkuszElementInwentStatusFromJson(Object? value) =>
    ArkuszElementInwentStatus.fromApi(value);

String? _arkuszElementInwentStatusToJson(ArkuszElementInwentStatus? status) =>
    status?.apiValue;

bool? _boolFromJson(Object? value) => switch (value) {
  final bool boolValue => boolValue,
  final int intValue => intValue == 1,
  final String stringValue =>
    stringValue == '1' || stringValue.toLowerCase() == 'true',
  _ => null,
};

bool? _boolToJson(bool? value) => value;

String? _decimalStringFromJson(Object? value) => switch (value) {
  null => null,
  final String stringValue => stringValue,
  final num numValue => numValue.toString(),
  _ => value.toString(),
};

String? _decimalStringToJson(String? value) => value;
