import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_preferences.dart';

/// Port preferencji globalnego dostarczania i osobistego Storage.
abstract interface class NotificationPreferencesRepository {
  /// Pobiera globalną macierz dostarczania e-mail dla bieżącego użytkownika.
  Future<Either<ApiError, NotificationDeliveryPreferences>>
  getDeliveryPreferences();

  /// Zapisuje wyłącznie pola przekazane w poleceniu.
  Future<Either<ApiError, NotificationDeliveryPreferences>>
  updateDeliveryPreferences(
    UpdateNotificationDeliveryPreferencesCommand command,
  );

  /// Pobiera skuteczną preferencję powiadomień Storage.
  Future<Either<ApiError, StorageNotificationPreference>>
  getStoragePreference();

  /// Ustawia osobisty tryb dostarczania zdarzeń Storage.
  Future<Either<ApiError, StorageNotificationPreference>>
  updateStoragePreference(
    StorageNotificationMode mode,
  );
}
