import 'package:json_annotation/json_annotation.dart';

part 'post_arkusz_models.g.dart';

/// Query dla `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostArkuszQuery {
  const PostArkuszQuery({
    required this.idMiejsca,
    required this.idFirmy,
    required this.baza,
    this.scope,
    this.numer,
    this.komisja,
  });

  factory PostArkuszQuery.fromJson(Map<String, dynamic> json) =>
      _$PostArkuszQueryFromJson(json);

  final int idMiejsca;
  final int idFirmy;
  final String baza;
  final String? scope;
  final String? numer;
  final List<int>? komisja;
  Map<String, dynamic> toJson() => _$PostArkuszQueryToJson(this);
}

/// Data odpowiedzi dla `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostArkuszResponseData {
  const PostArkuszResponseData({
    required this.id,
    required this.scope,
    required this.elementyCount,
    required this.komisjaCount,
    this.success = true,
  });

  factory PostArkuszResponseData.fromJson(Map<String, dynamic> json) =>
      _$PostArkuszResponseDataFromJson(json);

  final int id;
  final bool success;
  final String scope;
  final int elementyCount;
  final int komisjaCount;
  Map<String, dynamic> toJson() => _$PostArkuszResponseDataToJson(this);
}
