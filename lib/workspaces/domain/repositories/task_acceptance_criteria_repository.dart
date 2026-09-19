import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';

/// Atomowe mutacje kryteriów akceptacji zadania.
abstract interface class TaskAcceptanceCriteriaRepository {
  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskAcceptanceCriterionPayload payload,
  });

  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  update({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String criterionId,
    required UpdateTaskAcceptanceCriterionPayload payload,
  });

  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  delete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String criterionId,
    required int expectedVersion,
  });
}
