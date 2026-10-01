import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/tasks/helpers/task_permission_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/custom_fields/task_cell_custom_field.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_cell.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_project_settings_launcher.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';

/// Immutable input for rendering the row's ordered cell collection.
final class TaskListRowCellData {
  const TaskListRowCellData({
    required this.task,
    required this.columns,
    required this.columnReferences,
    required this.profiles,
    required this.milestones,
    required this.hierarchyDepth,
    required this.customFields,
    required this.columnWidths,
    required this.columnWidthsById,
    this.onMilestoneChanged,
    this.onTitleChanged,
    this.onStatusChanged,
    this.onCustomStatusChanged,
    this.onPriorityChanged,
    this.onTaskTypeChanged,
    this.onSystemMetricChanged,
    this.onAssigneesChanged,
    this.onDueDateChanged,
    this.onStartDateChanged,
    this.onPinnedChanged,
    this.onWatchingToggled,
    this.onLabelsChanged,
    this.onDuplicate,
    this.onCreateSubtask,
    this.onArchive,
    this.onRecurrenceToggled,
    this.onRecurrenceConfigured,
    this.onCustomFieldChanged,
  });

  final ProjectTaskListItemResponse task;
  final List<TaskSavedViewColumn> columns;
  final List<TaskColumnReference>? columnReferences;
  final Map<String, ProjectMemberProfile> profiles;
  final Map<String, MilestoneResponse> milestones;
  final int hierarchyDepth;
  final List<TaskCustomFieldResponse> customFields;
  final Map<TaskSavedViewColumn, double> columnWidths;
  final Map<String, double> columnWidthsById;
  final Future<bool> Function(String title)? onTitleChanged;
  final Future<bool> Function(ProjectTaskStatus status)? onStatusChanged;
  final Future<bool> Function(String? customStatusId)? onCustomStatusChanged;
  final Future<bool> Function(TaskPriority priority)? onPriorityChanged;
  final Future<bool> Function(String taskType)? onTaskTypeChanged;
  final Future<bool> Function(TaskSavedViewColumn column, int? value)?
  onSystemMetricChanged;
  final Future<bool> Function(List<String> userIds)? onAssigneesChanged;
  final Future<bool> Function(DateTime? dueAtUtc)? onDueDateChanged;
  final Future<bool> Function(DateTime? startAtUtc)? onStartDateChanged;
  final Future<bool> Function(bool isPinned)? onPinnedChanged;
  final Future<bool> Function()? onWatchingToggled;
  final Future<bool> Function(List<String> labelIds)? onLabelsChanged;
  final Future<void> Function()? onDuplicate;
  final Future<void> Function()? onCreateSubtask;
  final Future<bool> Function()? onArchive;
  final Future<bool> Function()? onRecurrenceToggled;
  final Future<void> Function(Offset position)? onRecurrenceConfigured;
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged;
  final Future<bool> Function(String? milestoneId)? onMilestoneChanged;
}

/// Renders the row's cells in the configured column order.
final class TaskListRowCells extends StatelessWidget {
  const TaskListRowCells({
    required this.data,
    required this.openTask,
    required this.loadEligibleProfilesPage,
    super.key,
  });

  final TaskListRowCellData data;
  final VoidCallback openTask;
  final EligibleProfilesPageLoader? loadEligibleProfilesPage;

