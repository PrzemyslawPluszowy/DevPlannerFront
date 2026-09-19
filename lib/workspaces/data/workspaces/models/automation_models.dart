import 'package:devplanner/workspaces/data/shared/enums/automation_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'automation_models.freezed.dart';
part 'automation_models.g.dart';

/// Typed warunek reguły automatyzacji.
@freezed
abstract class AutomationCondition with _$AutomationCondition {
  /// Definiuje typ warunku i jego parametry.
  const factory AutomationCondition({
    required AutomationConditionType type,
    ProjectTaskStatus? status,
    TaskPriority? priority,
    String? userId,
    String? labelId,
    int? days,
    String? text,
  }) = _AutomationCondition;

  /// Odtwarza warunek z JSON.
  factory AutomationCondition.fromJson(Map<String, dynamic> json) =>
      _$AutomationConditionFromJson(json);
}

/// Typed akcja reguły automatyzacji.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AutomationAction with _$AutomationAction {
  /// Definiuje typ akcji i opcjonalne parametry.
  const factory AutomationAction({
    required AutomationActionType type,
    ProjectTaskStatus? status,
    TaskPriority? priority,
    String? userId,
    String? labelId,
    DateTime? dueAtUtc,
    String? text,
    String? title,
    String? description,
    String? conversationId,
    String? keyResultId,
    double? value,
    String? webhookUrl,
    Map<String, dynamic>? payload,
    String? storageFileId,
  }) = _AutomationAction;

  /// Odtwarza akcję z JSON.
  factory AutomationAction.fromJson(Map<String, dynamic> json) =>
      _$AutomationActionFromJson(json);
}

/// Payload utworzenia reguły automatyzacji.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateAutomationRulePayload with _$CreateAutomationRulePayload {
  /// Definiuje wyzwalacz, warunki i akcje.
  const factory CreateAutomationRulePayload({
    required String name,
    required AutomationTriggerType triggerType,
    required Map<String, dynamic> triggerConfig,
    required List<AutomationCondition> conditions,
    required List<AutomationAction> actions,
  }) = _CreateAutomationRulePayload;

  /// Odtwarza payload z JSON.
  factory CreateAutomationRulePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateAutomationRulePayloadFromJson(json);
}

/// Payload aktualizacji reguły automatyzacji.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateAutomationRulePayload with _$UpdateAutomationRulePayload {
  /// Zawiera pełną definicję i oczekiwaną wersję.
  const factory UpdateAutomationRulePayload({
    required String name,
    required AutomationTriggerType triggerType,
    required Map<String, dynamic> triggerConfig,
    required List<AutomationCondition> conditions,
    required List<AutomationAction> actions,
    required int expectedVersion,
  }) = _UpdateAutomationRulePayload;

  /// Odtwarza payload z JSON.
  factory UpdateAutomationRulePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateAutomationRulePayloadFromJson(json);
}

/// Payload zmiany aktywności reguły.
@freezed
abstract class SetAutomationRuleEnabledPayload
    with _$SetAutomationRuleEnabledPayload {
  /// Ustawia aktywność i wersję reguły.
  const factory SetAutomationRuleEnabledPayload({
    required bool enabled,
    required int expectedVersion,
  }) = _SetAutomationRuleEnabledPayload;

  /// Odtwarza payload z JSON.
  factory SetAutomationRuleEnabledPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$SetAutomationRuleEnabledPayloadFromJson(json);
}

/// Odpowiedź reguły automatyzacji.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AutomationRuleResponse with _$AutomationRuleResponse {
  /// Zwraca definicję, statystyki wykonania i wersję reguły.
  const factory AutomationRuleResponse({
    required String id,
    required String projectId,
    required String name,
    required AutomationTriggerType triggerType,
    required Map<String, dynamic> triggerConfig,
    required List<AutomationCondition> conditions,
    required List<AutomationAction> actions,
    required bool isEnabled,
    required int executionCount,
    DateTime? lastExecutedAtUtc,
    required DateTime updatedAtUtc,
    required int version,
    DateTime? archivedAtUtc,
  }) = _AutomationRuleResponse;

  /// Odtwarza regułę z JSON.
  factory AutomationRuleResponse.fromJson(Map<String, dynamic> json) =>
      _$AutomationRuleResponseFromJson(json);
}

/// Historia uruchomienia reguły.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AutomationRunResponse with _$AutomationRunResponse {
  /// Zwraca stan, czas, korelację i szczegóły wykonania.
  const factory AutomationRunResponse({
    required String id,
    required String ruleId,
    required String triggerEventId,
    required String triggerSourceEntity,
    required String triggerSourceEntityId,
    required AutomationRunStatus status,
    required int durationMs,
    String? errorMessage,
    required Map<String, dynamic> executionDetails,
    required DateTime executedAtUtc,
    required String correlationId,
    required int chainDepth,
  }) = _AutomationRunResponse;

  /// Odtwarza uruchomienie z JSON.
  factory AutomationRunResponse.fromJson(Map<String, dynamic> json) =>
      _$AutomationRunResponseFromJson(json);
}

