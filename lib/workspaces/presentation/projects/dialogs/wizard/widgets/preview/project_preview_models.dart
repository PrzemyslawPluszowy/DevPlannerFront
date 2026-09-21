import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';

/// Liczba zadań pokazywanych w jednej kolumnie podglądu.
const int kProjectPreviewTasksPerColumn = 3;

/// Liczba wierszy listy pokazywanych w podglądzie.
const int kProjectPreviewListRows = 5;

/// Skąd pochodzą kolumny pokazane w podglądzie.
///
/// Panel musi umieć powiedzieć, co dokładnie wie: kolumny z szablonu mają
/// prawdziwe nazwy, kolory i limity WIP, a statusy systemowe nie mają kolorów,
/// dopóki nie utworzy ich Backend.
enum ProjectPreviewColumnSource {
  /// Kolumny pochodzą z pobranego szablonu projektu.
  template,

  /// Kolumny pochodzą z jawnie zdefiniowanych statusów draftu.
  explicitStatuses,

  /// Kolumny pochodzą z planu zbudowanego przez Backend.
  plan,

  /// Kolumny to systemowe kategorie statusów bez własnych kolorów.
  systemDefaults,

  /// Wybrano katalogowy układ statusów, którego zawartości jeszcze nie znamy.
  catalogTemplate,

  /// Nie ma jeszcze nic do pokazania.
  none,
}

/// Pojedyncza kolumna tablicy w podglądzie.
final class ProjectPreviewColumn {
  /// Tworzy kolumnę podglądu.
  const ProjectPreviewColumn({
    required this.name,
    this.colorHex,
    this.wipLimit,
    this.isDefault = false,
    this.category,
    this.taskTitles = const <String>[],
    this.taskCount = 0,
  });

  /// Nazwa kolumny widoczna dla użytkownika.
  final String name;

  /// Kolor kolumny w kontrakcie `#RRGGBB`; `null` znaczy „kolor z motywu”.
  final String? colorHex;

  /// Limit WIP kolumny albo `null`.
  final int? wipLimit;

  /// Czy kolumna jest domyślna dla nowych zadań.
  final bool isDefault;

  /// Kategoria analityczna kolumny albo `null`.
  final TaskStatusCategory? category;

  /// Tytuły zadań pokazywane na kartach.
  final List<String> taskTitles;

  /// Łączna liczba zadań w kolumnie, także tych niepokazanych.
  final int taskCount;

  /// Liczba zadań, których nie ma miejsca w podglądzie.
  int get hiddenTaskCount =>
      taskCount > taskTitles.length ? taskCount - taskTitles.length : 0;
}

/// Zadanie widoczne w liście podglądu.
final class ProjectPreviewTask {
  /// Tworzy zadanie podglądu.
  const ProjectPreviewTask({
    required this.title,
    required this.statusName,
    this.priorityLabel,
    this.labels = const <String>[],
  });

  /// Tytuł zadania.
  final String title;

  /// Nazwa statusu, w którym zadanie powstanie.
  final String statusName;

  /// Etykieta priorytetu albo `null`, gdy szablon go nie zapisał.
  final String? priorityLabel;

  /// Nazwy etykiet przypisanych do zadania.
  final List<String> labels;
}

/// Dane podglądu wyprowadzone z draftu, szablonu i planu Backendu.
///
/// Snapshot jest czystą wartością: dzięki temu logikę „co pokazać” można
/// sprawdzić testem bez uruchamiania widgetów.
final class ProjectPreviewSnapshot {
  /// Tworzy snapshot podglądu.
  const ProjectPreviewSnapshot({
    this.columns = const <ProjectPreviewColumn>[],
    this.columnSource = ProjectPreviewColumnSource.none,
    this.catalogTemplateName,
    this.tasks = const <ProjectPreviewTask>[],
    this.taskTotal = 0,
    this.labels = const <String>[],
    this.fields = const <String>[],
    this.systemStatusCount = 0,
    this.planApproved = false,
  });

  /// Kolumny tablicy w kolejności wyświetlania.
  final List<ProjectPreviewColumn> columns;

  /// Źródło kolumn.
  final ProjectPreviewColumnSource columnSource;

  /// Nazwa katalogowego układu statusów, gdy wybrano opcję bez własnych kolumn.
  final String? catalogTemplateName;

  /// Zadania do widoku listy.
  final List<ProjectPreviewTask> tasks;

  /// Łączna liczba zadań, także tych spoza widocznego wycinka.
  final int taskTotal;

