import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';

/// Pasek filtrów listy zadań (status, priorytet, przypisane osoby, udział, przypięte).
class TaskListFilters extends StatelessWidget {
  const TaskListFilters({
    required this.state,
    required this.memberProfiles,
    this.onOpenColumnSettings,
    this.canManage = false,
    super.key,
  });

  final ProjectTasksListReady state;
  final Map<String, ProjectMemberProfile> memberProfiles;
  final VoidCallback? onOpenColumnSettings;
  final bool canManage;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      _FilterMenu<ProjectTaskStatus>(
        value: state.status,
        icon: Symbols.track_changes,
        label: context.l10n.tasksListStatus,
        values: ProjectTaskStatus.values,
        itemLabel: (status) => TaskStatusVisualHelper.label(context, status),
        onSelected: (status) => unawaited(
          context.read<ProjectTasksListCubit>().load(
            status: status,
            clearStatus: status == null,
          ),
        ),
      ),
      _FilterMenu<TaskPriority>(
        value: state.priority,
        icon: Symbols.flag,
        label: context.l10n.tasksListPriority,
        values: TaskPriority.values,
        itemLabel: (priority) =>
            TaskPriorityVisualHelper.label(context, priority),
        onSelected: (priority) => unawaited(
          context.read<ProjectTasksListCubit>().load(
            priority: priority,
            clearPriority: priority == null,
          ),
        ),
      ),
      _PeopleFilter(
        selectedCoreUserId: state.assigneeCoreUserId,
        unassignedOnly: state.unassignedOnly,
        profiles: memberProfiles,
      ),
      _FilterMenu<TaskInvolvementFilter>(
        value: state.myInvolvement,
        icon: Symbols.person_pin,
        label: 'Mój udział',
        values: const [
          TaskInvolvementFilter.primaryAssignee,
          TaskInvolvementFilter.collaborator,
          TaskInvolvementFilter.watcher,
        ],
        itemLabel: _involvementLabel,
        onSelected: (involvement) => unawaited(
          context.read<ProjectTasksListCubit>().load(
            myInvolvement: involvement,
            clearMyInvolvement: involvement == null,
          ),
        ),
      ),
      FilterChip(
        avatar: Icon(
          Symbols.push_pin,
          size: 18,
          color: state.pinnedOnly
              ? context.colors.primary
              : context.colors.onSurfaceVariant,
        ),
        label: const Text('Przypięte'),
        selected: state.pinnedOnly,
        onSelected: (selected) => unawaited(
          context.read<ProjectTasksListCubit>().load(pinnedOnly: selected),
        ),
      ),
      if (onOpenColumnSettings != null)
        TextButton.icon(
          icon: Icon(
            Symbols.view_column_rounded,
            size: 16,
            color: context.colors.primary,
          ),
          label: Text(
            context.l10n.tasksListColumnsTitle,
            style: context.text.labelMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: context.colors.primaryContainer.withValues(
              alpha: 0.35,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: context.colors.primary.withValues(alpha: 0.35),
                width: 0.8,
              ),
            ),
            padding: const .symmetric(horizontal: 10, vertical: 6),
            visualDensity: VisualDensity.compact,
          ),
          onPressed: onOpenColumnSettings,
        ),
    ],
  );

  static String _involvementLabel(TaskInvolvementFilter involvement) =>
      switch (involvement) {
        TaskInvolvementFilter.primaryAssignee => 'Właściciel',
        TaskInvolvementFilter.collaborator => 'Współpracownik',
        TaskInvolvementFilter.watcher => 'Obserwator',
        TaskInvolvementFilter.assignee => 'Wykonawca',
        TaskInvolvementFilter.any => 'Dowolny udział',
      };
}

class _PeopleFilter extends StatelessWidget {
  const _PeopleFilter({
    required this.selectedCoreUserId,
    required this.unassignedOnly,
    required this.profiles,
  });

