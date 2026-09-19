import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/kanban/api/kanban_api.dart';
import 'package:devplanner/workspaces/data/kanban/repositories/kanban_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/milestones/api/milestones_api.dart';
import 'package:devplanner/workspaces/data/projects/milestones/repositories/milestone_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/repositories/project_member_profiles_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/repositories/projects_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_advanced_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_capacity_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_templates_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_views_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/tasks_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_capacity_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_collaboration_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_list_configuration_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_metadata_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_recurrence_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_template_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_view_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_workflow_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/tasks_repository_impl.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';

/// Kompozycja runtime dla niezależnego Boardu Tasks/Kanban.
///
/// Każdy adapter korzysta z jednego, uwierzytelnionego Dio. Realtime jest
/// tworzony dopiero dla transportu desktopowego z dostawcą tokenu; webowy BFF
/// nie ujawnia tokenu SignalR i pozostaje poza tą kompozycją.
final class TasksBoardComposition {
  const TasksBoardComposition({
    required this.kanbanRepository,
    required this.tasksRepository,
    required this.workflowRepository,
    required this.collaborationRepository,
    required this.taskTemplateRepository,
    required this.memberProfilesRepository,
    required this.projectsRepository,
    required this.metadataRepository,
    required this.viewRepository,
    required this.listConfigurationRepository,
    required this.capacityRepository,
    required this.recurrenceRepository,
    required this.milestoneRepository,
    required this.realtimeFactory,
  });

  final KanbanRepository kanbanRepository;
  final TasksRepository tasksRepository;
  final TaskWorkflowRepository workflowRepository;
  final TaskCollaborationRepository collaborationRepository;
  final TaskTemplateRepository taskTemplateRepository;
  final ProjectMemberProfilesRepository memberProfilesRepository;
  final ProjectsRepository projectsRepository;
  final TaskMetadataRepository metadataRepository;
  final TaskViewRepository viewRepository;
  final TaskListConfigurationRepository listConfigurationRepository;
  final TaskCapacityRepository capacityRepository;
  final TaskRecurrenceRepository recurrenceRepository;
  final MilestoneRepository milestoneRepository;
  final WorkspaceScopedRealtimeFactory realtimeFactory;

  /// Zwraca `null`, gdy transport nie może bezpiecznie utworzyć realtime.
  static TasksBoardComposition? fromTransport(
    DevPlannerHttpTransport transport,
  ) {
    final accessTokenProvider = transport.realtimeAccessTokenProvider;
    if (!transport.supportsStandaloneApiClients ||
        accessTokenProvider == null) {
      return null;
    }

    final dio = transport.apiDio;
    final baseUrl = transport.baseUrl;
    final advancedApi = TaskAdvancedApi(dio, baseUrl: baseUrl);
    final operationsApi = TaskOperationsApi(dio, baseUrl: baseUrl);
    final projectsApi = ProjectsApi(dio, baseUrl: baseUrl);

    return TasksBoardComposition(
      kanbanRepository: KanbanRepositoryImpl(
        KanbanApi(dio, baseUrl: baseUrl),
      ),
      tasksRepository: TasksRepositoryImpl(
        TasksApi(dio, baseUrl: baseUrl),
      ),
      workflowRepository: TaskWorkflowRepositoryImpl(advancedApi),
      collaborationRepository: TaskCollaborationRepositoryImpl(operationsApi),
      taskTemplateRepository: TaskTemplateRepositoryImpl(
        TaskTemplatesApi(dio, baseUrl: baseUrl),
      ),
      memberProfilesRepository: ProjectMemberProfilesRepositoryImpl(
        api: projectsApi,
      ),
      projectsRepository: ProjectsRepositoryImpl(api: projectsApi),
      metadataRepository: TaskMetadataRepositoryImpl(operationsApi),
      viewRepository: TaskViewRepositoryImpl(
        TaskViewsApi(dio, baseUrl: baseUrl),
      ),
      listConfigurationRepository: TaskListConfigurationRepositoryImpl(dio),
      capacityRepository: TaskCapacityRepositoryImpl(
        TaskCapacityApi(dio, baseUrl: baseUrl),
      ),
      recurrenceRepository: TaskRecurrenceRepositoryImpl(advancedApi),
      milestoneRepository: MilestoneRepositoryImpl(
        MilestonesApi(dio, baseUrl: baseUrl),
      ),
      realtimeFactory: WorkspaceScopedRealtimeFactory(
        baseUrl: baseUrl,
        accessTokenProvider: accessTokenProvider,
      ),
    );
  }
}
