part of 'project_tasks_list_cubit.dart';

/// Operacje loading wydzielone poza klasę stanu listy.
mixin TaskListLoadingMixin on ProjectTasksListCubitPort {
  bool _canPage(ProjectTasksListReady current) =>
      !isClosed &&
      !current.isRefreshing &&
      !current.isBulkSaving &&
      _localMutationDepth == 0;

  bool _pageChanged(
    ProjectTasksListReady initial,
    ProjectTasksListReady latest,
  ) {
    if (_localMutationDepth > 0 || latest.isBulkSaving) return true;
    final versions = {
      for (final task in TaskListSnapshot.allLoadedTasks(latest))
        task.id: task.version,
    };
    return TaskListSnapshot.allLoadedTasks(initial)
        .any((task) => versions[task.id] != task.version);
  }

  static bool canRetryPage(ApiError? error) =>
      error == null ||
      (!const {
            ApiErrorType.unauthorized,
            ApiErrorType.forbidden,
            ApiErrorType.notFound,
          }.contains(error.type) &&
          !const {401, 403, 404}.contains(error.statusCode));

  static const _changedPage = ApiError(
    type: ApiErrorType.conflict,
    message: 'tasks.list.page_changed',
  );
  static const _invalidPage = ApiError(
    type: ApiErrorType.parsing,
    message: 'tasks.list.page_failed',
  );

  Future<void> loadMore({bool retry = false}) async {
    final initial = state;
    if (initial is! ProjectTasksListReady ||
        !initial.canLoadMore ||
        !_canPage(initial) ||
        (initial.moreApiError != null &&
            (!retry || !canRetryPage(initial.moreApiError)))) {
      return;
    }
    final cursor = initial.nextCursor!;
    final serial = _requestSerial;
    emit(initial.copyWith(isLoadingMore: true, clearMoreError: true));
    try {
      final result = await repository.listProjectTasks(
        workspaceId: workspaceId,
        projectId: projectId,
        query: TaskListQuery.fromReady(
          initial,
          savedViewId: savedViewId,
        ).listPage(cursor: cursor),
      );
      if (isClosed || serial != _requestSerial) return;
      final latest = state;
      if (latest is! ProjectTasksListReady || latest.nextCursor != cursor) {
        return;
      }
      result.fold<void>(
        (error) => emit(latest.copyWith(moreApiError: error)),
        (page) {
          if (_pageChanged(initial, latest) || page.nextCursor == cursor) {
            emit(
              latest.copyWith(
                moreApiError: _pageChanged(initial, latest)
                    ? _changedPage
                    : _invalidPage,
              ),
            );
            return;
          }
          final knownIds = TaskListSnapshot.allLoadedTasks(latest)
              .map((task) => task.id)
              .toSet();
          emit(
            latest.copyWith(
              tasks: [
                ...latest.tasks,
                ...page.items.where((task) => knownIds.add(task.id)),
              ],
              nextCursor: page.nextCursor,
              clearCursor: page.nextCursor == null,
            ),
          );
        },
      );
    } catch (_) {
      final latest = state;
      if (!isClosed &&
          serial == _requestSerial &&
          latest is ProjectTasksListReady) {
        emit(latest.copyWith(moreApiError: _invalidPage));
      }
    } finally {
      final latest = state;
      if (!isClosed &&
          serial == _requestSerial &&
          latest is ProjectTasksListReady) {
        emit(latest.copyWith(isLoadingMore: false));
      }
    }
  }

  /// Kolejna strona należy do konkretnego kursora, grupy i epoki zapytania.
  Future<void> loadMoreGroup(String groupKey) async {
    final initial = state;
    if (initial is! ProjectTasksListReady ||
        !_canPage(initial) ||
        initial.loadingGroupKeys.contains(groupKey) ||
        !canRetryPage(initial.groupLoadErrors[groupKey])) {
      return;
    }
    final group = initial.groups
        .where((item) => item.key == groupKey)
        .firstOrNull;
    final cursor = group?.nextCursor;
    if (group == null || cursor == null) return;
    final serial = _requestSerial;
    final grouping = groupBy;
    // Backend normalizuje None do Status, choć UI prezentuje płaską listę.
    final responseGrouping = grouping == TaskSavedViewGroupBy.none
        ? TaskSavedViewGroupBy.status
        : grouping;
    emit(
      initial.copyWith(
        loadingGroupKeys: {...initial.loadingGroupKeys, groupKey},
        groupLoadErrors: {...initial.groupLoadErrors}..remove(groupKey),
      ),
    );
    try {
      final result = await repository.listProjectTaskGroups(
        workspaceId: workspaceId,
        projectId: projectId,
        query: TaskListQuery.fromReady(
          initial,
          savedViewId: savedViewId,
        ).groups(groupBy: grouping, groupKey: groupKey, cursor: cursor),
      );
      if (isClosed || serial != _requestSerial || grouping != groupBy) return;
      final latest = state;
      if (latest is! ProjectTasksListReady) return;
      final latestGroup = latest.groups
          .where((item) => item.key == groupKey)
          .firstOrNull;
      if (latestGroup == null || latestGroup.nextCursor != cursor) return;
      result.fold<void>(
        (error) => emit(
          latest.copyWith(
            groupLoadErrors: {...latest.groupLoadErrors, groupKey: error},
          ),
        ),
        (page) {
          if (_pageChanged(initial, latest) ||
              page.groupBy != responseGrouping ||
              page.groups.length != 1 ||
              page.groups.single.key != groupKey ||
              page.groups.single.nextCursor == cursor) {
            emit(
              latest.copyWith(
                groupLoadErrors: {
                  ...latest.groupLoadErrors,
                  groupKey: _pageChanged(initial, latest)
                      ? _changedPage
                      : _invalidPage,
                },
              ),
            );
            return;
          }
          final incoming = page.groups.single;
          final knownIds = TaskListSnapshot.allLoadedTasks(latest)
              .map((task) => task.id)
              .toSet();
          final merged = latestGroup.copyWith(
            items: [
              ...latestGroup.items,
              ...incoming.items.where((item) => knownIds.add(item.id)),
            ],
            nextCursor: incoming.nextCursor,
          );
          final groups = [
            for (final item in latest.groups)
              if (item.key == groupKey) merged else item,
          ];
          emit(
            latest.copyWith(
              groups: groups,
              tasks: [for (final item in groups) ...item.items],
            ),
          );
        },
      );
    } catch (_) {
      final latest = state;
      if (!isClosed &&
          serial == _requestSerial &&
          latest is ProjectTasksListReady) {
        emit(
          latest.copyWith(
            groupLoadErrors: {
              ...latest.groupLoadErrors,
              groupKey: _invalidPage,
            },
          ),
        );
      }
    } finally {
      final latest = state;
      if (!isClosed &&
          serial == _requestSerial &&
          latest is ProjectTasksListReady) {
        emit(
          latest.copyWith(
            loadingGroupKeys: {...latest.loadingGroupKeys}..remove(groupKey),
          ),
        );
      }
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
