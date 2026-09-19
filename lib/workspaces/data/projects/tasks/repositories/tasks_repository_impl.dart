import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/tasks_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';

/// Implementacja podstawowych operacji Tasks oparta na kontrakcie OpenAPI.
final class TasksRepositoryImpl extends ApiRepository
    implements TasksRepository {
  TasksRepositoryImpl(this._api);

  final TasksApi _api;

  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) => guardApiCall(
    () => _api.listTasks(
      workspaceId,
      projectId,
      parentTaskId: query.parentTaskId,
      includeArchived: query.includeArchived,
      limit: query.limit,
      cursor: query.cursor,
      savedViewId: query.savedViewId,
      status: query.status,
      priority: query.priority,
      assigneeUserId: query.assigneeUserId,
      myInvolvement: query.myInvolvement,
      unassignedOnly: query.unassignedOnly,
      search: query.search,
      dueFromUtc: query.dueFromUtc,
      dueToUtc: query.dueToUtc,
      pinnedOnly: query.pinnedOnly,
    ),
    fallbackMessage: 'Nie udało się pobrać zadań projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową stronę zadań.',
  );

  @override
  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  }) => guardApiCall(
    () => _api.listTaskGroups(
      workspaceId,
      projectId,
      groupBy: query.groupBy,
      groupKey: query.groupKey,
      parentTaskId: query.parentTaskId,
      includeArchived: query.includeArchived,
      limit: query.limit,
      cursor: query.cursor,
      savedViewId: query.savedViewId,
      status: query.status,
      priority: query.priority,
      assigneeUserId: query.assigneeUserId,
      myInvolvement: query.myInvolvement,
      unassignedOnly: query.unassignedOnly,
      search: query.search,
      dueFromUtc: query.dueFromUtc,
      dueToUtc: query.dueToUtc,
      pinnedOnly: query.pinnedOnly,
    ),
    fallbackMessage: 'Nie udało się pobrać grup zadań projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe grupy zadań.',
  );

  @override
  Future<Either<ApiError, TaskSelectionTokenResponse>>
  createTaskSelectionToken({
    required String workspaceId,
    required String projectId,
    required CreateTaskSelectionTokenPayload payload,
  }) => guardApiCall(
    () => _api.createTaskSelectionToken(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć tokenu zaznaczenia Tasks.',
    parsingMessage: 'Backend zwrócił nieprawidłowy token zaznaczenia.',
  );

  @override
  Future<Either<ApiError, BulkUpdateTaskSelectionResponse>>
  bulkUpdateTaskSelection({
    required String workspaceId,
    required String projectId,
    required BulkUpdateTaskSelectionPayload payload,
  }) => guardApiCall(
    () => _api.bulkUpdateTaskSelection(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zbiorczo zaktualizować Tasks.',
    parsingMessage: 'Backend zwrócił nieprawidłowy wynik bulk Tasks.',
  );

  @override
  Future<Either<ApiError, TaskTimelineResponse>> getProjectTimeline({
    required String workspaceId,
    required String projectId,
    required ProjectTaskTimelineQuery query,
  }) => guardApiCall(
    () => _api.getTimeline(
      workspaceId,
      projectId,
      fromUtc: query.fromUtc,
      toUtc: query.toUtc,
      includeUndated: query.includeUndated,
      limit: query.limit,
      cursor: query.cursor,
    ),
    fallbackMessage: 'Nie udało się pobrać osi czasu projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową oś czasu projektu.',
  );

  @override
  Future<Either<ApiError, ProjectTaskDetailsResponse>> getTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.getTask(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się pobrać szczegółów zadania.',
    parsingMessage: 'Backend zwrócił nieprawidłowe szczegóły zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  createTask({
    required String workspaceId,
    required String projectId,
    required CreateProjectTaskPayload payload,
  }) => guardApiCall(
    () => _api.createTask(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  }) => guardApiCall(
    () => _api.quickCreateTask(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  updateTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateProjectTaskPayload payload,
  }) => guardApiCall(
    () => _api.updateTask(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się zaktualizować zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskListItemResponse>>>
  updateListItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskListItemPayload payload,
  }) => guardApiCall(
    () => _api.updateListItem(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się zapisać pola zadania.',
  );

  @override
  Future<Either<ApiError, MovedProjectTaskResponse>> moveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required MoveProjectTaskPayload payload,
  }) => guardApiCall(
    () => _api.moveTask(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się przenieść zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  archiveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.archiveTask(
      workspaceId,
      projectId,
      taskId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się zarchiwizować zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  restoreTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.restoreTask(
      workspaceId,
      projectId,
      taskId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się przywrócić zadania.',
  );

  @override
  Future<Either<ApiError, List<ReorderedTaskVersionResponse>>> reorderTasks({
    required String workspaceId,
    required String projectId,
    required ReorderProjectTasksPayload payload,
  }) => guardApiCall(
    () => _api.reorderTasks(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zapisać kolejności zadań.',
  );

  @override
  Future<Either<ApiError, List<TaskDependencyResponse>>> listDependencies({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.listDependencies(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się pobrać zależności zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  createDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskDependencyPayload payload,
  }) => guardApiCall(
    () => _api.createDependency(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się utworzyć zależności zadania.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  updateDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String dependencyId,
    required UpdateTaskDependencyPayload payload,
  }) => guardApiCall(
    () => _api.updateDependency(
      workspaceId,
      projectId,
      taskId,
      dependencyId,
      payload,
    ),
    fallbackMessage: 'Nie udało się zaktualizować parametrów zależności.',
  );

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  deleteDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String dependencyId,
    required int expectedVersion,
  }) => guardApiCall(
    () => _api.deleteDependency(
      workspaceId,
      projectId,
      taskId,
      dependencyId,
      expectedVersion,
    ),
    fallbackMessage: 'Nie udało się usunąć zależności zadania.',
  );
}
