import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'workspace_notifications_settings_state.dart';

/// Zarządza odczytem i zapisem osobistych preferencji powiadomień przestrzeni roboczej.
class WorkspaceNotificationsSettingsCubit
    extends Cubit<WorkspaceNotificationsSettingsState> {
  WorkspaceNotificationsSettingsCubit({
    required this.workspaceId,
    required this.repository,
  }) : super(const WorkspaceNotificationsSettingsLoading());

  final String workspaceId;
  final WorkspacesRepository repository;

  /// Ładuje aktualne preferencje powiadomień.
  Future<void> load() async {
    emit(const WorkspaceNotificationsSettingsLoading());

    final result = await repository.getNotificationPreference(workspaceId);

    if (isClosed) return;

    result.fold(
      (error) => emit(WorkspaceNotificationsSettingsError(error: error)),
      (preferences) => emit(
        WorkspaceNotificationsSettingsLoaded(preferences: preferences),
      ),
    );
  }

  /// Zapisuje zmodyfikowane preferencje powiadomień.
  Future<bool> savePreferences({
    required bool inAppEnabled,
    required bool emailEnabled,
    required bool tasksEnabled,
    required bool projectsEnabled,
    required bool workspaceEnabled,
    required bool membershipEnabled,
    required bool invitationsEnabled,
  }) async {
    final current = state;
    if (current is! WorkspaceNotificationsSettingsLoaded || current.isSaving) {
      return false;
    }

    emit(
      current.copyWith(isSaving: true, clearSuccess: true, clearError: true),
    );

    final result = await repository.updateNotificationPreference(
      workspaceId: workspaceId,
      payload: UpdateWorkspaceNotificationPreferencePayload(
        inAppEnabled: inAppEnabled,
        emailEnabled: emailEnabled,
        tasksEnabled: tasksEnabled,
        projectsEnabled: projectsEnabled,
        workspaceEnabled: workspaceEnabled,
        membershipEnabled: membershipEnabled,
        invitationsEnabled: invitationsEnabled,
      ),
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error));
        return false;
      },
      (updated) {
        emit(
          current.copyWith(
            preferences: updated,
            isSaving: false,
            saveSuccess: true,
          ),
        );
        return true;
      },
    );
  }
}
