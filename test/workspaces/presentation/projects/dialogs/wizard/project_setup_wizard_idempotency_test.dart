import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Wzorzec UUID w wersji 4, którego wymaga Backend dla klucza idempotencji.
final RegExp _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

/// Otwiera kreator i prowadzi draft do podsumowania z wpisaną nazwą.
Future<void> _openSummary(
  WidgetTester tester, {
  required FakeProjectSetupsRepository setups,
  FakeProjectTemplatesRepository? templates,
  String name = 'Projekt z nazwą',
  List<String>? created,
}) async {
  await pumpProjectSetupApp(
    tester,
    open: (context) => ProjectResourceCreationDialogs.showCreateProject(
      context,
      workspaceId: kProjectSetupWorkspaceId,
      repository: FakeSessionProjectsRepository(setups),
      templatesRepository: templates,
      onProjectCreated: created?.add,
      onCreated: () {},
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

/// Czeka na zakończenie operacji w tle bez `pumpAndSettle`, które nie kończy
/// się przy pasku postępu `submitting` animowanym w nieskończoność.
Future<void> _settleAfterCompletion(WidgetTester tester) => tester.pumpAndSettle();

void main() {
  testWidgets('podwójne kliknięcie Utwórz wysyła jedno żądanie i jeden klucz', (
    tester,
  ) async {
    final completion =
        Completer<Either<ApiError, ProjectSetupCreation>>();
    final created = <String>[];
    final setups = FakeProjectSetupsRepository(
      onCreate: (_, _) => completion.future,
    );
    await _openSummary(tester, setups: setups, created: created);

    final button = find.text('Utwórz projekt');
    // Dwa kliknięcia bez klatki pomiędzy nimi: pierwsze przechodzi w stan
    // `submitting`, drugie nie może wysłać kolejnego żądania.
    await tester.tap(button);
    await tester.tap(button, warnIfMissed: false);
    await tester.pump();

    expect(setups.createRequests, hasLength(1));
    expect(setups.idempotencyKeys.single, matches(_uuidV4));
    // Przycisk jest jawnie zablokowany, dopóki trwa tworzenie projektu.
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Tworzenie projektu…'),
          )
          .onPressed,
      isNull,
    );
    expect(created, isEmpty);

    completion.complete(Right(projectSetupCreation(projectId: 'project-7')));
    await _settleAfterCompletion(tester);

    expect(setups.createRequests, hasLength(1));
    expect(created, <String>['project-7']);
    expect(find.text('$kProjectRouteKey:project-7'), findsOneWidget);
  });

  testWidgets('ponowienie po timeoucie używa tego samego klucza idempotencji', (
    tester,
  ) async {
    var attempts = 0;
    final setups = FakeProjectSetupsRepository(
      onCreate: (_, _) async {
        attempts++;
        if (attempts == 1) {
          return Left(
            projectSetupApiError(
              type: ApiErrorType.receiveTimeout,
              message: 'Serwer zbyt długo zwracał odpowiedź.',
              apiCode: 'project_setup.timeout',
              traceId: 'trace-timeout',
            ),
          );
        }
        return Right(projectSetupCreation(projectId: 'project-timeout'));
      },
    );
    await _openSummary(tester, setups: setups);

    await tester.tap(find.text('Utwórz projekt'));
    await tester.pumpAndSettle();

    // Timeout nie dowodzi, że serwer nie wykonał operacji, więc ponowienie
    // musi użyć tego samego klucza — inaczej powstałby drugi projekt.
    expect(find.text('Serwer zbyt długo zwracał odpowiedź.'), findsOneWidget);
    expect(find.text('Kod: project_setup.timeout'), findsOneWidget);
    expect(find.text('Identyfikator śledzenia: trace-timeout'), findsOneWidget);
    expect(find.text('Nowy projekt'), findsOneWidget);

    await tester.tap(find.text('Ponów'));
    await tester.pumpAndSettle();

    expect(setups.idempotencyKeys, hasLength(2));
    expect(setups.idempotencyKeys[0], setups.idempotencyKeys[1]);
    expect(setups.createRequests[0].project.name, 'Projekt z nazwą');
    expect(
      setups.createRequests[1].project.name,
      setups.createRequests[0].project.name,
    );
    // Wynik operacji jest sprawdzany: odpowiedź serwera zamyka kreator.
    expect(find.text('$kProjectRouteKey:project-timeout'), findsOneWidget);
  });

  testWidgets('konflikt klucza 409 jest trwałym błędem i wymienia klucz', (
    tester,
  ) async {
    var attempts = 0;
    final setups = FakeProjectSetupsRepository(
      onCreate: (_, _) async {
        attempts++;
        if (attempts == 1) {
          return Left(
            projectSetupApiError(
              type: ApiErrorType.conflict,
              statusCode: 409,
              message: 'Klucz należy do innego żądania.',
              apiCode: 'project_setup.idempotency_key_conflict',
              traceId: 'trace-409-key',
            ),
          );
        }
        return Right(projectSetupCreation(projectId: 'project-409'));
      },
    );
    await _openSummary(tester, setups: setups);

    await tester.tap(find.text('Utwórz projekt'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Ten klucz operacji został już użyty dla innego żądania. '
        'Kolejna próba użyje nowego klucza.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Kod: project_setup.idempotency_key_conflict'),
      findsOneWidget,
    );
    expect(find.text('Identyfikator śledzenia: trace-409-key'), findsOneWidget);
    expect(find.text('Nowy projekt'), findsOneWidget);

    await tester.tap(find.text('Ponów'));
    await tester.pumpAndSettle();

    expect(setups.idempotencyKeys, hasLength(2));
    // Backend dowiódł, że klucz należy do innego żądania, więc kolejna próba
    // musi dostać nowy klucz; ciało żądania zostaje bez zmian.
    expect(setups.idempotencyKeys[0], isNot(setups.idempotencyKeys[1]));
    expect(setups.idempotencyKeys[1], matches(_uuidV4));
    expect(
      setups.createRequests[1].project.name,
      setups.createRequests[0].project.name,
    );
    expect(find.text('$kProjectRouteKey:project-409'), findsOneWidget);
  });

  testWidgets('konflikt wersji szablonu 409 jest trwały i odświeża snapshot', (
    tester,
  ) async {
    var attempts = 0;
    var detailReads = 0;
    final templates = FakeProjectTemplatesRepository(
      templates: <ProjectTemplateResponse>[projectTemplate(version: 5)],
      details: projectTemplateDetails(version: 5),
      onDetails: (templateId) async {
        // Po konflikcie Backend zwraca nowszą wersję szablonu; kreator musi
        // pobrać ją ponownie, żeby ponowienie niosło właściwą oczekiwaną wersję.
        detailReads++;
        return Right(projectTemplateDetails(version: detailReads > 1 ? 8 : 5));
      },
    );
    final setups = FakeProjectSetupsRepository(
      onPreview: (request) async =>
          Right(projectSetupPlan(templateName: 'Szablon startowy')),
      onCreate: (request, _) async {
        attempts++;
        if (attempts == 1) {
          return Left(
            projectSetupApiError(
              type: ApiErrorType.conflict,
              statusCode: 409,
              message: 'Szablon zmienił się.',
              apiCode: 'project_setup.template_version_conflict',
              traceId: 'trace-409-template',
            ),
          );
        }
        return Right(projectSetupCreation(projectId: 'project-template'));
      },
    );
    await pumpProjectSetupApp(
      tester,
      open: (context) => ProjectResourceCreationDialogs.showCreateProject(
        context,
        workspaceId: kProjectSetupWorkspaceId,
        repository: FakeSessionProjectsRepository(setups),
        templatesRepository: templates,
        onCreated: () {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Szablon startowy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Projekt z szablonu');
    await tester.pumpAndSettle();
    await tester.tap(find.text('7. Podsumowanie'));
    await tester.pumpAndSettle();
    expect(setups.previewRequests.single.source.expectedVersion, 5);

    await tester.tap(find.text('Utwórz projekt'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Szablon projektu zmienił się w innej sesji. Podgląd szablonu został '
        'odświeżony — sprawdź podsumowanie i spróbuj ponownie.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Kod: project_setup.template_version_conflict'),
      findsOneWidget,
    );
    expect(find.text('Nowy projekt'), findsOneWidget);
    // Podgląd został pobrany ponownie, a draft niesie już nową wersję szablonu.
    expect(templates.detailsRequests, hasLength(2));
    expect(setups.createRequests, hasLength(1));

    await tester.tap(find.text('Ponów'));
    await tester.pumpAndSettle();

    expect(setups.createRequests, hasLength(2));
    expect(setups.createRequests[1].source.expectedVersion, 8);
    expect(setups.idempotencyKeys[0], setups.idempotencyKeys[1]);
    expect(find.text('$kProjectRouteKey:project-template'), findsOneWidget);
  });
}
