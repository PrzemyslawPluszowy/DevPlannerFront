part of 'project_tasks_list_cubit.dart';

/// Operacje realtime wydzielone poza klasę stanu listy.
mixin TaskListRealtimeMixin on ProjectTasksListCubitPort {
  Future<void> load({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    String? assigneeUserId,
    TaskInvolvementFilter? myInvolvement,
    bool? unassignedOnly,
    bool? pinnedOnly,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearAssigneeUserId = false,
    bool clearMyInvolvement = false,
  });

  /// Zachowany wyłącznie jako jawne odświeżenie użytkownika/fallback startowy.
  /// Eventy realtime nie mogą go wywoływać, bo zmiana jednej komórki nie może
  /// zerwać scrolla ani spowodować migotania całej tabeli.
  Future<void> refreshFromRealtime() async {
    if (_shouldIgnoreRealtime) {
      _realtimeRefreshPending = true;
      _scheduleDeferredRealtimeRefresh();
      return;
    }
    final current = state;
    if (current is ProjectTasksListReady) {
      // Kanał SignalR przekazuje konkretne mutacje do applyRealtimeMutation.
      // Brak mutacji nie jest uprawnieniem do pełnego GET, bo taki GET niszczy
      // viewport przy normalnej pracy. Jawny refresh użytkownika pozostaje
      // obsługiwany przez load().
      return;
    }
    await load();
  }

  /// Aktualizuje pojedynczy załadowany wiersz z wiadomości SignalR. Pełny
  /// odczyt pozostaje wyłącznie fallbackiem dla mutacji bez lokalnego odpowiednika.
  Future<void> applyRealtimeMutation(TaskRealtimeMutation mutation) async {
    final current = state;
    // Echo własnego PATCH ma wersję, którą lista już dostała w odpowiedzi.
    // Nie wolno odkładać go na 2 s, bo kończyło się to GET /tasks/groups.
    if (current is ProjectTasksListReady &&
        _isRealtimeMutationAlreadyApplied(current, mutation)) {
      return;
    }
    if (_shouldIgnoreRealtime) {
      _realtimeRefreshPending = true;
      _pendingRealtimeMutations.add(mutation);
      _scheduleDeferredRealtimeRefresh();
      return;
    }
    if (current is! ProjectTasksListReady) {
      await load();
      return;
    }
    switch (mutation.type) {
      case TaskRealtimeMutationType.updated:
        final task = current.tasks
            .where((item) => item.id == mutation.taskId)
            .firstOrNull;
        if (task == null || mutation.version <= task.version) return;
        emit(
          _replaceTask(
            current,
            task.copyWith(
              title: mutation.title ?? task.title,
              status: mutation.status ?? task.status,
              priority: mutation.priority ?? task.priority,
              dueAtUtc: mutation.hasDueAtUtc
                  ? mutation.dueAtUtc
                  : task.dueAtUtc,
              version: mutation.version,
              updatedAtUtc: mutation.occurredAtUtc,
            ),
          ),
        );
      case TaskRealtimeMutationType.statusChanged:
      case TaskRealtimeMutationType.kanbanMoved:
      case TaskRealtimeMutationType.kanbanBulkMoved:
      case TaskRealtimeMutationType.kanbanColumnRebalanced:
        if (groupBy == TaskSavedViewGroupBy.status && mutation.status != null) {
          if (_moveLoadedTaskForRealtimeStatus(current, mutation)) {
            return;
          }
        }
        final task = current.tasks
            .where((item) => item.id == mutation.taskId)
            .firstOrNull;
        if (task == null ||
            mutation.status == null ||
            mutation.version <= task.version) {
          return;
        }
        emit(
          _replaceTask(
            current,
            task.copyWith(
              status: mutation.status!,
              version: mutation.version,
              updatedAtUtc: mutation.occurredAtUtc,
            ),
          ),
        );
      case TaskRealtimeMutationType.created:
      case TaskRealtimeMutationType.restored:
        await _appendRealtimeRootTask(mutation);
        return;
      case TaskRealtimeMutationType.archived:
        final task = TaskListSnapshot.findLoadedTask(current, mutation.taskId);
        if (task == null || mutation.version <= task.version) return;
        emit(TaskListSnapshot.removeTask(current, task.id));
        return;
      case TaskRealtimeMutationType.recurrenceChanged:
        return;
    }
  }

  bool _isRealtimeMutationAlreadyApplied(
    ProjectTasksListReady current,
    TaskRealtimeMutation mutation,
  ) {
    final task = TaskListSnapshot.findLoadedTask(current, mutation.taskId);
    return task != null && task.version >= mutation.version;
  }

  /// Nowe albo przywrócone zadanie wymaga pełnej projekcji, aby lokalny reducer
  /// mógł poprawnie sprawdzić filtry i grupę. Pobieramy wyłącznie ten rekord;
  /// nigdy całe `/tasks/groups` ani atrapy pozbawione wykonawców/checklisty.
  Future<void> _appendRealtimeRootTask(TaskRealtimeMutation mutation) async {
    final result = await repository.getTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: mutation.taskId,
    );
    if (isClosed) return;
    result.fold((_) {}, (details) {
      final current = state;
      if (current is! ProjectTasksListReady ||
          TaskListSnapshot.findLoadedTask(current, mutation.taskId) != null ||
          details.task.archivedAtUtc != null ||
          details.task.version < mutation.version) {
        return;
      }
      emit(
        details.task.parentTaskId == null
            ? TaskListSnapshot.appendCreatedRootTask(
                current,
                details.task,
                groupBy: groupBy,
                hasSavedView: savedViewId != null,
              )
            : TaskListSnapshot.appendCreatedSubtaskIfLoaded(
                current,
                details.task,
                hasSavedView: savedViewId != null,
              ),
      );
    });
  }

  bool _moveLoadedTaskForRealtimeStatus(
    ProjectTasksListReady current,
    TaskRealtimeMutation mutation,
  ) {
    final sourceIndex = current.groups.indexWhere(
      (group) => group.items.any((task) => task.id == mutation.taskId),
    );
    final targetKey =
        'status:${mutation.status!.name[0].toUpperCase()}${mutation.status!.name.substring(1)}';
    final targetIndex = current.groups.indexWhere(
      (group) => group.key == targetKey,
    );
    if (sourceIndex < 0 || targetIndex < 0) return false;
    final source = current.groups[sourceIndex];
    final task = source.items.firstWhere((item) => item.id == mutation.taskId);
    if (mutation.version <= task.version) return true;
    final replacement = task.copyWith(
      title: mutation.title ?? task.title,
      priority: mutation.priority ?? task.priority,
      dueAtUtc: mutation.hasDueAtUtc ? mutation.dueAtUtc : task.dueAtUtc,
      status: mutation.status!,
      version: mutation.version,
      updatedAtUtc: mutation.occurredAtUtc,
    );
    if (_inFlightListItemUpdates.containsKey(mutation.taskId)) {
      emit(_replaceTask(current, replacement));
      return true;
    }
    final groups = [...current.groups];
    if (sourceIndex == targetIndex) {
      groups[sourceIndex] = source.copyWith(
        items: [
          for (final item in source.items)
            if (item.id == task.id) replacement else item,
        ],
      );
    } else {
      final target = current.groups[targetIndex];
      groups[sourceIndex] = source.copyWith(
        items: source.items.where((item) => item.id != task.id).toList(),
        totalCount: (source.totalCount - 1).clamp(0, source.totalCount),
      );
      groups[targetIndex] = target.copyWith(
        items: [...target.items, replacement],
        totalCount: target.totalCount + 1,
      );
    }
    emit(
      current.copyWith(
        groups: groups,
        tasks: [for (final group in groups) ...group.items],
      ),
    );
    return true;
  }
}
