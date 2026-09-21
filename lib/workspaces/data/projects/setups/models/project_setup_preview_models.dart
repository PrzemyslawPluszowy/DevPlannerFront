import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_setup_preview_models.freezed.dart';
part 'project_setup_preview_models.g.dart';

/// Ostrzeżenie planu kreatora: stabilny kod i komunikat Backendu.
///
/// Odpowiada `ProjectSetupWarningResponse`. Kod służy do tłumaczenia w UI,
/// a komunikat jest wyłącznie zapasem dla nieznanego kodu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupWarningResponse with _$ProjectSetupWarningResponse {
  /// Tworzy ostrzeżenie planu.
  const factory ProjectSetupWarningResponse({
    /// Stabilny kod ostrzeżenia, np. `project_setup.members_ignored_for_shared`.
    required String code,

    /// Komunikat ostrzeżenia dla użytkownika.
    required String message,
  }) = _ProjectSetupWarningResponse;

  /// Odtwarza ostrzeżenie planu z JSON.
  factory ProjectSetupWarningResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupWarningResponseFromJson(json);
}

/// Członek, który otrzyma dostęp do tworzonego projektu.
///
/// Odpowiada `ProjectSetupMemberPreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupMemberPreviewResponse
    with _$ProjectSetupMemberPreviewResponse {
  /// Tworzy pozycję planu członkostw.
  const factory ProjectSetupMemberPreviewResponse({
    /// UUID lokalnego użytkownika.
    required String userId,

    /// Rola nadawana w projekcie.
    required ProjectRole role,

    /// Czy pozycja wynika z tego, że użytkownik tworzy projekt.
    required bool isCreator,
  }) = _ProjectSetupMemberPreviewResponse;

  /// Odtwarza pozycję planu członkostw z JSON.
  factory ProjectSetupMemberPreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupMemberPreviewResponseFromJson(json);
}

/// Podsumowanie szablonu użytego jako źródło projektu.
///
/// Odpowiada `ProjectSetupTemplatePreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupTemplatePreviewResponse
    with _$ProjectSetupTemplatePreviewResponse {
  /// Tworzy podsumowanie szablonu.
  const factory ProjectSetupTemplatePreviewResponse({
    /// UUID użytego szablonu projektu.
    required String templateId,

    /// Nazwa szablonu.
    required String name,

    /// Wersja szablonu użyta do zbudowania planu.
    required int version,

    /// Liczba aktywnych zadań, które powstaną z szablonu.
    required int taskCount,

    /// Liczba etykiet, które powstaną z szablonu.
    required int labelCount,

    /// Liczba pól niestandardowych, które powstaną z szablonu.
    required int customFieldCount,

    /// Liczba własnych statusów workflow, które powstaną z szablonu.
    required int customStatusCount,
  }) = _ProjectSetupTemplatePreviewResponse;

  /// Odtwarza podsumowanie szablonu z JSON.
  factory ProjectSetupTemplatePreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupTemplatePreviewResponseFromJson(json);
}

/// Znormalizowane dane projektu w planie kreatora.
///
/// Odpowiada `ProjectSetupProjectPreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupProjectPreviewResponse
    with _$ProjectSetupProjectPreviewResponse {
  /// Tworzy znormalizowane dane projektu.
  const factory ProjectSetupProjectPreviewResponse({
    /// Nazwa projektu po normalizacji.
    required String name,

    /// Opis projektu po normalizacji.
    String? description,

    /// Ikona projektu po normalizacji.
    String? icon,

    /// Kolor główny projektu po normalizacji.
    String? primaryColor,

    /// Efektywna widoczność projektu.
    required ProjectVisibility visibility,

    /// Efektywny stan projektu.
    required ProjectStatus status,

    /// Czy projekt dziedziczy dostęp wszystkich aktywnych członków workspace.
    required bool inheritsWorkspaceMembers,

    /// Liczba członkostw, które powstaną razem z projektem.
    required int memberCount,

    /// Lista członkostw, które powstaną razem z projektem.
    required List<ProjectSetupMemberPreviewResponse> members,
  }) = _ProjectSetupProjectPreviewResponse;

  /// Odtwarza znormalizowane dane projektu z JSON.
  factory ProjectSetupProjectPreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupProjectPreviewResponseFromJson(json);
}

/// Pojedynczy status własnego workflow w planie kreatora.
///
/// Odpowiada `ProjectSetupWorkflowStatusPreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupWorkflowStatusPreviewResponse
    with _$ProjectSetupWorkflowStatusPreviewResponse {
  /// Tworzy pozycję statusu workflow.
  const factory ProjectSetupWorkflowStatusPreviewResponse({
    /// Nazwa kolumny.
    required String name,

    /// Kolor kolumny.
    required String color,

    /// Kategoria analityczna kolumny.
    required TaskStatusCategory category,

    /// Pozycja kolumny od zera.
    required int position,

    /// Limit WIP kolumny albo null.
    int? wipLimit,

    /// Czy kolumna jest domyślna dla nowych zadań.
    required bool isDefault,
  }) = _ProjectSetupWorkflowStatusPreviewResponse;

  /// Odtwarza pozycję statusu workflow z JSON.
  factory ProjectSetupWorkflowStatusPreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupWorkflowStatusPreviewResponseFromJson(json);
}

