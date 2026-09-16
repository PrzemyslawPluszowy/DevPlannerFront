import 'package:json_annotation/json_annotation.dart';

part 'patch_inwentaryzacja_status_models.g.dart';

/// Dane odpowiedzi dla `POST /api/v1/inwentaryzacja/{id}/close`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchInwentaryzacjaStatusResponseData {
  const PatchInwentaryzacjaStatusResponseData({
    required this.id,
    required this.status,
    this.success = true,
  });

  factory PatchInwentaryzacjaStatusResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$PatchInwentaryzacjaStatusResponseDataFromJson(json);

  /// Identyfikator inwentaryzacji.
  final int id;

  /// Aktualny status po zmianie.
  final int status;

  /// Flaga powodzenia operacji.
  final bool success;

  Map<String, dynamic> toJson() =>
      _$PatchInwentaryzacjaStatusResponseDataToJson(this);
}
