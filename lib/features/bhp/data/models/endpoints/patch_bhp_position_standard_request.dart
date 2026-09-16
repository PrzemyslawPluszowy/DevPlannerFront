import 'package:json_annotation/json_annotation.dart';

part 'patch_bhp_position_standard_request.g.dart';

/// Request edycji pozycji standardu stanowiska BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchBhpPositionStandardRequest {
  /// Tworzy request edycji pozycji standardu stanowiska BHP.
  const PatchBhpPositionStandardRequest({
    this.okres,
    this.ilosc,
    this.uwagi,
  });

  /// Tworzy request z JSON.
  factory PatchBhpPositionStandardRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchBhpPositionStandardRequestFromJson(json);

  /// Okres użytkowania nadpisany dla standardu stanowiska.
  final int? okres;

  /// Ilość przypisana w standardzie stanowiska.
  final String? ilosc;

  /// Uwagi pozycji standardu stanowiska.
  final String? uwagi;

  /// Serializuje request do JSON.
  Map<String, dynamic> toJson() =>
      _$PatchBhpPositionStandardRequestToJson(this);
}
