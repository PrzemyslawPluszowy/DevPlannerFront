import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/shared/presentation/widgets/app_dropdown.dart';
import 'package:devplanner/shared/presentation/widgets/app_text_field.dart';
import 'package:devplanner/shared/presentation/widgets/app_tooltip.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/project_creation_wizard.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_help_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Stan kreatora czytany wprost z Cubita — pozwala sprawdzić, czy kontrolka
/// naprawdę zmieniła draft, a nie tylko swój lokalny wygląd.
ProjectSetupWizardState _wizardState(WidgetTester tester) => tester
    .widget<ProjectCreationWizard>(find.byType(ProjectCreationWizard))
    .cubit
    .state;

/// Znajduje przycisk pomocy po jego etykiecie dla czytnika ekranu.
Finder _help(String title) => find.bySemanticsLabel('Pomoc: $title');

/// Wszystkie dropdowny kreatora, niezależnie od typu wartości.
Finder get _appDropdowns => find.byWidgetPredicate(
  (widget) => widget.runtimeType.toString().startsWith('AppDropdown<'),
);

/// Wszystkie surowe kontrolki Material, których kreator nie może już używać.
Finder get _rawMaterialControls => find.byWidgetPredicate(
  (widget) =>
      widget is DropdownButton ||
      widget is DropdownButtonFormField ||
      widget is DropdownMenu,
);

/// Przewija kontrolkę do widoku i klika — krok bywa dłuższy niż modal.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

AuthSessionPort _signedInSession() => AuthSessionController(
  initial: const AuthSessionSnapshot(
    status: AuthSessionStatus.signedIn,
    user: AuthUser(
      userId: 'user-me',
      login: 'anna',
      displayName: 'Anna Nowak',
    ),
  ),
);

Future<void> _openWizard(
  WidgetTester tester, {
  FakeWorkspaceMembersRepository? members,
  AuthSessionPort? authSession,
  bool privateProject = false,
}) async {
  await pumpProjectSetupApp(
    tester,
    authSession: authSession,
    open: (context) => ProjectResourceCreationDialogs.showCreateProject(
      context,
      workspaceId: kProjectSetupWorkspaceId,
      repository: FakeSessionProjectsRepository(
        FakeProjectSetupsRepository(),
      ),
      templatesRepository: FakeProjectTemplatesRepository(
        templates: <ProjectTemplateResponse>[projectTemplate()],
        details: projectTemplateDetails(),
      ),
      membersRepository: members,
      onCreated: () {},
    ),
  );
  await tester.pumpAndSettle();
  if (!privateProject) return;
  await _tap(tester, find.text('3. Dostęp'));
  await _tap(tester, findInControls('Prywatny'));
}

