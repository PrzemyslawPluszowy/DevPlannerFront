import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'workspace_members_settings_state.dart';

/// Odpowiada za listę członków przestrzeni roboczej, zmianę ich ról oraz usuwanie.
class WorkspaceMembersSettingsCubit
    extends Cubit<WorkspaceMembersSettingsState> {
  WorkspaceMembersSettingsCubit({
    required this.workspaceId,
    required this.repository,
  }) : super(const WorkspaceMembersSettingsLoading());

  final String workspaceId;
  final WorkspacesRepository repository;

  /// Ładuje listę członków przestrzeni roboczej.
  Future<void> load() async {
    emit(const WorkspaceMembersSettingsLoading());
    final result = await repository.listMembers(workspaceId);

    if (isClosed) return;

    result.fold(
      (error) => emit(WorkspaceMembersSettingsError(error: error)),
      (members) => emit(WorkspaceMembersSettingsLoaded(members: members)),
    );
  }

  /// Zmienia rolę członka w przestrzeni roboczej.
  Future<void> changeRole({
    required String memberId,
    required WorkspaceRole role,
  }) async {
    final currentState = state;
    if (currentState is! WorkspaceMembersSettingsLoaded ||
        currentState.isMutating) {
      return;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await repository.changeMemberRole(
      workspaceId: workspaceId,
      memberId: memberId,
      role: role,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(currentState.copyWith(isMutating: false, error: error)),
      (updatedMember) => emit(
        currentState.copyWith(
          members: [
            for (final m in currentState.members)
              if (m.id == memberId) updatedMember else m,
          ],
          isMutating: false,
        ),
      ),
    );
  }

  /// Usuwa członka z przestrzeni roboczej.
  Future<void> removeMember({
    required String memberId,
  }) async {
    final currentState = state;
    if (currentState is! WorkspaceMembersSettingsLoaded ||
        currentState.isMutating) {
      return;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await repository.revokeMember(
      workspaceId: workspaceId,
      memberId: memberId,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(currentState.copyWith(isMutating: false, error: error)),
      (_) => emit(
        currentState.copyWith(
          members: [
            for (final m in currentState.members)
              if (m.id != memberId) m,
          ],
          isMutating: false,
        ),
      ),
    );
  }
}
