import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:retrofit/retrofit.dart';

part 'task_schedule_api.g.dart';

/// Klient Retrofit harmonogramu i kaskadowego przesuwania zadań.
@RestApi()
abstract class TaskScheduleApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TaskScheduleApi(Dio dio, {String? baseUrl}) = _TaskScheduleApi;

  /// Pobiera aktualny tryb automatycznego harmonogramu projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/schedule/')
  Future<ProjectScheduleSettingsResponse> getSettings(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Symuluje kaskadę terminów bez zapisu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/schedule/cascade-preview',
  )
  Future<ScheduleCascadeResponse> previewCascade(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() PreviewScheduleCascadePayload body,
  );

  /// Atomowo zapisuje kaskadę terminów.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/schedule/cascade-apply',
  )
  Future<ScheduleCascadeResponse> applyCascade(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() ApplyScheduleCascadePayload body,
  );

  /// Ustawia tryb automatycznego przesuwania następców.
  @PUT('/api/v1/workspaces/{workspaceId}/projects/{projectId}/schedule/mode')
  Future<void> setScheduleMode(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() SetScheduleModePayload body,
  );

  /// Pobiera uporządkowany kalendarz dni wolnych workspace'u.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/schedule/calendar/holidays',
  )
  Future<List<WorkspaceHolidayResponse>> listHolidays(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Dodaje dzień wolny uwzględniany przez harmonogram.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/schedule/calendar/holidays',
  )
  Future<WorkspaceHolidayResponse> addHoliday(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateWorkspaceHolidayPayload body,
  );

  /// Usuwa istniejący dzień wolny workspace'u.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/schedule/calendar/holidays/{holidayId}',
  )
  Future<void> deleteHoliday(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('holidayId') String holidayId,
  );
}
