import 'dart:async';

import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kontekstowy pasek akcji masowych Listy.
///
/// Jego miejsce to drugi wiersz wspólnego nagłówka, więc nad treścią nie ma już
/// drugiego, pływającego paska. Kontrolki przewijają się poziomo, korzystają ze
/// wspólnego menu kontekstowego i tokenów gęstości Tasks.
class TaskListBulkBar extends StatelessWidget {
  const TaskListBulkBar({
    required this.listCubit,
    required this.listState,
    required this.memberProfiles,
    this.preferencesState,
    super.key,
  });

  final ProjectTasksListCubit listCubit;
  final ProjectTasksListState listState;
  final Map<String, ProjectMemberProfile> memberProfiles;
  final TaskListPreferencesState? preferencesState;

  ProjectTasksListReady? get _ready => listState is ProjectTasksListReady
      ? listState as ProjectTasksListReady
      : null;

  @override
  Widget build(BuildContext context) {
    final ready = _ready;
    if (ready == null) return const SizedBox.shrink();

    final selectedCount = ready.selectedTaskIds.length;
    final preferences = preferencesState is TaskListPreferencesReady
        ? preferencesState! as TaskListPreferencesReady
        : null;
    final workflowGroups = [
      for (final group in ready.groups)
        if (group.key.startsWith('custom-status:')) group,
    ];
    final profiles = _sortedProfiles();

    return TasksContextualBulkBar(
      selectedCount: selectedCount,
      onClearSelection: listCubit.clearSelection,
      controls: [
        TasksBulkMenu<ProjectTaskStatus>(
          key: const ValueKey('bulk_status'),
          icon: Symbols.playlist_add_check_rounded,
          label: 'Status',
          options: [
            for (final status in ProjectTaskStatus.values)
              AppContextMenuOption<ProjectTaskStatus>(
                value: status,
                label: TaskStatusVisualHelper.label(context, status),
                icon: TaskStatusVisualHelper.icon(status),
                iconColor: TaskStatusVisualHelper.color(status),
              ),
          ],
          onSelected: (status) => unawaited(_apply(status: status)),
        ),
        TasksBulkMenu<TaskPriority>(
          key: const ValueKey('bulk_priority'),
          icon: Symbols.flag,
          label: 'Priorytet',
          options: [
            for (final priority in TaskPriority.values)
              AppContextMenuOption<TaskPriority>(
                value: priority,
                label: TaskPriorityVisualHelper.label(context, priority),
                icon: TaskPriorityVisualHelper.icon(priority),
                iconColor: TaskPriorityVisualHelper.color(priority),
              ),
          ],
          onSelected: (priority) => unawaited(_apply(priority: priority)),
        ),
        TasksBulkButton(
          key: const ValueKey('bulk_due_today'),
          icon: Symbols.today,
          label: 'Termin dziś',
          onTap: () => unawaited(_apply(dueAtUtc: DateTime.now().toUtc())),
        ),
        if (preferences?.groupBy == TaskSavedViewGroupBy.customStatus &&
            workflowGroups.isNotEmpty)
          TasksBulkMenu<String>(
            key: const ValueKey('bulk_group_move'),
            icon: Symbols.account_tree,
            label: 'Grupa wszystkich',
            options: [
              for (final group in workflowGroups)
                AppContextMenuOption<String>(
                  value: group.key,
                  label: 'Cały wynik: ${group.displayName}',
                ),
            ],
            onSelected: (key) => unawaited(
              _apply(
                customStatusId: key == 'custom-status:none'
                    ? null
                    : key.substring('custom-status:'.length),
                clearCustomStatus: key == 'custom-status:none',
                entireResult: true,
              ),
            ),
          ),
        if (profiles.isNotEmpty)
          TasksBulkMenu<String>(
            key: const ValueKey('bulk_assignee'),
            icon: Symbols.person_add_alt,
            label: 'Wykonawca',
            options: [
              for (final profile in profiles)
                AppContextMenuOption<String>(
                  value: profile.userId,
                  label: _profileName(profile),
                ),
            ],
            onSelected: (userId) => unawaited(_apply(assigneeIds: [userId])),
          ),
        TasksBulkButton(
          key: const ValueKey('bulk_archive'),
          icon: Symbols.archive,
          label: 'Archiwizuj',
          isDestructive: true,
          onTap: () => unawaited(_apply(archive: true)),
        ),
        TasksBulkMenu<String>(
          key: const ValueKey('bulk_entire_result'),
          icon: Symbols.select_all_rounded,
          label: 'Cały wynik',
          options: [
            for (final status in ProjectTaskStatus.values)
              AppContextMenuOption<String>(
                value: 'status:${status.name}',
                label:
                    'Status: ${TaskStatusVisualHelper.label(context, status)}',
                icon: TaskStatusVisualHelper.icon(status),
                iconColor: TaskStatusVisualHelper.color(status),
              ),
            for (final priority in TaskPriority.values)
              AppContextMenuOption<String>(
                value: 'priority:${priority.name}',
                label:
                    'Priorytet: ${TaskPriorityVisualHelper.label(context, priority)}',
                icon: TaskPriorityVisualHelper.icon(priority),
                iconColor: TaskPriorityVisualHelper.color(priority),
                separatorBefore: priority == TaskPriority.values.first,
              ),
            const AppContextMenuOption<String>(
              value: 'due_today',
              label: 'Termin dziś dla całego wyniku',
              icon: Symbols.event_available,
              separatorBefore: true,
            ),
            const AppContextMenuOption<String>(
              value: 'archive',
              label: 'Archiwizuj cały wynik',
              icon: Symbols.archive,
              isDestructive: true,
            ),
          ],
          onSelected: (value) => unawaited(_applyEntireResult(value)),
        ),
      ],
    );
  }

