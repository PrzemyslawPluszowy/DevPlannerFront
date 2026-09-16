import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';

/// Odczyt ACL‑bezpiecznych danych prezentacyjnych członków projektu.
abstract interface class ProjectMemberProfilesRepository {
  /// Pobiera profile aktywnych członków wskazanego projektu.
  Future<Either<ApiError, List<ProjectMemberProfile>>> listProfiles({
    required String workspaceId,
    required String projectId,
    bool forceRefresh = false,
  });

  /// Pobiera jedną stronę osób dopuszczonych przez ACL projektu.
  Future<Either<ApiError, ProjectMemberProfilePage>> listProfilesPage({
    required String workspaceId,
    required String projectId,
    String? search,
    String? cursor,
    int limit = 30,
  });

  /// Wyszukuje wyłącznie osoby dopuszczone przez ACL wskazanego projektu.
  Future<Either<ApiError, List<ProjectMemberProfile>>> searchProfiles({
    required String workspaceId,
    required String projectId,
    required String query,
  });

  /// Usuwa lokalne dane po zmianie członkostwa albo opuszczeniu projektu.
  void invalidate({required String workspaceId, required String projectId});
}
