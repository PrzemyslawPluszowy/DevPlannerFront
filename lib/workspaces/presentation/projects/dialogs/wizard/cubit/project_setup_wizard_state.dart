import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';

/// Cykl życia kreatora projektu widoczny dla UI.
///
/// Stany są jawne, żeby przycisk finalnego potwierdzenia, podsumowanie i pasek
/// kroków nie musiały wnioskować niczego z `bool`-ów rozsianych po widgetach.
enum ProjectSetupWizardStatus {
  /// Użytkownik edytuje draft; przejścia kroków są lokalne i bez spinnerów.
  editing,

  /// Trwa budowanie planu dla podsumowania.
  previewing,

  /// Trwa atomowe tworzenie projektu.
  submitting,

  /// Projekt powstał; kreator zostanie zamknięty po pokazaniu wyniku.
  succeeded,

  /// Ostatnia operacja nie powiodła się; draft i krok pozostają nietknięte.
  failed,
}

/// Dostępność katalogu szablonów projektu.
enum ProjectSetupCatalogStatus {
  /// Port szablonów nie został wstrzyknięty; krok startu pokazuje powód.
  unavailable,

  /// Trwa pierwsze pobranie katalogu — tylko tutaj pokazujemy skeleton.
  loading,

  /// Katalog jest gotowy.
  ready,

  /// Pobranie katalogu nie powiodło się.
  failed,
}

/// Stan katalogu szablonów projektu w kreatorze.
final class ProjectSetupCatalogState {
  /// Tworzy stan katalogu.
  const ProjectSetupCatalogState({
    this.status = ProjectSetupCatalogStatus.unavailable,
    this.templates = const <ProjectTemplateResponse>[],
    this.error,
  });

  /// Bieżący etap pobierania katalogu.
  final ProjectSetupCatalogStatus status;

  /// Szablony dostępne w workspace.
  final List<ProjectTemplateResponse> templates;

  /// Błąd pobrania katalogu zachowany przy powierzchni, nie w SnackBarze.
  final ApiError? error;

  /// Czy katalog ma dane do pokazania.
  bool get hasTemplates => templates.isNotEmpty;

