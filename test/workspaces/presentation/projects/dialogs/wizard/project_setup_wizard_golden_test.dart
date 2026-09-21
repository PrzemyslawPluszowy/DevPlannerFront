import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_mode_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Pięć scenariuszy wizualnych wymaganych przez plan UX kreatora.
///
/// Goldeny utrwalają układ modala, proporcje paneli i hierarchię kroków tak, jak
/// widzi je użytkownik: razem z tłem dialogu, nagłówkiem i stopką. Zmiana
/// szerokości panelu albo zniknięcie podglądu jest tu widoczne od razu.
void main() {
  final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    colorSchemeSeed: const Color(0xFF6C5CE7),
  );

  final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    colorSchemeSeed: const Color(0xFF6C5CE7),
  );

  ProjectTemplateDetailsResponse template() => projectTemplateDetails(
    customStatuses: [
      projectTemplateStatus(
        sourceId: 'status-todo',
        name: 'Do zrobienia',
        color: '#2563EB',
        wipLimit: 3,
        isDefault: true,
      ),
      projectTemplateStatus(
        sourceId: 'status-doing',
        name: 'W toku',
        color: '#F59E0B',
        position: 1,
      ),
      projectTemplateStatus(
        sourceId: 'status-done',
        name: 'Gotowe',
        color: '#16A34A',
        category: 'Done',
        position: 2,
      ),
    ],
    tasks: [
      projectTemplateTask(
        sourceId: 'task-1',
        title: 'Przygotować brief marketingowy',
        customStatusSourceId: 'status-todo',
        priority: 'High',
      ),
      projectTemplateTask(
        sourceId: 'task-2',
        title: 'Zebrać wymagania od zespołu',
        customStatusSourceId: 'status-todo',
      ),
      projectTemplateTask(
        sourceId: 'task-3',
        title: 'Zaprojektować ekran startowy',
        customStatusSourceId: 'status-doing',
      ),
      projectTemplateTask(
        sourceId: 'task-4',
        title: 'Testy akceptacyjne',
        customStatusSourceId: 'status-done',
      ),
    ],
  );

  Future<void> pump(
    WidgetTester tester, {
    required ThemeData theme,
    required FakeProjectTemplatesRepository templates,
    FakeProjectSetupsRepository? setups,
    Size viewport = const Size(1440, 900),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.reset);
    await pumpProjectSetupApp(
      tester,
      viewport: viewport,
      theme: theme,
      open: (context) => ProjectResourceCreationDialogs.showCreateProject(
        context,
        workspaceId: kProjectSetupWorkspaceId,
        repository: FakeSessionProjectsRepository(
          setups ?? FakeProjectSetupsRepository(),
        ),
        templatesRepository: templates,
        membersRepository: FakeWorkspaceMembersRepository(),
        onCreated: () {},
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> capture(WidgetTester tester, String name) => expectLater(
    find.byKey(kProjectSetupAppKey),
    matchesGoldenFile('goldens/$name.png'),
  );

  testWidgets('start z wybranym szablonem, desktop light', (tester) async {
    await pump(
      tester,
      theme: lightTheme,
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: template(),
      ),
    );
    await tap(tester, findInControls('Szablon startowy'));

    await capture(tester, 'wizard_start_template_light');
  });

  testWidgets('workflow z własnymi statusami, desktop dark', (tester) async {
    await pump(
      tester,
      theme: darkTheme,
      templates: FakeProjectTemplatesRepository(),
    );
    await tap(tester, find.text('4. Workflow'));
    await tap(tester, findInControls('Własne statusy'));

    await capture(tester, 'wizard_workflow_explicit_dark');
  });

  testWidgets('sposób pracy z podglądem Kanban, desktop light', (tester) async {
    await pump(
      tester,
      theme: lightTheme,
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: template(),
      ),
    );
    await tap(tester, findInControls('Szablon startowy'));
    await tap(tester, find.text('5. Sposób pracy'));
    // Krok sposobu pracy ma własny przełącznik domyślnego widoku, więc
    // przełącznik podglądu wskazujemy po kluczu.
    await tap(
      tester,
      find.descendant(
        of: find.byKey(ProjectPreviewModeToggle.toggleKey),
        matching: find.text('Kanban'),
      ),
    );

    await capture(tester, 'wizard_working_style_kanban_light');
  });

  testWidgets('wąski modal 720×640', (tester) async {
    await pump(
      tester,
      theme: lightTheme,
      viewport: const Size(720, 640),
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: template(),
      ),
    );
    await tap(tester, findInControls('Szablon startowy'));

    await capture(tester, 'wizard_narrow_720x640');
  });

  testWidgets('błąd podglądu i ostrzeżenia planu', (tester) async {
    final setups = FakeProjectSetupsRepository(
      onPreview: (request) async => Right(
        projectSetupPlan(
          name: request.project.name,
          warnings: const <ProjectSetupWarningResponse>[
            ProjectSetupWarningResponse(
              code: 'project_setup.workspace_capacity_changed',
              message: 'Pojemność workspace zostanie zmieniona.',
            ),
          ],
        ),
      ),
    );
    await pump(
      tester,
      theme: lightTheme,
      setups: setups,
      templates: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: template(),
      ),
    );

    await tap(tester, find.text('2. Podstawy'));
    await tester.enterText(
      find.byType(TextField).first,
      'Wdrożenie DevPlanner',
    );
    await tester.pumpAndSettle();
    await tap(tester, find.text('7. Podsumowanie'));

    await capture(tester, 'wizard_summary_warnings_light');
  });
}
