import 'package:json_annotation/json_annotation.dart';

/// Wyzwalacz reguły automatyzacji.
@JsonEnum(fieldRename: FieldRename.pascal)
enum AutomationTriggerType {
  taskCreated,
  taskStatusChanged,
  taskKanbanMoved,
  taskDueSoon,
  fileUploaded,
  wikiPublished,
  whiteboardExported,
  schedule,
}

/// Typ warunku reguły automatyzacji.
@JsonEnum(fieldRename: FieldRename.pascal)
enum AutomationConditionType {
  taskStatusIs,
  taskPriorityIs,
  taskAssigneeIs,
  taskDueWithinDays,
  taskHasLabel,
  taskTitleContains,
}

/// Typ akcji reguły automatyzacji.
@JsonEnum(fieldRename: FieldRename.pascal)
enum AutomationActionType {
  setTaskStatus,
  setTaskPriority,
  assignTask,
  addTaskLabel,
  removeTaskLabel,
  setTaskDueDate,
  notifyUser,
  createSubtask,
  sendChatMessage,
  updateOkrKeyResult,
  invokeWebhook,
  createStorageNotification,
}

/// Stan uruchomienia reguły.
@JsonEnum(fieldRename: FieldRename.pascal)
enum AutomationRunStatus {
  queued,
  running,
  succeeded,
  partiallySucceeded,
  failed,
  skippedConditions,
  skippedDisabled,
  skippedLoop,
}
