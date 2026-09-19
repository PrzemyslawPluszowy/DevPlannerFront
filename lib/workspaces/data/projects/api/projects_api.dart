import 'package:devplanner/workspaces/data/projects/payloads/change_project_member_role_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/create_project_membership_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/create_project_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_order_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_payload.dart';
import 'package:devplanner/workspaces/data/projects/payloads/update_project_user_preference_payload.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_list_item_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_profile_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'projects_api.g.dart';

/// Klient Retrofit dla endpointów projektów Veloryn Workspaces.
///
/// Wszystkie ścieżki i typy odpowiedzi są odwzorowane bezpośrednio z kontraktów
/// C# z `veloryn-workspaces/Endpoints/Projects/ProjectEndpoints.cs`.
@RestApi()
abstract class ProjectsApi {
  /// Tworzy klienta na bazie uwierzytelnionego klienta Dio Workspaces.
  factory ProjectsApi(Dio dio, {String? baseUrl}) = _ProjectsApi;

  /// Pobiera aktywne projekty dostępne w wskazanym workspace.
  ///
  /// Workspaces filtruje wynik według członkostwa, widoczności projektu oraz
  /// osobistego ukrycia projektu. `includeHidden` pozwala dołączyć projekty
  /// ukryte wyłącznie przez bieżącego użytkownika.
  ///
  /// Endpoint C#: `GET /api/v1/workspaces/{workspaceId}/projects/`.
  @GET('/api/v1/workspaces/{workspaceId}/projects/')
  Future<List<ProjectListItemResponse>> listProjects(
    /// UUID workspace, którego projekty mają zostać pobrane.
    @Path('workspaceId') String workspaceId, {

    /// Czy dołączyć projekty ukryte przez bieżącego użytkownika.
    @Query('includeHidden') bool includeHidden = false,
  });

  /// Tworzy projekt w aktywnym workspace.
  ///
  /// Endpoint wymaga co najmniej roli Member w workspace. Twórca otrzymuje
  /// rolę Owner projektu.
  ///
  /// Endpoint C#: `POST /api/v1/workspaces/{workspaceId}/projects/`.
  @POST('/api/v1/workspaces/{workspaceId}/projects/')
  Future<ProjectResponse> createProject(
    /// UUID workspace, w którym powstanie projekt.
    @Path('workspaceId') String workspaceId,

    /// Dane nowego projektu.
    @Body() CreateProjectPayload body,
  );

  /// Zapisuje pełną ręczną kolejność widocznych projektów użytkownika.
  ///
  /// Endpoint C#: `PUT /api/v1/workspaces/{workspaceId}/projects/preferences/order`.
  @PUT('/api/v1/workspaces/{workspaceId}/projects/preferences/order')
  Future<List<ProjectListItemResponse>> updateProjectOrder(
    /// UUID workspace, którego kolejność projektów jest zmieniana.
    @Path('workspaceId') String workspaceId,

    /// Pełna, niepowtarzalna kolejność widocznych projektów.
    @Body() UpdateProjectOrderPayload body,
  );

  /// Pobiera szczegóły aktywnego projektu.
  ///
  /// Brak dostępu do projektu jest zwracany przez backend jako 404.
  ///
  /// Endpoint C#: `GET /api/v1/workspaces/{workspaceId}/projects/{projectId}`.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}')
  Future<ProjectResponse> getProject(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID projektu.
    @Path('projectId') String projectId,
  );

  /// Aktualizuje dane projektu z ochroną optimistic concurrency po stronie backendu.
  ///
  /// Endpoint C#: `PATCH /api/v1/workspaces/{workspaceId}/projects/{projectId}`.
  @PATCH('/api/v1/workspaces/{workspaceId}/projects/{projectId}')
  Future<ProjectResponse> updateProject(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID aktualizowanego projektu.
    @Path('projectId') String projectId,

    /// Pełny zestaw edytowalnych danych projektu.
    @Body() UpdateProjectPayload body,
  );

  /// Archiwizuje projekt bez usuwania jego historii.
  ///
  /// Endpoint C#: `POST /api/v1/workspaces/{workspaceId}/projects/{projectId}/archive`.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/archive')
  Future<ProjectResponse> archiveProject(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID archiwizowanego projektu.
    @Path('projectId') String projectId,
  );

  /// Przywraca zarchiwizowany projekt do aktywnej listy workspace.
  ///
  /// Endpoint C#: `POST /api/v1/workspaces/{workspaceId}/projects/{projectId}/restore`.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/restore')
  Future<ProjectResponse> restoreProject(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID przywracanego projektu.
    @Path('projectId') String projectId,
  );

