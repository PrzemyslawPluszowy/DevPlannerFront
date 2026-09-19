import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';

final class TaskAcceptanceCriteriaRepositoryImpl extends ApiRepository
    implements TaskAcceptanceCriteriaRepository {
  TaskAcceptanceCriteriaRepositoryImpl(this._api);

  final TaskOperationsApi _api;

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskAcceptanceCriterionPayload payload,
  }) => guardApiCall(
    () => _api.createAcceptanceCriterion(
      workspaceId,
      projectId,
      taskId,
      payload,
    ),
    fallbackMessage: 'Nie udało się dodać kryterium akceptacji.',
  );

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  update({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String criterionId,
    required UpdateTaskAcceptanceCriterionPayload payload,
  }) => guardApiCall(
    () => _api.updateAcceptanceCriterion(
      workspaceId,
      projectId,
      taskId,
      criterionId,
      payload,
    ),
    fallbackMessage: 'Nie udało się zaktualizować kryterium akceptacji.',
  );

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  delete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String criterionId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.deleteAcceptanceCriterion(
      workspaceId,
      projectId,
      taskId,
      criterionId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się usunąć kryterium akceptacji.',
  );
}
