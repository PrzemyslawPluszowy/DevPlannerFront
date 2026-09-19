import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_invitation_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_responses.freezed.dart';
part 'workspace_responses.g.dart';

/// Workspace z osobistymi ustawieniami prezentacji.
@freezed
abstract class WorkspaceListItemResponse with _$WorkspaceListItemResponse {
  /// Tworzy element listy workspace.
  const factory WorkspaceListItemResponse({
    required String id,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    required bool isPinned,
    @Default(false) bool isHidden,
    int? sortPosition,
    String? createdByCoreUserId,
    @Default(false) bool isOwner,
  }) = _WorkspaceListItemResponse;

  /// Odtwarza element listy z JSON.
  factory WorkspaceListItemResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceListItemResponseFromJson(json);
}

/// Publiczne szczegóły workspace.
@freezed
abstract class WorkspaceResponse with _$WorkspaceResponse {
  /// Tworzy odpowiedź workspace.
  const factory WorkspaceResponse({
    required String id,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    required String createdByCoreUserId,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    DateTime? archivedAtUtc,
  }) = _WorkspaceResponse;

  /// Odtwarza workspace z JSON.
  factory WorkspaceResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceResponseFromJson(json);
}

/// Osobiste ustawienia prezentacji workspace.
@freezed
abstract class WorkspaceUserPreferenceResponse
    with _$WorkspaceUserPreferenceResponse {
  /// Tworzy odpowiedź preferencji workspace.
  const factory WorkspaceUserPreferenceResponse({
    required String workspaceId,
    required bool isHidden,
    required bool isPinned,
    int? sortPosition,
  }) = _WorkspaceUserPreferenceResponse;

  /// Odtwarza preferencje z JSON.
  factory WorkspaceUserPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceUserPreferenceResponseFromJson(json);
}

/// Preferencje powiadomień użytkownika dla workspace.
@freezed
abstract class WorkspaceNotificationPreferenceResponse
    with _$WorkspaceNotificationPreferenceResponse {
  /// Tworzy odpowiedź preferencji powiadomień.
  const factory WorkspaceNotificationPreferenceResponse({
    required String workspaceId,
    required bool inAppEnabled,
    required bool emailEnabled,
    required bool tasksEnabled,
    required bool projectsEnabled,
    required bool workspaceEnabled,
    required bool membershipEnabled,
    required bool invitationsEnabled,
    required bool adminEnabled,
    required bool ownerEnabled,
  }) = _WorkspaceNotificationPreferenceResponse;

  /// Odtwarza preferencje powiadomień z JSON.
  factory WorkspaceNotificationPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WorkspaceNotificationPreferenceResponseFromJson(json);
}

/// Aktywne członkostwo użytkownika w workspace.
@freezed
abstract class WorkspaceMemberResponse with _$WorkspaceMemberResponse {
  /// Tworzy odpowiedź członkostwa.
  const factory WorkspaceMemberResponse({
    required String id,
    required String userId,
    required WorkspaceRole role,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
  }) = _WorkspaceMemberResponse;

  /// Odtwarza członkostwo z JSON.
  factory WorkspaceMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceMemberResponseFromJson(json);
}

/// Potwierdzenie cofnięcia członkostwa workspace.
@freezed
abstract class WorkspaceMemberRevocationResponse
    with _$WorkspaceMemberRevocationResponse {
  /// Tworzy odpowiedź cofnięcia członkostwa.
  const factory WorkspaceMemberRevocationResponse({
    required String membershipId,
    required DateTime revokedAtUtc,
  }) = _WorkspaceMemberRevocationResponse;

  /// Odtwarza odpowiedź z JSON.
  factory WorkspaceMemberRevocationResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WorkspaceMemberRevocationResponseFromJson(json);
}

/// Minimalny lokalny użytkownik dostępny jako kandydat do zaproszenia.
@freezed
abstract class LocalUserDirectoryResponse with _$LocalUserDirectoryResponse {
  /// Tworzy wynik wyszukiwania lokalnego katalogu użytkowników.
  const factory LocalUserDirectoryResponse({
    required String userId,
    required String login,
    required String displayName,
    String? email,
    required bool emailVerified,
    String? avatarFileId,
  }) = _LocalUserDirectoryResponse;

  /// Odtwarza użytkownika z JSON.
  factory LocalUserDirectoryResponse.fromJson(Map<String, dynamic> json) =>
      _$LocalUserDirectoryResponseFromJson(json);
}

/// Bezpieczny widok zaproszenia do workspace.
@freezed
abstract class WorkspaceInvitationResponse with _$WorkspaceInvitationResponse {
  /// Tworzy odpowiedź zaproszenia.
  const factory WorkspaceInvitationResponse({
    required String id,
    required String workspaceId,
    required String userId,
    required WorkspaceRole role,
    required WorkspaceInvitationStatus status,
    required String login,
    required String displayName,
    String? email,
    String? message,
    required DateTime createdAtUtc,
    required DateTime expiresAtUtc,
    DateTime? respondedAtUtc,
  }) = _WorkspaceInvitationResponse;

  /// Odtwarza zaproszenie z JSON.
  factory WorkspaceInvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceInvitationResponseFromJson(json);
}

/// Strona zaproszeń workspace.
typedef WorkspaceInvitationPage =
    CursorPageResponse<WorkspaceInvitationResponse>;
