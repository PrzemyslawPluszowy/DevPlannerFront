import 'package:dartz/dartz.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
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
import 'package:mocktail/mocktail.dart';

/// Współdzielony fixture portów centrum ustawień projektu.
///
/// Trasa Tasks i modal ustawień muszą używać tego samego, hermetycznego grafu
/// portów, żeby kontrakt otwierania ustawień był sprawdzany na realnej
/// kompozycji, a nie na atrapie ekranu.
final class ProjectSettingsFixture {
  ProjectSettingsFixture({this.project = defaultProject}) {
    _stubRepositories();
  }

  /// Projekt używany przez zakładki, gdy test nie poda własnego.
  static const defaultProject = ProjectListItem(
    id: 'project-1',
    workspaceId: 'workspace-1',
    name: 'Marketing Q3',
    description: 'Kampania Q3',
  );

  final ProjectListItem project;

  final _MockProjectsRepository projects = _MockProjectsRepository();
  final _MockWorkspacesRepository workspaces = _MockWorkspacesRepository();
  final _MockProjectTemplatesRepository projectTemplates =
      _MockProjectTemplatesRepository();
  final _MockCustomWorkflowRepository customWorkflow =
      _MockCustomWorkflowRepository();
  final _MockTaskMetadataRepository taskMetadata =
      _MockTaskMetadataRepository();
  final _MockMilestoneRepository milestones = _MockMilestoneRepository();
  final _MockAutomationRepository automations = _MockAutomationRepository();
  final _MockTasksRepository tasks = _MockTasksRepository();
  final _MockProjectMemberProfilesRepository memberProfiles =
      _MockProjectMemberProfilesRepository();

  ProjectSettingsComposition get composition => ProjectSettingsComposition(
    projects: projects,
    workspaces: workspaces,
    projectTemplates: projectTemplates,
    customWorkflow: customWorkflow,
    taskMetadata: taskMetadata,
    milestones: milestones,
    automations: automations,
    tasks: tasks,
    memberProfiles: memberProfiles,
  );

  void _stubRepositories() {
    when(
      () => projects.getProject(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => Right(project));

    when(
      () => projects.listProjectMembers(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => workspaces.listMembers(any()),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => customWorkflow.listStatuses(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => customWorkflow.listTemplates(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => taskMetadata.listLabels(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => taskMetadata.listCustomFields(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => milestones.listMilestones(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => automations.listRules(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer((_) async => const Right([]));

    when(
      () => automations.getCatalog(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        AutomationCatalogResponse(triggers: [], conditions: [], actions: []),
      ),
    );

    when(() => projectTemplates.listTemplates(any())).thenAnswer(
      (_) async => Right([
        ProjectTemplateResponse(
          id: 'tmpl-1',
          name: 'Szablon Bazowy',
          updatedAtUtc: DateTime.utc(2026),
          version: 1,
        ),
      ]),
    );

    when(
      () => projectTemplates.getTemplateDetails(
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
          updatedAtUtc: DateTime.utc(2026),
          version: 1,
        ),
      ),
    );
  }
}

final class _MockProjectsRepository extends Mock implements ProjectsRepository {}

final class _MockWorkspacesRepository extends Mock
    implements WorkspacesRepository {}

final class _MockProjectTemplatesRepository extends Mock
    implements ProjectTemplatesRepository {}

final class _MockCustomWorkflowRepository extends Mock
    implements CustomWorkflowRepository {}

final class _MockTaskMetadataRepository extends Mock
    implements TaskMetadataRepository {}

final class _MockMilestoneRepository extends Mock
    implements MilestoneRepository {}

final class _MockAutomationRepository extends Mock
    implements AutomationRepository {}

final class _MockTasksRepository extends Mock implements TasksRepository {}

final class _MockProjectMemberProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}
