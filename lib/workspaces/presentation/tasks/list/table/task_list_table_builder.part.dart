part of 'task_list_table.dart';

/// Metody pomocnicze do budowania struktury wierszy i wierszy zadań tabeli.
extension _TaskListTableBuilderExtension on _TaskListTableState {
  List<_ListRow> _groupedRows(
    ProjectTasksListReady state,
    TaskSavedViewGroupBy groupBy, {
    TaskSavedViewSortField? sortField,
    TaskSavedViewSortDirection? sortDirection,
  }) {
    if (_lastStateForGroupedRows == state &&
        _lastGroupByForRows == groupBy &&
        _lastSortFieldForRows == sortField &&
        _lastSortDirectionForRows == sortDirection &&
        _cachedGroupedRows != null) {
      return _cachedGroupedRows!;
    }

    final groups = [...state.groups]
      ..sort((left, right) {
        final leftStatus = TaskListGrouping.statusForGroup(left.key);
        final rightStatus = TaskListGrouping.statusForGroup(right.key);
        if (leftStatus == null || rightStatus == null) {
          return left.position.compareTo(right.position);
        }
        return TaskListGrouping.statusOrder(leftStatus).compareTo(
          TaskListGrouping.statusOrder(rightStatus),
        );
      });
    final isFlat = groupBy == TaskSavedViewGroupBy.none;
    final List<_ListRow> rows;
    if (isFlat) {
      final allItems = [for (final group in groups) ...group.items];
      final flatGroupKey = groups.firstOrNull?.key ?? 'flat';
      rows = [
        _ListGroupTableHeader(flatGroupKey),
        for (final task in _sortGroupItems(
          allItems,
          sortField: sortField,
          sortDirection: sortDirection,
        )) ...[
          _ListTaskRow(
            task,
            groupKey: flatGroupKey,
            isExpanded: state.expandedTaskIds.contains(task.id),
            isSubtasksLoading: state.loadingSubtaskParentIds.contains(task.id),
          ),
          if (state.expandedTaskIds.contains(task.id))
            _ListSubtaskTable(
              parent: task,
              groupKey: flatGroupKey,
              subtasks: state.subtasksByParentId[task.id] ?? const [],
              hasMore: state.nextSubtaskCursorByParentId[task.id] != null,
            ),
        ],
        for (final group in groups)
          if (group.nextCursor != null) _ListGroupLoadMore(group.key),
        if (TaskListGrouping.canCreateRootTaskInGroup(groupBy, flatGroupKey))
          _ListGroupInlineCreate(flatGroupKey),
      ];
    } else {
      rows = [
        for (final group in groups) ...[
          _ListGroupHeader(
            id: group.key,
            label: group.displayName,
            count: group.totalCount,
            status: TaskListGrouping.statusForGroup(group.key),
          ),
          _ListGroupTableHeader(group.key),
          for (final task in _sortGroupItems(
            group.items,
            sortField: sortField,
            sortDirection: sortDirection,
          )) ...[
            _ListTaskRow(
              task,
              groupKey: group.key,
              isExpanded: state.expandedTaskIds.contains(task.id),
              isSubtasksLoading: state.loadingSubtaskParentIds.contains(
                task.id,
              ),
            ),
            if (state.expandedTaskIds.contains(task.id))
              _ListSubtaskTable(
                parent: task,
                groupKey: group.key,
                subtasks: state.subtasksByParentId[task.id] ?? const [],
                hasMore: state.nextSubtaskCursorByParentId[task.id] != null,
              ),
          ],
          if (group.nextCursor != null) _ListGroupLoadMore(group.key),
          if (TaskListGrouping.canCreateRootTaskInGroup(groupBy, group.key))
            _ListGroupInlineCreate(group.key),
        ],
      ];
    }

    _lastStateForGroupedRows = state;
    _lastGroupByForRows = groupBy;
    _lastSortFieldForRows = sortField;
    _lastSortDirectionForRows = sortDirection;
    _cachedGroupedRows = rows;
    return rows;
  }

