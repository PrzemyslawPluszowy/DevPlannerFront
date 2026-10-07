import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_interaction.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/bulk/task_list_bulk_actions.dart';
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
class TaskListBulkBar extends StatefulWidget {
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

  @override
  State<TaskListBulkBar> createState() => _TaskListBulkBarState();
}

final class _TaskListBulkBarState extends State<TaskListBulkBar> {
  ProjectTasksListCubit get listCubit => widget.listCubit;
  ProjectTasksListState get listState => widget.listState;
  TaskListPreferencesState? get preferencesState => widget.preferencesState;
  Map<String, ProjectMemberProfile> get memberProfiles => widget.memberProfiles;
  late List<ProjectMemberProfile> _profiles;
  late TaskListBulkActions _actions;
  final TasksBulkInteraction _dueDateInteraction = TasksBulkInteraction();
  @override
  void initState() {
    super.initState();
    _prepareProfiles();
    _actions = _createActions();
  }

  @override
  void didUpdateWidget(TaskListBulkBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.listCubit, widget.listCubit) ||
        !identical(oldWidget.memberProfiles, widget.memberProfiles)) {
      _actions = _createActions();
    }
    if (!identical(oldWidget.memberProfiles, widget.memberProfiles)) {
      _prepareProfiles();
    }
  }

  TaskListBulkActions _createActions() {
    final source = listCubit;
    return TaskListBulkActions(
      source,
      profiles: memberProfiles,
      dueDateInteraction: _dueDateInteraction,
      isCurrentSource: () => mounted && identical(listCubit, source),
    );
  }

  void _prepareProfiles() {
    _profiles = memberProfiles.values.toList()
      ..sort((a, b) => _profileName(a).compareTo(_profileName(b)));
  }

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
    final profiles = _profiles;

    return TasksContextualBulkBar(
      selectedCount: selectedCount,
      onClearSelection: listCubit.clearSelection,
      isSaving: ready.isBulkSaving,
      errorMessage: switch (ready.bulkError?.message) {
        'tasks.bulk.selection_limit' => context.l10n.tasksBulkSelectionLimit,
        'tasks.bulk.save_failed' => context.l10n.tasksBulkSaveFailed,
        'tasks.bulk.scope_expired' => context.l10n.tasksBulkScopeExpired,
        _ => ready.bulkError?.message,
      },
      onRetry: ready.canRetryBulk
          ? () => unawaited(listCubit.retryBulkOperation())
          : null,
      controls: [
        if (selectedCount > 500)
          SizedBox(
            width: 360,
            child: Text(
              context.l10n.tasksBulkSelectionLimit,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        TasksBulkMenu<ProjectTaskStatus>(
          isLoading: ready.isBulkSaving,
          key: const ValueKey('bulk_status'),
          icon: Symbols.playlist_add_check_rounded,
          label: context.l10n.tasksBulkStatus,
          options: [
            for (final status in ProjectTaskStatus.values)
              AppContextMenuOption<ProjectTaskStatus>(
                value: status,
                label: TaskStatusVisualHelper.label(context, status),
                icon: TaskStatusVisualHelper.icon(status),
                iconColor: TaskStatusVisualHelper.color(status),
              ),
          ],
          onSelected: (status) =>
              unawaited(_actions.apply(context, status: status)),
        ),
        TasksBulkMenu<TaskPriority>(
          isLoading: ready.isBulkSaving,
          key: const ValueKey('bulk_priority'),
          icon: Symbols.flag,
          label: context.l10n.tasksBulkPriority,
          options: [
            for (final priority in TaskPriority.values)
              AppContextMenuOption<TaskPriority>(
                value: priority,
                label: TaskPriorityVisualHelper.label(context, priority),
                icon: TaskPriorityVisualHelper.icon(priority),
                iconColor: TaskPriorityVisualHelper.color(priority),
              ),
          ],
          onSelected: (priority) =>
              unawaited(_actions.apply(context, priority: priority)),
        ),
        TasksBulkButton(
          key: const ValueKey('bulk_due_today'),
          icon: Symbols.today,
          label: context.l10n.tasksBulkDueDate,
          onTap: ready.isBulkSaving
              ? null
              : () => unawaited(_actions.pickDueDate(context)),
        ),
        if (preferences?.groupBy == TaskSavedViewGroupBy.customStatus &&
            workflowGroups.isNotEmpty)
          TasksBulkMenu<String>(
            isLoading: ready.isBulkSaving,
            key: const ValueKey('bulk_group_move'),
            icon: Symbols.account_tree,
            label: context.l10n.tasksBulkEntireGroup,
            options: [
              for (final group in workflowGroups)
                AppContextMenuOption<String>(
                  value: group.key,
                  label: context.l10n.tasksBulkGroup(group.displayName),
                ),
            ],
            onSelected: (key) => unawaited(
              _actions.apply(
                context,
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
            isLoading: ready.isBulkSaving,
            key: const ValueKey('bulk_assignee'),
            icon: Symbols.person_add_alt,
            label: context.l10n.taskDetailsAssignees,
            options: [
              for (final profile in profiles)
                AppContextMenuOption<String>(
                  value: profile.userId,
                  label: _profileName(profile).isEmpty
                      ? context.l10n.taskDetailsProjectMember
                      : _profileName(profile),
                ),
            ],
            onSelected: (userId) =>
                unawaited(_actions.apply(context, assigneeIds: [userId])),
          ),
        TasksBulkButton(
          key: const ValueKey('bulk_archive'),
          icon: Symbols.archive,
          label: context.l10n.tasksBulkArchive,
          isDestructive: true,
          onTap: ready.isBulkSaving
              ? null
              : () => unawaited(_actions.apply(context, archive: true)),
        ),
        TasksBulkMenu<String>(
          isLoading: ready.isBulkSaving,
          key: const ValueKey('bulk_entire_result'),
          icon: Symbols.select_all_rounded,
          label: context.l10n.tasksBulkEntireResult,
          options: [
            for (final status in ProjectTaskStatus.values)
              AppContextMenuOption<String>(
                value: 'status:${status.name}',
                label: TaskStatusVisualHelper.label(context, status),
                icon: TaskStatusVisualHelper.icon(status),
                iconColor: TaskStatusVisualHelper.color(status),
              ),
            for (final priority in TaskPriority.values)
              AppContextMenuOption<String>(
                value: 'priority:${priority.name}',
                label: TaskPriorityVisualHelper.label(context, priority),
                icon: TaskPriorityVisualHelper.icon(priority),
                iconColor: TaskPriorityVisualHelper.color(priority),
                separatorBefore: priority == TaskPriority.values.first,
              ),
            AppContextMenuOption<String>(
              value: 'due_today',
              label: context.l10n.tasksBulkDueDate,
              icon: Symbols.event_available,
              separatorBefore: true,
            ),
            AppContextMenuOption<String>(
              value: 'archive',
              label: context.l10n.tasksBulkArchive,
              icon: Symbols.archive,
              isDestructive: true,
            ),
          ],
          onSelected: (value) =>
              unawaited(_actions.applyEntireResult(context, value)),
        ),
      ],
    );
  }

  static String _profileName(ProjectMemberProfile profile) {
    final displayName = profile.displayName?.trim();
    return displayName?.isNotEmpty == true ? displayName! : '';
  }
}
