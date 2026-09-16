import 'package:json_annotation/json_annotation.dart';

part 'post_bhp_equipment_activation_request.g.dart';

/// Żądanie aktywacji karty wyposażenia z opcjonalnym przywróceniem przypisań.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PostBhpEquipmentActivationRequest {
  /// Tworzy żądanie aktywacji karty wyposażenia.
  const PostBhpEquipmentActivationRequest({
    this.selectedStandardIds,
  });

  /// Tworzy żądanie z JSON.
  factory PostBhpEquipmentActivationRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$PostBhpEquipmentActivationRequestFromJson(json);

  /// Identyfikatory przypisań standardów do przywrócenia.
  final List<int>? selectedStandardIds;

  /// Serializuje żądanie do JSON.
  Map<String, dynamic> toJson() =>
      _$PostBhpEquipmentActivationRequestToJson(this);
}
