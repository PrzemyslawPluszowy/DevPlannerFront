import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:flutter/foundation.dart';

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

/// Filtry tablicy Kanban wspólne dla liczników kolumn, kart i kolejnych stron.
///
/// Backend liczy `totalTaskCount` i WIP tą samą predykatą, którą filtruje karty,
/// dlatego filtr musi być wysłany razem z pierwszym odczytem tablicy oraz z
/// każdym doładowaniem kolumny.
@immutable
final class KanbanBoardFilter {
  const KanbanBoardFilter({
    this.assigneeUserId,
    this.priority,
    this.milestoneId,
  });

  static const KanbanBoardFilter none = KanbanBoardFilter();

  final String? assigneeUserId;
  final TaskPriority? priority;
  final String? milestoneId;

  /// Czy tablica pokazuje pełny projekt, czy zawężony zestaw kart.
  bool get isActive =>
      assigneeUserId != null || priority != null || milestoneId != null;

  /// Liczba aktywnych wymiarów filtra — używana przez pasek aktywnego filtra.
  int get activeCount =>
      (assigneeUserId == null ? 0 : 1) +
      (priority == null ? 0 : 1) +
      (milestoneId == null ? 0 : 1);

  /// Tworzy zapytanie kolumny dziedziczące filtry tablicy.
  KanbanColumnQuery toColumnQuery({String? cursor}) => KanbanColumnQuery(
    cursor: cursor,
    assigneeUserId: assigneeUserId,
    priority: priority,
    milestoneId: milestoneId,
  );

  KanbanBoardFilter copyWith({
    String? assigneeUserId,
    TaskPriority? priority,
    String? milestoneId,
    bool clearAssignee = false,
    bool clearPriority = false,
    bool clearMilestone = false,
  }) => KanbanBoardFilter(
    assigneeUserId: clearAssignee
        ? null
        : assigneeUserId ?? this.assigneeUserId,
    priority: clearPriority ? null : priority ?? this.priority,
    milestoneId: clearMilestone ? null : milestoneId ?? this.milestoneId,
  );

  @override
  bool operator ==(Object other) =>
      other is KanbanBoardFilter &&
      other.assigneeUserId == assigneeUserId &&
      other.priority == priority &&
      other.milestoneId == milestoneId;

  @override
  int get hashCode => Object.hash(assigneeUserId, priority, milestoneId);
}

/// Pełny kontrakt danych i mutacji tablicy Kanban projektu.
abstract interface class KanbanRepository {
  /// Pobiera tablicę; filtry zawężają liczniki kolumn i pierwsze strony kart.
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
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
