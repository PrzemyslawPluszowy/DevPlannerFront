import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_command_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/helpers/task_permission_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart';
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

  bool get _hasActiveFilter {
    final ready = _ready;
    return ready != null &&
        (ready.status != null ||
            ready.priority != null ||
            ready.assigneeUserId != null ||
            ready.unassignedOnly ||
            ready.myInvolvement != null ||
            ready.pinnedOnly);
  }

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
            label: _assigneeLabel(ready),
            leading: _avatarFor(ready.assigneeUserId),
            options: [
              AppContextMenuOption<String>(
                value: _all,
                label: 'Wszystkie osoby',
                selected: ready.assigneeUserId == null && !ready.unassignedOnly,
              ),
              AppContextMenuOption<String>(
                value: _unassigned,
                label: 'Nieprzypisane',
                selected: ready.unassignedOnly,
              ),
              for (final profile in _sortedProfiles)
                AppContextMenuOption<String>(
                  value: profile.userId,
                  label: _profileName(profile),
                  leading: _ProfileAvatar(profile: profile),
                  selected: ready.assigneeUserId == profile.userId,
                ),
            ],
            onSelected: (value) => unawaited(_applyAssignee(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_filter_involvement'),
            icon: Symbols.person_pin,
            label: 'Mój udział',
            activeLabel: ready.myInvolvement == null
                ? null
                : _involvementLabel(ready.myInvolvement!),
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
                  label: _involvementLabel(involvement),
                  selected: ready.myInvolvement == involvement,
                ),
            ],
            onSelected: (value) => unawaited(_applyInvolvement(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandButton(
            key: const ValueKey('command_filter_pinned'),
            icon: Symbols.push_pin,
            label: 'Przypięte',
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
            activeLabel: _sortLabel,
            options: [
              for (final field in TaskSavedViewSortField.values)
                AppContextMenuOption<String>(
                  value: field.name,
                  label: _sortFieldLabel(field),
                  selected: _preferences?.sortField == field,
                ),
            ],
            onSelected: (value) => unawaited(_applySort(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('command_sort_direction'),
            icon: Symbols.swap_horiz_rounded,
            label: 'Kierunek',
            activeLabel: _directionLabel,
            options: [
              for (final direction in TaskSavedViewSortDirection.values)
                AppContextMenuOption<String>(
                  value: direction.name,
                  label: direction == TaskSavedViewSortDirection.ascending
                      ? 'Rosnąco'
                      : 'Malejąco',
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
              final TaskSavedViewGroupBy groupBy => _groupByLabel(groupBy),
              _ => null,
            },
            options: [
              for (final groupBy in _availableGroupBy)
                AppContextMenuOption<String>(
                  value: groupBy.name,
                  label: _groupByLabel(groupBy),
                  selected: _preferences?.groupBy == groupBy,
                ),
            ],
            onSelected: (value) => unawaited(_applyGroupBy(context, value)),
          ),
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandButton(
            key: const ValueKey('command_columns'),
            icon: Symbols.view_column_rounded,
            label: context.l10n.tasksListColumnsTitle,
            onTap: () => unawaited(_openColumns(context)),
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

  List<ProjectMemberProfile> get _sortedProfiles =>
      memberProfiles.values.toList(growable: false)..sort(
        (left, right) => _profileName(left).compareTo(_profileName(right)),
      );

  String _assigneeLabel(ProjectTasksListReady ready) {
    if (ready.unassignedOnly) return 'Nieprzypisane';
    final userId = ready.assigneeUserId;
    if (userId == null) return 'Osoba';
    return _profileName(memberProfiles[userId]);
  }

  Widget? _avatarFor(String? userId) =>
      userId == null ? null : _ProfileAvatar(profile: memberProfiles[userId]);

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

  Future<void> _clearFilters(BuildContext context) async {
    await context.read<ProjectTasksListCubit>().load(
      clearStatus: true,
      clearPriority: true,
      clearAssigneeUserId: true,
      clearMyInvolvement: true,
      unassignedOnly: false,
      pinnedOnly: false,
    );
  }

  Future<void> _openColumns(BuildContext context) async {
    final cubit = context.read<TaskListPreferencesCubit>();
    final canManage = TaskPermissionHelper.canManageProject(
      context,
      memberProfiles: memberProfiles,
    );
    // Definicje pól pobieramy dopiero przy otwarciu arkusza, żeby nie dublować
    // zapytania, które tabela wykonuje dla komórek.
    final fields = await context
        .read<TaskMetadataRepository>()
        .listCustomFields(
          workspaceId: cubit.workspaceId,
          projectId: cubit.projectId,
        )
        .then(
          (result) => result.fold(
            (_) => const <TaskCustomFieldResponse>[],
            (fields) => fields,
          ),
        );
    if (!context.mounted) return;
    await TaskListColumnsSheet.show(
      context,
      cubit: cubit,
      customFields: fields,
      canManage: canManage,
    );
  }

  String? get _sortLabel {
    final sortField = _preferences?.sortField;
    return sortField == null ? null : _sortFieldLabel(sortField);
  }

  String? get _directionLabel => switch (_preferences?.sortDirection) {
    TaskSavedViewSortDirection.ascending => 'Rosnąco',
    TaskSavedViewSortDirection.descending => 'Malejąco',
    _ => null,
  };

  static String _sortFieldLabel(TaskSavedViewSortField field) =>
      switch (field) {
        TaskSavedViewSortField.position => 'Kolejność ręczna',
        TaskSavedViewSortField.updatedAtUtc => 'Ostatnia zmiana',
        TaskSavedViewSortField.dueAtUtc => 'Termin',
        TaskSavedViewSortField.priority => 'Priorytet',
        TaskSavedViewSortField.title => 'Tytuł',
      };

  static String _groupByLabel(TaskSavedViewGroupBy groupBy) =>
      switch (groupBy) {
        TaskSavedViewGroupBy.none => 'Bez grupowania',
        TaskSavedViewGroupBy.status => 'Status',
        TaskSavedViewGroupBy.customStatus => 'Status workflow',
        TaskSavedViewGroupBy.priority => 'Priorytet',
        TaskSavedViewGroupBy.assignee => 'Osoba',
      };

  static String _involvementLabel(TaskInvolvementFilter involvement) =>
      switch (involvement) {
        TaskInvolvementFilter.primaryAssignee => 'Właściciel',
        TaskInvolvementFilter.collaborator => 'Współpracownik',
        TaskInvolvementFilter.watcher => 'Obserwator',
        TaskInvolvementFilter.assignee => 'Wykonawca',
        TaskInvolvementFilter.any => 'Dowolny udział',
      };

  static String _profileName(ProjectMemberProfile? profile) {
    final displayName = profile?.displayName?.trim();
    return displayName?.isNotEmpty == true
        ? displayName!
        : 'Nieznany użytkownik';
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.profile});

  final ProjectMemberProfile? profile;

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    if (profile == null) {
      return Icon(
        Symbols.account_circle,
        size: 16,
        color: context.colors.onSurfaceVariant,
      );
    }
    final avatarUrl = profile.avatarUrl?.trim();
    final label = profile.displayName?.trim().isNotEmpty == true
        ? profile.displayName!.trim()
        : 'U';
    return CircleAvatar(
      radius: 9,
      foregroundImage: avatarUrl?.isNotEmpty == true
          ? NetworkImage(avatarUrl!)
          : null,
      child: avatarUrl?.isNotEmpty == true
          ? null
          : Text(
              label.characters.first.toUpperCase(),
              style: context.tasksTheme.metaText.copyWith(height: 1),
            ),
    );
  }
}
