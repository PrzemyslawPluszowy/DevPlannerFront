import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Ładuje pełny agregat szczegółów zadania z jednego typowanego repository.
final class TaskDetailsLoaderService {
  const TaskDetailsLoaderService({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  });

  final TasksRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<Either<ApiError, ProjectTaskDetailsResponse>> load() =>
      repository.getTask(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );

  Future<TaskDetailsState> loadState() async {
    final result = await load();
    return result.fold(
      (error) => TaskDetailsFailure(
        kind: switch (error.type) {
          ApiErrorType.forbidden ||
          ApiErrorType.unauthorized => TaskDetailsFailureKind.forbidden,
          ApiErrorType.notFound => TaskDetailsFailureKind.notFound,
          ApiErrorType.conflict => TaskDetailsFailureKind.conflict,
          ApiErrorType.connection ||
          ApiErrorType.connectionTimeout ||
          ApiErrorType.sendTimeout ||
          ApiErrorType.receiveTimeout => TaskDetailsFailureKind.offline,
          _ => TaskDetailsFailureKind.other,
        },
        message: error.message,
        backendCode: error.backendCode,
      ),
      TaskDetailsReady.new,
    );
  }
}
