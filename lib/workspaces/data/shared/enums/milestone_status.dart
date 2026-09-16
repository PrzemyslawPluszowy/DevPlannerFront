import 'package:freezed_annotation/freezed_annotation.dart';

/// Status kamienia milowego w projekcie.
@JsonEnum()
enum MilestoneStatus {
  /// Kamień milowy jest aktywny.
  @JsonValue('Active')
  active,

  /// Kamień milowy został ukończony.
  @JsonValue('Completed')
  completed,

  /// Kamień milowy został anulowany.
  @JsonValue('Cancelled')
  cancelled,
}
