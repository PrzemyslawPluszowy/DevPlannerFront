import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/corkboard/models/corkboard_models.dart';
import 'package:retrofit/retrofit.dart';

part 'corkboard_api.g.dart';

/// Klient Retrofit sekcji, kart i załączników Corkboardu.
@RestApi()
abstract class CorkboardApi {
  /// Tworzy klienta API Corkboardu.
  factory CorkboardApi(Dio dio, {String? baseUrl}) = _CorkboardApi;

  /// Pobiera sekcje tematyczne projektu.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/sections',
  )
  Future<List<CorkboardSectionResponse>> listSections(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy sekcję tematyczną Corkboardu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/sections',
  )
  Future<CorkboardSectionResponse> createSection(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateCorkboardSectionPayload payload,
  );

  /// Pobiera karty Corkboardu wraz z załącznikami.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/cards')
  Future<List<CorkboardCardResponse>> listCards(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy kolorową kartę Corkboardu.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/cards')
  Future<CorkboardCardResponse> createCard(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateCorkboardCardPayload payload,
  );

  /// Przypina istniejący plik Storage do karty.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/cards/{cardId}/attachments',
  )
  Future<CorkboardAttachmentResponse> attachFile(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('cardId') String cardId,
    @Body() AttachCorkboardFilePayload payload,
  );

  /// Grupuje karty Corkboardu przez AI.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/ai/cluster',
  )
  Future<CorkboardAiClusterResponse> clusterWithAi(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CorkboardAiClusterPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Syntetyzuje karty Corkboardu do nowej strony Wiki.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/ai/summarize-to-wiki',
  )
  Future<CorkboardAiSummarizeToWikiResponse> summarizeToWiki(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CorkboardAiSummarizeToWikiPayload payload,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Konwertuje kartę Corkboardu do zadania projektu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/ai/cards/{cardId}/convert-to-task',
  )
  Future<CorkboardAiConvertToTaskResponse> convertToTask(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('cardId') String cardId,
    @Header('Idempotency-Key') String? idempotencyKey,
  );

  /// Otwiera albo zwraca scoped Chat karty Corkboardu.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard/ai/cards/{cardId}/chat',
  )
  Future<String> ensureCardChat(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('cardId') String cardId,
  );
}
