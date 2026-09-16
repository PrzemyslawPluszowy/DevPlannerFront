import 'package:json_annotation/json_annotation.dart';

part 'patch_arkusz_models.g.dart';

/// Body dla `PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateArkuszRequest {
  const UpdateArkuszRequest({
    this.dataRozpoczecia,
    this.dataZakonczenia,
  });

  factory UpdateArkuszRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateArkuszRequestFromJson(json);

  final String? dataRozpoczecia;
  final String? dataZakonczenia;
  Map<String, dynamic> toJson() => _$UpdateArkuszRequestToJson(this);
}

/// Data odpowiedzi dla `PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateArkuszResponseData {
  const UpdateArkuszResponseData({required this.id, this.success = true});

  factory UpdateArkuszResponseData.fromJson(Map<String, dynamic> json) =>
      _$UpdateArkuszResponseDataFromJson(json);

  final int id;
  final bool success;
  Map<String, dynamic> toJson() => _$UpdateArkuszResponseDataToJson(this);
}
