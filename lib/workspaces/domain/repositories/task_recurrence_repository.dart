import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';

/// Kontrakt konfiguracji serii cyklicznej pojedynczego zadania.
abstract interface class TaskRecurrenceRepository {
  Future<Either<ApiError, TaskRecurrenceResponse>> get({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskRecurrencePayload payload,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  update({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskRecurrencePayload payload,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>> pause({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  resume({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  });

  Future<Either<ApiError, TaskMutationResponse<bool>>> delete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    int? expectedVersion,
  });

  Future<Either<ApiError, List<ProjectTaskRecurrenceItemResponse>>>
  getProjectRecurrences({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, List<ProjectTaskRecurrenceRunResponse>>>
  getProjectRecurrenceRuns({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  triggerRunNow({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });
}
