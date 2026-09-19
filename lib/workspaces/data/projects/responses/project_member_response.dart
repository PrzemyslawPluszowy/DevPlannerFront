import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_member_response.freezed.dart';
part 'project_member_response.g.dart';

/// Jawne członkostwo projektu z kanonicznym lokalnym UserId.
@freezed
abstract class ProjectMemberResponse with _$ProjectMemberResponse {
  /// Tworzy odpowiedź zgodną z `ProjectMemberResponse`.
  const factory ProjectMemberResponse({
    /// UUID członkostwa projektu.
    required String id,

    /// UUID członkostwa użytkownika w workspace.
    required String workspaceMembershipId,

    /// UUID lokalnego użytkownika.
    required String userId,

    /// Rola użytkownika w projekcie.
    required ProjectRole role,

    /// Czas utworzenia członkostwa.
    required DateTime createdAtUtc,

    /// Czas cofnięcia członkostwa albo null.
    DateTime? revokedAtUtc,
  }) = _ProjectMemberResponse;

  /// Odtwarza członkostwo projektu z odpowiedzi JSON.
  factory ProjectMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberResponseFromJson(json);
}
