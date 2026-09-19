import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_feature_enums.dart';
import 'package:devplanner/workspaces/data/workspaces/models/workspace_feature_models.dart';

/// Kontrakt repozytorium dodatkowych funkcji workspace (dashboardy, wyszukiwanie, aktywność).
abstract interface class WorkspaceFeaturesRepository {
  /// Pobiera preferencje dashboardu użytkownika.
  Future<Either<ApiError, DashboardPreferenceResponse>>
  getDashboardPreferences({
    required String workspaceId,
    DashboardContextKind? context,
    String? projectId,
  });

  /// Zapisuje layout dashboardu.
  Future<Either<ApiError, DashboardPreferenceResponse>>
  updateDashboardPreferences({
    required String workspaceId,
    required UpdateDashboardPreferencePayload payload,
    DashboardContextKind? context,
    String? projectId,
  });

  /// Wyszukuje globalnie w workspace.
  Future<Either<ApiError, GlobalSearchResponse>> search({
    required String workspaceId,
    required String query,
    int? limit,
  });

  /// Pobiera osobisty pulpit workspace.
  Future<Either<ApiError, HomeDashboardResponse>> getHome(String workspaceId);

  /// Pobiera osobisty dashboard użytkownika.
  Future<Either<ApiError, HomeDashboardResponse>> getPersonalDashboard(
    String workspaceId,
  );

  /// Pobiera dashboard projektu.
  Future<Either<ApiError, ProjectDashboardResponse>> getProjectDashboard({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera strumień aktywności workspace/projektu.
  Future<Either<ApiError, WorkspaceActivityPageResponse>> listActivity({
    required String workspaceId,
    String? projectId,
    String? cursor,
    int? limit,
  });

  /// Pobiera linki synchronizacji z zadaniami.
  Future<Either<ApiError, List<CrossModuleSyncLinkResponse>>> listSyncLinks({
    required String workspaceId,
    required String projectId,
  });
}
