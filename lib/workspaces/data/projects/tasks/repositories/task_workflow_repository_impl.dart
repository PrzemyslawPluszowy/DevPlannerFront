import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_advanced_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';

/// Adapter workflow oparty na wydzielonym endpointcie zaawansowanych Tasks.
final class TaskWorkflowRepositoryImpl extends ApiRepository
    implements TaskWorkflowRepository {
  /// Tworzy adapter z uwierzytelnionym klientem endpointów zaawansowanych.
  TaskWorkflowRepositoryImpl(this._api);

  final TaskAdvancedApi _api;

  @override
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> getWorkflow({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getWorkflow(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać workflow projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe workflow projektu.',
  );

  @override
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> updateWorkflow({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskWorkflowPayload payload,
  }) => guardApiCall(
    () => _api.updateWorkflow(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zapisać workflow projektu.',
  );
}
