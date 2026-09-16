import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/whiteboard/models/whiteboard_models.dart';
import 'package:retrofit/retrofit.dart';

part 'whiteboard_api.g.dart';

/// Klient Retrofit whiteboardów, stron, obiektów, eksportów i AI.
@RestApi()
abstract class WhiteboardApi {
  /// Tworzy klienta API Whiteboard.
  factory WhiteboardApi(Dio dio, {String? baseUrl}) = _WhiteboardApi;

  /// Pobiera cursorową listę whiteboardów projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/whiteboards/')
  Future<CursorPageResponse<WhiteboardSummaryResponse>> listProjectWhiteboards(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Tworzy nazwany whiteboard projektu.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/whiteboards/')
  Future<WhiteboardResponse> createProjectWhiteboard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateWhiteboardPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Pobiera pełny whiteboard projektu.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/whiteboards/{whiteboardId}',
  )
  Future<WhiteboardResponse> getProjectWhiteboard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('whiteboardId') String whiteboardId,
  );

  /// Aktualizuje metadane whiteboardu.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/whiteboards/{whiteboardId}',
  )
  Future<WhiteboardResponse> updateProjectWhiteboard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('whiteboardId') String whiteboardId,
    @Body() UpdateWhiteboardPayload payload,
  );

  /// Tworzy głęboką kopię whiteboardu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/whiteboards/{whiteboardId}/duplicate',
  )
  Future<WhiteboardResponse> duplicateProjectWhiteboard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('whiteboardId') String whiteboardId,
    @Body() DuplicateWhiteboardPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Pobiera katalog systemowych szablonów whiteboardów.
  @GET('/api/v1/whiteboard-templates/')
  Future<List<WhiteboardTemplateResponse>> listTemplates();

  /// Tworzy whiteboard z systemowego szablonu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/whiteboards/from-template',
  )
  Future<WhiteboardResponse> createFromTemplate(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateWhiteboardFromTemplatePayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Pobiera access-safe snapshot whiteboardu.
  @GET('/api/v1/whiteboards/{whiteboardId}/snapshot')
  Future<WhiteboardSnapshotResponse> getSnapshot(
    @Path('whiteboardId') String whiteboardId,
    @Query('cursor') String? cursor,
  );

  /// Pobiera cursorowy log zmian whiteboardu.
  @GET('/api/v1/whiteboards/{whiteboardId}/events')
  Future<CursorPageResponse<WhiteboardEventResponse>> listEvents(
    @Path('whiteboardId') String whiteboardId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Pobiera cursorową listę stron whiteboardu.
  @GET('/api/v1/whiteboards/{whiteboardId}/pages')
  Future<CursorPageResponse<WhiteboardPageResponse>> listPages(
    @Path('whiteboardId') String whiteboardId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Tworzy stronę whiteboardu.
  @POST('/api/v1/whiteboards/{whiteboardId}/pages')
  Future<WhiteboardPageResponse> createPage(
    @Path('whiteboardId') String whiteboardId,
    @Body() CreateWhiteboardPagePayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Pobiera stronę whiteboardu.
  @GET('/api/v1/whiteboards/{whiteboardId}/pages/{pageId}')
  Future<WhiteboardPageResponse> getPage(
    @Path('whiteboardId') String whiteboardId,
    @Path('pageId') String pageId,
  );

  /// Aktualizuje stronę whiteboardu.
  @PATCH('/api/v1/whiteboards/{whiteboardId}/pages/{pageId}')
  Future<WhiteboardPageResponse> updatePage(
    @Path('whiteboardId') String whiteboardId,
    @Path('pageId') String pageId,
    @Body() UpdateWhiteboardPagePayload payload,
  );

  /// Pobiera cursorową listę obiektów whiteboardu.
  @GET('/api/v1/whiteboards/{whiteboardId}/objects')
  Future<CursorPageResponse<WhiteboardObjectResponse>> listObjects(
    @Path('whiteboardId') String whiteboardId, {
    @Query('pageId') String? pageId,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Tworzy obiekt na konkretnej stronie.
  @POST('/api/v1/whiteboards/{whiteboardId}/pages/{pageId}/objects')
  Future<WhiteboardObjectResponse> createObject(
    @Path('whiteboardId') String whiteboardId,
    @Path('pageId') String pageId,
    @Body() CreateWhiteboardObjectPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Tworzy obiekt na canvasie whiteboardu.
  @POST('/api/v1/whiteboards/{whiteboardId}/objects')
  Future<WhiteboardObjectResponse> createCanvasObject(
    @Path('whiteboardId') String whiteboardId,
    @Body() CreateWhiteboardObjectPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Tworzy zadanie ze Sticky Note.
  @POST('/api/v1/whiteboards/{whiteboardId}/objects/{objectId}/task')
  Future<StickyNoteTaskResponse> createTaskFromStickyNote(
    @Path('whiteboardId') String whiteboardId,
    @Path('objectId') String objectId,
    @Body() CreateTaskFromStickyNotePayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Konwertuje wiele Sticky Notes na zadania.
  @POST('/api/v1/whiteboards/{whiteboardId}/convert-to-tasks')
  Future<BulkCreateTasksFromStickyNotesResponse> convertStickyNotesToTasks(
    @Path('whiteboardId') String whiteboardId,
    @Body() BulkCreateTasksFromStickyNotesPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Aktualizuje obiekt whiteboardu.
  @PATCH('/api/v1/whiteboards/{whiteboardId}/objects/{objectId}')
  Future<WhiteboardObjectResponse> updateObject(
    @Path('whiteboardId') String whiteboardId,
    @Path('objectId') String objectId,
    @Body() UpdateWhiteboardObjectPayload payload,
  );

  /// Usuwa obiekt whiteboardu.
  @DELETE('/api/v1/whiteboards/{whiteboardId}/objects/{objectId}')
  Future<void> deleteObject(
    @Path('whiteboardId') String whiteboardId,
    @Path('objectId') String objectId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Atomowo stosuje operacje offline queue.
  @POST('/api/v1/whiteboards/{whiteboardId}/operations')
  Future<ApplyWhiteboardOperationsResponse> applyOperations(
    @Path('whiteboardId') String whiteboardId,
    @Body() ApplyWhiteboardOperationsPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Zleca asynchroniczny eksport whiteboardu.
  @POST('/api/v1/whiteboards/{whiteboardId}/export')
  Future<WhiteboardExportResponse> createExport(
    @Path('whiteboardId') String whiteboardId,
    @Body() CreateWhiteboardExportPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Pobiera status joba eksportu.
  @GET('/api/v1/whiteboards/{whiteboardId}/export/{jobId}')
  Future<WhiteboardExportResponse> getExport(
    @Path('whiteboardId') String whiteboardId,
    @Path('jobId') String jobId,
  );

  /// Grupuje obiekty whiteboardu przez AI.
  @POST('/api/v1/whiteboards/{whiteboardId}/ai/cluster')
  Future<WhiteboardAiOperationResponse> clusterWithAi(
    @Path('whiteboardId') String whiteboardId,
    @Body() WhiteboardAiClusterPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Generuje i materializuje przepływ whiteboardu przez AI.
  @POST('/api/v1/whiteboards/{whiteboardId}/ai/generate-flow')
  Future<WhiteboardAiOperationResponse> generateFlowWithAi(
    @Path('whiteboardId') String whiteboardId,
    @Body() WhiteboardAiGenerateFlowPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );
}
