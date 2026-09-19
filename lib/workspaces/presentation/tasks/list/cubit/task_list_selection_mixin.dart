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
    if (current is! ProjectTasksListReady) return;
    // Rozwinięte podzadania są pełnoprawnymi wierszami listy. Nie mogą
    // wyglądać jak zaznaczalne, a następnie znikać z bulk toolbaru tylko
    // dlatego, że ich cache nie należy do płaskiego `tasks` grup głównych.
    final ids = TaskListSnapshot.allLoadedTasks(current)
        .map((task) => task.id)
        .toList();
    if (!ids.contains(taskId)) return;
    emit(
      current.copyWith(
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
    if (current is ProjectTasksListReady) {
      emit(
        current.copyWith(
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
    if (current is! ProjectTasksListReady) return;
    emit(
      current.copyWith(
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
    if (current is! ProjectTasksListReady) return;
    emit(
      current.copyWith(
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
    if (current is ProjectTasksListReady) {
      emit(
        current.copyWith(selectedTaskIds: const {}, clearSelectionAnchor: true),
      );
    }
  }

  /// Wykonuje identyczną, wersjonowaną mutację dla aktualnie zaznaczonych
  /// rekordów. Do czasu wdrożenia tokenu selekcji backend pozostaje to celowo
  /// ograniczone do rekordów obecnych w lokalnym snapshotie listy.
  Future<int> bulkUpdateSelected({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    List<String>? assigneeIds,
    bool archive = false,
  }) async {
    final initial = state;
    if (initial is! ProjectTasksListReady || initial.selectedTaskIds.isEmpty) {
      return 0;
    }
    final tasks = TaskListSnapshot.allLoadedTasks(initial)
        .where((task) => initial.selectedTaskIds.contains(task.id))
        .toList(growable: false);
    var updatedCount = 0;
    for (final task in tasks) {
      final saved = archive
          ? await archiveLoadedTask(task)
          : assigneeIds != null
          ? await replaceAssigneesForLoadedTask(task, assigneeIds)
          : await updateListItem(
              task: task,
              payload: UpdateTaskListItemPayload(
                status: status,
                priority: priority,
                dueAtUtc: dueAtUtc,
                clearDueAtUtc: clearDueAtUtc,
                expectedVersion: task.version,
              ),
            );
      if (saved) updatedCount++;
    }
    // Każda udana operacja zaktualizowała już lokalny snapshot. Czyszczenie
    // zaznaczenia nie może zamieniać szybkiej akcji bulk w pełny reload listy.
    final latest = state;
    if (!isClosed && latest is ProjectTasksListReady) {
      emit(
        latest.copyWith(
          selectedTaskIds: const {},
          clearSelectionAnchor: true,
        ),
      );
    }
    return updatedCount;
  }

  /// Wykonuje zmianę na całym wyniku aktywnych filtrów przez token backendu.
  /// Klient nie materializuje identyfikatorów niezaładowanych stron.
  Future<int> bulkUpdateEntireResult({
    ProjectTaskStatus? status,
    String? customStatusId,
    bool clearCustomStatus = false,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    List<String>? assigneeIds,
    bool archive = false,
  }) async {
    final current = state;
    if (current is! ProjectTasksListReady) return 0;
    final loadedTaskIds = TaskListSnapshot.allLoadedTasks(current)
        .map((task) => task.id)
        .toList(growable: false);
    final tokenResult = await repository.createTaskSelectionToken(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: CreateTaskSelectionTokenPayload(
        query: TaskListQuery.fromReady(
          current,
          savedViewId: savedViewId,
        ).selectionTokenPayload(),
      ),
    );
    if (isClosed) return 0;
    return tokenResult.fold((_) => 0, (token) async {
      final result = await repository.bulkUpdateTaskSelection(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: BulkUpdateTaskSelectionPayload(
          selectionToken: token.token,
          status: status,
          customStatusId: customStatusId,
          clearCustomStatus: clearCustomStatus,
          priority: priority,
          dueAtUtc: dueAtUtc,
          clearDueAtUtc: clearDueAtUtc,
          assigneeIds: assigneeIds,
          archive: archive,
          returnTaskIds: loadedTaskIds,
        ),
      );
      if (isClosed) return 0;
      return result.fold((_) => 0, (response) {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            TaskListSnapshot.applyBulkMutation(
              latest,
              response.updatedTasks,
              groupBy: groupBy,
              status: status,
              customStatusId: customStatusId,
              clearCustomStatus: clearCustomStatus,
              priority: priority,
              dueAtUtc: dueAtUtc,
              clearDueAtUtc: clearDueAtUtc,
              assigneeIds: assigneeIds,
              archive: archive,
            ),
          );
        }
        return response.updatedCount;
      });
    });
  }
}
