import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_presence_api.g.dart';

/// Kontrakt REST statusu obecności użytkowników Chat.
@RestApi()
abstract class ChatPresenceApi {
  /// Tworzy klienta obecności Chat na sesyjnym transporcie HTTP.
  factory ChatPresenceApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ChatPresenceApi;

  /// Pobiera status wskazanego użytkownika.
  @GET('/api/v1/chat/users/{userId}/status')
  Future<ChatUserStatusResponse?> getUserStatus(@Path('userId') String userId);

  /// Ustawia własny status.
  @PUT('/api/v1/chat/users/me/status')
  Future<ChatUserStatusResponse> upsertStatus(
    @Body() UpsertChatUserStatusPayload payload,
  );

  /// Czyści własny status.
  @DELETE('/api/v1/chat/users/me/status')
  Future<void> clearStatus();
}
