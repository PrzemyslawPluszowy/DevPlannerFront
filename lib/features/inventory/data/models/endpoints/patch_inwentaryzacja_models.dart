import 'package:json_annotation/json_annotation.dart';

part 'patch_inwentaryzacja_models.g.dart';

/// Body dla `PATCH /api/v1/inwentaryzacja/{id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchInwentaryzacjaRequest {
  const PatchInwentaryzacjaRequest({
    this.dataOd,
    this.dataDo,
    this.numer,
    this.uwagi,
  });

  factory PatchInwentaryzacjaRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchInwentaryzacjaRequestFromJson(json);

  final String? dataOd;
  final String? dataDo;
  final String? numer;
  final String? uwagi;

  Map<String, dynamic> toJson() => _$PatchInwentaryzacjaRequestToJson(this);
}

/// Data odpowiedzi dla `PATCH /api/v1/inwentaryzacja/{id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchInwentaryzacjaResponseData {
  const PatchInwentaryzacjaResponseData({
    required this.id,
    this.dataOd,
    this.dataDo,
    this.success = true,
  });

  factory PatchInwentaryzacjaResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$PatchInwentaryzacjaResponseDataFromJson(json);

  final int id;
  final String? dataOd;
  final String? dataDo;
  final bool success;

  Map<String, dynamic> toJson() =>
      _$PatchInwentaryzacjaResponseDataToJson(this);
}
