import 'package:json_annotation/json_annotation.dart';

part 'get_stan_st_models.g.dart';

/// Status srodka trwalego zgodny z wartosciami backendu.
enum SrodekTrwalyStatus {
  brak,
  niezatwierdzone,
  wUzytkowaniu,
  zlikwidowany,
  sprzedane,
  przeniesiony,
  nieWystepujeWSt;

  /// Tworzy status na podstawie wartosci `stan` lub `aktualny_stan` z API.
  static SrodekTrwalyStatus? fromApi(Object? value) => switch (value) {
    null => brak,
    0 || '0' || 'niezatwierdzone' || 'niezatwierdzony' => niezatwierdzone,
    1 || '1' || 'w_uzytkowaniu' => wUzytkowaniu,
    2 || '2' || 'zlikwidowany' => zlikwidowany,
    4 || '4' || 'sprzedane' || 'sprzedany' => sprzedane,
    5 || '5' || 'przeniesiony' => przeniesiony,
    99 || '99' || 'nie_wystepuje_w_st' || 'poza_ewidencja' => nieWystepujeWSt,
    _ => null,
  };

  /// Wartosc statusu zgodna z API backendowym.
  int? get apiValue => switch (this) {
    SrodekTrwalyStatus.brak => null,
    SrodekTrwalyStatus.niezatwierdzone => 0,
    SrodekTrwalyStatus.wUzytkowaniu => 1,
    SrodekTrwalyStatus.zlikwidowany => 2,
    SrodekTrwalyStatus.sprzedane => 4,
    SrodekTrwalyStatus.przeniesiony => 5,
    SrodekTrwalyStatus.nieWystepujeWSt => 99,
  };
}

/// Helpery prezentacyjne dla statusu srodka trwalego.
extension SrodekTrwalyStatusX on SrodekTrwalyStatus {
  /// Czytelna etykieta statusu do UI.
  String get label => switch (this) {
    SrodekTrwalyStatus.brak => 'Brak',
    SrodekTrwalyStatus.niezatwierdzone => 'Niezatwierdzone',
    SrodekTrwalyStatus.wUzytkowaniu => 'W uzytkowaniu',
    SrodekTrwalyStatus.zlikwidowany => 'Zlikwidowany',
    SrodekTrwalyStatus.sprzedane => 'Sprzedane',
    SrodekTrwalyStatus.przeniesiony => 'Przeniesiony',
    SrodekTrwalyStatus.nieWystepujeWSt => 'Nie wystepuje w srodkach trwalych',
  };
}

/// Query dla `GET /api/v1/inwentaryzacja/stan_st`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetStanStQuery {
  const GetStanStQuery({
    this.firma,
    this.baza,
    this.idmiejsce,
    this.stan,
    this.q,
    this.limit,
    this.offset,
    this.nazwa,
    this.nrewid,
    this.kodKreskowy,
  });

  factory GetStanStQuery.fromJson(Map<String, dynamic> json) =>
      _$GetStanStQueryFromJson(json);

  final int? firma;
  final String? baza;
  final int? idmiejsce;
  final String? stan;
  final String? q;
  final int? limit;
  final int? offset;
  final String? nazwa;
  final String? nrewid;
  final String? kodKreskowy;
  Map<String, dynamic> toJson() => _$GetStanStQueryToJson(this);
}

/// Data dla `GET /api/v1/inwentaryzacja/stan_st`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetStanStResponseData {
  const GetStanStResponseData({required this.items, required this.meta});

  factory GetStanStResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetStanStResponseDataFromJson(json);

  final List<GetStanStItem> items;
  final GetStanStMeta meta;
  Map<String, dynamic> toJson() => _$GetStanStResponseDataToJson(this);
}

/// Rekord srodka trwalego.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetStanStItem {
  const GetStanStItem({
    required this.id,
    this.firma,
    this.nazwa,
    this.nrewid,
    this.osoba,
    this.dataZakupu,
    this.stan,
    this.idmiejsce,
    this.miejsce,
    this.kodKreskowy,
    this.wartoscP,
    this.wartoscA,
    this.lvl,
    this.dataImportu,
  });

  factory GetStanStItem.fromJson(Map<String, dynamic> json) =>
      _$GetStanStItemFromJson(json);

  final int id;
  final int? firma;
  final String? nazwa;
  final String? nrewid;
  final String? osoba;
  final String? dataZakupu;
  final int? stan;
  final int? idmiejsce;
  final String? miejsce;
  final int? kodKreskowy;
  @JsonKey(fromJson: _decimalStringFromJson, toJson: _decimalStringToJson)
  final String? wartoscP;
  @JsonKey(fromJson: _decimalStringFromJson, toJson: _decimalStringToJson)
  final String? wartoscA;
  final String? lvl;
  final String? dataImportu;

  /// Zmapowany status srodka trwalego na potrzeby UI.
  SrodekTrwalyStatus? get status => SrodekTrwalyStatus.fromApi(stan);

  Map<String, dynamic> toJson() => _$GetStanStItemToJson(this);
}

String? _decimalStringFromJson(Object? value) => switch (value) {
  null => null,
  final String stringValue => stringValue,
  final num numValue => numValue.toString(),
  _ => value.toString(),
};

String? _decimalStringToJson(String? value) => value;

/// Metadane paginacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetStanStMeta {
  const GetStanStMeta({
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory GetStanStMeta.fromJson(Map<String, dynamic> json) =>
      _$GetStanStMetaFromJson(json);

  final int total;
  final int limit;
  final int offset;
  Map<String, dynamic> toJson() => _$GetStanStMetaToJson(this);
}
