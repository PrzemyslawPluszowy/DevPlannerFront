import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Trzy uproszczenia kroków z UX-5: miniatury kolumn na opcjach workflow,
/// bramka „Dostosuj także…” w sposobie pracy i reguły na kartach automatyzacji.
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

  /// Znajduje tekst w obszarze kontrolek kroku.
  Finder inStep(String text) => find.descendant(
    of: find.byKey(ProjectSetupWizardLayout.controlsKey),
    matching: find.text(text),
  );

  group('miniatury kolumn na opcjach workflow', () {
    testWidgets('każda opcja pokazuje swoje kolumny', (tester) async {
      await openWizard(tester);
      await tap(tester, find.text('4. Workflow'));

      // Legenda miniatury jest przy każdej z trzech opcji.
      expect(inStep('Kolumny tej opcji'), findsNWidgets(3));

      // Standard: sama obietnica kolumn systemowych — kontrakt nie zdradza
      // ich nazw, więc miniatura nie pokazuje żadnej wymyślonej nazwy.
      expect(
        inStep('Te kolumny powstają w każdym nowym projekcie.'),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('project-setup-status-0')),
          matching: find.text('Do zrobienia'),
        ),
        findsNothing,
      );

      // Katalog: sam kształt tablicy, bez wymyślania nazw kolumn.
      expect(
        inStep(
          'Gotowy układ dobierzesz z listy — podgląd po prawej pokaże jego '
          'kolumny po wybraniu.',
        ),
        findsOneWidget,
      );

      // Własne statusy: kolumny z draftu (na start jedna pusta).
      expect(inStep('Własne kolumny dodasz poniżej.'), findsOneWidget);
    });

    testWidgets('miniatura własnych statusów zmienia się z draftem', (
      tester,
    ) async {
      await openWizard(tester);
      await tap(tester, find.text('4. Workflow'));
      await tap(tester, findInControls('Własne statusy'));
      await tester.enterText(find.byType(TextField).first, 'Do przeglądu');
      await tester.pumpAndSettle();

      expect(inStep('Do przeglądu'), findsWidgets);
    });
  });

  group('bramka „Dostosuj także…” w sposobie pracy', () {
    testWidgets(
      'domyślny widok listy pokazuje ustawienia listy i chowa tablicę',
      (
        tester,
      ) async {
        await openWizard(tester);
        await tap(tester, find.text('5. Sposób pracy'));

        expect(inStep('Lista zadań'), findsOneWidget);
        expect(inStep('Tablica Kanban'), findsNothing);
        // Bramka mówi, co się stanie z ukrytymi ustawieniami.
        expect(
          inStep(
            'Ustawienia drugiego widoku trafią do projektu z wartościami '
            'domyślnymi; zobaczysz je w podsumowaniu.',
          ),
          findsOneWidget,
        );

        await tap(tester, inStep('Dostosuj także ustawienia tablicy'));

        expect(inStep('Tablica Kanban'), findsOneWidget);
        expect(inStep('Wysoki priorytet'), findsNothing);
        expect(inStep('Dostosuj także ustawienia tablicy'), findsNothing);
      },
    );

    testWidgets('zmiana domyślnego widoku odwraca widoczne ustawienia', (
      tester,
    ) async {
      await openWizard(tester);
      await tap(tester, find.text('5. Sposób pracy'));
      await tap(tester, inStep('Kanban'));

      expect(inStep('Tablica Kanban'), findsOneWidget);
      expect(inStep('Lista zadań'), findsNothing);
      expect(inStep('Dostosuj także ustawienia listy'), findsOneWidget);

      await tap(tester, inStep('Dostosuj także ustawienia listy'));
      expect(inStep('Lista zadań'), findsOneWidget);
    });

    testWidgets('błąd pola tablicy odsłania jej ustawienia mimo bramki', (
      tester,
    ) async {
      await openWizard(tester);
      await tap(tester, find.text('5. Sposób pracy'));
      await tap(tester, inStep('Kanban'));
      // Odznaczenie wszystkich pól kafelka to błąd walidacji.
      for (final field in <String>['Wykonawcy', 'Termin', 'Etykiety']) {
        await tap(tester, inStep(field));
      }
      expect(
        inStep('Wybierz co najmniej jedno pole widoczne na kafelku.'),
        findsOneWidget,
      );

      // Powrót na listę jako domyślny widok nie może ukryć błędu.
      await tap(tester, inStep('Lista'));
      expect(inStep('Tablica Kanban'), findsOneWidget);
      expect(
        inStep('Wybierz co najmniej jedno pole widoczne na kafelku.'),
        findsOneWidget,
      );
      expect(inStep('Dostosuj także ustawienia tablicy'), findsNothing);
    });
  });

  group('reguły na kartach funkcji startowych', () {
    testWidgets('każda automatyzacja pokazuje „Gdy… → wtedy…”', (tester) async {
      await openWizard(tester);
      await tap(tester, find.text('6. Funkcje startowe'));

      expect(inStep('Gdy: '), findsNWidgets(4));
      expect(inStep('wtedy: '), findsNWidgets(4));
      expect(inStep('wyczyść termin zadania'), findsOneWidget);
      expect(inStep('podnieś priorytet do wysokiego'), findsOneWidget);
    });
  });
}
