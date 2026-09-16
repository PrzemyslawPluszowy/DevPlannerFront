import 'package:json_annotation/json_annotation.dart';

part 'get_inwentaryzacje_models.g.dart';

/// Kolumny sortowania dla endpointu listy inwentaryzacji.
enum GetInwentaryzacjeSortBy {
  @JsonValue('id')
  id,
  @JsonValue('data_od')
  dataOd,
  @JsonValue('data_do')
  dataDo,
  @JsonValue('numer')
  numer,
  @JsonValue('status')
  status,
}

/// Mapper enum sortowania na wartosc query oczekiwana przez API.
extension GetInwentaryzacjeSortByApiX on GetInwentaryzacjeSortBy {
  /// Zwraca wartosc query zgodna ze Swagger.
  String get apiValue => switch (this) {
    GetInwentaryzacjeSortBy.id => 'id',
    GetInwentaryzacjeSortBy.dataOd => 'data_od',
    GetInwentaryzacjeSortBy.dataDo => 'data_do',
    GetInwentaryzacjeSortBy.numer => 'numer',
    GetInwentaryzacjeSortBy.status => 'status',
  };
}

/// Kierunek sortowania dla endpointu listy inwentaryzacji.
enum GetInwentaryzacjeSortDirection {
  @JsonValue('ASC')
  asc,
  @JsonValue('DESC')
  desc,
}

/// Mapper kierunku sortowania na wartosc query oczekiwana przez API.
extension GetInwentaryzacjeSortDirectionApiX on GetInwentaryzacjeSortDirection {
  /// Zwraca wartosc query zgodna ze Swagger.
  String get apiValue => switch (this) {
    GetInwentaryzacjeSortDirection.asc => 'ASC',
    GetInwentaryzacjeSortDirection.desc => 'DESC',
  };
}

/// Status inwentaryzacji zgodny z kontraktem backendu.
enum InwentaryzacjaStatus {
  @JsonValue(0)
  nowa,
  @JsonValue(1)
  wToku,
  @JsonValue(2)
  zakonczona,
  @JsonValue(-1)
  nieznany;

  /// Mapuje status na wartość całkowitą dla API.
  int get apiValue => switch (this) {
    nowa => 0,
    wToku => 1,
    zakonczona => 2,
    nieznany => -1,
  };

  /// Tworzy status na podstawie wartości całkowitej z API.
  static InwentaryzacjaStatus? fromApi(int? value) => switch (value) {
    0 => nowa,
    1 => wToku,
    2 => zakonczona,
    -1 => nieznany,
    _ => null,
  };
}

/// Helpery prezentacyjne dla statusu inwentaryzacji.
extension InwentaryzacjaStatusX on InwentaryzacjaStatus {
  /// Czytelna etykieta statusu do UI.
  String get label => switch (this) {
    InwentaryzacjaStatus.nowa => 'Nowa',
    InwentaryzacjaStatus.wToku => 'W toku',
    InwentaryzacjaStatus.zakonczona => 'Zakończona',
    InwentaryzacjaStatus.nieznany => 'Nieznany',
  };
}

/// Query dla `GET /api/v1/inwentaryzacja`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjeQuery {
  const GetInwentaryzacjeQuery({
    this.firma,
    this.status,
    this.numer,
    this.dataOdFrom,
    this.dataOdTo,
    this.sortBy,
    this.sortDir,
  });

  factory GetInwentaryzacjeQuery.fromJson(Map<String, dynamic> json) =>
      _$GetInwentaryzacjeQueryFromJson(json);

  final int? firma;
  final int? status;
  final String? numer;
  final String? dataOdFrom;
  final String? dataOdTo;
  final GetInwentaryzacjeSortBy? sortBy;
  final GetInwentaryzacjeSortDirection? sortDir;
  Map<String, dynamic> toJson() => _$GetInwentaryzacjeQueryToJson(this);
}

/// Data dla `GET /api/v1/inwentaryzacja`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjeResponseData {
  const GetInwentaryzacjeResponseData({
    required this.items,
    required this.meta,
  });

  factory GetInwentaryzacjeResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetInwentaryzacjeResponseDataFromJson(json);

  final List<GetInwentaryzacjeItem> items;
  final GetInwentaryzacjeMeta meta;
  Map<String, dynamic> toJson() => _$GetInwentaryzacjeResponseDataToJson(this);
}

/// Rekord listy inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjeItem {
  const GetInwentaryzacjeItem({
    required this.id,
    required this.firma,
    required this.numer,
    required this.status,
    this.dataOd,
    this.dataDo,
    this.firmy = const [],
    this.uwagi,
    this.komisjaCount = 0,
    this.arkuszeCount = 0,
  });

  factory GetInwentaryzacjeItem.fromJson(Map<String, dynamic> json) =>
      _$GetInwentaryzacjeItemFromJson(json);

  final int id;
  final String? dataOd;
  final String? dataDo;
  final int firma;
  final List<GetInwentaryzacjeFirmaItem> firmy;
  final String numer;
  final String? uwagi;
  @JsonKey(unknownEnumValue: InwentaryzacjaStatus.nieznany)
  final InwentaryzacjaStatus status;
  final int komisjaCount;
  final int arkuszeCount;
  Map<String, dynamic> toJson() => _$GetInwentaryzacjeItemToJson(this);
}

/// Firma/oddzial przypisany do inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjeFirmaItem {
  const GetInwentaryzacjeFirmaItem({
    required this.idFirmy,
    this.nazwa,
  });

  factory GetInwentaryzacjeFirmaItem.fromJson(Map<String, dynamic> json) =>
      _$GetInwentaryzacjeFirmaItemFromJson(json);

  @JsonKey(readValue: _readIdFirmyFromJson)
  final int idFirmy;
  final String? nazwa;
  Map<String, dynamic> toJson() => _$GetInwentaryzacjeFirmaItemToJson(this);
}

Object? _readIdFirmyFromJson(Map<dynamic, dynamic> json, String _) =>
    json['id_firmy'] ?? json['id'];

/// Metadane listy inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjeMeta {
  const GetInwentaryzacjeMeta({
    required this.total,
    required this.sortBy,
    required this.sortDir,
  });

  factory GetInwentaryzacjeMeta.fromJson(Map<String, dynamic> json) =>
      _$GetInwentaryzacjeMetaFromJson(json);

  final int total;
  final String sortBy;
  final String sortDir;
  Map<String, dynamic> toJson() => _$GetInwentaryzacjeMetaToJson(this);
}