  List<ProjectMemberProfile> _sortedProfiles() =>
      memberProfiles.values.toList(growable: false)..sort(
        (left, right) => _profileName(left).compareTo(_profileName(right)),
      );

  Future<void> _apply({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    List<String>? assigneeIds,
    String? customStatusId,
    bool clearCustomStatus = false,
    bool archive = false,
    bool entireResult = false,
  }) async {
    if (entireResult) {
      await listCubit.bulkUpdateEntireResult(
        status: status,
        customStatusId: customStatusId,
        clearCustomStatus: clearCustomStatus,
        priority: priority,
        dueAtUtc: dueAtUtc,
        assigneeIds: assigneeIds,
        archive: archive,
      );
      return;
    }
    // Przeniesienie do grupy workflow obsługuje wyłącznie cały wynik, więc dla
    // zaznaczonych zadań przekazujemy tylko wspierane pola.
    await listCubit.bulkUpdateSelected(
      status: status,
      priority: priority,
      dueAtUtc: dueAtUtc,
      assigneeIds: assigneeIds,
      archive: archive,
    );
  }

  Future<void> _applyEntireResult(String value) async {
    final separator = value.indexOf(':');
    if (separator == -1) {
      await _apply(
        dueAtUtc: value == 'due_today' ? DateTime.now().toUtc() : null,
        archive: value == 'archive',
        entireResult: true,
      );
      return;
    }
    final kind = value.substring(0, separator);
    final name = value.substring(separator + 1);
    if (kind == 'status') {
      await _apply(
        status: ProjectTaskStatus.values.firstWhere((s) => s.name == name),
        entireResult: true,
      );
      return;
    }
    await _apply(
      priority: TaskPriority.values.firstWhere((p) => p.name == name),
      entireResult: true,
    );
  }

  static String _profileName(ProjectMemberProfile profile) {
    final displayName = profile.displayName?.trim();
    return displayName?.isNotEmpty == true ? displayName! : profile.userId;
  }
}
