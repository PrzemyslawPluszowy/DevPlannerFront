import 'package:json_annotation/json_annotation.dart';

import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';

part 'get_inwentaryzacja_details_models.g.dart';

/// Data dla `GET /api/v1/inwentaryzacja/{inwentaryzacja_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaDetailsResponseData {
  const GetInwentaryzacjaDetailsResponseData({
    required this.inwentaryzacja,
    required this.komisja,
    required this.arkusze,
  });

  factory GetInwentaryzacjaDetailsResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaDetailsResponseDataFromJson(json);

  final GetInwentaryzacjaDetailsHeader inwentaryzacja;
  final List<GetInwentaryzacjaDetailsKomisjaItem> komisja;
  final List<GetInwentaryzacjaDetailsArkuszItem> arkusze;
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaDetailsResponseDataToJson(this);
}

/// Naglowek inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaDetailsHeader {
  const GetInwentaryzacjaDetailsHeader({
    required this.id,
    required this.numer,
    required this.status,
    this.dataOd,
    this.dataDo,
    this.firma,
    this.firmaNazwa,
    this.firmy = const [],
    this.uwagi,
  });

  factory GetInwentaryzacjaDetailsHeader.fromJson(Map<String, dynamic> json) =>
      _$GetInwentaryzacjaDetailsHeaderFromJson(json);

  final int id;
  final String? dataOd;
  final String? dataDo;
  final int? firma;
  final String? firmaNazwa;
  final List<GetInwentaryzacjaDetailsFirmaItem> firmy;
  final String numer;
  final String? uwagi;

  /// Kod statusu inwentaryzacji zwrocony przez API.
  final int status;

  /// Czytelny status do UI i logiki aplikacji.
  InwentaryzacjaStatus? get inventoryStatus =>
      InwentaryzacjaStatus.fromApi(status);
  Map<String, dynamic> toJson() => _$GetInwentaryzacjaDetailsHeaderToJson(this);
}

/// Firma przypisana do inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaDetailsFirmaItem {
  const GetInwentaryzacjaDetailsFirmaItem({
    required this.id,
    this.nazwaFirmy,
  });

  factory GetInwentaryzacjaDetailsFirmaItem.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaDetailsFirmaItemFromJson(json);

  final int id;
  final String? nazwaFirmy;
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaDetailsFirmaItemToJson(this);
}

/// Czlonek komisji dla szczegolow inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaDetailsKomisjaItem {
  const GetInwentaryzacjaDetailsKomisjaItem({
    required this.id,
    required this.userId,
    required this.displayName,
  });

  factory GetInwentaryzacjaDetailsKomisjaItem.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaDetailsKomisjaItemFromJson(json);

  final int id;
  final int userId;
  final String displayName;
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaDetailsKomisjaItemToJson(this);
}

/// Czlonek komisji przypisanej do arkusza.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaDetailsArkuszKomisjaItem {
  const GetInwentaryzacjaDetailsArkuszKomisjaItem({
    required this.userId,
    required this.displayName,
  });

  factory GetInwentaryzacjaDetailsArkuszKomisjaItem.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaDetailsArkuszKomisjaItemFromJson(json);

  final int userId;
  final String displayName;
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaDetailsArkuszKomisjaItemToJson(this);
}

/// Arkusz na liscie szczegolow inwentaryzacji.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetInwentaryzacjaDetailsArkuszItem {
  const GetInwentaryzacjaDetailsArkuszItem({
    required this.id,
    this.numer,
    this.idMiejsca,
    this.nazwaMiejsca,
    this.lvlMiejsca,
    this.firma,
    this.wczytanest,
    this.rozpoczecie,
    this.zakonczenie,
    this.elementyCount = 0,
    this.komisja = const [],
  });

  factory GetInwentaryzacjaDetailsArkuszItem.fromJson(
    Map<String, dynamic> json,
  ) => _$GetInwentaryzacjaDetailsArkuszItemFromJson(json);

  final int id;
  final String? numer;
  final int? idMiejsca;
  final String? nazwaMiejsca;
  final String? lvlMiejsca;
  final int? firma;
  final int? wczytanest;
  final String? rozpoczecie;
  final String? zakonczenie;
  final int elementyCount;
  final List<GetInwentaryzacjaDetailsArkuszKomisjaItem> komisja;
  Map<String, dynamic> toJson() =>
      _$GetInwentaryzacjaDetailsArkuszItemToJson(this);
}
