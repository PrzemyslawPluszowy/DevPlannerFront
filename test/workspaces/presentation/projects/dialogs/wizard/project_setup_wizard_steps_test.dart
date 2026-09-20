import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Otwiera kreator przez publiczne wejście z jawnie wstrzykniętym portem.
Future<void> _openWizard(
  WidgetTester tester, {
  required FakeProjectSetupsRepository setups,
  FakeProjectTemplatesRepository? templates,
  FakeWorkspaceMembersRepository? members,
}) async {
  await pumpProjectSetupApp(
    tester,
    open: (context) => ProjectResourceCreationDialogs.showCreateProject(
      context,
      workspaceId: kProjectSetupWorkspaceId,
      repository: FakeSessionProjectsRepository(setups),
      templatesRepository: templates,
      membersRepository: members,
      onCreated: () {},
    ),
  );
  await tester.pumpAndSettle();
}

/// Wpisuje nazwę projektu w kroku podstaw.
Future<void> _enterName(WidgetTester tester, String name) async {
  await tester.enterText(find.byType(TextField).first, name);
  await tester.pumpAndSettle();
}

/// Sprawdza, czy kreator pokazuje wskazany krok.
void _expectStep(WidgetTester tester, int ordinal) {
  expect(find.textContaining('Krok $ordinal z 7'), findsOneWidget);
}

void main() {
  testWidgets('przejście w przód i w tył zachowuje draft', (tester) async {
    final setups = FakeProjectSetupsRepository();
    await _openWizard(tester, setups: setups);

    _expectStep(tester, 1);
    // Krok pierwszy nie ma poprzednika, więc cofanie jest wyłączone.
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Wstecz'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();
    _expectStep(tester, 2);

    await _enterName(tester, 'Wdrożenie DevPlanner');
    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();
    _expectStep(tester, 3);
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Wstecz'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Wstecz'));
    await tester.pumpAndSettle();
    _expectStep(tester, 2);
    // Draft przeżył cofanie: pole nadal pokazuje wpisaną nazwę.
    expect(find.text('Wdrożenie DevPlanner'), findsOneWidget);

    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();
    _expectStep(tester, 3);
    expect(setups.previewRequests, isEmpty);
    expect(setups.createRequests, isEmpty);
  });

  testWidgets('brak nazwy blokuje przejście i pokazuje błąd przy polu', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository();
    await _openWizard(tester, setups: setups);

    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();

    _expectStep(tester, 2);
    expect(find.text('Wprowadź nazwę projektu.'), findsOneWidget);

    await _enterName(tester, 'Projekt z nazwą');
    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();

    _expectStep(tester, 3);
    expect(find.text('Wprowadź nazwę projektu.'), findsNothing);
  });

  testWidgets('krok startu nie wypuszcza dalej, gdy draft nie ma nazwy', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository();
    await _openWizard(tester, setups: setups);

    // Walidacja obejmuje cały draft, więc krok bez nazwy nie przechodzi dalej —
    // kreator zostaje w miejscu i nie wysyła żadnego żądania.
    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();

    _expectStep(tester, 1);
    expect(setups.previewRequests, isEmpty);
    expect(setups.createRequests, isEmpty);
  });

  testWidgets('kroki opcjonalne można pominąć do podsumowania', (tester) async {
    final setups = FakeProjectSetupsRepository(
      // Plan budowany jest z draftu, więc podsumowanie musi pokazać nazwę,
      // którą użytkownik wpisał, a nie wartość spoza draftu.
      onPreview: (request) async =>
          Right(projectSetupPlan(name: request.project.name)),
    );
    await _openWizard(tester, setups: setups);

    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();
    await _enterName(tester, 'Projekt skrócony');
    await tester.tap(find.text('Pomiń do podsumowania'));
    await tester.pumpAndSettle();

    _expectStep(tester, 7);
    expect(find.text('Utwórz projekt'), findsOneWidget);
    expect(find.text('Pomiń do podsumowania'), findsNothing);
    expect(find.text('Pusty projekt'), findsOneWidget);
    expect(find.text('Projekt skrócony'), findsOneWidget);
    expect(setups.previewRequests, hasLength(1));
    expect(setups.previewRequests.single.project.name, 'Projekt skrócony');
    // Kroki opcjonalne nie znikają z planu: wartości domyślne trafiają do
    // żądania bez wizyty użytkownika w tych krokach.
    expect(
      setups.previewRequests.single.workflow?.kind,
      ProjectSetupWorkflowKind.systemDefault,
    );
  });

  testWidgets('pominięcie z niepoprawnym draftem zostaje i przenosi do błędu', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository();
    await _openWizard(tester, setups: setups);

    await tester.tap(find.text('Pomiń do podsumowania'));
    await tester.pumpAndSettle();

    _expectStep(tester, 1);
    expect(setups.previewRequests, isEmpty);

    // Błąd należy do pola z kroku drugiego, więc pokazuje go dopiero ten krok.
    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();
    expect(find.text('Wprowadź nazwę projektu.'), findsOneWidget);
  });

  testWidgets('pole bez wartości pokazuje błąd i blokuje wyjście dalej', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository();
    await _openWizard(tester, setups: setups);

    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();
    await _enterName(tester, 'Projekt z polami');
    await tester.tap(find.text('5. Sposób pracy'));
    await tester.pumpAndSettle();
    _expectStep(tester, 5);
    expect(
      find.text('Wybierz co najmniej jedno pole widoczne na kafelku.'),
      findsNothing,
    );

    for (final field in <String>['Wykonawcy', 'Termin', 'Etykiety']) {
      // Krok sposobu pracy jest dłuższy niż modal, więc pole trzeba odsłonić
      // przed kliknięciem.
      await tester.ensureVisible(find.text(field));
      await tester.pumpAndSettle();
      await tester.tap(find.text(field));
      await tester.pumpAndSettle();
    }

    expect(
      find.text('Wybierz co najmniej jedno pole widoczne na kafelku.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();
    _expectStep(tester, 5);

    await tester.ensureVisible(find.text('Wykonawcy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wykonawcy'));
    await tester.pumpAndSettle();
    expect(
      find.text('Wybierz co najmniej jedno pole widoczne na kafelku.'),
      findsNothing,
    );
    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();
    _expectStep(tester, 6);
  });
}
