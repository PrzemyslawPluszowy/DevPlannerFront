import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:retrofit/retrofit.dart';

part 'task_capacity_api.g.dart';

/// Klient Retrofit konfiguracji capacity i workloadu Tasks.
@RestApi()
abstract class TaskCapacityApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TaskCapacityApi(Dio dio, {String? baseUrl}) = _TaskCapacityApi;

  /// Pobiera domyślną dzienną pojemność workspace.
  @GET('/api/v1/workspaces/{workspaceId}/capacity/')
  Future<WorkspaceCapacityResponse> getWorkspaceCapacity(
    @Path('workspaceId') String workspaceId,
  );

  /// Ustawia domyślną dzienną pojemność workspace.
  @PUT('/api/v1/workspaces/{workspaceId}/capacity/')
  Future<WorkspaceCapacityResponse> updateWorkspaceCapacity(
    @Path('workspaceId') String workspaceId,
    @Body() UpdateWorkspaceCapacityPayload body,
  );

  /// Pobiera override'y capacity projektu w zakresie dat.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/capacity-overrides/',
  )
  Future<List<UserCapacityOverrideResponse>> listCapacityOverrides(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('fromDate') DateTime? fromDate,
    @Query('toDate') DateTime? toDate,
  });

  /// Tworzy override capacity użytkownika.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/capacity-overrides/',
  )
  Future<UserCapacityOverrideResponse> createCapacityOverride(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateUserCapacityOverridePayload body,
  );

  /// Aktualizuje override capacity z kontrolą wersji.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/capacity-overrides/{overrideId}',
  )
  Future<UserCapacityOverrideResponse> updateCapacityOverride(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('overrideId') String overrideId,
    @Body() UpdateUserCapacityOverridePayload body,
  );

  /// Usuwa override capacity po oczekiwanej wersji.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/capacity-overrides/{overrideId}',
  )
  Future<void> deleteCapacityOverride(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('overrideId') String overrideId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Pobiera agregaty workloadu zespołu projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/workload')
  Future<TaskWorkloadResponse> getWorkload(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('fromDate') DateTime? fromDate,
    @Query('toDate') DateTime? toDate,
  });
}
