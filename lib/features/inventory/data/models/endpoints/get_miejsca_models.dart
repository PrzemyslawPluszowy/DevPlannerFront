import 'package:json_annotation/json_annotation.dart';

part 'get_miejsca_models.g.dart';

/// Query dla `GET /api/v1/inwentaryzacja/miejsca`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetMiejscaQuery {
  const GetMiejscaQuery({this.firma});

  factory GetMiejscaQuery.fromJson(Map<String, dynamic> json) =>
      _$GetMiejscaQueryFromJson(json);

  final int? firma;
  Map<String, dynamic> toJson() => _$GetMiejscaQueryToJson(this);
}

/// Data dla `GET /api/v1/inwentaryzacja/miejsca`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetMiejscaResponseData {
  const GetMiejscaResponseData({required this.items, required this.meta});

  factory GetMiejscaResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetMiejscaResponseDataFromJson(json);

  final List<GetMiejscaItem> items;
  final GetMiejscaMeta meta;
  Map<String, dynamic> toJson() => _$GetMiejscaResponseDataToJson(this);
}

/// Rekord miejsca.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetMiejscaItem {
  const GetMiejscaItem({
    required this.id,
    required this.idMiejsca,
    required this.idFirmy,
    this.idparent,
    this.baza,
    this.nazwa,
    this.lvl,
  });

  factory GetMiejscaItem.fromJson(Map<String, dynamic> json) =>
      _$GetMiejscaItemFromJson(json);

  final int id;
  final int idMiejsca;
  final int? idparent;
  final int idFirmy;
  final String? baza;
  final String? nazwa;
  final String? lvl;
  Map<String, dynamic> toJson() => _$GetMiejscaItemToJson(this);
}

/// Metadane listy miejsc.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetMiejscaMeta {
  const GetMiejscaMeta({required this.total});

  factory GetMiejscaMeta.fromJson(Map<String, dynamic> json) =>
      _$GetMiejscaMetaFromJson(json);

  final int total;
  Map<String, dynamic> toJson() => _$GetMiejscaMetaToJson(this);
}
