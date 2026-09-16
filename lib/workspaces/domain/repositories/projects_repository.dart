import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/responses/project_member_response.dart';
import 'package:ready_next/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';

/// Kontrakt repozytorium projektów workspace’u.
abstract interface class ProjectsRepository {
  /// Pobiera projekty należące do konkretnego workspace’u.
  Future<Either<ApiError, List<ProjectListItem>>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  });

  /// Tworzy nowy projekt w wybranym workspace.
  Future<Either<ApiError, ProjectListItem>> createProject({
    required String workspaceId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    ProjectVisibility visibility = ProjectVisibility.shared,
    ProjectStatus status = ProjectStatus.active,
  });

  /// Pobiera pełne szczegóły projektu.
  Future<Either<ApiError, ProjectListItem>> getProject({
    required String workspaceId,
    required String projectId,
  });

  /// Aktualizuje dane projektu.
  Future<Either<ApiError, ProjectListItem>> updateProject({
    required String workspaceId,
    required String projectId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    required ProjectVisibility visibility,
    required ProjectStatus status,
  });

  /// Archiwizuje projekt.
  Future<Either<ApiError, ProjectListItem>> archiveProject({
    required String workspaceId,
    required String projectId,
  });

  /// Przywraca zarchiwizowany projekt.
  Future<Either<ApiError, ProjectListItem>> restoreProject({
    required String workspaceId,
    required String projectId,
  });

  /// Trwale usuwa zarchiwizowany projekt.
  Future<Either<ApiError, void>> deleteProject({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera listę jawnych członków projektu.
  Future<Either<ApiError, List<ProjectMemberResponse>>> listProjectMembers({
    required String workspaceId,
    required String projectId,
  });

  /// Dodaje członka workspace do projektu.
  Future<Either<ApiError, ProjectMemberResponse>> createProjectMembership({
    required String workspaceId,
    required String projectId,
    required String workspaceMemberId,
    required ProjectRole role,
  });

  /// Zmienia rolę członka w projekcie.
  Future<Either<ApiError, ProjectMemberResponse>> changeProjectMemberRole({
    required String workspaceId,
    required String projectId,
    required String memberId,
    required ProjectRole role,
  });

  /// Usuwa członka z projektu.
  Future<Either<ApiError, ProjectMemberResponse>> revokeProjectMember({
    required String workspaceId,
    required String projectId,
    required String memberId,
  });

  /// Pozwala użytkownikowi opuścić jawne członkostwo w projekcie.
  Future<Either<ApiError, ProjectMemberResponse>> leaveProject({
    required String workspaceId,
    required String projectId,
  });

  /// Aktualizuje osobiste preferencje projektu (przypięcie, ukrycie).
  Future<Either<ApiError, ProjectUserPreferenceResponse>>
  updateProjectPreference({
    required String workspaceId,
    required String projectId,
    required bool isHidden,
    required bool isPinned,
  });

  /// Zapisuje trwałą kolejność widocznych projektów użytkownika w workspace.
  Future<Either<ApiError, List<ProjectListItem>>> updateProjectOrder({
    required String workspaceId,
    required List<String> projectIds,
  });
}
