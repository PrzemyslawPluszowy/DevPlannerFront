import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:ready_next/workspaces/presentation/tasks/helpers/task_permission_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/custom_fields/task_cell_custom_field.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/metrics/task_cell_business_value.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/metrics/task_cell_complexity.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/metrics/task_cell_duration.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/metrics/task_cell_risk.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/metrics/task_cell_size.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_checklist.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_dates.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_labels.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_milestone.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_priority.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_status.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_task_type.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_title.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_watchers.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/header/task_list_column_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/rows/task_list_row_actions.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

part 'task_list_cell.part.dart';
part 'task_list_row_selection_cell.part.dart';
part 'task_list_row_cells.part.dart';

/// Pojedynczy wiersz zadania w tabeli listy zadań.
///
/// Obsługuje interakcje wiersza: zaznaczanie, drag & drop podzadań, menu
/// kontekstowe, skróty klawiaturowe oraz renderowanie poszczególnych komórek.
class TaskListRow extends StatelessWidget {
  const TaskListRow({
    required this.task,
    this.columns = defaultTaskListColumns,
    this.columnReferences,
    required this.memberProfilesByCoreUserId,
    super.key,
    this.onOpen,
    this.onDuplicate,
    this.onCreateSubtask,
    this.onToggleSubtasks,
    this.onStatusChanged,
    this.onCustomStatusChanged,
    this.onPriorityChanged,
    this.onTaskTypeChanged,
    this.onSystemMetricChanged,
    this.onAssigneesChanged,
    this.onDueDateChanged,
    this.onStartDateChanged,
    this.onArchive,
    this.onPinnedChanged,
    this.onWatchingToggled,
    this.onRecurrenceToggled,
    this.onRecurrenceConfigured,
    this.onLabelsChanged,
    this.onMilestoneChanged,
    this.milestones = const {},
    this.onDragStarted,
    this.onTaskDroppedAsSubtask,
    this.isSelected = false,
    this.onSelectionChanged,
    this.isExpanded = false,
    this.isSubtasksLoading = false,
    this.hierarchyDepth = 0,
    this.customFields = const [],
    this.onTitleChanged,
    this.showActions = true,
    this.height = 42,
    this.errorMessage,
    this.onCustomFieldChanged,
    this.columnWidths = const {},
    this.columnWidthsById = const {},
    this.focusNode,
  });

  final ProjectTaskListItemResponse task;
  final List<TaskSavedViewColumn> columns;
  final List<TaskColumnReference>? columnReferences;
  final Map<String, double> columnWidthsById;
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;
  final Future<bool> Function(String title)? onTitleChanged;
  final VoidCallback? onOpen;
  final Future<void> Function()? onDuplicate;
  final Future<void> Function()? onCreateSubtask;
  final VoidCallback? onToggleSubtasks;
  final Future<bool> Function(ProjectTaskStatus status)? onStatusChanged;
  final Future<bool> Function(String? customStatusId)? onCustomStatusChanged;
  final Future<bool> Function(TaskPriority priority)? onPriorityChanged;
  final Future<bool> Function(String taskType)? onTaskTypeChanged;
  final Future<bool> Function(TaskSavedViewColumn column, int? value)?
  onSystemMetricChanged;
  final Future<bool> Function(List<String> coreUserIds)? onAssigneesChanged;
  final Future<bool> Function(DateTime? dueAtUtc)? onDueDateChanged;
  final Future<bool> Function(DateTime? startAtUtc)? onStartDateChanged;
  final Future<bool> Function()? onArchive;
  final Future<bool> Function(bool isPinned)? onPinnedChanged;
  final Future<bool> Function()? onWatchingToggled;
  final Future<bool> Function()? onRecurrenceToggled;
  final Future<void> Function(Offset position)? onRecurrenceConfigured;
  final Future<bool> Function(List<String> labelIds)? onLabelsChanged;
  final Future<bool> Function(String? milestoneId)? onMilestoneChanged;
  final Map<String, MilestoneResponse> milestones;
  final VoidCallback? onDragStarted;
  final ValueChanged<ProjectTaskListItemResponse>? onTaskDroppedAsSubtask;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final bool isExpanded;
  final bool isSubtasksLoading;
  final int hierarchyDepth;
  final List<TaskCustomFieldResponse> customFields;
  final bool showActions;
  final double height;
  final String? errorMessage;
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged;
  final Map<TaskSavedViewColumn, double> columnWidths;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    Future<ProjectMemberProfilePage> loadEligibleProfilesPage({
      String? query,
      String? cursor,
    }) async {
      final pathParameters = GoRouterState.of(context).pathParameters;
      final workspaceId = pathParameters['workspaceId'] ?? '';
      final projectId = pathParameters['projectId'] ?? '';
      final result = await context
          .read<ProjectMemberProfilesRepository>()
          .listProfilesPage(
            workspaceId: workspaceId,
            projectId: projectId,
            search: query,
            cursor: cursor,
          );
      return result.fold(
        (_) => const ProjectMemberProfilePage(items: []),
        (page) => page,
      );
    }

