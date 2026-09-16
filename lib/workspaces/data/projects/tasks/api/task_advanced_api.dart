import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:retrofit/retrofit.dart';

part 'task_advanced_api.g.dart';

/// Klient Retrofit zaawansowanych endpointów Tasks.
@RestApi()
abstract class TaskAdvancedApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TaskAdvancedApi(Dio dio, {String? baseUrl}) = _TaskAdvancedApi;

  /// Tworzy serię cykliczną dla zadania głównego.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/recurrence',
  )
  Future<TaskMutationResponse<TaskRecurrenceResponse>> createRecurrence(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() CreateTaskRecurrencePayload body,
  );

  /// Pobiera konfigurację serii cyklicznej zadania.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/recurrence',
  )
  Future<TaskRecurrenceResponse> getRecurrence(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Aktualizuje serię cykliczną z kontrolą wersji.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/recurrence',
  )
  Future<TaskMutationResponse<TaskRecurrenceResponse>> updateRecurrence(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() UpdateTaskRecurrencePayload body,
  );

  /// Wstrzymuje serię cykliczną.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/recurrence/pause',
  )
  Future<TaskMutationResponse<TaskRecurrenceResponse>> pauseRecurrence(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Wznawia serię cykliczną.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/recurrence/resume',
  )
  Future<TaskMutationResponse<TaskRecurrenceResponse>> resumeRecurrence(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Usuwa serię cykliczną.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/recurrence',
  )
  Future<TaskMutationResponse<bool>> deleteRecurrence(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Query('expectedVersion') int? expectedVersion,
  );

  /// Pobiera listę wszystkich reguł cyklicznych w projekcie.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/recurrences',
  )
  Future<List<ProjectTaskRecurrenceItemResponse>> getProjectRecurrences(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Pobiera historię uruchomień zadań cyklicznych w projekcie.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/recurrence-runs',
  )
  Future<List<ProjectTaskRecurrenceRunResponse>> getProjectRecurrenceRuns(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Wywołuje natychmiastowe utworzenie wystąpienia serii.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/recurrence/run-now',
  )
  Future<TaskMutationResponse<TaskRecurrenceResponse>> triggerRecurrenceRunNow(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Pobiera historię biznesową zadania od najnowszego zdarzenia.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/history',
  )
  Future<CursorPageResponse<TaskHistoryEventResponse>> listHistory(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId, {
    @Query('limit') int limit = 50,
    @Query('cursor') String? cursor,
  });

  /// Pobiera workflow statusów projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-workflow/')
  Future<ProjectTaskWorkflowResponse> getWorkflow(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Zastępuje konfigurację workflow projektu.
  @PUT('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-workflow/')
  Future<ProjectTaskWorkflowResponse> updateWorkflow(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() UpdateProjectTaskWorkflowPayload body,
  );

  /// Pobiera timeline zadań projektu w podanym zakresie UTC.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-timeline/')
  Future<TaskTimelineResponse> getTimeline(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Query('fromUtc') DateTime fromUtc,
    @Query('toUtc') DateTime toUtc, {
    @Query('includeUndated') bool includeUndated = false,
    @Query('limit') int limit = 500,
    @Query('cursor') String? cursor,
  });

  /// Pobiera wpisy czasu zadania.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/',
  )
  Future<List<TaskTimeEntryResponse>> listTimeEntries(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );
}
