import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';

/// Operacje współpracy przy zadaniu, bez zależności od stanu prezentacji.
final class TaskDetailsCollaborationService {
  const TaskDetailsCollaborationService({
    required this._repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  });

  final TaskCollaborationRepository _repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  replaceAssignees({
    required List<String> userIds,
    required int expectedVersion,
  }) => _repository.replaceAssignees(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    userIds: userIds.toSet().toList(growable: false),
    expectedVersion: expectedVersion,
  );

  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  toggleWatching({
    required bool isWatched,
    required int expectedVersion,
  }) => (isWatched ? _repository.unfollow : _repository.follow)(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    expectedVersion: expectedVersion,
  );

  Future<Either<ApiError, Unit>> togglePinned({required bool isPinned}) =>
      _repository.updatePinned(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        isPinned: isPinned,
      );
}
