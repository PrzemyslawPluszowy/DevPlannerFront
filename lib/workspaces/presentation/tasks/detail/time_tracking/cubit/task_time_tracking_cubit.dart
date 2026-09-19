import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskTimeTrackingState {
  const TaskTimeTrackingState();
}

final class TaskTimeTrackingLoading extends TaskTimeTrackingState {
  const TaskTimeTrackingLoading();
}

final class TaskTimeTrackingFailure extends TaskTimeTrackingState {
  const TaskTimeTrackingFailure(this.message);
  final String message;
}

final class TaskTimeTrackingReady extends TaskTimeTrackingState {
  const TaskTimeTrackingReady({
    required this.entries,
    this.isSaving = false,
    this.error,
    this.nowUtc,
  });
  final List<TaskTimeEntryResponse> entries;
  final bool isSaving;
  final String? error;
  final DateTime? nowUtc;
  List<TaskTimeEntryResponse> get activeTimers => entries
      .where(
        (entry) =>
            entry.kind == TaskTimeEntryKind.timer && entry.stoppedAtUtc == null,
      )
      .toList(growable: false);
  TaskTimeTrackingReady copyWith({
    List<TaskTimeEntryResponse>? entries,
    bool? isSaving,
    String? error,
    bool clearError = false,
    DateTime? nowUtc,
  }) => TaskTimeTrackingReady(
    entries: entries ?? this.entries,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
    nowUtc: nowUtc ?? this.nowUtc,
  );
}

/// Stan wpisów czasu i bezpiecznych akcji timer/workflow dla jednego zadania.
final class TaskTimeTrackingCubit extends Cubit<TaskTimeTrackingState> {
  TaskTimeTrackingCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  }) : super(const TaskTimeTrackingLoading());
  final TaskTimeTrackingRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  Timer? _ticker;

  Future<void> load() async {
    emit(const TaskTimeTrackingLoading());
    final result = await repository.list(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );
    if (isClosed) return;
    result.fold((error) => emit(TaskTimeTrackingFailure(error.message)), (
      entries,
    ) {
      final ready = TaskTimeTrackingReady(
        entries: entries,
        nowUtc: DateTime.now().toUtc(),
      );
      emit(ready);
      _syncTicker(ready);
    });
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
  Future<bool> stopTimer({DateTime? stoppedAtUtc}) => _mutate(
    () => repository.stopTimer(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: StopTaskTimerPayload(stoppedAtUtc: stoppedAtUtc),
    ),
  );
  Future<bool> submit(TaskTimeEntryResponse entry) =>
      _workflow(entry, repository.submit);
  Future<bool> approve(TaskTimeEntryResponse entry) =>
      _workflow(entry, repository.approve);
  Future<bool> reject(TaskTimeEntryResponse entry, {String? comment}) =>
      _mutate(
        () => repository.reject(
          workspaceId: workspaceId,
          projectId: projectId,
          taskId: taskId,
          entryId: entry.id,
          payload: TimeEntryWorkflowPayload(
            expectedVersion: entry.version,
            comment: comment,
          ),
        ),
      );

  Future<bool> _workflow(
    TaskTimeEntryResponse entry,
    Future<Either<ApiError, TaskTimeEntryResponse>> Function({
      required String workspaceId,
      required String projectId,
      required String taskId,
      required String entryId,
      required TimeEntryWorkflowPayload payload,
    })
    operation,
  ) => _mutate(
    () => operation(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      entryId: entry.id,
      payload: TimeEntryWorkflowPayload(expectedVersion: entry.version),
    ),
  );

  Future<bool> _mutate(
    Future<Either<ApiError, TaskTimeEntryResponse>> Function() operation,
  ) async {
    final current = state;
    if (current is! TaskTimeTrackingReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await operation();
    if (isClosed) return false;
    final succeeded = result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) => true,
    );
    if (!succeeded) return false;
    await load();
    return true;
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
    return super.close();
  }
}
