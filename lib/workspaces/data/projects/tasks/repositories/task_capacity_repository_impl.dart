import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_capacity_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';

/// Adapter capacity i workloadu do typowanego kontraktu domenowego Tasks.
final class TaskCapacityRepositoryImpl extends ApiRepository
    implements TaskCapacityRepository {
  TaskCapacityRepositoryImpl(this._api);

  final TaskCapacityApi _api;

  @override
  Future<Either<ApiError, WorkspaceCapacityResponse>> getWorkspaceCapacity({
    required String workspaceId,
  }) => guardApiCall(
    () => _api.getWorkspaceCapacity(workspaceId),
    fallbackMessage: 'Nie udało się pobrać pojemności workspace.',
  );

  @override
  Future<Either<ApiError, WorkspaceCapacityResponse>> updateWorkspaceCapacity({
    required String workspaceId,
    required UpdateWorkspaceCapacityPayload payload,
  }) => guardApiCall(
    () => _api.updateWorkspaceCapacity(workspaceId, payload),
    fallbackMessage: 'Nie udało się zapisać pojemności workspace.',
  );

  @override
  Future<Either<ApiError, List<UserCapacityOverrideResponse>>> listOverrides({
    required String workspaceId,
    required String projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => guardApiCall(
    () => _api.listCapacityOverrides(
      workspaceId,
      projectId,
      fromDate: fromDate,
      toDate: toDate,
    ),
    fallbackMessage: 'Nie udało się pobrać wyjątków pojemności projektu.',
  );

  @override
  Future<Either<ApiError, UserCapacityOverrideResponse>> createOverride({
    required String workspaceId,
    required String projectId,
    required CreateUserCapacityOverridePayload payload,
  }) => guardApiCall(
    () => _api.createCapacityOverride(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć wyjątku pojemności.',
  );

  @override
  Future<Either<ApiError, UserCapacityOverrideResponse>> updateOverride({
    required String workspaceId,
    required String projectId,
    required String overrideId,
    required UpdateUserCapacityOverridePayload payload,
  }) => guardApiCall(
    () => _api.updateCapacityOverride(
      workspaceId,
      projectId,
      overrideId,
      payload,
    ),
    fallbackMessage: 'Nie udało się zapisać wyjątku pojemności.',
  );

  @override
  Future<Either<ApiError, Unit>> deleteOverride({
    required String workspaceId,
    required String projectId,
    required String overrideId,
    required int expectedVersion,
  }) => guardApiCall(
    () async {
      await _api.deleteCapacityOverride(
        workspaceId,
        projectId,
        overrideId,
        expectedVersion,
      );
      return unit;
    },
    fallbackMessage: 'Nie udało się usunąć wyjątku pojemności.',
  );

  @override
  Future<Either<ApiError, TaskWorkloadResponse>> getWorkload({
    required String workspaceId,
    required String projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) => guardApiCall(
    () => _api.getWorkload(
      workspaceId,
      projectId,
      fromDate: fromDate,
      toDate: toDate,
    ),
    fallbackMessage: 'Nie udało się pobrać obciążenia zespołu.',
  );
}
