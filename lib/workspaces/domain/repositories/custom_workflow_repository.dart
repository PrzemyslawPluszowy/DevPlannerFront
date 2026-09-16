import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';

/// Operacje własnych kolumn i szablonów workflow projektu.
abstract interface class CustomWorkflowRepository {
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> listStatuses({
    required String workspaceId,
    required String projectId,
  });
  Future<Either<ApiError, ProjectCustomStatusResponse>> createStatus({
    required String workspaceId,
    required String projectId,
    required CreateProjectCustomStatusPayload payload,
  });
  Future<Either<ApiError, ProjectCustomStatusResponse>> updateStatus({
    required String workspaceId,
    required String projectId,
    required String statusId,
    required UpdateProjectCustomStatusPayload payload,
  });
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> reorderStatuses({
    required String workspaceId,
    required String projectId,
    required ReorderProjectCustomStatusesPayload payload,
  });
  Future<Either<ApiError, AdminMutationResponse>> deleteStatus({
    required String workspaceId,
    required String projectId,
    required String statusId,
    required DeleteProjectCustomStatusPayload payload,
  });
  Future<Either<ApiError, List<WorkflowTemplateSummary>>> listTemplates({
    required String workspaceId,
    required String projectId,
  });
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> applyTemplate({
    required String workspaceId,
    required String projectId,
    required ApplyWorkflowTemplatePayload payload,
  });
}
