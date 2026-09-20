import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';

/// Kolejność kroków kreatora projektu.
///
/// Kroki pośrednie ([access], [workflow], [workingStyle], [starterFeatures])
/// są opcjonalne: kreator pozwala je pominąć bez utraty wartości domyślnych,
/// które i tak trafiają do planu i podsumowania.
enum ProjectSetupStep {
  /// Sposób startu: pusty projekt albo szablon całego projektu.
  start,

  /// Podstawy: nazwa, opis, ikona, kolor, status początkowy.
  basics,

  /// Dostęp: Shared albo Private wraz z początkowymi członkami i rolami.
  access,

  /// Workflow: systemowy, katalogowy albo jawne statusy.
  workflow,

  /// Sposób pracy: harmonogram, widok domyślny, lista i Kanban, capacity.
  workingStyle,

  /// Funkcje startowe: przepisy automatyzacji.
  starterFeatures,

  /// Podsumowanie planu i finalne `Utwórz`.
  summary;

  /// Czy krok można pominąć bez blokowania finalnego potwierdzenia.
  bool get isOptional => switch (this) {
    ProjectSetupStep.start ||
    ProjectSetupStep.basics ||
    ProjectSetupStep.summary => false,
    _ => true,
  };

  /// Numer kroku widoczny w nagłówku kreatora (liczony od jedynki).
  int get ordinal => index + 1;
}

/// Wybór workflow zadań w kroku [ProjectSetupStep.workflow].
///
/// Rozdzielony od transportowego [ProjectSetupWorkflowKind], bo dla projektu
/// tworzonego z szablonu workflow pochodzi z szablonu i nie jest wyborem
/// użytkownika.
enum ProjectSetupWorkflowChoice {
  /// Systemowe statusy zadań projektu.
  systemDefault,

  /// Katalogowy szablon własnych kolumn.
  catalogTemplate,

  /// Jawne statusy zdefiniowane w kreatorze.
  explicitStatuses;

  /// Transportowy odpowiednik wyboru.
  ProjectSetupWorkflowKind get kind => switch (this) {
    ProjectSetupWorkflowChoice.systemDefault =>
      ProjectSetupWorkflowKind.systemDefault,
    ProjectSetupWorkflowChoice.catalogTemplate =>
      ProjectSetupWorkflowKind.catalogTemplate,
    ProjectSetupWorkflowChoice.explicitStatuses =>
      ProjectSetupWorkflowKind.explicitStatuses,
  };
}

/// Katalog wartości kontraktu, których nie da się pobrać przed utworzeniem
/// projektu.
///
/// Klucze pochodzą z Backendu (`ProjectWorkflowTemplateCatalog` oraz
/// `AutomationRecipeCatalog`). Nazwy prezentacyjne są tłumaczone w UI, dlatego
/// katalog trzyma wyłącznie stabilne klucze, nigdy gotowe teksty ani `.name`.
final class ProjectSetupCatalog {
  const ProjectSetupCatalog._();

  /// Klucze katalogowych szablonów workflow.
  static const List<String> workflowTemplateKeys = <String>[
    'standard',
    'marketing',
    'production',
    'hr',
    'software',
  ];

  /// Klucze katalogowych przepisów automatyzacji.
  static const List<String> automationRecipeKeys = <String>[
    'critical-to-blocked',
    'due-soon-high-priority',
    'done-clear-due-date',
    'done-create-review-subtask',
  ];

  /// Maksymalna liczba jawnych statusów workflow w kreatorze.
  static const int maxExplicitStatuses = 20;

  /// Maksymalna długość nazwy jawnego statusu wynikająca z kontraktu.
  static const int maxStatusNameLength = 60;

  /// Maksymalna długość nazwy projektu wynikająca z kontraktu.
  static const int maxProjectNameLength = 160;

  /// Maksymalna długość opisu projektu wynikająca z kontraktu.
  static const int maxProjectDescriptionLength = 4000;

  /// Górna granica dziennej pojemności w minutach wynikająca z kontraktu.
  static const int maxDailyCapacityMinutes = 1440;
}

/// Początkowy członek projektu Private wraz z rolą wybraną w kreatorze.
final class ProjectSetupMemberSelection {
  /// Tworzy wybór członka projektu.
  const ProjectSetupMemberSelection({required this.userId, required this.role});