/// Workflow, który powstanie razem z projektem.
///
/// Odpowiada `ProjectSetupWorkflowPreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupWorkflowPreviewResponse
    with _$ProjectSetupWorkflowPreviewResponse {
  /// Tworzy opis workflow planu.
  const factory ProjectSetupWorkflowPreviewResponse({
    /// Źródło workflow.
    required ProjectSetupWorkflowKind kind,

    /// Klucz katalogowego szablonu workflow albo null.
    String? templateKey,

    /// Nazwa katalogowego szablonu workflow albo null.
    String? templateName,

    /// Liczba statusów systemowych tworzonych zawsze dla nowego projektu.
    required int systemStatusCount,

    /// Własne statusy workflow, które powstaną razem z projektem.
    required List<ProjectSetupWorkflowStatusPreviewResponse> customStatuses,
  }) = _ProjectSetupWorkflowPreviewResponse;

  /// Odtwarza opis workflow planu z JSON.
  factory ProjectSetupWorkflowPreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupWorkflowPreviewResponseFromJson(json);
}

/// Ustawienia widoku zadań w planie kreatora.
///
/// Odpowiada `ProjectSetupTaskViewPreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupTaskViewPreviewResponse
    with _$ProjectSetupTaskViewPreviewResponse {
  /// Tworzy opis ustawień widoku zadań.
  const factory ProjectSetupTaskViewPreviewResponse({
    /// Domyślny widok modułu Zadania zapisany w projekcie.
    required ProjectSetupTaskViewKind defaultView,

    /// Domyślne kolumny polityki listy zadań.
    required List<String> listDefaultColumns,

    /// Domyślne pole sortowania listy zadań.
    required String listSortField,

    /// Domyślny kierunek sortowania listy zadań.
    required String listSortDirection,

    /// Domyślny sposób grupowania listy zadań.
    required String listGroupBy,

    /// Sposób grupowania kart Kanban.
    required KanbanSwimlaneMode boardSwimlaneMode,

    /// Domyślna gęstość kafelka Kanban.
    required KanbanCardDensity boardCardDensity,

    /// Pola widoczne domyślnie na kafelku Kanban.
    required List<KanbanCardField> boardVisibleCardFields,

    /// Liczba kolumn z limitem WIP.
    required int boardWipLimitCount,

    /// Liczba ukrytych kolumn tablicy.
    required int boardHiddenColumnCount,
  }) = _ProjectSetupTaskViewPreviewResponse;

  /// Odtwarza opis ustawień widoku zadań z JSON.
  factory ProjectSetupTaskViewPreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupTaskViewPreviewResponseFromJson(json);
}

/// Przepis automatyzacji, który zostanie zainstalowany w projekcie.
///
/// Odpowiada `ProjectSetupRecipePreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupRecipePreviewResponse
    with _$ProjectSetupRecipePreviewResponse {
  /// Tworzy pozycję planu automatyzacji.
  const factory ProjectSetupRecipePreviewResponse({
    /// Klucz przepisu z katalogu automatyzacji.
    required String key,

    /// Nazwa przepisu.
    required String name,
  }) = _ProjectSetupRecipePreviewResponse;

  /// Odtwarza pozycję planu automatyzacji z JSON.
  factory ProjectSetupRecipePreviewResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupRecipePreviewResponseFromJson(json);
}

/// Znormalizowany plan utworzenia projektu; preview niczego nie zapisuje.
///
/// Odpowiada `ProjectSetupPreviewResponse`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupPreviewResponse with _$ProjectSetupPreviewResponse {
  /// Tworzy plan utworzenia projektu.
  const factory ProjectSetupPreviewResponse({
    /// Sposób startu projektu przyjęty w planie.
    required ProjectSetupSourceKind source,

    /// Podsumowanie szablonu albo null dla pustego projektu.
    ProjectSetupTemplatePreviewResponse? template,

    /// Znormalizowane dane projektu razem z listą przyszłych członkostw.
    required ProjectSetupProjectPreviewResponse project,

    /// Workflow, który powstanie razem z projektem.
    required ProjectSetupWorkflowPreviewResponse workflow,

    /// Ustawienia widoku zadań, które powstaną razem z projektem.
    required ProjectSetupTaskViewPreviewResponse taskView,

    /// Tryb harmonogramowania projektu.
    required String scheduleMode,

    /// Domyślna dzienna pojemność workspace, jeśli żądanie ją zmienia.
    int? defaultDailyCapacityMinutes,

    /// Przepisy automatyzacji instalowane w projekcie.
    required List<ProjectSetupRecipePreviewResponse> automationRecipes,

    /// Ostrzeżenia planu; nie blokują wykonania.
    required List<ProjectSetupWarningResponse> warnings,

    /// Zadania, które powstaną razem z projektem, każde z nazwą kolumny
    /// docelowej.
    ///
    /// Pole jest opcjonalne, bo starsza wersja planu go nie wysyłała; brak listy
    /// oznacza, że podgląd nadal korzysta z zawartości szablonu.
    @JsonKey(name: 'tasks') List<ProjectSetupTaskPreviewResponse>? tasks,
  }) = _ProjectSetupPreviewResponse;

  /// Odtwarza plan utworzenia projektu z JSON.
  factory ProjectSetupPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupPreviewResponseFromJson(json);
}

/// Zadanie planu kreatora wraz z kolumną, w której powstanie.
///
/// Nazwę kolumny wyznacza Backend tą samą regułą, którą materializuje projekt,
/// więc podgląd nie musi dopasowywać zadań do kolumn po nazwie statusu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupTaskPreviewResponse
    with _$ProjectSetupTaskPreviewResponse {
  /// Tworzy zadanie planu.
  const factory ProjectSetupTaskPreviewResponse({
    /// Tytuł zadania.
    required String title,

    /// Nazwa kolumny (statusu), w której zadanie powstanie.
    required String statusName,

    /// Priorytet zadania w kontrakcie, np. `High`.
    required String priority,

    /// Nazwy etykiet przypisanych do zadania.
    required List<String> labels,
  }) = _ProjectSetupTaskPreviewResponse;

  /// Odtwarza zadanie planu z JSON.
  factory ProjectSetupTaskPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupTaskPreviewResponseFromJson(json);
}
