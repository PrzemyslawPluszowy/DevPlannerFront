import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';

part 'create_project_membership_payload.freezed.dart';
part 'create_project_membership_payload.g.dart';

/// Payload dodania do projektu członka tego samego workspace.
@freezed
abstract class CreateProjectMembershipPayload
    with _$CreateProjectMembershipPayload {
  /// Tworzy dane zgodne z `CreateProjectMembershipRequest`.
  const factory CreateProjectMembershipPayload({
    /// UUID aktywnego członkostwa workspace dodawanej osoby.
    required String workspaceMembershipId,

    /// Rola nadawana w projekcie.
    required ProjectRole role,
  }) = _CreateProjectMembershipPayload;

  /// Odtwarza payload członkostwa z JSON.
  factory CreateProjectMembershipPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectMembershipPayloadFromJson(json);
}
