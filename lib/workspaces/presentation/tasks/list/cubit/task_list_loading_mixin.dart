part of 'project_tasks_list_cubit.dart';

/// Operacje loading wydzielone poza klasę stanu listy.
mixin TaskListLoadingMixin on ProjectTasksListCubitPort {
  Future<void> loadMore() async {
    final current = state;
    if (current is! ProjectTasksListReady || !current.canLoadMore) return;
    final cursor = current.nextCursor;
    if (cursor == null) return;
    final serial = _requestSerial;
    emit(current.copyWith(isLoadingMore: true, clearMoreError: true));
    final result = await repository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
      query: TaskListQuery.fromReady(
        current,
        savedViewId: savedViewId,
      ).listPage(cursor: cursor),
    );
    if (isClosed || serial != _requestSerial) return;
    final latest = state;
    if (latest is! ProjectTasksListReady) return;
    result.fold(
      (error) => emit(
        latest.copyWith(isLoadingMore: false, moreError: error.message),
      ),
      (page) {
        final knownIds = latest.tasks.map((task) => task.id).toSet();
        emit(
          latest.copyWith(
            tasks: [
              ...latest.tasks,
              ...page.items.where((task) => knownIds.add(task.id)),
            ],
            nextCursor: page.nextCursor,
            clearCursor: page.nextCursor == null,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Doładowuje wyłącznie jedną grupę według jej niezależnego kursora.
  Future<void> loadMoreGroup(String groupKey) async {
    final current = state;
    if (current is! ProjectTasksListReady || !_loadingGroupKeys.add(groupKey)) {
      return;
    }
    final group = current.groups
        .where((item) => item.key == groupKey)
        .firstOrNull;
    if (group?.nextCursor == null) {
      _loadingGroupKeys.remove(groupKey);
      return;
    }
    try {
      final result = await repository.listProjectTaskGroups(
        workspaceId: workspaceId,
        projectId: projectId,
        query:
            TaskListQuery.fromReady(
              current,
              savedViewId: savedViewId,
            ).groups(
              groupBy: groupBy,
              groupKey: groupKey,
              cursor: group!.nextCursor,
            ),
      );
      if (isClosed || state is! ProjectTasksListReady) return;
      result.fold(
        (_) {},
        (page) {
          final latest = state as ProjectTasksListReady;
          final latestGroup = latest.groups
              .where((item) => item.key == groupKey)
              .firstOrNull;
          if (latestGroup == null) return;
          final incoming = page.groups.single;
          final knownIds = latestGroup.items.map((item) => item.id).toSet();
          final merged = latestGroup.copyWith(
            items: [
              ...latestGroup.items,
              ...incoming.items.where((item) => knownIds.add(item.id)),
            ],
            nextCursor: incoming.nextCursor,
          );
          emit(
            latest.copyWith(
              groups: [
                for (final item in latest.groups)
                  if (item.key == groupKey) merged else item,
              ],
              tasks: [
                for (final item in latest.groups)
                  if (item.key == groupKey) ...merged.items else ...item.items,
              ],
            ),
          );
        },
      );
    } finally {
      _loadingGroupKeys.remove(groupKey);
    }
  }

  /// Rozwija lub zwija bezpośrednie podzadania bez pobierania całej listy.
  Future<void> toggleSubtasks(ProjectTaskListItemResponse parent) async {
    final current = state;
    if (current is! ProjectTasksListReady || parent.parentTaskId != null) {
      return;
    }
    final parentId = parent.id;
    final expansion = TaskListTreeSnapshot.toggleExpansion(
      current,
      parentId: parentId,
    );
    if (!expansion.shouldLoad) {
      emit(expansion.state);
      return;
    }
    await _loadSubtasks(
      current,
      parentId,
      expandedTaskIds: expansion.expandedTaskIdsForLoad!,
    );
  }

  /// Tworzy jednopoziomowe podzadanie z listy i odświeża wyłącznie gałąź rodzica.
  Future<bool> createSubtask({
    required ProjectTaskListItemResponse parent,
    required String title,
  }) async {
    final current = state;
    final normalized = title.trim();
    if (current is! ProjectTasksListReady ||
        parent.parentTaskId != null ||
        normalized.isEmpty) {
      return false;
    }
    final result = await repository.quickCreateTask(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: QuickCreateProjectTaskPayload(
        title: normalized,
        parentTaskId: parent.id,
        targetStatus: ProjectTaskStatus.todo,
      ),
    );
    if (isClosed) return false;
    return await result.fold(
      (error) async {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            latest.copyWith(
              subtaskErrorsByParentId: {
                ...latest.subtaskErrorsByParentId,
                parent.id: error.message,
              },
            ),
          );
        }
        return false;
      },
      (_) async {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          await _loadSubtasks(
            latest,
            parent.id,
            expandedTaskIds: {...latest.expandedTaskIds, parent.id},
            force: true,
          );
        }
        return true;
      },
    );
  }

  /// Doładowuje kolejną stronę bezpośrednich dzieci, zachowując cache gałęzi.
  Future<void> loadMoreSubtasks(ProjectTaskListItemResponse parent) async {
    final current = state;
    final parentId = parent.id;
    if (current is! ProjectTasksListReady ||
        !current.expandedTaskIds.contains(parentId) ||
        current.loadingSubtaskParentIds.contains(parentId)) {
      return;
    }
    final cursor = current.nextSubtaskCursorByParentId[parentId];
    if (cursor == null) return;
    await _loadSubtasks(
      current,
      parentId,
      expandedTaskIds: current.expandedTaskIds,
      cursor: cursor,
    );
  }
}
