import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:retrofit/retrofit.dart';

part 'task_views_api.g.dart';

/// Klient Retrofit zapisanych widoków, listy własnych zadań i wyszukiwania.
@RestApi()
abstract class TaskViewsApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TaskViewsApi(Dio dio, {String? baseUrl}) = _TaskViewsApi;

  /// Pobiera prywatne widoki projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-views/')
  Future<List<TaskSavedViewResponse>> listViews(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy prywatny widok projektu.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-views/')
  Future<TaskSavedViewResponse> createView(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateTaskSavedViewPayload body,
  );

  /// Aktualizuje prywatny widok projektu.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-views/{viewId}',
  )
  Future<TaskSavedViewResponse> updateView(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('viewId') String viewId,
    @Body() UpdateTaskSavedViewPayload body,
  );

  /// Usuwa prywatny widok projektu.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-views/{viewId}',
  )
  Future<void> deleteView(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('viewId') String viewId,
  );

  /// Pobiera przekrojową listę zadań bieżącego użytkownika.
  @GET('/api/v1/me/tasks/')
  Future<CursorPageResponse<MyTaskListItemResponse>> listMyTasks({
    @Query('limit') int limit = 50,
    @Query('cursor') String? cursor,
    @Query('involvement') String? involvement,
    @Query('status') String? status,
    @Query('priority') String? priority,
    @Query('dueFromUtc') DateTime? dueFromUtc,
    @Query('dueToUtc') DateTime? dueToUtc,
  });

  /// Wyszukuje zadania globalnie w dostępnych projektach.
  @GET('/api/v1/tasks/search')
  Future<CursorPageResponse<GlobalTaskSearchItemResponse>> searchTasks(
    @Query('query') String query, {
    @Query('workspaceId') String? workspaceId,
    @Query('projectId') String? projectId,
    @Query('status') String? status,
    @Query('limit') int limit = 50,
    @Query('cursor') String? cursor,
  });
}
