part of 'project_tasks_list_cubit.dart';

/// Operacje subtasks_private wydzielone poza klasę stanu listy.
mixin TaskListSubtasksMixin on ProjectTasksListCubitPort {
  @override
  Future<void> _loadSubtasks(
    ProjectTasksListReady current,
    String parentId, {
    required Set<String> expandedTaskIds,
    bool force = false,
    String? cursor,
  }) async {
    if (current.loadingSubtaskParentIds.contains(parentId)) return;
    if (!force &&
        cursor == null &&
        current.subtasksByParentId.containsKey(parentId)) {
      return;
    }
    emit(
      TaskListTreeSnapshot.startLoading(
        current,
        parentId: parentId,
        expandedTaskIds: expandedTaskIds,
      ),
    );
    final result = await repository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
      query: TaskListQuery.fromReady(
        current,
        savedViewId: savedViewId,
      ).listPage(cursor: cursor, parentTaskId: parentId),
    );
    if (isClosed) return;
    final latest = state;
    if (latest is! ProjectTasksListReady) return;
    result.fold(
      (error) => emit(
        TaskListTreeSnapshot.loadFailed(
          latest,
          parentId: parentId,
          message: error.message,
        ),
      ),
      (page) => emit(
        TaskListTreeSnapshot.mergePage(
          latest,
          parentId: parentId,
          items: page.items,
          nextCursor: page.nextCursor,
          append: cursor != null,
        ),
      ),
    );
  }
}
