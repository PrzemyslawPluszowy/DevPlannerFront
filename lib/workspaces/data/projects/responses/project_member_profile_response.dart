import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_member_profile_response.freezed.dart';
part 'project_member_profile_response.g.dart';

/// Bezpieczny profil aktywnego członka projektu do prezentacji w UI.
///
/// Endpoint jest ograniczony ACL projektu. Nie wolno zastępować go odpytywaniem
/// katalogu Core bezpośrednio z aplikacji klienckiej.
@freezed
abstract class ProjectMemberProfileResponse
    with _$ProjectMemberProfileResponse {
  /// Tworzy odpowiedź zgodną z kontraktem Workspaces.
  const factory ProjectMemberProfileResponse({
    /// Kanoniczny lokalny identyfikator użytkownika DevPlanner.
    required String userId,

    /// Nazwa do pokazania w presence i selektorach osób.
    String? displayName,

    /// Bezpieczny URL avatara, jeśli katalog go udostępnia.
    String? avatarUrl,

    /// Skuteczna rola użytkownika w projekcie.
    required ProjectRole role,
  }) = _ProjectMemberProfileResponse;

  /// Odtwarza profil z odpowiedzi JSON API.
  factory ProjectMemberProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberProfileResponseFromJson(json);
}
