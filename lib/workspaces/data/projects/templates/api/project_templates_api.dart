import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:retrofit/retrofit.dart';

part 'project_templates_api.g.dart';

/// Klient Retrofit biblioteki szablonów projektów Workspaces.
@RestApi()
abstract class ProjectTemplatesApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory ProjectTemplatesApi(Dio dio, {String? baseUrl}) =
      _ProjectTemplatesApi;

  /// Pobiera skróconą listę szablonów dostępnych w workspace.
  @GET('/api/v1/workspaces/{workspaceId}/project-templates/')
  Future<List<ProjectTemplateResponse>> listTemplates(
    @Path('workspaceId') String workspaceId,
  );

  /// Zapisuje aktualny stan projektu jako nowy szablon.
  @POST(
    '/api/v1/workspaces/{workspaceId}/project-templates/from-project/{projectId}',
  )
  Future<ProjectTemplateResponse> createTemplate(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateProjectTemplatePayload body,
  );

  /// Pobiera pełną konfigurację, workflow i zadania szablonu.
  @GET('/api/v1/workspaces/{workspaceId}/project-templates/{templateId}')
  Future<ProjectTemplateDetailsResponse> getTemplateDetails(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId,
  );

  /// Odświeża szablon aktualnym stanem projektu z kontrolą wersji.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/project-templates/{templateId}/from-project/{projectId}',
  )
  Future<ProjectTemplateDetailsResponse> refreshTemplate(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId,
    @Path('projectId') String projectId,
    @Body() RefreshProjectTemplatePayload body,
  );

  /// Usuwa szablon z podaną oczekiwaną wersją optimistic concurrency.
  @DELETE('/api/v1/workspaces/{workspaceId}/project-templates/{templateId}')
  Future<void> deleteTemplate(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Tworzy nowy projekt na podstawie szablonu i zwraca mapowania identyfikatorów.
  @POST('/api/v1/workspaces/{workspaceId}/project-templates/{templateId}/apply')
  Future<ApplyProjectTemplateResponse> applyTemplate(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId,
    @Body() ApplyProjectTemplatePayload body,
  );
}
