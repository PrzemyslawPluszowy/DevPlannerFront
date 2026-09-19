import 'package:dartz/dartz.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/automation_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/project_user_hub_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProjectsRepository extends Mock implements ProjectsRepository {}

class _MockWorkspacesRepository extends Mock implements WorkspacesRepository {}

class _MockCustomWorkflowRepository extends Mock
    implements CustomWorkflowRepository {}

class _MockTaskMetadataRepository extends Mock
    implements TaskMetadataRepository {}

class _MockMilestoneRepository extends Mock implements MilestoneRepository {}

class _MockAutomationRepository extends Mock implements AutomationRepository {}

class _MockProjectMemberProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}

class _MockTasksRepository extends Mock implements TasksRepository {}

class _MockProjectTemplatesRepository extends Mock
    implements ProjectTemplatesRepository {}

void main() {
  late _MockProjectsRepository projectsRepo;
  late _MockWorkspacesRepository workspacesRepo;
  late _MockCustomWorkflowRepository workflowRepo;
  late _MockTaskMetadataRepository metadataRepo;
  late _MockMilestoneRepository milestoneRepo;
  late _MockAutomationRepository automationRepo;
  late _MockProjectMemberProfilesRepository profilesRepo;
  late _MockTasksRepository tasksRepo;
  late _MockProjectTemplatesRepository templatesRepo;

  const project = ProjectListItem(
    id: 'proj-1',
    workspaceId: 'ws-1',
    name: 'Marketing Q3',
    description: 'Kampania Q3',
    myRole: ProjectRole.admin,
  );

  setUp(() {
    projectsRepo = _MockProjectsRepository();
    workspacesRepo = _MockWorkspacesRepository();
    workflowRepo = _MockCustomWorkflowRepository();
    metadataRepo = _MockTaskMetadataRepository();
    milestoneRepo = _MockMilestoneRepository();
    automationRepo = _MockAutomationRepository();
    profilesRepo = _MockProjectMemberProfilesRepository();
    tasksRepo = _MockTasksRepository();
    templatesRepo = _MockProjectTemplatesRepository();

    when(
      () => projectsRepo.getProject(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right(project));

    when(
      () => projectsRepo.listProjectMembers(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(() => workspacesRepo.listMembers(any()))
        .thenAnswer((_) async => const Right([]));

    when(
      () => workflowRepo.listStatuses(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => workflowRepo.listTemplates(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => metadataRepo.listLabels(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => metadataRepo.listCustomFields(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => milestoneRepo.listMilestones(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => automationRepo.listRules(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => automationRepo.getCatalog(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        AutomationCatalogResponse(
          triggers: [],
          conditions: [],
          actions: [],
        ),
      ),
    );

    when(() => templatesRepo.listTemplates(any())).thenAnswer(
      (_) async => Right([
        ProjectTemplateResponse(
          id: 'tmpl-1',
          name: 'Szablon Bazowy',
          updatedAtUtc: DateTime.now(),
          version: 1,
        ),
      ]),
    );

    when(
      () => templatesRepo.getTemplateDetails(
        workspaceId: any(named: 'workspaceId'),
        templateId: any(named: 'templateId'),
      ),
    ).thenAnswer(
      (_) async => Right(
        ProjectTemplateDetailsResponse(
          id: 'tmpl-1',
          name: 'Szablon Bazowy',
          status: 'Active',
          visibility: 'Shared',
          workflow: [],
          transitions: [],
          labels: [],
          customFields: [],
          tasks: [],
          updatedAtUtc: DateTime.now(),
          version: 1,
        ),
      ),
    );
  });

  Widget buildTestApp(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProjectsRepository>.value(value: projectsRepo),
        RepositoryProvider<WorkspacesRepository>.value(value: workspacesRepo),
        RepositoryProvider<CustomWorkflowRepository>.value(value: workflowRepo),
        RepositoryProvider<TaskMetadataRepository>.value(value: metadataRepo),
        RepositoryProvider<MilestoneRepository>.value(value: milestoneRepo),
        RepositoryProvider<AutomationRepository>.value(value: automationRepo),
        RepositoryProvider<ProjectMemberProfilesRepository>.value(
          value: profilesRepo,
        ),
        RepositoryProvider<TasksRepository>.value(value: tasksRepo),
        RepositoryProvider<ProjectTemplatesRepository>.value(
          value: templatesRepo,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pl'),
        home: Scaffold(
          body: Builder(
            builder: (ctx) => Center(
              child: child,
            ),
          ),
        ),
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
        () => projectsRepo.getProject(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      ).called(1);

      // Pozostałe Cubity i repozytoria NIE zostały wywołane
      verifyNever(
        () => workflowRepo.listStatuses(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      );
      verifyNever(
        () => milestoneRepo.listMilestones(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      );
      verifyNever(
        () => automationRepo.listRules(
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      );
      verifyNever(() => templatesRepo.listTemplates(any()));
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
