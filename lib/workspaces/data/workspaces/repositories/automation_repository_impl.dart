import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/workspaces/api/automation_api.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:devplanner/workspaces/domain/repositories/automation_repository.dart';

/// Adapter API automatyzacji do kontraktu domenowego Workspaces.
final class AutomationRepositoryImpl extends ApiRepository
    implements AutomationRepository {
  AutomationRepositoryImpl(this._api);

  final AutomationApi _api;

  @override
  Future<Either<ApiError, List<AutomationRuleResponse>>> listRules({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listRules(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać automatyzacji projektu.',
  );

  @override
  Future<Either<ApiError, AutomationCatalogResponse>> getCatalog({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getCatalog(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać katalogu automatyzacji.',
  );

  @override
  Future<Either<ApiError, List<AutomationRecipe>>> listRecipes({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listRecipes(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać przepisów automatyzacji.',
  );

  @override
  Future<Either<ApiError, AutomationRuleResponse>> createRule({
    required String workspaceId,
    required String projectId,
    required CreateAutomationRulePayload payload,
  }) => guardApiCall(
    () => _api.createRule(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć automatyzacji.',
  );

  @override
  Future<Either<ApiError, AutomationRuleResponse>> updateRule({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required UpdateAutomationRulePayload payload,
  }) => guardApiCall(
    () => _api.updateRule(workspaceId, projectId, ruleId, payload),
    fallbackMessage: 'Nie udało się zapisać automatyzacji.',
  );

  @override
  Future<Either<ApiError, AutomationRuleResponse>> setRuleEnabled({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required SetAutomationRuleEnabledPayload payload,
  }) => guardApiCall(
    () => _api.setRuleEnabled(workspaceId, projectId, ruleId, payload),
    fallbackMessage: 'Nie udało się zmienić aktywności automatyzacji.',
  );

  @override
  Future<Either<ApiError, Unit>> archiveRule({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required int expectedVersion,
  }) => guardApiCall(
    () async {
      await _api.archiveRule(workspaceId, projectId, ruleId, expectedVersion);
      return unit;
    },
    fallbackMessage: 'Nie udało się zarchiwizować automatyzacji.',
  );

  @override
  Future<Either<ApiError, AutomationRuleResponse>> installRecipe({
    required String workspaceId,
    required String projectId,
    required String recipeKey,
    required ApplyAutomationRecipePayload payload,
  }) => guardApiCall(
    () => _api.installRecipe(workspaceId, projectId, recipeKey, payload),
    fallbackMessage: 'Nie udało się zainstalować przepisu automatyzacji.',
  );

  @override
  Future<Either<ApiError, List<AutomationRunResponse>>> listRuns({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    int? pageSize,
  }) => guardApiCall(
    () => _api.listRuns(
      workspaceId,
      projectId,
      ruleId,
      pageSize: pageSize,
    ),
    fallbackMessage: 'Nie udało się pobrać historii automatyzacji.',
  );

  @override
  Future<Either<ApiError, AutomationDryRunResponse>> dryRun({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required AutomationDryRunPayload payload,
  }) => guardApiCall(
    () => _api.dryRun(workspaceId, projectId, ruleId, payload),
    fallbackMessage: 'Nie udało się przeprowadzić symulacji automatyzacji.',
  );
}
