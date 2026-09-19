import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'task_time_tracking_api.g.dart';

/// Klient Retrofit rejestracji i akceptacji czasu pracy zadania.
@RestApi()
abstract class TaskTimeTrackingApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TaskTimeTrackingApi(Dio dio, {String? baseUrl}) =
      _TaskTimeTrackingApi;

  /// Pobiera wpisy czasu zadania.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/',
  )
  Future<List<TaskTimeEntryResponse>> list(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Dodaje ręczny wpis czasu pracy.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/',
  )
  Future<TaskTimeEntryResponse> create(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() CreateTaskTimeEntryPayload body,
  );

  /// Uruchamia timer bieżącego użytkownika.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/timer/start',
  )
  Future<TaskTimeEntryResponse> startTimer(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Zatrzymuje aktywny timer.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/timer/stop',
  )
  Future<TaskTimeEntryResponse> stopTimer(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() StopTaskTimerPayload body,
  );

  /// Przesyła wpis czasu do akceptacji.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/{entryId}/submit',
  )
  Future<TaskTimeEntryResponse> submit(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('entryId') String entryId,
    @Body() TimeEntryWorkflowPayload body,
  );

  /// Akceptuje wpis czasu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/{entryId}/approve',
  )
  Future<TaskTimeEntryResponse> approve(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('entryId') String entryId,
    @Body() TimeEntryWorkflowPayload body,
  );

  /// Odrzuca wpis czasu z opcjonalnym komentarzem.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/time-entries/{entryId}/reject',
  )
  Future<TaskTimeEntryResponse> reject(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('entryId') String entryId,
    @Body() TimeEntryWorkflowPayload body,
  );
}
