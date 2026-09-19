import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/payloads/change_project_member_role_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/create_project_membership_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/create_project_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_order_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_user_preference_payload.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_list_item_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';

/// Implementacja repozytorium projektów oparta o uwierzytelniony Retrofit API.
final class ProjectsRepositoryImpl extends ApiRepository
    implements ProjectsRepository {
  ProjectsRepositoryImpl({required this.api});

  final ProjectsApi api;

  @override
  Future<Either<ApiError, List<ProjectListItem>>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) => guardApiCall(
    () async => (await api.listProjects(
      workspaceId,
      includeHidden: includeHidden,
    )).map(_toDomain).toList(growable: false),
    fallbackMessage: 'Nie udało się pobrać projektów workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę projektów.',
  );

  @override
  Future<Either<ApiError, ProjectListItem>> createProject({
    required String workspaceId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    ProjectVisibility visibility = ProjectVisibility.shared,
    ProjectStatus status = ProjectStatus.active,
  }) => guardApiCall(
    () async {
      final response = await api.createProject(
        workspaceId,
        CreateProjectPayload(
          name: name,
          description: description,
          icon: icon,
          primaryColor: primaryColor,
          visibility: visibility,
          status: status,
        ),
      );
      return _fromProjectResponse(response);
    },
    fallbackMessage: 'Nie udało się utworzyć projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź projektu.',
  );

  @override
  Future<Either<ApiError, ProjectListItem>> getProject({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async {
      final response = await api.getProject(workspaceId, projectId);
      return _fromProjectResponse(response);
    },
    fallbackMessage: 'Nie udało się pobrać szczegółów projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź projektu.',
  );

  @override
  Future<Either<ApiError, ProjectListItem>> updateProject({
    required String workspaceId,
    required String projectId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    required ProjectVisibility visibility,
    required ProjectStatus status,
  }) => guardApiCall(
    () async {
      final response = await api.updateProject(
        workspaceId,
        projectId,
        UpdateProjectPayload(
          name: name,
          description: description,
          icon: icon,
          primaryColor: primaryColor,
          visibility: visibility,
          status: status,
        ),
      );
      return _fromProjectResponse(response);
    },
    fallbackMessage: 'Nie udało się zaktualizować projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź projektu.',
  );

  @override
  Future<Either<ApiError, ProjectListItem>> archiveProject({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async {
      final response = await api.archiveProject(workspaceId, projectId);
      return _fromProjectResponse(response);
    },
    fallbackMessage: 'Nie udało się zarchiwizować projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź projektu.',
  );

  @override
  Future<Either<ApiError, ProjectListItem>> restoreProject({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async {
      final response = await api.restoreProject(workspaceId, projectId);
      return _fromProjectResponse(response);
    },
    fallbackMessage: 'Nie udało się przywrócić projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź projektu.',
  );

  @override
  Future<Either<ApiError, void>> deleteProject({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => api.deleteProject(workspaceId, projectId),
    fallbackMessage: 'Nie udało się trwale usunąć projektu.',
    parsingMessage: 'Błąd podczas usuwania projektu.',
  );

  @override
  Future<Either<ApiError, List<ProjectMemberResponse>>> listProjectMembers({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => api.listProjectMembers(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać listy członków projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę członków.',
  );

  @override
  Future<Either<ApiError, ProjectMemberResponse>> createProjectMembership({
    required String workspaceId,
    required String projectId,
    required String workspaceMemberId,
    required ProjectRole role,
  }) => guardApiCall(
    () => api.createProjectMembership(
      workspaceId,
      projectId,
      CreateProjectMembershipPayload(
        workspaceMembershipId: workspaceMemberId,
        role: role,
      ),
    ),
    fallbackMessage: 'Nie udało się dodać członka do projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, ProjectMemberResponse>> changeProjectMemberRole({
    required String workspaceId,
    required String projectId,
    required String memberId,
    required ProjectRole role,
  }) => guardApiCall(
    () => api.changeProjectMemberRole(
      workspaceId,
      projectId,
      memberId,
      ChangeProjectMemberRolePayload(role: role),
    ),
    fallbackMessage: 'Nie udało się zmienić roli członka projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, ProjectMemberResponse>> revokeProjectMember({
    required String workspaceId,
    required String projectId,
    required String memberId,
  }) => guardApiCall(
    () => api.revokeProjectMember(workspaceId, projectId, memberId),
    fallbackMessage: 'Nie udało się usunąć członka z projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, ProjectMemberResponse>> leaveProject({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => api.leaveProject(workspaceId, projectId),
    fallbackMessage: 'Nie udało się opuścić projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, ProjectUserPreferenceResponse>>
  updateProjectPreference({
    required String workspaceId,
    required String projectId,
    required bool isHidden,
    required bool isPinned,
  }) => guardApiCall(
    () => api.updateProjectUserPreference(
      workspaceId,
      projectId,
      UpdateProjectUserPreferencePayload(
        isHidden: isHidden,
        isPinned: isPinned,
      ),
    ),
    fallbackMessage: 'Nie udało się zaktualizować preferencji projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, List<ProjectListItem>>> updateProjectOrder({
    required String workspaceId,
    required List<String> projectIds,
  }) => guardApiCall(
    () async {
      final items = await api.updateProjectOrder(
        workspaceId,
        UpdateProjectOrderPayload(projectIds: projectIds),
      );
      return items.map(_toDomain).toList(growable: false);
    },
    fallbackMessage: 'Nie udało się zapisać kolejności projektów.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę projektów.',
  );

  ProjectListItem _fromProjectResponse(ProjectResponse response) =>
      ProjectListItem(
        id: response.id,
        workspaceId: response.workspaceId,
        name: response.name,
        description: response.description,
        icon: response.icon,
        primaryColor: response.primaryColor,
        visibility: response.visibility,
        status: response.status,
        myRole: response.myRole,
        sortPosition: 0,
        archivedAtUtc: response.archivedAtUtc,
      );

  ProjectListItem _toDomain(ProjectListItemResponse response) =>
      ProjectListItem(
        id: response.id,
        workspaceId: response.workspaceId,
        name: response.name,
        description: response.description,
        icon: response.icon,
        primaryColor: response.primaryColor,
        visibility: response.visibility,
        status: response.status,
        myRole: response.myRole,
        isPinned: response.isPinned,
        sortPosition: response.sortPosition,
      );
}
