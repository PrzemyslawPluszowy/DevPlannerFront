import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_priority_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_status_picker.dart';

/// Zwięzły opis serii wspólny dla tabeli Tasks i karty Kanban.
String taskRecurrenceSummaryLabel(TaskRecurrenceSummaryResponse recurrence) {
  final frequency = switch (recurrence.frequency) {
    TaskRecurrenceFrequency.daily => 'dzień',
    TaskRecurrenceFrequency.weekly => 'tydzień',
    TaskRecurrenceFrequency.monthly => 'miesiąc',
  };
  final mode = switch (recurrence.mode) {
    TaskRecurrenceMode.scheduled => 'według harmonogramu',
    TaskRecurrenceMode.afterCompletion => 'po ukończeniu',
  };
  final state = recurrence.isActive ? 'aktywna' : 'wstrzymana';
  final nextInfo = recurrence.nextOccurrenceAtUtc != null
      ? ' • Następne zadanie: ${DateFormat.yMMMd('pl').add_Hm().format(recurrence.nextOccurrenceAtUtc!.toLocal())}'
      : (recurrence.mode == TaskRecurrenceMode.afterCompletion
            ? ' • Oczekuje na ukończenie otwartego zadania'
            : '');
  return 'Cykliczność $state: co ${recurrence.interval} $frequency ($mode)$nextInfo';
}

/// Wyświetla menu kontekstowe dla wiersza zadania w tabeli.
Future<void> showTaskRowContextMenu(
  BuildContext context, {
  required ProjectTaskListItemResponse task,
  required Offset position,
  VoidCallback? onOpen,
  Future<void> Function()? onDuplicate,
  Future<void> Function()? onCreateSubtask,
  Future<bool> Function(ProjectTaskStatus status)? onStatusChanged,
  Future<bool> Function(TaskPriority priority)? onPriorityChanged,
  Future<bool> Function(List<String> coreUserIds)? onAssigneesChanged,
  Future<bool> Function(DateTime? dueAtUtc)? onDueDateChanged,
  Future<bool> Function()? onArchive,
  Future<bool> Function(bool isPinned)? onPinnedChanged,
  Future<bool> Function()? onWatchingToggled,
  Future<bool> Function()? onRecurrenceToggled,
  Future<void> Function(Offset position)? onRecurrenceConfigured,
  Map<String, ProjectMemberProfile>? profiles,
  List<TaskCustomFieldResponse> customFields = const [],
  Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged,
  EligibleProfilesPageLoader? searchEligibleProfiles,
}) => AppContextMenu.show(
  context,
  globalPosition: position,
  actions: [
    if (onOpen != null)
      AppContextMenuAction(
        label: context.l10n.taskDetailsEditBasics,
        icon: Symbols.open_in_new,
        onTap: (_) => onOpen(),
      ),
    if (onStatusChanged != null)
      AppContextMenuAction(
        label:
            '${context.l10n.tasksListStatus}: ${TaskStatusVisualHelper.label(context, task.status)}',
        icon: Symbols.check_circle_rounded,
        onTap: (menuContext) => TaskStatusPicker.show(
          menuContext,
          selected: task.status,
          onChanged: onStatusChanged,
          position: position,
        ),
      ),
    if (onPriorityChanged != null)
      AppContextMenuAction(
        label:
            '${context.l10n.tasksListPriority}: ${TaskPriorityVisualHelper.label(context, task.priority)}',
        icon: Symbols.flag_rounded,
        onTap: (menuContext) => TaskPriorityPicker.show(
          menuContext,
          selected: task.priority,
          onChanged: onPriorityChanged,
          position: position,
        ),
      ),
    if (onAssigneesChanged != null && profiles != null)
      AppContextMenuAction(
        label: context.l10n.tasksListOwner,
        icon: Symbols.person_rounded,
        onTap: (menuContext) => showTaskAssigneeEditor(
          menuContext,
          assignees: task.assignees,
          profiles: profiles,
          onSave: onAssigneesChanged,
          searchEligibleProfiles: searchEligibleProfiles,
        ),
      ),
    if (onAssigneesChanged != null && profiles != null)
      AppContextMenuAction(
        label: context.l10n.taskDetailsAssignees,
        icon: Symbols.group_add,
        onTap: (menuContext) => showTaskAssigneeEditor(
          menuContext,
          assignees: task.assignees,
          profiles: profiles,
          onSave: onAssigneesChanged,
          searchEligibleProfiles: searchEligibleProfiles,
        ),
      ),
    if (onDueDateChanged != null)
      AppContextMenuAction(
        label: context.l10n.tasksListDueDate,
        icon: Symbols.event,
        onTap: (menuContext) async {
          final selection = await pickAnchoredDate(
            menuContext,
            initialValue: task.dueAtUtc,
            globalPosition: position,
          );
          if (selection == null) return;
          await onDueDateChanged(asUtcCalendarDate(selection.value));
        },
      ),
    if (onPinnedChanged != null)
      AppContextMenuAction(
        label: task.isPinned
            ? context.l10n.taskDetailsUnpin
            : context.l10n.taskDetailsPin,
        icon: task.isPinned ? Symbols.push_pin : Symbols.push_pin_rounded,
        onTap: (_) => onPinnedChanged(!task.isPinned),
      ),
    if (onWatchingToggled != null)
      AppContextMenuAction(
        label: task.isWatchedByMe
            ? context.l10n.taskDetailsStopWatching
            : context.l10n.taskDetailsWatch,
        icon: task.isWatchedByMe
            ? Symbols.notifications_active
            : Symbols.notifications_none_rounded,
        onTap: (_) => onWatchingToggled(),
      ),
    if (task.recurrence != null && onRecurrenceToggled != null)
      AppContextMenuAction(
        label: task.recurrence!.isActive
            ? context.l10n.taskDetailsRecurrencePause
            : context.l10n.taskDetailsRecurrenceResume,
        icon: task.recurrence!.isActive
            ? Symbols.pause_circle_outline_rounded
            : Symbols.play_circle_rounded,
        onTap: (_) => onRecurrenceToggled(),
      ),
    if (onRecurrenceConfigured != null)
      AppContextMenuAction(
        label: task.recurrence == null
            ? context.l10n.taskDetailsConfigureRecurrence
            : context.l10n.tasksRecurrenceEdit,
        icon: Symbols.repeat_rounded,
        onTap: (_) => onRecurrenceConfigured(position),
      ),
    if (onCreateSubtask != null)
      AppContextMenuAction(
        label: context.l10n.taskDetailsAddSubtask,
        icon: Symbols.account_tree,
        onTap: (_) => onCreateSubtask(),
      ),
    AppContextMenuAction(
      label: 'Duplikuj zadanie',
      icon: Symbols.content_copy,
      onTap: (_) => onDuplicate?.call(),
    ),
    if (onArchive != null)
      AppContextMenuAction(
        label: 'Archiwizuj zadanie',
        icon: Symbols.archive,
        isDestructive: true,
        separatorBefore: true,
        onTap: (_) => onArchive(),
      ),
  ],
);
