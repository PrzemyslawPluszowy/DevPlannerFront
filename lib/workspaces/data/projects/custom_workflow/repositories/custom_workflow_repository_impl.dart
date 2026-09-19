import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/api/custom_workflow_api.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';

/// Implementacja kontraktu własnego workflow przez API Workspaces.
final class CustomWorkflowRepositoryImpl extends ApiRepository
    implements CustomWorkflowRepository {
  CustomWorkflowRepositoryImpl(this._api);
  final CustomWorkflowApi _api;
  @override
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> listStatuses({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listStatuses(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać własnych statusów.',
  );
  @override
  Future<Either<ApiError, ProjectCustomStatusResponse>> createStatus({
    required String workspaceId,
    required String projectId,
    required CreateProjectCustomStatusPayload payload,
  }) => guardApiCall(
    () => _api.createStatus(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć statusu.',
  );
  @override
  Future<Either<ApiError, ProjectCustomStatusResponse>> updateStatus({
    required String workspaceId,
    required String projectId,
    required String statusId,
    required UpdateProjectCustomStatusPayload payload,
  }) => guardApiCall(
    () => _api.updateStatus(workspaceId, projectId, statusId, payload),
    fallbackMessage: 'Nie udało się zaktualizować statusu.',
  );
  @override
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> reorderStatuses({
    required String workspaceId,
    required String projectId,
    required ReorderProjectCustomStatusesPayload payload,
  }) => guardApiCall(
    () => _api.reorderStatuses(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zmienić kolejności statusów.',
  );
  @override
  Future<Either<ApiError, AdminMutationResponse>> deleteStatus({
    required String workspaceId,
    required String projectId,
    required String statusId,
    required DeleteProjectCustomStatusPayload payload,
  }) => guardApiCall(
    () => _api.deleteStatus(workspaceId, projectId, statusId, payload),
    fallbackMessage: 'Nie udało się zarchiwizować statusu.',
  );
  @override
  Future<Either<ApiError, List<WorkflowTemplateSummary>>> listTemplates({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listWorkflowTemplates(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać szablonów workflow.',
  );
  @override
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> applyTemplate({
    required String workspaceId,
    required String projectId,
    required ApplyWorkflowTemplatePayload payload,
  }) => guardApiCall(
    () => _api.applyWorkflowTemplate(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zastosować szablonu workflow.',
  );
}
