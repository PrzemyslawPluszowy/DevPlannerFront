part of 'workspace_general_settings_cubit.dart';

/// Stan modułu ustawień ogólnych przestrzeni roboczej.
sealed class WorkspaceGeneralSettingsState {
  const WorkspaceGeneralSettingsState();
}

/// Stan ładowania danych workspace.
final class WorkspaceGeneralSettingsLoading
    extends WorkspaceGeneralSettingsState {
  const WorkspaceGeneralSettingsLoading();
}

/// Stan gotowości z danymi workspace'u.
final class WorkspaceGeneralSettingsLoaded
    extends WorkspaceGeneralSettingsState {
  const WorkspaceGeneralSettingsLoaded({
    required this.workspace,
    this.isSaving = false,
    this.saveSuccess = false,
    this.isArchiving = false,
    this.error,
  });

  /// Dane przestrzeni roboczej.
  final WorkspaceListItem workspace;

  /// Czy trwa zapis formularza ogólnego.
  final bool isSaving;

  /// Czy ostatni zapis zakończył się sukcesem.
  final bool saveSuccess;

  /// Czy trwa proces archiwizacji / przywracania.
  final bool isArchiving;

  /// Błąd ostatniej operacji.
  final ApiError? error;

  WorkspaceGeneralSettingsLoaded copyWith({
    WorkspaceListItem? workspace,
    bool? isSaving,
    bool? saveSuccess,
    bool? isArchiving,
    ApiError? error,
    bool clearSuccess = false,
    bool clearError = false,
  }) => WorkspaceGeneralSettingsLoaded(
    workspace: workspace ?? this.workspace,
    isSaving: isSaving ?? this.isSaving,
    saveSuccess: !clearSuccess && (saveSuccess ?? this.saveSuccess),
    isArchiving: isArchiving ?? this.isArchiving,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Stan błędu ładowania danych workspace.
final class WorkspaceGeneralSettingsError
    extends WorkspaceGeneralSettingsState {
  const WorkspaceGeneralSettingsError({required this.error});

  /// Błąd z backendu.
  final ApiError error;
}
