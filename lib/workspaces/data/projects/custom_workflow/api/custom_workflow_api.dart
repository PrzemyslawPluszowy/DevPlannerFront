import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:retrofit/retrofit.dart';

part 'custom_workflow_api.g.dart';

/// Klient Retrofit własnych statusów workflow projektu.
@RestApi()
abstract class CustomWorkflowApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory CustomWorkflowApi(Dio dio, {String? baseUrl}) = _CustomWorkflowApi;

  /// Pobiera aktywne statusy workflow projektu.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/custom-workflow/statuses',
  )
  Future<List<ProjectCustomStatusResponse>> listStatuses(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy własny status workflow projektu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/custom-workflow/statuses',
  )
  Future<ProjectCustomStatusResponse> createStatus(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateProjectCustomStatusPayload body,
  );

  /// Aktualizuje własny status z kontrolą oczekiwanej wersji.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/custom-workflow/statuses/{statusId}',
  )
  Future<ProjectCustomStatusResponse> updateStatus(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('statusId') String statusId,
    @Body() UpdateProjectCustomStatusPayload body,
  );

  /// Zapisuje pełną kolejność własnych statusów projektu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/custom-workflow/statuses/reorder',
  )
  Future<List<ProjectCustomStatusResponse>> reorderStatuses(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() ReorderProjectCustomStatusesPayload body,
  );

  /// Archiwizuje status i przenosi jego zadania do statusu zastępczego.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/custom-workflow/statuses/{statusId}',
  )
  Future<AdminMutationResponse> deleteStatus(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('statusId') String statusId,
    @Body() DeleteProjectCustomStatusPayload body,
  );

  /// Pobiera katalog gotowych szablonów workflow.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/custom-workflow/templates',
  )
  Future<List<WorkflowTemplateSummary>> listWorkflowTemplates(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Zastosowuje gotowy szablon workflow w projekcie.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/custom-workflow/templates/apply',
  )
  Future<List<ProjectCustomStatusResponse>> applyWorkflowTemplate(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() ApplyWorkflowTemplatePayload body,
  );
}
