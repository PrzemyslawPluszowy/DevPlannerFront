part of 'project_templates_cubit.dart';

/// Typ akcji na szablonie zakończonej sukcesem.
enum ProjectTemplateActionType {
  created,
  refreshed,
  deleted,
  applied,
}

/// Stan zarządzania szablonami projektów w panelu administratora.
sealed class ProjectTemplatesState {
  const ProjectTemplatesState();
}

/// Stan początkowego ładowania szablonów.
final class ProjectTemplatesLoading extends ProjectTemplatesState {
  const ProjectTemplatesLoading();
}

/// Stan gotowości z listą szablonów i stanem operacji w toku.
final class ProjectTemplatesReady extends ProjectTemplatesState {
  const ProjectTemplatesReady({
    required this.templates,
    this.isSaving = false,
    this.actionSuccess,
    this.error,
  });

  final List<ProjectTemplateResponse> templates;
  final bool isSaving;
  final ProjectTemplateActionType? actionSuccess;
  final String? error;

  ProjectTemplatesReady copyWith({
    List<ProjectTemplateResponse>? templates,
    bool? isSaving,
    ProjectTemplateActionType? actionSuccess,
    String? error,
    bool clearSuccess = false,
    bool clearError = false,
  }) => ProjectTemplatesReady(
    templates: templates ?? this.templates,
    isSaving: isSaving ?? this.isSaving,
    actionSuccess: clearSuccess ? null : (actionSuccess ?? this.actionSuccess),
    error: clearError ? null : (error ?? this.error),
  );
}

/// Błąd pobierania listy szablonów.
final class ProjectTemplatesFailure extends ProjectTemplatesState {
  const ProjectTemplatesFailure(this.message);

  final String message;
}
