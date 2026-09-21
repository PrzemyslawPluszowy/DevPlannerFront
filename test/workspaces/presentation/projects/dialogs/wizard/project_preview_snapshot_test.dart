import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_atoms.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_models.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/template_list_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Podgląd nie może wymyślać danych: te testy sprawdzają, co dokładnie wie
/// snapshot zbudowany z draftu, szablonu i planu serwera.
void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('pl'));
  });

  test('kolumny z szablonu mają nazwy, kolory i limity WIP z danych', () {
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: 'template-1',
      ),
      template: projectTemplateDetails(
        customStatuses: [
          projectTemplateStatus(
            sourceId: 'status-todo',
            name: 'Do akceptacji',
            color: '#2563EB',
            wipLimit: 2,
            isDefault: true,
          ),
          projectTemplateStatus(
            sourceId: 'status-doing',
            name: 'W realizacji',
            color: '#F59E0B',
            position: 1,
          ),
        ],
        tasks: [
          projectTemplateTask(
            sourceId: 'task-1',
            title: 'Przygotować brief',
            customStatusSourceId: 'status-todo',
          ),
        ],
      ),
    );

    expect(snapshot.columnSource, ProjectPreviewColumnSource.template);
    expect(
      snapshot.columns.map((column) => column.name),
      <String>['Do akceptacji', 'W realizacji'],
    );
    expect(snapshot.columns.first.colorHex, '#2563EB');
    expect(snapshot.columns.first.wipLimit, 2);
    expect(snapshot.columns.first.isDefault, isTrue);
    expect(snapshot.columns.first.taskTitles, <String>['Przygotować brief']);
    expect(snapshot.columns.last.colorHex, '#F59E0B');
  });

  test('podgląd przycina wycinek i mówi, ile pozycji zostało', () {
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: 'template-1',
      ),
      template: projectTemplateDetails(
        customStatuses: [
          projectTemplateStatus(
            sourceId: 'status-1',
            name: 'Backlog',
            isDefault: true,
          ),
        ],
        tasks: [
          for (var index = 0; index < 9; index++)
            projectTemplateTask(
              sourceId: 'task-$index',
              title: 'Zadanie $index',
              customStatusSourceId: 'status-1',
            ),
        ],
      ),
    );

    final column = snapshot.columns.single;
    expect(column.taskTitles, hasLength(kProjectPreviewTasksPerColumn));
    expect(column.taskCount, 9);
    expect(column.hiddenTaskCount, 9 - kProjectPreviewTasksPerColumn);
    expect(snapshot.tasks, hasLength(kProjectPreviewListRows));
    expect(snapshot.taskTotal, 9);
    expect(snapshot.hiddenTaskTotal, 9 - kProjectPreviewListRows);
  });

  test('zadanie bez własnego statusu trafia do kolumny z workflow', () {
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: 'template-1',
      ),
      template: projectTemplateDetails(
        customStatuses: const <ProjectTemplateCustomStatusResponse>[],
        workflow: const <ProjectTemplateWorkflowResponse>[
          ProjectTemplateWorkflowResponse(
            status: 'InProgress',
            name: 'W toku',
            color: '#0284C7',
            position: 0,
            isInitial: true,
            isTerminal: false,
          ),
        ],
        tasks: [
          projectTemplateTask(
            sourceId: 'task-1',
            title: 'Zadanie z workflow',
            status: 'InProgress',
          ),
        ],
      ),
    );

    expect(snapshot.columns.single.name, 'W toku');
    expect(snapshot.columns.single.colorHex, '#0284C7');
    expect(snapshot.columns.single.isDefault, isTrue);
    expect(snapshot.columns.single.taskTitles, <String>['Zadanie z workflow']);
  });

  test('status spoza deklaracji nie gubi zadania', () {
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: 'template-1',
      ),
      template: projectTemplateDetails(
        customStatuses: [
          projectTemplateStatus(sourceId: 'status-1', name: 'Backlog'),
        ],
        tasks: [
          projectTemplateTask(
            sourceId: 'task-1',
            title: 'Zadanie bez kolumny',
            status: 'Waiting',
          ),
        ],
      ),
    );

    // Kolumna nieznanego statusu powstaje z nazwy zapisanej w zadaniu — podgląd
    // nie ukrywa zadania tylko dlatego, że szablon nie zadeklarował kolumny.
    expect(
      snapshot.columns.map((column) => column.name),
      <String>['Backlog', 'Waiting'],
    );
    expect(snapshot.columns.last.taskTitles, <String>['Zadanie bez kolumny']);
  });

  test('jawny status z draftu jest kolumną z kolorem i limitem WIP', () {
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        workflowChoice: ProjectSetupWorkflowChoice.explicitStatuses,
        customStatuses: [
          ProjectSetupCustomStatusDraft(
            name: 'Do przeglądu',
            colorHex: '#8B5CF6',
            category: TaskStatusCategory.todo,
            wipLimit: 3,
            isDefault: true,
          ),
        ],
      ),
    );

    expect(snapshot.columnSource, ProjectPreviewColumnSource.explicitStatuses);
    expect(snapshot.columns.single.name, 'Do przeglądu');
    expect(snapshot.columns.single.wipLimit, 3);
    expect(snapshot.columns.single.isDefault, isTrue);
  });

  test('systemowe kolumny pokazują kształt, a nie wymyślone nazwy', () {
    final withoutPlan = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(),
    );

    // Kontrakt nie zdradza nazw statusów systemowych, więc podgląd nie zgaduje
    // ani nazw, ani liczby kolumn przed zbudowaniem planu.
    expect(withoutPlan.columnSource, ProjectPreviewColumnSource.systemDefaults);
    expect(withoutPlan.systemStatusCount, 0);
    expect(withoutPlan.columns, hasLength(3));
    expect(withoutPlan.columns.every((column) => column.name.isEmpty), isTrue);

    // Plan zna liczbę statusów systemowych (nazw nadal nie), więc podgląd
    // pokazuje dokładnie tyle kolumn, ile powstanie.
    final withPlan = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(),
      plan: projectSetupPlan(),
    );
    expect(withPlan.columnSource, ProjectPreviewColumnSource.systemDefaults);
    expect(withPlan.systemStatusCount, 4);
    expect(withPlan.columns, hasLength(4));
    expect(withPlan.columns.every((column) => column.name.isEmpty), isTrue);
  });

  test('katalogowy układ statusów mówi, że kolumn jeszcze nie zna', () {
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        workflowChoice: ProjectSetupWorkflowChoice.catalogTemplate,
        workflowTemplateKey: 'marketing',
      ),
    );

    expect(snapshot.columnSource, ProjectPreviewColumnSource.catalogTemplate);
    expect(snapshot.columns, isEmpty);
    expect(snapshot.hasContent, isFalse);
  });

  test(
    'pusty projekt z planem bez własnych kolumn pokazuje statusy systemowe',
    () {
      final snapshot = buildProjectPreviewSnapshot(
        l10n: l10n,
        draft: const ProjectSetupDraft(),
        plan: projectSetupPlan(),
      );

      // Plan potwierdza cztery statusy systemowe, więc podgląd nie udaje, że
      // kolumny pochodzą z planu — mówi o statusach systemowych.
      expect(snapshot.columnSource, ProjectPreviewColumnSource.systemDefaults);
      expect(snapshot.systemStatusCount, 4);
      expect(snapshot.columns, hasLength(4));
    },
  );

  test('projekt z szablonu zachowuje kolumny szablonu razem z kartami', () {
    // Kontrakt: dla projektu z szablonu plan nie niesie własnych statusów
    // (ResolveWorkflow zwraca rodzaj domyślny), a serwer kopiuje statusy
    // i zadania szablonu. Podsumowanie nie może podmienić kolumn ani zgubić kart.
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: 'template-1',
      ),
      template: projectTemplateDetails(
        customFieldCount: 3,
        tasks: [
          projectTemplateTask(
            sourceId: 'task-1',
            title: 'Przygotować brief',
            customStatusSourceId: 'status-todo',
          ),
          projectTemplateTask(
            sourceId: 'task-2',
            title: 'Zebrać wymagania',
            customStatusSourceId: 'status-todo',
            position: 1,
          ),
        ],
        customStatuses: [
          projectTemplateStatus(
            sourceId: 'status-todo',
            name: 'Do zrobienia',
            color: '#2563EB',
            wipLimit: 2,
            isDefault: true,
          ),
        ],
      ),
      plan: projectSetupPlan(templateName: 'Szablon startowy'),
    );

    expect(snapshot.columnSource, ProjectPreviewColumnSource.template);
    expect(snapshot.planApproved, isTrue);
    expect(snapshot.columns.single.name, 'Do zrobienia');
    expect(snapshot.columns.single.wipLimit, 2);
    // Karty są na miejscu: kolumna nie może zostać pusta.
    expect(snapshot.columns.single.taskTitles, <String>[
      'Przygotować brief',
      'Zebrać wymagania',
    ]);
    expect(snapshot.columns.single.taskCount, 2);
    expect(snapshot.columns.single.hiddenTaskCount, 0);
    expect(snapshot.tasks, hasLength(2));
    expect(snapshot.taskTotal, 2);
    expect(snapshot.labels, hasLength(2));
    expect(snapshot.fields, hasLength(3));
  });

  test('plan z własnymi kolumnami nie odbiera szablonowi kart', () {
    // Kontrakt: dla projektu z szablonu plan zwraca workflow domyślne bez
    // własnych statusów (`ResolveWorkflow` w `ProjectSetupPlanner`, a po drugiej
    // stronie `SetupFromTemplateRecreatesWorkflowLabelsAndTasks`), bo statusy
    // i zadania materializuje snapshot szablonu. Ten test pilnuje, że nawet
    // plan niosący własne kolumny nie podmieni kolumn szablonu i nie zgubi kart.
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: 'template-1',
      ),
      template: projectTemplateDetails(
        tasks: [
          projectTemplateTask(
            sourceId: 'task-1',
            title: 'Przygotować brief',
            customStatusSourceId: 'status-todo',
          ),
          projectTemplateTask(
            sourceId: 'task-2',
            title: 'Zebrać wymagania',
            customStatusSourceId: 'status-todo',
            position: 1,
          ),
        ],
        customStatuses: [
          projectTemplateStatus(
            sourceId: 'status-todo',
            name: 'Do zrobienia',
            color: '#2563EB',
            isDefault: true,
          ),
        ],
      ),
      plan: projectSetupPlan(
        templateName: 'Szablon startowy',
        workflow: const ProjectSetupWorkflowPreviewResponse(
          kind: ProjectSetupWorkflowKind.explicitStatuses,
          systemStatusCount: 4,
          customStatuses: <ProjectSetupWorkflowStatusPreviewResponse>[
            ProjectSetupWorkflowStatusPreviewResponse(
              name: 'W realizacji',
              color: '#16A34A',
              category: TaskStatusCategory.inProgress,
              position: 0,
              isDefault: true,
            ),
          ],
        ),
      ),
    );

    expect(snapshot.columnSource, ProjectPreviewColumnSource.template);
    expect(snapshot.columns.single.name, 'Do zrobienia');
    expect(
      snapshot.columns.single.taskTitles,
      <String>['Przygotować brief', 'Zebrać wymagania'],
    );
    expect(snapshot.columns.single.taskCount, 2);
    expect(
      snapshot.tasks,
      hasLength(2),
      reason: 'plan nie może zgubić zadań szablonu',
    );
  });

  test('plan serwera jest źródłem kolumn i kart podsumowania', () {
    // Kontrakt: plan niesie kolumny (własne statusy, które powstaną) oraz zadania
    // z nazwą kolumny docelowej, więc podsumowanie pokazuje plan, a nie własne
    // dopasowanie po nazwie statusu. Szablon daje etykiety, pola i liczniki.
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: 'template-1',
      ),
      template: projectTemplateDetails(
        customFieldCount: 2,
        tasks: [
          projectTemplateTask(
            sourceId: 'task-1',
            title: 'Przygotować brief',
            customStatusSourceId: 'status-todo',
          ),
        ],
        customStatuses: [
          projectTemplateStatus(
            sourceId: 'status-todo',
            name: 'Do zrobienia',
            color: '#2563EB',
            isDefault: true,
          ),
        ],
      ),
      plan: projectSetupPlan(
        templateName: 'Szablon startowy',
        workflow: const ProjectSetupWorkflowPreviewResponse(
          kind: ProjectSetupWorkflowKind.systemDefault,
          systemStatusCount: 4,
          customStatuses: <ProjectSetupWorkflowStatusPreviewResponse>[
            ProjectSetupWorkflowStatusPreviewResponse(
              name: 'Do akceptacji',
              color: '#7C3AED',
              category: TaskStatusCategory.inProgress,
              position: 0,
              wipLimit: 3,
              isDefault: true,
            ),
          ],
        ),
        tasks: const <ProjectSetupTaskPreviewResponse>[
          ProjectSetupTaskPreviewResponse(
            title: 'Przygotować brief',
            statusName: 'Do akceptacji',
            priority: 'High',
            labels: <String>['UX'],
          ),
          ProjectSetupTaskPreviewResponse(
            title: 'Zebrać wymagania',
            statusName: 'Do akceptacji',
            priority: 'Normal',
            labels: <String>[],
          ),
        ],
      ),
    );

    expect(snapshot.planApproved, isTrue);
    expect(snapshot.columns.single.name, 'Do akceptacji');
    expect(snapshot.columns.single.colorHex, '#7C3AED');
    expect(
      snapshot.columns.single.taskTitles,
      <String>['Przygotować brief', 'Zebrać wymagania'],
      reason: 'karty trafiają do kolumny wskazanej przez plan',
    );
    expect(snapshot.columns.single.taskCount, 2);
    expect(snapshot.tasks.map((task) => task.title), <String>[
      'Przygotować brief',
      'Zebrać wymagania',
    ]);
    expect(snapshot.taskTotal, 2);
    expect(
      snapshot.tasks.first.priorityLabel,
      isNotNull,
      reason: 'priorytet zadania pochodzi z planu',
    );
    expect(snapshot.tasks.first.labels, <String>['UX']);
    expect(snapshot.fields, hasLength(2));
  });

  test(
    'mapowanie zadań na kolumny planu nie gubi kart i ignoruje spacje oraz wielkość liter',
    () {
      final columns = mapProjectPreviewTasksToColumns(
        tasks: const <ProjectPreviewTask>[
          ProjectPreviewTask(title: 'Pierwsze', statusName: 'W realizacji'),
          ProjectPreviewTask(title: 'Drugie', statusName: ' w REALIZACJI '),
          ProjectPreviewTask(title: 'Trzecie', statusName: 'Nieznany status'),
        ],
        columns: const <ProjectPreviewColumn>[
          ProjectPreviewColumn(name: 'W realizacji', colorHex: '#16A34A'),
          ProjectPreviewColumn(name: 'Gotowe', colorHex: '#2563EB'),
        ],
      );

      expect(columns, hasLength(3));
      expect(columns.first.name, 'W realizacji');
      expect(columns.first.taskTitles, <String>['Pierwsze', 'Drugie']);
      expect(columns.first.taskCount, 2);
      expect(
        columns.first.colorHex,
        '#16A34A',
        reason: 'kolumna planu zachowuje swój kolor',
      );
      expect(columns[1].name, 'Gotowe');
      expect(columns[1].taskCount, 0);
      expect(
        columns.last.name,
        'Nieznany status',
        reason: 'zadanie z nieznanym statusem dostaje własną kolumnę zamiast zniknąć',
      );
      expect(columns.last.taskCount, 1);
    },
  );

  testWidgets(
    'kolor statusu na liście nie zależy od wielkości liter i spacji',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().light(),
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: TemplateListPreview(
              snapshot: ProjectPreviewSnapshot(
                columns: <ProjectPreviewColumn>[
                  ProjectPreviewColumn(
                    name: 'Do zrobienia',
                    colorHex: '#16A34A',
                  ),
                ],
                tasks: <ProjectPreviewTask>[
                  ProjectPreviewTask(
                    title: 'Zadanie z inną pisownią statusu',
                    statusName: ' do ZROBIENIA ',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              (widget.decoration as BoxDecoration?)?.color ==
                  const Color(0xFF16A34A),
        ),
        findsOneWidget,
        reason:
            'kolor kolumny musi trafić do wiersza mimo innej pisowni statusu',
      );
    },
  );

  test('własne kolumny z planu wygrywają w pustym projekcie', () {
    final snapshot = buildProjectPreviewSnapshot(
      l10n: l10n,
      draft: const ProjectSetupDraft(),
      plan: projectSetupPlan(
        workflow: const ProjectSetupWorkflowPreviewResponse(
          kind: ProjectSetupWorkflowKind.explicitStatuses,
          systemStatusCount: 4,
          customStatuses: <ProjectSetupWorkflowStatusPreviewResponse>[
            ProjectSetupWorkflowStatusPreviewResponse(
              name: 'Wdrożone',
              color: '#16A34A',
              category: TaskStatusCategory.done,
              position: 0,
              wipLimit: 5,
              isDefault: false,
            ),
          ],
        ),
      ),
    );

    expect(snapshot.columnSource, ProjectPreviewColumnSource.plan);
    expect(snapshot.columns.single.name, 'Wdrożone');
    expect(snapshot.columns.single.wipLimit, 5);
    expect(snapshot.columns.single.category, TaskStatusCategory.done);
  });

  test('nieznana kategoria i zły HEX nie wywracają podglądu', () {
    expect(projectSetupStatusCategory('Nieznana'), isNull);
    expect(
      projectSetupStatusCategory('InProgress'),
      TaskStatusCategory.inProgress,
    );
    expect(ProjectDialogColorHexCodec.toColor('#ZZZZZZ'), isNull);
    expect(
      projectPreviewColor('#ZZZZZZ', const Color(0xFF123456)),
      const Color(0xFF123456),
    );
    expect(
      projectPreviewColor('#2563EB', const Color(0xFF123456)),
      const Color(0xFF2563EB),
    );
  });

  test('etykieta priorytetu tłumaczy znane wartości i pokazuje nieznane', () {
    expect(projectSetupPriorityLabel(l10n, 'High'), l10n.tasksPriorityHigh);
    expect(projectSetupPriorityLabel(l10n, 'Medium'), l10n.tasksPriorityNormal);
    expect(projectSetupPriorityLabel(l10n, 'Nietypowy'), 'Nietypowy');
    expect(projectSetupPriorityLabel(l10n, '  '), isNull);
  });
}
