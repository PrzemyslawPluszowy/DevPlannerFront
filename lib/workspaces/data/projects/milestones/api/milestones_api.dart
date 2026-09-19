import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'milestones_api.g.dart';

/// Klient Retrofit endpointów kamieni milowych projektu Workspaces.
@RestApi()
abstract class MilestonesApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory MilestonesApi(Dio dio, {String? baseUrl}) = _MilestonesApi;

  /// Pobiera wszystkie kamienie milowe projektu wraz z postępem i statusem.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/')
  Future<List<MilestoneResponse>> listMilestones(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy kamień milowy w projekcie.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/')
  Future<MilestoneResponse> createMilestone(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateMilestonePayload body,
  );

  /// Pobiera szczegóły jednego kamienia milowego.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/{milestoneId}',
  )
  Future<MilestoneResponse> getMilestone(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('milestoneId') String milestoneId,
  );

  /// Aktualizuje dane i status kamienia milowego.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/{milestoneId}',
  )
  Future<MilestoneResponse> updateMilestone(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('milestoneId') String milestoneId,
    @Body() UpdateMilestonePayload body,
  );

  /// Usuwa kamień milowy, jeśli nie ma aktywnych powiązań blokujących usunięcie.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/{milestoneId}',
  )
  Future<void> deleteMilestone(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('milestoneId') String milestoneId,
  );

  /// Pobiera aktywne zadania przypisane do kamienia milowego.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/{milestoneId}/tasks',
  )
  Future<List<MilestoneTaskResponse>> listMilestoneTasks(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('milestoneId') String milestoneId,
  );

  /// Przypisuje zadanie projektu do kamienia milowego.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/{milestoneId}/tasks/{taskId}',
  )
  Future<void> assignTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('milestoneId') String milestoneId,
    @Path('taskId') String taskId,
  );

  /// Usuwa przypisanie zadania z kamienia milowego.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/milestones/{milestoneId}/tasks/{taskId}',
  )
  Future<void> unassignTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('milestoneId') String milestoneId,
    @Path('taskId') String taskId,
  );
}
