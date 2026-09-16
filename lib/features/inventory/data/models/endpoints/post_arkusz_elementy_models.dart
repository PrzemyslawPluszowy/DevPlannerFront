import 'package:json_annotation/json_annotation.dart';

part 'post_arkusz_elementy_models.g.dart';

/// Body dla `POST /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostArkuszElementyQuery {
  const PostArkuszElementyQuery({
    required this.kodKreskowy,
    this.dataZakupu,
    this.nazwa,
    this.nrewid,
    this.osoba,
  });

  factory PostArkuszElementyQuery.fromJson(Map<String, dynamic> json) =>
      _$PostArkuszElementyQueryFromJson(json);

  final int kodKreskowy;
  final String? dataZakupu;
  final String? nazwa;
  final String? nrewid;
  final String? osoba;
  Map<String, dynamic> toJson() => _$PostArkuszElementyQueryToJson(this);
}

/// Data odpowiedzi dla `POST /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostArkuszElementyResponseData {
  const PostArkuszElementyResponseData({
    required this.id,
    this.success,
    this.nadwyzka,
  });

  factory PostArkuszElementyResponseData.fromJson(Map<String, dynamic> json) =>
      _$PostArkuszElementyResponseDataFromJson(json);

  final int id;
  final bool? success;
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? nadwyzka;
  Map<String, dynamic> toJson() => _$PostArkuszElementyResponseDataToJson(this);
}

bool? _boolFromJson(Object? value) => switch (value) {
  final bool boolValue => boolValue,
  final int intValue => intValue == 1,
  final String stringValue =>
    stringValue == '1' || stringValue.toLowerCase() == 'true',
  _ => null,
};

bool? _boolToJson(bool? value) => value;
