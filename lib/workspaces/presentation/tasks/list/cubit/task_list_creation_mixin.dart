part of 'project_tasks_list_cubit.dart';

/// Operacje creation wydzielone poza klasę stanu listy.
mixin TaskListCreationMixin on ProjectTasksListCubitPort {
  /// Tworzy zadanie główne i zwraca typowany wynik dla lokalnej kompozycji listy.
  ///
  /// Snapshot jest aktualizowany dopiero po potwierdzonej odpowiedzi backendu;
  /// odrzucona próba nie udaje sukcesu ani nie uruchamia odświeżenia.
  Future<ProjectTaskCreationResult> createRootTaskWithResult({
    required String title,
    required ProjectTaskStatus status,
    TaskPriority priority = TaskPriority.normal,
    String? customStatusId,
  }) async {
    final normalized = title.trim();
    if (normalized.isEmpty) {
      return const ProjectTaskCreationFailure(
        reason: ProjectTaskCreationFailureReason.invalidTitle,
      );
    }
    if (_rootTaskCreationInFlight) {
      return const ProjectTaskCreationFailure(
        reason: ProjectTaskCreationFailureReason.duplicateSubmission,
      );
    }
    if (state is! ProjectTasksListReady) {
      return const ProjectTaskCreationFailure(
        reason: ProjectTaskCreationFailureReason.listNotReady,
      );
    }

    _rootTaskCreationInFlight = true;
    try {
      final result = await repository.quickCreateTask(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: QuickCreateProjectTaskPayload(
          title: normalized,
          targetStatus: customStatusId == null ? status : null,
          customStatusId: customStatusId,
        ),
      );
      if (isClosed) {
        return const ProjectTaskCreationFailure(
          reason: ProjectTaskCreationFailureReason.listNotReady,
        );
      }
      return await result.fold(
        (error) => ProjectTaskCreationFailure(error: error),
        (mutation) {
          final latest = state;
          if (latest is ProjectTasksListReady) {
            emit(
              TaskListSnapshot.appendCreatedRootTask(
                latest,
                mutation.data,
                groupBy: groupBy,
                hasSavedView: savedViewId != null,
              ),
            );
          }
          return const ProjectTaskCreationSuccess();
        },
      );
    } finally {
      _rootTaskCreationInFlight = false;
    }
  }

  /// Tworzy zadanie główne bez przeładowywania bieżącej listy.
  ///
  /// Backend zwraca pełną projekcję nowego zadania, którą składamy do lekkiego
  /// rekordu tabeli i dopisujemy tylko do jego załadowanej grupy. Dzięki temu
  /// wpisanie zadania nie resetuje scrolla, rozwiniętych podzadań ani filtrów.
  Future<bool> createRootTask({
    required String title,
    required ProjectTaskStatus status,
    TaskPriority priority = TaskPriority.normal,
    String? customStatusId,
  }) async {
    final result = await createRootTaskWithResult(
      title: title,
      status: status,
      priority: priority,
      customStatusId: customStatusId,
    );
    return result is ProjectTaskCreationSuccess;
  }

  /// Aktualizuje tytuł zadania optymistycznie i wysyła zmianę do backendu.
  Future<bool> updateTitle(
    ProjectTaskListItemResponse task,
    String newTitle,
  ) async {
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty || trimmed == task.title) return false;
    return updateListItem(
      task: task,
      payload: UpdateTaskListItemPayload(
        title: trimmed,
        expectedVersion: task.version,
      ),
    );
  }

  /// Aktualizuje stan licznika checklisty dla zadania w lokalnym widoku listy.
  void updateChecklistCounts({
    required String taskId,
    required int completedCount,
    required int totalCount,
    int? newVersion,
  }) {
    final current = state;
    if (current is! ProjectTasksListReady) return;
    final task = TaskListSnapshot.findLoadedTask(current, taskId);
    if (task == null) return;
    final updated = task.copyWith(
      checklistCompletedCount: completedCount,
      checklistTotalCount: totalCount,
      version: newVersion ?? task.version,
    );
    emit(TaskListSnapshot.replaceTask(current, updated, groupBy: groupBy));
  }

  /// Zapisuje pojedynczą komórkę listy optymistycznie i przywraca ją po błędzie.
  Future<bool> updateListItem({
    required ProjectTaskListItemResponse task,
    required UpdateTaskListItemPayload payload,
  }) async {
    final inFlight = _inFlightListItemUpdates[task.id];
    if (inFlight != null) {
      // Szybka druga zmiana nie może wysłać starego expectedVersion.
      final previousSucceeded = await inFlight;
      if (!previousSucceeded || isClosed) return false;
      final current = state;
      final latest = current is ProjectTasksListReady
          ? TaskListSnapshot.findLoadedTask(current, task.id)
          : null;
      if (latest == null) return false;
      return updateListItem(
        task: latest,
        payload: payload.copyWith(expectedVersion: latest.version),
      );
    }
    late final Future<bool> future;
    future = _updateListItemNow(task: task, payload: payload).whenComplete(() {
      if (identical(_inFlightListItemUpdates[task.id], future)) {
        final removed = _inFlightListItemUpdates.remove(task.id);
        // [removed] jest właśnie kończącą się future; nie czekamy na nią
        // ponownie wewnątrz jej własnego whenComplete.
        assert(removed != null, 'Zakończona mutacja musi istnieć w kolejce.');
      }
    });
    _inFlightListItemUpdates[task.id] = future;
    return future;
  }

  Future<bool> _updateListItemNow({
    required ProjectTaskListItemResponse task,
    required UpdateTaskListItemPayload payload,
  }) async {
    final current = state;
    if (current is! ProjectTasksListReady ||
        task.version != payload.expectedVersion) {
      return false;
    }
    final optimistic = task.copyWith(
      title: payload.title ?? task.title,
      status: payload.status ?? task.status,
      priority: payload.priority ?? task.priority,
      startAtUtc: payload.clearStartAtUtc
          ? null
          : payload.startAtUtc ?? task.startAtUtc,
      dueAtUtc: payload.clearDueAtUtc
          ? null
          : payload.dueAtUtc ?? task.dueAtUtc,
      taskType: payload.taskType ?? task.taskType,
      size: payload.clearSize ? null : payload.size ?? task.size,
      complexity: payload.clearComplexity
          ? null
          : payload.complexity ?? task.complexity,
      risk: payload.clearRisk ? null : payload.risk ?? task.risk,
      businessValue: payload.clearBusinessValue
          ? null
          : payload.businessValue ?? task.businessValue,
      estimatedMinutes: payload.clearEstimatedMinutes
          ? null
          : payload.estimatedMinutes ?? task.estimatedMinutes,
    );
    emit(_replaceTask(current, optimistic));
    _beginLocalMutation();
    try {
      final result = await repository.updateListItem(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: task.id,
        payload: payload,
      );
      if (isClosed) return false;
      final latest = state;
      if (latest is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          final taskAfterFailure = error.type == ApiErrorType.conflict
              ? optimistic
              : task;
          emit(
            _replaceTask(
              latest,
              taskAfterFailure,
              errorForTaskId: task.id,
              error: error.type == ApiErrorType.conflict
                  ? 'Zadanie zmienił inny użytkownik. Odśwież je świadomie, aby porównać zmiany.'
                  : error.message,
            ),
          );
          return false;
        },
        (mutation) {
          // PATCH /list-item nie zmienia osobistego przypięcia ani relacji
          // obserwowania. Zachowujemy bieżący snapshot tych pól, aby nawet
          // starsza/niepełna odpowiedź backendu po zmianie statusu nie
          // zgasiła ikonek wiersza przed następnym odczytem listy.
          final currentTask =
              TaskListSnapshot.findLoadedTask(latest, task.id) ?? optimistic;
          final confirmed = mutation.data.copyWith(
            isPinned: currentTask.isPinned,
            watcherCount: currentTask.watcherCount,
            isWatchedByMe: currentTask.isWatchedByMe,
          );
          emit(_replaceTask(latest, confirmed));
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }
}
