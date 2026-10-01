import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_assignee_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

export 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_assignee_picker.dart'
    show TaskAssigneePicker;

/// Akcja menu kontekstowego przypisania osób.
enum AssigneeMenuAction { setOwner, toggleCollaborator, clear }

/// Typ ładowania stron profili członków projektu.
/// Bezstanowy loader projektu, który zachowuje pełny wynik Either katalogu.
final class EligibleProfilesPageLoader {
  const EligibleProfilesPageLoader({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  });

  final ProjectMemberProfilesRepository repository;
  final String workspaceId;
  final String projectId;

  bool hasSameScopeAs(EligibleProfilesPageLoader other) =>
      identical(repository, other.repository) &&
      workspaceId == other.workspaceId &&
      projectId == other.projectId;

  Future<Either<ApiError, ProjectMemberProfilePage>> call({
    String? query,
    String? cursor,
  }) => repository.listProfilesPage(
    workspaceId: workspaceId,
    projectId: projectId,
    search: query,
    cursor: cursor,
  );
}

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
  final Future<bool> Function(List<String> userIds)? onChanged;
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
      TaskAssigneeColumnMode.owner => context.l10n.tasksAssigneeSetPrimary,
      TaskAssigneeColumnMode.collaborators =>
        context.l10n.tasksListCollaborators,
      TaskAssigneeColumnMode.all => context.l10n.taskDetailsAssignees,
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
                TaskAssigneePicker.show(
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
                                .map((a) => _resolveName(context, a.userId))
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

  String _resolveName(BuildContext context, String userId) {
    final profile = profiles[userId];
    return profile?.displayName?.trim().isNotEmpty == true
        ? profile!.displayName!.trim()
        : context.l10n.tasksAutomationsUnknownMember;
  }
}
