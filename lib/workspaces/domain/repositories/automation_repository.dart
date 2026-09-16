import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/workspaces/models/automation_models.dart';

/// Pełny kontrakt reguł, katalogu i diagnostyki automatyzacji projektu.
abstract interface class AutomationRepository {
  Future<Either<ApiError, List<AutomationRuleResponse>>> listRules({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, AutomationCatalogResponse>> getCatalog({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, List<AutomationRecipe>>> listRecipes({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, AutomationRuleResponse>> createRule({
    required String workspaceId,
    required String projectId,
    required CreateAutomationRulePayload payload,
  });

  Future<Either<ApiError, AutomationRuleResponse>> updateRule({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required UpdateAutomationRulePayload payload,
  });

  Future<Either<ApiError, AutomationRuleResponse>> setRuleEnabled({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required SetAutomationRuleEnabledPayload payload,
  });

  Future<Either<ApiError, Unit>> archiveRule({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required int expectedVersion,
  });

  Future<Either<ApiError, AutomationRuleResponse>> installRecipe({
    required String workspaceId,
    required String projectId,
    required String recipeKey,
    required ApplyAutomationRecipePayload payload,
  });

  Future<Either<ApiError, List<AutomationRunResponse>>> listRuns({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    int? pageSize,
  });

  Future<Either<ApiError, AutomationDryRunResponse>> dryRun({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required AutomationDryRunPayload payload,
  });
}
