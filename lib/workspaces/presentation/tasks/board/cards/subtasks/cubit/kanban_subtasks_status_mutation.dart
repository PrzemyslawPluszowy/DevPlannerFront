part of 'kanban_subtasks_cubit.dart';

extension KanbanSubtasksStatusMutation on KanbanSubtasksCubit {
  /// Optymistycznie zmienia status załadowanego podzadania. Podzadania nie są
  /// kartami Kanban, dlatego używa kontraktu PATCH list-item zamiast moveTask.
  Future<bool> updateStatus(
    String taskId,
    ProjectTaskStatus status, {
    String? customStatusId,
  }) async {
    final current = state;
    if (current is! KanbanSubtasksReady ||
        current.pendingSubtaskIds.contains(taskId)) {
      return false;
    }
    final index = current.subtasks.indexWhere((item) => item.id == taskId);
    if (index < 0) return false;
    final previous = current.subtasks[index];
    if (previous.status == status &&
        previous.customStatusId == customStatusId) {
      return true;
    }
    final wasDone = previous.status == ProjectTaskStatus.done;
    final isDone = status == ProjectTaskStatus.done;
    _parentCompleted += (isDone ? 1 : 0) - (wasDone ? 1 : 0);
    final optimistic = previous.copyWith(
      status: status,
      customStatusId: customStatusId,
    );
    final items = [...current.subtasks]..[index] = optimistic;
    _emitMutationState(
      current.copyWith(
        subtasks: items,
        subtaskCompleted: _parentCompleted,
        pendingSubtaskIds: {...current.pendingSubtaskIds, taskId},
      ),
    );
    try {
      final result = await tasksRepository.updateListItem(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        payload: UpdateTaskListItemPayload(
          status: customStatusId == null ? status : null,
          customStatusId: customStatusId,
          expectedVersion: previous.version,
        ),
      );
      if (isClosed) return false;
      return await result.fold(
        (error) async {
          final ready = state;
          _parentCompleted += (wasDone ? 1 : 0) - (isDone ? 1 : 0);
          if (error.type == ApiErrorType.conflict) {
            await refresh(
              mutationError: error.message,
              mutationSerial: ready is KanbanSubtasksReady
                  ? ready.mutationSerial + 1
                  : 1,
            );
            return false;
          }
          if (ready is KanbanSubtasksReady) {
            final rollback = [...ready.subtasks];
            final rollbackIndex = rollback.indexWhere(
              (item) => item.id == taskId,
            );
            if (rollbackIndex >= 0) {
              rollback[rollbackIndex] = previous;
            }
            _emitMutationState(
              ready.copyWith(
                subtasks: rollback,
                subtaskCompleted: _parentCompleted,
                pendingSubtaskIds: {...ready.pendingSubtaskIds}..remove(taskId),
                mutationError: error.message,
                mutationSerial: ready.mutationSerial + 1,
              ),
            );
          }
          return false;
        },
        (mutation) {
          final ready = state;
          if (ready is KanbanSubtasksReady) {
            final updated = [...ready.subtasks];
            final updatedIndex = updated.indexWhere(
              (item) => item.id == taskId,
            );
            if (updatedIndex >= 0 &&
                mutation.data.version >= updated[updatedIndex].version) {
              updated[updatedIndex] = mutation.data;
            }
            _emitMutationState(
              ready.copyWith(
                subtasks: updated,
                pendingSubtaskIds: {...ready.pendingSubtaskIds}..remove(taskId),
              ),
            );
          }
          return true;
        },
      );
    } catch (error) {
      _parentCompleted += (wasDone ? 1 : 0) - (isDone ? 1 : 0);
      if (!isClosed) {
        await refresh(mutationError: error.toString(), mutationSerial: 1);
      }
      return false;
    }
  }
}
