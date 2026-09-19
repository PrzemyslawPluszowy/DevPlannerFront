import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_time_tracking_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';

/// Adapter operacji rejestracji czasu do kontraktu domenowego Tasks.
final class TaskTimeTrackingRepositoryImpl extends ApiRepository
    implements TaskTimeTrackingRepository {
  TaskTimeTrackingRepositoryImpl(this._api);
  final TaskTimeTrackingApi _api;
  @override
  Future<Either<ApiError, List<TaskTimeEntryResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.list(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się pobrać wpisów czasu.',
  );
  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskTimeEntryPayload payload,
  }) => guardApiCall(
    () => _api.create(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się dodać wpisu czasu.',
  );
  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> startTimer({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.startTimer(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się uruchomić timera.',
  );
  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> stopTimer({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required StopTaskTimerPayload payload,
  }) => guardApiCall(
    () => _api.stopTimer(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się zatrzymać timera.',
  );
  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> submit({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  }) => guardApiCall(
    () => _api.submit(workspaceId, projectId, taskId, entryId, payload),
    fallbackMessage: 'Nie udało się przesłać wpisu czasu.',
  );
  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> approve({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  }) => guardApiCall(
    () => _api.approve(workspaceId, projectId, taskId, entryId, payload),
    fallbackMessage: 'Nie udało się zaakceptować wpisu czasu.',
  );
  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> reject({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  }) => guardApiCall(
    () => _api.reject(workspaceId, projectId, taskId, entryId, payload),
    fallbackMessage: 'Nie udało się odrzucić wpisu czasu.',
  );
}
