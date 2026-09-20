import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Otwiera kreator z wstrzykniętym katalogiem szablonów.
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

void main() {
  testWidgets('karty szablonów pokazują dane z katalogu i z podglądu', (
    tester,
  ) async {
    final templates = FakeProjectTemplatesRepository(
      templates: <ProjectTemplateResponse>[
        projectTemplate(),
        projectTemplate(id: 'template-2', name: 'Marketing', version: 7),
      ],
      details: projectTemplateDetails(
        description: 'Opis z podglądu',
        version: 9,
        taskCount: 6,
        labelCount: 3,
        customFieldCount: 2,
        customStatusCount: 7,
      ),
    );
    await _openWizard(tester, templates: templates);

    expect(tester.takeException(), isNull);
    // Karty pokazują dane katalogu jeszcze przed pobraniem podglądu.
    expect(find.text('Szablon startowy'), findsOneWidget);
    expect(find.text('Marketing'), findsOneWidget);
    expect(find.text('Wersja 3'), findsOneWidget);
    expect(find.text('Wersja 7'), findsOneWidget);
    // Karta, której podglądu nie pobrano, nie ogłasza porażki.
    expect(find.text('Nie udało się pobrać podglądu szablonu.'), findsNothing);
    expect(templates.detailsRequests, isEmpty);

    await tester.tap(find.text('Szablon startowy'));
    await tester.pumpAndSettle();

    expect(templates.detailsRequests, <String>['template-1']);
    expect(find.text('Opis z podglądu'), findsOneWidget);
    expect(find.text('Zadania: 6'), findsOneWidget);
    expect(find.text('Etykiety: 3'), findsOneWidget);
    expect(find.text('Pola: 2'), findsOneWidget);
    expect(find.text('Własne statusy: 7'), findsOneWidget);
    // Liczby i wersja pochodzą z podglądu, a nie z wpisu katalogu.
    expect(find.text('Wersja 9'), findsOneWidget);
    expect(find.text('Wersja 3'), findsNothing);
  });

  testWidgets('podgląd szablonu jest pamiętany per templateId', (tester) async {
    final templates = FakeProjectTemplatesRepository(
      templates: <ProjectTemplateResponse>[
        projectTemplate(),
        projectTemplate(id: 'template-2', name: 'Marketing', version: 7),
      ],
      details: projectTemplateDetails(),
    );
    await _openWizard(tester, templates: templates);

    await tester.tap(find.text('Szablon startowy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2. Podstawy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1. Sposób startu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Szablon startowy'));
    await tester.pumpAndSettle();

    // Powrót do tego samego szablonu nie pobiera podglądu drugi raz, więc karta
    // nie miga skeletonem.
    expect(templates.detailsRequests, <String>['template-1']);
    await tester.tap(find.text('Marketing'));
    await tester.pumpAndSettle();
    expect(templates.detailsRequests, <String>['template-1', 'template-2']);
  });

  testWidgets('błąd podglądu pokazuje tylko karta, której dotyczy', (
    tester,
  ) async {
    final templates = FakeProjectTemplatesRepository(
      templates: <ProjectTemplateResponse>[
        projectTemplate(),
        projectTemplate(id: 'template-2', name: 'Marketing', version: 7),
      ],
      onDetails: (templateId) async {
        if (templateId == 'template-1') {
          return Left(
            projectSetupApiError(
              message: 'Podgląd szablonu jest chwilowo niedostępny.',
              statusCode: 503,
            ),
          );
        }
        return Right(projectTemplateDetails(id: templateId));
      },
    );
    await _openWizard(tester, templates: templates);

    await tester.tap(find.text('Szablon startowy'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.text('Podgląd szablonu jest chwilowo niedostępny.'),
      findsOneWidget,
    );
    // Wybór szablonu nadal działa, a krok się nie wywraca.
    expect(find.text('Marketing'), findsOneWidget);
    expect(find.text('Wersja 7'), findsOneWidget);
  });

  testWidgets('błąd katalogu pokazuje powód i pozwala ponowić pobranie', (
    tester,
  ) async {
    final templates = FakeProjectTemplatesRepository(
      listError: projectSetupApiError(
        message: 'Katalog szablonów jest niedostępny.',
        statusCode: 503,
      ),
    );
    await _openWizard(tester, templates: templates);

    expect(tester.takeException(), isNull);
    expect(find.text('Katalog szablonów jest niedostępny.'), findsOneWidget);
    expect(find.text('Ponów pobieranie szablonów'), findsOneWidget);

    templates.listError = null;
    templates.templates = <ProjectTemplateResponse>[
      projectTemplate(name: 'Szablon po ponowieniu'),
    ];
    await tester.tap(find.text('Ponów pobieranie szablonów'));
    await tester.pumpAndSettle();

    expect(find.text('Szablon po ponowieniu'), findsOneWidget);
  });

  testWidgets('pusty katalog nie wywraca kroku startu', (tester) async {
    await _openWizard(
      tester,
      templates: FakeProjectTemplatesRepository(),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.text('W tym workspace nie ma jeszcze szablonów projektów.'),
      findsOneWidget,
    );
    expect(find.text('Pusty projekt'), findsOneWidget);
  });
}
