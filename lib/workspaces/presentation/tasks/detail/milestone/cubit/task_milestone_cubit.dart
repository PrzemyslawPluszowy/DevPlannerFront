import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskMilestoneState {
  const TaskMilestoneState();
}

final class TaskMilestoneLoading extends TaskMilestoneState {
  const TaskMilestoneLoading();
}

final class TaskMilestoneFailure extends TaskMilestoneState {
  const TaskMilestoneFailure(this.message, {this.error});

  final String message;
  final ApiError? error;
}

final class TaskMilestoneReady extends TaskMilestoneState {
  const TaskMilestoneReady({
    required this.milestones,
    this.assigned,
    this.isSaving = false,
    this.error,
    this.apiError,
  });

  final List<MilestoneResponse> milestones;
  final MilestoneResponse? assigned;
  final bool isSaving;
  final String? error;
  final ApiError? apiError;

  TaskMilestoneReady copyWith({
    MilestoneResponse? assigned,
    bool clearAssigned = false,
    bool? isSaving,
    String? error,
    ApiError? apiError,
    bool clearError = false,
  }) => TaskMilestoneReady(
    milestones: milestones,
    assigned: clearAssigned ? null : assigned ?? this.assigned,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
    apiError: clearError ? null : apiError ?? this.apiError,
  );
}

/// Odczytuje i mutuje faktyczne przypisanie jednego zadania do milestone’u.
final class TaskMilestoneCubit extends Cubit<TaskMilestoneState> {
  TaskMilestoneCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    required this.assignedMilestoneId,
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskMilestoneLoading());

  final MilestoneRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  final String? assignedMilestoneId;
  late String? _assignedMilestoneId = assignedMilestoneId;
  int _generation = 0;
  DateTime? _retryAfterUtc;
  Timer? _retryTimer;

  bool get canRetry =>
      !isClosed &&
      (_retryAfterUtc == null ||
          !DateTime.now().toUtc().isBefore(_retryAfterUtc!));

  bool get canMutate =>
      canRetry &&
      canEdit?.call() != false &&
      state is TaskMilestoneReady &&
      !(state as TaskMilestoneReady).isSaving;

  Future<void> load() async {
    if (!canRetry ||
        (state is TaskMilestoneReady &&
            (state as TaskMilestoneReady).isSaving)) {
      return;
    }
    final generation = ++_generation;
    emit(const TaskMilestoneLoading());
    final result = await _call(
      () => repository.listMilestones(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    );
    if (isClosed || generation != _generation) return;
    await result.fold<Future<void>>(
      (error) async => _failLoad(error),
      (milestones) async {
        MilestoneResponse? assigned;
        for (final milestone in milestones) {
          if (milestone.id == _assignedMilestoneId) assigned = milestone;
        }
        if (_assignedMilestoneId != null && assigned == null) {
          final fetched = await _call(
            () => repository.getMilestone(
              workspaceId: workspaceId,
              projectId: projectId,
              milestoneId: _assignedMilestoneId!,
            ),
          );
          if (isClosed || generation != _generation) return;
          ApiError? failure;
          fetched.fold(
            (error) => failure = error,
            (milestone) => assigned = milestone,
          );
          if (failure case final error?) {
            _failLoad(error);
            return;
          }
        }
        emit(
          TaskMilestoneReady(
            milestones: List.unmodifiable(
              milestones.where((m) => m.status == MilestoneStatus.active),
            ),
            assigned: assigned,
          ),
        );
      },
    );
  }

  void _failLoad(ApiError error) {
    _setRetryGate(error);
    emit(TaskMilestoneFailure(error.message, error: error));
    _reportAccess(error);
  }

  void _reportAccess(ApiError error) {
    if (error.type == ApiErrorType.unauthorized ||
        error.type == ApiErrorType.forbidden ||
        error.type == ApiErrorType.notFound) {
      onAccessLost?.call(error);
    }
  }

  Future<bool> assign(MilestoneResponse milestone) async {
    final current = state;
    if (!canMutate ||
        current is! TaskMilestoneReady ||
        current.isSaving ||
        current.assigned != null ||
        milestone.status != MilestoneStatus.active) {
      return false;
    }
    final generation = ++_generation;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await _call(
      () => repository.assignTask(
        workspaceId: workspaceId,
        projectId: projectId,
        milestoneId: milestone.id,
        taskId: taskId,
      ),
    );
    if (isClosed || generation != _generation) return false;
    return result.fold(
      (error) {
        _setRetryGate(error);
        emit(
          current.copyWith(
            isSaving: false,
            error: error.message,
            apiError: error,
          ),
        );
        _reportAccess(error);
        return false;
      },
      (_) {
        _assignedMilestoneId = milestone.id;
        emit(
          current.copyWith(
            assigned: milestone,
            isSaving: false,
            clearError: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> unassign() async {
    final current = state;
    final assigned = current is TaskMilestoneReady ? current.assigned : null;
    if (!canMutate ||
        current is! TaskMilestoneReady ||
        current.isSaving ||
        assigned == null) {
      return false;
    }
    final generation = ++_generation;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await _call(
      () => repository.unassignTask(
        workspaceId: workspaceId,
        projectId: projectId,
        milestoneId: assigned.id,
        taskId: taskId,
      ),
    );
    if (isClosed || generation != _generation) return false;
    return result.fold(
      (error) {
        _setRetryGate(error);
        emit(
          current.copyWith(
            isSaving: false,
            error: error.message,
            apiError: error,
          ),
        );
        _reportAccess(error);
        return false;
      },
      (_) {
        _assignedMilestoneId = null;
        emit(
          current.copyWith(
            clearAssigned: true,
            isSaving: false,
            clearError: true,
          ),
        );
        return true;
      },
    );
  }

  Future<Either<ApiError, T>> _call<T>(
    Future<Either<ApiError, T>> Function() operation,
  ) async {
    try {
      return await operation();
    } on Object catch (error) {
      return Left(switch (error) {
        final ApiError apiError => apiError,
        final DioException dioError
            when dioError.type == DioExceptionType.unknown &&
                dioError.response == null =>
          const ApiError(
            type: ApiErrorType.unknown,
            message: '',
            apiCode: 'tasks.milestone_operation_failed',
          ),
        final DioException dioError => ApiError.fromDioException(
          dioError,
          fallbackMessage: '',
        ),
        _ => const ApiError(
          type: ApiErrorType.unknown,
          message: '',
          apiCode: 'tasks.milestone_operation_failed',
        ),
      });
    }
  }

  void _setRetryGate(ApiError error) {
    _retryTimer?.cancel();
    _retryAfterUtc = error.retryAfterUtc?.toUtc();
    final delay = _retryAfterUtc?.difference(DateTime.now().toUtc());
    if (delay != null && delay > Duration.zero) {
      _retryTimer = Timer(delay, _enableRetry);
    }
  }

  void _enableRetry() {
    _retryTimer = null;
    _retryAfterUtc = null;
    if (isClosed) return;
    final current = state;
    if (current is TaskMilestoneReady) {
      emit(current.copyWith());
    } else if (current is TaskMilestoneFailure) {
      emit(TaskMilestoneFailure(current.message, error: current.error));
    }
  }

  @override
  Future<void> close() {
    _generation++;
    _retryTimer?.cancel();
    return super.close();
  }
}
