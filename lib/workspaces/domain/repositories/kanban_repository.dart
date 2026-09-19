import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';

/// Filtry jednej cursorowej kolumny Kanban.
final class KanbanColumnQuery {
  const KanbanColumnQuery({
    this.cursor,
    this.limit = 25,
    this.assigneeUserId,
    this.priority,
    this.milestoneId,
  }) : assert(
         limit >= 1 && limit <= 50,
         'Limit strony kolumny Kanban musi mieścić się w zakresie 1–50.',
       );

  final String? cursor;
  final int limit;
  final String? assigneeUserId;
  final TaskPriority? priority;
  final String? milestoneId;
}

/// Pełny kontrakt danych i mutacji tablicy Kanban projektu.
abstract interface class KanbanRepository {
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera pełne, wersjonowane ustawienia tablicy projektu.
  Future<Either<ApiError, ProjectKanbanSettingsResponse>> getSettings({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getSystemColumn({
    required String workspaceId,
    required String projectId,
    required ProjectTaskStatus status,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  });

  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getCustomColumn({
    required String workspaceId,
    required String projectId,
    required String customStatusId,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  });

  Future<Either<ApiError, MoveKanbanTaskResponse>> moveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required MoveKanbanTaskPayload payload,
  });

  Future<Either<ApiError, BulkMoveKanbanTasksResponse>> bulkMove({
    required String workspaceId,
    required String projectId,
    required BulkMoveKanbanTasksPayload payload,
  });

  Future<Either<ApiError, BulkUpdateKanbanTasksResponse>> bulkUpdate({
    required String workspaceId,
    required String projectId,
    required BulkUpdateKanbanTasksPayload payload,
  });

  Future<Either<ApiError, ProjectKanbanSettingsResponse>> updateSettings({
    required String workspaceId,
    required String projectId,
    required UpdateProjectKanbanSettingsPayload payload,
  });

  Future<Either<ApiError, UserKanbanPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, UserKanbanPreferenceResponse>> updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateUserKanbanPreferencePayload payload,
  });
}