  /// UUID lokalnego użytkownika z aktywnym członkostwem w workspace.
  final String userId;

  /// Rola nadawana w projekcie.
  final ProjectRole role;

  /// Zwraca kopię wyboru z podmienioną rolą.
  ProjectSetupMemberSelection withRole(ProjectRole role) =>
      ProjectSetupMemberSelection(userId: userId, role: role);
}

/// Jawny status workflow definiowany w kreatorze.
final class ProjectSetupCustomStatusDraft {
  /// Tworzy szkic jawnego statusu.
  const ProjectSetupCustomStatusDraft({
    required this.name,
    required this.colorHex,
    required this.category,
    this.wipLimit,
    this.isDefault = false,
  });

  /// Nazwa kolumny.
  final String name;

  /// Kolor kolumny w formacie `#RRGGBB`.
  final String colorHex;

  /// Kategoria analityczna kolumny.
  final TaskStatusCategory category;

  /// Opcjonalny limit WIP w zakresie 1-999.
  final int? wipLimit;

  /// Czy status jest domyślny dla nowych zadań.
  final bool isDefault;

  /// Zwraca kopię statusu z podmienionymi polami.
  ProjectSetupCustomStatusDraft copyWith({
    String? name,
    String? colorHex,
    TaskStatusCategory? category,
    int? wipLimit,
    bool clearWipLimit = false,
    bool? isDefault,
  }) => ProjectSetupCustomStatusDraft(
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
    category: category ?? this.category,
    wipLimit: clearWipLimit ? null : (wipLimit ?? this.wipLimit),
    isDefault: isDefault ?? this.isDefault,
  );
}

/// Lokalny draft kreatora projektu.
///
/// Draft nie zna HTTP ani `BuildContext`; jest zwykłym modelem domenowym,
/// który przeżywa cofanie i ponowne przejście kroków. Żadne pole nie jest
/// wysyłane do Backendu przed finalnym potwierdzeniem.
final class ProjectSetupDraft {
  /// Tworzy draft z wartościami domyślnymi planu.
  const ProjectSetupDraft({
    this.startKind = ProjectSetupSourceKind.blank,
    this.templateId,
    this.templateExpectedVersion,
    this.templateName,
    this.name = '',
    this.description = '',
    this.iconKey = 'workflow',
    this.colorHex = '#6366F1',
    this.status = ProjectStatus.active,
    this.visibility = ProjectVisibility.private,
    this.members = const <ProjectSetupMemberSelection>[],
    this.workflowChoice = ProjectSetupWorkflowChoice.systemDefault,
    this.workflowTemplateKey = 'standard',
    this.customStatuses = const <ProjectSetupCustomStatusDraft>[],
    this.defaultView = ProjectSetupTaskViewKind.list,
    this.scheduleMode = AutoScheduleMode.manual,
    this.capacityMinutes,
    this.boardSwimlaneMode = KanbanSwimlaneMode.none,
    this.boardDensity = KanbanCardDensity.comfortable,
    this.boardVisibleFields = const <KanbanCardField>{
      KanbanCardField.assignee,
      KanbanCardField.dueDate,
      KanbanCardField.labels,
    },
    this.listSortField = TaskSavedViewSortField.position,
    this.listSortDirection = TaskSavedViewSortDirection.ascending,
    this.listGroupBy = TaskSavedViewGroupBy.status,
    this.recipeKeys = const <String>{},
  });

  /// Sposób startu projektu.
  final ProjectSetupSourceKind startKind;

  /// UUID szablonu dla [ProjectSetupSourceKind.projectTemplate].
  final String? templateId;

  /// Wersja szablonu z ostatniego odczytu; niezgodność zwraca 409.
  final int? templateExpectedVersion;

  /// Nazwa szablonu zapamiętana dla podsumowania i komunikatów błędu.
  final String? templateName;

  /// Nazwa projektu.
  final String name;

  /// Opis projektu.
  final String description;

  /// Klucz ikony prezentacyjnej projektu.
  final String iconKey;

  /// Kolor główny projektu w formacie `#RRGGBB`.
  final String colorHex;

  /// Status początkowy projektu.
  final ProjectStatus status;

  /// Widoczność projektu.
  final ProjectVisibility visibility;

  /// Początkowi członkowie projektu Private.
  final List<ProjectSetupMemberSelection> members;

