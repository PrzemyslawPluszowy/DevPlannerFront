import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
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
import 'package:mocktail/mocktail.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'project_settings_fixture.dart';

/// Współdzielony fixture kompozycji Tasks.
///
/// Testy trasy i routera muszą montować dokładnie ten sam, hermetyczny graf
/// portów, żeby kontrakt widoku był sprawdzany na realnym module, a nie na
/// atrapie ekranu.
final class TasksBoardRouteFixture {
  TasksBoardRouteFixture({
    this.workspaceId = 'workspace-1',
    this.projectId = 'project-1',
    required this.boardResult,
    this.pendingBoard,
    this.groupedListResult,
    ProjectSettingsFixture? projectSettings,
  }) : settings =
           projectSettings ??
           ProjectSettingsFixture(
             project: ProjectListItem(
               id: projectId,
               workspaceId: workspaceId,
               name: 'Project',
               sortPosition: 0,
             ),
           ) {
    _stubRepositories();
  }

  final String workspaceId;
  final String projectId;
  final Either<ApiError, KanbanBoardResponse> boardResult;
  final Future<Either<ApiError, KanbanBoardResponse>>? pendingBoard;

  /// Odpowiedź listy grup; `null` oznacza pusty wynik.
  final Either<ApiError, ProjectTaskGroupedListResponse>? groupedListResult;

  /// Porty centrum ustawień projektu, które nagłówek Tasks otwiera jawnie.
  final ProjectSettingsFixture settings;

  final _MockKanbanRepository kanban = _MockKanbanRepository();
  final _MockTasksRepository tasks = _MockTasksRepository();
  final _MockTaskWorkflowRepository workflow = _MockTaskWorkflowRepository();
  final _MockTaskCollaborationRepository collaboration =
      _MockTaskCollaborationRepository();
  final _MockTaskTemplateRepository templates = _MockTaskTemplateRepository();
  final _MockProjectMemberProfilesRepository profiles =
      _MockProjectMemberProfilesRepository();
  final _MockProjectsRepository projects = _MockProjectsRepository();
  final _MockTaskMetadataRepository metadata = _MockTaskMetadataRepository();
  final _MockTaskViewRepository views = _MockTaskViewRepository();
  final _MockTaskListConfigurationRepository listConfiguration =
      _MockTaskListConfigurationRepository();
  final _MockTaskCapacityRepository capacity = _MockTaskCapacityRepository();
  final _MockTaskRecurrenceRepository recurrence =
      _MockTaskRecurrenceRepository();
  final _MockMilestoneRepository milestones = _MockMilestoneRepository();

  TasksBoardComposition get composition => TasksBoardComposition(
    kanbanRepository: kanban,
    tasksRepository: tasks,
    workflowRepository: workflow,
    collaborationRepository: collaboration,
    taskTemplateRepository: templates,
    memberProfilesRepository: profiles,
    projectsRepository: projects,
    metadataRepository: metadata,
    viewRepository: views,
    listConfigurationRepository: listConfiguration,
    capacityRepository: capacity,
    recurrenceRepository: recurrence,
    milestoneRepository: milestones,
    realtimeFactory: _FakeRealtimeFactory(),
  );

