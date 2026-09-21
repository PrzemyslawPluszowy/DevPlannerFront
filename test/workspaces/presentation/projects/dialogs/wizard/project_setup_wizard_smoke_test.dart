import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/project_creation_wizard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Testy dymne wejść kreatora projektu.
///
/// Sidebar i drzewo projektów otwierają ten sam kreator, ale różnią się
/// sposobem przekazania portu projektów: sidebar wstrzykuje go jawnie, drzewo
/// polega na providerze kompozycji. Żadna z tych ścieżek nie może kończyć się
/// wyjątkiem — brak portu jest stanem „niedostępne” z jawnym powodem.
void main() {
  testWidgets(
    'sidebar otwiera kreator z jawnym portem projektów i bez providerów opcjonalnych',
    (tester) async {
      final setups = FakeProjectSetupsRepository();
      final session = FakeSessionProjectsRepository(setups);

      await pumpProjectSetupApp(
        tester,
        open: (context) => ProjectResourceCreationDialogs.showCreateProject(
          context,
          workspaceId: kProjectSetupWorkspaceId,
          repository: session,
          onCreated: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProjectCreationWizard), findsOneWidget);
      expect(find.text('Nowy projekt'), findsOneWidget);
      expect(find.textContaining('Krok 1 z 7'), findsOneWidget);
      // Kreator nie ma portu szablonów ani członków, a mimo to pokazuje pełny
      // krok startu: brak portu jest jawnym powodem, nie brakiem treści.
      expect(
        findInControls('Nie możemy teraz pobrać szablonów projektów.'),
        findsOneWidget,
      );
      // Powód mówi, co użytkownik może zrobić, a nie jakiej klasy brakuje
      // w kompozycji aplikacji.
      expect(
        findInControls(
          'Spróbuj ponownie za chwilę. Jeśli problem się powtórzy, '
          'zgłoś go administratorowi.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('portu'), findsNothing);
      expect(findInControls('Pusty projekt'), findsOneWidget);
      expect(setups.previewRequests, isEmpty);
      expect(setups.createRequests, isEmpty);
    },
  );

  testWidgets(
    'drzewo bez portu projektów pokazuje jawny powód zamiast ProviderNotFoundException',
    (tester) async {
      // Wejście drzewa projektów nie przekazuje portu, a kompozycja bez
      // transportu standalone nie ma providera. Kreator musi pokazać stan
      // „niedostępne”, a nie wyjątek z przycisku `+`.
      await pumpProjectSetupApp(
        tester,
        open: (context) => ProjectResourceCreationDialogs.showCreateProject(
          context,
          workspaceId: kProjectSetupWorkspaceId,
          onCreated: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProjectCreationWizard), findsNothing);
      expect(find.text('Nowy projekt'), findsOneWidget);
      expect(
        find.text(
          'Tworzenie projektu nie jest teraz dostępne. Spróbuj ponownie '
          'za chwilę; jeśli problem się powtórzy, zgłoś go administratorowi.',
        ),
        findsOneWidget,
      );
      expect(find.text('Anuluj'), findsOneWidget);
    },
  );

  testWidgets('krok startu bez portu szablonów pokazuje powód zamiast kart', (
    tester,
  ) async {
    await pumpProjectSetupApp(
      tester,
      open: (context) => ProjectResourceCreationDialogs.showCreateProject(
        context,
        workspaceId: kProjectSetupWorkspaceId,
        repository: FakeSessionProjectsRepository(
          FakeProjectSetupsRepository(),
        ),
        onCreated: () {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('3. Dostęp'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Krok 3 z 7'), findsOneWidget);
    // Krok dostępu bez portu członków jest jawnie niedostępny z powodem.
    expect(
      findInControls('Nie możemy teraz pobrać listy członków workspace.'),
      findsOneWidget,
    );
    expect(find.textContaining('portu'), findsNothing);
    expect(findInControls('Dla wszystkich w workspace'), findsOneWidget);
    expect(findInControls('Prywatny'), findsOneWidget);
  });

  testWidgets(
    'krok sposobu pracy bez znanej roli pokazuje powód zamiast kontrolki pojemności',
    (tester) async {
      await pumpProjectSetupApp(
        tester,
        open: (context) => ProjectResourceCreationDialogs.showCreateProject(
          context,
          workspaceId: kProjectSetupWorkspaceId,
          repository: FakeSessionProjectsRepository(
            FakeProjectSetupsRepository(),
          ),
          onCreated: () {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('5. Sposób pracy'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Krok 5 z 7'), findsOneWidget);
      // Bez portu członków i sesji rola jest nieznana, więc zapis pojemności
      // jest wyłączony z jawnym powodem zamiast pokazywać kontrolkę bez skutku.
      expect(
        find.text(
          'Zmiana pojemności wymaga roli Admin albo Owner w workspace.',
        ),
        findsOneWidget,
      );
      expect(find.text('Minuty na dzień'), findsNothing);
      expect(find.byType(TextField), findsNothing);
    },
  );

  testWidgets(
    'krok dostępu z portem członków i bez portu sesji renderuje listę',
    (
      tester,
    ) async {
      await pumpProjectSetupApp(
        tester,
        open: (context) => ProjectResourceCreationDialogs.showCreateProject(
          context,
          workspaceId: kProjectSetupWorkspaceId,
          repository: FakeSessionProjectsRepository(
            FakeProjectSetupsRepository(),
          ),
          membersRepository: FakeWorkspaceMembersRepository(
            members: <WorkspaceMemberResponse>[
              workspaceMember(userId: 'user-aaaaaaaa'),
              workspaceMember(
                userId: 'user-bbbbbbbb',
                role: WorkspaceRole.admin,
              ),
            ],
          ),
          onCreated: () {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('3. Dostęp'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Brak portu sesji nie blokuje kroku: wiersz twórcy pokazuje samą plakietkę.
      expect(find.text('Ty — Owner'), findsOneWidget);
      expect(find.text('Użytkownik (user-aaa…)'), findsOneWidget);
      expect(find.text('Użytkownik (user-bbb…)'), findsOneWidget);
    },
  );
}
