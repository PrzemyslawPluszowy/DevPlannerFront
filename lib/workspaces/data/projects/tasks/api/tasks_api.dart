import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'tasks_api.g.dart';

/// Klient Retrofit podstawowych endpointów zadań projektu Workspaces.
@RestApi()
abstract class TasksApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory TasksApi(Dio dio, {String? baseUrl}) = _TasksApi;

  /// Tworzy zadanie główne albo jednopoziomowe podzadanie.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/')
  Future<TaskMutationResponse<ProjectTaskResponse>> createTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateProjectTaskPayload body,
  );

  /// Szybko tworzy zadanie w projekcie z opcjonalnym zastosowaniem szablonu/formatki.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/quick-create',
  )
  Future<TaskMutationResponse<ProjectTaskResponse>> quickCreateTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() QuickCreateProjectTaskPayload body,
  );

  /// Pobiera cursorową listę zadań projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/')
  Future<CursorPageResponse<ProjectTaskListItemResponse>> listTasks(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('parentTaskId') String? parentTaskId,
    @Query('includeArchived') bool includeArchived = false,
    @Query('limit') int limit = 50,
    @Query('cursor') String? cursor,
    @Query('savedViewId') String? savedViewId,
    @Query('status') String? status,
    @Query('priority') String? priority,
    @Query('assigneeUserId') String? assigneeUserId,
    @Query('myInvolvement') String? myInvolvement,
    @Query('unassignedOnly') bool unassignedOnly = false,
    @Query('search') String? search,
    @Query('dueFromUtc') DateTime? dueFromUtc,
    @Query('dueToUtc') DateTime? dueToUtc,
    @Query('pinnedOnly') bool pinnedOnly = false,
  });

  /// Pobiera grupy z prawdziwymi licznikami oraz osobnym kursorem każdej grupy.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/groups')
  Future<ProjectTaskGroupedListResponse> listTaskGroups(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('groupBy') String? groupBy,
    @Query('groupKey') String? groupKey,
    @Query('parentTaskId') String? parentTaskId,
    @Query('includeArchived') bool includeArchived = false,
    @Query('limit') int limit = 50,
    @Query('cursor') String? cursor,
    @Query('savedViewId') String? savedViewId,
    @Query('status') String? status,
    @Query('priority') String? priority,
    @Query('assigneeUserId') String? assigneeUserId,
    @Query('myInvolvement') String? myInvolvement,
    @Query('unassignedOnly') bool unassignedOnly = false,
    @Query('search') String? search,
    @Query('dueFromUtc') DateTime? dueFromUtc,
    @Query('dueToUtc') DateTime? dueToUtc,
    @Query('pinnedOnly') bool pinnedOnly = false,
  });

  /// Pobiera snapshot Gantta projektu wraz z relacjami zależności.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/task-timeline/')
  Future<TaskTimelineResponse> getTimeline(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('fromUtc') required DateTime fromUtc,
    @Query('toUtc') required DateTime toUtc,
    @Query('includeUndated') bool includeUndated = false,
    @Query('limit') int limit = 500,
    @Query('cursor') String? cursor,
  });

  /// Pobiera pełne dane zadania, checklistę i wykonawców.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}')
  Future<ProjectTaskDetailsResponse> getTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/selection-token',
  )
  Future<TaskSelectionTokenResponse> createTaskSelectionToken(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateTaskSelectionTokenPayload body,
  );

  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/selection-token/bulk',
  )
  Future<BulkUpdateTaskSelectionResponse> bulkUpdateTaskSelection(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() BulkUpdateTaskSelectionPayload body,
  );

  /// Aktualizuje zadanie z kontrolą optimistic concurrency.
  @PATCH('/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}')
  Future<TaskMutationResponse<ProjectTaskResponse>> updateTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() UpdateProjectTaskPayload body,
  );

  /// Aktualizuje pola dostępne bezpośrednio w zwartej liście.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/list-item',
  )
  Future<TaskMutationResponse<ProjectTaskListItemResponse>> updateListItem(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() UpdateTaskListItemPayload body,
  );

  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/move',
  )
  Future<MovedProjectTaskResponse> moveTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() MoveProjectTaskPayload body,
  );

  /// Archiwizuje zadanie bez usuwania jego historii.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/archive',
  )
  Future<TaskMutationResponse<ProjectTaskResponse>> archiveTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Przywraca zarchiwizowane zadanie do aktywnej listy projektu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/restore',
  )
  Future<TaskMutationResponse<ProjectTaskResponse>> restoreTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Zapisuje pełną kolejność jednej gałęzi zadań.
  @PUT('/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/order')
  Future<List<ReorderedTaskVersionResponse>> reorderTasks(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() ReorderProjectTasksPayload body,
  );

  /// Pobiera zależności zadania.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/dependencies',
  )
  Future<List<TaskDependencyResponse>> listDependencies(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
  );

  /// Dodaje zależność do innego zadania tego samego projektu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/dependencies',
  )
  Future<TaskMutationResponse<TaskDependencyResponse>> createDependency(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() CreateTaskDependencyPayload body,
  );

  /// Aktualizuje parametry Gantta zależności z kontrolą wersji źródła.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/dependencies/{dependencyId}',
  )
  Future<TaskMutationResponse<TaskDependencyResponse>> updateDependency(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('dependencyId') String dependencyId,
    @Body() UpdateTaskDependencyPayload body,
  );

  /// Usuwa zależność i zwraca nową wersję zadania.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/dependencies/{dependencyId}',
  )
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  deleteDependency(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Path('dependencyId') String dependencyId,
    @Query('expectedVersion') int expectedVersion,
  );
}
