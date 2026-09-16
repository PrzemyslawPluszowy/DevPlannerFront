import 'package:json_annotation/json_annotation.dart';

part 'patch_arkusz_numer_models.g.dart';

/// Body dla `PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/numer`.
@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateArkuszNumerRequest {
  const UpdateArkuszNumerRequest({required this.numer});

  factory UpdateArkuszNumerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateArkuszNumerRequestFromJson(json);

  final String numer;
  Map<String, dynamic> toJson() => _$UpdateArkuszNumerRequestToJson(this);
}

/// Data odpowiedzi dla `PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/numer`.
@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateArkuszNumerResponseData {
  const UpdateArkuszNumerResponseData({required this.id, this.success = true});

  factory UpdateArkuszNumerResponseData.fromJson(Map<String, dynamic> json) =>
      _$UpdateArkuszNumerResponseDataFromJson(json);

  final int id;
  final bool success;
  Map<String, dynamic> toJson() => _$UpdateArkuszNumerResponseDataToJson(this);
}
