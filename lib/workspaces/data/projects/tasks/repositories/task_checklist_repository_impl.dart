import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_checklist_repository.dart';

final class TaskChecklistRepositoryImpl extends ApiRepository
    implements TaskChecklistRepository {
  TaskChecklistRepositoryImpl(this._api);

  final TaskOperationsApi _api;

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  addItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskChecklistItemPayload payload,
  }) => guardApiCall(
    () => _api.addChecklistItem(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się dodać pozycji checklisty.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  updateItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String itemId,
    required UpdateTaskChecklistItemPayload payload,
  }) => guardApiCall(
    () => _api.updateChecklistItem(
      workspaceId,
      projectId,
      taskId,
      itemId,
      payload,
    ),
    fallbackMessage: 'Nie udało się zaktualizować pozycji checklisty.',
  );

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  deleteItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String itemId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.deleteChecklistItem(
      workspaceId,
      projectId,
      taskId,
      itemId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się usunąć pozycji checklisty.',
  );
}
