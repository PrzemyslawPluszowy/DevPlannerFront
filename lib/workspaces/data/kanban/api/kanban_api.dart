import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

part 'kanban_api.g.dart';

/// Klient Retrofit tablic Kanban i osobistych preferencji widoku.
@RestApi()
abstract class KanbanApi {
  /// Tworzy klienta API Kanban.
  factory KanbanApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _KanbanApi;

  /// Pobiera ustawienia tablicy i pierwsze strony widocznych kolumn.
  ///
  /// Filtry są opcjonalne; Backend stosuje tę samą predykatę do liczników kolumn
  /// i do kart, a kursor strony kolumny dziedziczy ten sam zestaw filtrów.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/')
  Future<KanbanBoardResponse> getBoard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('assigneeUserId') String? assigneeUserId,
    @Query('priority') String? priority,
    @Query('milestoneId') String? milestoneId,
    @Query('status') String? status,
    @Query('customStatusId') String? customStatusId,
  });

  /// Pobiera zapisaną konfigurację kolumn i kart tablicy Kanban.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/settings')
  Future<ProjectKanbanSettingsResponse> getSettings(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Pobiera cursorową stronę kart systemowej kolumny Kanban.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/columns/{status}',
  )
  Future<CursorPageResponse<KanbanTaskCardResponse>> getColumn(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('status') String status, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('assigneeUserId') String? assigneeUserId,
    @Query('priority') String? priority,
    @Query('milestoneId') String? milestoneId,
    // Nazwa różni się od parametru ścieżki `status`: ten opisuje kolumnę,
    // a filtr zawęża karty w kolumnie.
    @Query('status') String? statusFilter,
    @Query('customStatusId') String? customStatusId,
  });

  /// Pobiera cursorową stronę kart własnej kolumny workflow.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/columns/custom/{customStatusId}',
  )
  Future<CursorPageResponse<KanbanTaskCardResponse>> getCustomColumn(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('customStatusId') String customStatusId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('assigneeUserId') String? assigneeUserId,
    @Query('priority') String? priority,
    @Query('milestoneId') String? milestoneId,
    @Query('status') String? status,
    @Query('customStatusId') String? customStatus,
  });

  /// Pobiera tablicę pogrupowaną po osobach: Nieprzypisane, bieżący użytkownik, pozostali.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/assignees')
  Future<AssigneeKanbanBoardResponse> getAssigneeBoard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('assigneeUserId') String? assigneeUserId,
    @Query('priority') String? priority,
    @Query('milestoneId') String? milestoneId,
    @Query('status') String? status,
    @Query('customStatusId') String? customStatusId,
  });

  /// Pobiera cursorową stronę kolumny jednej osoby.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/assignees/{assigneeUserId}',
  )
  Future<CursorPageResponse<KanbanTaskCardResponse>> getAssigneeGroup(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('assigneeUserId') String assigneeUserId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('assigneeUserId') String? assigneeUserIdFilter,
    @Query('priority') String? priority,
    @Query('milestoneId') String? milestoneId,
    @Query('status') String? status,
    @Query('customStatusId') String? customStatusId,
  });

  /// Pobiera cursorową stronę grupy zadań bez głównego wykonawcy.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/assignees/unassigned',
  )
  Future<CursorPageResponse<KanbanTaskCardResponse>> getUnassignedGroup(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('assigneeUserId') String? assigneeUserId,
    @Query('priority') String? priority,
    @Query('milestoneId') String? milestoneId,
    @Query('status') String? status,
    @Query('customStatusId') String? customStatusId,
  });

  /// Zastępuje ustawienia tablicy Kanban projektu.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/settings',
  )
  Future<ProjectKanbanSettingsResponse> updateSettings(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() UpdateProjectKanbanSettingsPayload payload,
  );

  /// Atomowo przenosi wiele kart do jednej kolumny.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/bulk-move',
  )
  Future<BulkMoveKanbanTasksResponse> bulkMove(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() BulkMoveKanbanTasksPayload payload,
  );

  /// Atomowo aktualizuje wspólne pola wielu kart.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/bulk-update',
  )
  Future<BulkUpdateKanbanTasksResponse> bulkUpdate(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() BulkUpdateKanbanTasksPayload payload,
  );

  /// Przesuwa pojedynczą kartę z kontrolą wersji.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/move-kanban',
  )
  Future<MoveKanbanTaskResponse> move(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() MoveKanbanTaskPayload payload,
  );

  /// Zmienia wyłącznie głównego wykonawcę karty, bez zmiany statusu.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/tasks/{taskId}/primary-assignee',
  )
  Future<ChangeKanbanPrimaryAssigneeResponse> changePrimaryAssignee(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('taskId') String taskId,
    @Body() ChangeKanbanPrimaryAssigneePayload payload,
  );

  /// Pobiera osobiste preferencje tablicy Kanban.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/preferences/',
  )
  Future<UserKanbanPreferenceResponse> getUserPreference(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Zapisuje osobiste preferencje tablicy Kanban.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban/preferences/',
  )
  Future<UserKanbanPreferenceResponse> updateUserPreference(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() UpdateUserKanbanPreferencePayload payload,
  );
}

/// Wypisuje diagnostykę rozbieżności kontraktu Kanban w konsoli debuggera.
///
/// Retrofit przekazuje tu surową odpowiedź zanim repository zamieni błąd na
/// przyjazny komunikat w UI, dzięki czemu backendową rozbieżność da się od razu
/// zidentyfikować bez odtwarzania błędu w debuggerze.
final class KanbanParseErrorLogger implements ParseErrorLogger {
  const KanbanParseErrorLogger();

  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions options, {
    Response<dynamic>? response,
  }) {
    final traceId =
        response?.headers.value('x-trace-id') ??
        response?.headers.value('traceparent');
    debugPrint(
      '[KANBAN][PARSING] ${options.method} ${options.path} | '
      '${error.runtimeType}: $error | statusCode=${response?.statusCode} '
      '${traceId != null ? 'traceId=$traceId' : ''}',
    );
    debugPrintStack(
      label: '[KANBAN][PARSING][stack]',
      stackTrace: stackTrace,
    );
  }
}
