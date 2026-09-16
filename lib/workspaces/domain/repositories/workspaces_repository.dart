import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_role.dart';
import 'package:ready_next/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';

/// Kontrakt odczytu i zmian głównej domeny Workspace.
///
/// Interfejs należy do domeny, dzięki czemu warstwa prezentacji i Cubity
/// nie zależą bezpośrednio od implementacji Retrofit / Dio.
abstract interface class WorkspacesRepository {
  /// Pobiera aktywne workspace’y bieżącego użytkownika.
  Future<Either<ApiError, List<WorkspaceListItem>>> listWorkspaces({
    bool includeHidden = false,
  });

  /// Pobiera szczegółowe dane pojedynczego workspace'u.
  Future<Either<ApiError, WorkspaceListItem>> getWorkspace(String workspaceId);

  /// Pobiera członków wskazanego workspace’u wraz z rolami.
  Future<Either<ApiError, List<WorkspaceMemberResponse>>> listMembers(
    String workspaceId,
  );

  /// Tworzy workspace; backend nadaje bieżącemu użytkownikowi rolę Owner.
  Future<Either<ApiError, WorkspaceListItem>> createWorkspace({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  });

  /// Zmienia osobiste przypięcie albo ukrycie workspace’u.
  Future<Either<ApiError, void>> updateWorkspacePreference({
    required String workspaceId,
    bool? isHidden,
    bool? isPinned,
  });

  /// Zapisuje atomową kolejność widocznych workspace’ów.
  Future<Either<ApiError, List<WorkspaceListItem>>> updateWorkspaceOrder(
    List<String> workspaceIds,
  );

  /// Aktualizuje dane workspace’u (nazwa, opis, ikona, kolor).
  Future<Either<ApiError, WorkspaceListItem>> updateWorkspace({
    required String workspaceId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  });

  /// Archiwizuje workspace bez usuwania powiązanych danych.
  Future<Either<ApiError, WorkspaceListItem>> archiveWorkspace(
    String workspaceId,
  );

  /// Przywraca zarchiwizowany workspace.
  Future<Either<ApiError, WorkspaceListItem>> restoreWorkspace(
    String workspaceId,
  );

  /// Zmienia rolę członka w przestrzeni roboczej.
  Future<Either<ApiError, WorkspaceMemberResponse>> changeMemberRole({
    required String workspaceId,
    required String memberId,
    required WorkspaceRole role,
  });

  /// Cofa członkostwo użytkownika w przestrzeni roboczej.
  Future<Either<ApiError, WorkspaceMemberRevocationResponse>> revokeMember({
    required String workspaceId,
    required String memberId,
  });

  /// Wyszukuje użytkowników Ready do zaproszenia.
  Future<Either<ApiError, List<ReadyDirectoryUserResponse>>> searchReadyUsers({
    required String workspaceId,
    required String query,
  });

  /// Tworzy zaproszenie dla użytkownika Ready.
  Future<Either<ApiError, WorkspaceInvitationResponse>> createInvitation({
    required String workspaceId,
    required CreateWorkspaceInvitationPayload payload,
  });

  /// Pobiera listę wysłanych zaproszeń workspace'u.
  Future<Either<ApiError, CursorPageResponse<WorkspaceInvitationResponse>>>
  listSentInvitations({
    required String workspaceId,
    int limit = 30,
    String? cursor,
  });

  /// Anuluje oczekujące zaproszenie.
  Future<Either<ApiError, WorkspaceInvitationResponse>> cancelInvitation({
    required String workspaceId,
    required String invitationId,
  });

  /// Ponawia wysłanie zaproszenia.
  Future<Either<ApiError, WorkspaceInvitationResponse>> resendInvitation({
    required String workspaceId,
    required String invitationId,
  });

  /// Pobiera listę zaproszeń otrzymanych przez bieżącego użytkownika.
  Future<Either<ApiError, CursorPageResponse<WorkspaceInvitationResponse>>>
  listReceivedInvitations({int limit = 30, String? cursor});

  /// Akceptuje zaproszenie do workspace.
  Future<Either<ApiError, WorkspaceInvitationResponse>> acceptInvitation({
    required String workspaceId,
    required String invitationId,
  });

  /// Odrzuca zaproszenie do workspace.
  Future<Either<ApiError, WorkspaceInvitationResponse>> declineInvitation({
    required String workspaceId,
    required String invitationId,
  });

  /// Pozwala bieżącemu użytkownikowi opuścić workspace.
  Future<Either<ApiError, WorkspaceMemberRevocationResponse>> leaveWorkspace(
    String workspaceId,
  );

  /// Pobiera osobiste preferencje powiadomień workspace'u.
  Future<Either<ApiError, WorkspaceNotificationPreferenceResponse>>
  getNotificationPreference(String workspaceId);

  /// Aktualizuje osobiste preferencje powiadomień workspace'u.
  Future<Either<ApiError, WorkspaceNotificationPreferenceResponse>>
  updateNotificationPreference({
    required String workspaceId,
    required UpdateWorkspaceNotificationPreferencePayload payload,
  });
}
