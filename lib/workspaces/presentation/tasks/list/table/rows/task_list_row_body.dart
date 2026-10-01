import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row_actions.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row_cells.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row_selection_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Obsługa wskaźnika, klawiatury i przeciągania wiersza zadania.
final class TaskListRowBody extends StatelessWidget {
  const TaskListRowBody({
    required this.row,
    required this.searchEligibleProfiles,
    super.key,
  });

  final TaskListRow row;
  final EligibleProfilesPageLoader? searchEligibleProfiles;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onSecondaryTapDown: (details) => _onSecondaryTapDown(context, details),
    child: LongPressDraggable<ProjectTaskListItemResponse>(
      data: row.task,
      onDragStarted: row.onDragStarted,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 300,
          child: Opacity(opacity: .88, child: Text(row.task.title)),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: .35,
        child: TaskListRowInteraction(body: this, attachFocus: false),
      ),
      child: TaskListRowInteraction(body: this),
    ),
  );

  Object? _activateTask(BuildContext context) {
    _openTask(context);
    return null;
  }

  Object? _toggleSelection(_ToggleTaskSelectionIntent _) {
    row.onSelectionChanged?.call(false);
    return null;
  }

  Object? _toggleSelectionRange(_ToggleTaskSelectionRangeIntent _) {
    row.onSelectionChanged?.call(true);
    return null;
  }

  Object? _openMenuFromKeyboard(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      _showTaskMenu(context, box.localToGlobal(Offset(0, box.size.height)));
    }
    return null;
  }

  void _onSecondaryTapDown(BuildContext context, TapDownDetails details) {
    _showTaskMenu(context, details.globalPosition);
  }

  void _showTaskMenu(BuildContext context, Offset position) {
    unawaited(
      TaskRowContextMenu.show(
        context,
        task: row.task,
        position: position,
        onOpen: () => _openTask(context),
        onDuplicate: row.onDuplicate,
        onCreateSubtask: row.onCreateSubtask,
        onStatusChanged: row.onStatusChanged,
        onPriorityChanged: row.onPriorityChanged,
        onAssigneesChanged: row.onAssigneesChanged,
        onDueDateChanged: row.onDueDateChanged,
        onArchive: row.onArchive,
        onPinnedChanged: row.onPinnedChanged,
        onWatchingToggled: row.onWatchingToggled,
        onRecurrenceToggled: row.onRecurrenceToggled,
        onRecurrenceConfigured: row.onRecurrenceConfigured,
        profiles: row.memberProfilesByUserId,
        customFields: row.customFields,
        onCustomFieldChanged: row.onCustomFieldChanged,
        searchEligibleProfiles: searchEligibleProfiles,
      ),
    );
  }

  void _openTask(BuildContext context) {
    if (row.onOpen case final callback?) {
      callback();
      return;
    }
    final pathParameters = GoRouterState.of(context).pathParameters;
    final currentLocation = GoRouterState.of(context).uri;
    unawaited(
      context.plannerNavigation.goToTask(
        workspaceId: pathParameters['workspaceId'] ?? '',
        projectId: pathParameters['projectId'] ?? '',
        taskId: row.task.id,
        currentLocation: currentLocation,
        source: TaskDetailOpenSource.taskList,
      ),
    );
  }
}

/// Osobny widget interakcji i komórek; kopia podczas drag nie współdzieli focusu.
final class TaskListRowInteraction extends StatelessWidget {
  const TaskListRowInteraction({
    required this.body,
    this.attachFocus = true,
    super.key,
  });

  final TaskListRowBody body;
  final bool attachFocus;

  TaskListRow get row => body.row;
  EligibleProfilesPageLoader? get searchEligibleProfiles =>
      body.searchEligibleProfiles;

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
    focusNode: attachFocus ? row.focusNode : null,
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
        onInvoke: (_) => body._activateTask(context),
      ),
      _ToggleTaskSelectionIntent: CallbackAction<_ToggleTaskSelectionIntent>(
        onInvoke: body._toggleSelection,
      ),
      _ToggleTaskSelectionRangeIntent:
          CallbackAction<_ToggleTaskSelectionRangeIntent>(
            onInvoke: body._toggleSelectionRange,
          ),
      _OpenTaskMenuIntent: CallbackAction<_OpenTaskMenuIntent>(
        onInvoke: (_) => body._openMenuFromKeyboard(context),
      ),
    },
    child: Semantics(
      container: true,
      button: true,
      label:
          '${row.task.key}, ${row.task.title}, ${TaskStatusVisualHelper.label(context, row.task.status)}, ${TaskPriorityVisualHelper.label(context, row.task.priority)}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.colors.outlineVariant),
          ),
        ),
        child: InkWell(
          onTap: () => body._openTask(context),
          onSecondaryTapDown: (details) =>
              body._onSecondaryTapDown(context, details),
          child: SizedBox(
            height: row.height,
            child: Row(
              children: [
                TaskListRowSelectionCell(
                  task: row.task,
                  isSelected: row.isSelected,
                  onSelectionChanged: row.onSelectionChanged,
                  isExpanded: row.isExpanded,
                  isSubtasksLoading: row.isSubtasksLoading,
                  onToggleSubtasks: row.onToggleSubtasks,
                  onTaskDroppedAsSubtask: row.onTaskDroppedAsSubtask,
                ),
                TaskListRowCells(
                  data: TaskListRowCellData(
                    task: row.task,
                    columns: row.columns,
                    columnReferences: row.columnReferences,
                    profiles: row.memberProfilesByUserId,
                    milestones: row.milestones,
                    hierarchyDepth: row.hierarchyDepth,
                    customFields: row.customFields,
                    columnWidths: row.columnWidths,
                    columnWidthsById: row.columnWidthsById,
                    onMilestoneChanged: row.onMilestoneChanged,
                    onTitleChanged: row.onTitleChanged,
                    onStatusChanged: row.onStatusChanged,
                    onCustomStatusChanged: row.onCustomStatusChanged,
                    onPriorityChanged: row.onPriorityChanged,
                    onTaskTypeChanged: row.onTaskTypeChanged,
                    onSystemMetricChanged: row.onSystemMetricChanged,
                    onAssigneesChanged: row.onAssigneesChanged,
                    onDueDateChanged: row.onDueDateChanged,
                    onStartDateChanged: row.onStartDateChanged,
                    onPinnedChanged: row.onPinnedChanged,
                    onWatchingToggled: row.onWatchingToggled,
                    onLabelsChanged: row.onLabelsChanged,
                    onDuplicate: row.onDuplicate,
                    onCreateSubtask: row.onCreateSubtask,
                    onArchive: row.onArchive,
                    onRecurrenceToggled: row.onRecurrenceToggled,
                    onRecurrenceConfigured: row.onRecurrenceConfigured,
                    onCustomFieldChanged: row.onCustomFieldChanged,
                  ),
                  openTask: () => body._openTask(context),
                  loadEligibleProfilesPage: searchEligibleProfiles,
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
