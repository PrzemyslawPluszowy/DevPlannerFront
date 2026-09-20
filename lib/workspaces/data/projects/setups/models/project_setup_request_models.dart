import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_setup_request_models.freezed.dart';
part 'project_setup_request_models.g.dart';

/// Sposób startu projektu wraz z wersją użytego szablonu.
///
/// Odpowiada `ProjectSetupSourceRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupSourceRequest with _$ProjectSetupSourceRequest {
  /// Tworzy sekcję źródła kreatora.
  const factory ProjectSetupSourceRequest({
    /// `Blank` albo `ProjectTemplate`.
    required ProjectSetupSourceKind kind,

    /// UUID szablonu; wymagany wyłącznie dla `kind = projectTemplate`.
    String? templateId,

    /// Wersja szablonu z ostatniego odczytu; niezgodność zwraca 409.
    int? expectedVersion,
  }) = _ProjectSetupSourceRequest;

  /// Odtwarza sekcję źródła z JSON.
  factory ProjectSetupSourceRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupSourceRequestFromJson(json);
}

/// Podstawowe dane tworzonego projektu.
///
/// Odpowiada `ProjectSetupProjectRequest`. Brak wartości oznacza, że Backend
/// użyje danych z szablonu, a dla pustego projektu — wartości domyślnej.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupProjectRequest with _$ProjectSetupProjectRequest {
  /// Tworzy sekcję danych projektu.
  const factory ProjectSetupProjectRequest({
    /// Nazwa projektu od 1 do 160 znaków.
    required String name,

    /// Opis projektu do 4000 znaków.
    String? description,

    /// Identyfikator ikony prezentacyjnej projektu.
    String? icon,

    /// Kolor główny w formacie `#RRGGBB` albo `#RRGGBBAA`.
    String? primaryColor,

    /// Widoczność projektu.
    ProjectVisibility? visibility,

    /// Stan projektu.
    ProjectStatus? status,
  }) = _ProjectSetupProjectRequest;

  /// Odtwarza sekcję danych projektu z JSON.
  factory ProjectSetupProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupProjectRequestFromJson(json);
}

/// Początkowy członek projektu Private wraz z rolą.
///
/// Odpowiada `ProjectSetupMemberAssignmentRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupMemberAssignmentRequest
    with _$ProjectSetupMemberAssignmentRequest {
  /// Tworzy przypisanie członka.
  const factory ProjectSetupMemberAssignmentRequest({
    /// UUID lokalnego użytkownika z aktywnym członkostwem w workspace.
    required String userId,

    /// Rola nadawana w projekcie.
    required ProjectRole role,
  }) = _ProjectSetupMemberAssignmentRequest;

  /// Odtwarza przypisanie członka z JSON.
  factory ProjectSetupMemberAssignmentRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupMemberAssignmentRequestFromJson(json);
}

/// Wybór workflow zadań dla tworzonego projektu.
///
/// Odpowiada `ProjectSetupWorkflowRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupWorkflowRequest with _$ProjectSetupWorkflowRequest {
  /// Tworzy sekcję workflow.
  const factory ProjectSetupWorkflowRequest({
    /// `Default`, `CatalogTemplate` albo `ExplicitStatuses`.
    required ProjectSetupWorkflowKind kind,

    /// Klucz katalogowego szablonu; wymagany dla `catalogTemplate`.
    String? templateKey,

    /// Jawne statusy; wymagane dla `explicitStatuses`.
    List<ProjectSetupWorkflowStatusRequest>? statuses,
  }) = _ProjectSetupWorkflowRequest;

  /// Odtwarza sekcję workflow z JSON.
  factory ProjectSetupWorkflowRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupWorkflowRequestFromJson(json);
}

/// Jeden jawny status własnego workflow projektu.
///
/// Odpowiada `ProjectSetupWorkflowStatusRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupWorkflowStatusRequest
    with _$ProjectSetupWorkflowStatusRequest {
  /// Tworzy jawny status workflow.
  const factory ProjectSetupWorkflowStatusRequest({
    /// Nazwa kolumny do 60 znaków.
    required String name,

    /// Kolor kolumny w formacie `#RRGGBB` albo `#RRGGBBAA`.
    required String color,

    /// Kategoria analityczna kolumny.
    required TaskStatusCategory category,

    /// Opcjonalny limit WIP w zakresie 1-999.
    int? wipLimit,

    /// Czy status jest domyślny dla nowych zadań.
    required bool isDefault,
  }) = _ProjectSetupWorkflowStatusRequest;

  /// Odtwarza jawny status workflow z JSON.
  factory ProjectSetupWorkflowStatusRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupWorkflowStatusRequestFromJson(json);
}

