import 'package:freezed_annotation/freezed_annotation.dart';

/// Stabilna kategoria analityczna statusu zadania.
@JsonEnum()
enum TaskStatusCategory {
  /// Zadanie oczekuje na rozpoczęcie.
  @JsonValue('Todo')
  todo,

  /// Zadanie jest w trakcie realizacji.
  @JsonValue('InProgress')
  inProgress,

  /// Zadanie zostało wykonane.
  @JsonValue('Done')
  done,

  /// Zadanie zostało anulowane.
  @JsonValue('Cancelled')
  cancelled,
}
