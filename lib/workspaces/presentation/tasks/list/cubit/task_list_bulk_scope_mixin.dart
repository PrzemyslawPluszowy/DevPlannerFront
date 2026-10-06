part of 'project_tasks_list_cubit.dart';

/// Przygotowanie potwierdzanego zakresu bez mutacji zadań.
mixin TaskListBulkScopeMixin on ProjectTasksListCubitPort {
  TaskSelectionTokenResponse? _preparedBulkSelection;
  int _preparedRevision = -1;
  void _resetBulkRetry();

  Future<TaskSelectionTokenResponse?> prepareBulkSelection() async {
    final initial = state;
    if (initial is! ProjectTasksListReady ||
        initial.isBulkSaving ||
        _localMutationDepth > 0) {
      return null;
    }
    _resetBulkRetry();
    _preparedBulkSelection = null;
    _preparedRevision = -1;
    final revision = _requestSerial;
    emit(
      initial.copyWith(
        isBulkSaving: true,
        clearBulkError: true,
        canRetryBulk: false,
      ),
    );
    try {
      final result = await repository.createTaskSelectionToken(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: CreateTaskSelectionTokenPayload(
          query: TaskListQuery.fromReady(
            initial,
            savedViewId: savedViewId,
          ).selectionTokenPayload(),
        ),
      );
      if (isClosed || revision != _requestSerial) return null;
      final latest = state;
      if (latest is! ProjectTasksListReady) return null;
      return result.fold<TaskSelectionTokenResponse?>(
        (error) {
          emit(
            latest.copyWith(
              isBulkSaving: false,
              bulkError: error,
              canRetryBulk: false,
            ),
          );
          return null;
        },
        (token) {
          _preparedBulkSelection = token;
          _preparedRevision = revision;
          emit(latest.copyWith(isBulkSaving: false));
          return token;
        },
      );
    } catch (_) {
      if (!isClosed && revision == _requestSerial) {
        final current = state;
        if (current is ProjectTasksListReady) {
          emit(
            current.copyWith(
              bulkError: const ApiError(
                type: ApiErrorType.unknown,
                message: 'tasks.bulk.save_failed',
              ),
            ),
          );
        }
      }
      return null;
    } finally {
      final current = state;
      if (!isClosed &&
          revision == _requestSerial &&
          current is ProjectTasksListReady) {
        emit(current.copyWith(isBulkSaving: false));
      }
    }
  }
}
