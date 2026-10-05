import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_command_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_command_bar_columns_button.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_command_bar_labels.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_member_avatar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wiersz poleceń Listy: filtry, sortowanie, grupowanie i kolumny.
///
/// Kontrolki korzystają ze wspólnego menu kontekstowego i tokenów gęstości, więc
/// Lista i Kanban mają jeden rząd poleceń, a nie trzy różne systemy menu.
class TaskListCommandBar extends StatelessWidget {
  const TaskListCommandBar({
    required this.listState,
    required this.preferencesState,
    required this.memberProfiles,
    required this.hasCustomWorkflow,
    super.key,
  });

  final ProjectTasksListState listState;
  final TaskListPreferencesState preferencesState;
  final Map<String, ProjectMemberProfile> memberProfiles;
  final bool hasCustomWorkflow;

  /// Wartość pozycji „wszystkie”: `select` zwraca `null` także po zamknięciu
  /// menu bez wyboru, więc potrzebujemy własnego znacznika.
  static const String _all = '__tasks_filter_all__';
  static const String _unassigned = '__tasks_filter_unassigned__';

  ProjectTasksListReady? get _ready => listState is ProjectTasksListReady
      ? listState as ProjectTasksListReady
      : null;

  TaskListPreferencesReady? get _preferences =>
      preferencesState is TaskListPreferencesReady
      ? preferencesState as TaskListPreferencesReady
      : null;

  bool get _hasActiveFilter => _ready?.hasActiveFilters ?? false;

