import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'workspace_invitations_settings_state.dart';

/// Odpowiada za listę wysłanych zaproszeń, wyszukiwanie użytkowników i operacje zaproszeń.
class WorkspaceInvitationsSettingsCubit
    extends Cubit<WorkspaceInvitationsSettingsState> {
  WorkspaceInvitationsSettingsCubit({
    required this.workspaceId,
    required this.repository,
  }) : super(const WorkspaceInvitationsSettingsLoading());

  final String workspaceId;
  final WorkspacesRepository repository;

  /// Ładuje listę wysłanych zaproszeń.
  Future<void> load() async {
    emit(const WorkspaceInvitationsSettingsLoading());

    final result = await repository.listSentInvitations(
      workspaceId: workspaceId,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(WorkspaceInvitationsSettingsError(error: error)),
      (page) =>
          emit(WorkspaceInvitationsSettingsLoaded(invitations: page.items)),
    );
  }

  /// Wyszukuje użytkowników w lokalnym katalogu.
  Future<List<LocalUserDirectoryResponse>> searchLocalUsers(
    String query,
  ) async {
    final result = await repository.searchLocalUsers(
      workspaceId: workspaceId,
      query: query,
    );

    return result.fold(
      (_) => <LocalUserDirectoryResponse>[],
      (users) => users,
    );
  }

  /// Tworzy nowe zaproszenie dla wybranego użytkownika.
  Future<bool> inviteUser({
    required String userId,
    required WorkspaceRole role,
  }) async {
    final currentState = state;
    if (currentState is! WorkspaceInvitationsSettingsLoaded ||
        currentState.isMutating) {
      return false;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await repository.createInvitation(
      workspaceId: workspaceId,
      payload: CreateWorkspaceInvitationPayload(
        userId: userId,
        role: role,
      ),
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(currentState.copyWith(isMutating: false, error: error));
        return false;
      },
      (invitation) {
        emit(
          currentState.copyWith(
            invitations: [invitation, ...currentState.invitations],
            isMutating: false,
          ),
        );
        return true;
      },
    );
  }

  /// Ponawia wysłanie zaproszenia.
  Future<void> resendInvitation(String invitationId) async {
    final currentState = state;
    if (currentState is! WorkspaceInvitationsSettingsLoaded ||
        currentState.isMutating) {
      return;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await repository.resendInvitation(
      workspaceId: workspaceId,
      invitationId: invitationId,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(currentState.copyWith(isMutating: false, error: error)),
      (updated) => emit(
        currentState.copyWith(
          invitations: [
            for (final inv in currentState.invitations)
              if (inv.id == invitationId) updated else inv,
          ],
          isMutating: false,
        ),
      ),
    );
  }

  /// Anuluje zaproszenie.
  Future<void> cancelInvitation(String invitationId) async {
    final currentState = state;
    if (currentState is! WorkspaceInvitationsSettingsLoaded ||
        currentState.isMutating) {
      return;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await repository.cancelInvitation(
      workspaceId: workspaceId,
      invitationId: invitationId,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(currentState.copyWith(isMutating: false, error: error)),
      (updated) => emit(
        currentState.copyWith(
          invitations: [
            for (final inv in currentState.invitations)
              if (inv.id == invitationId) updated else inv,
          ],
          isMutating: false,
        ),
      ),
    );
  }
}
