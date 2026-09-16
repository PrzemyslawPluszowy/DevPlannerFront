import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';

/// Typowane filtry cursorowej listy zadań projektu.
final class ProjectTasksQuery {
  const ProjectTasksQuery({
    this.parentTaskId,
    this.includeArchived = false,
    this.limit = 50,
    this.cursor,
    this.savedViewId,
    this.status,
    this.priority,
    this.assigneeCoreUserId,
    this.myInvolvement,
    this.unassignedOnly = false,
    this.search,
    this.dueFromUtc,
    this.dueToUtc,
    this.pinnedOnly = false,
  }) : assert(
         limit >= 1 && limit <= 100,
         'Limit listy zadań musi mieścić się w zakresie 1–100.',
       ),
       assert(
         !unassignedOnly || assigneeCoreUserId == null,
         'Filtr nieprzypisanych zadań nie może wskazywać wykonawcy.',
       );

  final String? parentTaskId;
  final bool includeArchived;
  final int limit;
  final String? cursor;

  /// UUID prywatnego widoku, którego definicję wykonuje backend.
  final String? savedViewId;
  final String? status;
  final String? priority;
  final String? assigneeCoreUserId;
  final String? myInvolvement;
  final bool unassignedOnly;
  final String? search;
  final DateTime? dueFromUtc;
  final DateTime? dueToUtc;
  final bool pinnedOnly;
}

/// Parametry serwerowo grupowanej listy; `cursor` dotyczy wyłącznie `groupKey`.
final class ProjectTasksGroupedQuery extends ProjectTasksQuery {
  const ProjectTasksGroupedQuery({
    this.groupBy,
    this.groupKey,
    super.parentTaskId,
    super.includeArchived,
    super.limit,
    super.cursor,
    super.savedViewId,
    super.status,
    super.priority,
    super.assigneeCoreUserId,
    super.myInvolvement,
    super.unassignedOnly,
    super.search,
    super.dueFromUtc,
    super.dueToUtc,
    super.pinnedOnly,
  }) : assert(
         groupKey != null || cursor == null,
         'Kursor grupy wymaga groupKey.',
       );

  final String? groupBy;
  final String? groupKey;
}

/// Parametry cursorowego snapshotu osi czasu projektu.
final class ProjectTaskTimelineQuery {
  const ProjectTaskTimelineQuery({
    required this.fromUtc,
    required this.toUtc,
    this.includeUndated = false,
    this.limit = 500,
    this.cursor,
  }) : assert(
         limit >= 1 && limit <= 1000,
         'Limit osi czasu musi mieścić się w zakresie 1–1000.',
       );

  final DateTime fromUtc;
  final DateTime toUtc;
  final bool includeUndated;
  final int limit;
  final String? cursor;
}

/// Operacje podstawowego agregatu zadania projektu.
abstract interface class TasksRepository {
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  });

  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  });

  Future<Either<ApiError, TaskSelectionTokenResponse>>
  createTaskSelectionToken({
    required String workspaceId,
    required String projectId,
    required CreateTaskSelectionTokenPayload payload,
  });

  Future<Either<ApiError, BulkUpdateTaskSelectionResponse>>
  bulkUpdateTaskSelection({
    required String workspaceId,
    required String projectId,
    required BulkUpdateTaskSelectionPayload payload,
  });

  Future<Either<ApiError, TaskTimelineResponse>> getProjectTimeline({
    required String workspaceId,
    required String projectId,
    required ProjectTaskTimelineQuery query,
  });

  Future<Either<ApiError, ProjectTaskDetailsResponse>> getTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  createTask({
    required String workspaceId,
    required String projectId,
    required CreateProjectTaskPayload payload,
  });

  /// Szybkie tworzenie zadania z opcjonalną domyślną formatką użytkownika lub jawnym szablonem.
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  });

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  updateTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateProjectTaskPayload payload,
  });

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskListItemResponse>>>
  updateListItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskListItemPayload payload,
  });

  Future<Either<ApiError, MovedProjectTaskResponse>> moveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required MoveProjectTaskPayload payload,
  });

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  archiveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  });

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  restoreTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  });

  Future<Either<ApiError, List<ReorderedTaskVersionResponse>>> reorderTasks({
    required String workspaceId,
    required String projectId,
    required ReorderProjectTasksPayload payload,
  });

  Future<Either<ApiError, List<TaskDependencyResponse>>> listDependencies({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  createDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskDependencyPayload payload,
  });

  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  updateDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String dependencyId,
    required UpdateTaskDependencyPayload payload,
  });

  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  deleteDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String dependencyId,
    required int expectedVersion,
  });
}