  @override
  Widget build(BuildContext context) {
    final row = data;
    if (row.columnReferences != null) {
      return Row(
        children: [
          for (final ref in row.columnReferences!)
            switch (ref) {
              SystemColumnReference(:final column) => TaskListCell(
                column: column,
                task: row.task,
                profiles: row.profiles,
                milestones: row.milestones,
                onMilestoneChanged: row.onMilestoneChanged,
                onTitleChanged: row.onTitleChanged,
                onStatusChanged: row.onStatusChanged,
                onCustomStatusChanged: row.onCustomStatusChanged,
                onPriorityChanged: row.onPriorityChanged,
                onTaskTypeChanged: row.onTaskTypeChanged,
                onSystemMetricChanged: row.onSystemMetricChanged,
                onAssigneesChanged: row.onAssigneesChanged,
                onSearchEligibleProfiles: loadEligibleProfilesPage,
                onDueDateChanged: row.onDueDateChanged,
                onStartDateChanged: row.onStartDateChanged,
                onPinnedChanged: row.onPinnedChanged,
                onWatchingToggled: row.onWatchingToggled,
                onLabelsChanged: row.onLabelsChanged,
                onOpen: openTask,
                onDuplicate: row.onDuplicate,
                onCreateSubtask: row.onCreateSubtask,
                onArchive: row.onArchive,
                onRecurrenceToggled: row.onRecurrenceToggled,
                onRecurrenceConfigured: row.onRecurrenceConfigured,
                customFields: row.customFields,
                onCustomFieldChanged: row.onCustomFieldChanged,
                hierarchyDepth: row.hierarchyDepth,
                width:
                    row.columnWidthsById[ref.id] ??
                    row.columnWidths[column] ??
                    TaskListGrid.width(column),
              ),
              CustomFieldColumnReference(:final fieldId) =>
                TaskListCustomFieldCell(
                  field: row.customFields
                      .where((item) => item.id == fieldId)
                      .firstOrNull,
                  data: row,
                  width:
                      row.columnWidthsById[ref.id] ?? TaskListGrid.customField,
                ),
            },
        ],
      );
    }

    return Row(
      children: [
        for (final column in row.columns)
          TaskListCell(
            column: column,
            task: row.task,
            profiles: row.profiles,
            milestones: row.milestones,
            onMilestoneChanged: row.onMilestoneChanged,
            onTitleChanged: row.onTitleChanged,
            onStatusChanged: row.onStatusChanged,
            onCustomStatusChanged: row.onCustomStatusChanged,
            onPriorityChanged: row.onPriorityChanged,
            onTaskTypeChanged: row.onTaskTypeChanged,
            onSystemMetricChanged: row.onSystemMetricChanged,
            onAssigneesChanged: row.onAssigneesChanged,
            onSearchEligibleProfiles: loadEligibleProfilesPage,
            onDueDateChanged: row.onDueDateChanged,
            onStartDateChanged: row.onStartDateChanged,
            onPinnedChanged: row.onPinnedChanged,
            onWatchingToggled: row.onWatchingToggled,
            onLabelsChanged: row.onLabelsChanged,
            onOpen: openTask,
            onDuplicate: row.onDuplicate,
            onCreateSubtask: row.onCreateSubtask,
            onArchive: row.onArchive,
            onRecurrenceToggled: row.onRecurrenceToggled,
            onRecurrenceConfigured: row.onRecurrenceConfigured,
            customFields: row.customFields,
            onCustomFieldChanged: row.onCustomFieldChanged,
            hierarchyDepth: row.hierarchyDepth,
            width:
                row.columnWidthsById['sys:${column.name}'] ??
                row.columnWidths[column] ??
                TaskListGrid.width(column),
          ),
        for (final field in row.customFields)
          TaskListCustomFieldCell(
            field: field,
            data: row,
            width:
                row.columnWidthsById['cf:${field.id}'] ??
                TaskListGrid.customField,
          ),
      ],
    );
  }
}

final class TaskListCustomFieldCell extends StatelessWidget {
  const TaskListCustomFieldCell({
    required this.field,
    required this.data,
    required this.width,
    super.key,
  });

  final TaskCustomFieldResponse? field;
  final TaskListRowCellData data;
  final double width;

  @override
  Widget build(BuildContext context) {
    final currentField = field;
    if (currentField == null) return const SizedBox.shrink();
    return TaskCellCustomField(
      field: currentField,
      value: data.task.customFields
          .where((item) => item.fieldId == currentField.id)
          .firstOrNull
          ?.value,
      profiles: data.profiles,
      onChanged: data.onCustomFieldChanged,
      canManage: TaskPermissionHelper.canManageProject(
        context,
        memberProfiles: data.profiles,
      ),
      onConfigureField: () => TaskListProjectSettingsLauncher.show(
        context,
        ProjectSettingsTab.customFields,
      ),
      width: width,
    );
  }
}
