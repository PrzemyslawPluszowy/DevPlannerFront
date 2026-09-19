part of 'project_tasks_list_cubit.dart';

/// Operacje item wydzielone poza klasę stanu listy.
mixin TaskListItemMutationMixin on ProjectTasksListCubitPort {
  /// Archiwizuje wyłącznie załadowany rekord i usuwa go z lokalnego snapshotu
  /// po potwierdzeniu serwera. Błąd pozostawia wiersz na miejscu z komunikatem,
  /// dzięki czemu użytkownik nie traci kontekstu. Jest używane przez bulk toolbar
  /// i menu kontekstowe pojedynczego wiersza.
  Future<bool> archiveLoadedTask(ProjectTaskListItemResponse task) async {
    final result = await repository.archiveTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      expectedVersion: task.version,
    );
    if (isClosed) return false;
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    return result.fold(
      (error) {
        emit(
          current.copyWith(
            taskErrorsByTaskId: {
              ...current.taskErrorsByTaskId,
              task.id: error.message,
            },
          ),
        );
        return false;
      },
      (_) {
        final sourceIndex = current.groups.indexWhere(
          (group) => group.items.any((item) => item.id == task.id),
        );
        emit(TaskListSnapshot.removeTask(current, task.id));
        // Zadanie może być załadowanym podzadaniem, wtedy nie jest w grupie,
        // lecz znika wyłącznie z cache'u swojej gałęzi powyżej.
        assert(
          sourceIndex >= 0 || task.parentTaskId != null,
          'Aktywne zadanie musi należeć do grupy lub do cache podzadań.',
        );
        return true;
      },
    );
  }

  /// Zastępuje ownera i współpracowników jednego już załadowanego zadania.
  /// Pierwsza osoba jest ownerem, kolejne są współpracownikami — dokładnie jak
  /// w kontrakcie `PUT /assignees`. Odpowiedź podmienia wyłącznie ten wiersz.
  Future<bool> replaceAssigneesForLoadedTask(
    ProjectTaskListItemResponse task,
    List<String> userIds,
  ) async {
    final collaboration = collaborationRepository;
    if (collaboration == null) return false;
    _beginLocalMutation();
    try {
      final result = await collaboration.replaceAssignees(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: task.id,
        userIds: userIds,
        expectedVersion: task.version,
      );
      if (isClosed) return false;
      final current = state;
      if (current is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              current,
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
              current,
              task.copyWith(
                assignees: mutation.data.assignees,
                version: mutation.taskVersion,
                updatedAtUtc: mutation.taskUpdatedAtUtc,
              ),
            ),
          );
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  /// Zmienia osobiste przypięcie bez pobierania pełnego detailu. Przypięcie
  /// nie jest wersją domenowego taska, dlatego endpoint nie zwraca nowej
  /// wersji; lokalnie podmieniamy wyłącznie `isPinned` tego wiersza.
  Future<bool> setPinnedForLoadedTask(
    ProjectTaskListItemResponse task,
    bool isPinned,
  ) async {
    final collaboration = collaborationRepository;
    if (collaboration == null) return false;
    _beginLocalMutation();
    try {
      final result = await collaboration.updatePinned(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: task.id,
        isPinned: isPinned,
      );
      if (isClosed) return false;
      final current = state;
      if (current is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              current,
              task,
              errorForTaskId: task.id,
              error: error.message,
            ),
          );
          return false;
        },
        (_) {
          emit(_replaceTask(current, task.copyWith(isPinned: isPinned)));
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  /// Obserwowanie jest relacją bieżącego użytkownika z zadaniem. Odpowiedź
  /// zwraca nową wersję, więc lokalny licznik i stan „obserwuję” mogą zostać
  /// podmienione bez pobierania szczegółów taska.
  Future<bool> toggleWatchingForLoadedTask(
    ProjectTaskListItemResponse task,
  ) async {
    final collaboration = collaborationRepository;
    if (collaboration == null) return false;
    _beginLocalMutation();
    try {
      final result = task.isWatchedByMe
          ? await collaboration.unfollow(
              workspaceId: workspaceId,
              projectId: projectId,
              taskId: task.id,
              expectedVersion: task.version,
            )
          : await collaboration.follow(
              workspaceId: workspaceId,
              projectId: projectId,
              taskId: task.id,
              expectedVersion: task.version,
            );
      if (isClosed) return false;
      final current = state;
      if (current is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              current,
              task,
              errorForTaskId: task.id,
              error: error.message,
            ),
          );
          return false;
        },
        (mutation) {
          final watching = !task.isWatchedByMe;
          emit(
            _replaceTask(
              current,
              task.copyWith(
                isWatchedByMe: watching,
                watcherCount: watching
                    ? task.watcherCount + 1
                    : (task.watcherCount - 1).clamp(0, task.watcherCount),
                version: mutation.taskVersion,
                updatedAtUtc: mutation.taskUpdatedAtUtc,
              ),
            ),
          );
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  /// Atomowo zastępupuje etykiety jednego wiersza. Odpowiedź endpointu zawiera
  /// pełny, znormalizowany zestaw etykiet oraz nową wersję zadania.
  Future<bool> replaceLabelsForLoadedTask(
    ProjectTaskListItemResponse task,
    List<String> labelIds,
  ) async {
    final metadata = metadataRepository;
    if (metadata == null) return false;
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    final liveTask =
        current.tasks.cast<ProjectTaskListItemResponse?>().firstWhere(
          (t) => t?.id == task.id,
          orElse: () => task,
        ) ??
        task;
    _beginLocalMutation();
    try {
      final result = await metadata.replaceLabels(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: liveTask.id,
        payload: ReplaceTaskLabelsPayload(
          labelIds: labelIds,
          expectedVersion: liveTask.version,
        ),
      );
      if (isClosed) return false;
      final latest = state;
      if (latest is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              latest,
              liveTask,
              errorForTaskId: liveTask.id,
              error: error.message,
            ),
          );
          return false;
        },
        (mutation) {
          emit(
            _replaceTask(
              latest,
              liveTask.copyWith(
                labels: mutation.data,
                version: mutation.taskVersion,
                updatedAtUtc: mutation.taskUpdatedAtUtc,
              ),
            ),
          );
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }
}
