import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/project_creation_wizard.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_mode_toggle.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/template_kanban_preview.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/template_list_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'project_setup_wizard_fixture.dart';

/// Regresje zgłoszone w przeglądzie: stan wiersza statusu po usunięciu
/// sąsiada i zgodność przełącznika podglądu z tym, co widać pod nim.
void main() {
  Future<void> openWizard(
    WidgetTester tester, {
    FakeProjectTemplatesRepository? templates,
  }) async {
    await pumpProjectSetupApp(
      tester,
      open: (context) => ProjectResourceCreationDialogs.showCreateProject(
        context,
        workspaceId: kProjectSetupWorkspaceId,
        repository: FakeSessionProjectsRepository(
          FakeProjectSetupsRepository(),
        ),
        templatesRepository: templates ?? FakeProjectTemplatesRepository(),
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

  ProjectSetupWizardState wizardState(WidgetTester tester) => tester
      .widget<ProjectCreationWizard>(find.byType(ProjectCreationWizard))
      .cubit
      .state;

  /// Pole nazwy wiersza statusu o podanym indeksie.
  Finder nameField(int index) => find
      .descendant(
        of: find.byKey(ValueKey('project-setup-status-$index')),
        matching: find.byType(TextField),
      )
      .first;

  /// Pole limitu WIP wiersza statusu o podanym indeksie.
  Finder wipField(int index) => find
      .descendant(
        of: find.byKey(ValueKey('project-setup-status-$index')),
        matching: find.byType(TextField),
      )
      .last;

  /// Wpisuje nazwy trzech własnych statusów.
  Future<void> fillThreeStatuses(WidgetTester tester) async {
    await tap(tester, find.text('4. Workflow'));
    await tap(tester, findInControls('Własne statusy'));
    await tester.enterText(nameField(0), 'Pierwszy');
    await tester.pumpAndSettle();
    for (var index = 1; index < 3; index++) {
      await tap(tester, findInControls('Dodaj status'));
      await tester.enterText(
        nameField(index),
        <String>['', 'Drugi', 'Trzeci'][index],
      );
      await tester.pumpAndSettle();
    }
  }

  group('wiersze własnych statusów', () {
    testWidgets(
      'usunięcie środkowego wiersza pokazuje dane właściwych statusów',
      (
        tester,
      ) async {
        await openWizard(tester);
        await fillThreeStatuses(tester);

        expect(
          wizardState(tester).draft.customStatuses.map((status) => status.name),
          <String>['Pierwszy', 'Drugi', 'Trzeci'],
        );

        // Usuwamy środkowy wiersz — Flutter oddaje jego stan sąsiadowi, więc
        // kontrolery muszą przesynchronizować się z draftem.
        await tap(tester, find.byIcon(Symbols.delete).at(1));

        final names = wizardState(
          tester,
        ).draft.customStatuses.map((status) => status.name).toList();
        expect(names, <String>['Pierwszy', 'Trzeci']);

        // Pola pokazują nazwy swoich statusów, a nie nazwy sprzed usunięcia.
        final fields = [
          for (var index = 0; index < 2; index++)
            tester.widget<TextField>(nameField(index)).controller?.text,
        ];
        expect(fields, <String>['Pierwszy', 'Trzeci']);
      },
    );

    testWidgets('edycja po usunięciu zmienia właściwy status', (tester) async {
      await openWizard(tester);
      await fillThreeStatuses(tester);
      await tap(tester, find.byIcon(Symbols.delete).at(0));

      // Pierwszy widoczny wiersz to teraz dawny „Drugi”.
      await tester.enterText(find.byType(TextField).first, 'Drugi po zmianie');
      await tester.pumpAndSettle();

      expect(
        wizardState(tester).draft.customStatuses.map((status) => status.name),
        <String>['Drugi po zmianie', 'Trzeci'],
      );
    });

    testWidgets('limit WIP nie zostaje po usunięciu sąsiada', (tester) async {
      await openWizard(tester);
      await tap(tester, find.text('4. Workflow'));
      await tap(tester, findInControls('Własne statusy'));
      await tester.enterText(find.byType(TextField).first, 'Pierwszy');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '7');
      await tester.pumpAndSettle();

      await tap(tester, findInControls('Dodaj status'));
      await tester.enterText(find.byType(TextField).last, 'Drugi');
      await tester.pumpAndSettle();
      // Drugi status nie ma limitu WIP.
      expect(
        wizardState(tester).draft.customStatuses.map(
          (status) => status.wipLimit,
        ),
        <int?>[7, null],
      );

      await tap(tester, find.byIcon(Symbols.delete).first);

      expect(
        wizardState(tester).draft.customStatuses.map(
          (status) => status.wipLimit,
        ),
        <int?>[null],
      );
      final wip = tester.widget<TextField>(wipField(0)).controller?.text;
      expect(wip, '');
    });
  });

  group('przełącznik podglądu zgadza się z renderem', () {
    testWidgets('pusta lista z kolumnami pokazuje zaznaczony Kanban', (
      tester,
    ) async {
      await openWizard(tester);
      await tap(tester, find.text('4. Workflow'));
      await tap(tester, findInControls('Własne statusy'));
      await tester.enterText(find.byType(TextField).first, 'Do przeglądu');
      await tester.pumpAndSettle();

      // Domyślny widok to lista, ale lista nie ma ani jednego wiersza, więc
      // podgląd pokazuje tablicę — i przełącznik musi to odzwierciedlać.
      final toggle = tester.widget<SegmentedButton<ProjectSetupTaskViewKind>>(
        find.byKey(ProjectPreviewModeToggle.toggleKey),
      );
      expect(toggle.selected, {ProjectSetupTaskViewKind.board});
      expect(find.byType(TemplateKanbanPreview), findsOneWidget);
      expect(find.byType(TemplateListPreview), findsNothing);
    });
  });
}
