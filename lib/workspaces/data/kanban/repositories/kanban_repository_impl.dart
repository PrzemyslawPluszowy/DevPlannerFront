import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/kanban/api/kanban_api.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/domain/repositories/kanban_repository.dart';

/// Implementacja wszystkich operacji tablicy Kanban projektu.
final class KanbanRepositoryImpl extends ApiRepository
    implements KanbanRepository {
  KanbanRepositoryImpl(this._api);

  final KanbanApi _api;

  @override
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getBoard(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać tablicy Kanban.',
    parsingMessage: 'Backend zwrócił nieprawidłową tablicę Kanban.',
  );

  @override
  Future<Either<ApiError, ProjectKanbanSettingsResponse>> getSettings({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getSettings(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać ustawień Kanbana.',
    parsingMessage: 'Backend zwrócił nieprawidłowe ustawienia Kanbana.',
  );

  @override
  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getSystemColumn({
    required String workspaceId,
    required String projectId,
    required ProjectTaskStatus status,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  }) => guardApiCall(
    () => _api.getColumn(
      workspaceId,
      projectId,
      status,
      cursor: query.cursor,
      limit: query.limit,
      assigneeCoreUserId: query.assigneeCoreUserId,
      priority: query.priority,
      milestoneId: query.milestoneId,
    ),
    fallbackMessage: 'Nie udało się pobrać kolumny Kanban.',
  );

  @override
  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getCustomColumn({
    required String workspaceId,
    required String projectId,
    required String customStatusId,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  }) => guardApiCall(
    () => _api.getCustomColumn(
      workspaceId,
      projectId,
      customStatusId,
      cursor: query.cursor,
      limit: query.limit,
      assigneeCoreUserId: query.assigneeCoreUserId,
      priority: query.priority,
      milestoneId: query.milestoneId,
    ),
    fallbackMessage: 'Nie udało się pobrać własnej kolumny Kanban.',
  );

  @override
  Future<Either<ApiError, MoveKanbanTaskResponse>> moveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required MoveKanbanTaskPayload payload,
  }) => guardApiCall(
    () => _api.move(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się przenieść zadania.',
  );

  @override
  Future<Either<ApiError, BulkMoveKanbanTasksResponse>> bulkMove({
    required String workspaceId,
    required String projectId,
    required BulkMoveKanbanTasksPayload payload,
  }) => guardApiCall(
    () => _api.bulkMove(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się przenieść wybranych zadań.',
  );

  @override
  Future<Either<ApiError, BulkUpdateKanbanTasksResponse>> bulkUpdate({
    required String workspaceId,
    required String projectId,
    required BulkUpdateKanbanTasksPayload payload,
  }) => guardApiCall(
    () => _api.bulkUpdate(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zaktualizować wybranych zadań.',
  );

  @override
  Future<Either<ApiError, ProjectKanbanSettingsResponse>> updateSettings({
    required String workspaceId,
    required String projectId,
    required UpdateProjectKanbanSettingsPayload payload,
  }) => guardApiCall(
    () => _api.updateSettings(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zapisać ustawień Kanbana.',
  );

  @override
  Future<Either<ApiError, UserKanbanPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getUserPreference(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać preferencji Kanbana.',
  );

  @override
  Future<Either<ApiError, UserKanbanPreferenceResponse>> updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateUserKanbanPreferencePayload payload,
  }) => guardApiCall(
    () => _api.updateUserPreference(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zapisać preferencji Kanbana.',
  );
}
