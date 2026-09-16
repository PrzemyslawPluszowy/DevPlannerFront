import 'package:json_annotation/json_annotation.dart';

/// Sposób grupowania kart w tablicy.
@JsonEnum()
enum KanbanSwimlaneMode {
  @JsonValue('None')
  none,

  @JsonValue('Assignee')
  assignee,

  @JsonValue('Priority')
  priority,

  @JsonValue('Milestone')
  milestone,
}

/// Pole widoczne na kafelku Kanban.
@JsonEnum()
enum KanbanCardField {
  @JsonValue('Assignee')
  assignee,

  @JsonValue('DueDate')
  dueDate,

  @JsonValue('Labels')
  labels,

  @JsonValue('Checklist')
  checklist,

  @JsonValue('Subtasks')
  subtasks,

  @JsonValue('TimeTracking')
  timeTracking,

  @JsonValue('Blockers')
  blockers,

  @JsonValue('CoverAttachment')
  coverAttachment,

  @JsonValue('CustomFields')
  customFields,
}

/// Gęstość kafelka Kanban.
@JsonEnum()
enum KanbanCardDensity {
  @JsonValue('Compact')
  compact,

  @JsonValue('Comfortable')
  comfortable,

  @JsonValue('Detailed')
  detailed,
}

/// Szybki filtr osobistego widoku Kanban.
@JsonEnum()
enum KanbanQuickFilter {
  @JsonValue('All')
  all,

  @JsonValue('Mine')
  mine,

  @JsonValue('Unassigned')
  unassigned,

  @JsonValue('Blocked')
  blocked,

  @JsonValue('DueSoon')
  dueSoon,
}
