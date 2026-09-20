import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Otwiera kreator i prowadzi draft do podsumowania z wpisaną nazwą.
Future<void> _openSummary(
  WidgetTester tester, {
  required FakeProjectSetupsRepository setups,
  String name = 'Projekt z nazwą',
  ValueChanged<String>? onProjectCreated,
  void Function()? onCreated,
}) async {
  await pumpProjectSetupApp(
    tester,
    open: (context) => ProjectResourceCreationDialogs.showCreateProject(
      context,
      workspaceId: kProjectSetupWorkspaceId,
      repository: FakeSessionProjectsRepository(setups),
      onProjectCreated: onProjectCreated,
      onCreated: onCreated,
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('2. Podstawy'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).first, name);
  await tester.pumpAndSettle();
  await tester.tap(find.text('7. Podsumowanie'));
  await tester.pumpAndSettle();
}

/// Sprawdza, że trwały banner pokazuje kod i `traceId` Backendu.
void _expectDiagnostics({required String code, required String traceId}) {
  expect(find.text('Nie udało się wykonać operacji'), findsOneWidget);
  expect(find.text('Kod: $code'), findsOneWidget);
  expect(find.text('Identyfikator śledzenia: $traceId'), findsOneWidget);
}

void main() {
  testWidgets(
    'błąd planu zostaje w podsumowaniu z kodem i traceId, kreator się nie zamyka',
    (tester) async {
      final setups = FakeProjectSetupsRepository(
        onPreview: (_) async => Left(
          projectSetupApiError(
            type: ApiErrorType.forbidden,
            statusCode: 403,
            message: 'Brak uprawnień do workspace.',
            apiCode: 'workspace_forbidden',
            traceId: 'trace-preview',
          ),
        ),
      );
      await _openSummary(tester, setups: setups);

      expect(tester.takeException(), isNull);
      _expectDiagnostics(code: 'workspace_forbidden', traceId: 'trace-preview');
      // Znany kod 403 ma własne zdanie, a nie komunikat serwera.
      expect(
        find.text('Nie masz uprawnień do utworzenia projektu w tym workspace.'),
        findsOneWidget,
      );
      expect(find.text('Ponów'), findsOneWidget);
      // Kreator nie zamknął się i nie zgubił draftu.
      expect(find.text('Nowy projekt'), findsOneWidget);
      await tester.tap(find.text('2. Podstawy'));
      await tester.pumpAndSettle();
      expect(find.text('Projekt z nazwą'), findsOneWidget);
      expect(setups.createRequests, isEmpty);
    },
  );

  testWidgets(
    'błąd walidacji Backendu jest globalny w podsumowaniu, a pola zostają lokalne',
    (tester) async {
      final setups = FakeProjectSetupsRepository(
        onCreate: (_, _) async => Left(
          projectSetupApiError(
            type: ApiErrorType.validation,
            statusCode: 422,
            message: 'Pole name jest nieprawidłowe.',
            apiCode: 'project_setup.validation_failed',
            traceId: 'trace-submit-422',
          ),
        ),
      );
      await _openSummary(tester, setups: setups);

      await tester.tap(find.text('Utwórz projekt'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      _expectDiagnostics(
        code: 'project_setup.validation_failed',
        traceId: 'trace-submit-422',
      );
      expect(
        find.text('Backend odrzucił dane kreatora. Popraw wskazane wartości.'),
        findsOneWidget,
      );
      // Błąd walidacji serwera nie tworzy lokalnego błędu pola: pola bez
      // zastrzeżeń kreatora nie są oznaczane na czerwono.
      expect(find.text('Wprowadź nazwę projektu.'), findsNothing);
      // Draft i krok zostają: użytkownik może poprawić dane i spróbować ponownie.
      expect(find.text('Nowy projekt'), findsOneWidget);
      expect(find.textContaining('Krok 7 z 7'), findsOneWidget);
      expect(find.text('Utwórz projekt'), findsOneWidget);
      expect(setups.createRequests, hasLength(1));
    },
  );

  testWidgets('błąd pola zostaje przy polu, a globalny w podsumowaniu', (
    tester,
  ) async {
    final setups = FakeProjectSetupsRepository();
    await _openSummary(tester, setups: setups);

    // Wracamy do kroku podstaw i czyścimy nazwę — błąd pola ma zostać przy
    // polu, a nie przenieść się do bannera.
    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();

    expect(find.text('Wprowadź nazwę projektu.'), findsOneWidget);
    expect(find.text('Nie udało się wykonać operacji'), findsNothing);
  });

  testWidgets('błąd submitowania nie zamyka kreatora, a sukces zamyka go i otwiera projekt', (
    tester,
  ) async {
    final created = <String>[];
    var generalNotifications = 0;
    var attempts = 0;
    final setups = FakeProjectSetupsRepository(
      onCreate: (request, key) async {
        attempts++;
        if (attempts == 1) {
          return Left(
            projectSetupApiError(
              type: ApiErrorType.server,
              statusCode: 503,
              message: 'Serwis chwilowo niedostępny.',
              apiCode: 'project_setup.unavailable',
              traceId: 'trace-submit-503',
            ),
          );
        }
        return Right(projectSetupCreation(projectId: 'project-42'));
      },
    );
    await _openSummary(
      tester,
      setups: setups,
      onProjectCreated: created.add,
      onCreated: () => generalNotifications++,
    );

    await tester.tap(find.text('Utwórz projekt'));
    await tester.pumpAndSettle();

    // Porażka: kreator zostaje otwarty, draft nietknięty, błąd jest trwały.
    expect(tester.takeException(), isNull);
    _expectDiagnostics(
      code: 'project_setup.unavailable',
      traceId: 'trace-submit-503',
    );
    expect(find.text('Serwis chwilowo niedostępny.'), findsOneWidget);
    expect(find.text('Nowy projekt'), findsOneWidget);
    expect(created, isEmpty);

    await tester.tap(find.text('Utwórz projekt'));
    await tester.pumpAndSettle();

    // Sukces: identyfikator pochodzi z odpowiedzi serwera, kreator się zamyka,
    // a aplikacja przechodzi do utworzonego projektu.
    expect(created, <String>['project-42']);
    expect(generalNotifications, 1);
    expect(find.text('Nowy projekt'), findsNothing);
    expect(find.text('$kProjectRouteKey:project-42'), findsOneWidget);
    expect(setups.createRequests, hasLength(2));
  });
}
