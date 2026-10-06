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

  /// Jedna atomowa mutacja jawnego zaznaczenia, z wersją każdego rekordu.
  /// Scheduler oblicza wspólny graf, zamiast zależeć od kolejności wierszy.
  Future<int> bulkUpdateSelected({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    List<String>? assigneeIds,
    bool archive = false,
  }) async {
    final initial = state;
    if (initial is! ProjectTasksListReady ||
        initial.selectedTaskIds.isEmpty ||
        _localMutationDepth > 0) {
      return 0;
    }
    final tasks = TaskListSnapshot.allLoadedTasks(initial)
        .where((task) => initial.selectedTaskIds.contains(task.id))
        .toList(growable: false);
    if (tasks.isEmpty || tasks.length > 500) return 0;
    final queryRevision = _requestSerial;
    _bulkMutationInFlight = true;
    _beginLocalMutation();
    try {
      final result = await repository.bulkUpdateTaskSelection(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: BulkUpdateTaskSelectionPayload(
          selectionToken: '',
          tasks: [
            for (final task in tasks)
              BulkUpdateTaskItemPayload(
                taskId: task.id,
                expectedVersion: task.version,
              ),
          ],
          status: status,
          priority: priority,
          dueAtUtc: dueAtUtc,
          clearDueAtUtc: clearDueAtUtc,
          calendarTimeZoneId: dueAtUtc != null || clearDueAtUtc
              ? calendarTimeZoneId
              : null,
          assigneeIds: assigneeIds,
          archive: archive,
          returnTaskIds: [for (final task in tasks) task.id],
        ),
      );
      if (isClosed || _requestSerial != queryRevision) return 0;
      final latest = state;
      if (latest is! ProjectTasksListReady) return 0;
      return await result.fold(
        (error) {
          emit(
            latest.copyWith(
              taskErrorsByTaskId: {
                ...latest.taskErrorsByTaskId,
                for (final task in tasks) task.id: error.message,
              },
            ),
          );
          return 0;
        },
        (response) {
          final updated = TaskListSnapshot.applyBulkMutation(
            latest,
            response.updatedTasks,
            groupBy: groupBy,
            status: status,
            priority: priority,
            dueAtUtc: dueAtUtc,
            clearDueAtUtc: clearDueAtUtc,
            assigneeIds: assigneeIds,
            archive: archive,
          );
          emit(
            updated.copyWith(
              selectedTaskIds: latest.selectedTaskIds.difference(
                initial.selectedTaskIds,
              ),
              clearSelectionAnchor: true,
              taskErrorsByTaskId: {...updated.taskErrorsByTaskId}
                ..removeWhere((id, _) => initial.selectedTaskIds.contains(id)),
            ),
          );
          return response.updatedCount;
        },
      );
    } finally {
      _bulkMutationInFlight = false;
      _endLocalMutation();
    }
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
    if (current is! ProjectTasksListReady || _localMutationDepth > 0) return 0;
    final queryRevision = _requestSerial;
    _bulkMutationInFlight = true;
    _beginLocalMutation();
    try {
      final loadedTaskIds = TaskListSnapshot.allLoadedTasks(current)
          .map((task) => task.id)
          .take(500)
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
      if (isClosed || queryRevision != _requestSerial) return 0;
      return await tokenResult.fold(
        (error) => _showBulkError(error, loadedTaskIds),
        (token) async {
          final result = await repository.bulkUpdateTaskSelection(
            workspaceId: workspaceId,
            projectId: projectId,
            payload: BulkUpdateTaskSelectionPayload(
              selectionToken: token.token,
              calendarTimeZoneId: dueAtUtc != null || clearDueAtUtc
                  ? calendarTimeZoneId
                  : null,
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
          if (isClosed || queryRevision != _requestSerial) return 0;
          return result.fold((error) => _showBulkError(error, loadedTaskIds), (
            response,
          ) {
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
                ).copyWith(
                  selectedTaskIds: latest.selectedTaskIds.difference(
                    current.selectedTaskIds,
                  ),
                ),
              );
            }
            return response.updatedCount;
          });
        },
      );
    } finally {
      _bulkMutationInFlight = false;
      _endLocalMutation();
    }
  }

  int _showBulkError(ApiError error, List<String> taskIds) {
    final current = state;
    if (!isClosed && current is ProjectTasksListReady) {
      emit(
        current.copyWith(
          taskErrorsByTaskId: {
            ...current.taskErrorsByTaskId,
            for (final id in taskIds) id: error.message,
          },
          filterError: taskIds.isEmpty ? error.message : null,
        ),
      );
    }
    return 0;
  }
}