  List<_ListRow> _visibleRows(List<_ListRow> rows, Set<String> collapsedIds) {
    final visible = <_ListRow>[];
    var isCollapsed = false;
    for (final row in rows) {
      if (row case _ListGroupHeader(:final id)) {
        isCollapsed = collapsedIds.contains(id);
        visible.add(row);
      } else if (!isCollapsed) {
        visible.add(row);
      }
    }
    return visible;
  }

  TaskListRow _buildTaskRow(
    BuildContext context, {
    required ProjectTaskListItemResponse task,
    required List<TaskSavedViewColumn> columns,
    List<TaskColumnReference>? columnReferences,
    required List<TaskCustomFieldResponse> customFields,
    Map<String, MilestoneResponse> milestones = const {},
    bool isExpanded = false,
    bool isSubtasksLoading = false,
    double rowHeight = 42,
    Map<TaskSavedViewColumn, double> columnWidths = const {},
    Map<String, double> columnWidthsById = const {},
    int? hierarchyDepth,
  }) {
    final cubit = context.read<ProjectTasksListCubit>();
    final listState = cubit.state;
    final readyState = listState is ProjectTasksListReady ? listState : null;
    return TaskListRow(
      key: ValueKey('task-row-${task.id}'),
      task: task,
      columns: columns,
      columnReferences: columnReferences,
      customFields: customFields,
      milestones: milestones,
      height: rowHeight,
      columnWidths: columnWidths,
      columnWidthsById: columnWidthsById,
      errorMessage: readyState?.taskErrorsByTaskId[task.id],
      isSelected: readyState?.selectedTaskIds.contains(task.id) ?? false,
      onSelectionChanged: (range) =>
          cubit.toggleSelection(task.id, range: range),
      onTaskDroppedAsSubtask: task.parentTaskId == null
          ? (dragged) => unawaited(
              cubit.moveTask(
                task: dragged,
                targetGroupKey: TaskListGrouping.groupKeyForTask(task),
                parentTaskId: task.id,
              ),
            )
          : null,
      onCustomFieldChanged: (field, value) =>
          cubit.updateCustomField(task: task, fieldId: field.id, value: value),
      isExpanded: isExpanded,
      isSubtasksLoading: isSubtasksLoading,
      hierarchyDepth: hierarchyDepth ?? (task.parentTaskId == null ? 0 : 1),
      onToggleSubtasks: () => unawaited(cubit.toggleSubtasks(task)),
      onCreateSubtask: task.parentTaskId == null
          ? () => _beginInlineSubtaskCreate(task)
          : null,
      onDuplicate: () async {
        final copySuffix = context.l10n.tasksListTaskCopySuffix;
        await cubit.createRootTask(
          title: '${task.title} $copySuffix',
          status: task.status,
          priority: task.priority,
        );
      },
      onTitleChanged: (title) => cubit.updateTitle(task, title),
      onStatusChanged: (status) => cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          status: status,
          expectedVersion: task.version,
        ),
      ),
      onPriorityChanged: (priority) => cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          priority: priority,
          expectedVersion: task.version,
        ),
      ),
      onTaskTypeChanged: (taskType) => cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          taskType: taskType,
          expectedVersion: task.version,
        ),
      ),
      onRecurrenceToggled: task.recurrence == null
          ? null
          : () => cubit.toggleRecurrence(task),
      onRecurrenceConfigured: (position) =>
          TaskRecurrenceContextEditorLauncher.show(
            context,
            globalPosition: position,
            repository: context.read<TaskRecurrenceRepository>(),
            workspaceId: cubit.workspaceId,
            projectId: cubit.projectId,
            taskId: task.id,
            taskVersion: task.version,
            hasRecurrence: task.recurrence != null,
            onSaved: (mutation) =>
                cubit.applyRecurrenceMutation(task, mutation),
          ),
      onSystemMetricChanged: (column, value) => cubit.updateListItem(
        task: task,
        payload: switch (column) {
          TaskSavedViewColumn.size => UpdateTaskListItemPayload(
            size: value,
            clearSize: value == null,
            expectedVersion: task.version,
          ),
          TaskSavedViewColumn.complexity => UpdateTaskListItemPayload(
            complexity: value,
            clearComplexity: value == null,
            expectedVersion: task.version,
          ),
          TaskSavedViewColumn.risk => UpdateTaskListItemPayload(
            risk: value,
            clearRisk: value == null,
            expectedVersion: task.version,
          ),
          TaskSavedViewColumn.businessValue => UpdateTaskListItemPayload(
            businessValue: value,
            clearBusinessValue: value == null,
            expectedVersion: task.version,
          ),
          TaskSavedViewColumn.estimatedMinutes => UpdateTaskListItemPayload(
            estimatedMinutes: value,
            clearEstimatedMinutes: value == null,
            expectedVersion: task.version,
          ),
          _ => throw ArgumentError.value(column, 'column'),
        },
      ),
      onAssigneesChanged: (userIds) =>
          cubit.replaceAssigneesForLoadedTask(task, userIds),
      onDueDateChanged: (dueAtUtc) => cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          dueAtUtc: dueAtUtc,
          clearDueAtUtc: dueAtUtc == null,
          expectedVersion: task.version,
        ),
      ),
      onStartDateChanged: (startAtUtc) => cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          startAtUtc: startAtUtc,
          clearStartAtUtc: startAtUtc == null,
          expectedVersion: task.version,
        ),
      ),
      onArchive: () => cubit.archiveLoadedTask(task),
      onPinnedChanged: (isPinned) =>
          cubit.setPinnedForLoadedTask(task, isPinned),
      onWatchingToggled: () => cubit.toggleWatchingForLoadedTask(task),
      onLabelsChanged: (labelIds) =>
          cubit.replaceLabelsForLoadedTask(task, labelIds),
      onMilestoneChanged: (milestoneId) => cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          milestoneId: milestoneId,
          clearMilestone: milestoneId == null,
          expectedVersion: task.version,
        ),
      ),
      memberProfilesByUserId: widget.memberProfilesByUserId,
    );
  }

  /// Porządkuje zadania w obrębie grupy tabeli.
  ///
  /// Dla sortowania ręcznego (`position` lub brak aktywnego sortowania kolumny)
  /// bezwzględnie zachowuje kanoniczną kolejność z backendu / D&D (`items`),
  /// wynosząc jedynie zadania przypięte (`isPinned`) na szczyt grupy.
  /// Dla pozostałych pól stosuje stabilne sortowanie z zachowaniem relacji przy remisie.
  List<ProjectTaskListItemResponse> _sortGroupItems(
    List<ProjectTaskListItemResponse> items, {
    required TaskSavedViewSortField? sortField,
    required TaskSavedViewSortDirection? sortDirection,
  }) {
    final isManualSort =
        sortField == null || sortField == TaskSavedViewSortField.position;
    if (isManualSort) {
      final pinned = <ProjectTaskListItemResponse>[];
      final unpinned = <ProjectTaskListItemResponse>[];
      for (final item in items) {
        if (item.isPinned) {
          pinned.add(item);
        } else {
          unpinned.add(item);
        }
      }
      return [...pinned, ...unpinned];
    }

    final factor = sortDirection == TaskSavedViewSortDirection.descending
        ? -1
        : 1;
    final sorted = [...items];
    sorted.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      final cmp = switch (sortField) {
        TaskSavedViewSortField.priority => a.priority.index.compareTo(
          b.priority.index,
        ),
        TaskSavedViewSortField.title => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        TaskSavedViewSortField.dueAtUtc => () {
          if (a.dueAtUtc == null && b.dueAtUtc == null) return 0;
          if (a.dueAtUtc == null) return 1;
          if (b.dueAtUtc == null) return -1;
          return a.dueAtUtc!.compareTo(b.dueAtUtc!);
        }(),
        TaskSavedViewSortField.updatedAtUtc => a.updatedAtUtc.compareTo(
          b.updatedAtUtc,
        ),
        TaskSavedViewSortField.position => 0,
      };
      if (cmp != 0) return cmp * factor;
      return a.number.compareTo(b.number);
    });
    return sorted;
  }
}