  /// Zwraca kopię stanu katalogu.
  ProjectSetupCatalogState copyWith({
    ProjectSetupCatalogStatus? status,
    List<ProjectTemplateResponse>? templates,
    ApiError? error,
    bool clearError = false,
  }) => ProjectSetupCatalogState(
    status: status ?? this.status,
    templates: templates ?? this.templates,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Dostępność listy członków workspace potrzebnej w kroku dostępu.
enum ProjectSetupMembersStatus {
  /// Port członków nie został wstrzyknięty; krok dostępu pokazuje powód.
  unavailable,

  /// Trwa pobieranie listy członków.
  loading,

  /// Lista członków jest gotowa.
  ready,

  /// Pobranie listy członków nie powiodło się.
  failed,
}

/// Stan listy członków workspace w kreatorze.
final class ProjectSetupMembersState {
  /// Tworzy stan listy członków.
  const ProjectSetupMembersState({
    this.status = ProjectSetupMembersStatus.unavailable,
    this.members = const <WorkspaceMemberResponse>[],
    this.error,
  });

  /// Bieżący etap pobierania listy.
  final ProjectSetupMembersStatus status;

  /// Aktywni członkowie workspace.
  final List<WorkspaceMemberResponse> members;

  /// Błąd pobrania listy zachowany przy powierzchni.
  final ApiError? error;

  /// Zwraca kopię stanu listy członków.
  ProjectSetupMembersState copyWith({
    ProjectSetupMembersStatus? status,
    List<WorkspaceMemberResponse>? members,
    ApiError? error,
    bool clearError = false,
  }) => ProjectSetupMembersState(
    status: status ?? this.status,
    members: members ?? this.members,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Pełny stan kreatora projektu.
///
/// Stan nie zawiera `BuildContext`, nawigacji ani widgetów. Teksty użytkownika
/// wynikają wyłącznie z kodów ([ProjectSetupValidationError] i `ApiError`), które
/// UI tłumaczy przez ARB.
final class ProjectSetupWizardState {
  /// Tworzy stan kreatora.
  const ProjectSetupWizardState({
    required this.idempotencyKey,
    this.myWorkspaceRole,
    this.status = ProjectSetupWizardStatus.editing,
    this.step = ProjectSetupStep.start,
    this.draft = const ProjectSetupDraft(),
    this.fieldErrors = const <ProjectSetupField, ProjectSetupValidationError>{},
    this.globalError,
    this.plan,
    this.planIsStale = false,
    this.catalog = const ProjectSetupCatalogState(),
    this.templatePreviews = const <String, ProjectTemplateDetailsResponse>{},
    this.templateLoadingId,
    this.templateError,
    this.templateErrorId,
    this.members = const ProjectSetupMembersState(),
    this.creation,
    this.idempotencyKeyRotated = false,
  });

  /// Klucz idempotencji przypisany do tego draftu.
  ///
  /// Powstaje raz przy otwarciu kreatora i jest używany przy każdym ponowieniu
  /// po timeoucie albo utracie odpowiedzi. Zmienia się wyłącznie wtedy, gdy
  /// Backend dowiódł konfliktu klucza (409), bo dalsze ponowienia ze starym
  /// kluczem byłyby skazane na ten sam błąd.
  final String idempotencyKey;

  /// Rola bieżącego użytkownika w workspace albo `null`, gdy nieznana.
  ///
  /// Służy wyłącznie do discoverability kontrolek; każdy zapis nadal sprawdza
  /// ACL po stronie Backendu.
  final WorkspaceRole? myWorkspaceRole;

  /// Bieżący etap cyklu życia kreatora.
  final ProjectSetupWizardStatus status;

  /// Krok kreatora pokazywany użytkownikowi.
  final ProjectSetupStep step;

  /// Lokalny draft przeżywający cofanie między krokami.
  final ProjectSetupDraft draft;

  /// Błędy walidacji przypisane do konkretnych pól.
  final Map<ProjectSetupField, ProjectSetupValidationError> fieldErrors;

  /// Błąd globalny; pozostaje w podsumowaniu i nie zamyka kreatora.
  final ApiError? globalError;

  /// Ostatni poprawnie zbudowany plan utworzenia projektu.
  final ProjectSetupPreviewResponse? plan;

  /// Czy draft zmienił się po zbudowaniu [plan], więc plan wymaga odświeżenia.
  final bool planIsStale;

  /// Stan katalogu szablonów projektu.
  final ProjectSetupCatalogState catalog;

  /// Podglądy szablonów w pamięci podręcznej per `templateId`.
  final Map<String, ProjectTemplateDetailsResponse> templatePreviews;

  /// Identyfikator szablonu, którego podgląd właśnie się pobiera.
  final String? templateLoadingId;

  /// Błąd pobrania podglądu szablonu.
  ///
  /// Błąd należy do jednego szablonu, dlatego towarzyszy mu
  /// [templateErrorId] — karta, której podglądu nigdy nie pobrano, nie może
  /// pokazywać cudzego błędu ani udawać, że pobranie się nie powiodło.
  final ApiError? templateError;

  /// Identyfikator szablonu, którego dotyczy [templateError].
  final String? templateErrorId;

  /// Stan listy członków workspace.
  final ProjectSetupMembersState members;

  /// Wynik utworzenia projektu.
  final ProjectSetupCreation? creation;

  /// Czy klucz idempotencji został wymieniony po konflikcie z Backendem.
  final bool idempotencyKeyRotated;

  /// Czy finalny submit jest w toku.
  bool get isSubmitting => status == ProjectSetupWizardStatus.submitting;

  /// Czy trwa pobieranie planu.
  bool get isPreviewing => status == ProjectSetupWizardStatus.previewing;

  /// Czy projekt powstał.
  bool get isSucceeded => status == ProjectSetupWizardStatus.succeeded;

  /// Czy można przejść dalej z bieżącego kroku.
  bool get canAdvance => fieldErrors.isEmpty;

  /// Czy bieżący użytkownik może zmieniać domyślną pojemność workspace.
  ///
  /// Kontrolka pokazuje tylko to, co Backend i tak egzekwuje po ACL: zapis
  /// pojemności wymaga roli Admin albo Owner w workspace.
  bool get canManageWorkspaceCapacity =>
      myWorkspaceRole == WorkspaceRole.owner ||
      myWorkspaceRole == WorkspaceRole.admin;

  /// Zwraca kopię stanu kreatora.
  ProjectSetupWizardState copyWith({
    String? idempotencyKey,
    WorkspaceRole? myWorkspaceRole,
    ProjectSetupWizardStatus? status,
    ProjectSetupStep? step,
    ProjectSetupDraft? draft,
    Map<ProjectSetupField, ProjectSetupValidationError>? fieldErrors,
    ApiError? globalError,
    bool clearGlobalError = false,
    ProjectSetupPreviewResponse? plan,
    bool clearPlan = false,
    bool? planIsStale,
    ProjectSetupCatalogState? catalog,
    Map<String, ProjectTemplateDetailsResponse>? templatePreviews,
    String? templateLoadingId,
    bool clearTemplateLoading = false,
    ApiError? templateError,
    bool clearTemplateError = false,
    String? templateErrorId,
    ProjectSetupMembersState? members,
    ProjectSetupCreation? creation,
    bool? idempotencyKeyRotated,
  }) => ProjectSetupWizardState(
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    myWorkspaceRole: myWorkspaceRole ?? this.myWorkspaceRole,
    status: status ?? this.status,
    step: step ?? this.step,
    draft: draft ?? this.draft,
    fieldErrors: fieldErrors ?? this.fieldErrors,
    globalError: clearGlobalError ? null : (globalError ?? this.globalError),
    plan: clearPlan ? null : (plan ?? this.plan),
    planIsStale: planIsStale ?? this.planIsStale,
    catalog: catalog ?? this.catalog,
    templatePreviews: templatePreviews ?? this.templatePreviews,
    templateLoadingId: clearTemplateLoading
        ? null
        : (templateLoadingId ?? this.templateLoadingId),
    templateError: clearTemplateError
        ? null
        : (templateError ?? this.templateError),
    templateErrorId: clearTemplateError
        ? null
        : (templateErrorId ?? this.templateErrorId),
    members: members ?? this.members,
    creation: creation ?? this.creation,
    idempotencyKeyRotated: idempotencyKeyRotated ?? this.idempotencyKeyRotated,
  );
}
