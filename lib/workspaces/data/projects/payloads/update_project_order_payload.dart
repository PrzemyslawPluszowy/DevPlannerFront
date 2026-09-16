import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_project_order_payload.freezed.dart';
part 'update_project_order_payload.g.dart';

/// Payload pełnej ręcznej kolejności widocznych projektów.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateProjectOrderPayload with _$UpdateProjectOrderPayload {
  /// Tworzy kolejność projektów zgodną z `UpdateProjectOrderRequest`.
  const factory UpdateProjectOrderPayload({
    /// UUID-y wszystkich widocznych projektów w docelowej kolejności.
    required List<String> projectIds,
  }) = _UpdateProjectOrderPayload;

  /// Odtwarza kolejność projektów z JSON.
  factory UpdateProjectOrderPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectOrderPayloadFromJson(json);
}
