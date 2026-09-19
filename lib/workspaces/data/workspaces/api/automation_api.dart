import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'automation_api.g.dart';

/// Klient Retrofit reguł i katalogu automatyzacji projektu.
@RestApi()
abstract class AutomationApi {
  /// Tworzy klienta API automatyzacji.
  factory AutomationApi(Dio dio, {String? baseUrl}) = _AutomationApi;

  /// Pobiera reguły automatyzacji projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/')
  Future<List<AutomationRuleResponse>> listRules(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Tworzy aktywną regułę automatyzacji.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/')
  Future<AutomationRuleResponse> createRule(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateAutomationRulePayload payload,
  );

  /// Aktualizuje regułę z kontrolą wersji.
  @PUT(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/{ruleId}',
  )
  Future<AutomationRuleResponse> updateRule(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('ruleId') String ruleId,
    @Body() UpdateAutomationRulePayload payload,
  );

  /// Włącza albo wyłącza regułę automatyzacji.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/{ruleId}/enabled',
  )
  Future<AutomationRuleResponse> setRuleEnabled(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('ruleId') String ruleId,
    @Body() SetAutomationRuleEnabledPayload payload,
  );

  /// Archiwizuje regułę automatyzacji.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/{ruleId}',
  )
  Future<void> archiveRule(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('ruleId') String ruleId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Pobiera katalog obsługiwanych automatyzacji.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/catalog',
  )
  Future<AutomationCatalogResponse> getCatalog(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Pobiera gotowe przepisy automatyzacji.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/recipes',
  )
  Future<List<AutomationRecipe>> listRecipes(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Instaluje gotowy przepis jako nową regułę.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/recipes/{recipeKey}/install',
  )
  Future<AutomationRuleResponse> installRecipe(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('recipeKey') String recipeKey,
    @Body() ApplyAutomationRecipePayload payload,
  );

  /// Pobiera historię uruchomień reguły.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/{ruleId}/runs',
  )
  Future<List<AutomationRunResponse>> listRuns(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('ruleId') String ruleId, {
    @Query('pageSize') int? pageSize,
  });

  /// Symuluje regułę na wskazanym zadaniu bez zapisu zmian.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/automations/{ruleId}/dry-run',
  )
  Future<AutomationDryRunResponse> dryRun(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('ruleId') String ruleId,
    @Body() AutomationDryRunPayload payload,
  );
}
