import 'package:json_annotation/json_annotation.dart';

part 'post_bhp_position_standard_request.g.dart';

/// Request dodania pozycji do standardu stanowiska BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class PostBhpPositionStandardRequest {
  /// Tworzy request dodania pozycji standardu stanowiska BHP.
  const PostBhpPositionStandardRequest({
    required this.kartaWyposazeniaId,
    this.okres,
    this.ilosc,
    this.uwagi,
  });

  /// Tworzy request z JSON.
  factory PostBhpPositionStandardRequest.fromJson(Map<String, dynamic> json) =>
      _$PostBhpPositionStandardRequestFromJson(json);

  /// Id karty wyposażenia.
  final int kartaWyposazeniaId;

  /// Okres użytkowania nadpisany dla standardu stanowiska.
  final int? okres;

  /// Ilość przypisana w standardzie stanowiska.
  final String? ilosc;

  /// Uwagi pozycji standardu stanowiska.
  final String? uwagi;

  /// Serializuje request do JSON.
  Map<String, dynamic> toJson() => _$PostBhpPositionStandardRequestToJson(this);
}
