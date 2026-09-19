import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/api/workspaces_api.dart';
import 'package:devplanner/workspaces/data/workspaces/mappers/workspace_mappers.dart';
import 'package:devplanner/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';

/// Implementacja repozytorium Workspaces oparta o typowany klient Retrofit.
class WorkspacesRepositoryImpl extends ApiRepository
    implements WorkspacesRepository {
  /// Tworzy repozytorium korzystające z uwierzytelnionego API Workspaces.
  WorkspacesRepositoryImpl({required this.api});

  final WorkspacesApi api;

  @override
  Future<Either<ApiError, List<WorkspaceListItem>>> listWorkspaces({
    bool includeHidden = false,
  }) => guardApiCall(
    () async =>
        (await api.listWorkspaces(includeHidden: includeHidden))
            .map(mapWorkspaceListItem)
            .toList(growable: false),
    fallbackMessage: 'Nie udało się pobrać listy workspace’ów.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę workspace’ów.',
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> getWorkspace(
    String workspaceId,
  ) => guardApiCall(
    () async => mapCreatedWorkspace(await api.getWorkspace(workspaceId)),
    fallbackMessage: 'Nie udało się pobrać szczegółów workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane workspace’u.',
  );

  @override
  Future<Either<ApiError, List<WorkspaceMemberResponse>>> listMembers(
    String workspaceId,
  ) => guardApiCall(
    () => api.listMembers(workspaceId),
    fallbackMessage: 'Nie udało się pobrać członków workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę członków.',
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> createWorkspace({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) => guardApiCall(
    () async => mapCreatedWorkspace(
      await api.createWorkspace(
        CreateWorkspacePayload(
          name: name,
          description: description,
          icon: icon,
          primaryColor: primaryColor,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się utworzyć workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłowy workspace.',
  );

  @override
  Future<Either<ApiError, void>> updateWorkspacePreference({
    required String workspaceId,
    bool? isHidden,
    bool? isPinned,
  }) => guardApiCall(
    () => api.updateWorkspacePreference(
      workspaceId,
      UpdateWorkspaceUserPreferencePayload(
        isHidden: isHidden,
        isPinned: isPinned,
      ),
    ),
    fallbackMessage: 'Nie udało się zapisać preferencji workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłowe preferencje workspace’u.',
  );

  @override
  Future<Either<ApiError, List<WorkspaceListItem>>> updateWorkspaceOrder(
    List<String> workspaceIds,
  ) => guardApiCall(
    () async => (await api.updateWorkspaceOrder(
      UpdateWorkspaceOrderPayload(workspaceIds: List.of(workspaceIds)),
    )).map(mapWorkspaceListItem).toList(growable: false),
    fallbackMessage: 'Nie udało się zapisać kolejności workspace’ów.',
    parsingMessage: 'Backend zwrócił nieprawidłową kolejność workspace’ów.',
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> updateWorkspace({
    required String workspaceId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) => guardApiCall(
    () async => mapCreatedWorkspace(
      await api.updateWorkspace(
        workspaceId,
        UpdateWorkspacePayload(
          name: name,
          description: description,
          icon: icon,
          primaryColor: primaryColor,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się zaktualizować danych workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane workspace’u.',
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> archiveWorkspace(
    String workspaceId,
  ) => guardApiCall(
    () async => mapCreatedWorkspace(await api.archiveWorkspace(workspaceId)),
    fallbackMessage: 'Nie udało się zarchiwizować workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane.',
  );

  @override
  Future<Either<ApiError, WorkspaceListItem>> restoreWorkspace(
    String workspaceId,
  ) => guardApiCall(
    () async => mapCreatedWorkspace(await api.restoreWorkspace(workspaceId)),
    fallbackMessage: 'Nie udało się przywrócić workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane.',
  );

  @override
  Future<Either<ApiError, WorkspaceMemberResponse>> changeMemberRole({
    required String workspaceId,
    required String memberId,
    required WorkspaceRole role,
  }) => guardApiCall(
    () => api.changeMemberRole(
      workspaceId,
      memberId,
      ChangeWorkspaceMemberRolePayload(role: role),
    ),
    fallbackMessage: 'Nie udało się zmienić roli członka.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, WorkspaceMemberRevocationResponse>> revokeMember({
    required String workspaceId,
    required String memberId,
  }) => guardApiCall(
    () => api.revokeMember(workspaceId, memberId),
    fallbackMessage: 'Nie udało się usunąć członka z workspace’u.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, List<LocalUserDirectoryResponse>>> searchLocalUsers({
    required String workspaceId,
    required String query,
  }) => guardApiCall(
    () => api.searchLocalUsers(workspaceId, query),
    fallbackMessage: 'Nie udało się wyszukać użytkowników w lokalnym katalogu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane użytkowników.',
  );

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> createInvitation({
    required String workspaceId,
    required CreateWorkspaceInvitationPayload payload,
  }) => guardApiCall(
    () => api.createInvitation(workspaceId, payload),
    fallbackMessage: 'Nie udało się wysłać zaproszenia.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceInvitationResponse>>>
  listSentInvitations({
    required String workspaceId,
    int limit = 30,
    String? cursor,
  }) => guardApiCall(
    () => api.listSentInvitations(workspaceId, limit: limit, cursor: cursor),
    fallbackMessage: 'Nie udało się pobrać zaproszeń.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę zaproszeń.',
  );

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> cancelInvitation({
    required String workspaceId,
    required String invitationId,
  }) => guardApiCall(
    () => api.cancelInvitation(workspaceId, invitationId),
    fallbackMessage: 'Nie udało się anulować zaproszenia.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> resendInvitation({
    required String workspaceId,
    required String invitationId,
  }) => guardApiCall(
    () => api.resendInvitation(workspaceId, invitationId),
    fallbackMessage: 'Nie udało się ponowić zaproszenia.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceInvitationResponse>>>
  listReceivedInvitations({int limit = 30, String? cursor}) => guardApiCall(
    () => api.listReceivedInvitations(limit: limit, cursor: cursor),
    fallbackMessage: 'Nie udało się pobrać otrzymanych zaproszeń.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę zaproszeń.',
  );

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> acceptInvitation({
    required String workspaceId,
    required String invitationId,
  }) => guardApiCall(
    () => api.acceptInvitation(workspaceId, invitationId),
    fallbackMessage: 'Nie udało się zaakceptować zaproszenia.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, WorkspaceInvitationResponse>> declineInvitation({
    required String workspaceId,
    required String invitationId,
  }) => guardApiCall(
    () => api.declineInvitation(workspaceId, invitationId),
    fallbackMessage: 'Nie udało się odrzucić zaproszenia.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, WorkspaceMemberRevocationResponse>> leaveWorkspace(
    String workspaceId,
  ) => guardApiCall(
    () => api.leaveWorkspace(workspaceId),
    fallbackMessage: 'Nie udało się opuścić workspace.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź.',
  );

  @override
  Future<Either<ApiError, WorkspaceNotificationPreferenceResponse>>
  getNotificationPreference(String workspaceId) => guardApiCall(
    () => api.getNotificationPreference(workspaceId),
    fallbackMessage: 'Nie udało się pobrać preferencji powiadomień.',
    parsingMessage: 'Backend zwrócił nieprawidłowe preferencje.',
  );

  @override
  Future<Either<ApiError, WorkspaceNotificationPreferenceResponse>>
  updateNotificationPreference({
    required String workspaceId,
    required UpdateWorkspaceNotificationPreferencePayload payload,
  }) => guardApiCall(
    () => api.updateNotificationPreference(workspaceId, payload),
    fallbackMessage: 'Nie udało się zapisać preferencji powiadomień.',
    parsingMessage: 'Backend zwrócił nieprawidłowe preferencje.',
  );
}
