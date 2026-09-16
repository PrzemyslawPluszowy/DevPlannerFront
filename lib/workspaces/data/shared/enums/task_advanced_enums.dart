import 'package:json_annotation/json_annotation.dart';

/// Tryb uruchamiania kolejnego wystąpienia serii zadania.
@JsonEnum()
enum TaskRecurrenceMode {
  @JsonValue('Scheduled')
  scheduled,
  @JsonValue('AfterCompletion')
  afterCompletion,
}

/// Jednostka powtarzania serii zadania.
@JsonEnum()
enum TaskRecurrenceFrequency {
  @JsonValue('Daily')
  daily,
  @JsonValue('Weekly')
  weekly,
  @JsonValue('Monthly')
  monthly,
}

/// Wynik pojedynczego terminu serii cyklicznej.
@JsonEnum()
enum TaskRecurrenceRunOutcome {
  @JsonValue('Created')
  created,
  @JsonValue('SkippedPreviousOpen')
  skippedPreviousOpen,
}

/// Typ aktora wpisu historii zadania.
@JsonEnum()
enum TaskActorType {
  @JsonValue('User')
  user,
  @JsonValue('System')
  system,
  @JsonValue('Automation')
  automation,
}

/// Typ wpisu czasu pracy.
@JsonEnum()
enum TaskTimeEntryKind {
  @JsonValue('Manual')
  manual,
  @JsonValue('Timer')
  timer,
}

/// Status akceptacji wpisu czasu.
@JsonEnum()
enum TaskTimeEntryApprovalStatus {
  @JsonValue('Draft')
  draft,
  @JsonValue('Submitted')
  submitted,
  @JsonValue('Approved')
  approved,
  @JsonValue('Rejected')
  rejected,
}

/// Typ zdarzenia w niezmiennej historii zadania.
@JsonEnum()
enum TaskHistoryEventType {
  @JsonValue('Created')
  created,
  @JsonValue('Updated')
  updated,
  @JsonValue('StatusChanged')
  statusChanged,
  @JsonValue('AssigneesChanged')
  assigneesChanged,
  @JsonValue('ChecklistChanged')
  checklistChanged,
  @JsonValue('WatcherChanged')
  watcherChanged,
  @JsonValue('LabelsChanged')
  labelsChanged,
  @JsonValue('CustomFieldsChanged')
  customFieldsChanged,
  @JsonValue('AcceptanceCriteriaChanged')
  acceptanceCriteriaChanged,
  @JsonValue('DependencyChanged')
  dependencyChanged,
  @JsonValue('Reordered')
  reordered,
  @JsonValue('KanbanMoved')
  kanbanMoved,
  @JsonValue('KanbanRebalanced')
  kanbanRebalanced,
  @JsonValue('Archived')
  archived,
  @JsonValue('Restored')
  restored,
  @JsonValue('RecurrenceChanged')
  recurrenceChanged,
  @JsonValue('RecurrenceOccurrenceCreated')
  recurrenceOccurrenceCreated,
}

/// Źródło pojemności użytej w workloadzie.
@JsonEnum()
enum CapacitySource {
  @JsonValue('WorkspaceDefault')
  workspaceDefault,
  @JsonValue('ProjectUserOverride')
  projectUserOverride,
}

/// Tryb automatycznego harmonogramu projektu.
@JsonEnum()
enum AutoScheduleMode {
  @JsonValue('Manual')
  manual,
  @JsonValue('PushSuccessorsOnly')
  pushSuccessorsOnly,
  @JsonValue('StrictCascade')
  strictCascade,
}
