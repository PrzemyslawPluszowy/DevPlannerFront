part of 'project_tasks_list_cubit.dart';

/// Operacje mutation wydzielone poza klasę stanu listy.
mixin TaskListMutationMixin on ProjectTasksListCubitPort {
  /// Przenosi element względem sąsiadów, optymistycznie aktualizując wyłącznie
  /// załadowane grupy. Backend pozostaje źródłem prawdy dla pozycji i relacji.
  Future<bool> moveTask({
    required ProjectTaskListItemResponse task,
    required String targetGroupKey,
    String? previousTaskId,
    String? nextTaskId,
    String? parentTaskId,
  }) async {
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    final target = current.groups.where((group) => group.key == targetGroupKey);
    if (target.isEmpty) return false;
    final targetGroup = target.first;
    final isUnassignedCustomStatus =
        parentTaskId == null &&
        TaskListGrouping.isUnassignedCustomStatusGroup(targetGroupKey);
    final customStatusId = parentTaskId == null
        ? TaskListGrouping.customStatusIdForGroup(targetGroupKey)
        : null;
    final status = parentTaskId == null && customStatusId == null
        ? (isUnassignedCustomStatus
              ? task.status
              : TaskListGrouping.statusForGroup(targetGroupKey))
        : null;
    final optimistic = task.copyWith(
      parentTaskId: parentTaskId,
      status: status ?? task.status,
      customStatusId: customStatusId ?? task.customStatusId,
      customStatusName: customStatusId == null
          ? task.customStatusName
          : targetGroup.displayName,
      customStatusColor: customStatusId == null
          ? task.customStatusColor
          : targetGroup.color,
    );
    final snapshot = current;
    final removedGroups = [
      for (final group in current.groups)
        group.copyWith(
          items: group.items.where((item) => item.id != task.id).toList(),
        ),
    ];
    final subtasks = {
      for (final entry in current.subtasksByParentId.entries)
        entry.key: entry.value.where((item) => item.id != task.id).toList(),
    };
    if (parentTaskId == null) {
      final targetIndex = removedGroups.indexWhere(
        (group) => group.key == targetGroupKey,
      );
      final targetItems = [...removedGroups[targetIndex].items];
      final before = nextTaskId == null
          ? targetItems.length
          : targetItems.indexWhere((item) => item.id == nextTaskId);
      targetItems.insert(before < 0 ? targetItems.length : before, optimistic);
      removedGroups[targetIndex] = removedGroups[targetIndex].copyWith(
        items: targetItems,
      );
    } else {
      final targetItems = <ProjectTaskListItemResponse>[
        ...(subtasks[parentTaskId] ?? const <ProjectTaskListItemResponse>[]),
      ];
      final before = nextTaskId == null
          ? targetItems.length
          : targetItems.indexWhere((item) => item.id == nextTaskId);
      targetItems.insert(before < 0 ? targetItems.length : before, optimistic);
      subtasks[parentTaskId] = targetItems;
    }
    emit(
      current.copyWith(
        groups: removedGroups,
        tasks: [for (final group in removedGroups) ...group.items],
        subtasksByParentId: subtasks,
      ),
    );
    _suppressRealtimeForLocalMutation();
    final result = await repository.moveTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      payload: MoveProjectTaskPayload(
        expectedVersion: task.version,
        parentTaskId: parentTaskId,
        previousTaskId: previousTaskId,
        nextTaskId: nextTaskId,
        status: status,
        customStatusId: customStatusId,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          snapshot.copyWith(
            taskErrorsByTaskId: {
              ...snapshot.taskErrorsByTaskId,
              task.id: error.message,
            },
          ),
        );
        return false;
      },
      (moved) {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            _replaceTask(
              latest,
              optimistic.copyWith(
                version: moved.version,
                updatedAtUtc: moved.updatedAtUtc,
                parentTaskId: moved.parentTaskId,
                status: moved.status,
                customStatusId: moved.customStatusId,
              ),
            ),
          );
        }
        return true;
      },
    );
  }

  /// Wstrzymuje albo wznawia serię bez przeładowania listy.
  Future<bool> toggleRecurrence(ProjectTaskListItemResponse task) async {
    final current = state;
    final repository = recurrenceRepository;
    final recurrence = task.recurrence;
    if (current is! ProjectTasksListReady ||
        repository == null ||
        recurrence == null) {
      return false;
    }
    final optimistic = task.copyWith(
      recurrence: recurrence.copyWith(isActive: !recurrence.isActive),
    );
    emit(_replaceTask(current, optimistic));
    _suppressRealtimeForLocalMutation();
    final result = recurrence.isActive
        ? await repository.pause(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: task.id,
            expectedVersion: recurrence.version,
          )
        : await repository.resume(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: task.id,
            expectedVersion: recurrence.version,
          );
    if (isClosed) return false;
    final latest = state;
    if (latest is! ProjectTasksListReady) return false;
    return result.fold(
      (error) {
        emit(
          _replaceTask(
            latest,
            task,
            errorForTaskId: task.id,
            error: error.message,
          ),
        );
        return false;
      },
      (mutation) {
        final value = mutation.data;
        emit(
          _replaceTask(
            latest,
            task.copyWith(
              version: mutation.taskVersion,
              updatedAtUtc: mutation.taskUpdatedAtUtc,
              recurrence: TaskRecurrenceSummaryMapper.fromResponse(
                value,
                taskId: task.id,
              ),
            ),
          ),
        );
        return true;
      },
    );
  }

  /// Przyjmuje potwierdzoną pełną regułę z zakotwiczonego edytora i podmienia
  /// wyłącznie ten wiersz; edytor nie powoduje ponownego pobrania grup.
  void applyRecurrenceMutation(
    ProjectTaskListItemResponse task,
    TaskMutationResponse<TaskRecurrenceResponse> mutation,
  ) {
    final current = state;
    if (current is! ProjectTasksListReady || isClosed) return;
    final value = mutation.data;
    final latestTask =
        TaskListSnapshot.findLoadedTask(current, task.id) ?? task;
    emit(
      _replaceTask(
        current,
        latestTask.copyWith(
          version: mutation.taskVersion,
          updatedAtUtc: mutation.taskUpdatedAtUtc,
          recurrence: TaskRecurrenceSummaryMapper.fromResponse(
            value,
            taskId: latestTask.id,
          ),
        ),
      ),
    );
    _suppressRealtimeForLocalMutation();
  }

  /// Zapisuje wszystkie wartości własne zadania, utrzymując wersję i rollback
  /// pojedynczego wiersza w tej samej ścieżce co pozostałe komórki listy.
  Future<bool> updateCustomField({
    required ProjectTaskListItemResponse task,
    required String fieldId,
    required Object? value,
  }) async {
    final current = state;
    final metadata = metadataRepository;
    if (current is! ProjectTasksListReady || metadata == null) return false;
    final values = <String, Object>{
      for (final item in task.customFields)
        if (item.value != null && item.fieldId != fieldId)
          item.fieldId: item.value!,
      if (value != null && (value is! String || value.trim().isNotEmpty))
        fieldId: value,
    };
    final optimistic = task.copyWith(
      customFields: [
        for (final item in task.customFields)
          if (item.fieldId == fieldId)
            if (value != null) item.copyWith(value: value) else null
          else
            item,
        if (value != null &&
            !task.customFields.any((item) => item.fieldId == fieldId))
          TaskCustomFieldValueResponse(
            fieldId: fieldId,
            value: value,
            updatedAtUtc: DateTime.now().toUtc(),
          ),
      ].whereType<TaskCustomFieldValueResponse>().toList(growable: false),
    );
    emit(_replaceTask(current, optimistic));
    _suppressRealtimeForLocalMutation();
    final result = await metadata.replaceCustomFieldValues(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      payload: ReplaceTaskCustomFieldValuesPayload(
        values: values,
        expectedVersion: task.version,
      ),
    );
    if (isClosed) return false;
    final latest = state;
    if (latest is! ProjectTasksListReady) return false;
    return result.fold(
      (error) {
        emit(
          _replaceTask(
            latest,
            task,
            errorForTaskId: task.id,
            error: error.message,
          ),
        );
        return false;
      },
      (mutation) {
        emit(
          _replaceTask(
            latest,
            task.copyWith(
              customFields: mutation.data,
              version: mutation.taskVersion,
              updatedAtUtc: mutation.taskUpdatedAtUtc,
            ),
          ),
        );
        return true;
      },
    );
  }
}