  @override
  Widget build(BuildContext context) {
    final ready = _ready;
    if (ready == null) return const SizedBox.shrink();
    final tasksTheme = context.tasksTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TasksCommandMenu(
            key: const ValueKey('command_filter_status'),
            icon: Symbols.track_changes,
            label: context.l10n.tasksListStatus,
            activeLabel: ready.status == null
                ? null
                : TaskStatusVisualHelper.label(context, ready.status!),
            options: [
              AppContextMenuOption<String>(
                value: _all,
                label: context.l10n.tasksListAll,
                selected: ready.status == null,
              ),
              for (final status in ProjectTaskStatus.values)
                AppContextMenuOption<String>(
                  value: status.name,
                  label: TaskStatusVisualHelper.label(context, status),
                  icon: TaskStatusVisualHelper.icon(status),
                  iconColor: TaskStatusVisualHelper.color(status),
                  selected: ready.status == status,
                ),
            ],
            onSelected: (value) => unawaited(_applyStatus(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_filter_priority'),
            icon: Symbols.flag,
            label: context.l10n.tasksListPriority,
            activeLabel: ready.priority == null
                ? null
                : TaskPriorityVisualHelper.label(context, ready.priority!),
            options: [
              AppContextMenuOption<String>(
                value: _all,
                label: context.l10n.tasksListAll,
                selected: ready.priority == null,
              ),
              for (final priority in TaskPriority.values)
                AppContextMenuOption<String>(
                  value: priority.name,
                  label: TaskPriorityVisualHelper.label(context, priority),
                  icon: TaskPriorityVisualHelper.icon(priority),
                  iconColor: TaskPriorityVisualHelper.color(priority),
                  selected: ready.priority == priority,
                ),
            ],
            onSelected: (value) => unawaited(_applyPriority(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_filter_assignee'),
            icon: Symbols.people_alt,
            label: TaskListCommandBarLabels.assignee(
              context,
              unassignedOnly: ready.unassignedOnly,
              userId: ready.assigneeUserId,
              memberProfiles: memberProfiles,
            ),
            leading: _avatarFor(ready.assigneeUserId),
            options: [
              AppContextMenuOption<String>(
                value: _all,
                label: context.l10n.tasksBoardFilterAllPeople,
                selected: ready.assigneeUserId == null && !ready.unassignedOnly,
              ),
              AppContextMenuOption<String>(
                value: _unassigned,
                label: context.l10n.tasksSavedViewsUnassigned,
                selected: ready.unassignedOnly,
              ),
              for (final profile in _sortedProfiles(context))
                AppContextMenuOption<String>(
                  value: profile.userId,
                  label: TaskListCommandBarLabels.profileName(context, profile),
                  leading: TaskListMemberAvatar(profile: profile),
                  selected: ready.assigneeUserId == profile.userId,
                ),
            ],
            onSelected: (value) => unawaited(_applyAssignee(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_filter_involvement'),
            icon: Symbols.person_pin,
            label: context.l10n.myTasksInvolvement,
            activeLabel: ready.myInvolvement == null
                ? null
                : TaskListCommandBarLabels.involvement(
                    context,
                    ready.myInvolvement!,
                  ),
            options: [
              AppContextMenuOption<String>(
                value: _all,
                label: context.l10n.tasksListAll,
                selected: ready.myInvolvement == null,
              ),
              for (final involvement in const [
                TaskInvolvementFilter.primaryAssignee,
                TaskInvolvementFilter.collaborator,
                TaskInvolvementFilter.watcher,
              ])
                AppContextMenuOption<String>(
                  value: involvement.name,
                  label: TaskListCommandBarLabels.involvement(
                    context,
                    involvement,
                  ),
                  selected: ready.myInvolvement == involvement,
                ),
            ],
            onSelected: (value) => unawaited(_applyInvolvement(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandButton(
            key: const ValueKey('command_filter_pinned'),
            icon: Symbols.star,
            label: context.l10n.tasksListPinnedByMe,
            isActive: ready.pinnedOnly,
            onTap: () => unawaited(
              context.read<ProjectTasksListCubit>().load(
                pinnedOnly: !ready.pinnedOnly,
              ),
            ),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_sort'),
            icon: Symbols.swap_vert_rounded,
            label: context.l10n.tasksListSort,
            activeLabel: TaskListCommandBarLabels.sortField(
              context,
              _preferences?.sortField,
            ),
            options: [
              for (final field in TaskSavedViewSortField.values)
                AppContextMenuOption<String>(
                  value: field.name,
                  label: TaskListCommandBarLabels.sortField(context, field)!,
                  selected: _preferences?.sortField == field,
                ),
            ],
            onSelected: (value) => unawaited(_applySort(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_sort_direction'),
            icon: Symbols.swap_horiz_rounded,
            label: context.l10n.tasksListSortDirection,
            activeLabel: TaskListCommandBarLabels.sortDirection(
              context,
              _preferences?.sortDirection,
            ),
            options: [
              for (final direction in TaskSavedViewSortDirection.values)
                AppContextMenuOption<String>(
                  value: direction.name,
                  label: direction == TaskSavedViewSortDirection.ascending
                      ? context.l10n.tasksSavedViewsAscending
                      : context.l10n.tasksSavedViewsDescending,
                  selected: _preferences?.sortDirection == direction,
                ),
            ],
            onSelected: (value) => unawaited(_applyDirection(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_group'),
            icon: Symbols.account_tree,
            label: context.l10n.tasksListGroupBy,
            activeLabel: switch (_preferences?.groupBy) {
              final TaskSavedViewGroupBy groupBy =>
                TaskListCommandBarLabels.groupBy(
                  context,
                  groupBy,
                ),
              _ => null,
            },
            options: [
              for (final groupBy in _availableGroupBy)
                AppContextMenuOption<String>(
                  value: groupBy.name,
                  label: TaskListCommandBarLabels.groupBy(context, groupBy),
                  selected: _preferences?.groupBy == groupBy,
                ),
            ],
            onSelected: (value) => unawaited(_applyGroupBy(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TaskListCommandBarColumnsButton(
            key: const ValueKey('command_columns'),
            memberProfiles: memberProfiles,
          ),
          if (_hasActiveFilter) ...[
            SizedBox(width: tasksTheme.controlGap),
            TasksCommandButton(
              key: const ValueKey('command_clear_filters'),
              icon: Symbols.filter_alt_off_rounded,
              label: context.l10n.tasksListClearAllFilters,
              onTap: () => unawaited(_clearFilters(context)),
            ),
          ],
        ],
      ),
    );
  }

  List<TaskSavedViewGroupBy> get _availableGroupBy => [
    TaskSavedViewGroupBy.none,
    TaskSavedViewGroupBy.status,
    if (hasCustomWorkflow) TaskSavedViewGroupBy.customStatus,
    TaskSavedViewGroupBy.priority,
    TaskSavedViewGroupBy.assignee,
  ];

  List<ProjectMemberProfile> _sortedProfiles(BuildContext context) =>
      memberProfiles.values.toList(growable: false)..sort(
        (left, right) =>
            TaskListCommandBarLabels.profileName(
              context,
              left,
            ).compareTo(
              TaskListCommandBarLabels.profileName(context, right),
            ),
      );

  Widget? _avatarFor(String? userId) => userId == null
      ? null
      : TaskListMemberAvatar(profile: memberProfiles[userId]);

  Future<void> _applyStatus(BuildContext context, String value) async {
    final cubit = context.read<ProjectTasksListCubit>();
    if (value == _all) {
      await cubit.load(clearStatus: true);
      return;
    }
    await cubit.load(
      status: ProjectTaskStatus.values.firstWhere((s) => s.name == value),
    );
  }

  Future<void> _applyPriority(BuildContext context, String value) async {
    final cubit = context.read<ProjectTasksListCubit>();
    if (value == _all) {
      await cubit.load(clearPriority: true);
      return;
    }
    await cubit.load(
      priority: TaskPriority.values.firstWhere((p) => p.name == value),
    );
  }

  Future<void> _applyAssignee(BuildContext context, String value) async {
    final cubit = context.read<ProjectTasksListCubit>();
    if (value == _all) {
      await cubit.load(clearAssigneeUserId: true, unassignedOnly: false);
      return;
    }
    if (value == _unassigned) {
      await cubit.load(clearAssigneeUserId: true, unassignedOnly: true);
      return;
    }
    await cubit.load(assigneeUserId: value, unassignedOnly: false);
  }

  Future<void> _applyInvolvement(BuildContext context, String value) async {
    final cubit = context.read<ProjectTasksListCubit>();
    if (value == _all) {
      await cubit.load(clearMyInvolvement: true);
      return;
    }
    await cubit.load(
      myInvolvement: TaskInvolvementFilter.values.firstWhere(
        (i) => i.name == value,
      ),
    );
  }

  Future<void> _applySort(BuildContext context, String value) async {
    final cubit = context.read<TaskListPreferencesCubit>();
    final current = _preferences;
    if (current == null) return;
    await cubit.setSort(
      TaskSavedViewSortField.values.firstWhere((f) => f.name == value),
      current.sortDirection,
    );
  }

  Future<void> _applyDirection(BuildContext context, String value) async {
    final cubit = context.read<TaskListPreferencesCubit>();
    final current = _preferences;
    if (current == null) return;
    await cubit.setSort(
      current.sortField,
      TaskSavedViewSortDirection.values.firstWhere((d) => d.name == value),
    );
  }

  Future<void> _applyGroupBy(BuildContext context, String value) async {
    await context.read<TaskListPreferencesCubit>().setGroupBy(
      TaskSavedViewGroupBy.values.firstWhere((g) => g.name == value),
    );
  }

  Future<void> _clearFilters(BuildContext context) =>
      context.read<ProjectTasksListCubit>().clearFilters();
}
