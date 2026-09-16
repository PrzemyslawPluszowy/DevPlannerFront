import 'package:json_annotation/json_annotation.dart';

/// Znaczenie relacji między zadaniami.
@JsonEnum()
enum TaskDependencyType {
  @JsonValue('Blocks')
  blocks,
  @JsonValue('RelatedTo')
  relatedTo,
  @JsonValue('Duplicate')
  duplicate,
}

/// Relacja czasowa Gantta między zadaniami.
@JsonEnum()
enum TaskDependencyKind {
  @JsonValue('FinishToStart')
  finishToStart,
  @JsonValue('StartToStart')
  startToStart,
  @JsonValue('FinishToFinish')
  finishToFinish,
  @JsonValue('StartToFinish')
  startToFinish,
}

/// Typ wartości pola niestandardowego zadania.
@JsonEnum()
enum TaskCustomFieldType {
  @JsonValue('Text')
  text,
  @JsonValue('Number')
  number,
  @JsonValue('Date')
  date,
  @JsonValue('Boolean')
  boolean,
  @JsonValue('SingleSelect')
  singleSelect,
  @JsonValue('MultiSelect')
  multiSelect,
  @JsonValue('User')
  user,
}

/// Zakres zaangażowania użytkownika w zadanie.
@JsonEnum()
enum TaskInvolvementFilter {
  @JsonValue('Any')
  any,
  @JsonValue('PrimaryAssignee')
  primaryAssignee,
  @JsonValue('Collaborator')
  collaborator,
  @JsonValue('Assignee')
  assignee,
  @JsonValue('Watcher')
  watcher,
}
