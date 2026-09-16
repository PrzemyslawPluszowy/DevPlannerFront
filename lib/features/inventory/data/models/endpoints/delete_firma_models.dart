import 'package:json_annotation/json_annotation.dart';

part 'delete_firma_models.g.dart';

/// Data odpowiedzi dla `DELETE /api/v1/inwentaryzacja/firmy/{firma_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteFirmaResponseData {
  const DeleteFirmaResponseData({required this.id, this.success = true});

  factory DeleteFirmaResponseData.fromJson(Map<String, dynamic> json) =>
      _$DeleteFirmaResponseDataFromJson(json);

  final bool success;
  final int id;
  Map<String, dynamic> toJson() => _$DeleteFirmaResponseDataToJson(this);
}