  /// Nazwy etykiet, które powstaną razem z projektem.
  final List<String> labels;

  /// Nazwy pól własnych, które powstaną razem z projektem.
  final List<String> fields;

  /// Liczba statusów systemowych tworzonych zawsze przez Backend.
  final int systemStatusCount;

  /// Czy plan serwera potwierdził ten układ bez zmieniania kolumn.
  ///
  /// Projekt z szablonu dostaje statusy i zadania wprost z szablonu — plan
  /// zwraca wtedy rodzaj „domyślny” bez własnych statusów. Podsumowanie musi to
  /// pokazać jako potwierdzenie, a nie podmieniać kolumn na statusy systemowe.
  final bool planApproved;

  /// Czy podgląd ma kolumny do pokazania.
  bool get hasColumns => columns.isNotEmpty;

  /// Czy podgląd ma zadania do pokazania.
  bool get hasTasks => tasks.isNotEmpty;

  /// Czy są jakiekolwiek dane poza samą nazwą projektu.
  bool get hasContent =>
      hasColumns || hasTasks || labels.isNotEmpty || fields.isNotEmpty;

  /// Liczba zadań, których nie ma miejsca w widoku listy.
  int get hiddenTaskTotal =>
      taskTotal > tasks.length ? taskTotal - tasks.length : 0;
}

/// Buduje snapshot podglądu z draftu i danych pobranych z Backendu.
///
/// [template] jest podglądem szablonu, [plan] planem serwera dla podsumowania.
/// Podgląd nigdy nie wymyśla danych: gdy źródło nie zna kolumn, snapshot mówi
/// o tym wprost przez [ProjectPreviewSnapshot.columnSource].
ProjectPreviewSnapshot buildProjectPreviewSnapshot({
  required AppLocalizations l10n,
  required ProjectSetupDraft draft,
  ProjectTemplateDetailsResponse? template,
  ProjectSetupPreviewResponse? plan,
}) {
  final content = switch ((draft.usesTemplate, template)) {
    (true, final ProjectTemplateDetailsResponse details) =>
      _snapshotFromTemplate(l10n, details),
    (true, null) => const ProjectPreviewSnapshot(),
    (false, _) => _snapshotFromWorkflowChoice(l10n, draft),
  };
  if (plan == null) return content;
  final workflow = plan.workflow;
  // Plan nowej wersji niesie kolumny **i** zadania razem z nazwą kolumny
  // docelowej, więc podsumowanie pokazuje dokładnie to, co utworzy serwer —
  // bez dopasowywania zadań do kolumn po nazwie statusu. Starszy plan bez listy
  // zadań zostawia podgląd na zawartości szablonu (gałęzie niżej).
  final planTasks = _tasksFromPlan(l10n, plan);
  if (planTasks.isNotEmpty) {
    return _snapshotFromPlan(l10n, workflow, planTasks, content);
  }
  if (draft.usesTemplate) {
    // Projekt z szablonu powstaje z workflow zapisanym w szablonie — plan nigdy
    // nie niesie dla niego własnych kolumn (Backend odrzuca tam inny workflow),
    // a podmiana kolumn zgubiłaby karty i pokazała statusy, których projekt nie
    // dostanie. Plan tylko potwierdza układ szablonu.
    return ProjectPreviewSnapshot(
      columns: content.columns,
      columnSource: content.columnSource,
      catalogTemplateName: content.catalogTemplateName,
      systemStatusCount: content.systemStatusCount,
      tasks: content.tasks,
      taskTotal: content.taskTotal,
      labels: content.labels,
      fields: content.fields,
      planApproved: true,
    );
  }
  // W pustym projekcie plan jest źródłem prawdy dla kolumn; zawartość szablonu
  // (zadania, etykiety, pola) i tak zostaje, żeby podsumowanie nie gubiło tego,
  // co użytkownik zobaczył w kroku startu.
  return _withPlanColumns(content, _snapshotFromPlanColumns(l10n, workflow));
}