  /// Trwale usuwa wcześniej zarchiwizowany projekt.
  ///
  /// Endpoint C#: `DELETE /api/v1/workspaces/{workspaceId}/projects/{projectId}`.
  @DELETE('/api/v1/workspaces/{workspaceId}/projects/{projectId}')
  Future<void> deleteProject(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID zarchiwizowanego projektu.
    @Path('projectId') String projectId,
  );

  /// Pobiera jawnych, aktywnych członków projektu.
  ///
  /// Dla projektu Shared odpowiedź nie zawiera całego dziedziczonego
  /// członkostwa workspace.
  ///
  /// Endpoint C#: `GET /api/v1/workspaces/{workspaceId}/projects/{projectId}/members`.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/members')
  Future<List<ProjectMemberResponse>> listProjectMembers(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID projektu.
    @Path('projectId') String projectId,
  );

  /// Pobiera bezpieczne dane prezentacyjne aktywnych członków projektu.
  ///
  /// Backend wykonuje kontrolę dostępu do projektu przed zwróceniem nazw,
  /// avatarów i ról. Wynik służy m.in. do presence oraz selektorów osób.
  ///
  /// Endpoint C#: `GET /api/v1/workspaces/{workspaceId}/projects/{projectId}/members/profiles`.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/members/profiles')
  Future<CursorPageResponse<ProjectMemberProfileResponse>>
  listProjectMemberProfiles(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID projektu.
    @Path('projectId') String projectId,

    /// Opcjonalna fraza wyszukiwania; backend ogranicza wynik do osób, które
    /// można przypisać w tym projekcie.
    @Query('search') String? search, {

    /// Kursor następnej strony zwrócony przez poprzednie wywołanie.
    @Query('cursor') String? cursor,

    /// Maksymalna liczba profili na stronie (1–100).
    @Query('limit') int? limit,
  });

  /// Dodaje do projektu aktywnego członka tego samego workspace.
  ///
  /// Endpoint C#: `POST /api/v1/workspaces/{workspaceId}/projects/{projectId}/members`.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/members')
  Future<ProjectMemberResponse> createProjectMembership(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID projektu.
    @Path('projectId') String projectId,

    /// Członkostwo workspace i rola w projekcie.
    @Body() CreateProjectMembershipPayload body,
  );

  /// Zmienia rolę jawnego członka projektu.
  ///
  /// Endpoint C#: `PATCH /api/v1/workspaces/{workspaceId}/projects/{projectId}/members/{memberId}/role`.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/members/{memberId}/role',
  )
  Future<ProjectMemberResponse> changeProjectMemberRole(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID projektu.
    @Path('projectId') String projectId,

    /// UUID członkostwa projektu.
    @Path('memberId') String memberId,

    /// Nowa rola członka.
    @Body() ChangeProjectMemberRolePayload body,
  );

  /// Cofa jawne członkostwo użytkownika w projekcie.
  ///
  /// Endpoint C#: `DELETE /api/v1/workspaces/{workspaceId}/projects/{projectId}/members/{memberId}`.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/members/{memberId}',
  )
  Future<ProjectMemberResponse> revokeProjectMember(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID projektu.
    @Path('projectId') String projectId,

    /// UUID członkostwa projektu.
    @Path('memberId') String memberId,
  );

  /// Pozwala bieżącemu użytkownikowi opuścić jawne członkostwo projektu.
  ///
  /// Endpoint C#: `DELETE /api/v1/workspaces/{workspaceId}/projects/{projectId}/members/me`.
  @DELETE('/api/v1/workspaces/{workspaceId}/projects/{projectId}/members/me')
  Future<ProjectMemberResponse> leaveProject(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID opuszczanego projektu.
    @Path('projectId') String projectId,
  );

  /// Aktualizuje osobiste ukrycie i przypięcie projektu.
  ///
  /// Endpoint C#: `PATCH /api/v1/workspaces/{workspaceId}/projects/{projectId}/preferences`.
  @PATCH('/api/v1/workspaces/{workspaceId}/projects/{projectId}/preferences')
  Future<ProjectUserPreferenceResponse> updateProjectUserPreference(
    /// UUID workspace zawierającego projekt.
    @Path('workspaceId') String workspaceId,

    /// UUID projektu.
    @Path('projectId') String projectId,

    /// Nowe ustawienia osobiste bieżącego użytkownika.
    @Body() UpdateProjectUserPreferencePayload body,
  );
}
