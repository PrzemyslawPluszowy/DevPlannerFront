part of 'workspace_invitations_settings_cubit.dart';

/// Stan modułu zaproszeń przestrzeni roboczej.
sealed class WorkspaceInvitationsSettingsState {
  const WorkspaceInvitationsSettingsState();
}

/// Stan ładowania zaproszeń.
final class WorkspaceInvitationsSettingsLoading
    extends WorkspaceInvitationsSettingsState {
  const WorkspaceInvitationsSettingsLoading();
}

/// Stan załadowanych zaproszeń.
final class WorkspaceInvitationsSettingsLoaded
    extends WorkspaceInvitationsSettingsState {
  const WorkspaceInvitationsSettingsLoaded({
    required this.invitations,
    this.isMutating = false,
    this.error,
  });

  /// Lista wysłanych zaproszeń workspace.
  final List<WorkspaceInvitationResponse> invitations;

  /// Czy trwa wysyłanie / ponawianie / anulowanie zaproszenia.
  final bool isMutating;

  /// Opcjonalny błąd ostatniej akcji.
  final ApiError? error;

  WorkspaceInvitationsSettingsLoaded copyWith({
    List<WorkspaceInvitationResponse>? invitations,
    bool? isMutating,
    ApiError? error,
    bool clearError = false,
  }) => WorkspaceInvitationsSettingsLoaded(
    invitations: invitations ?? this.invitations,
    isMutating: isMutating ?? this.isMutating,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Stan błędu pobierania zaproszeń.
final class WorkspaceInvitationsSettingsError
    extends WorkspaceInvitationsSettingsState {
  const WorkspaceInvitationsSettingsError({required this.error});

  /// Błąd z backendu.
  final ApiError error;
}
