import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_notification_settings_api.g.dart';

/// Kontrakt ustawień globalnych i rozmownych powiadomień Chat.
@RestApi()
abstract class ChatNotificationSettingsApi {
  /// Tworzy klienta ustawień Chat na sesyjnym transporcie HTTP.
  factory ChatNotificationSettingsApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ChatNotificationSettingsApi;

  /// Pobiera globalne preferencje powiadomień.
  @GET('/api/v1/chat/users/me/notification-preferences')
  Future<ChatUserNotificationPreferenceResponse>
  getUserNotificationPreferences();

  /// Aktualizuje globalne preferencje powiadomień.
  @PUT('/api/v1/chat/users/me/notification-preferences')
  Future<ChatUserNotificationPreferenceResponse>
  updateUserNotificationPreferences(
    @Body() UpdateChatUserNotificationPreferencePayload payload,
  );

  /// Pobiera preferencję powiadomień rozmowy.
  @GET('/api/v1/chat/conversations/{conversationId}/notification-preference')
  Future<ChatNotificationPreferenceResponse> getNotificationPreference(
    @Path('conversationId') String conversationId,
  );

  /// Ustawia preferencję powiadomień rozmowy.
  @PUT('/api/v1/chat/conversations/{conversationId}/notification-preference')
  Future<ChatNotificationPreferenceResponse> setNotificationPreference(
    @Path('conversationId') String conversationId,
    @Body() UpdateChatNotificationPreferencePayload payload,
  );
}
