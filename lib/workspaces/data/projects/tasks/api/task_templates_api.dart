import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'task_templates_api.g.dart';

/// Klient Retrofit biblioteki szablonów zadań.
@RestApi()
abstract class TaskTemplatesApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TaskTemplatesApi(Dio dio, {String? baseUrl}) = _TaskTemplatesApi;

  /// Pobiera szablony zadań workspace.
  @GET('/api/v1/workspaces/{workspaceId}/task-templates/')
  Future<List<TaskTemplateResponse>> list(
    @Path('workspaceId') String workspaceId,
  );

  /// Zapisuje aktywne zadanie jako szablon.
  @POST('/api/v1/workspaces/{workspaceId}/task-templates/from-task/{taskId}')
  Future<TaskTemplateResponse> create(
    @Path('workspaceId') String workspaceId,
    @Path('taskId') String taskId,
    @Body() CreateTaskTemplatePayload body,
  );

  /// Tworzy nowy szablon zadania od zera.
  @POST('/api/v1/workspaces/{workspaceId}/task-templates/')
  Future<TaskTemplateResponse> createFromDefinition(
    @Path('workspaceId') String workspaceId,
    @Body() CreateTaskTemplateDefinitionPayload body,
  );

  /// Pobiera pełne szczegóły szablonu.
  @GET('/api/v1/workspaces/{workspaceId}/task-templates/{templateId}')
  Future<TaskTemplateDetailsResponse> getDetails(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId,
  );

  /// Aktualizuje pełną konfigurację szablonu.
  @PUT('/api/v1/workspaces/{workspaceId}/task-templates/{templateId}')
  Future<TaskTemplateDetailsResponse> update(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId,
    @Body() UpdateTaskTemplatePayload body,
  );

  /// Usuwa szablon zadania.
  @DELETE('/api/v1/workspaces/{workspaceId}/task-templates/{templateId}')
  Future<void> delete(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId, {
    @Query('expectedVersion') required int expectedVersion,
  });

  /// Tworzy zadanie na podstawie szablonu.
  @POST('/api/v1/workspaces/{workspaceId}/task-templates/{templateId}/apply')
  Future<ProjectTaskResponse> apply(
    @Path('workspaceId') String workspaceId,
    @Path('templateId') String templateId,
    @Body() ApplyTaskTemplatePayload body,
  );

  /// Pobiera osobisty domyślny szablon zadania.
  @GET('/api/v1/workspaces/{workspaceId}/task-templates/me/default')
  Future<DefaultTaskTemplateResponse> getDefault(
    @Path('workspaceId') String workspaceId,
  );

  /// Ustawia albo czyści osobisty domyślny szablon zadania.
  @PUT('/api/v1/workspaces/{workspaceId}/task-templates/me/default')
  Future<DefaultTaskTemplateResponse> setDefault(
    @Path('workspaceId') String workspaceId,
    @Body() SetDefaultTaskTemplatePayload body,
  );
}
