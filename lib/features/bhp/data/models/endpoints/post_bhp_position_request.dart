import 'package:json_annotation/json_annotation.dart';

part 'post_bhp_position_request.g.dart';

/// Request zapisu stanowiska BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostBhpPositionRequest {
  /// Tworzy request zapisu stanowiska BHP.
  const PostBhpPositionRequest({
    required this.nazwa,
    this.uwagi,
  });

  /// Tworzy request z JSON.
  factory PostBhpPositionRequest.fromJson(Map<String, dynamic> json) =>
      _$PostBhpPositionRequestFromJson(json);

  /// Nazwa stanowiska.
  final String nazwa;

  /// Uwagi do stanowiska.
  final String? uwagi;

  /// Serializuje request do JSON.
  Map<String, dynamic> toJson() => _$PostBhpPositionRequestToJson(this);
}
