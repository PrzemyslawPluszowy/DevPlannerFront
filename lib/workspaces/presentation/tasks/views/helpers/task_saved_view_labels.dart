import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';

/// Helper zwracający zlokalizowane etykiety dla enumów zapisanego widoku.
abstract final class TaskSavedViewLabels {
  /// Zwraca zlokalizowaną nazwę statusu systemowego.
  static String status(BuildContext context, ProjectTaskStatus value) =>
      switch (value) {
        ProjectTaskStatus.backlog => context.l10n.taskStatusBacklog,
        ProjectTaskStatus.todo => context.l10n.taskStatusTodo,
        ProjectTaskStatus.inProgress => context.l10n.taskStatusInProgress,
        ProjectTaskStatus.blocked => context.l10n.taskStatusBlocked,
        ProjectTaskStatus.done => context.l10n.taskStatusDone,
        ProjectTaskStatus.cancelled => context.l10n.taskStatusCanceled,
      };

  /// Zwraca zlokalizowaną nazwę priorytetu.
  static String priority(BuildContext context, TaskPriority value) =>
      switch (value) {
        TaskPriority.low => context.l10n.myTasksPriorityLow,
        TaskPriority.normal => context.l10n.myTasksPriorityNormal,
        TaskPriority.high => context.l10n.myTasksPriorityHigh,
        TaskPriority.critical => context.l10n.myTasksPriorityCritical,
      };

  /// Zwraca zlokalizowaną nazwę filtra udziału użytkownika.
  static String involvement(
    BuildContext context,
    TaskInvolvementFilter value,
  ) => switch (value) {
    TaskInvolvementFilter.any => context.l10n.myTasksInvolvementAny,
    TaskInvolvementFilter.primaryAssignee =>
      context.l10n.myTasksInvolvementPrimaryAssignee,
    TaskInvolvementFilter.collaborator =>
      context.l10n.myTasksInvolvementCollaborator,
    TaskInvolvementFilter.assignee => context.l10n.myTasksInvolvementAssignee,
    TaskInvolvementFilter.watcher => context.l10n.myTasksInvolvementWatcher,
  };

  /// Zwraca zlokalizowaną nazwę pola sortowania.
  static String sortField(
    BuildContext context,
    TaskSavedViewSortField value,
  ) => switch (value) {
    TaskSavedViewSortField.position => context.l10n.tasksSavedViewsSortPosition,
    TaskSavedViewSortField.updatedAtUtc =>
      context.l10n.tasksSavedViewsSortUpdated,
    TaskSavedViewSortField.dueAtUtc => context.l10n.tasksSavedViewsSortDueDate,
    TaskSavedViewSortField.priority => context.l10n.tasksSavedViewsSortPriority,
    TaskSavedViewSortField.title => context.l10n.tasksSavedViewsSortTitle,
  };

  /// Zwraca zlokalizowaną nazwę grupowania.
  static String groupBy(
    BuildContext context,
    TaskSavedViewGroupBy value,
  ) => switch (value) {
    TaskSavedViewGroupBy.none => context.l10n.tasksSavedViewsGroupNone,
    TaskSavedViewGroupBy.status => context.l10n.tasksSavedViewsGroupStatus,
    TaskSavedViewGroupBy.customStatus => 'Własny status',
    TaskSavedViewGroupBy.priority => context.l10n.tasksSavedViewsGroupPriority,
    TaskSavedViewGroupBy.assignee => context.l10n.tasksSavedViewsGroupAssignee,
  };

  /// Zwraca zlokalizowaną nazwę kolumny systemowej.
  static String column(
    BuildContext context,
    TaskSavedViewColumn value,
  ) => switch (value) {
    TaskSavedViewColumn.key => context.l10n.tasksSavedViewsColumnKey,
    TaskSavedViewColumn.title => context.l10n.tasksSavedViewsColumnTitle,
    TaskSavedViewColumn.status => context.l10n.tasksSavedViewsColumnStatus,
    TaskSavedViewColumn.customStatus => 'Własny status',
    TaskSavedViewColumn.priority => context.l10n.tasksSavedViewsColumnPriority,
    TaskSavedViewColumn.assignees =>
      context.l10n.tasksSavedViewsColumnAssignees,
    TaskSavedViewColumn.owner => 'Właściciel',
    TaskSavedViewColumn.collaborators => 'Współpracownicy',
    TaskSavedViewColumn.labels => 'Etykiety',
    TaskSavedViewColumn.watchers => 'Obserwujący',
    TaskSavedViewColumn.startAtUtc =>
      context.l10n.tasksSavedViewsColumnStartDate,
    TaskSavedViewColumn.dueAtUtc => context.l10n.tasksSavedViewsColumnDueDate,
    TaskSavedViewColumn.checklistProgress =>
      context.l10n.tasksSavedViewsColumnChecklist,
    TaskSavedViewColumn.updatedAtUtc =>
      context.l10n.tasksSavedViewsColumnUpdated,
    TaskSavedViewColumn.createdAtUtc => 'Utworzono',
    TaskSavedViewColumn.taskType => 'Typ',
    TaskSavedViewColumn.size => 'Rozmiar',
    TaskSavedViewColumn.complexity => 'Złożoność',
    TaskSavedViewColumn.risk => 'Ryzyko',
    TaskSavedViewColumn.businessValue => 'Wartość biznesowa',
    TaskSavedViewColumn.estimatedMinutes => 'Estymata',
    TaskSavedViewColumn.actualMinutes => 'Czas rzeczywisty',
    TaskSavedViewColumn.milestone => 'Kamień milowy',
  };
}