  /// Wybrany sposób workflow.
  final ProjectSetupWorkflowChoice workflowChoice;

  /// Klucz katalogowego szablonu workflow.
  final String workflowTemplateKey;

  /// Jawne statusy workflow.
  final List<ProjectSetupCustomStatusDraft> customStatuses;

  /// Domyślny widok modułu Zadania.
  final ProjectSetupTaskViewKind defaultView;

  /// Tryb harmonogramowania projektu.
  final AutoScheduleMode scheduleMode;

  /// Opcjonalna dzienna pojemność workspace w minutach.
  final int? capacityMinutes;

  /// Sposób grupowania kart Kanban.
  final KanbanSwimlaneMode boardSwimlaneMode;

  /// Domyślna gęstość kafelka Kanban.
  final KanbanCardDensity boardDensity;

  /// Pola widoczne domyślnie na kafelku Kanban.
  final Set<KanbanCardField> boardVisibleFields;

  /// Domyślne pole sortowania listy zadań.
  final TaskSavedViewSortField listSortField;

  /// Domyślny kierunek sortowania listy zadań.
  final TaskSavedViewSortDirection listSortDirection;

  /// Domyślny sposób grupowania listy zadań.
  final TaskSavedViewGroupBy listGroupBy;

  /// Klucze przepisów automatyzacji do zainstalowania.
  final Set<String> recipeKeys;

  /// Czy projekt powstaje z szablonu całego projektu.
  bool get usesTemplate => startKind == ProjectSetupSourceKind.projectTemplate;

  /// Zwraca kopię draftu z podmienionymi polami.
  ProjectSetupDraft copyWith({
    ProjectSetupSourceKind? startKind,
    String? templateId,
    bool clearTemplate = false,
    int? templateExpectedVersion,
    String? templateName,
    String? name,
    String? description,
    String? iconKey,
    String? colorHex,
    ProjectStatus? status,
    ProjectVisibility? visibility,
    List<ProjectSetupMemberSelection>? members,
    ProjectSetupWorkflowChoice? workflowChoice,
    String? workflowTemplateKey,
    List<ProjectSetupCustomStatusDraft>? customStatuses,
    ProjectSetupTaskViewKind? defaultView,
    AutoScheduleMode? scheduleMode,
    int? capacityMinutes,
    bool clearCapacity = false,
    KanbanSwimlaneMode? boardSwimlaneMode,
    KanbanCardDensity? boardDensity,
    Set<KanbanCardField>? boardVisibleFields,
    TaskSavedViewSortField? listSortField,
    TaskSavedViewSortDirection? listSortDirection,
    TaskSavedViewGroupBy? listGroupBy,
    Set<String>? recipeKeys,
  }) => ProjectSetupDraft(
    startKind: startKind ?? this.startKind,
    templateId: clearTemplate ? null : (templateId ?? this.templateId),
    templateExpectedVersion: clearTemplate
        ? null
        : (templateExpectedVersion ?? this.templateExpectedVersion),
    templateName: clearTemplate ? null : (templateName ?? this.templateName),
    name: name ?? this.name,
    description: description ?? this.description,
    iconKey: iconKey ?? this.iconKey,
    colorHex: colorHex ?? this.colorHex,
    status: status ?? this.status,
    visibility: visibility ?? this.visibility,
    members: members ?? this.members,
    workflowChoice: workflowChoice ?? this.workflowChoice,
    workflowTemplateKey: workflowTemplateKey ?? this.workflowTemplateKey,
    customStatuses: customStatuses ?? this.customStatuses,
    defaultView: defaultView ?? this.defaultView,
    scheduleMode: scheduleMode ?? this.scheduleMode,
    capacityMinutes: clearCapacity
        ? null
        : (capacityMinutes ?? this.capacityMinutes),
    boardSwimlaneMode: boardSwimlaneMode ?? this.boardSwimlaneMode,
    boardDensity: boardDensity ?? this.boardDensity,
    boardVisibleFields: boardVisibleFields ?? this.boardVisibleFields,
    listSortField: listSortField ?? this.listSortField,
    listSortDirection: listSortDirection ?? this.listSortDirection,
    listGroupBy: listGroupBy ?? this.listGroupBy,
    recipeKeys: recipeKeys ?? this.recipeKeys,
  );
}
