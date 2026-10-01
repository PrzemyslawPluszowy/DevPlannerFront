import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_operation_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_retry_after_gate.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/session/task_detail_section_lifecycle.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'task_time_tracking_state.dart';

/// Stan wpisów czasu i bezpiecznych akcji timer/workflow dla jednego zadania.
final class TaskTimeTrackingCubit extends Cubit<TaskTimeTrackingState> {
  TaskTimeTrackingCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskTimeTrackingLoading());
  final TaskTimeTrackingRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  Timer? _ticker;
  final _retryAfter = TaskDetailRetryAfterGate();
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  late final _lifecycle = TaskDetailSectionLifecycle(
    isClosed: () => isClosed,
    canEdit: canEdit,
    onAccessLost: onAccessLost,
  );

  bool get canSubmit =>
      _lifecycle.canMutate &&
      !_retryAfter.isBlocked &&
      state is TaskTimeTrackingReady &&
      !(state as TaskTimeTrackingReady).isSaving &&
      !(state as TaskTimeTrackingReady).isRetryBlocked;

  Future<void> load() => _load();

  Future<void> _load({bool afterMutation = false}) async {
    if (!afterMutation && _retryAfter.isBlocked) return;
    if (!afterMutation &&
        state is TaskTimeTrackingReady &&
        (state as TaskTimeTrackingReady).isSaving) {
      return;
    }
    final generation = _lifecycle.begin();
    if (generation == null) return;
    if (!afterMutation) _retryAfter.clear();
    _ticker?.cancel();
    final previousReady = afterMutation && state is TaskTimeTrackingReady
        ? state as TaskTimeTrackingReady
        : null;
    if (!afterMutation) emit(const TaskTimeTrackingLoading());
    late final Either<ApiError, List<TaskTimeEntryResponse>> result;
    try {
      result = await repository.list(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return;
      final apiError = TaskDetailOperationErrorNormalizer.fromThrown(
        error,
        fallbackMessage: '',
      );
      _emitLoadFailure(apiError, previousReady: previousReady);
      return;
    }
    if (!_lifecycle.isCurrent(generation)) return;
    result.fold(
      (error) => _emitLoadFailure(error, previousReady: previousReady),
      (
        entries,
      ) {
        _retryAfter.clear();
        final ready = TaskTimeTrackingReady(
          entries: entries,
          nowUtc: DateTime.now().toUtc(),
        );
        emit(ready);
        _syncTicker(ready);
      },
    );
  }

  Future<bool> create(CreateTaskTimeEntryPayload payload) => _mutate(
    () => repository.create(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: payload,
    ),
  );
  Future<bool> startTimer() => _mutate(
    () => repository.startTimer(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    ),
  );
  Future<bool> stopTimer({DateTime? stoppedAtUtc}) async {
    final current = state;
    if (current is! TaskTimeTrackingReady || current.ownActiveTimers.isEmpty) {
      return false;
    }
    return _mutate(
      () => repository.stopTimer(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        payload: StopTaskTimerPayload(stoppedAtUtc: stoppedAtUtc),
      ),
      allowReadOnly: true,
    );
  }

  Future<bool> submit(TaskTimeEntryResponse entry) =>
      _workflow(entry, repository.submit);
  Future<bool> approve(TaskTimeEntryResponse entry, {String? comment}) =>
      _workflow(entry, repository.approve, review: true, comment: comment);
  Future<bool> reject(TaskTimeEntryResponse entry, {String? comment}) =>
      _workflow(entry, repository.reject, review: true, comment: comment);

  bool _canEntryWorkflow(TaskTimeEntryResponse entry, {required bool review}) {
    final current = state;
    if (current is! TaskTimeTrackingReady) return false;
    return current.entries.any(
      (item) =>
          item.id == entry.id && (review ? item.canReview : item.canSubmit),
    );
  }

  Future<bool> _workflow(
    TaskTimeEntryResponse entry,
    Future<Either<ApiError, TaskTimeEntryResponse>> Function({
      required String workspaceId,
      required String projectId,
      required String taskId,
      required String entryId,
      required TimeEntryWorkflowPayload payload,
    })
    operation, {
    bool review = false,
    String? comment,
  }) async {
    if (!_canEntryWorkflow(entry, review: review)) return false;
    return _mutate(
      () => operation(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        entryId: entry.id,
        payload: TimeEntryWorkflowPayload(
          expectedVersion: entry.version,
          comment: comment,
        ),
      ),
      allowReadOnly: review,
    );
  }

  Future<bool> _mutate(
    Future<Either<ApiError, TaskTimeEntryResponse>> Function() operation, {
    bool allowReadOnly = false,
  }) async {
    final current = state;
    if (isClosed ||
        (!_lifecycle.canMutate && !allowReadOnly) ||
        current is! TaskTimeTrackingReady ||
        current.isSaving ||
        current.isRetryBlocked ||
        _retryAfter.isBlocked) {
      return false;
    }
    final generation = _lifecycle.begin()!;
    _retryAfter.clear();
    emit(
      current.copyWith(
        isSaving: true,
        isRetryBlocked: false,
        clearError: true,
      ),
    );
    late final Either<ApiError, TaskTimeEntryResponse> result;
    try {
      result = await operation();
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return false;
      final apiError = TaskDetailOperationErrorNormalizer.fromThrown(
        error,
        fallbackMessage: '',
      );
      _emitMutationFailure(current, apiError);
      return false;
    }
    if (!_lifecycle.isCurrent(generation)) return false;
    final succeeded = result.fold(
      (error) {
        _emitMutationFailure(current, error);
        return false;
      },
      (updatedEntry) {
        final entries = [...current.entries];
        final index = entries.indexWhere(
          (entry) => entry.id == updatedEntry.id,
        );
        if (index < 0) {
          entries.add(updatedEntry);
        } else {
          entries[index] = updatedEntry;
        }
        emit(
          current.copyWith(
            entries: entries,
            isSaving: true,
            isRetryBlocked: false,
            nowUtc: DateTime.now().toUtc(),
            clearError: true,
          ),
        );
        return true;
      },
    );
    if (!succeeded) return false;
    await _load(afterMutation: true);
    return true;
  }

  void _emitLoadFailure(
    ApiError error, {
    required TaskTimeTrackingReady? previousReady,
  }) {
    if (previousReady == null) {
      _retryAfter.schedule(error, onAvailable: _publishRetryAvailable);
      emit(
        TaskTimeTrackingFailure(
          error.message,
          apiError: error,
          isRetryBlocked: _retryAfter.isBlocked,
        ),
      );
    } else {
      _retryAfter.schedule(error, onAvailable: _publishRetryAvailable);
      emit(
        previousReady.copyWith(
          isSaving: false,
          error: error.message,
          apiError: error,
          isRetryBlocked: _retryAfter.isBlocked,
        ),
      );
      if (previousReady.activeTimers.isNotEmpty) {
        _syncTicker(previousReady);
      }
    }
    _lifecycle.reportError(error);
  }

  void _emitMutationFailure(TaskTimeTrackingReady current, ApiError error) {
    _retryAfter.schedule(error, onAvailable: _publishRetryAvailable);
    emit(
      current.copyWith(
        isSaving: false,
        error: error.message,
        apiError: error,
        isRetryBlocked: _retryAfter.isBlocked,
      ),
    );
    _lifecycle.reportError(error);
  }

  void _publishRetryAvailable() {
    if (isClosed) return;
    switch (state) {
      case TaskTimeTrackingFailure(:final message, :final apiError):
        emit(
          TaskTimeTrackingFailure(
            message,
            apiError: apiError,
          ),
        );
      case TaskTimeTrackingReady(:final isRetryBlocked) when isRetryBlocked:
        emit((state as TaskTimeTrackingReady).copyWith(isRetryBlocked: false));
      default:
        break;
    }
  }

  void _syncTicker(TaskTimeTrackingReady state) {
    _ticker?.cancel();
    if (state.activeTimers.isEmpty) {
      return;
    }
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      final current = this.state;
      if (isClosed ||
          current is! TaskTimeTrackingReady ||
          current.activeTimers.isEmpty) {
        return;
      }
      emit(current.copyWith(nowUtc: DateTime.now().toUtc()));
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _retryAfter.dispose();
    _lifecycle.invalidate();
    return super.close();
  }
}
