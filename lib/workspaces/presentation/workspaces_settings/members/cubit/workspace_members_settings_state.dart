part of 'workspace_members_settings_cubit.dart';

/// Stan modułu członków przestrzeni roboczej.
sealed class WorkspaceMembersSettingsState {
  const WorkspaceMembersSettingsState();
}

/// Stan ładowania listy członków workspace.
final class WorkspaceMembersSettingsLoading
    extends WorkspaceMembersSettingsState {
  const WorkspaceMembersSettingsLoading();
}

/// Stan załadowanych członków workspace.
final class WorkspaceMembersSettingsLoaded
    extends WorkspaceMembersSettingsState {
  const WorkspaceMembersSettingsLoaded({
    required this.members,
    this.isMutating = false,
    this.error,
  });

  /// Lista członków przestrzeni roboczej.
  final List<WorkspaceMemberResponse> members;

  /// Czy trwa operacja zmiany roli lub usuwania członka.
  final bool isMutating;

  /// Opcjonalny błąd ostatniej akcji.
  final ApiError? error;

  WorkspaceMembersSettingsLoaded copyWith({
    List<WorkspaceMemberResponse>? members,
    bool? isMutating,
    ApiError? error,
    bool clearError = false,
  }) => WorkspaceMembersSettingsLoaded(
    members: members ?? this.members,
    isMutating: isMutating ?? this.isMutating,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Stan błędu pobierania członków workspace.
final class WorkspaceMembersSettingsError
    extends WorkspaceMembersSettingsState {
  const WorkspaceMembersSettingsError({required this.error});

  /// Błąd z backendu.
  final ApiError error;
}
