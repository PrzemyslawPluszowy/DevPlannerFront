import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/wiki/models/wiki_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'wiki_api.g.dart';

/// Klient Retrofit drzew, stron, rewizji i akcji AI Wiki.
@RestApi()
abstract class WikiApi {
  /// Tworzy klienta API Wiki.
  factory WikiApi(Dio dio, {String? baseUrl}) = _WikiApi;

  /// Pobiera drzewo stron Wiki workspace.
  @GET('/api/v1/workspaces/{workspaceId}/wiki/tree')
  Future<List<WikiPageTreeNodeResponse>> getWorkspaceTree(
    @Path('workspaceId') String workspaceId,
  );

  /// Tworzy stronę Wiki na poziomie workspace.
  @POST('/api/v1/workspaces/{workspaceId}/wiki/pages')
  Future<WikiPageResponse> createWorkspacePage(
    @Path('workspaceId') String workspaceId,
    @Body() CreateWikiPagePayload payload,
  );

  /// Pobiera drzewo stron Wiki projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/wiki/tree')
  Future<List<WikiPageTreeNodeResponse>> getProjectTree(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy stronę Wiki w projekcie.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/wiki/pages')
  Future<WikiPageResponse> createProjectPage(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateWikiPagePayload payload,
  );

  /// Pobiera pełną stronę Wiki.
  @GET('/api/v1/wiki/pages/{pageId}')
  Future<WikiPageResponse> getPage(@Path('pageId') String pageId);

  /// Aktualizuje stronę Wiki z kontrolą wersji.
  @PATCH('/api/v1/wiki/pages/{pageId}')
  Future<WikiPageResponse> updatePage(
    @Path('pageId') String pageId,
    @Body() UpdateWikiPagePayload payload,
  );

  /// Przenosi stronę Wiki w drzewie.
  @POST('/api/v1/wiki/pages/{pageId}/move')
  Future<WikiPageResponse> movePage(
    @Path('pageId') String pageId,
    @Body() MoveWikiPagePayload payload,
  );

  /// Przenosi stronę Wiki do kosza.
  @DELETE('/api/v1/wiki/pages/{pageId}')
  Future<void> archivePage(
    @Path('pageId') String pageId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Pobiera cursorową historię rewizji strony.
  @GET('/api/v1/wiki/pages/{pageId}/revisions')
  Future<CursorPageResponse<WikiPageRevisionSummaryResponse>> listRevisions(
    @Path('pageId') String pageId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Pobiera pełną rewizję strony Wiki.
  @GET('/api/v1/wiki/pages/{pageId}/revisions/{revisionId}')
  Future<WikiPageRevisionResponse> getRevision(
    @Path('pageId') String pageId,
    @Path('revisionId') String revisionId,
  );

  /// Porównuje dwie rewizje strony Wiki.
  @GET(
    '/api/v1/wiki/pages/{pageId}/revisions/{fromRevisionId}/diff/{toRevisionId}',
  )
  Future<WikiPageRevisionDiffResponse> diffRevisions(
    @Path('pageId') String pageId,
    @Path('fromRevisionId') String fromRevisionId,
    @Path('toRevisionId') String toRevisionId,
  );

  /// Przywraca rewizję jako nową wersję strony.
  @POST('/api/v1/wiki/pages/{pageId}/revisions/{revisionId}/restore')
  Future<WikiPageResponse> restorePage(
    @Path('pageId') String pageId,
    @Path('revisionId') String revisionId,
    @Body() RestoreWikiPagePayload payload,
  );

  /// Nadaje stronie status Verified.
  @POST('/api/v1/wiki/pages/{pageId}/verify')
  Future<WikiPageResponse> verifyPage(
    @Path('pageId') String pageId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Cofa stronie status Verified.
  @DELETE('/api/v1/wiki/pages/{pageId}/verify')
  Future<WikiPageResponse> unverifyPage(
    @Path('pageId') String pageId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Konwertuje zaznaczenie strony do zadania projektu.
  @POST('/api/v1/wiki/pages/{pageId}/convert-selection-to-task')
  Future<ConvertWikiSelectionToTaskResponse> convertSelectionToTask(
    @Path('pageId') String pageId,
    @Body() ConvertWikiSelectionToTaskPayload payload,
  );

  /// Pobiera zadania powiązane backlinkami ze stroną.
  @GET('/api/v1/wiki/pages/{pageId}/task-links')
  Future<List<WikiPageTaskLinkResponse>> listTaskLinks(
    @Path('pageId') String pageId,
  );

  /// Generuje podsumowanie strony przez AI.
  @POST('/api/v1/wiki/pages/{pageId}/ai/summarize')
  Future<WikiSummarizeResponse> summarize(
    @Path('pageId') String pageId,
  );

  /// Wyodrębnia działania ze strony przez AI.
  @POST('/api/v1/wiki/pages/{pageId}/ai/generate-action-items')
  Future<WikiActionItemsResponse> generateActionItems(
    @Path('pageId') String pageId,
  );
}
