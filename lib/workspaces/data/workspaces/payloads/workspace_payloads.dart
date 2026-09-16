import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_role.dart';

part 'workspace_payloads.freezed.dart';
part 'workspace_payloads.g.dart';

/// Payload utworzenia workspace.
@freezed
abstract class CreateWorkspacePayload with _$CreateWorkspacePayload {
  /// Tworzy dane nowego workspace.
  const factory CreateWorkspacePayload({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) = _CreateWorkspacePayload;

  /// Odtwarza payload z JSON.
  factory CreateWorkspacePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateWorkspacePayloadFromJson(json);
}

/// Payload aktualizacji workspace.
@freezed
abstract class UpdateWorkspacePayload with _$UpdateWorkspacePayload {
  /// Tworzy dane edytowalne workspace.
  const factory UpdateWorkspacePayload({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) = _UpdateWorkspacePayload;

  /// Odtwarza payload z JSON.
  factory UpdateWorkspacePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkspacePayloadFromJson(json);
}

/// Payload osobistych ustawień workspace na liście.
@freezed
abstract class UpdateWorkspaceUserPreferencePayload
    with _$UpdateWorkspaceUserPreferencePayload {
  /// Tworzy zmianę ukrycia lub przypięcia workspace.
  const factory UpdateWorkspaceUserPreferencePayload({
    bool? isHidden,
    bool? isPinned,
  }) = _UpdateWorkspaceUserPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateWorkspaceUserPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateWorkspaceUserPreferencePayloadFromJson(json);
}

/// Payload pełnej ręcznej kolejności workspace.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateWorkspaceOrderPayload with _$UpdateWorkspaceOrderPayload {
  /// Tworzy kolejność wszystkich widocznych workspace.
  const factory UpdateWorkspaceOrderPayload({
    required List<String> workspaceIds,
  }) = _UpdateWorkspaceOrderPayload;

  /// Odtwarza payload z JSON.
  factory UpdateWorkspaceOrderPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkspaceOrderPayloadFromJson(json);
}

/// Payload preferencji powiadomień workspace.
@freezed
abstract class UpdateWorkspaceNotificationPreferencePayload
    with _$UpdateWorkspaceNotificationPreferencePayload {
  /// Tworzy częściową zmianę preferencji powiadomień; null pozostawia wartość.
  const factory UpdateWorkspaceNotificationPreferencePayload({
    bool? inAppEnabled,
    bool? emailEnabled,
    bool? tasksEnabled,
    bool? projectsEnabled,
    bool? workspaceEnabled,
    bool? membershipEnabled,
    bool? invitationsEnabled,
    bool? adminEnabled,
    bool? ownerEnabled,
  }) = _UpdateWorkspaceNotificationPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateWorkspaceNotificationPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateWorkspaceNotificationPreferencePayloadFromJson(json);
}

/// Payload utworzenia zaproszenia dla użytkownika Ready.
@freezed
abstract class CreateWorkspaceInvitationPayload
    with _$CreateWorkspaceInvitationPayload {
  /// Tworzy zaproszenie z rolą nadawaną po akceptacji.
  const factory CreateWorkspaceInvitationPayload({
    required int readyUserId,
    required WorkspaceRole role,
    String? message,
  }) = _CreateWorkspaceInvitationPayload;

  /// Odtwarza payload z JSON.
  factory CreateWorkspaceInvitationPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateWorkspaceInvitationPayloadFromJson(json);
}

/// Payload zmiany roli członka workspace.
@freezed
abstract class ChangeWorkspaceMemberRolePayload
    with _$ChangeWorkspaceMemberRolePayload {
  /// Tworzy zmianę roli członka.
  const factory ChangeWorkspaceMemberRolePayload({
    required WorkspaceRole role,
  }) = _ChangeWorkspaceMemberRolePayload;

  /// Odtwarza payload z JSON.
  factory ChangeWorkspaceMemberRolePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$ChangeWorkspaceMemberRolePayloadFromJson(json);
}
