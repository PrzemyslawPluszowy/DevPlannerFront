import 'package:json_annotation/json_annotation.dart';

part 'delete_stan_st_models.g.dart';

/// Data odpowiedzi dla `DELETE /api/v1/inwentaryzacja/stan_st/{id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteStanStResponseData {
  /// Tworzy payload odpowiedzi po usunieciu rekordu `stan_st`.
  const DeleteStanStResponseData({required this.id, this.success = true});

  /// Deserializuje odpowiedz backendu do modelu transportowego.
  factory DeleteStanStResponseData.fromJson(Map<String, dynamic> json) =>
      _$DeleteStanStResponseDataFromJson(json);

  /// Flaga sukcesu zwracana przez backend.
  final bool success;

  /// Identyfikator usunietego rekordu.
  final int id;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() => _$DeleteStanStResponseDataToJson(this);
}
