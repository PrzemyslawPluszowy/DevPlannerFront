import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_project_member_role_payload.freezed.dart';
part 'change_project_member_role_payload.g.dart';

/// Payload zmiany roli jawnego członka projektu.
@freezed
abstract class ChangeProjectMemberRolePayload
    with _$ChangeProjectMemberRolePayload {
  /// Tworzy dane zgodne z `ChangeProjectMemberRoleRequest`.
  const factory ChangeProjectMemberRolePayload({
    /// Nowa rola członka projektu.
    required ProjectRole role,
  }) = _ChangeProjectMemberRolePayload;

  /// Odtwarza payload zmiany roli z JSON.
  factory ChangeProjectMemberRolePayload.fromJson(Map<String, dynamic> json) =>
      _$ChangeProjectMemberRolePayloadFromJson(json);
}
