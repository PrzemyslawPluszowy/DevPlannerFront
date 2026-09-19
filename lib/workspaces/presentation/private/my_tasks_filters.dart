import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';

/// Niemutowalne kryteria odczytu listy „Moje zadania”.
final class MyTasksFilters {
  const MyTasksFilters({
    this.status,
    this.priority,
    this.involvement,
    this.dueFromUtc,
    this.dueToUtc,
  });

  final ProjectTaskStatus? status;
  final TaskPriority? priority;
  final TaskInvolvementFilter? involvement;
  final DateTime? dueFromUtc;
  final DateTime? dueToUtc;

  MyTasksFilters copyWith({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    TaskInvolvementFilter? involvement,
    DateTime? dueFromUtc,
    DateTime? dueToUtc,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearInvolvement = false,
    bool clearDueFromUtc = false,
    bool clearDueToUtc = false,
  }) => MyTasksFilters(
    status: clearStatus ? null : (status ?? this.status),
    priority: clearPriority ? null : (priority ?? this.priority),
    involvement: clearInvolvement ? null : (involvement ?? this.involvement),
    dueFromUtc: clearDueFromUtc ? null : (dueFromUtc ?? this.dueFromUtc),
    dueToUtc: clearDueToUtc ? null : (dueToUtc ?? this.dueToUtc),
  );

  static String statusLabel(AppLocalizations l10n, ProjectTaskStatus value) =>
      switch (value) {
        ProjectTaskStatus.backlog => l10n.taskStatusBacklog,
        ProjectTaskStatus.todo => l10n.taskStatusTodo,
        ProjectTaskStatus.inProgress => l10n.taskStatusInProgress,
        ProjectTaskStatus.blocked => l10n.taskStatusBlocked,
        ProjectTaskStatus.done => l10n.taskStatusDone,
        ProjectTaskStatus.cancelled => l10n.taskStatusCanceled,
      };

  static String priorityLabel(AppLocalizations l10n, TaskPriority value) =>
      switch (value) {
        TaskPriority.low => l10n.myTasksPriorityLow,
        TaskPriority.normal => l10n.myTasksPriorityNormal,
        TaskPriority.high => l10n.myTasksPriorityHigh,
        TaskPriority.critical => l10n.myTasksPriorityCritical,
      };

  static String involvementLabel(
    AppLocalizations l10n,
    TaskInvolvementFilter value,
  ) => switch (value) {
    TaskInvolvementFilter.any => l10n.myTasksInvolvementAny,
    TaskInvolvementFilter.primaryAssignee =>
      l10n.myTasksInvolvementPrimaryAssignee,
    TaskInvolvementFilter.collaborator => l10n.myTasksInvolvementCollaborator,
    TaskInvolvementFilter.assignee => l10n.myTasksInvolvementAssignee,
    TaskInvolvementFilter.watcher => l10n.myTasksInvolvementWatcher,
  };
}
