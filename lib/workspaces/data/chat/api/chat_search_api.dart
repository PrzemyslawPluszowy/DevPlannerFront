import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_search_api.g.dart';

/// Kontrakt wyszukiwania wiadomości i sugestii wzmianek.
@RestApi()
abstract class ChatSearchApi {
  /// Tworzy klienta wyszukiwania Chat na sesyjnym transporcie HTTP.
  factory ChatSearchApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ChatSearchApi;

  /// Wyszukuje wiadomości dostępne dla bieżącego użytkownika.
  @GET('/api/v1/chat/search')
  Future<ChatSearchResponse> search({
    @Query('q') required String query,
    @Query('conversationId') String? conversationId,
    @Query('senderId') String? senderId,
    @Query('workspaceId') String? workspaceId,
    @Query('projectId') String? projectId,
    @Query('fromUtc') DateTime? fromUtc,
    @Query('toUtc') DateTime? toUtc,
    @Query('mentionedUserId') String? mentionedUserId,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
  });

  /// Pobiera facety wyszukiwania wiadomości.
  @GET('/api/v1/chat/search/facets')
  Future<ChatSearchFacetsResponse> searchFacets({
    @Query('q') required String query,
    @Query('conversationId') String? conversationId,
    @Query('senderId') String? senderId,
    @Query('workspaceId') String? workspaceId,
    @Query('projectId') String? projectId,
    @Query('fromUtc') DateTime? fromUtc,
    @Query('toUtc') DateTime? toUtc,
    @Query('mentionedUserId') String? mentionedUserId,
  });

  /// Pobiera sugestie użytkowników do wzmianki.
  @GET('/api/v1/chat/conversations/{conversationId}/mention-suggestions')
  Future<List<ChatMentionSuggestionResponse>> mentionSuggestions(
    @Path('conversationId') String conversationId,
    @Query('q') String query,
  );
}
