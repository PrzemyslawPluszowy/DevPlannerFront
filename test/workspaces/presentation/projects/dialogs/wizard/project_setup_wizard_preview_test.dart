import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/project_creation_wizard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Szablon z dwiema kolumnami, limitem WIP i zadaniami w obu z nich.
ProjectTemplateDetailsResponse _templateWithTasks({
  String id = 'template-1',
  String name = 'Szablon startowy',
  String color = '#2563EB',
}) => projectTemplateDetails(
  id: id,
  name: name,
  customStatuses: [
    projectTemplateStatus(
      sourceId: 'status-todo',
      name: 'Do zrobienia',
      color: color,
      wipLimit: 2,
      isDefault: true,
    ),
    projectTemplateStatus(
      sourceId: 'status-doing',
      name: 'W toku',
      color: '#F59E0B',
      position: 1,
    ),
  ],
  tasks: [
    projectTemplateTask(
      sourceId: 'task-1',
      title: 'Przygotować brief',
      customStatusSourceId: 'status-todo',
      priority: 'High',
    ),
    projectTemplateTask(
      sourceId: 'task-2',
      title: 'Zebrać wymagania',
      customStatusSourceId: 'status-todo',
    ),
    projectTemplateTask(
      sourceId: 'task-3',
      title: 'Zaprojektować ekran',
      customStatusSourceId: 'status-todo',
    ),
    projectTemplateTask(
      sourceId: 'task-4',
      title: 'Wdrożyć nagłówek',
      customStatusSourceId: 'status-todo',
    ),
    projectTemplateTask(
      sourceId: 'task-5',
      title: 'Testy akceptacyjne',
      customStatusSourceId: 'status-doing',
    ),
  ],
);

