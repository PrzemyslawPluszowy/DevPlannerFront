import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_views_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';

/// Implementacja HTTP prywatnych widoków Tasks.
final class TaskViewRepositoryImpl extends ApiRepository
    implements TaskViewRepository {
  TaskViewRepositoryImpl(this._api);

  final TaskViewsApi _api;

  @override
  Future<Either<ApiError, CursorPageResponse<MyTaskListItemResponse>>>
  listMyTasks({MyTasksQuery query = const MyTasksQuery()}) => guardApiCall(
    () => _api.listMyTasks(
      limit: query.limit,
      cursor: query.cursor,
      involvement: query.involvement,
      status: query.status,
      priority: query.priority,
      dueFromUtc: query.dueFromUtc,
      dueToUtc: query.dueToUtc,
    ),
    fallbackMessage: 'Nie udało się pobrać moich zadań.',
  );

  @override
  Future<Either<ApiError, CursorPageResponse<GlobalTaskSearchItemResponse>>>
  searchTasks({
    required String query,
    String? workspaceId,
    String? projectId,
    String? status,
    int limit = 50,
    String? cursor,
  }) => guardApiCall(
    () => _api.searchTasks(
      query,
      workspaceId: workspaceId,
      projectId: projectId,
      status: status,
      limit: limit,
      cursor: cursor,
    ),
    fallbackMessage: 'Nie udało się wyszukać zadań.',
    parsingMessage: 'Backend zwrócił nieprawidłowe wyniki wyszukiwania.',
  );

  @override
  Future<Either<ApiError, List<TaskSavedViewResponse>>> list({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listViews(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać zapisanych widoków.',
  );

  @override
  Future<Either<ApiError, TaskSavedViewResponse>> create({
    required String workspaceId,
    required String projectId,
    required CreateTaskSavedViewPayload payload,
  }) => guardApiCall(
    () => _api.createView(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zapisać widoku.',
  );

  @override
  Future<Either<ApiError, TaskSavedViewResponse>> update({
    required String workspaceId,
    required String projectId,
    required String viewId,
    required UpdateTaskSavedViewPayload payload,
  }) => guardApiCall(
    () => _api.updateView(workspaceId, projectId, viewId, payload),
    fallbackMessage: 'Nie udało się zaktualizować widoku.',
  );

  @override
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String projectId,
    required String viewId,
  }) async {
    final result = await guardApiCall(
      () => _api.deleteView(workspaceId, projectId, viewId),
      fallbackMessage: 'Nie udało się usunąć widoku.',
    );
    return result.map((_) => unit);
  }
}