/// Podmienia kolumny snapshotu na te zatwierdzone przez plan serwera.
///
/// Zadania zostają rozdzielone po kolumnach planu (patrz
/// [mapProjectPreviewTasksToColumns]), więc podmiana kolumn nie może zgubić
/// kart: podgląd pokazuje kolumny, które powstaną, razem z ich zawartością.
ProjectPreviewSnapshot _withPlanColumns(
  ProjectPreviewSnapshot content,
  ProjectPreviewSnapshot planColumns,
) => ProjectPreviewSnapshot(
  columns: mapProjectPreviewTasksToColumns(
    tasks: content.tasks,
    columns: planColumns.columns,
  ),
  columnSource: planColumns.columnSource,
  catalogTemplateName: planColumns.catalogTemplateName,
  systemStatusCount: planColumns.systemStatusCount,
  tasks: content.tasks,
  taskTotal: content.taskTotal,
  labels: content.labels,
  fields: content.fields,
  planApproved: true,
);

/// Zadania planu przeliczone na wpisy podglądu.
///
/// Priorytet i etykiety pochodzą wprost z planu, więc lista podglądu nie musi
/// niczego dopytywać w szablonie.
List<ProjectPreviewTask> _tasksFromPlan(
  AppLocalizations l10n,
  ProjectSetupPreviewResponse plan,
) => [
  for (final task in plan.tasks ?? const <ProjectSetupTaskPreviewResponse>[])
    ProjectPreviewTask(
      title: task.title,
      statusName: task.statusName,
      priorityLabel: projectSetupPriorityLabel(l10n, task.priority),
      labels: task.labels,
    ),
];

/// Podsumowanie zbudowane z planu serwera: kolumny planu plus jego zadania.
///
/// Liczniki kolumn liczone są z **pełnej** listy zadań, a wycinek listy tylko
/// z pierwszych wierszy — tak samo jak dla szablonu, żeby „+N więcej" i licznik
/// kolumny opisywały całość, a nie to, co widać.
ProjectPreviewSnapshot _snapshotFromPlan(
  AppLocalizations l10n,
  ProjectSetupWorkflowPreviewResponse plan,
  List<ProjectPreviewTask> tasks,
  ProjectPreviewSnapshot content,
) {
  final planColumns = _snapshotFromPlanColumns(l10n, plan);
  return ProjectPreviewSnapshot(
    columns: mapProjectPreviewTasksToColumns(
      tasks: tasks,
      columns: planColumns.columns,
    ),
    // Dla projektu z szablonu mówimy dalej, że kolumny pochodzą z szablonu:
    // plan potwierdza właśnie ten układ, a nie własny.
    columnSource: content.columnSource == ProjectPreviewColumnSource.none
        ? planColumns.columnSource
        : content.columnSource,
    catalogTemplateName: planColumns.catalogTemplateName,
    systemStatusCount: plan.systemStatusCount,
    tasks: _capped(tasks, kProjectPreviewListRows),
    taskTotal: tasks.length,
    labels: content.labels,
    fields: content.fields,
    planApproved: true,
  );
}

/// Rozdziela zadania podglądu po kolumnach planu.
///
/// Dopasowanie idzie po nazwie statusu (bez wielkości liter i spacji), bo plan
/// nie niesie identyfikatorów zadań. Zadanie ze statusem, którego plan nie zna
/// (np. plan zmienił nazwę kolumny), dostaje **własną kolumnę** zamiast zniknąć
/// z podglądu — karta nie może wypaść tylko dlatego, że ktoś nazwał kolumnę
/// inaczej. Liczniki i wycinek tytułów liczone są na wejściu, więc kolumna
/// pokazuje tyle kart, ile naprawdę powstanie.
List<ProjectPreviewColumn> mapProjectPreviewTasksToColumns({
  required List<ProjectPreviewTask> tasks,
  required List<ProjectPreviewColumn> columns,
}) {
  if (tasks.isEmpty) return columns;
  final byName = <String, _MutableColumn>{
    for (final column in columns)
      projectPreviewStatusKey(column.name): _MutableColumn(
        name: column.name,
        declared: column,
      ),
  };
  for (final task in tasks) {
    final column = byName.putIfAbsent(
      projectPreviewStatusKey(task.statusName),
      () => _MutableColumn(
        name: task.statusName,
        declared: ProjectPreviewColumn(name: task.statusName),
      ),
    );
    column.taskTitles.add(task.title);
    column.taskCount += 1;
  }
  return [
    for (final column in byName.values)
      ProjectPreviewColumn(
        name: column.name,
        colorHex: column.declared.colorHex,
        wipLimit: column.declared.wipLimit,
        isDefault: column.declared.isDefault,
        category: column.declared.category,
        taskTitles: _capped(column.taskTitles, kProjectPreviewTasksPerColumn),
        taskCount: column.taskCount,
      ),
  ];
}