    void openTask() {
      if (onOpen case final callback?) {
        callback();
        return;
      }
      final pathParameters = GoRouterState.of(context).pathParameters;
      final workspaceId = pathParameters['workspaceId'] ?? '';
      final projectId = pathParameters['projectId'] ?? '';
      context.go(
        '/workspaces/$workspaceId/projects/$projectId/tasks/${task.id}',
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) => unawaited(
        showTaskRowContextMenu(
          context,
          task: task,
          position: details.globalPosition,
          onOpen: openTask,
          onDuplicate: onDuplicate,
          onCreateSubtask: onCreateSubtask,
          onStatusChanged: onStatusChanged,
          onPriorityChanged: onPriorityChanged,
          onAssigneesChanged: onAssigneesChanged,
          onDueDateChanged: onDueDateChanged,
          onArchive: onArchive,
          onPinnedChanged: onPinnedChanged,
          onWatchingToggled: onWatchingToggled,
          onRecurrenceToggled: onRecurrenceToggled,
          onRecurrenceConfigured: onRecurrenceConfigured,
          profiles: memberProfilesByCoreUserId,
          customFields: customFields,
          onCustomFieldChanged: onCustomFieldChanged,
          searchEligibleProfiles: loadEligibleProfilesPage,
        ),
      ),
      child: LongPressDraggable<ProjectTaskListItemResponse>(
        data: task,
        onDragStarted: onDragStarted,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 300,
            child: Opacity(opacity: .88, child: Text(task.title)),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: .35,
          child: _buildRow(context, openTask, loadEligibleProfilesPage),
        ),
        child: _buildRow(context, openTask, loadEligibleProfilesPage),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    VoidCallback openTask,
    EligibleProfilesPageLoader loadEligibleProfilesPage,
  ) => FocusableActionDetector(
    focusNode: focusNode,
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): _ToggleTaskSelectionIntent(),
      SingleActivator(LogicalKeyboardKey.space, shift: true):
          _ToggleTaskSelectionRangeIntent(),
      SingleActivator(LogicalKeyboardKey.contextMenu): _OpenTaskMenuIntent(),
      SingleActivator(LogicalKeyboardKey.f10, shift: true):
          _OpenTaskMenuIntent(),
    },
    actions: <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (_) {
          openTask();
          return null;
        },
      ),
      _ToggleTaskSelectionIntent: CallbackAction<_ToggleTaskSelectionIntent>(
        onInvoke: (_) {
          onSelectionChanged?.call(false);
          return null;
        },
      ),
      _ToggleTaskSelectionRangeIntent:
          CallbackAction<_ToggleTaskSelectionRangeIntent>(
            onInvoke: (_) {
              onSelectionChanged?.call(true);
              return null;
            },
          ),
      _OpenTaskMenuIntent: CallbackAction<_OpenTaskMenuIntent>(
        onInvoke: (_) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            unawaited(
              showTaskRowContextMenu(
                context,
                task: task,
                position: box.localToGlobal(Offset(0, box.size.height)),
                onOpen: openTask,
                onDuplicate: onDuplicate,
                onCreateSubtask: onCreateSubtask,
                onStatusChanged: onStatusChanged,
                onPriorityChanged: onPriorityChanged,
                onAssigneesChanged: onAssigneesChanged,
                onDueDateChanged: onDueDateChanged,
                onArchive: onArchive,
                onPinnedChanged: onPinnedChanged,
                onWatchingToggled: onWatchingToggled,
                onRecurrenceToggled: onRecurrenceToggled,
                onRecurrenceConfigured: onRecurrenceConfigured,
                profiles: memberProfilesByCoreUserId,
                customFields: customFields,
                onCustomFieldChanged: onCustomFieldChanged,
                searchEligibleProfiles: loadEligibleProfilesPage,
              ),
            );
          }
          return null;
        },
      ),
    },
    child: Semantics(
      container: true,
      button: true,
      label:
          '${task.key}, ${task.title}, ${TaskStatusVisualHelper.label(context, task.status)}, ${TaskPriorityVisualHelper.label(context, task.priority)}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.colors.outlineVariant),
          ),
        ),
        child: InkWell(
          onTap: openTask,
          onSecondaryTapDown: (details) {
            unawaited(
              showTaskRowContextMenu(
                context,
                task: task,
                position: details.globalPosition,
                onOpen: openTask,
                onDuplicate: onDuplicate,
                onCreateSubtask: onCreateSubtask,
                onStatusChanged: onStatusChanged,
                onPriorityChanged: onPriorityChanged,
                onAssigneesChanged: onAssigneesChanged,
                onDueDateChanged: onDueDateChanged,
                onArchive: onArchive,
                onPinnedChanged: onPinnedChanged,
                onWatchingToggled: onWatchingToggled,
                onRecurrenceToggled: onRecurrenceToggled,
                onRecurrenceConfigured: onRecurrenceConfigured,
                profiles: memberProfilesByCoreUserId,
                customFields: customFields,
                onCustomFieldChanged: onCustomFieldChanged,
                searchEligibleProfiles: loadEligibleProfilesPage,
              ),
            );
          },
          child: SizedBox(
            height: height,
            child: Row(
              children: [
                _TaskListRowSelectionCell(
                  task: task,
                  isSelected: isSelected,
                  onSelectionChanged: onSelectionChanged,
                  isExpanded: isExpanded,
                  isSubtasksLoading: isSubtasksLoading,
                  onToggleSubtasks: onToggleSubtasks,
                  onTaskDroppedAsSubtask: onTaskDroppedAsSubtask,
                ),
                ..._buildRowCells(
                  context,
                  openTask: openTask,
                  loadEligibleProfilesPage: loadEligibleProfilesPage,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ToggleTaskSelectionIntent extends Intent {
  const _ToggleTaskSelectionIntent();
}

class _ToggleTaskSelectionRangeIntent extends Intent {
  const _ToggleTaskSelectionRangeIntent();
}

class _OpenTaskMenuIntent extends Intent {
  const _OpenTaskMenuIntent();
}

void _openProjectSettings(BuildContext context, ProjectSettingsTab tab) {
  final pathParameters = GoRouterState.of(context).pathParameters;
  final workspaceId = pathParameters['workspaceId'] ?? '';
  final projectId = pathParameters['projectId'] ?? '';
  if (workspaceId.isEmpty || projectId.isEmpty) return;

  final project = ProjectListItem(
    id: projectId,
    workspaceId: workspaceId,
    name: '',
    sortPosition: 0,
  );
  unawaited(
    showProjectSettingsModal(
      context: context,
      project: project,
      initialTab: tab,
    ),
  );
}
