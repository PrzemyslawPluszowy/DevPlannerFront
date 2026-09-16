import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/responses/project_member_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';

part 'project_members_settings_state.dart';

/// Zarządza listą członków projektu, pobieraniem użytkowników z workspace i zmianami uprawnień.
class ProjectMembersSettingsCubit extends Cubit<ProjectMembersSettingsState> {
  ProjectMembersSettingsCubit({
    required this.workspaceId,
    required this.projectId,
    required this.projectsRepository,
    required this.workspacesRepository,
  }) : super(const ProjectMembersSettingsLoading());

  final String workspaceId;
  final String projectId;
  final ProjectsRepository projectsRepository;
  final WorkspacesRepository workspacesRepository;

  /// Ładuje listę członków projektu oraz członków całego workspace.
  Future<void> load() async {
    emit(const ProjectMembersSettingsLoading());

    final (projectMembersResult, workspaceMembersResult) = await (
      projectsRepository.listProjectMembers(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
      workspacesRepository.listMembers(workspaceId),
    ).wait;

    if (isClosed) return;

    switch (projectMembersResult) {
      case Left(:final value):
        emit(ProjectMembersSettingsError(error: value));
      case Right(value: final members):
        switch (workspaceMembersResult) {
          case Left(:final value):
            emit(ProjectMembersSettingsError(error: value));
          case Right(value: final workspaceMembers):
            emit(
              ProjectMembersSettingsLoaded(
                members: members,
                availableWorkspaceMembers: workspaceMembers,
              ),
            );
        }
    }
  }

  /// Dodaje członka workspace do projektu z wybraną rolą.
  Future<void> addMember({
    required String workspaceMemberId,
    required ProjectRole role,
  }) async {
    final currentState = state;
    if (currentState is! ProjectMembersSettingsLoaded ||
        currentState.isMutating) {
      return;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await projectsRepository.createProjectMembership(
      workspaceId: workspaceId,
      projectId: projectId,
      workspaceMemberId: workspaceMemberId,
      role: role,
    );

    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        emit(currentState.copyWith(isMutating: false, error: value));
      case Right(value: final newMember):
        emit(
          currentState.copyWith(
            members: [...currentState.members, newMember],
            isMutating: false,
          ),
        );
    }
  }

  /// Zmienia rolę członka w projekcie.
  Future<void> changeRole({
    required String memberId,
    required ProjectRole role,
  }) async {
    final currentState = state;
    if (currentState is! ProjectMembersSettingsLoaded ||
        currentState.isMutating) {
      return;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await projectsRepository.changeProjectMemberRole(
      workspaceId: workspaceId,
      projectId: projectId,
      memberId: memberId,
      role: role,
    );

    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        emit(currentState.copyWith(isMutating: false, error: value));
      case Right(value: final updatedMember):
        emit(
          currentState.copyWith(
            members: [
              for (final m in currentState.members)
                if (m.id == memberId) updatedMember else m,
            ],
            isMutating: false,
          ),
        );
    }
  }

  /// Usuwa członka z projektu.
  Future<void> removeMember({
    required String memberId,
  }) async {
    final currentState = state;
    if (currentState is! ProjectMembersSettingsLoaded ||
        currentState.isMutating) {
      return;
    }

    emit(currentState.copyWith(isMutating: true, clearError: true));

    final result = await projectsRepository.revokeProjectMember(
      workspaceId: workspaceId,
      projectId: projectId,
      memberId: memberId,
    );

    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        emit(currentState.copyWith(isMutating: false, error: value));
      case Right():
        emit(
          currentState.copyWith(
            members: [
              for (final m in currentState.members)
                if (m.id != memberId) m,
            ],
            isMutating: false,
          ),
        );
    }
  }
}
