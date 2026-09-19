import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/project_user_hub_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/project_settings_fixture.dart';

void main() {
  const project = ProjectListItem(
    id: 'proj-1',
    workspaceId: 'ws-1',
    name: 'Marketing Q3',
    description: 'Kampania Q3',
    myRole: ProjectRole.admin,
  );

  late ProjectSettingsFixture ports;

  setUp(() {
    ports = ProjectSettingsFixture(project: project);
  });

  /// Montuje porty wewnątrz trasy, czyli dokładnie tak, jak robi to aktywny
  /// Tasks. Modal na root navigatorze nie jest potomkiem tej trasy, więc każdy
  /// port musi dostać jawnie, a nie przez `context.read` z własnego kontekstu.
  Widget buildTestApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pl'),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ProjectsRepository>.value(value: ports.projects),
          RepositoryProvider<ProjectSettingsComposition>.value(
            value: ports.composition,
          ),
        ],
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets(
    'ProjectUserHubModal otwiera się i renderuje profil oraz preferencje',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => ProjectUserHubDialogs.show(
                context: ctx,
                project: project,
                userRole: ProjectRole.admin,
              ),
              child: const Text('Open User Hub'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open User Hub'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Moje Centrum Projektu'), findsOneWidget);
      expect(find.text('Mój Profil'), findsOneWidget);
      expect(find.text('Moje Preferencje'), findsOneWidget);
      expect(find.text('Administrator (Admin)'), findsOneWidget);

      // Przejście do zakładki Preferencje
      await tester.tap(find.text('Moje Preferencje'));
      await tester.pumpAndSettle();

      expect(find.text('Przypnij do ulubionych'), findsOneWidget);
      expect(find.text('Ukryj projekt w bocznym menu'), findsOneWidget);
    },
  );

  testWidgets(
    'ProjectSettingsModal otwiera się i zawiera zakładkę Szablony Projektu',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => ProjectSettingsDialogs.show(
                context: ctx,
                project: project,
                userRole: ProjectRole.admin,
              ),
              child: const Text('Open Settings'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Ustawienia projektu'), findsOneWidget);
      expect(find.text('Szablony Projektu'), findsOneWidget);

      // Przejście do zakładki Szablony Projektu
      await tester.tap(find.text('Szablony Projektu'));
      await tester.pumpAndSettle();

      expect(find.text('Szablony projektów'), findsOneWidget);
      expect(find.text('Szablon Bazowy'), findsOneWidget);
      expect(find.text('Zapisz projekt jako szablon'), findsOneWidget);
      expect(find.text('Utwórz projekt z szablonu'), findsOneWidget);
    },
  );

  testWidgets(
    'ProjectSettingsModal wykonuje lazy loading - nie pobiera innych zakładek na starcie',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => ProjectSettingsDialogs.show(
                context: ctx,
                project: project,
                userRole: ProjectRole.admin,
              ),
              child: const Text('Open Settings'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();

      // Aktywna zakładka to Ogólne - projectsRepo.getProject zostało wywołane
      verify(
        () => ports.projects.getProject(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      ).called(1);

      // Pozostałe Cubity i repozytoria NIE zostały wywołane
      verifyNever(
        () => ports.customWorkflow.listStatuses(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      );
      verifyNever(
        () => ports.milestones.listMilestones(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      );
      verifyNever(
        () => ports.automations.listRules(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      );
      verifyNever(() => ports.projectTemplates.listTemplates(any()));
    },
  );

  testWidgets(
    'ProjectSettingsModal ukrywa akcje mutujące szablony dla roli bez uprawnień zarządzania',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestApp(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => ProjectSettingsDialogs.show(
                context: ctx,
                project: project,
                userRole: ProjectRole.member,
                initialTab: ProjectSettingsTab.templates,
              ),
              child: const Text('Open Settings As Member'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Settings As Member'));
      await tester.pumpAndSettle();

      // Zakładka szablonów jest widoczna
      expect(find.text('Szablony projektów'), findsOneWidget);
      // Ale przycisk zapisu jako szablon jest ukryty dla Membera
      expect(find.text('Zapisz projekt jako szablon'), findsNothing);
      // Akcja tworzenia projektu z szablonu jest ukryta dla Membera
      expect(find.text('Utwórz projekt z szablonu'), findsNothing);
    },
  );
}