/// Payload symulacji reguły na zadaniu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AutomationDryRunPayload with _$AutomationDryRunPayload {
  /// Wskazuje zadanie i opcjonalny payload zdarzenia.
  const factory AutomationDryRunPayload({
    required String taskId,
    required Map<String, dynamic> eventPayload,
  }) = _AutomationDryRunPayload;

  /// Odtwarza payload z JSON.
  factory AutomationDryRunPayload.fromJson(Map<String, dynamic> json) =>
      _$AutomationDryRunPayloadFromJson(json);
}

/// Podgląd akcji w symulacji.
@freezed
abstract class AutomationActionPreview with _$AutomationActionPreview {
  /// Zwraca obsługę i opis akcji.
  const factory AutomationActionPreview({
    required AutomationActionType type,
    required bool supported,
    required String description,
  }) = _AutomationActionPreview;

  /// Odtwarza podgląd z JSON.
  factory AutomationActionPreview.fromJson(Map<String, dynamic> json) =>
      _$AutomationActionPreviewFromJson(json);
}

/// Wynik symulacji reguły.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AutomationDryRunResponse with _$AutomationDryRunResponse {
  /// Zwraca dopasowanie warunków i planowane akcje.
  const factory AutomationDryRunResponse({
    required String ruleId,
    required String taskId,
    required bool conditionsMatched,
    required List<AutomationActionPreview> actions,
    String? skipReason,
  }) = _AutomationDryRunResponse;

  /// Odtwarza wynik z JSON.
  factory AutomationDryRunResponse.fromJson(Map<String, dynamic> json) =>
      _$AutomationDryRunResponseFromJson(json);
}

/// Gotowy przepis automatyzacji.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AutomationRecipe with _$AutomationRecipe {
  /// Zawiera kompletną definicję przepisu.
  const factory AutomationRecipe({
    required String key,
    required String name,
    required String description,
    required AutomationTriggerType triggerType,
    required Map<String, dynamic> triggerConfig,
    required List<AutomationCondition> conditions,
    required List<AutomationAction> actions,
  }) = _AutomationRecipe;

  /// Odtwarza przepis z JSON.
  factory AutomationRecipe.fromJson(Map<String, dynamic> json) =>
      _$AutomationRecipeFromJson(json);
}

/// Payload instalacji przepisu automatyzacji.
@freezed
abstract class ApplyAutomationRecipePayload
    with _$ApplyAutomationRecipePayload {
  /// Pozwala opcjonalnie nadpisać nazwę i przekazać wersję bazową.
  const factory ApplyAutomationRecipePayload({
    String? name,
    int? expectedVersion,
  }) = _ApplyAutomationRecipePayload;

  /// Odtwarza payload z JSON.
  factory ApplyAutomationRecipePayload.fromJson(Map<String, dynamic> json) =>
      _$ApplyAutomationRecipePayloadFromJson(json);
}

/// Definicja typu wyzwalacza w katalogu automatyzacji.
@freezed
abstract class AutomationTriggerDefinition with _$AutomationTriggerDefinition {
  /// Zwraca obsługę i opis wyzwalacza.
  const factory AutomationTriggerDefinition({
    required AutomationTriggerType type,
    required bool supported,
    required String description,
  }) = _AutomationTriggerDefinition;

  /// Odtwarza definicję z JSON.
  factory AutomationTriggerDefinition.fromJson(Map<String, dynamic> json) =>
      _$AutomationTriggerDefinitionFromJson(json);
}

/// Definicja typu warunku w katalogu automatyzacji.
@freezed
abstract class AutomationConditionDefinition
    with _$AutomationConditionDefinition {
  /// Zwraca opis warunku.
  const factory AutomationConditionDefinition({
    required AutomationConditionType type,
    required String description,
  }) = _AutomationConditionDefinition;

  /// Odtwarza definicję z JSON.
  factory AutomationConditionDefinition.fromJson(Map<String, dynamic> json) =>
      _$AutomationConditionDefinitionFromJson(json);
}

/// Definicja typu akcji w katalogu automatyzacji.
@freezed
abstract class AutomationActionDefinition with _$AutomationActionDefinition {
  /// Zwraca obsługę i opis akcji.
  const factory AutomationActionDefinition({
    required AutomationActionType type,
    required bool supported,
    required String description,
  }) = _AutomationActionDefinition;

  /// Odtwarza definicję z JSON.
  factory AutomationActionDefinition.fromJson(Map<String, dynamic> json) =>
      _$AutomationActionDefinitionFromJson(json);
}

/// Katalog wyzwalaczy, warunków i akcji.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AutomationCatalogResponse with _$AutomationCatalogResponse {
  /// Zwraca typed katalog automatyzacji.
  const factory AutomationCatalogResponse({
    required List<AutomationTriggerDefinition> triggers,
    required List<AutomationConditionDefinition> conditions,
    required List<AutomationActionDefinition> actions,
  }) = _AutomationCatalogResponse;

  /// Odtwarza katalog z JSON.
  factory AutomationCatalogResponse.fromJson(Map<String, dynamic> json) =>
      _$AutomationCatalogResponseFromJson(json);
}
