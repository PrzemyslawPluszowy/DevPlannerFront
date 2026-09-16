part of 'project_general_settings_cubit.dart';

/// Stan modułu ustawień ogólnych projektu.
sealed class ProjectGeneralSettingsState {
  const ProjectGeneralSettingsState();
}

/// Stan początkowego ładowania danych projektu.
final class ProjectGeneralSettingsLoading extends ProjectGeneralSettingsState {
  const ProjectGeneralSettingsLoading();
}

/// Stan załadowanych danych projektu z opcjonalnymi flagami operacji asynchronicznych.
final class ProjectGeneralSettingsLoaded extends ProjectGeneralSettingsState {
  const ProjectGeneralSettingsLoaded({
    required this.project,
    this.isSaving = false,
    this.saveSuccess = false,
    this.error,
  });

  /// Aktualne dane projektu.
  final ProjectListItem project;

  /// Czy trwa zapis lub zmiana stanu cyklu życia.
  final bool isSaving;

  /// Czy ostatni zapis zakończył się sukcesem.
  final bool saveSuccess;

  /// Opcjonalny błąd ostatniej operacji.
  final ApiError? error;

  ProjectGeneralSettingsLoaded copyWith({
    ProjectListItem? project,
    bool? isSaving,
    bool? saveSuccess,
    bool clearSuccess = false,
    ApiError? error,
  }) => ProjectGeneralSettingsLoaded(
    project: project ?? this.project,
    isSaving: isSaving ?? this.isSaving,
    saveSuccess: !clearSuccess && (saveSuccess ?? this.saveSuccess),
    error: error,
  );
}

/// Stan błędu ładowania danych projektu.
final class ProjectGeneralSettingsError extends ProjectGeneralSettingsState {
  const ProjectGeneralSettingsError({required this.error});

  /// Komunikat błędu z backendu.
  final ApiError error;
}
