import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_operation_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_retry_after_gate.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/session/task_detail_section_lifecycle.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_entry_reviewer_lookup_gate.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_error_state_factory.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_retry_state_publisher.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'task_time_tracking_state.dart';

final class TaskTimeTrackingCubit extends Cubit<TaskTimeTrackingState> {
  TaskTimeTrackingCubit({
    required this.repository,
    this.memberProfilesRepository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskTimeTrackingLoading()) {
    _reviewerLookupGate = TaskTimeEntryReviewerLookupGate(
      repository: memberProfilesRepository,
      workspaceId: workspaceId,
      projectId: projectId,
    );
  }
  final TaskTimeTrackingRepository repository;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  Timer? _ticker;
  final _retryAfter = TaskDetailRetryAfterGate();
  late final TaskTimeEntryReviewerLookupGate _reviewerLookupGate;
  int? _timeGeneration;
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
    _timeGeneration = generation;
    _reviewerLookupGate.cancelPending();
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
    if (result.isLeft()) {
      result.fold(
        (error) => _emitLoadFailure(error, previousReady: previousReady),
        (_) {},
      );
      return;
    }
    _retryAfter.clear();
    final entries = result.getOrElse(() => const <TaskTimeEntryResponse>[]);
    final ready = TaskTimeTrackingReady(
      entries: entries,
      reviewerNames: previousReady?.reviewerNames ?? const <String, String>{},
      reviewerIdsLookedUp:
          previousReady?.reviewerIdsLookedUp ?? const <String>{},
      reviewerLookupFailure: previousReady?.reviewerLookupFailure,
      isReviewerLookupRetryBlocked: _reviewerLookupGate.isRetryBlocked,
      nowUtc: DateTime.now().toUtc(),
    );
    emit(ready);
    _syncTicker(ready);
    unawaited(
      _refreshReviewerNames(generation, refreshUnseen: afterMutation),
    );
  }

  Future<void> retryReviewerNames() async {
    final current = state;
    final generation = _timeGeneration;
    if (current is! TaskTimeTrackingReady ||
        current.isSaving ||
        generation == null) {
      return;
    }
    await _refreshReviewerNames(generation, forceRefresh: true);
  }

  Future<void> _refreshReviewerNames(
    int generation, {
    bool refreshUnseen = false,
    bool forceRefresh = false,
  }) async {
    final current = state;
    if (!_lifecycle.isCurrent(generation) ||
        current is! TaskTimeTrackingReady) {
      return;
    }
    final outcome = await _reviewerLookupGate.lookup(
      current: current,
      refreshUnseen: refreshUnseen,
      forceRefresh: forceRefresh,
      onStarted: () => emit(
        current.copyWith(
          isReviewerLookupLoading: true,
          isReviewerLookupRetryBlocked: false,
        ),
      ),
      onRetryAvailable: _publishReviewerRetryAvailable,
    );
    if (outcome == null) return;
    if (!_lifecycle.isCurrent(generation) ||
        !_reviewerLookupGate.isCurrent(outcome.serial) ||
        state is! TaskTimeTrackingReady) {
      return;
    }
    final latest = state as TaskTimeTrackingReady;
    if (outcome.failure != null) {
      emit(
        latest.copyWith(
          reviewerLookupFailure: outcome.failure,
          isReviewerLookupLoading: false,
          isReviewerLookupRetryBlocked: outcome.retryBlocked,
        ),
      );
      return;
    }
    emit(
      latest.copyWith(
        reviewerNames: {...latest.reviewerNames, ...outcome.names},
        reviewerIdsLookedUp: {
          ...latest.reviewerIdsLookedUp,
          ...outcome.reviewerIds,
        },
        clearReviewerLookupFailure: true,
        isReviewerLookupLoading: false,
        isReviewerLookupRetryBlocked: false,
      ),
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
    _timeGeneration = generation;
    _reviewerLookupGate.cancelPending();
    _retryAfter.clear();
    emit(
      current.copyWith(
        isSaving: true,
        isReviewerLookupLoading: false,
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
    emit(
      TaskTimeTrackingErrorStateFactory.loadFailure(
        error: error,
        previousReady: previousReady,
        retryAfter: _retryAfter,
        onRetryAvailable: _publishRetryAvailable,
      ),
    );
    if (previousReady?.activeTimers.isNotEmpty == true) {
      _syncTicker(previousReady!);
    }
    _lifecycle.reportError(error);
  }

  void _emitMutationFailure(TaskTimeTrackingReady current, ApiError error) {
    emit(
      TaskTimeTrackingErrorStateFactory.mutationFailure(
        current: current,
        error: error,
        retryAfter: _retryAfter,
        onRetryAvailable: _publishRetryAvailable,
      ),
    );
    _lifecycle.reportError(error);
  }

  void _publishRetryAvailable() {
    TaskTimeTrackingRetryStatePublisher.time(
      isClosed: isClosed,
      state: state,
      emit: emit,
    );
  }

  void _publishReviewerRetryAvailable() {
    TaskTimeTrackingRetryStatePublisher.reviewerNames(
      isClosed: isClosed,
      state: state,
      emit: emit,
    );
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
    _reviewerLookupGate.dispose();
    _lifecycle.invalidate();
    return super.close();
  }
}
