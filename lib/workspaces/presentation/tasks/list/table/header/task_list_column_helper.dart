import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_type_visual.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Klasa pomocnicza dla kolumn tabeli zadań.
///
/// Tłumaczy kolumny systemowe na czytelne etykiety z `context.l10n`
/// oraz przypisuje im dedykowane ikony Material Symbols.
abstract final class TaskListColumnHelper {
  /// Zwraca zlokalizowaną etykietę dla kolumny widoku zadań.
  static String label(
    BuildContext context,
    TaskSavedViewColumn column,
  ) => switch (column) {
    TaskSavedViewColumn.key => context.l10n.tasksSavedViewsColumnKey,
    TaskSavedViewColumn.title => context.l10n.tasksListTask,
    TaskSavedViewColumn.status => context.l10n.tasksListStatus,
    TaskSavedViewColumn.customStatus => context.l10n.tasksListCustomStatus,
    TaskSavedViewColumn.priority => context.l10n.tasksListPriority,
    TaskSavedViewColumn.assignees => context.l10n.tasksListOwner,
    TaskSavedViewColumn.owner => context.l10n.tasksListOwner,
    TaskSavedViewColumn.collaborators => context.l10n.tasksListCollaborators,
    TaskSavedViewColumn.labels => context.l10n.taskDetailsLabels,
    TaskSavedViewColumn.watchers => context.l10n.tasksListWatchers,
    TaskSavedViewColumn.startAtUtc =>
      context.l10n.tasksSavedViewsColumnStartDate,
    TaskSavedViewColumn.dueAtUtc => context.l10n.tasksListDueDate,
    TaskSavedViewColumn.checklistProgress => context.l10n.tasksListProgress,
    TaskSavedViewColumn.updatedAtUtc =>
      context.l10n.tasksSavedViewsColumnUpdated,
    TaskSavedViewColumn.createdAtUtc => context.l10n.tasksListCreated,
    TaskSavedViewColumn.taskType => context.l10n.tasksListTaskType,
    TaskSavedViewColumn.size => context.l10n.tasksListSize,
    TaskSavedViewColumn.complexity => context.l10n.tasksListComplexity,
    TaskSavedViewColumn.risk => context.l10n.tasksListRisk,
    TaskSavedViewColumn.businessValue => context.l10n.tasksListBusinessValue,
    TaskSavedViewColumn.estimatedMinutes =>
      context.l10n.tasksListEstimatedMinutes,
    TaskSavedViewColumn.actualMinutes => context.l10n.tasksListActualMinutes,
    TaskSavedViewColumn.milestone => context.l10n.tasksListMilestone,
  };

  /// Zwraca ikonę reprezentującą kolumnę tabeli.
  static IconData icon(TaskSavedViewColumn column) => switch (column) {
    TaskSavedViewColumn.key => Symbols.tag_rounded,
    TaskSavedViewColumn.title => Symbols.title_rounded,
    TaskSavedViewColumn.status => Symbols.check_circle_rounded,
    TaskSavedViewColumn.customStatus => Symbols.flowsheet_rounded,
    TaskSavedViewColumn.priority => Symbols.flag_rounded,
    TaskSavedViewColumn.assignees ||
    TaskSavedViewColumn.owner => Symbols.person_rounded,
    TaskSavedViewColumn.collaborators => Symbols.group_rounded,
    TaskSavedViewColumn.labels => Symbols.label_rounded,
    TaskSavedViewColumn.watchers => Symbols.visibility_rounded,
    TaskSavedViewColumn.startAtUtc ||
    TaskSavedViewColumn.dueAtUtc => Symbols.calendar_today_rounded,
    TaskSavedViewColumn.checklistProgress => Symbols.checklist_rounded,
    TaskSavedViewColumn.updatedAtUtc ||
    TaskSavedViewColumn.createdAtUtc => Symbols.schedule_rounded,
    TaskSavedViewColumn.taskType => Symbols.category_rounded,
    TaskSavedViewColumn.size => Symbols.straighten_rounded,
    TaskSavedViewColumn.complexity => Symbols.network_node_rounded,
    TaskSavedViewColumn.risk => Symbols.warning_rounded,
    TaskSavedViewColumn.businessValue => Symbols.trending_up_rounded,
    TaskSavedViewColumn.estimatedMinutes ||
    TaskSavedViewColumn.actualMinutes => Symbols.timer_rounded,
    TaskSavedViewColumn.milestone => Symbols.flag_circle_rounded,
  };

  /// Zwraca czytelną etykietę dla dowolnej referencji kolumny.
  static String referenceLabel(
    BuildContext context,
    TaskColumnReference reference, {
    List<TaskCustomFieldResponse> customFields = const [],
  }) => switch (reference) {
    SystemColumnReference(:final column) => label(context, column),
    CustomFieldColumnReference(:final fieldId) =>
      customFields.where((f) => f.id == fieldId).firstOrNull?.name ?? fieldId,
  };

  /// Zwraca ikonę semantyczną dla dowolnej referencji kolumny.
  static IconData referenceIcon(
    TaskColumnReference reference, {
    List<TaskCustomFieldResponse> customFields = const [],
  }) => switch (reference) {
    SystemColumnReference(:final column) => icon(column),
    CustomFieldColumnReference(:final fieldId) => () {
      final field = customFields.where((f) => f.id == fieldId).firstOrNull;
      if (field == null) return Symbols.extension_rounded;
      return CustomFieldTypeVisualCatalog.forType(field.type).icon;
    }(),
  };
}