Future<void> _openWizard(
  WidgetTester tester, {
  required FakeProjectTemplatesRepository templates,
  FakeProjectSetupsRepository? setups,
}) async {
  await pumpProjectSetupApp(
    tester,
    open: (context) => ProjectResourceCreationDialogs.showCreateProject(
      context,
      workspaceId: kProjectSetupWorkspaceId,
      repository: FakeSessionProjectsRepository(
        setups ?? FakeProjectSetupsRepository(),
      ),
      templatesRepository: templates,
      onCreated: () {},
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('wybrany szablon pokazuje prawdziwe kolumny i zadania', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository();
    final templates = FakeProjectTemplatesRepository(
      templates: <ProjectTemplateResponse>[projectTemplate()],
      details: _templateWithTasks(),
    );
    await _openWizard(tester, templates: templates, setups: setups);

    expect(tester.takeException(), isNull);
    await _tap(tester, findInControls('Szablon startowy'));
    await _tap(tester, find.text('Kanban'));

    // Kolumny pochodzą z szablonu: nazwy, zadania i liczniki.
    expect(findInPreview('Do zrobienia'), findsOneWidget);
    expect(findInPreview('W toku'), findsOneWidget);
    expect(findInPreview('Przygotować brief'), findsOneWidget);
    expect(findInPreview('Testy akceptacyjne'), findsOneWidget);
    // W kolumnie jest 4 zadania, a podgląd mieści 3 — reszta jest policzona.
    expect(findInPreview('+1 więcej zadań'), findsOneWidget);
    // Limit WIP i kategoria domyślnej kolumny są widoczne.
    expect(findInPreview('WIP 2'), findsOneWidget);
    // Etykiety i pola szablonu też trafiają do podglądu.
    expect(findInPreview('Etykiety: 2'), findsOneWidget);
    expect(findInPreview('Pola: 1'), findsOneWidget);

    expect(templates.detailsRequests, <String>['template-1']);
    // Podgląd nie wysyła żadnego innego żądania.
    expect(setups.previewRequests, isEmpty);
    expect(setups.createRequests, isEmpty);
  });

  testWidgets('przełączenie Kanban/Lista nie zmienia draftu ani nie pyta API', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository();
    await _openWizard(
      tester,
      setups: setups,
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: _templateWithTasks(),
      ),
    );
    await _tap(tester, findInControls('Szablon startowy'));

    // Domyślny widok projektu to lista, więc podgląd startuje jako lista.
    expect(findInPreview('Zadanie'), findsOneWidget);
    expect(findInPreview('Przygotować brief'), findsOneWidget);

    await _tap(tester, find.text('Kanban'));

    // Widok tablicy pokazuje kolumny, a draft nadal wskazuje listę.
    expect(findInPreview('Do zrobienia'), findsOneWidget);
    final wizard = tester.widget<ProjectCreationWizard>(
      find.byType(ProjectCreationWizard),
    );
    expect(
      wizard.cubit.state.draft.defaultView,
      ProjectSetupTaskViewKind.list,
    );
    expect(wizard.cubit.state.draft.usesTemplate, isTrue);
    expect(setups.previewRequests, isEmpty);
    expect(setups.createRequests, isEmpty);
  });

  testWidgets('podgląd jest pamiętany, więc powrót nie miga skeletonem', (
    tester,
  ) async {
    final templates = FakeProjectTemplatesRepository(
      templates: <ProjectTemplateResponse>[
        projectTemplate(),
        projectTemplate(id: 'template-2', name: 'Marketing'),
      ],
      onDetails: (templateId) async => Right(
        _templateWithTasks(
          id: templateId,
          name: templateId == 'template-2' ? 'Marketing' : 'Szablon startowy',
        ),
      ),
    );
    await _openWizard(tester, templates: templates);

    await _tap(tester, findInControls('Szablon startowy'));
    expect(find.byType(AppShimmerBox), findsNothing);

    await _tap(tester, findInControls('Marketing'));
    await _tap(tester, findInControls('Szablon startowy'));

    // Powrót do szablonu z pamięci: bez nowego żądania i bez szkieletu.
    expect(templates.detailsRequests, <String>['template-1', 'template-2']);
    expect(find.byType(AppShimmerBox), findsNothing);
    expect(findInPreview('Przygotować brief'), findsOneWidget);
  });

  testWidgets('podgląd reaguje na kolejne kroki kreatora', (tester) async {
    await _openWizard(
      tester,
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: _templateWithTasks(),
      ),
    );
    await _tap(tester, findInControls('Szablon startowy'));

    // Krok podstaw: nazwa i opis projektu od razu w nagłówku podglądu.
    await _tap(tester, find.text('2. Podstawy'));
    await tester.enterText(
      find.byType(TextField).first,
      'Wdrożenie DevPlanner',
    );
    await tester.pumpAndSettle();
    expect(findInPreview('Wdrożenie DevPlanner'), findsOneWidget);

    // Krok workflow: podgląd mówi, skąd pochodzą kolumny.
    await _tap(tester, find.text('4. Workflow'));
    expect(findInPreview('Kolumny z szablonu'), findsOneWidget);

    // Krok sposobu pracy: gęstość i ustawienia listy są odzwierciedlone.
    await _tap(tester, find.text('5. Sposób pracy'));
    expect(findInPreview('Ustawienia tablicy'), findsOneWidget);
    expect(findInPreview('Ustawienia listy'), findsOneWidget);
    expect(findInPreview('Widoczne pola: 3'), findsOneWidget);
  });

  testWidgets('jawny status z draftu pojawia się jako kolumna podglądu', (
    tester,
  ) async {
    await _openWizard(
      tester,
      templates: FakeProjectTemplatesRepository(),
    );

    await _tap(tester, find.text('4. Workflow'));
    await _tap(tester, findInControls('Własne statusy'));
    await tester.enterText(find.byType(TextField).first, 'Do przeglądu');
    await tester.pumpAndSettle();

    expect(findInPreview('Do przeglądu'), findsOneWidget);
    expect(
      findInPreview(
        'Te kolumny zdefiniujesz sam. Pojawią się w projekcie '
        'w podanej kolejności.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('błąd podglądu nie kasuje danych wcześniej pobranego szablonu', (
    tester,
  ) async {
    final templates = FakeProjectTemplatesRepository(
      templates: <ProjectTemplateResponse>[
        projectTemplate(),
        projectTemplate(id: 'template-2', name: 'Marketing'),
      ],
      onDetails: (templateId) async {
        if (templateId == 'template-2') {
          return Left(
            projectSetupApiError(
              message: 'Podgląd szablonu jest chwilowo niedostępny.',
              statusCode: 503,
            ),
          );
        }
        return Right(_templateWithTasks());
      },
    );
    await _openWizard(tester, templates: templates);

    await _tap(tester, findInControls('Szablon startowy'));
    expect(findInPreview('Przygotować brief'), findsOneWidget);

    await _tap(tester, findInControls('Marketing'));
    expect(
      findInPreview('Podgląd szablonu jest chwilowo niedostępny.'),
      findsOneWidget,
    );
    expect(
      findInPreview(
        'Spróbuj ponownie. Jeśli problem się powtórzy, zgłoś go '
        'administratorowi.',
      ),
      findsOneWidget,
    );
    expect(findInPreview('Ponów'), findsOneWidget);

    // Powrót do szablonu z pamięci przywraca jego prawdziwe dane.
    await _tap(tester, findInControls('Szablon startowy'));
    expect(findInPreview('Przygotować brief'), findsOneWidget);
    expect(
      findInPreview('Podgląd szablonu jest chwilowo niedostępny.'),
      findsNothing,
    );
  });

  testWidgets('niepoprawny kolor w szablonie nie wywraca podglądu', (
    tester,
  ) async {
    await _openWizard(
      tester,
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: _templateWithTasks(color: '#ZZZZZZ'),
      ),
    );

    await _tap(tester, findInControls('Szablon startowy'));

    // Zły kolor nie może przerwać renderowania: podgląd pokazuje kolumnę
    // w kolorze motywu, a lista nadal ma wiersze zadań.
    expect(tester.takeException(), isNull);
    expect(findInPreview('Do zrobienia'), findsWidgets);
    expect(findInPreview('Przygotować brief'), findsOneWidget);
  });

  testWidgets('podsumowanie projektu z szablonu zachowuje kolumny i karty', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository(
      onPreview: (request) async =>
          Right(projectSetupPlan(name: request.project.name)),
    );
    await _openWizard(
      tester,
      setups: setups,
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: _templateWithTasks(),
      ),
    );

    await _tap(tester, findInControls('Szablon startowy'));
    await _tap(tester, find.text('2. Podstawy'));
    await tester.enterText(find.byType(TextField).first, 'Projekt z szablonu');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('7. Podsumowanie'));

    expect(setups.previewRequests, hasLength(1));
    // Plan dla projektu z szablonu nie niesie jego kolumn (Backend zostawia
    // workflow szablonowi), więc nota mówi o zgodności z planem, a nie
    // o zatwierdzonych kolumnach, i nie zamienia ich na statusy systemowe.
    expect(findInPreview('Zgodne z planem serwera'), findsOneWidget);
    expect(findInPreview('Statusy systemowe'), findsNothing);
    expect(findInPreview('Przygotować brief'), findsOneWidget);
    expect(findInPreview('Etykiety: 2'), findsOneWidget);
    expect(findInPreview('Pola: 1'), findsOneWidget);

    // Tablica pokazuje kolumny szablonu razem z kartami.
    await _tap(tester, find.text('Kanban'));
    expect(findInPreview('Do zrobienia'), findsOneWidget);
    expect(findInPreview('Przygotować brief'), findsOneWidget);
    expect(findInPreview('WIP 2'), findsOneWidget);
  });

  testWidgets('podsumowanie pustego projektu pokazuje kolumny z planu', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository(
      onPreview: (request) async => Right(
        projectSetupPlan(
          name: request.project.name,
          workflow: const ProjectSetupWorkflowPreviewResponse(
            kind: ProjectSetupWorkflowKind.explicitStatuses,
            systemStatusCount: 4,
            customStatuses: <ProjectSetupWorkflowStatusPreviewResponse>[
              ProjectSetupWorkflowStatusPreviewResponse(
                name: 'Gotowe do wdrożenia',
                color: '#16A34A',
                category: TaskStatusCategory.done,
                position: 0,
                wipLimit: 4,
                isDefault: false,
              ),
            ],
          ),
        ),
      ),
    );
    await _openWizard(
      tester,
      setups: setups,
      templates: FakeProjectTemplatesRepository(),
    );

    await _tap(tester, find.text('2. Podstawy'));
    await tester.enterText(find.byType(TextField).first, 'Projekt z planem');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('7. Podsumowanie'));

    expect(setups.previewRequests, hasLength(1));
    // Pusty projekt nie ma zadań, więc podgląd pokazuje kolumny zatwierdzone
    // przez plan i mówi, że pochodzą z planu.
    expect(findInPreview('Gotowe do wdrożenia'), findsOneWidget);
    expect(findInPreview('WIP 4'), findsOneWidget);
    expect(
      findInPreview('Kolumny zatwierdzone w planie'),
      findsOneWidget,
    );
  });
}
