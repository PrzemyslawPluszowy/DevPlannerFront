import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/api/custom_workflow_api.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/repositories/custom_workflow_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/milestones/api/milestones_api.dart';
import 'package:devplanner/workspaces/data/projects/milestones/repositories/milestone_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/repositories/project_member_profiles_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/repositories/projects_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/tasks_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_metadata_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/tasks_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/templates/api/project_templates_api.dart';
import 'package:devplanner/workspaces/data/projects/templates/repositories/project_templates_repository_impl.dart';
import 'package:devplanner/workspaces/data/workspaces/api/automation_api.dart';
import 'package:devplanner/workspaces/data/workspaces/api/workspaces_api.dart';
import 'package:devplanner/workspaces/data/workspaces/repositories/automation_repository_impl.dart';
import 'package:devplanner/workspaces/data/workspaces/repositories/workspaces_repository_impl.dart';
import 'package:devplanner/workspaces/domain/repositories/automation_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';

/// Komplet portów, których potrzebuje każda zakładka centrum ustawień projektu.
///
/// Centrum jest otwierane przez `showDialog` na root navigatorze, więc nie jest
/// potomkiem trasy, która je otworzyła, i nie może czytać portów z providerów
/// tej trasy. Modal dostaje dlatego cały zestaw jawnie — jedno miejsce składa
/// go z transportu, a zakładki tworzą swoje Cubity dopiero po wejściu.
final class ProjectSettingsComposition {
  const ProjectSettingsComposition({
    required this.projects,
    required this.workspaces,
    required this.projectTemplates,
    required this.customWorkflow,
    required this.taskMetadata,
    required this.milestones,
    required this.automations,
    required this.tasks,
    required this.memberProfiles,
  });

  /// Zakładka Ogólne i członkowie projektu.
  final ProjectsRepository projects;

  /// Skład workspace'u przy zaproszeniach do projektu.
  final WorkspacesRepository workspaces;

  /// Zakładka Szablony Projektu.
  final ProjectTemplatesRepository projectTemplates;

  /// Zakładka Workflow i własne statusy.
  final CustomWorkflowRepository customWorkflow;

  /// Zakładka Pola własne i Etykiety.
  final TaskMetadataRepository taskMetadata;

  /// Zakładka Kamienie milowe.
  final MilestoneRepository milestones;

  /// Zakładka Automatyzacje.
  final AutomationRepository automations;

  /// Kandydaci na zadanie przy dyrektywach automatyzacji.
  final TasksRepository tasks;

  /// Role i profile członków projektu.
  final ProjectMemberProfilesRepository memberProfiles;

  /// Buduje realny kontrakt z jednego uwierzytelnionego transportu.
  ///
  /// Zwraca `null`, gdy transport nie tworzy samodzielnych klientów API, więc
  /// trasa pozostaje wtedy przy istniejącym ekranie unavailable zamiast
  /// pokazywać ustawienia bez autorytatywnych danych.
  static ProjectSettingsComposition? fromTransport(
    DevPlannerHttpTransport transport,
  ) {
    if (!transport.supportsStandaloneApiClients) return null;
    final dio = transport.apiDio;
    final baseUrl = transport.baseUrl;
    final projectsApi = ProjectsApi(dio, baseUrl: baseUrl);
    final operationsApi = TaskOperationsApi(dio, baseUrl: baseUrl);
    return ProjectSettingsComposition(
      projects: ProjectsRepositoryImpl(api: projectsApi),
      workspaces: WorkspacesRepositoryImpl(
        api: WorkspacesApi(dio, baseUrl: baseUrl),
      ),
      projectTemplates: ProjectTemplatesRepositoryImpl(
        api: ProjectTemplatesApi(dio, baseUrl: baseUrl),
      ),
      customWorkflow: CustomWorkflowRepositoryImpl(
        CustomWorkflowApi(dio, baseUrl: baseUrl),
      ),
      taskMetadata: TaskMetadataRepositoryImpl(operationsApi),
      milestones: MilestoneRepositoryImpl(
        MilestonesApi(dio, baseUrl: baseUrl),
      ),
      automations: AutomationRepositoryImpl(
        AutomationApi(dio, baseUrl: baseUrl),
      ),
      tasks: TasksRepositoryImpl(TasksApi(dio, baseUrl: baseUrl)),
      memberProfiles: ProjectMemberProfilesRepositoryImpl(api: projectsApi),
    );
  }
}
