import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';

/// Mutacje checklisty wydzielone z szerokiego transportu operacji zadania.
abstract interface class TaskChecklistRepository {
  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  addItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskChecklistItemPayload payload,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  updateItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String itemId,
    required UpdateTaskChecklistItemPayload payload,
  });

  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  deleteItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String itemId,
    required int expectedVersion,
  });
}
