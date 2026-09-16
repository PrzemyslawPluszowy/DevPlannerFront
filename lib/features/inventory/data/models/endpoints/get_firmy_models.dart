import 'package:json_annotation/json_annotation.dart';

part 'get_firmy_models.g.dart';

/// Data dla `GET /api/v1/inwentaryzacja/firmy`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetFirmyResponseData {
  const GetFirmyResponseData({required this.items, required this.meta});

  factory GetFirmyResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetFirmyResponseDataFromJson(json);

  final List<GetFirmyItem> items;
  final GetFirmyMeta meta;
  Map<String, dynamic> toJson() => _$GetFirmyResponseDataToJson(this);
}

/// Rekord firmy.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetFirmyItem {
  const GetFirmyItem({
    required this.id,
    required this.idFirmy,
    required this.nazwa,
    this.aktywna,
  });

  factory GetFirmyItem.fromJson(Map<String, dynamic> json) =>
      _$GetFirmyItemFromJson(json);

  @JsonKey(readValue: _readIdFromJson)
  final int id;
  @JsonKey(readValue: _readIdFirmyFromJson)
  final int idFirmy;
  @JsonKey(readValue: _readNazwaFromJson)
  final String nazwa;
  final int? aktywna;
  Map<String, dynamic> toJson() => _$GetFirmyItemToJson(this);
}

Object? _readIdFromJson(Map<dynamic, dynamic> json, String _) =>
    json['id'] ?? json['id_firmy'] ?? json['orunid'];

Object? _readIdFirmyFromJson(Map<dynamic, dynamic> json, String _) =>
    json['id_firmy'] ?? json['id'] ?? json['orunid'];

Object? _readNazwaFromJson(Map<dynamic, dynamic> json, String _) =>
    json['nazwa'] ?? json['ndenam'];

/// Metadane listy firm.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetFirmyMeta {
  const GetFirmyMeta({required this.total});

  factory GetFirmyMeta.fromJson(Map<String, dynamic> json) =>
      _$GetFirmyMetaFromJson(json);

  final int total;
  Map<String, dynamic> toJson() => _$GetFirmyMetaToJson(this);
}
