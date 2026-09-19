import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'workspaces_api.g.dart';

/// Klient Retrofit wszystkich endpointów głównej domeny Workspaces.
@RestApi()
abstract class WorkspacesApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory WorkspacesApi(Dio dio, {String? baseUrl}) = _WorkspacesApi;

  /// Tworzy workspace i dodaje bieżącego użytkownika jako Ownera.
  @POST('/api/v1/workspaces/')
  Future<WorkspaceResponse> createWorkspace(
    @Body() CreateWorkspacePayload body,
  );

  /// Pobiera aktywne workspace użytkownika; includeHidden dołącza ukryte pozycje.
  @GET('/api/v1/workspaces/')
  Future<List<WorkspaceListItemResponse>> listWorkspaces({
    @Query('includeHidden') bool includeHidden = false,
  });

  /// Zmienia osobiste ukrycie lub przypięcie workspace.
  @PATCH('/api/v1/workspaces/{workspaceId}/preferences')
  Future<WorkspaceUserPreferenceResponse> updateWorkspacePreference(
    @Path('workspaceId') String workspaceId,
    @Body() UpdateWorkspaceUserPreferencePayload body,
  );

  /// Pobiera osobiste preferencje powiadomień workspace.
  @GET('/api/v1/workspaces/{workspaceId}/notification-preferences')
  Future<WorkspaceNotificationPreferenceResponse> getNotificationPreference(
    @Path('workspaceId') String workspaceId,
  );

  /// Aktualizuje osobiste preferencje powiadomień workspace.
  @PATCH('/api/v1/workspaces/{workspaceId}/notification-preferences')
  Future<WorkspaceNotificationPreferenceResponse> updateNotificationPreference(
    @Path('workspaceId') String workspaceId,
    @Body() UpdateWorkspaceNotificationPreferencePayload body,
  );

  /// Zapisuje pełną ręczną kolejność workspace użytkownika.
  @PUT('/api/v1/workspaces/preferences/order')
  Future<List<WorkspaceListItemResponse>> updateWorkspaceOrder(
    @Body() UpdateWorkspaceOrderPayload body,
  );

  /// Pobiera szczegóły aktywnego workspace.
  @GET('/api/v1/workspaces/{workspaceId}')
  Future<WorkspaceResponse> getWorkspace(
    @Path('workspaceId') String workspaceId,
  );

  /// Aktualizuje nazwę, opis, ikonę i kolor workspace.
  @PATCH('/api/v1/workspaces/{workspaceId}')
  Future<WorkspaceResponse> updateWorkspace(
    @Path('workspaceId') String workspaceId,
    @Body() UpdateWorkspacePayload body,
  );

  /// Archiwizuje workspace bez usuwania danych.
  @POST('/api/v1/workspaces/{workspaceId}/archive')
  Future<WorkspaceResponse> archiveWorkspace(
    @Path('workspaceId') String workspaceId,
  );

  /// Przywraca zarchiwizowany workspace.
  @POST('/api/v1/workspaces/{workspaceId}/restore')
  Future<WorkspaceResponse> restoreWorkspace(
    @Path('workspaceId') String workspaceId,
  );

  /// Pobiera aktywnych członków workspace.
  @GET('/api/v1/workspaces/{workspaceId}/members')
  Future<List<WorkspaceMemberResponse>> listMembers(
    @Path('workspaceId') String workspaceId,
  );

  /// Wyszukuje aktywnych, potwierdzonych użytkowników lokalnego katalogu.
  @GET('/api/v1/workspaces/{workspaceId}/users/search')
  Future<List<LocalUserDirectoryResponse>> searchLocalUsers(
    @Path('workspaceId') String workspaceId,
    @Query('query') String query,
  );

  /// Tworzy zaproszenie do workspace.
  @POST('/api/v1/workspaces/{workspaceId}/invitations')
  Future<WorkspaceInvitationResponse> createInvitation(
    @Path('workspaceId') String workspaceId,
    @Body() CreateWorkspaceInvitationPayload body,
  );

  /// Pobiera wysłane zaproszenia workspace stronicowane kursorem.
  @GET('/api/v1/workspaces/{workspaceId}/invitations')
  Future<CursorPageResponse<WorkspaceInvitationResponse>> listSentInvitations(
    @Path('workspaceId') String workspaceId, {
    @Query('limit') int limit = 30,
    @Query('cursor') String? cursor,
  });

  /// Pobiera zaproszenia otrzymane przez bieżącego użytkownika.
  @GET('/api/v1/workspaces/invitations/me')
  Future<CursorPageResponse<WorkspaceInvitationResponse>>
  listReceivedInvitations({
    @Query('limit') int limit = 30,
    @Query('cursor') String? cursor,
  });

  /// Akceptuje własne, niewygasłe zaproszenie.
  @POST('/api/v1/workspaces/{workspaceId}/invitations/{invitationId}/accept')
  Future<WorkspaceInvitationResponse> acceptInvitation(
    @Path('workspaceId') String workspaceId,
    @Path('invitationId') String invitationId,
  );

  /// Odrzuca własne oczekujące zaproszenie.
  @POST('/api/v1/workspaces/{workspaceId}/invitations/{invitationId}/decline')
  Future<WorkspaceInvitationResponse> declineInvitation(
    @Path('workspaceId') String workspaceId,
    @Path('invitationId') String invitationId,
  );

  /// Anuluje oczekujące zaproszenie workspace.
  @POST('/api/v1/workspaces/{workspaceId}/invitations/{invitationId}/cancel')
  Future<WorkspaceInvitationResponse> cancelInvitation(
    @Path('workspaceId') String workspaceId,
    @Path('invitationId') String invitationId,
  );

  /// Anuluje stare zaproszenie i tworzy nowe dla tego samego użytkownika.
  @POST('/api/v1/workspaces/{workspaceId}/invitations/{invitationId}/resend')
  Future<WorkspaceInvitationResponse> resendInvitation(
    @Path('workspaceId') String workspaceId,
    @Path('invitationId') String invitationId,
  );

  /// Zmienia rolę aktywnego członka workspace.
  @PATCH('/api/v1/workspaces/{workspaceId}/members/{memberId}/role')
  Future<WorkspaceMemberResponse> changeMemberRole(
    @Path('workspaceId') String workspaceId,
    @Path('memberId') String memberId,
    @Body() ChangeWorkspaceMemberRolePayload body,
  );

  /// Cofa członkostwo wskazanego użytkownika.
  @DELETE('/api/v1/workspaces/{workspaceId}/members/{memberId}')
  Future<WorkspaceMemberRevocationResponse> revokeMember(
    @Path('workspaceId') String workspaceId,
    @Path('memberId') String memberId,
  );

  /// Pozwala bieżącemu użytkownikowi opuścić workspace.
  @DELETE('/api/v1/workspaces/{workspaceId}/members/me')
  Future<WorkspaceMemberRevocationResponse> leaveWorkspace(
    @Path('workspaceId') String workspaceId,
  );
}
