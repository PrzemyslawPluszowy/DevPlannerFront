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
