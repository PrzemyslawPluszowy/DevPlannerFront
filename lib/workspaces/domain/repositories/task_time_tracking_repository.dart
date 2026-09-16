import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';

/// Kontrakt wpisów czasu, timera i procesu akceptacji dla jednego zadania.
abstract interface class TaskTimeTrackingRepository {
  Future<Either<ApiError, List<TaskTimeEntryResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });
  Future<Either<ApiError, TaskTimeEntryResponse>> create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskTimeEntryPayload payload,
  });
  Future<Either<ApiError, TaskTimeEntryResponse>> startTimer({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });
  Future<Either<ApiError, TaskTimeEntryResponse>> stopTimer({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required StopTaskTimerPayload payload,
  });
  Future<Either<ApiError, TaskTimeEntryResponse>> submit({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  });
  Future<Either<ApiError, TaskTimeEntryResponse>> approve({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  });
  Future<Either<ApiError, TaskTimeEntryResponse>> reject({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  });
}
