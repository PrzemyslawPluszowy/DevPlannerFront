import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'notifications_api.g.dart';

/// Klient Retrofit prywatnej skrzynki i preferencji powiadomień.
@RestApi()
abstract class NotificationsApi {
  /// Tworzy klienta API powiadomień.
  factory NotificationsApi(Dio dio, {String? baseUrl}) = _NotificationsApi;

  /// Pobiera cursorową stronę aktywnych powiadomień.
  @GET('/api/v1/notifications/')
  Future<CursorPageResponse<WorkspaceNotificationResponse>> list({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('category') String? category,
    @Query('isUnreadOnly') bool? isUnreadOnly,
  });

  /// Pobiera liczbę nieprzeczytanych powiadomień.
  @GET('/api/v1/notifications/unread-count')
  Future<UnreadNotificationCountResponse> unreadCount();

  /// Pobiera cursorową stronę grup powiadomień.
  @GET('/api/v1/notifications/groups')
  Future<CursorPageResponse<NotificationGroupResponse>> listGroups({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('category') String? category,
    @Query('isUnreadOnly') bool? isUnreadOnly,
  });

  /// Buduje snapshot grup digest-only.
  @GET('/api/v1/notifications/digest')
  Future<NotificationDigestResponse> digest({@Query('limit') int? limit});

  /// Pobiera globalne preferencje e-mail.
  @GET('/api/v1/notifications/delivery-preferences')
  Future<NotificationDeliveryPreferenceResponse> getDeliveryPreferences();

  /// Aktualizuje wybrane globalne preferencje e-mail.
  @PUT('/api/v1/notifications/delivery-preferences')
  Future<NotificationDeliveryPreferenceResponse> updateDeliveryPreferences(
    @Body() UpdateNotificationDeliveryPreferencePayload payload,
  );

  /// Pobiera osobistą preferencję powiadomień Storage.
  @GET('/api/v1/notifications/storage-preference')
  Future<StorageNotificationPreferenceResponse> getStoragePreference();

  /// Aktualizuje osobistą preferencję powiadomień Storage.
  @PUT('/api/v1/notifications/storage-preference')
  Future<StorageNotificationPreferenceResponse> updateStoragePreference(
    @Body() UpdateStorageNotificationPreferencePayload payload,
  );

  /// Oznacza wszystkie powiadomienia grupy jako przeczytane.
  @POST('/api/v1/notifications/groups/{groupKey}/read')
  Future<void> markGroupRead(@Path('groupKey') String groupKey);

  /// Archiwizuje całą grupę powiadomień.
  @DELETE('/api/v1/notifications/groups/{groupKey}')
  Future<void> archiveGroup(@Path('groupKey') String groupKey);

  /// Wykonuje szybką akcję na powiadomieniu.
  @POST('/api/v1/notifications/{id}/quick-action')
  Future<NotificationQuickActionResponse> executeQuickAction(
    @Path('id') String id,
    @Body() NotificationQuickActionPayload payload,
  );

  /// Oznacza pojedyncze powiadomienie jako przeczytane.
  @POST('/api/v1/notifications/{id}/read')
  Future<void> markRead(@Path('id') String id);

  /// Oznacza wszystkie aktywne powiadomienia jako przeczytane.
  @POST('/api/v1/notifications/read-all')
  Future<void> markAllRead();

  /// Przypina powiadomienie w osobistej skrzynce.
  @PUT('/api/v1/notifications/{id}/pin')
  Future<void> pin(@Path('id') String id);

  /// Usuwa osobiste przypięcie powiadomienia.
  @DELETE('/api/v1/notifications/{id}/pin')
  Future<void> unpin(@Path('id') String id);

  /// Archiwizuje pojedyncze powiadomienie.
  @DELETE('/api/v1/notifications/{id}')
  Future<void> archive(@Path('id') String id);

  /// Publikuje odpowiedź Chat wskazaną przez powiadomienie.
  @POST('/api/v1/notifications/{id}/reply')
  Future<ChatMessageResponse> reply(
    @Path('id') String id,
    @Body() NotificationReplyPayload payload,
  );

  /// Wysyła ręczny komunikat administracyjny do użytkownika Core.
  @POST('/api/v1/admin/notifications/')
  Future<WorkspaceNotificationResponse> createAdminNotification(
    @Body() CreateAdminNotificationPayload payload,
  );
}
