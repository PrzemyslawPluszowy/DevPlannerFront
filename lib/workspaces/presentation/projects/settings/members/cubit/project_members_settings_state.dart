part of 'project_members_settings_cubit.dart';

/// Stan modułu członków projektu.
sealed class ProjectMembersSettingsState {
  const ProjectMembersSettingsState();
}

/// Stan ładowania listy członków projektu.
final class ProjectMembersSettingsLoading extends ProjectMembersSettingsState {
  const ProjectMembersSettingsLoading();
}

/// Stan załadowanych członków projektu z listą dostępnych użytkowników workspace.
final class ProjectMembersSettingsLoaded extends ProjectMembersSettingsState {
  const ProjectMembersSettingsLoaded({
    required this.members,
    required this.availableWorkspaceMembers,
    this.isMutating = false,
    this.error,
  });

  /// Jawni członkowie projektu.
  final List<ProjectMemberResponse> members;

  /// Wszyscy aktywni członkowie workspace możliwi do dodania.
  final List<WorkspaceMemberResponse> availableWorkspaceMembers;

  /// Czy trwa operacja mutacji (dodawanie/edycja roli/usuwanie).
  final bool isMutating;

  /// Opcjonalny błąd ostatniej akcji.
  final ApiError? error;

  /// Lista członków workspace, którzy jeszcze nie są jawnymi członkami projektu.
  List<WorkspaceMemberResponse> get unassignedWorkspaceMembers {
    final assignedUserIds = members.map((m) => m.userId).toSet();
    return availableWorkspaceMembers
        .where((wm) => !assignedUserIds.contains(wm.userId))
        .toList(growable: false);
  }

  ProjectMembersSettingsLoaded copyWith({
    List<ProjectMemberResponse>? members,
    List<WorkspaceMemberResponse>? availableWorkspaceMembers,
    bool? isMutating,
    ApiError? error,
    bool clearError = false,
  }) => ProjectMembersSettingsLoaded(
    members: members ?? this.members,
    availableWorkspaceMembers:
        availableWorkspaceMembers ?? this.availableWorkspaceMembers,
    isMutating: isMutating ?? this.isMutating,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Stan błędu ładowania członków projektu.
final class ProjectMembersSettingsError extends ProjectMembersSettingsState {
  const ProjectMembersSettingsError({required this.error});

  /// Błąd z backendu.
  final ApiError error;
}
