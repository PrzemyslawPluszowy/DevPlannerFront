import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_advanced_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';

/// Adapter endpointów cykliczności do niezależnego kontraktu domenowego.
final class TaskRecurrenceRepositoryImpl extends ApiRepository
    implements TaskRecurrenceRepository {
  TaskRecurrenceRepositoryImpl(this._api);

  final TaskAdvancedApi _api;

  @override
  Future<Either<ApiError, TaskRecurrenceResponse>> get({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.getRecurrence(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się pobrać cykliczności zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskRecurrencePayload payload,
  }) => guardApiCall(
    () => _api.createRecurrence(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się utworzyć cykliczności zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  update({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskRecurrencePayload payload,
  }) => guardApiCall(
    () => _api.updateRecurrence(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się zapisać cykliczności zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>> pause({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.pauseRecurrence(
      workspaceId,
      projectId,
      taskId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się wstrzymać cykliczności zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  resume({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.resumeRecurrence(
      workspaceId,
      projectId,
      taskId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się wznowić cykliczności zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<bool>>> delete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    int? expectedVersion,
  }) => guardApiCall(
    () => _api.deleteRecurrence(
      workspaceId,
      projectId,
      taskId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się usunąć cykliczności zadania.',
  );

  @override
  Future<Either<ApiError, List<ProjectTaskRecurrenceItemResponse>>>
  getProjectRecurrences({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getProjectRecurrences(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać listy cykliczności w projekcie.',
  );

  @override
  Future<Either<ApiError, List<ProjectTaskRecurrenceRunResponse>>>
  getProjectRecurrenceRuns({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getProjectRecurrenceRuns(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać historii wykonań cykliczności.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  triggerRunNow({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.triggerRecurrenceRunNow(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się wywołać natychmiastowego cyklu zadania.',
  );
}
