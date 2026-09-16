import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_role.dart';
import 'package:ready_next/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';

part 'workspace_invitations_settings_state.dart';

/// Odpowiada za listę wysłanych zaproszeń, wyszukiwanie użytkowników Ready i operacje zaproszeń.
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

  /// Wyszukuje użytkowników w katalogu Ready.
  Future<List<ReadyDirectoryUserResponse>> searchReadyUsers(
    String query,
  ) async {
    final result = await repository.searchReadyUsers(
      workspaceId: workspaceId,
      query: query,
    );

    return result.fold(
      (_) => <ReadyDirectoryUserResponse>[],
      (users) => users,
    );
  }

  /// Tworzy nowe zaproszenie dla wybranego użytkownika Ready.
  Future<bool> inviteUser({
    required int readyUserId,
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
        readyUserId: readyUserId,
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
