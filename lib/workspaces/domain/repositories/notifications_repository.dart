import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';

/// Kontrakt globalnej skrzynki powiadomień.
///
/// Warstwa prezentacji nie zna Retrofit ani Dio, ale zachowuje nieprzezroczysty
/// kursor backendu. Dzięki temu inbox może bezpiecznie scalać strony po
/// reconnect bez zgadywania offsetów.
abstract interface class NotificationsRepository {
  /// Pobiera liczbę nieprzeczytanych elementów do globalnego topbara.
  Future<Either<ApiError, int>> unreadCount();

  /// Pobiera cursorową stronę pojedynczych powiadomień użytkownika.
  Future<Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>>
  listNotifications({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  });

  /// Pobiera cursorową stronę grup powiadomień użytkownika.
  Future<Either<ApiError, CursorPageResponse<NotificationGroupResponse>>>
  listGroups({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  });

  /// Oznacza wszystkie aktywne powiadomienia jako przeczytane.
  Future<Either<ApiError, void>> markAllRead();

  /// Oznacza całą grupę jako przeczytaną.
  Future<Either<ApiError, void>> markGroupRead(String groupKey);

  /// Archiwizuje całą grupę bez usuwania historii audytowej.
  Future<Either<ApiError, void>> archiveGroup(String groupKey);

  /// Wykonuje typowaną szybką akcję pojedynczego powiadomienia.
  Future<Either<ApiError, void>> quickAction(
    String notificationId,
    NotificationQuickActionKind action,
  );
}
