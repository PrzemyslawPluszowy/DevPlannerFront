import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_feature_enums.dart';
import 'package:devplanner/workspaces/data/workspaces/api/workspace_feature_api.dart';
import 'package:devplanner/workspaces/data/workspaces/models/workspace_feature_models.dart';
import 'package:devplanner/workspaces/domain/repositories/workspace_features_repository.dart';

/// Implementacja repozytorium dashboardów, aktywności i wyszukiwania.
final class WorkspaceFeaturesRepositoryImpl extends ApiRepository
    implements WorkspaceFeaturesRepository {
  WorkspaceFeaturesRepositoryImpl(this._api);

  final WorkspaceFeatureApi _api;

  @override
  Future<Either<ApiError, DashboardPreferenceResponse>>
  getDashboardPreferences({
    required String workspaceId,
    DashboardContextKind? context,
    String? projectId,
  }) => guardApiCall(
    () => _api.getDashboardPreferences(
      workspaceId,
      context: context?.wireValue,
      projectId: projectId,
    ),
    fallbackMessage: 'Nie udało się pobrać preferencji pulpitu.',
  );

  @override
  Future<Either<ApiError, DashboardPreferenceResponse>>
  updateDashboardPreferences({
    required String workspaceId,
    required UpdateDashboardPreferencePayload payload,
    DashboardContextKind? context,
    String? projectId,
  }) => guardApiCall(
    () => _api.updateDashboardPreferences(
      workspaceId,
      payload,
      context: context?.wireValue,
      projectId: projectId,
    ),
    fallbackMessage: 'Nie udało się zapisać preferencji pulpitu.',
  );

  @override
  Future<Either<ApiError, GlobalSearchResponse>> search({
    required String workspaceId,
    required String query,
    int? limit,
  }) => guardApiCall(
    () => _api.search(workspaceId, query, limit: limit),
    fallbackMessage: 'Nie udało się wykonać wyszukiwania w workspace.',
  );

  @override
  Future<Either<ApiError, HomeDashboardResponse>> getHome(String workspaceId) =>
      guardApiCall(
        () => _api.getHome(workspaceId),
        fallbackMessage: 'Nie udało się pobrać pulpitu głównego workspace.',
      );

  @override
  Future<Either<ApiError, HomeDashboardResponse>> getPersonalDashboard(
    String workspaceId,
  ) => guardApiCall(
    () => _api.getPersonalDashboard(workspaceId),
    fallbackMessage: 'Nie udało się pobrać osobistego pulpitu użytkownika.',
  );

  @override
  Future<Either<ApiError, ProjectDashboardResponse>> getProjectDashboard({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getProjectDashboard(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać pulpitu projektu.',
  );

  @override
  Future<Either<ApiError, WorkspaceActivityPageResponse>> listActivity({
    required String workspaceId,
    String? projectId,
    String? cursor,
    int? limit,
  }) => guardApiCall(
    () => _api.listActivity(
      workspaceId,
      projectId: projectId,
      cursor: cursor,
      limit: limit,
    ),
    fallbackMessage: 'Nie udało się pobrać historii aktywności.',
  );

  @override
  Future<Either<ApiError, List<CrossModuleSyncLinkResponse>>> listSyncLinks({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listSyncLinks(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać powiązań synchronizacji zadań.',
  );
}
