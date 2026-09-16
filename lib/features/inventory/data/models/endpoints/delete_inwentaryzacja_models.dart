import 'package:json_annotation/json_annotation.dart';

part 'delete_inwentaryzacja_models.g.dart';

/// Data odpowiedzi dla `DELETE /api/v1/inwentaryzacja/{inwentaryzacja_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteInwentaryzacjaResponseData {
  const DeleteInwentaryzacjaResponseData({
    required this.id,
    this.success = true,
  });

  factory DeleteInwentaryzacjaResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteInwentaryzacjaResponseDataFromJson(json);

  final bool success;
  final int id;
  Map<String, dynamic> toJson() =>
      _$DeleteInwentaryzacjaResponseDataToJson(this);
}
