part of 'workspace_notifications_settings_cubit.dart';

/// Stan modułu preferencji powiadomień przestrzeni roboczej.
sealed class WorkspaceNotificationsSettingsState {
  const WorkspaceNotificationsSettingsState();
}

/// Stan ładowania preferencji.
final class WorkspaceNotificationsSettingsLoading
    extends WorkspaceNotificationsSettingsState {
  const WorkspaceNotificationsSettingsLoading();
}

/// Stan załadowanych preferencji.
final class WorkspaceNotificationsSettingsLoaded
    extends WorkspaceNotificationsSettingsState {
  const WorkspaceNotificationsSettingsLoaded({
    required this.preferences,
    this.isSaving = false,
    this.saveSuccess = false,
    this.error,
  });

  /// Aktualne preferencje powiadomień.
  final WorkspaceNotificationPreferenceResponse preferences;

  /// Czy trwa zapis preferencji.
  final bool isSaving;

  /// Czy ostatni zapis zakończył się sukcesem.
  final bool saveSuccess;

  /// Opcjonalny błąd ostatniej akcji.
  final ApiError? error;

  WorkspaceNotificationsSettingsLoaded copyWith({
    WorkspaceNotificationPreferenceResponse? preferences,
    bool? isSaving,
    bool? saveSuccess,
    ApiError? error,
    bool clearSuccess = false,
    bool clearError = false,
  }) => WorkspaceNotificationsSettingsLoaded(
    preferences: preferences ?? this.preferences,
    isSaving: isSaving ?? this.isSaving,
    saveSuccess: !clearSuccess && (saveSuccess ?? this.saveSuccess),
    error: clearError ? null : (error ?? this.error),
  );
}

/// Stan błędu pobierania preferencji.
final class WorkspaceNotificationsSettingsError
    extends WorkspaceNotificationsSettingsState {
  const WorkspaceNotificationsSettingsError({required this.error});

  /// Błąd z backendu.
  final ApiError error;
}
