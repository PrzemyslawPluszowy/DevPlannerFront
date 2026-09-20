import 'package:devplanner/workspaces/data/projects/responses/project_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_setup_result_models.freezed.dart';
part 'project_setup_result_models.g.dart';

/// Instalowana reguła automatyzacji.
///
/// Odpowiada `ProjectSetupAutomationRuleResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupAutomationRuleResponse
    with _$ProjectSetupAutomationRuleResponse {
  /// Tworzy pozycję zainstalowanej reguły.
  const factory ProjectSetupAutomationRuleResponse({
    /// UUID utworzonej reguły automatyzacji.
    required String id,

    /// Klucz przepisu, z którego powstała reguła.
    required String recipeKey,

    /// Nazwa reguły.
    required String name,

    /// Czy reguła jest aktywna po utworzeniu.
    required bool isEnabled,
  }) = _ProjectSetupAutomationRuleResponse;

  /// Odtwarza zainstalowaną regułę z JSON.
  factory ProjectSetupAutomationRuleResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupAutomationRuleResponseFromJson(json);
}

/// Workflow zapisany razem z projektem.
///
/// Odpowiada `ProjectSetupWorkflowResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupWorkflowResponse
    with _$ProjectSetupWorkflowResponse {
  /// Tworzy opis zapisanego workflow.
  const factory ProjectSetupWorkflowResponse({
    /// Źródło workflow zapisane w projekcie.
    required ProjectSetupWorkflowKind kind,

    /// Klucz katalogowego szablonu workflow albo null.
    String? templateKey,

    /// Liczba zapisanych własnych statusów workflow.
    required int customStatusCount,

    /// Liczba zapisanych statusów systemowych.
    required int systemStatusCount,
  }) = _ProjectSetupWorkflowResponse;

  /// Odtwarza opis zapisanego workflow z JSON.
  factory ProjectSetupWorkflowResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupWorkflowResponseFromJson(json);
}

/// Ustawienia widoku zadań zapisane razem z projektem.
///
/// Odpowiada `ProjectSetupTaskViewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupTaskViewResponse
    with _$ProjectSetupTaskViewResponse {
  /// Tworzy opis zapisanych ustawień widoku.
  const factory ProjectSetupTaskViewResponse({
    /// Domyślny widok modułu Zadania zapisany w projekcie.
    required ProjectSetupTaskViewKind defaultView,

    /// Wersja zapisanej polityki listy zadań.
    required int listPolicyVersion,

    /// Wersja zapisanych ustawień tablicy Kanban.
    required int boardSettingsVersion,
  }) = _ProjectSetupTaskViewResponse;

  /// Odtwarza opis zapisanych ustawień widoku z JSON.
  factory ProjectSetupTaskViewResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupTaskViewResponseFromJson(json);
}

/// Wynik atomowego kreatora projektu wraz z informacją o odtworzeniu.
///
/// Odpowiada `ProjectSetupResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupResponse with _$ProjectSetupResponse {
  /// Tworzy wynik kreatora projektu.
  const factory ProjectSetupResponse({
    /// Utworzony projekt razem z wersją i capabilities twórcy.
    required ProjectResponse project,

    /// Workflow zapisany razem z projektem.
    required ProjectSetupWorkflowResponse workflow,

    /// Ustawienia widoku zadań zapisane razem z projektem.
    required ProjectSetupTaskViewResponse taskView,

    /// Tryb harmonogramowania zapisany w projekcie.
    required String scheduleMode,

    /// Liczba członkostw utworzonych razem z projektem.
    required int memberCount,

    /// Reguły automatyzacji zainstalowane razem z projektem.
    required List<ProjectSetupAutomationRuleResponse> automationRules,

    /// Klucz idempotencji, którym oznaczono operację.
    required String idempotencyKey,

    /// Czy odpowiedź odtworzono z wcześniej zapisanego wyniku.
    required bool replayed,

    /// Czas zatwierdzenia operacji w UTC.
    required DateTime completedAtUtc,
  }) = _ProjectSetupResponse;

  /// Odtwarza wynik kreatora projektu z JSON.
  factory ProjectSetupResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupResponseFromJson(json);
}
