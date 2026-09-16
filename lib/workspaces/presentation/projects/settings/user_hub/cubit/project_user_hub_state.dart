part of 'project_user_hub_cubit.dart';

/// Stany panelu użytkownika projektu.
sealed class ProjectUserHubState {
  const ProjectUserHubState();
}

/// Stan ładowania danych panelu użytkownika.
final class ProjectUserHubLoading extends ProjectUserHubState {
  const ProjectUserHubLoading();
}

/// Stan błędu panelu użytkownika.
final class ProjectUserHubFailure extends ProjectUserHubState {
  const ProjectUserHubFailure(this.message);

  final String message;
}

/// Stan gotowości panelu użytkownika.
final class ProjectUserHubReady extends ProjectUserHubState {
  const ProjectUserHubReady({
    required this.project,
    required this.isPinned,
    required this.isHidden,
    this.isSaving = false,
    this.isLeaving = false,
    this.error,
    this.successMessage,
  });

  final ProjectListItem project;
  final bool isPinned;
  final bool isHidden;
  final bool isSaving;
  final bool isLeaving;
  final String? error;
  final String? successMessage;

  ProjectUserHubReady copyWith({
    ProjectListItem? project,
    bool? isPinned,
    bool? isHidden,
    bool? isSaving,
    bool? isLeaving,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) => ProjectUserHubReady(
    project: project ?? this.project,
    isPinned: isPinned ?? this.isPinned,
    isHidden: isHidden ?? this.isHidden,
    isSaving: isSaving ?? this.isSaving,
    isLeaving: isLeaving ?? this.isLeaving,
    error: clearError ? null : error ?? this.error,
    successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
  );
}

/// Stan po pomyślnym opuszczeniu projektu.
final class ProjectUserHubLeftSuccess extends ProjectUserHubState {
  const ProjectUserHubLeftSuccess({required this.visibility});

  final ProjectVisibility visibility;
}
