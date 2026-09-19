import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';

/// Adapter operacji obserwowania taska oparty na kontrakcie Tasks.
final class TaskCollaborationRepositoryImpl extends ApiRepository
    implements TaskCollaborationRepository {
  /// Tworzy adapter z uwierzytelnionym klientem operacji taska.
  TaskCollaborationRepositoryImpl(this._api);

  final TaskOperationsApi _api;

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  replaceAssignees({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required List<String> userIds,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.replaceAssignees(
      workspaceId,
      projectId,
      taskId,
      UpdateTaskAssigneesPayload(
        userIds: userIds,
        expectedVersion: expectedVersion,
      ),
    ),
    fallbackMessage: 'Nie udało się zmienić wykonawców zadania.',
  );

  @override
  Future<Either<ApiError, List<TaskWatcherResponse>>> listWatchers({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.listWatchers(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się pobrać obserwatorów zadania.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę obserwatorów.',
  );

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  follow({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.followTask(workspaceId, projectId, taskId, expectedVersion),
    fallbackMessage: 'Nie udało się rozpocząć obserwowania zadania.',
  );

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  unfollow({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.unfollowTask(workspaceId, projectId, taskId, expectedVersion),
    fallbackMessage: 'Nie udało się zakończyć obserwowania zadania.',
  );

  @override
  Future<Either<ApiError, Unit>> updatePinned({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required bool isPinned,
  }) async {
    final result = await guardApiCall<void>(
      () => _api.updateTaskPreference(
        workspaceId,
        projectId,
        taskId,
        UpdateTaskUserPreferencePayload(isPinned: isPinned),
      ),
      fallbackMessage: 'Nie udało się zmienić przypięcia zadania.',
    );
    return result.map((_) => unit);
  }
}
