import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_preferences.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_preferences_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Właściciel tylko globalnej macierzy dostarczania e-mail powiadomień.
///
/// Nie dzieli stanu ze skrzynką ani z ustawieniem Storage. Dzięki temu zapis
/// jednej kategorii nie blokuje ani nie odświeża globalnego inboxa.
final class NotificationDeliveryPreferencesCubit
    extends Cubit<NotificationDeliveryPreferencesState> {
  NotificationDeliveryPreferencesCubit(this._repository)
    : super(const NotificationDeliveryPreferencesLoading());

  final NotificationPreferencesRepository _repository;
  int _requestGeneration = 0;

  /// Pobiera aktualny snapshot dostarczania dla aktywnego użytkownika.
  Future<void> load() async {
    final requestGeneration = ++_requestGeneration;
    emit(const NotificationDeliveryPreferencesLoading());
    final result = await _repository.getDeliveryPreferences();
    if (isClosed || requestGeneration != _requestGeneration) return;
    result.fold(
      (error) => emit(NotificationDeliveryPreferencesFailure(error)),
      (preferences) => emit(NotificationDeliveryPreferencesReady(preferences)),
    );
  }

  /// Optymistycznie zmienia jeden kanał, cofając snapshot przy błędzie zapisu.
  Future<bool> updateMode(
    NotificationDeliveryCategory category,
    NotificationEmailDeliveryMode mode,
  ) async {
    final current = state;
    if (current is! NotificationDeliveryPreferencesReady || current.isSaving) {
      return false;
    }

    final previous = current.preferences;
    final requestGeneration = ++_requestGeneration;
    final optimistic = NotificationDeliveryPreferences(
      userId: previous.userId,
      modes: {...previous.modes, category: mode},
      updatedAtUtc: previous.updatedAtUtc,
    );
    emit(NotificationDeliveryPreferencesReady(optimistic, isSaving: true));

    final result = await _repository.updateDeliveryPreferences(
      _commandFor(category, mode),
    );
    if (isClosed || requestGeneration != _requestGeneration) return false;

    return result.fold(
      (error) {
        emit(NotificationDeliveryPreferencesReady(previous, error: error));
        return false;
      },
      (preferences) {
        emit(NotificationDeliveryPreferencesReady(preferences));
        return true;
      },
    );
  }

  UpdateNotificationDeliveryPreferencesCommand _commandFor(
    NotificationDeliveryCategory category,
    NotificationEmailDeliveryMode mode,
  ) => switch (category) {
    NotificationDeliveryCategory.invitation =>
      UpdateNotificationDeliveryPreferencesCommand(invitation: mode),
    NotificationDeliveryCategory.membership =>
      UpdateNotificationDeliveryPreferencesCommand(membership: mode),
    NotificationDeliveryCategory.workspace =>
      UpdateNotificationDeliveryPreferencesCommand(workspace: mode),
    NotificationDeliveryCategory.project =>
      UpdateNotificationDeliveryPreferencesCommand(project: mode),
    NotificationDeliveryCategory.task =>
      UpdateNotificationDeliveryPreferencesCommand(task: mode),
    NotificationDeliveryCategory.comment =>
      UpdateNotificationDeliveryPreferencesCommand(comment: mode),
    NotificationDeliveryCategory.chat =>
      UpdateNotificationDeliveryPreferencesCommand(chat: mode),
    NotificationDeliveryCategory.storage =>
      UpdateNotificationDeliveryPreferencesCommand(storage: mode),
    NotificationDeliveryCategory.system =>
      UpdateNotificationDeliveryPreferencesCommand(system: mode),
  };
}

/// Stan odczytu i zapisu globalnych preferencji dostarczania.
sealed class NotificationDeliveryPreferencesState {
  const NotificationDeliveryPreferencesState();
}

final class NotificationDeliveryPreferencesLoading
    extends NotificationDeliveryPreferencesState {
  const NotificationDeliveryPreferencesLoading();
}

final class NotificationDeliveryPreferencesFailure
    extends NotificationDeliveryPreferencesState {
  const NotificationDeliveryPreferencesFailure(this.error);

  final ApiError error;
}

final class NotificationDeliveryPreferencesReady
    extends NotificationDeliveryPreferencesState {
  const NotificationDeliveryPreferencesReady(
    this.preferences, {
    this.isSaving = false,
    this.error,
  });

  final NotificationDeliveryPreferences preferences;
  final bool isSaving;
  final ApiError? error;
}
