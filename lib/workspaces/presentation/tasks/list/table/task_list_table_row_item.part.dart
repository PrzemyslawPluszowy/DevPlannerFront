part of 'task_list_table.dart';

/// Rozszerzenie odpowiedzialne za budowanie pojedynczych wierszy różnego typu (grupy, zadania, subtaski, inline-create).
extension _TaskListTableRowItemExtension on _TaskListTableState {
  Widget _buildRowItem(
    BuildContext context, {
    required ProjectTasksListReady state,
    required _ListRow row,
    required List<TaskSavedViewColumn> visibleColumns,
    required List<TaskColumnReference>? effectiveColumnRefs,
    required List<TaskCustomFieldResponse> customFields,
    required Map<String, MilestoneResponse> milestones,
    required bool canMoveBetweenGroups,
    required TaskListPreferencesReady? resolvedPrefState,
    required TaskListPreferencesCubit? resolvedPrefCubit,
    required VoidCallback openColumnSettings,
  }) {
    return switch (row) {
      _ListGroupHeader(
        :final id,
        :final label,
        :final count,
        :final status,
      ) =>
        TaskListGroupRow(
          label: label,
          count: count,
          status: status,
          isCollapsed: _collapsedGroupIds.contains(id),
          onToggle: () => updateState(() {
            if (!_collapsedGroupIds.add(id)) {
              _collapsedGroupIds.remove(id);
            }
          }),
          onTaskDropped: !canMoveBetweenGroups
              ? null
              : (task) {
                  final group = state.groups
                      .where((item) => item.key == id)
                      .firstOrNull;
                  final previous = group?.items
                      .where((item) => item.id != task.id)
                      .lastOrNull;
                  unawaited(
                    context.read<ProjectTasksListCubit>().moveTask(
                      task: task,
                      targetGroupKey: id,
                      previousTaskId: previous?.id,
                    ),
                  );
                },
        ),
      _ListGroupTableHeader(:final groupKey) => TaskListTableHeader(
        columnReferences: effectiveColumnRefs,
        columns: visibleColumns,
        customFields: customFields,
        columnWidths: _columnWidths,
        columnWidthsById: _columnWidthsById,
        onColumnResizeStart: _onColumnResizeStart,
        onColumnResizeUpdate: _onColumnResizeUpdate,
        onColumnResizeEnd: _onColumnResizeEnd,
        onColumnWidthDelta: _resizeColumn,
        onColumnWidthDeltaById: _resizeColumnById,
        activeSortField: resolvedPrefState?.sortField,
        sortDirection: resolvedPrefState?.sortDirection,
        onSortField: (field) => resolvedPrefCubit?.cycleSort(field),
        onOpenColumnSettings: resolvedPrefCubit != null
            ? openColumnSettings
            : null,
        onReorderColumns: resolvedPrefCubit?.reorderColumns,
        allSelected: context
            .read<ProjectTasksListCubit>()
            .isLoadedGroupSelected(groupKey),
        selectionTooltip: context.l10n.tasksSelectLoadedGroup,
        onToggleAll: (selected) => context
            .read<ProjectTasksListCubit>()
            .setLoadedGroupSelected(groupKey, selected: selected),
      ),
      _ListTaskRow(
        :final task,
        :final groupKey,
        :final isExpanded,
        :final isSubtasksLoading,
      ) =>
        DragTarget<ProjectTaskListItemResponse>(
          onWillAcceptWithDetails: (details) => details.data.id != task.id,
          onAcceptWithDetails: (details) {
            unawaited(
              context.read<ProjectTasksListCubit>().moveTask(
                task: details.data,
                targetGroupKey: groupKey,
                nextTaskId: task.id,
              ),
            );
          },
          builder: (context, candidates, _) => DecoratedBox(
            decoration: BoxDecoration(
              border: candidates.isEmpty
                  ? null
                  : Border(
                      top: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
            ),
            child: _buildTaskRow(
              context,
              task: task,
              columns: visibleColumns,
              columnReferences: effectiveColumnRefs,
              customFields: customFields,
              milestones: milestones,
              isExpanded: isExpanded,
              isSubtasksLoading: isSubtasksLoading,
              columnWidths: _columnWidths,
              columnWidthsById: _columnWidthsById,
            ),
          ),
        ),
      _ListSubtaskTable(
        :final parent,
        :final subtasks,
        :final hasMore,
        :final groupKey,
      ) =>
        TaskListSubtaskTable(
          key: ValueKey('subtask-table-${parent.id}'),
          parent: parent,
          groupKey: groupKey,
          subtasks: subtasks,
          hasMore: hasMore,
          columns: visibleColumns,
          columnReferences: effectiveColumnRefs,
          columnWidths: _columnWidths,
          columnWidthsById: _columnWidthsById,
          onColumnResizeStart: _onColumnResizeStart,
          onColumnResizeUpdate: _onColumnResizeUpdate,
          onColumnResizeEnd: _onColumnResizeEnd,
          onColumnWidthDelta: _resizeColumn,
          onColumnWidthDeltaById: _resizeColumnById,
          errorMessage: state.subtaskErrorsByParentId[parent.id],
          startAdding: _addingSubtaskParentId == parent.id,
          onStartAddingHandled: () =>
              updateState(() => _addingSubtaskParentId = null),
          rowBuilder: (child) => _buildTaskRow(
            context,
            task: child.parentTaskId == null
                ? child.copyWith(parentTaskId: parent.id)
                : child,
            hierarchyDepth: 1,
            columns: visibleColumns,
            columnReferences: effectiveColumnRefs,
            customFields: customFields,
            milestones: milestones,
            columnWidths: _columnWidths,
            columnWidthsById: _columnWidthsById,
          ),
        ),
      _ListGroupLoadMore() => const SizedBox.shrink(),
      _ListGroupInlineCreate(:final groupKey) => TaskListGroupInlineCreateRow(
        isEditing: _addingRootGroupKey == groupKey,
        controller: _rootCreateController,
        onBegin: () => _beginInlineRootCreate(groupKey),
        onCancel: () => updateState(() {
          _rootCreateController.clear();
          _addingRootGroupKey = null;
        }),
        onSubmit: () => _submitInlineRootCreate(groupKey),
      ),
    };
  }
}
