import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';

/// Transport i walidacja mutacji checklisty zadania.
///
/// Serwis nie zna stanu Cubita ani sposobu prezentacji wyników. Dzięki temu
/// Cubit pozostaje właścicielem jedynie przejść stanu i scalenia odpowiedzi.
final class TaskDetailsChecklistService {
  const TaskDetailsChecklistService({
    required this._repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  });

  final TaskChecklistRepository _repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  add({
    required String title,
    required int expectedVersion,
  }) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Tytuł pozycji checklisty nie może być pusty.',
          ),
        ),
      );
    }
    return _repository.addItem(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: CreateTaskChecklistItemPayload(
        title: normalizedTitle,
        expectedVersion: expectedVersion,
      ),
    );
  }

  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  update({
    required TaskChecklistItemResponse item,
    required int expectedVersion,
    String? title,
    bool? isCompleted,
  }) {
    final normalizedTitle = (title ?? item.title).trim();
    if (normalizedTitle.isEmpty) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Tytuł pozycji checklisty nie może być pusty.',
          ),
        ),
      );
    }
    return _repository.updateItem(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      itemId: item.id,
      payload: UpdateTaskChecklistItemPayload(
        title: normalizedTitle,
        position: item.position,
        isCompleted: isCompleted ?? item.isCompleted,
        expectedVersion: expectedVersion,
      ),
    );
  }

  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  delete({
    required TaskChecklistItemResponse item,
    required int expectedVersion,
  }) => _repository.deleteItem(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    itemId: item.id,
    expectedVersion: expectedVersion,
  );
}
