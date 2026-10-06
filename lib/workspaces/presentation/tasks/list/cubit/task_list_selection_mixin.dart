part of 'project_tasks_list_cubit.dart';

/// Operacje selection wydzielone poza klasę stanu listy.
mixin TaskListSelectionMixin on ProjectTasksListCubitPort {
  Future<bool> archiveLoadedTask(ProjectTaskListItemResponse task);

  Future<bool> replaceAssigneesForLoadedTask(
    ProjectTaskListItemResponse task,
    List<String> userIds,
  );

  Future<bool> updateListItem({
    required ProjectTaskListItemResponse task,
    required UpdateTaskListItemPayload payload,
  });

  /// Zaznacza rekord albo zakres pomiędzy aktywnym anchor i rekordem klikniętym.
  void toggleSelection(String taskId, {bool range = false}) {
    final current = state;
    if (current is! ProjectTasksListReady || current.isBulkSaving) return;
    // Rozwinięte podzadania są pełnoprawnymi wierszami listy. Nie mogą
    // wyglądać jak zaznaczalne, a następnie znikać z bulk toolbaru tylko
    // dlatego, że ich cache nie należy do płaskiego `tasks` grup głównych.
    final ids = TaskListSnapshot.allLoadedTasks(current)
        .map((task) => task.id)
        .toList();
    if (!ids.contains(taskId)) return;
    emit(
      current.copyWith(
        clearBulkError: true,
        canRetryBulk: false,
        selectedTaskIds: TaskListSelection.toggle(
          selectedIds: current.selectedTaskIds,
          orderedScopeIds: ids,
          taskId: taskId,
          anchorTaskId: current.selectionAnchorTaskId,
          range: range,
        ),
        selectionAnchorTaskId: taskId,
      ),
    );
  }

  void selectLoadedTasks() {
    final current = state;
    if (current is ProjectTasksListReady && !current.isBulkSaving) {
      emit(
        current.copyWith(
          clearBulkError: true,
          canRetryBulk: false,
          selectedTaskIds: TaskListSnapshot.allLoadedTasks(current)
              .map((task) => task.id)
              .toSet(),
        ),
      );
    }
  }

  bool isLoadedGroupSelected(String groupKey) {
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    return TaskListSelection.containsAll(
      current.selectedTaskIds,
      TaskListSnapshot.loadedGroupTaskIds(current, groupKey),
    );
  }

  void setLoadedGroupSelected(String groupKey, {required bool selected}) {
    final current = state;
    if (current is! ProjectTasksListReady || current.isBulkSaving) return;
    emit(
      current.copyWith(
        clearBulkError: true,
        canRetryBulk: false,
        selectedTaskIds: TaskListSelection.setScope(
          selectedIds: current.selectedTaskIds,
          scopeIds: TaskListSnapshot.loadedGroupTaskIds(current, groupKey),
          selected: selected,
        ),
        clearSelectionAnchor: true,
      ),
    );
  }

  bool areLoadedSubtasksSelected(String parentTaskId) {
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    return TaskListSelection.containsAll(
      current.selectedTaskIds,
      TaskListSnapshot.loadedSubtaskIds(current, parentTaskId),
    );
  }

  void setLoadedSubtasksSelected(
    String parentTaskId, {
    required bool selected,
  }) {
    final current = state;
    if (current is! ProjectTasksListReady || current.isBulkSaving) return;
    emit(
      current.copyWith(
        clearBulkError: true,
        canRetryBulk: false,
        selectedTaskIds: TaskListSelection.setScope(
          selectedIds: current.selectedTaskIds,
          scopeIds: TaskListSnapshot.loadedSubtaskIds(current, parentTaskId),
          selected: selected,
        ),
        clearSelectionAnchor: true,
      ),
    );
  }

  void clearSelection() {
    final current = state;
    if (current is ProjectTasksListReady && !current.isBulkSaving) {
      emit(
        current.copyWith(
          selectedTaskIds: const {},
          clearSelectionAnchor: true,
          clearBulkError: true,
          canRetryBulk: false,
        ),
      );
    }
  }
}
