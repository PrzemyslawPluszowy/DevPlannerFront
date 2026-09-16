import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/notifications/api/notifications_api.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';

/// Implementacja repozytorium globalnych powiadomień.
class NotificationsRepositoryImpl extends ApiRepository
    implements NotificationsRepository {
  /// Tworzy repozytorium na uwierzytelnionym kliencie Workspaces.
  NotificationsRepositoryImpl(NotificationsApi api) : _api = api;

  final NotificationsApi _api;

  @override
  Future<Either<ApiError, int>> unreadCount() async => guardApiCall(
    () async => (await _api.unreadCount()).count,
    fallbackMessage: 'Nie udało się pobrać licznika powiadomień.',
    parsingMessage: 'Backend zwrócił nieprawidłowy licznik powiadomień.',
  );

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>>
  listNotifications({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => guardApiCall(
    () => _api.list(
      cursor: cursor,
      limit: limit,
      category: category,
      isUnreadOnly: unreadOnly,
    ),
    fallbackMessage: 'Nie udało się pobrać powiadomień.',
    parsingMessage: 'Backend zwrócił nieprawidłową skrzynkę powiadomień.',
  );

  @override
  Future<Either<ApiError, CursorPageResponse<NotificationGroupResponse>>>
  listGroups({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => guardApiCall(
    () => _api.listGroups(
      cursor: cursor,
      limit: limit,
      category: category,
      isUnreadOnly: unreadOnly,
    ),
    fallbackMessage: 'Nie udało się pobrać powiadomień.',
    parsingMessage: 'Backend zwrócił nieprawidłową skrzynkę powiadomień.',
  );

  @override
  Future<Either<ApiError, void>> markAllRead() async => guardApiCall(
    _api.markAllRead,
    fallbackMessage: 'Nie udało się oznaczyć powiadomień jako przeczytane.',
  );

  @override
  Future<Either<ApiError, void>> markGroupRead(String groupKey) async =>
      guardApiCall(
        () => _api.markGroupRead(groupKey),
        fallbackMessage: 'Nie udało się oznaczyć grupy jako przeczytanej.',
      );

  @override
  Future<Either<ApiError, void>> archiveGroup(String groupKey) async =>
      guardApiCall(
        () => _api.archiveGroup(groupKey),
        fallbackMessage: 'Nie udało się zarchiwizować grupy powiadomień.',
      );

  @override
  Future<Either<ApiError, void>> quickAction(
    String notificationId,
    NotificationQuickActionKind action,
  ) async => guardApiCall(
    () async {
      await _api.executeQuickAction(
        notificationId,
        NotificationQuickActionPayload(action: action),
      );
    },
    fallbackMessage: 'Nie udało się wykonać akcji powiadomienia.',
  );
}