  static const _all = '__tasks-filter-all__';
  static const _unassigned = '__tasks-filter-unassigned__';

  final String? selectedCoreUserId;
  final bool unassignedOnly;
  final Map<String, ProjectMemberProfile> profiles;

  @override
  Widget build(BuildContext context) {
    final selected = selectedCoreUserId == null
        ? null
        : profiles[selectedCoreUserId];
    final entries = profiles.values.toList(
      growable: false,
    )..sort((left, right) => _profileName(left).compareTo(_profileName(right)));
    final label = unassignedOnly
        ? 'Nieprzypisane'
        : selected == null
        ? 'Osoba'
        : _profileName(selected);

    return PopupMenuButton<String>(
      tooltip: 'Filtruj po przypisanej osobie',
      onSelected: (value) {
        final cubit = context.read<ProjectTasksListCubit>();
        if (value == _all) {
          unawaited(
            cubit.load(
              clearAssigneeCoreUserId: true,
              unassignedOnly: false,
            ),
          );
        } else if (value == _unassigned) {
          unawaited(
            cubit.load(
              clearAssigneeCoreUserId: true,
              unassignedOnly: true,
            ),
          );
        } else {
          unawaited(
            cubit.load(
              assigneeCoreUserId: value,
              unassignedOnly: false,
            ),
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: _all, child: Text('Wszystkie osoby')),
        const PopupMenuItem(value: _unassigned, child: Text('Nieprzypisane')),
        if (entries.isNotEmpty) const PopupMenuDivider(),
        for (final profile in entries)
          PopupMenuItem(
            value: profile.coreUserId,
            child: Row(
              children: [
                _FilterProfileAvatar(profile: profile),
                const SizedBox(width: 8),
                Text(_profileName(profile)),
              ],
            ),
          ),
      ],
      child: Chip(
        avatar: selected == null
            ? const Icon(Symbols.people_alt, size: 18)
            : _FilterProfileAvatar(profile: selected),
        label: Text(label),
      ),
    );
  }

  static String _profileName(ProjectMemberProfile profile) {
    final displayName = profile.displayName?.trim();
    return displayName?.isNotEmpty == true
        ? displayName!
        : 'Nieznany użytkownik';
  }
}

class _FilterProfileAvatar extends StatelessWidget {
  const _FilterProfileAvatar({required this.profile});

  final ProjectMemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl?.trim();
    final label = profile.displayName?.trim().isNotEmpty == true
        ? profile.displayName!.trim()
        : 'U';
    return CircleAvatar(
      radius: 11,
      foregroundImage: avatarUrl?.isNotEmpty == true
          ? NetworkImage(avatarUrl!)
          : null,
      child: avatarUrl?.isNotEmpty == true
          ? null
          : Text(label.characters.first.toUpperCase()),
    );
  }
}

class _FilterMenu<T> extends StatelessWidget {
  const _FilterMenu({
    required this.value,
    required this.icon,
    required this.label,
    required this.values,
    required this.itemLabel,
    required this.onSelected,
  });

  final T? value;
  final IconData icon;
  final String label;
  final List<T> values;
  final String Function(T value) itemLabel;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<T?>(
    onSelected: onSelected,
    itemBuilder: (context) => [
      PopupMenuItem<T?>(child: Text(context.l10n.tasksListAll)),
      for (final item in values)
        PopupMenuItem<T?>(value: item, child: Text(itemLabel(item))),
    ],
    child: Chip(
      avatar: Icon(icon, size: 18),
      label: Text(value == null ? label : itemLabel(value as T)),
    ),
  );
}

/// Widok błędu ładowania listy zadań z przyciskiem ponowienia.
class TaskListFailureView extends StatelessWidget {
  const TaskListFailureView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: OutlinedButton.icon(
      onPressed: () => unawaited(context.read<ProjectTasksListCubit>().load()),
      icon: const Icon(Symbols.refresh_rounded),
      label: Text(message),
    ),
  );
}
