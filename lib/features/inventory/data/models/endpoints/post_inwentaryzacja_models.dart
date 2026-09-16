import 'package:json_annotation/json_annotation.dart';

part 'post_inwentaryzacja_models.g.dart';

/// Body dla `POST /api/v1/inwentaryzacja`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostInwentaryzacjaQuery {
  const PostInwentaryzacjaQuery({
    required this.firmy,
    required this.numer,
    required this.komisja,
    required this.dataOd,
    this.dataDo,
    this.uwagi,
  });

  factory PostInwentaryzacjaQuery.fromJson(Map<String, dynamic> json) =>
      _$PostInwentaryzacjaQueryFromJson(json);

  final List<int> firmy;
  final String numer;
  final List<int> komisja;
  final String dataOd;
  final String? dataDo;
  final String? uwagi;
  Map<String, dynamic> toJson() => _$PostInwentaryzacjaQueryToJson(this);
}

/// Data odpowiedzi dla `POST /api/v1/inwentaryzacja`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostInwentaryzacjaResponseData {
  const PostInwentaryzacjaResponseData({required this.id, this.success = true});

  factory PostInwentaryzacjaResponseData.fromJson(Map<String, dynamic> json) =>
      _$PostInwentaryzacjaResponseDataFromJson(json);

  final int id;
  final bool success;
  Map<String, dynamic> toJson() => _$PostInwentaryzacjaResponseDataToJson(this);
}
