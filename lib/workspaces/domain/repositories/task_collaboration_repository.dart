import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';

/// Operacje współpracy wykonywane przez bieżącego użytkownika przy zadaniu.
abstract interface class TaskCollaborationRepository {
  /// Atomowo zastępuje pełną listę wykonawców zadania.
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  replaceAssignees({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required List<String> userIds,
    required int expectedVersion,
  });

  /// Pobiera aktualną listę obserwatorów zadania.
  Future<Either<ApiError, List<TaskWatcherResponse>>> listWatchers({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });

  /// Dodaje bieżącego użytkownika do obserwatorów zadania.
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  follow({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  });

  /// Usuwa bieżącego użytkownika z obserwatorów zadania.
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  unfollow({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  });

  /// Zmienia osobiste przypięcie zadania bieżącego użytkownika.
  Future<Either<ApiError, Unit>> updatePinned({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required bool isPinned,
  });
}
