import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_preferences.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_preferences_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Właściciel wyłącznie osobistej preferencji powiadomień Storage.
final class StorageNotificationPreferenceCubit
    extends Cubit<StorageNotificationPreferenceState> {
  StorageNotificationPreferenceCubit(this._repository)
    : super(const StorageNotificationPreferenceLoading());

  final NotificationPreferencesRepository _repository;
  int _requestGeneration = 0;

  /// Ładuje skuteczną preferencję Storage aktywnego użytkownika.
  Future<void> load() async {
    final requestGeneration = ++_requestGeneration;
    emit(const StorageNotificationPreferenceLoading());
    final result = await _repository.getStoragePreference();
    if (isClosed || requestGeneration != _requestGeneration) return;
    result.fold(
      (error) => emit(StorageNotificationPreferenceFailure(error)),
      (preference) => emit(StorageNotificationPreferenceReady(preference)),
    );
  }

  /// Zapisuje optymistycznie nowy tryb i cofa go po błędzie portu.
  Future<bool> updateMode(StorageNotificationMode mode) async {
    final current = state;
    if (current is! StorageNotificationPreferenceReady || current.isSaving) {
      return false;
    }
    if (current.preference.mode == mode) return true;

    final previous = current.preference;
    final requestGeneration = ++_requestGeneration;
    final optimistic = StorageNotificationPreference(
      userId: previous.userId,
      mode: mode,
      isDefault: false,
      updatedAtUtc: previous.updatedAtUtc,
    );
    emit(StorageNotificationPreferenceReady(optimistic, isSaving: true));

    final result = await _repository.updateStoragePreference(mode);
    if (isClosed || requestGeneration != _requestGeneration) return false;
    return result.fold(
      (error) {
        emit(StorageNotificationPreferenceReady(previous, error: error));
        return false;
      },
      (preference) {
        emit(StorageNotificationPreferenceReady(preference));
        return true;
      },
    );
  }
}

/// Stan odczytu i zapisu osobistej preferencji Storage.
sealed class StorageNotificationPreferenceState {
  const StorageNotificationPreferenceState();
}

final class StorageNotificationPreferenceLoading
    extends StorageNotificationPreferenceState {
  const StorageNotificationPreferenceLoading();
}

final class StorageNotificationPreferenceFailure
    extends StorageNotificationPreferenceState {
  const StorageNotificationPreferenceFailure(this.error);

  final ApiError error;
}

final class StorageNotificationPreferenceReady
    extends StorageNotificationPreferenceState {
  const StorageNotificationPreferenceReady(
    this.preference, {
    this.isSaving = false,
    this.error,
  });

  final StorageNotificationPreference preference;
  final bool isSaving;
  final ApiError? error;
}
