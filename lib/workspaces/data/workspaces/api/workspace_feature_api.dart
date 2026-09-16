import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_feature_enums.dart';
import 'package:ready_next/workspaces/data/workspaces/models/workspace_feature_models.dart';
import 'package:retrofit/retrofit.dart';

part 'workspace_feature_api.g.dart';

/// Klient Retrofit dashboardów, aktywności, wyszukiwania i synchronizacji.
@RestApi()
abstract class WorkspaceFeatureApi {
  /// Tworzy klienta dodatkowych endpointów Workspaces.
  factory WorkspaceFeatureApi(Dio dio, {String? baseUrl}) =
      _WorkspaceFeatureApi;

  /// Pobiera preferencje dashboardu użytkownika.
  @GET('/api/v1/workspaces/{workspaceId}/dashboard/preferences/')
  Future<DashboardPreferenceResponse> getDashboardPreferences(
    @Path('workspaceId') String workspaceId, {
    @Query('context') DashboardContextKind? context,
    @Query('projectId') String? projectId,
  });

  /// Zapisuje layout dashboardu z kontrolą wersji.
  @PUT('/api/v1/workspaces/{workspaceId}/dashboard/preferences/')
  Future<DashboardPreferenceResponse> updateDashboardPreferences(
    @Path('workspaceId') String workspaceId,
    @Body() UpdateDashboardPreferencePayload payload, {
    @Query('context') DashboardContextKind? context,
    @Query('projectId') String? projectId,
  });

  /// Wyszukuje globalnie zadania, projekty, Wiki, pliki, whiteboardy i Chat.
  @GET('/api/v1/workspaces/{workspaceId}/search')
  Future<GlobalSearchResponse> search(
    @Path('workspaceId') String workspaceId,
    @Query('q') String query, {
    @Query('limit') int? limit,
  });

  /// Pobiera osobisty pulpit workspace.
  @GET('/api/v1/workspaces/{workspaceId}/home')
  Future<HomeDashboardResponse> getHome(
    @Path('workspaceId') String workspaceId,
  );

  /// Pobiera osobisty dashboard użytkownika.
  @GET('/api/v1/workspaces/{workspaceId}/dashboard/me')
  Future<HomeDashboardResponse> getPersonalDashboard(
    @Path('workspaceId') String workspaceId,
  );

  /// Pobiera dashboard projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/dashboard')
  Future<ProjectDashboardResponse> getProjectDashboard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Pobiera strumień aktywności workspace.
  @GET('/api/v1/workspaces/{workspaceId}/activity')
  Future<WorkspaceActivityPageResponse> listActivity(
    @Path('workspaceId') String workspaceId, {
    @Query('projectId') String? projectId,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Pobiera linki synchronizacji źródeł Wiki/Whiteboard z zadaniami.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-sync/links')
  Future<List<CrossModuleSyncLinkResponse>> listSyncLinks(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('taskId') String? taskId,
  });

  /// Tworzy link synchronizacji źródło–zadanie.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-sync/links')
  Future<CrossModuleSyncLinkResponse> createSyncLink(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateCrossModuleSyncLinkPayload payload,
  );

  /// Wstrzymuje albo wznawia propagację linku synchronizacji.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-sync/links/{linkId}',
  )
  Future<CrossModuleSyncLinkResponse> setSyncLinkState(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('linkId') String linkId,
    @Body() SetCrossModuleSyncLinkStatePayload payload,
  );
}
