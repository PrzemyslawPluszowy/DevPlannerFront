import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/tasks/helpers/task_permission_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/metrics/task_cell_business_value.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/metrics/task_cell_complexity.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/metrics/task_cell_duration.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/metrics/task_cell_risk.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/metrics/task_cell_size.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_checklist.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_dates.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_key.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_labels.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_milestone.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_task_type.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_title.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_watchers.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_column_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_project_settings_launcher.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Dyspozytor komórek tabeli według wybranej kolumny.
class TaskListCell extends StatelessWidget {
  const TaskListCell({
    required this.column,
    required this.task,
    required this.profiles,
    required this.hierarchyDepth,
    required this.width,
    super.key,
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
    this.onMilestoneChanged,
    this.milestones = const {},
    this.onSearchEligibleProfiles,
    this.onOpen,
    this.onDuplicate,
    this.onCreateSubtask,
    this.onArchive,
    this.onRecurrenceToggled,
    this.onRecurrenceConfigured,
    this.customFields = const [],
    this.onCustomFieldChanged,
  });

  final TaskSavedViewColumn column;
  final ProjectTaskListItemResponse task;
  final Map<String, ProjectMemberProfile> profiles;
  final Map<String, MilestoneResponse> milestones;
  final int hierarchyDepth;
  final double width;
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
  final Future<bool> Function(String? milestoneId)? onMilestoneChanged;
  final EligibleProfilesPageLoader? onSearchEligibleProfiles;
  final VoidCallback? onOpen;
  final Future<void> Function()? onDuplicate;
  final Future<void> Function()? onCreateSubtask;
  final Future<bool> Function()? onArchive;
  final Future<bool> Function()? onRecurrenceToggled;
  final Future<void> Function(Offset position)? onRecurrenceConfigured;
  final List<TaskCustomFieldResponse> customFields;
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged;

  @override
  Widget build(BuildContext context) {
    final canManage = TaskPermissionHelper.canManageProject(
      context,
      memberProfiles: profiles,
    );

    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: switch (column) {
        TaskSavedViewColumn.key => TaskCellKey(task: task),
        TaskSavedViewColumn.title => TaskCellTitle(
          task: task,
          hierarchyDepth: hierarchyDepth,
          onTitleChanged: onTitleChanged,
          onPinnedChanged: onPinnedChanged,
          onWatchingToggled: onWatchingToggled,
          onOpen: onOpen,
          onDuplicate: onDuplicate,
          onCreateSubtask: onCreateSubtask,
          onArchive: onArchive,
          onRecurrenceToggled: onRecurrenceToggled,
          onRecurrenceConfigured: onRecurrenceConfigured,
          profiles: profiles,
          customFields: customFields,
          onCustomFieldChanged: onCustomFieldChanged,
          onSearchEligibleProfiles: onSearchEligibleProfiles,
          onStatusChanged: onStatusChanged,
          onPriorityChanged: onPriorityChanged,
          onAssigneesChanged: onAssigneesChanged,
          onDueDateChanged: onDueDateChanged,
        ),
        TaskSavedViewColumn.status => TaskCellStatus(
          status: task.status,
          onChanged: onStatusChanged,
          canManage: canManage,
          onConfigureWorkflow: () => TaskListProjectSettingsLauncher.show(
            context,
            ProjectSettingsTab.workflow,
          ),
        ),
        TaskSavedViewColumn.customStatus => TaskCellCustomStatus(
          task: task,
          onChanged: onCustomStatusChanged,
          canManage: canManage,
          onConfigureWorkflow: () => TaskListProjectSettingsLauncher.show(
            context,
            ProjectSettingsTab.workflow,
          ),
        ),
        TaskSavedViewColumn.priority => TaskCellPriority(
          priority: task.priority,
          onChanged: onPriorityChanged,
        ),
        TaskSavedViewColumn.assignees => TaskCellAssignees(
          task: task,
          profiles: profiles,
          onChanged: onAssigneesChanged,
          searchEligibleProfiles: onSearchEligibleProfiles,
        ),
        TaskSavedViewColumn.owner => TaskCellAssignees(
          task: task,
          profiles: profiles,
          mode: TaskAssigneeColumnMode.owner,
          onChanged: onAssigneesChanged,
          searchEligibleProfiles: onSearchEligibleProfiles,
        ),
        TaskSavedViewColumn.collaborators => TaskCellAssignees(
          task: task,
          profiles: profiles,
          mode: TaskAssigneeColumnMode.collaborators,
          onChanged: onAssigneesChanged,
          searchEligibleProfiles: onSearchEligibleProfiles,
        ),
        TaskSavedViewColumn.labels => TaskCellLabels(
          task: task,
          onChanged: onLabelsChanged,
        ),
        TaskSavedViewColumn.milestone => TaskCellMilestone(
          task: task,
          milestones: milestones,
          onChanged: onMilestoneChanged,
        ),
        TaskSavedViewColumn.dueAtUtc => TaskCellDate(
          dateTime: task.dueAtUtc,
          icon: Symbols.event,
          tooltip: context.l10n.tasksListDueDate,
          onChanged: onDueDateChanged,
        ),
        TaskSavedViewColumn.startAtUtc => TaskCellDate(
          dateTime: task.startAtUtc,
          icon: Symbols.calendar_today,
          tooltip: context.l10n.tasksListDueDate,
          onChanged: onStartDateChanged,
        ),
        TaskSavedViewColumn.checklistProgress => TaskCellChecklist(task: task),
        TaskSavedViewColumn.updatedAtUtc => TaskCellReadOnlyDate(
          dateTime: task.updatedAtUtc,
        ),
        TaskSavedViewColumn.createdAtUtc => TaskCellReadOnlyDate(
          dateTime: task.createdAtUtc,
        ),
        TaskSavedViewColumn.watchers => TaskCellWatchers(
          task: task,
          onWatchingToggled: onWatchingToggled,
        ),
        TaskSavedViewColumn.size => TaskCellSize(
          size: task.size,
          onChanged: onSystemMetricChanged == null
              ? null
              : (val) => onSystemMetricChanged!(column, val),
        ),
        TaskSavedViewColumn.complexity => TaskCellComplexity(
          complexity: task.complexity,
          onChanged: onSystemMetricChanged == null
              ? null
              : (val) => onSystemMetricChanged!(column, val),
        ),
        TaskSavedViewColumn.risk => TaskCellRisk(
          risk: task.risk,
          onChanged: onSystemMetricChanged == null
              ? null
              : (val) => onSystemMetricChanged!(column, val),
        ),
        TaskSavedViewColumn.businessValue => TaskCellBusinessValue(
          value: task.businessValue,
          onChanged: onSystemMetricChanged == null
              ? null
              : (val) => onSystemMetricChanged!(column, val),
        ),
        TaskSavedViewColumn.estimatedMinutes => TaskCellDuration(
          minutes: task.estimatedMinutes,
          title: TaskListColumnHelper.label(context, column),
          onChanged: onSystemMetricChanged == null
              ? null
              : (val) => onSystemMetricChanged!(column, val),
        ),
        TaskSavedViewColumn.actualMinutes => TaskCellDuration(
          minutes: task.actualMinutes,
          title: TaskListColumnHelper.label(context, column),
          isEstimated: false,
        ),
        TaskSavedViewColumn.taskType => TaskCellTaskType(
          taskType: task.taskType,
          onChanged: onTaskTypeChanged,
          canManage: canManage,
          onConfigureTypes: () => TaskListProjectSettingsLauncher.show(
            context,
            ProjectSettingsTab.general,
          ),
        ),
      },
    );
  }
}
