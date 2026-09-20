import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';

/// Kontrakt repozytorium projektów workspace’u.
abstract interface class ProjectsRepository {
  /// Pobiera projekty należące do konkretnego workspace’u.
  ///
  /// Filtr stanu i widoczności trafia wprost do backendu, dzięki czemu sekcje
  /// `Ukryte` (`visibility: hidden`) i `Archiwum` (`state: archived`) pochodzą
  /// z serwera, a nie wyłącznie z wiedzy bieżącej sesji klienta.
  ///
  /// [includeHidden] jest przestarzałym aliasem: `true` odpowiada
  /// `visibility: all`, a jawna wartość [visibility] ma pierwszeństwo.
  Future<Either<ApiError, List<ProjectListItem>>> listProjects(
    String workspaceId, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    @Deprecated('Użyj visibility; wartość true odpowiada visibility=all.')
    bool? includeHidden,
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
  ///
  /// [expectedVersion] to wersja z ostatniego odczytu; niezgodność kończy się
  /// 409 z kodem `project.version_conflict` i nie nadpisuje cudzej zmiany.
  Future<Either<ApiError, ProjectListItem>> updateProject({
    required String workspaceId,
    required String projectId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    required ProjectVisibility visibility,
    required ProjectStatus status,
    int? expectedVersion,
  });

  /// Archiwizuje projekt.
  Future<Either<ApiError, ProjectListItem>> archiveProject({
    required String workspaceId,
    required String projectId,
    int? expectedVersion,
  });

  /// Przywraca zarchiwizowany projekt.
  Future<Either<ApiError, ProjectListItem>> restoreProject({
    required String workspaceId,
    required String projectId,
    int? expectedVersion,
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
  ///
  /// [expectedVersion] to wersja preferencji z poprzedniego odczytu lub zapisu
  /// (a nie wersja projektu); niezgodność kończy się 409 z kodem
  /// `project.preference_version_conflict`.
  Future<Either<ApiError, ProjectUserPreferenceResponse>>
  updateProjectPreference({
    required String workspaceId,
    required String projectId,
    required bool isHidden,
    required bool isPinned,
    int? expectedVersion,
  });

  /// Zapisuje trwałą kolejność widocznych projektów użytkownika w workspace.
  Future<Either<ApiError, List<ProjectListItem>>> updateProjectOrder({
    required String workspaceId,
    required List<String> projectIds,
  });
}
