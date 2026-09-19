import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';

/// Filtry cursorowej listy zadań bieżącego użytkownika.
final class MyTasksQuery {
  const MyTasksQuery({
    this.limit = 50,
    this.cursor,
    this.involvement,
    this.status,
    this.priority,
    this.dueFromUtc,
    this.dueToUtc,
  }) : assert(
         limit >= 1 && limit <= 100,
         'Limit listy moich zadań musi mieścić się w zakresie 1–100.',
       );

  final int limit;
  final String? cursor;
  final String? involvement;
  final String? status;
  final String? priority;
  final DateTime? dueFromUtc;
  final DateTime? dueToUtc;
}

/// Prywatne, zapisane widoki listy Tasks w granicach projektu.
abstract interface class TaskViewRepository {
  Future<Either<ApiError, CursorPageResponse<MyTaskListItemResponse>>>
  listMyTasks({MyTasksQuery query = const MyTasksQuery()});

  /// Wyszukuje zadania globalnie w dostępnych projektach.
  Future<Either<ApiError, CursorPageResponse<GlobalTaskSearchItemResponse>>>
  searchTasks({
    required String query,
    String? workspaceId,
    String? projectId,
    String? status,
    int limit = 50,
    String? cursor,
  });

  Future<Either<ApiError, List<TaskSavedViewResponse>>> list({
    required String workspaceId,
    required String projectId,
  });
  Future<Either<ApiError, TaskSavedViewResponse>> create({
    required String workspaceId,
    required String projectId,
    required CreateTaskSavedViewPayload payload,
  });
  Future<Either<ApiError, TaskSavedViewResponse>> update({
    required String workspaceId,
    required String projectId,
    required String viewId,
    required UpdateTaskSavedViewPayload payload,
  });
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String projectId,
    required String viewId,
  });
}
