import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_capacity_models.dart';

/// Kontrakt pojemności workspace, override’ów projektu oraz jego workloadu.
abstract interface class TaskCapacityRepository {
  Future<Either<ApiError, WorkspaceCapacityResponse>> getWorkspaceCapacity({
    required String workspaceId,
  });

  Future<Either<ApiError, WorkspaceCapacityResponse>> updateWorkspaceCapacity({
    required String workspaceId,
    required UpdateWorkspaceCapacityPayload payload,
  });

  Future<Either<ApiError, List<UserCapacityOverrideResponse>>> listOverrides({
    required String workspaceId,
    required String projectId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<Either<ApiError, UserCapacityOverrideResponse>> createOverride({
    required String workspaceId,
    required String projectId,
    required CreateUserCapacityOverridePayload payload,
  });

  Future<Either<ApiError, UserCapacityOverrideResponse>> updateOverride({
    required String workspaceId,
    required String projectId,
    required String overrideId,
    required UpdateUserCapacityOverridePayload payload,
  });

  Future<Either<ApiError, Unit>> deleteOverride({
    required String workspaceId,
    required String projectId,
    required String overrideId,
    required int expectedVersion,
  });

  Future<Either<ApiError, TaskWorkloadResponse>> getWorkload({
    required String workspaceId,
    required String projectId,
    DateTime? fromDate,
    DateTime? toDate,
  });
}
