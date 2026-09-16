import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_assignee_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

export 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_assignee_picker.dart'
    show showTaskAssigneeEditor;

/// Akcja menu kontekstowego przypisania osób.
enum AssigneeMenuAction { setOwner, toggleCollaborator, clear }

/// Typ ładowania stron profili członków projektu.
typedef EligibleProfilesPageLoader = Future<ProjectMemberProfilePage> Function({
  String? query,
  String? cursor,
});

/// Tryb wyświetlania osób w kolumnie przypisania.
enum TaskAssigneeColumnMode { all, owner, collaborators }

/// Komórka osób przypisanych do zadania w tabeli.
class TaskCellAssignees extends StatelessWidget {
  const TaskCellAssignees({
    required this.task,
    required this.profiles,
    super.key,
    this.mode = TaskAssigneeColumnMode.all,
    this.onChanged,
    this.searchEligibleProfiles,
  });

  final ProjectTaskListItemResponse task;
  final Map<String, ProjectMemberProfile> profiles;
  final TaskAssigneeColumnMode mode;
  final Future<bool> Function(List<String> coreUserIds)? onChanged;
  final EligibleProfilesPageLoader? searchEligibleProfiles;

  @override
  Widget build(BuildContext context) {
    final filtered = switch (mode) {
      TaskAssigneeColumnMode.owner =>
        task.assignees.where((item) => item.isPrimary).toList(growable: false),
      TaskAssigneeColumnMode.collaborators =>
        task.assignees.where((item) => !item.isPrimary).toList(growable: false),
      TaskAssigneeColumnMode.all => task.assignees,
    };

    final initialAction = switch (mode) {
      TaskAssigneeColumnMode.owner => AssigneeMenuAction.setOwner,
      TaskAssigneeColumnMode.collaborators =>
        AssigneeMenuAction.toggleCollaborator,
      TaskAssigneeColumnMode.all => null,
    };

    final tooltip = switch (mode) {
      TaskAssigneeColumnMode.owner => 'Ustaw właściciela',
      TaskAssigneeColumnMode.collaborators => 'Dodaj współpracownika',
      TaskAssigneeColumnMode.all => 'Przypisz osoby',
    };

    return Builder(
      builder: (cellContext) => InkWell(
        mouseCursor: onChanged != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        borderRadius: .circular(4),
        onTap: onChanged == null
            ? null
            : () => unawaited(
                showTaskAssigneeEditor(
                  cellContext,
                  assignees: task.assignees,
                  profiles: profiles,
                  initialAction: initialAction,
                  onSave: onChanged!,
                  searchEligibleProfiles: searchEligibleProfiles,
                ),
              ),
        child: SizedBox(
          width: TaskListGrid.assignee,
          child: Padding(
            padding: const .symmetric(horizontal: 10),
            child: Align(
              alignment: .centerLeft,
              child: filtered.isEmpty
                  ? TaskCellEmptyPlaceholder(
                      icon: Symbols.person_add_rounded,
                      tooltip: onChanged != null ? tooltip : null,
                      isInteractive: onChanged != null,
                    )
                  : Row(
                      mainAxisSize: .min,
                      children: [
                        const Icon(Symbols.person_rounded, size: 15),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            filtered
                                .map((a) => _resolveName(a.coreUserId))
                                .join(', '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.labelMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  String _resolveName(String coreUserId) {
    final profile = profiles[coreUserId];
    return profile?.displayName?.trim().isNotEmpty == true
        ? profile!.displayName!.trim()
        : 'Nieznany użytkownik';
  }
}
