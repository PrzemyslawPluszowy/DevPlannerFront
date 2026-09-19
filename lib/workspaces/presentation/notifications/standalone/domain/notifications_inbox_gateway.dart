import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_models.dart';

/// Wąski port skrzynki Notifications dla nowego standalone UI.
///
/// Port celowo nie obejmuje grup, preferencji, odpowiedzi Chat ani operacji
/// administracyjnych. Dzięki temu ekran nie zależy od odziedziczonego,
/// wielodomenowego klienta powiadomień.
abstract interface class StandaloneNotificationsInboxGateway {
  Future<Either<ApiError, StandaloneNotificationPage>> list({
    String? cursor,
    int limit = 30,
    bool unreadOnly = false,
    NotificationCategory? category,
  });

  Future<Either<ApiError, int>> unreadCount();

  Future<Either<ApiError, Unit>> markRead(String notificationId);
}
