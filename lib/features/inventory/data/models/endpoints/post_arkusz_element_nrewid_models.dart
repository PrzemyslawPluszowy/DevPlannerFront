import 'package:json_annotation/json_annotation.dart';

part 'post_arkusz_element_nrewid_models.g.dart';

/// Body dla `POST /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/nrewid`.
@JsonSerializable(fieldRename: FieldRename.snake)
class CreateArkuszElementByNrewidRequest {
  const CreateArkuszElementByNrewidRequest({required this.nrewid});

  factory CreateArkuszElementByNrewidRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateArkuszElementByNrewidRequestFromJson(json);

  final String nrewid;
  Map<String, dynamic> toJson() =>
      _$CreateArkuszElementByNrewidRequestToJson(this);
}

/// Data odpowiedzi dla `POST /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/nrewid`.
@JsonSerializable(fieldRename: FieldRename.snake)
class CreateArkuszElementByNrewidResponseData {
  const CreateArkuszElementByNrewidResponseData({
    required this.id,
    this.success = true,
  });

  factory CreateArkuszElementByNrewidResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateArkuszElementByNrewidResponseDataFromJson(json);

  final int id;
  final bool success;
  Map<String, dynamic> toJson() =>
      _$CreateArkuszElementByNrewidResponseDataToJson(this);
}
