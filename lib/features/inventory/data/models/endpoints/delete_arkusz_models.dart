import 'package:json_annotation/json_annotation.dart';

part 'delete_arkusz_models.g.dart';

/// Data odpowiedzi dla `DELETE /api/v1/inwentaryzacja/arkusze/{arkusz_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteArkuszResponseData {
  const DeleteArkuszResponseData({required this.id, this.success = true});

  factory DeleteArkuszResponseData.fromJson(Map<String, dynamic> json) =>
      _$DeleteArkuszResponseDataFromJson(json);

  final bool success;
  final int id;
  Map<String, dynamic> toJson() => _$DeleteArkuszResponseDataToJson(this);
}