/// Klucz dopasowania zadania do kolumny i koloru: nazwa bez wielkości liter
/// i nadmiarowych spacji.
///
/// Wspólny dla mapowania zadań na kolumny planu i dla koloru statusu w liście
/// podglądu, żeby jedna reguła decydowała o obu dopasowaniach.
String projectPreviewStatusKey(String name) =>
    name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

ProjectPreviewSnapshot _snapshotFromPlanColumns(
  AppLocalizations l10n,
  ProjectSetupWorkflowPreviewResponse plan,
) {
  final statuses = [...plan.customStatuses]
    ..sort((a, b) => a.position.compareTo(b.position));
  if (statuses.isEmpty) {
    // Plan bez własnych kolumn to statusy systemowe; znamy ich liczbę, ale nie
    // nazwy, więc podgląd pokazuje tyle kolumn, ile naprawdę powstanie.
    return _systemStatusSnapshot(plan.systemStatusCount);
  }
  return ProjectPreviewSnapshot(
    columnSource: ProjectPreviewColumnSource.plan,
    systemStatusCount: plan.systemStatusCount,
    columns: [
      for (final status in statuses)
        ProjectPreviewColumn(
          name: status.name,
          colorHex: status.color,
          wipLimit: status.wipLimit,
          isDefault: status.isDefault,
          category: status.category,
        ),
    ],
  );
}

ProjectPreviewSnapshot _snapshotFromTemplate(
  AppLocalizations l10n,
  ProjectTemplateDetailsResponse template,
) {
  final declared = _declaredTemplateColumns(l10n, template);
  final statuses = template.customStatuses;
  final workflow = <String, ProjectTemplateWorkflowResponse>{
    for (final entry in template.workflow) entry.status: entry,
  };
  final labelsById = {
    for (final label in template.labels) label.sourceId: label,
  };
  final columns = [
    for (final column in declared)
      _MutableColumn(name: column.name, declared: column),
  ];
  final indexByName = {for (final column in columns) column.name: column};

  for (final task in template.tasks) {
    final customName = _customStatusName(statuses, task.customStatusSourceId);
    final name =
        customName ?? workflow[task.status]?.name ?? task.status.trim();
    final column = indexByName.putIfAbsent(
      name,
      () => _MutableColumn(
        name: name,
        declared: ProjectPreviewColumn(name: name),
      ),
    );
    column.taskTitles.add(task.title);
    column.taskCount += 1;
  }

  return ProjectPreviewSnapshot(
    columnSource: ProjectPreviewColumnSource.template,
    // Kolumny bierzemy z mapy, nie z listy deklaracji: zadanie z nieznanym
    // statusem dokłada własną kolumnę, a mapa zachowuje kolejność wstawiania,
    // więc kolejność deklaracji pozostaje nietknięta.
    columns: [
      for (final column in indexByName.values)
        ProjectPreviewColumn(
          name: column.name,
          colorHex: column.declared.colorHex,
          wipLimit: column.declared.wipLimit,
          isDefault: column.declared.isDefault,
          category: column.declared.category,
          taskTitles: _capped(column.taskTitles, kProjectPreviewTasksPerColumn),
          taskCount: column.taskCount,
        ),
    ],
    tasks: [
      for (final task in _capped(template.tasks, kProjectPreviewListRows))
        ProjectPreviewTask(
          title: task.title,
          statusName:
              _customStatusName(statuses, task.customStatusSourceId) ??
              workflow[task.status]?.name ??
              task.status.trim(),
          priorityLabel: projectSetupPriorityLabel(l10n, task.priority),
          labels: [
            for (final labelId in task.labelSourceIds)
              if (labelsById[labelId] case final label?) label.name,
          ],
        ),
    ],
    taskTotal: template.tasks.length,
    labels: [for (final label in template.labels) label.name],
    fields: [for (final field in template.customFields) field.name],
  );
}

/// Kolumny zapisane w szablonie: własne statusy, a gdy ich nie ma — workflow.
List<ProjectPreviewColumn> _declaredTemplateColumns(
  AppLocalizations l10n,
  ProjectTemplateDetailsResponse template,
) {
  final statuses = [...?template.customStatuses]
    ..sort((a, b) => a.position.compareTo(b.position));
  if (statuses.isNotEmpty) {
    return [
      for (final status in statuses)
        ProjectPreviewColumn(
          name: status.name,
          colorHex: status.color,
          wipLimit: status.wipLimit,
          isDefault: status.isDefault,
          category: projectSetupStatusCategory(status.category),
        ),
    ];
  }
  final workflow = [...template.workflow]
    ..sort((a, b) => a.position.compareTo(b.position));
  return [
    for (final entry in workflow)
      ProjectPreviewColumn(
        name: entry.name,
        colorHex: entry.color,
        isDefault: entry.isInitial,
      ),
  ];
}

