part of 'task_list_row.dart';

/// Rozszerzenie wiersza zadania renderujące listę komórek danych w zależności od układu kolumn.
extension _TaskListRowCellsExtension on TaskListRow {
  List<Widget> _buildRowCells(
    BuildContext context, {
    required VoidCallback openTask,
    required EligibleProfilesPageLoader loadEligibleProfilesPage,
  }) {
    if (columnReferences != null) {
      return [
        for (final ref in columnReferences!)
          switch (ref) {
            SystemColumnReference(:final column) => _TaskListCell(
              column: column,
              task: task,
              profiles: memberProfilesByUserId,
              milestones: milestones,
              onMilestoneChanged: onMilestoneChanged,
              onTitleChanged: onTitleChanged,
              onStatusChanged: onStatusChanged,
              onCustomStatusChanged: onCustomStatusChanged,
              onPriorityChanged: onPriorityChanged,
              onTaskTypeChanged: onTaskTypeChanged,
              onSystemMetricChanged: onSystemMetricChanged,
              onAssigneesChanged: onAssigneesChanged,
              onSearchEligibleProfiles: loadEligibleProfilesPage,
              onDueDateChanged: onDueDateChanged,
              onStartDateChanged: onStartDateChanged,
              onPinnedChanged: onPinnedChanged,
              onWatchingToggled: onWatchingToggled,
              onLabelsChanged: onLabelsChanged,
              onOpen: openTask,
              onDuplicate: onDuplicate,
              onCreateSubtask: onCreateSubtask,
              onArchive: onArchive,
              onRecurrenceToggled: onRecurrenceToggled,
              onRecurrenceConfigured: onRecurrenceConfigured,
              customFields: customFields,
              onCustomFieldChanged: onCustomFieldChanged,
              hierarchyDepth: hierarchyDepth,
              width:
                  columnWidthsById[ref.id] ??
                  columnWidths[column] ??
                  TaskListGrid.width(column),
            ),
            CustomFieldColumnReference(:final fieldId) => () {
              final field = customFields
                  .where((item) => item.id == fieldId)
                  .firstOrNull;
              if (field == null) return const SizedBox.shrink();
              return TaskCellCustomField(
                field: field,
                value: task.customFields
                    .where((item) => item.fieldId == field.id)
                    .firstOrNull
                    ?.value,
                profiles: memberProfilesByUserId,
                onChanged: onCustomFieldChanged,
                canManage: TaskPermissionHelper.canManageProject(
                  context,
                  memberProfiles: memberProfilesByUserId,
                ),
                onConfigureField: () => TaskListProjectSettingsLauncher.show(
                  context,
                  ProjectSettingsTab.customFields,
                ),
                width: columnWidthsById[ref.id] ?? TaskListGrid.customField,
              );
            }(),
          },
      ];
    }

    return [
      for (final column in columns)
        _TaskListCell(
          column: column,
          task: task,
          profiles: memberProfilesByUserId,
          milestones: milestones,
          onMilestoneChanged: onMilestoneChanged,
          onTitleChanged: onTitleChanged,
          onStatusChanged: onStatusChanged,
          onCustomStatusChanged: onCustomStatusChanged,
          onPriorityChanged: onPriorityChanged,
          onTaskTypeChanged: onTaskTypeChanged,
          onSystemMetricChanged: onSystemMetricChanged,
          onAssigneesChanged: onAssigneesChanged,
          onSearchEligibleProfiles: loadEligibleProfilesPage,
          onDueDateChanged: onDueDateChanged,
          onStartDateChanged: onStartDateChanged,
          onPinnedChanged: onPinnedChanged,
          onWatchingToggled: onWatchingToggled,
          onLabelsChanged: onLabelsChanged,
          onOpen: openTask,
          onDuplicate: onDuplicate,
          onCreateSubtask: onCreateSubtask,
          onArchive: onArchive,
          onRecurrenceToggled: onRecurrenceToggled,
          onRecurrenceConfigured: onRecurrenceConfigured,
          customFields: customFields,
          onCustomFieldChanged: onCustomFieldChanged,
          hierarchyDepth: hierarchyDepth,
          width:
              columnWidthsById['sys:${column.name}'] ??
              columnWidths[column] ??
              TaskListGrid.width(column),
        ),
      for (final field in customFields)
        TaskCellCustomField(
          field: field,
          value: task.customFields
              .where((item) => item.fieldId == field.id)
              .firstOrNull
              ?.value,
          profiles: memberProfilesByUserId,
          onChanged: onCustomFieldChanged,
          canManage: TaskPermissionHelper.canManageProject(
            context,
            memberProfiles: memberProfilesByUserId,
          ),
          onConfigureField: () => TaskListProjectSettingsLauncher.show(
            context,
            ProjectSettingsTab.customFields,
          ),
          width: columnWidthsById['cf:${field.id}'] ?? TaskListGrid.customField,
        ),
    ];
  }
}