/// Ustawienia widoku zadań tworzone razem z projektem.
///
/// Odpowiada `ProjectSetupTaskViewRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupTaskViewRequest with _$ProjectSetupTaskViewRequest {
  /// Tworzy sekcję widoku zadań.
  const factory ProjectSetupTaskViewRequest({
    /// Domyślny widok modułu Zadania.
    required ProjectSetupTaskViewKind defaultView,

    /// Opcjonalne ustawienia polityki listy zadań.
    ProjectSetupListSettingsRequest? list,

    /// Opcjonalne ustawienia tablicy Kanban.
    ProjectSetupBoardSettingsRequest? board,
  }) = _ProjectSetupTaskViewRequest;

  /// Odtwarza sekcję widoku zadań z JSON.
  factory ProjectSetupTaskViewRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupTaskViewRequestFromJson(json);
}

/// Polityka kolumn listy zadań projektu.
///
/// Odpowiada `ProjectSetupListSettingsRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupListSettingsRequest
    with _$ProjectSetupListSettingsRequest {
  /// Tworzy ustawienia polityki listy.
  const factory ProjectSetupListSettingsRequest({
    /// Domyślna kolejność kolumn listy.
    List<String>? defaultColumns,

    /// Domyślne pole sortowania listy.
    TaskSavedViewSortField? defaultSortField,

    /// Domyślny kierunek sortowania listy.
    TaskSavedViewSortDirection? defaultSortDirection,

    /// Domyślny sposób grupowania listy.
    TaskSavedViewGroupBy? defaultGroupBy,
  }) = _ProjectSetupListSettingsRequest;

  /// Odtwarza ustawienia polityki listy z JSON.
  factory ProjectSetupListSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupListSettingsRequestFromJson(json);
}

/// Ustawienia tablicy Kanban projektu.
///
/// Odpowiada `ProjectSetupBoardSettingsRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupBoardSettingsRequest
    with _$ProjectSetupBoardSettingsRequest {
  /// Tworzy ustawienia tablicy Kanban.
  const factory ProjectSetupBoardSettingsRequest({
    /// Sposób grupowania kart w tory.
    KanbanSwimlaneMode? swimlaneMode,

    /// Typowane pola widoczne na kafelku.
    List<KanbanCardField>? visibleCardFields,

    /// Domyślna gęstość kafelka.
    KanbanCardDensity? defaultCardDensity,
  }) = _ProjectSetupBoardSettingsRequest;

  /// Odtwarza ustawienia tablicy Kanban z JSON.
  factory ProjectSetupBoardSettingsRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectSetupBoardSettingsRequestFromJson(json);
}

/// Tryb harmonogramu i opcjonalna domyślna pojemność workspace.
///
/// Odpowiada `ProjectSetupScheduleRequest`. Pole `defaultDailyCapacityMinutes`
/// wysyłamy wyłącznie wtedy, gdy użytkownik ma w workspace rolę Admin albo
/// Owner — Backend odrzuca ten zapis dla pozostałych rol.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectSetupScheduleRequest with _$ProjectSetupScheduleRequest {
  /// Tworzy sekcję harmonogramu.
  const factory ProjectSetupScheduleRequest({
    /// Tryb harmonogramowania projektu.
    required AutoScheduleMode mode,

    /// Opcjonalna dzienna pojemność użytkownika w minutach (0-1440).
    int? defaultDailyCapacityMinutes,
  }) = _ProjectSetupScheduleRequest;

  /// Odtwarza sekcję harmonogramu z JSON.
  factory ProjectSetupScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectSetupScheduleRequestFromJson(json);
}

/// Atomowe polecenie kreatora projektu wraz z otoczeniem startowym.
///
/// Odpowiada `CreateProjectSetupRequest`.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateProjectSetupRequest with _$CreateProjectSetupRequest {
  /// Tworzy żądanie kreatora projektu.
  const factory CreateProjectSetupRequest({
    /// Sposób startu projektu.
    required ProjectSetupSourceRequest source,

    /// Podstawowe dane projektu.
    required ProjectSetupProjectRequest project,

    /// Początkowi członkowie projektu Private.
    List<ProjectSetupMemberAssignmentRequest>? memberAssignments,

    /// Wybór workflow zadań.
    ProjectSetupWorkflowRequest? workflow,

    /// Domyślny widok zadań i ustawienia Listy oraz Kanbanu.
    ProjectSetupTaskViewRequest? taskView,

    /// Tryb harmonogramowania i pojemność.
    ProjectSetupScheduleRequest? schedule,

    /// Klucze katalogowych przepisów automatyzacji.
    List<String>? automationRecipeKeys,
  }) = _CreateProjectSetupRequest;

  /// Odtwarza żądanie kreatora z JSON.
  factory CreateProjectSetupRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectSetupRequestFromJson(json);
}