  void _stubRepositories() {
    when(
      () => tasks.listProjectTaskGroups(
        workspaceId: workspaceId,
        projectId: projectId,
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async =>
          groupedListResult ??
          const Right<ApiError, ProjectTaskGroupedListResponse>(
            ProjectTaskGroupedListResponse(
              totalCount: 0,
              groupBy: TaskSavedViewGroupBy.status,
              groups: [],
            ),
          ),
    );
    // Tablica jest stubowana razem z filtrem, bo moduł zawsze wysyła filtr do
    // Backendu; atrapa bez tego wymiaru nie odpowiada na realne wywołanie.
    when(
      () => kanban.getBoard(
        workspaceId: workspaceId,
        projectId: projectId,
        filter: any(named: 'filter'),
      ),
    ).thenAnswer((_) => pendingBoard ?? Future.value(boardResult));
    when(
      () => kanban.getUserPreference(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, UserKanbanPreferenceResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No preference'),
      ),
    );
    when(
      () => workflow.getWorkflow(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, ProjectTaskWorkflowResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No workflow'),
      ),
    );
    when(
      () => profiles.listProfiles(
        workspaceId: workspaceId,
        projectId: projectId,
        forceRefresh: true,
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<ProjectMemberProfile>>(
        <ProjectMemberProfile>[],
      ),
    );
    when(
      () => projects.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => Right<ApiError, ProjectListItem>(
        ProjectListItem(
          id: projectId,
          workspaceId: workspaceId,
          name: 'Project',
          sortPosition: 0,
        ),
      ),
    );
    when(
      () => metadata.listLabels(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<TaskLabelResponse>>(
        <TaskLabelResponse>[],
      ),
    );
    when(
      () => metadata.listCustomFields(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<TaskCustomFieldResponse>>(
        <TaskCustomFieldResponse>[],
      ),
    );
    when(
      () => milestones.listMilestones(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async =>
          const Right<ApiError, List<MilestoneResponse>>(<MilestoneResponse>[]),
    );
    when(
      () => views.list(workspaceId: workspaceId, projectId: projectId),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<TaskSavedViewResponse>>(
        <TaskSavedViewResponse>[],
      ),
    );
    when(
      () => listConfiguration.getEffectiveConfiguration(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, EffectiveTaskListConfigurationResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No list config'),
      ),
    );
    when(() => templates.list(workspaceId)).thenAnswer(
      (_) async => const Right<ApiError, List<TaskTemplateResponse>>(
        <TaskTemplateResponse>[],
      ),
    );
    when(
      () => capacity.getWorkload(
        workspaceId: workspaceId,
        projectId: projectId,
        fromDate: any(named: 'fromDate'),
        toDate: any(named: 'toDate'),
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, TaskWorkloadResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No workload'),
      ),
    );
    when(
      () => tasks.getProjectTimeline(
        workspaceId: workspaceId,
        projectId: projectId,
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, TaskTimelineResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No timeline'),
      ),
    );
    when(
      () => recurrence.getProjectRecurrences(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async =>
          const Left<ApiError, List<ProjectTaskRecurrenceItemResponse>>(
            ApiError(type: ApiErrorType.notFound, message: 'No recurrences'),
          ),
    );
    when(
      () => recurrence.getProjectRecurrenceRuns(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, List<ProjectTaskRecurrenceRunResponse>>(
        ApiError(type: ApiErrorType.notFound, message: 'No runs'),
      ),
    );
  }
}

/// Rejestruje wartości zastępcze wymagane przez matchery mocktail.
void registerTasksBoardRouteFallbacks() {
  registerFallbackValue(KanbanBoardFilter.none);
  registerFallbackValue(const ProjectTasksGroupedQuery());
  registerFallbackValue(
    ProjectTaskTimelineQuery(
      fromUtc: DateTime.utc(2026),
      toUtc: DateTime.utc(2026, 2),
    ),
  );
}

const emptyKanbanBoardResult = Right<ApiError, KanbanBoardResponse>(
  KanbanBoardResponse(
    projectId: 'project-1',
    swimlaneMode: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    hiddenColumns: [],
    visibleCardFields: [],
    defaultCardDensity: KanbanCardDensity.comfortable,
    columns: [],
  ),
);

/// Board z kolumnami dowodzi, że Lista nie montuje niewidocznego Kanbanu.
const kanbanBoardResultWithColumns = Right<ApiError, KanbanBoardResponse>(
  KanbanBoardResponse(
    projectId: 'project-1',
    swimlaneMode: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    hiddenColumns: [],
    visibleCardFields: [],
    defaultCardDensity: KanbanCardDensity.comfortable,
    columns: [
      KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        displayName: 'Do zrobienia',
        color: '#2563EB',
        totalTaskCount: 2,
        isWipLimitExceeded: false,
        tasks: [],
      ),
    ],
  ),
);

final class _MockKanbanRepository extends Mock implements KanbanRepository {}

final class _MockTasksRepository extends Mock implements TasksRepository {}

final class _MockTaskWorkflowRepository extends Mock
    implements TaskWorkflowRepository {}

final class _MockTaskCollaborationRepository extends Mock
    implements TaskCollaborationRepository {}

final class _MockTaskTemplateRepository extends Mock
    implements TaskTemplateRepository {}

final class _MockProjectMemberProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}

final class _MockProjectsRepository extends Mock implements ProjectsRepository {}

final class _MockTaskMetadataRepository extends Mock
    implements TaskMetadataRepository {}

final class _MockTaskViewRepository extends Mock implements TaskViewRepository {}

final class _MockTaskListConfigurationRepository extends Mock
    implements TaskListConfigurationRepository {}

final class _MockTaskCapacityRepository extends Mock
    implements TaskCapacityRepository {}

final class _MockTaskRecurrenceRepository extends Mock
    implements TaskRecurrenceRepository {}

final class _MockMilestoneRepository extends Mock
    implements MilestoneRepository {}

final class _FakeSignalRTransport implements WorkspaceSignalRTransport {
  @override
  Stream<WorkspaceSignalRConnectionState> get states =>
      Stream<WorkspaceSignalRConnectionState>.value(
        WorkspaceSignalRConnectionState.disconnected,
      );

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async => null;

  @override
  void on(String methodName, MethodInvocationFunc handler) {}

  @override
  void dispose() {}
}

final class _FakeRealtimeFactory extends WorkspaceScopedRealtimeFactory {
  _FakeRealtimeFactory()
    : super(baseUrl: 'https://test.invalid', accessTokenProvider: _token);

  static Future<String?> _token() async => 'test-token';

  @override
  WorkspaceScopedRealtimeService create(WorkspaceScopedRealtimeKind kind) =>
      WorkspaceScopedRealtimeService(client: _FakeSignalRTransport());
}

/// Karta Kanbanu dla zrzutów widoków.
KanbanTaskCardResponse visualKanbanCard({
  required String id,
  required String key,
  required String title,
  required int position,
  String? assigneeUserId,
  int checklistTotal = 0,
  int checklistCompleted = 0,
}) => KanbanTaskCardResponse(
  id: id,
  number: position,
  taskCode: key,
  title: title,
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.high,
  primaryAssigneeUserId: assigneeUserId,
  position: position,
  checklistTotal: checklistTotal,
  checklistCompleted: checklistCompleted,
  attachmentCount: 0,
  dueAtUtc: DateTime.utc(2026, 10, 2),
  version: 1,
);

/// Board z trzema kolumnami i kartami, używany wyłącznie do zrzutów widoków.
final populatedKanbanBoardResult = Right<ApiError, KanbanBoardResponse>(
  KanbanBoardResponse(
    projectId: 'project-1',
    swimlaneMode: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    hiddenColumns: [],
    visibleCardFields: [
      KanbanCardField.assignee,
      KanbanCardField.dueDate,
      KanbanCardField.subtasks,
    ],
    defaultCardDensity: KanbanCardDensity.comfortable,
    columns: [
      KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        displayName: 'Do zrobienia',
        color: '#2563EB',
        totalTaskCount: 3,
        isWipLimitExceeded: false,
        tasks: [
          KanbanTaskCardResponse(
            id: 'task-1',
            number: 1,
            taskCode: 'DEV-1',
            title: 'Uporządkować wspólny nagłówek Listy i Kanbanu',
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.high,
            position: 1,
            checklistTotal: 4,
            checklistCompleted: 2,
            attachmentCount: 0,
            dueAtUtc: DateTime.utc(2026, 10, 2),
            version: 1,
          ),
          const KanbanTaskCardResponse(
            id: 'task-2',
            number: 2,
            taskCode: 'DEV-2',
            title: 'Domknąć filtry w wierszu poleceń',
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.normal,
            position: 2,
            checklistTotal: 2,
            checklistCompleted: 0,
            attachmentCount: 0,
            version: 1,
          ),
          const KanbanTaskCardResponse(
            id: 'task-3',
            number: 3,
            taskCode: 'DEV-3',
            title: 'Opisać rollback 409 przy przenoszeniu karty',
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.critical,
            position: 3,
            checklistTotal: 0,
            checklistCompleted: 0,
            attachmentCount: 1,
            version: 1,
          ),
        ],
      ),
      const KanbanColumnResponse(
        status: ProjectTaskStatus.inProgress,
        displayName: 'W toku',
        color: '#F59E0B',
        totalTaskCount: 2,
        isWipLimitExceeded: false,
        tasks: [
          KanbanTaskCardResponse(
            id: 'task-4',
            number: 4,
            taskCode: 'DEV-4',
            title: 'Zrównać menu kontekstowe Listy i Kanbanu',
            status: ProjectTaskStatus.inProgress,
            priority: TaskPriority.high,
            position: 4,
            checklistTotal: 3,
            checklistCompleted: 3,
            attachmentCount: 0,
            version: 2,
          ),
          KanbanTaskCardResponse(
            id: 'task-5',
            number: 5,
            taskCode: 'DEV-5',
            title: 'Potwierdzić realtime po zmianie kolumny',
            status: ProjectTaskStatus.inProgress,
            priority: TaskPriority.normal,
            position: 5,
            checklistTotal: 1,
            checklistCompleted: 0,
            attachmentCount: 0,
            version: 1,
          ),
        ],
      ),
      const KanbanColumnResponse(
        status: ProjectTaskStatus.done,
        displayName: 'Zrobione',
        color: '#10B981',
        totalTaskCount: 1,
        isWipLimitExceeded: false,
        tasks: [
          KanbanTaskCardResponse(
            id: 'task-6',
            number: 6,
            taskCode: 'DEV-6',
            title: 'Przenieść tokeny gęstości do motywu',
            status: ProjectTaskStatus.done,
            priority: TaskPriority.low,
            position: 6,
            checklistTotal: 2,
            checklistCompleted: 2,
            attachmentCount: 0,
            version: 3,
          ),
        ],
      ),
    ],
  ),
);

/// Grupy listy odpowiadające danym z [populatedKanbanBoardResult].
final populatedGroupedListResult =
    Right<ApiError, ProjectTaskGroupedListResponse>(
      ProjectTaskGroupedListResponse(
        totalCount: 6,
        groupBy: TaskSavedViewGroupBy.status,
        groups: [
          ProjectTaskListGroupResponse(
            key: 'status:Todo',
            displayName: 'Do zrobienia',
            color: '#2563EB',
            position: 0,
            totalCount: 3,
            items: [
              ProjectTaskListItemResponse(
                id: 'task-1',
                number: 1,
                key: 'DEV-1',
                title: 'Uporządkować wspólny nagłówek Listy i Kanbanu',
                status: ProjectTaskStatus.todo,
                priority: TaskPriority.high,
                assignees: [],
                checklistCompletedCount: 2,
                checklistTotalCount: 4,
                updatedAtUtc: DateTime.utc(2026, 9, 19),
                version: 1,
              ),
              ProjectTaskListItemResponse(
                id: 'task-2',
                number: 2,
                key: 'DEV-2',
                title: 'Domknąć filtry w wierszu poleceń',
                status: ProjectTaskStatus.todo,
                priority: TaskPriority.normal,
                assignees: [],
                checklistCompletedCount: 0,
                checklistTotalCount: 2,
                updatedAtUtc: DateTime.utc(2026, 9, 19),
                version: 1,
              ),
              ProjectTaskListItemResponse(
                id: 'task-3',
                number: 3,
                key: 'DEV-3',
                title: 'Opisać rollback 409 przy przenoszeniu karty',
                status: ProjectTaskStatus.todo,
                priority: TaskPriority.critical,
                assignees: [],
                checklistCompletedCount: 0,
                checklistTotalCount: 0,
                updatedAtUtc: DateTime.utc(2026, 9, 19),
                version: 1,
              ),
            ],
          ),
          ProjectTaskListGroupResponse(
            key: 'status:InProgress',
            displayName: 'W toku',
            color: '#F59E0B',
            position: 1,
            totalCount: 2,
            items: [
              ProjectTaskListItemResponse(
                id: 'task-4',
                number: 4,
                key: 'DEV-4',
                title: 'Zrównać menu kontekstowe Listy i Kanbanu',
                status: ProjectTaskStatus.inProgress,
                priority: TaskPriority.high,
                assignees: [],
                checklistCompletedCount: 3,
                checklistTotalCount: 3,
                updatedAtUtc: DateTime.utc(2026, 9, 19),
                version: 2,
              ),
              ProjectTaskListItemResponse(
                id: 'task-5',
                number: 5,
                key: 'DEV-5',
                title: 'Potwierdzić realtime po zmianie kolumny',
                status: ProjectTaskStatus.inProgress,
                priority: TaskPriority.normal,
                assignees: [],
                checklistCompletedCount: 0,
                checklistTotalCount: 1,
                updatedAtUtc: DateTime.utc(2026, 9, 19),
                version: 1,
              ),
            ],
          ),
        ],
      ),
    );
