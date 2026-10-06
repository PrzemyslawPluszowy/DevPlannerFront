part of 'project_tasks_list_cubit.dart';

/// Atomowe operacje zakresu, feedback i świadome ponowienie.
mixin TaskListBulkMutationMixin
    on ProjectTasksListCubitPort, TaskListBulkScopeMixin {
  Future<int> Function()? _retryBulk;
  int _retryRevision = -1;
  Set<String>? _retryIds;

  @override
  void _resetBulkRetry() {
    _retryBulk = null;
    _retryIds = null;
    _retryRevision = -1;
  }

  bool _allowsRetry(ApiError error) =>
      !const {
        ApiErrorType.unauthorized,
        ApiErrorType.forbidden,
        ApiErrorType.notFound,
      }.contains(error.type) &&
      !const {401, 403, 404}.contains(error.statusCode);

  Future<int> retryBulkOperation() async {
    final current = state;
    if (isClosed ||
        current is! ProjectTasksListReady ||
        current.isBulkSaving ||
        !current.canRetryBulk ||
        _retryRevision != _requestSerial) {
      return 0;
    }
    final ids = _retryIds;
    if (ids != null &&
        (ids.length != current.selectedTaskIds.length ||
            !ids.containsAll(current.selectedTaskIds))) {
      return 0;
    }
    return await _retryBulk?.call() ?? 0;
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
        initial.isBulkSaving ||
        _localMutationDepth > 0) {
      return 0;
    }
    final tasks = TaskListSnapshot.allLoadedTasks(initial)
        .where((task) => initial.selectedTaskIds.contains(task.id))
        .toList(growable: false);
    if (tasks.isEmpty) return 0;
    if (tasks.length > 500) {
      _resetBulkRetry();
      emit(
        initial.copyWith(
          bulkError: const ApiError(
            type: ApiErrorType.validation,
            message: 'tasks.bulk.selection_limit',
          ),
          canRetryBulk: false,
        ),
      );
      return 0;
    }
    final queryRevision = _requestSerial;
    _retryRevision = queryRevision;
    _retryIds = Set.unmodifiable(initial.selectedTaskIds);
    _retryBulk = () => bulkUpdateSelected(
      status: status,
      priority: priority,
      dueAtUtc: dueAtUtc,
      clearDueAtUtc: clearDueAtUtc,
      assigneeIds: assigneeIds,
      archive: archive,
    );
    emit(
      initial.copyWith(
        isBulkSaving: true,
        clearBulkError: true,
        canRetryBulk: false,
      ),
    );
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
              bulkError: error,
              canRetryBulk: _allowsRetry(error),
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
    } catch (_) {
      if (!isClosed && queryRevision == _requestSerial) {
        _showBulkError(
          const ApiError(
            type: ApiErrorType.unknown,
            message: 'tasks.bulk.save_failed',
          ),
          const [],
        );
      }
      return 0;
    } finally {
      _bulkMutationInFlight = false;
      _endLocalMutation();
      final settled = state;
      if (!isClosed &&
          _requestSerial == queryRevision &&
          settled is ProjectTasksListReady) {
        emit(settled.copyWith(isBulkSaving: false));
      }
    }
  }

  /// Wykonuje zmianę na całym wyniku aktywnych filtrów przez token backendu.
  /// Klient nie materializuje identyfikatorów niezaładowanych stron.
  Future<int> bulkUpdateEntireResult({
    TaskSelectionTokenResponse? preparedSelection,
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
    if (current is! ProjectTasksListReady ||
        current.isBulkSaving ||
        _localMutationDepth > 0) {
      return 0;
    }
    final queryRevision = _requestSerial;
    if (preparedSelection != null &&
        (!identical(preparedSelection, _preparedBulkSelection) ||
            _preparedRevision != queryRevision ||
            !preparedSelection.expiresAtUtc.isAfter(DateTime.now().toUtc()))) {
      emit(
        current.copyWith(
          bulkError: const ApiError(
            type: ApiErrorType.validation,
            message: 'tasks.bulk.scope_expired',
          ),
          canRetryBulk: false,
        ),
      );
      return 0;
    }
    _retryRevision = queryRevision;
    _retryIds = null;
    _retryBulk = () => bulkUpdateEntireResult(
      preparedSelection: preparedSelection,
      status: status,
      customStatusId: customStatusId,
      clearCustomStatus: clearCustomStatus,
      priority: priority,
      dueAtUtc: dueAtUtc,
      clearDueAtUtc: clearDueAtUtc,
      assigneeIds: assigneeIds,
      archive: archive,
    );
    emit(
      current.copyWith(
        isBulkSaving: true,
        clearBulkError: true,
        canRetryBulk: false,
      ),
    );
    _bulkMutationInFlight = true;
    _beginLocalMutation();
    try {
      final loadedTaskIds = TaskListSnapshot.allLoadedTasks(current)
          .map((task) => task.id)
          .take(500)
          .toList(growable: false);
      final tokenResult = preparedSelection != null
          ? Right<ApiError, TaskSelectionTokenResponse>(preparedSelection)
          : await repository.createTaskSelectionToken(
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
    } catch (_) {
      if (!isClosed && queryRevision == _requestSerial) {
        _showBulkError(
          const ApiError(
            type: ApiErrorType.unknown,
            message: 'tasks.bulk.save_failed',
          ),
          const [],
        );
      }
      return 0;
    } finally {
      _bulkMutationInFlight = false;
      _endLocalMutation();
      final settled = state;
      if (!isClosed &&
          _requestSerial == queryRevision &&
          settled is ProjectTasksListReady) {
        emit(settled.copyWith(isBulkSaving: false));
      }
    }
  }

  int _showBulkError(ApiError error, List<String> taskIds) {
    final current = state;
    if (!isClosed && current is ProjectTasksListReady) {
      emit(
        current.copyWith(
          bulkError: error,
          canRetryBulk: _allowsRetry(error),
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
