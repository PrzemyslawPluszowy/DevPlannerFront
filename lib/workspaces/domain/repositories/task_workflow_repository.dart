import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';

/// Odczyt konfiguracji przejść workflow projektu dla ekranów Tasks.
abstract interface class TaskWorkflowRepository {
  /// Pobiera statusy i dozwolone przejścia aktualnego projektu.
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> getWorkflow({
    required String workspaceId,
    required String projectId,
  });

  /// Zastępuje pełną konfigurację statusów i przejść workflow projektu.
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> updateWorkflow({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskWorkflowPayload payload,
  });
}
