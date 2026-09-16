import 'package:json_annotation/json_annotation.dart';

part 'post_zamknij_inwentaryzacje_models.g.dart';

/// Body dla `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/zamknij`.
@JsonSerializable(fieldRename: FieldRename.snake)
class ZamknijInwentaryzacjeRequest {
  const ZamknijInwentaryzacjeRequest({required this.dataDo});

  factory ZamknijInwentaryzacjeRequest.fromJson(Map<String, dynamic> json) =>
      _$ZamknijInwentaryzacjeRequestFromJson(json);

  final String dataDo;
  Map<String, dynamic> toJson() => _$ZamknijInwentaryzacjeRequestToJson(this);
}

/// Data odpowiedzi dla `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/zamknij`.
@JsonSerializable(fieldRename: FieldRename.snake)
class ZamknijInwentaryzacjeResponseData {
  const ZamknijInwentaryzacjeResponseData({
    required this.id,
    this.success = true,
  });

  factory ZamknijInwentaryzacjeResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$ZamknijInwentaryzacjeResponseDataFromJson(json);

  final int id;
  final bool success;
  Map<String, dynamic> toJson() =>
      _$ZamknijInwentaryzacjeResponseDataToJson(this);
}
