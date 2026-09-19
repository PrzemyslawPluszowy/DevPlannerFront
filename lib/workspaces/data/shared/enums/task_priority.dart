import 'package:freezed_annotation/freezed_annotation.dart';

/// Priorytet zadania używany przez kontrakty projektowe.
@JsonEnum()
enum TaskPriority {
  /// Niski priorytet.
  @JsonValue('Low')
  low,

  /// Standardowy priorytet.
  @JsonValue('Normal')
  normal,

  /// Wysoki priorytet.
  @JsonValue('High')
  high,

  /// Krytyczny priorytet.
  @JsonValue('Critical')
  critical,
}

/// Stabilna reprezentacja tekstowa używana w query API.
extension TaskPriorityWireValue on TaskPriority {
  String get wireValue => switch (this) {
    TaskPriority.low => 'Low',
    TaskPriority.normal => 'Normal',
    TaskPriority.high => 'High',
    TaskPriority.critical => 'Critical',
  };
}