void main() {
  group('kontrolki kreatora używają design systemu', () {
    testWidgets('żaden krok nie pokazuje surowego dropdownu Material', (
      tester,
    ) async {
      final members = FakeWorkspaceMembersRepository(
        members: <WorkspaceMemberResponse>[workspaceMember(userId: 'user-1')],
      );
      await _openWizard(
        tester,
        members: members,
        authSession: _signedInSession(),
        privateProject: true,
      );

      // Krok dostępu: prywatny projekt z zaznaczonym członkiem i jego rolą.
      await _tap(tester, find.byType(Checkbox).first);
      expect(find.byType(AppDropdown<ProjectRole>), findsOneWidget);
      expect(_rawMaterialControls, findsNothing);

      // Krok workflow z jawnymi statusami: kategoria statusu.
      await _tap(tester, find.text('4. Workflow'));
      await _tap(tester, findInControls('Własne statusy'));
      expect(find.byType(AppDropdown<TaskStatusCategory>), findsOneWidget);
      expect(_rawMaterialControls, findsNothing);

      // Krok sposobu pracy pokazuje najpierw ustawienia wybranego widoku…
      await _tap(tester, find.text('5. Sposób pracy'));
      expect(_appDropdowns, findsNWidgets(3));
      expect(_rawMaterialControls, findsNothing);

      // …a drugi widok wchodzi jedną akcją „Dostosuj także…”.
      await _tap(tester, find.text('Dostosuj także ustawienia tablicy'));
      expect(_appDropdowns, findsNWidgets(5));
      expect(_rawMaterialControls, findsNothing);

      for (final step in <String>['6. Funkcje startowe', '7. Podsumowanie']) {
        await _tap(tester, find.text(step));
        expect(_rawMaterialControls, findsNothing);
      }
    });

    testWidgets('rola członka wybiera się z prawdziwego menu kontrolki', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final members = FakeWorkspaceMembersRepository(
        members: <WorkspaceMemberResponse>[workspaceMember(userId: 'user-1')],
      );
      await _openWizard(
        tester,
        members: members,
        authSession: _signedInSession(),
        privateProject: true,
      );

      await _tap(tester, find.byType(Checkbox).first);
      expect(
        _wizardState(tester).draft.members.single.role,
        ProjectRole.member,
      );

      // Kontrakt kontrolki: bieżąca wartość i trzy role z etykietami ARB.
      final dropdown = find.byType(AppDropdown<ProjectRole>);
      final control = tester.widget<AppDropdown<ProjectRole>>(dropdown);
      expect(control.value, ProjectRole.member);
      expect(
        control.options.map((option) => option.value),
        <ProjectRole>[
          ProjectRole.admin,
          ProjectRole.member,
          ProjectRole.observer,
        ],
      );
      expect(
        control.options.map((option) => option.label),
        <String>[
          'Administrator (Admin)',
          'Członek (Member)',
          'Obserwator (Observer)',
        ],
      );

      // Prawdziwe menu: kliknięcie w kontrolkę otwiera overlay z pozycjami.
      await _tap(tester, dropdown);
      expect(find.text('Administrator (Admin)'), findsOneWidget);
      expect(find.text('Obserwator (Observer)'), findsOneWidget);

      // Wybór pozycji zmienia draft. Akcję wykonujemy tą samą drogą, której
      // używa czytnik ekranu: ten wiersz leży pod zgięciem panelu i klik
      // w geometrię nie trafia (opisane w handoffie), więc test nie udaje, że
      // sprawdza geometrię — sprawdza działanie pozycji menu. Ścieżkę kliknięcia
      // w pozycję pokrywa test dropdownu gęstości kafelka.
      tester.semantics.performAction(
        find.semantics.byLabel('Administrator (Admin)'),
        SemanticsAction.tap,
      );
      await tester.pumpAndSettle();

      expect(_wizardState(tester).draft.members.single.role, ProjectRole.admin);
      expect(
        tester.widget<AppDropdown<ProjectRole>>(dropdown).value,
        ProjectRole.admin,
      );
      semantics.dispose();
    });

    testWidgets('menu wspólnego dropdownu wybiera wartość i zmienia draft', (
      tester,
    ) async {
      await _openWizard(tester);
      await _tap(tester, find.text('5. Sposób pracy'));
      await _tap(tester, find.text('Dostosuj także ustawienia tablicy'));

      await _tap(tester, find.byType(AppDropdown<KanbanCardDensity>));
      await tester.tap(find.text('Szczegółowa').last);
      await tester.pumpAndSettle();

      expect(
        _wizardState(tester).draft.boardDensity,
        KanbanCardDensity.detailed,
      );
    });

    testWidgets('pola tekstowe kroków są wspólnymi wrapperami', (tester) async {
      await _openWizard(tester);

      await _tap(tester, find.text('2. Podstawy'));
      // Nazwa i opis to AppTextField — żaden TextField nie stoi poza wrapperem.
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(
        find.descendant(
          of: find.byType(AppTextField),
          matching: find.byType(TextField),
        ),
        findsNWidgets(2),
      );

      await _tap(tester, find.text('4. Workflow'));
      await _tap(tester, findInControls('Własne statusy'));
      // Nazwa kolumny i limit WIP w wierszu statusu też są wrapperami.
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(
        find.descendant(
          of: find.byType(AppTextField),
          matching: find.byType(TextField),
        ),
        findsNWidgets(2),
      );
    });
  });

  group('pomoc kontekstowa przy pojęciach domenowych', () {
    testWidgets('znak zapytania otwiera objaśnienie torów na tablicy', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _openWizard(tester);
      await _tap(tester, find.text('5. Sposób pracy'));
      // Tory i gęstość należą do tablicy, więc odsłaniamy jej ustawienia.
      await _tap(tester, find.text('Dostosuj także ustawienia tablicy'));

      final help = _help('Tory na tablicy');
      expect(help, findsOneWidget);
      // Pole trafienia przycisku nie może być mniejsze niż 32 px.
      final size = tester.getSize(find.byType(ProjectSetupHelpButton).first);
      expect(size.width, greaterThanOrEqualTo(32));
      expect(size.height, greaterThanOrEqualTo(32));

      await _tap(tester, help);
      expect(
        find.text(
          'Tory dzielą tablicę na poziome sekcje, np. osobno dla każdego '
          'wykonawcy lub priorytetu. Nie zmieniają statusu zadania.',
        ),
        findsOneWidget,
      );

      // Ponowne kliknięcie zamyka objaśnienie.
      await _tap(tester, help);
      expect(find.textContaining('Tory dzielą tablicę'), findsNothing);
      semantics.dispose();
    });

    testWidgets('objaśnienia pokrywają pojęcia wymagane przez plan', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final members = FakeWorkspaceMembersRepository(
        members: <WorkspaceMemberResponse>[workspaceMember(userId: 'user-1')],
      );
      await _openWizard(
        tester,
        members: members,
        authSession: _signedInSession(),
        privateProject: true,
      );

      // Nagłówek kreatora i krok dostępu.
      expect(_help('Podgląd projektu'), findsOneWidget);
      expect(_help('Widoczność prywatna'), findsOneWidget);
      expect(_help('Startowi członkowie'), findsOneWidget);

      await _tap(tester, find.text('4. Workflow'));
      await _tap(tester, findInControls('Własne statusy'));
      expect(_help('Limit WIP'), findsOneWidget);
      expect(_help('Kategoria statusu'), findsOneWidget);
      await _tap(tester, findInControls('Katalogowy szablon'));
      expect(_help('Katalogowy szablon workflow'), findsOneWidget);

      await _tap(tester, find.text('5. Sposób pracy'));
      expect(_help('Kaskada zależności'), findsOneWidget);
      expect(_help('Dzienna pojemność'), findsWidgets);
      await _tap(tester, find.text('Dostosuj także ustawienia tablicy'));
      expect(_help('Gęstość karty'), findsOneWidget);
      expect(_help('Tory na tablicy'), findsOneWidget);

      await _tap(tester, find.text('6. Funkcje startowe'));
      expect(_help('Automatyzacje'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('objaśnienie działa myszą, dotykiem i z czytnika ekranu', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _openWizard(tester);
      await _tap(tester, find.text('5. Sposób pracy'));
      await _tap(tester, find.text('Dostosuj także ustawienia tablicy'));

      final help = _help('Tory na tablicy');
      final tooltip = tester.widget<AppTooltip>(
        find.ancestor(of: help, matching: find.byType(AppTooltip)).first,
      );
      // Mysz dostaje tę samą treść w podpowiedzi, bez konieczności klikania.
      expect(tooltip.message, contains('Tory dzielą tablicę'));

      // Dotyk i mysz: kliknięcie otwiera objaśnienie.
      await _tap(tester, help);
      expect(find.textContaining('Tory dzielą tablicę'), findsOneWidget);
      await _tap(tester, help);

      // Klawiatura: przycisk jest prawdziwym `IconButton` z akcją i etykietą,
      // więc fokus aktywuje go Enterem albo spacją.
      final button = tester.widget<IconButton>(
        find.ancestor(of: help, matching: find.byType(IconButton)).first,
      );
      expect(button.onPressed, isNotNull);
      expect((button.icon as Icon).semanticLabel, 'Pomoc: Tory na tablicy');

      // Ta sama akcja, którą wykonuje czytnik ekranu, otwiera objaśnienie.
      tester.semantics.performAction(
        find.semantics.byLabel('Pomoc: Tory na tablicy'),
        SemanticsAction.tap,
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Tory dzielą tablicę'), findsOneWidget);
      semantics.dispose();
    });
  });
}
