import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

/// Locale-aware labels for history; numeric values belong to persisted metadata,
/// not the textual transport enums of the Task API.
abstract final class TaskHistoryPresentation {
  static String actionLabel(BuildContext context, TaskHistoryEventType type) =>
      switch (type) {
        TaskHistoryEventType.created => context.l10n.taskHistoryEventCreated,
        TaskHistoryEventType.updated => context.l10n.taskHistoryEventUpdated,
        TaskHistoryEventType.statusChanged =>
          context.l10n.taskHistoryEventStatusChanged,
        TaskHistoryEventType.assigneesChanged =>
          context.l10n.taskHistoryEventAssigneesChanged,
        TaskHistoryEventType.checklistChanged =>
          context.l10n.taskHistoryEventChecklistChanged,
        TaskHistoryEventType.watcherChanged =>
          context.l10n.taskHistoryEventWatcherChanged,
        TaskHistoryEventType.labelsChanged =>
          context.l10n.taskHistoryEventLabelsChanged,
        TaskHistoryEventType.customFieldsChanged =>
          context.l10n.taskHistoryEventCustomFieldsChanged,
        TaskHistoryEventType.acceptanceCriteriaChanged =>
          context.l10n.taskHistoryEventAcceptanceCriteriaChanged,
        TaskHistoryEventType.dependencyChanged =>
          context.l10n.taskHistoryEventDependencyChanged,
        TaskHistoryEventType.reordered =>
          context.l10n.taskHistoryEventReordered,
        TaskHistoryEventType.kanbanMoved =>
          context.l10n.taskHistoryEventKanbanMoved,
        TaskHistoryEventType.kanbanRebalanced =>
          context.l10n.taskHistoryEventKanbanRebalanced,
        TaskHistoryEventType.archived => context.l10n.taskHistoryEventArchived,
        TaskHistoryEventType.restored => context.l10n.taskHistoryEventRestored,
        TaskHistoryEventType.recurrenceChanged =>
          context.l10n.taskHistoryEventRecurrenceChanged,
        TaskHistoryEventType.recurrenceOccurrenceCreated =>
          context.l10n.taskHistoryEventRecurrenceOccurrenceCreated,
      };

  static IconData eventIcon(TaskHistoryEventType type) => switch (type) {
    TaskHistoryEventType.created => Symbols.add_task_rounded,
    TaskHistoryEventType.statusChanged ||
    TaskHistoryEventType.kanbanMoved => Symbols.swap_horiz_rounded,
    TaskHistoryEventType.archived => Symbols.archive,
    TaskHistoryEventType.restored => Symbols.unarchive,
    _ => Symbols.edit_note_rounded,
  };

  static String actorLabel(
    BuildContext context,
    TaskHistoryActorResponse actor,
    Map<String, String> names,
  ) => switch (actor.type) {
    TaskActorType.system => context.l10n.taskDetailsHistoryActorSystem,
    TaskActorType.automation => context.l10n.taskDetailsHistoryActorAutomation,
    TaskActorType.user =>
      names[actor.userId] ?? context.l10n.taskDetailsHistoryActorUser,
  };

  static String fieldLabel(BuildContext context, String field) =>
      switch (field) {
        'title' => context.l10n.taskDetailsTitleField,
        'description' ||
        'descriptionDeltaJson' => context.l10n.taskDetailsDescription,
        'status' ||
        'targetStatus' ||
        'oldStatus' => context.l10n.taskDetailsStatusField,
        'priority' => context.l10n.taskDetailsPriorityField,
        'position' => context.l10n.taskHistoryPosition,
        'isCompleted' => context.l10n.taskHistoryCompleted,
        'startAtUtc' || 'startedAtUtc' => context.l10n.taskDetailsStartDate,
        'dueAtUtc' => context.l10n.taskDetailsDueDate,
        'assigneeUserIds' => context.l10n.taskDetailsAssignees,
        'milestoneId' => context.l10n.taskDetailsMilestone,
        _ => field,
      };

  static String value(BuildContext context, String field, Object? value) {
    if (value == null) return '—';
    if (field == 'status' || field == 'targetStatus' || field == 'oldStatus') {
      final status = switch (value) {
        0 || 'Backlog' => ProjectTaskStatus.backlog,
        1 || 'Todo' => ProjectTaskStatus.todo,
        2 || 'InProgress' => ProjectTaskStatus.inProgress,
        3 || 'Blocked' => ProjectTaskStatus.blocked,
        4 || 'Done' => ProjectTaskStatus.done,
        5 || 'Cancelled' => ProjectTaskStatus.cancelled,
        _ => null,
      };
      return status == null
          ? context.l10n.taskHistoryUnknownStatus
          : TaskDetailsLabeler.status(context, status);
    }
    if (field == 'priority') {
      final priority = switch (value) {
        0 || 'Low' => TaskPriority.low,
        1 || 'Normal' => TaskPriority.normal,
        2 || 'High' => TaskPriority.high,
        3 || 'Critical' => TaskPriority.critical,
        _ => null,
      };
      return priority == null
          ? context.l10n.taskHistoryUnknownPriority
          : TaskDetailsLabeler.priority(context, priority);
    }
    if (value is bool) {
      if (field == 'isCompleted') {
        return value
            ? context.l10n.taskHistoryCompletedValue
            : context.l10n.taskHistoryIncompleteValue;
      }
      return value ? context.l10n.yes : context.l10n.no;
    }
    if (field.endsWith('AtUtc') && value is String) {
      final date = DateTime.tryParse(value);
      if (date != null) {
        return DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
            .add_Hm()
            .format(date.toLocal());
      }
    }
    final text = value.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.length <= 80 ? text : '${text.substring(0, 77)}…';
  }
}
