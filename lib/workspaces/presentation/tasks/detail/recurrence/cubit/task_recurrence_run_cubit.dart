import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_operation_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_retry_after_gate.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/session/task_detail_section_lifecycle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan ostatniego uruchomienia i jawnej akcji utworzenia wystąpienia.
final class TaskRecurrenceRunState {
  const TaskRecurrenceRunState({
    this.recurrenceRuleId,
    this.latestRun,
    this.isLoadingHistory = false,
    this.isTriggering = false,
    this.historyError,
    this.actionError,
    this.isHistoryRetryBlocked = false,
    this.isActionRetryBlocked = false,
  });

  final String? recurrenceRuleId;
  final ProjectTaskRecurrenceRunResponse? latestRun;
  final bool isLoadingHistory;
  final bool isTriggering;
  final ApiError? historyError;
  final ApiError? actionError;
  final bool isHistoryRetryBlocked;
  final bool isActionRetryBlocked;

  TaskRecurrenceRunState copyWith({
    String? recurrenceRuleId,
    ProjectTaskRecurrenceRunResponse? latestRun,
    bool clearLatestRun = false,
    bool? isLoadingHistory,
    bool? isTriggering,
    ApiError? historyError,
    ApiError? actionError,
    bool clearHistoryError = false,
    bool clearActionError = false,
    bool? isHistoryRetryBlocked,
    bool? isActionRetryBlocked,
  }) => TaskRecurrenceRunState(
    recurrenceRuleId: recurrenceRuleId ?? this.recurrenceRuleId,
    latestRun: clearLatestRun ? null : latestRun ?? this.latestRun,
    isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
    isTriggering: isTriggering ?? this.isTriggering,
    historyError: clearHistoryError ? null : historyError ?? this.historyError,
    actionError: clearActionError ? null : actionError ?? this.actionError,
    isHistoryRetryBlocked: isHistoryRetryBlocked ?? this.isHistoryRetryBlocked,
    isActionRetryBlocked: isActionRetryBlocked ?? this.isActionRetryBlocked,
  );
}

