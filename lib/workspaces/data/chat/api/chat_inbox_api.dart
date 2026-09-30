import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_inbox_api.g.dart';

/// Kontrakt REST skrzynki, liczników nieprzeczytanych i read ACK.
@RestApi()
abstract class ChatInboxApi {
  /// Tworzy klienta skrzynki Chat na sesyjnym transporcie HTTP.
  factory ChatInboxApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ChatInboxApi;

  /// Pobiera cursorową stronę skrzynki bieżącego użytkownika.
  @GET('/api/v1/chat/inbox')
  Future<ChatInboxPageResponse> loadInbox({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('filter') String? filter,
    @Query('query') String? query,
  });

  /// Pobiera agregat nieprzeczytanych bez pobierania stron skrzynki.
  @GET('/api/v1/chat/inbox/unread-count')
  Future<ChatInboxUnreadCountResponse> loadInboxUnreadCount();

  /// Potwierdza odczyt wskazanej wiadomości.
  @POST('/api/v1/chat/conversations/{conversationId}/messages/{messageId}/read')
  Future<void> markRead(
    @Path('conversationId') String conversationId,
    @Path('messageId') String messageId,
  );
}