ProjectPreviewSnapshot _snapshotFromWorkflowChoice(
  AppLocalizations l10n,
  ProjectSetupDraft draft,
) {
  switch (draft.workflowChoice) {
    case ProjectSetupWorkflowChoice.explicitStatuses:
      return ProjectPreviewSnapshot(
        columnSource: ProjectPreviewColumnSource.explicitStatuses,
        columns: [
          for (final status in draft.customStatuses)
            ProjectPreviewColumn(
              name: status.name,
              colorHex: status.colorHex,
              wipLimit: status.wipLimit,
              isDefault: status.isDefault,
              category: status.category,
            ),
        ],
      );
    case ProjectSetupWorkflowChoice.catalogTemplate:
      return ProjectPreviewSnapshot(
        columnSource: ProjectPreviewColumnSource.catalogTemplate,
        catalogTemplateName: ProjectSetupWizardL10n.workflowTemplateName(
          l10n,
          draft.workflowTemplateKey,
        ),
      );
    case ProjectSetupWorkflowChoice.systemDefault:
      return _systemStatusSnapshot(null);
  }
}

/// Kolumny systemowe: nazwy i kolory zna dopiero serwer.
///
/// Kontrakt nie wystawia nazw statusów systemowych przed utworzeniem projektu,
/// więc podgląd pokazuje sam kształt tablicy i liczbę kolumn, gdy ta jest znana
/// z planu. Wymyślanie nazw byłoby obietnicą, której nie da się sprawdzić.
ProjectPreviewSnapshot _systemStatusSnapshot(int? systemStatusCount) {
  final visible = systemStatusCount == null
      ? 3
      : (systemStatusCount < 4 ? systemStatusCount : 4);
  return ProjectPreviewSnapshot(
    columnSource: ProjectPreviewColumnSource.systemDefaults,
    systemStatusCount: systemStatusCount ?? 0,
    columns: [
      for (var index = 0; index < visible; index++)
        const ProjectPreviewColumn(name: ''),
    ],
  );
}

String? _customStatusName(
  List<ProjectTemplateCustomStatusResponse>? statuses,
  String? sourceId,
) {
  if (statuses == null || sourceId == null) return null;
  for (final status in statuses) {
    if (status.sourceId == sourceId) return status.name;
  }
  return null;
}

List<T> _capped<T>(List<T> values, int limit) =>
    values.length <= limit ? values : values.sublist(0, limit);

/// Kategoria analityczna zapisana w szablonie jako tekst kontraktu.
///
/// Nieznana wartość zwraca `null`: podgląd pokazuje wtedy kolumnę bez kategorii
/// zamiast zgadywać, czy zadanie czeka, trwa, czy jest zakończone.
TaskStatusCategory? projectSetupStatusCategory(String? raw) {
  final value = raw?.trim().toLowerCase();
  if (value == null || value.isEmpty) return null;
  return switch (value) {
    'todo' => TaskStatusCategory.todo,
    'inprogress' ||
    'in_progress' ||
    'in progress' => TaskStatusCategory.inProgress,
    'done' => TaskStatusCategory.done,
    'cancelled' || 'canceled' => TaskStatusCategory.cancelled,
    _ => null,
  };
}

/// Nazwa gęstości kafelka używana w nagłówku podglądu tablicy.
String projectSetupDensityLabel(
  AppLocalizations l10n,
  KanbanCardDensity density,
) => ProjectSetupWizardL10n.cardDensity(l10n, density);

/// Etykieta priorytetu zadania szablonu; nieznana wartość pokazuje się dosłownie.
String? projectSetupPriorityLabel(AppLocalizations l10n, String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  return switch (value.toLowerCase()) {
    'low' => l10n.tasksPriorityLow,
    'normal' || 'medium' => l10n.tasksPriorityNormal,
    'high' => l10n.tasksPriorityHigh,
    'critical' || 'urgent' => l10n.tasksPriorityCritical,
    _ => value,
  };
}

final class _MutableColumn {
  _MutableColumn({required this.name, required this.declared});

  final String name;
  final ProjectPreviewColumn declared;
  final List<String> taskTitles = <String>[];
  int taskCount = 0;
}
