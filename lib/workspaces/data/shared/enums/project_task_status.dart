import 'package:freezed_annotation/freezed_annotation.dart';

/// Status zadania zwracany w odpowiedzi przypisania do milestone.
@JsonEnum()
enum ProjectTaskStatus {
  /// Zadanie w backlogu.
  @JsonValue('Backlog')
  backlog,

  /// Zadanie do wykonania.
  @JsonValue('Todo')
  todo,

  /// Zadanie w trakcie realizacji.
  @JsonValue('InProgress')
  inProgress,

  /// Zadanie zablokowane.
  @JsonValue('Blocked')
  blocked,

  /// Zadanie ukończone.
  @JsonValue('Done')
  done,

  /// Zadanie anulowane.
  @JsonValue('Cancelled')
  cancelled,
}

/// Stabilna reprezentacja tekstowa używana w path/query API.
extension ProjectTaskStatusWireValue on ProjectTaskStatus {
  String get wireValue => switch (this) {
    ProjectTaskStatus.backlog => 'Backlog',
    ProjectTaskStatus.todo => 'Todo',
    ProjectTaskStatus.inProgress => 'InProgress',
    ProjectTaskStatus.blocked => 'Blocked',
    ProjectTaskStatus.done => 'Done',
    ProjectTaskStatus.cancelled => 'Cancelled',
  };
}