/// Oddzielnie kontroluje historię i uruchomienie; błąd nie blokuje edytora.
final class TaskRecurrenceRunCubit extends Cubit<TaskRecurrenceRunState> {
  TaskRecurrenceRunCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.sourceTaskId,
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskRecurrenceRunState());

  final TaskRecurrenceRepository repository;
  final String workspaceId;
  final String projectId;
  final String sourceTaskId;
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  late final _lifecycle = TaskDetailSectionLifecycle(
    isClosed: () => isClosed,
    canEdit: canEdit,
    onAccessLost: onAccessLost,
  );
  final _historyRetry = TaskDetailRetryAfterGate();
  final _actionRetry = TaskDetailRetryAfterGate();
  String? _loadedRuleId;

  /// Pobiera maksymalnie 100 ostatnich wykonań zwracanych przez API projektu.
  Future<void> ensureLatestLoaded(String recurrenceRuleId) async {
    if (_loadedRuleId == recurrenceRuleId ||
        state.recurrenceRuleId == recurrenceRuleId && state.isLoadingHistory) {
      return;
    }
    await _loadLatest(recurrenceRuleId, force: false);
  }

  /// Odświeża status bez ponawiania niepewnego POST run-now.
  Future<void> retryHistory() async {
    final ruleId = state.recurrenceRuleId;
    if (ruleId == null ||
        state.isLoadingHistory ||
        state.isTriggering ||
        _historyRetry.isBlocked) {
      return;
    }
    await _loadLatest(ruleId, force: true);
  }

  Future<bool> triggerRunNow(String recurrenceRuleId) async {
    final current = state;
    if (!_lifecycle.canMutate ||
        current.isTriggering ||
        current.isLoadingHistory ||
        current.isActionRetryBlocked ||
        _actionRetry.isBlocked) {
      return false;
    }
    final generation = _lifecycle.begin();
    if (generation == null) return false;
    _loadedRuleId = recurrenceRuleId;
    emit(
      current.copyWith(
        recurrenceRuleId: recurrenceRuleId,
        isTriggering: true,
        clearActionError: true,
      ),
    );
    late final Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>
    result;
    try {
      result = await repository.triggerRunNow(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: sourceTaskId,
      );
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return false;
      final apiError = TaskDetailOperationErrorNormalizer.fromThrown(
        error,
        fallbackMessage: '',
      );
      _emitActionFailure(apiError);
      return false;
    }
    if (!_lifecycle.isCurrent(generation)) return false;
    final response = result.fold(
      (error) {
        _emitActionFailure(error);
        return null;
      },
      (success) {
        _actionRetry.clear();
        emit(state.copyWith(isTriggering: false, clearActionError: true));
        return success.data;
      },
    );
    if (response == null) return false;
    await _loadLatest(recurrenceRuleId, force: true);
    return !isClosed;
  }

  Future<void> _loadLatest(
    String recurrenceRuleId, {
    required bool force,
  }) async {
    if (_historyRetry.isBlocked ||
        state.isLoadingHistory ||
        state.isTriggering && !force) {
      return;
    }
    final generation = _lifecycle.begin();
    if (generation == null) return;
    emit(
      state.copyWith(
        recurrenceRuleId: recurrenceRuleId,
        isLoadingHistory: true,
        clearHistoryError: true,
        isHistoryRetryBlocked: false,
      ),
    );
    late final Either<ApiError, List<ProjectTaskRecurrenceRunResponse>> result;
    try {
      result = await repository.getProjectRecurrenceRuns(
        workspaceId: workspaceId,
        projectId: projectId,
      );
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return;
      _emitHistoryFailure(
        TaskDetailOperationErrorNormalizer.fromThrown(
          error,
          fallbackMessage: '',
        ),
      );
      return;
    }
    if (!_lifecycle.isCurrent(generation)) return;
    result.fold(_emitHistoryFailure, (runs) {
      _historyRetry.clear();
      _loadedRuleId = recurrenceRuleId;
      final latestRun = _latestForRule(runs, recurrenceRuleId);
      emit(
        state.copyWith(
          recurrenceRuleId: recurrenceRuleId,
          latestRun: latestRun,
          clearLatestRun: latestRun == null,
          isLoadingHistory: false,
          clearHistoryError: true,
          isHistoryRetryBlocked: false,
        ),
      );
    });
  }

  ProjectTaskRecurrenceRunResponse? _latestForRule(
    List<ProjectTaskRecurrenceRunResponse> runs,
    String recurrenceRuleId,
  ) {
    ProjectTaskRecurrenceRunResponse? latest;
    for (final run in runs) {
      if (run.recurrenceRuleId != recurrenceRuleId ||
          run.sourceTaskId != sourceTaskId) {
        continue;
      }
      if (latest == null || run.executedAtUtc.isAfter(latest.executedAtUtc)) {
        latest = run;
      }
    }
    return latest;
  }

  void _emitActionFailure(ApiError error) {
    _actionRetry.schedule(error, onAvailable: _publishRetryAvailable);
    emit(
      state.copyWith(
        isTriggering: false,
        actionError: error,
        isActionRetryBlocked: _actionRetry.isBlocked,
      ),
    );
    _lifecycle.reportError(error);
  }

  void _emitHistoryFailure(ApiError error) {
    _historyRetry.schedule(error, onAvailable: _publishRetryAvailable);
    emit(
      state.copyWith(
        isLoadingHistory: false,
        historyError: error,
        isHistoryRetryBlocked: _historyRetry.isBlocked,
      ),
    );
    _lifecycle.reportError(error);
  }

  void _publishRetryAvailable() {
    if (isClosed) return;
    emit(
      state.copyWith(
        isHistoryRetryBlocked: _historyRetry.isBlocked,
        isActionRetryBlocked: _actionRetry.isBlocked,
      ),
    );
  }

  @override
  Future<void> close() {
    _historyRetry.dispose();
    _actionRetry.dispose();
    _lifecycle.invalidate();
    return super.close();
  }
}
