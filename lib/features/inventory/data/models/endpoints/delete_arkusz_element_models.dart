import 'package:json_annotation/json_annotation.dart';

part 'delete_arkusz_element_models.g.dart';

/// Data odpowiedzi dla `DELETE /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteArkuszElementResponseData {
  const DeleteArkuszElementResponseData({
    required this.elementId,
    this.success = true,
  });

  factory DeleteArkuszElementResponseData.fromJson(Map<String, dynamic> json) =>
      _$DeleteArkuszElementResponseDataFromJson(json);

  final bool success;
  final int elementId;
  Map<String, dynamic> toJson() =>
      _$DeleteArkuszElementResponseDataToJson(this);
}
