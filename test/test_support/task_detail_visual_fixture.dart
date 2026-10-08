import 'package:dartz/dartz.dart';
import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_page.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:mocktail/mocktail.dart';

import 'project_settings_fixture.dart';
import 'tasks_board_route_fixture.dart';

const visualWorkspaceId = '550e8400-e29b-41d4-a716-446655440000';
const visualProjectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
const visualTaskId = '550e8400-e29b-41d4-a716-446655440002';
const visualMemberId = '550e8400-e29b-41d4-a716-446655440003';
const visualMilestoneId = '550e8400-e29b-41d4-a716-446655440004';
const visualConversationId = '550e8400-e29b-41d4-a716-446655440005';

enum TaskDetailVisualMode { editable, readOnly, archived, denied, conflict }

final class TaskDetailVisualFixture {
  TaskDetailVisualFixture(this.mode, {String? initialTaskTab}) {
    final customWorkflow = _CustomWorkflowRepository();
    when(
      () => customWorkflow.listStatuses(
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
      ),
    ).thenAnswer((_) async => const Right([]));
    milestoneRepository = _MilestoneRepository();
    when(
      () => milestoneRepository.listMilestones(
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
      ),
    ).thenAnswer((_) async => Right([visualMilestone]));
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(
        userId: 'fixture-user',
        login: 'fixture',
        displayName: 'Fixture',
      ),
    );
    authSession = auth.session;
    _configureChatRepository();
    chatComposition = DevPlannerGlobalChatComposition(
      repository: _chatRepository,
      userId: 'fixture-user',
      draftRepository: _chatDraftRepository,
      messageActions: _chatRepository,
    );
    boardFixture = TasksBoardRouteFixture(
      workspaceId: visualWorkspaceId,
      projectId: visualProjectId,
      boardResult: kanbanBoardResultWithColumns.map(
        (board) => board.copyWith(projectId: visualProjectId),
      ),
      effectiveListConfiguration: const EffectiveTaskListConfigurationResponse(
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        effectiveVisibleColumns: ['sys:title', 'sys:status'],
        effectiveColumnWidths: {'sys:title': 280},
        availableColumns: ['sys:title', 'sys:status'],
        requiredColumns: ['sys:title'],
        sortField: TaskSavedViewSortField.position,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.status,
        userPreferenceVersion: 1,
        policyVersion: 1,
      ),
      userKanbanPreference: const UserKanbanPreferenceResponse(
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        userId: 'fixture-user',
        collapsedColumns: [],
        collapsedCustomStatusIds: [],
        quickFilter: KanbanQuickFilter.all,
        version: 1,
      ),
      projectSettings: ProjectSettingsFixture(
        project: const ProjectListItem(
          id: visualProjectId,
          workspaceId: visualWorkspaceId,
          name: 'Visual fixture project',
          sortPosition: 0,
        ),
      ),
    );
    memberProfilesRepository =
        boardFixture.composition.memberProfilesRepository;
    when(
      () => memberProfilesRepository.listProfiles(
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<ProjectMemberProfile>>([
        ProjectMemberProfile(
          userId: visualMemberId,
          role: ProjectRole.member,
          displayName: 'Marta Nowak',
        ),
      ]),
    );
    router = DevPlannerRouter(
      auth: auth,
      initialLocation:
          '/workspaces/$visualWorkspaceId/projects/$visualProjectId/tasks?view=kanban&task=$visualTaskId'
          '${initialTaskTab == null ? '' : '&taskTab=$initialTaskTab'}',
      tasksBoardComposition: boardFixture.composition,
      projectSettingsComposition: boardFixture.settings.composition,
      tasksDetailsComposition: _detailsComposition(
        customWorkflow,
        milestoneRepository,
      ),
    );
  }

  final TaskDetailVisualMode mode;
  late final TasksBoardRouteFixture boardFixture;
  late final MilestoneRepository milestoneRepository;
  late final ProjectMemberProfilesRepository memberProfilesRepository;
  late final AuthSessionPort authSession;
  late final DevPlannerGlobalChatComposition chatComposition;
  late final DevPlannerRouter router;
  late final _VisualTasksRepository _tasks = _VisualTasksRepository(mode);
  final _VisualChatRepository _chatRepository = _VisualChatRepository();
  final _VisualChatDraftRepository _chatDraftRepository =
      _VisualChatDraftRepository();

  void dispose() => router.dispose();

  ResourceChatRepository get resourceChatRepository => _chatRepository;

  ChatConversationRepository get conversationHistoryRepository =>
      _chatRepository;

  void _configureChatRepository() {
    registerFallbackValue(const ChatComposerDraft(text: ''));
    when(
      () => _chatRepository.resolveTaskConversation(
        taskId: visualTaskId,
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
      ),
    ).thenAnswer((_) async => Right(_visualConversation()));
    when(
      () => _chatRepository.getConversation(visualConversationId),
    ).thenAnswer((_) async => Right(_visualConversation()));
    when(
      () => _chatRepository.listConversationMessages(
        conversationId: visualConversationId,
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => Right(ChatMessagePage(items: _visualChatMessages())),
    );
    when(
      () => _chatRepository.markConversationRead(
        conversationId: visualConversationId,
        messageId: any(named: 'messageId'),
      ),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => _chatRepository.listPins(visualConversationId),
    ).thenAnswer((_) async => const Right(<ChatPinnedMessage>[]));
    when(
      _chatRepository.listBookmarks,
    ).thenAnswer((_) async => const Right(<ChatBookmark>[]));
    when(_chatRepository.listConversations).thenAnswer(
      (_) async => const Right(<ChatConversationResponse>[]),
    );
    when(
      () => _chatRepository.listMessages(visualConversationId),
    ).thenAnswer((_) async => const Right(<ChatMessageResponse>[]));
    when(
      () => _chatDraftRepository.read(
        userId: 'fixture-user',
        conversationId: visualConversationId,
      ),
    ).thenAnswer((_) async => null);
    when(
      () => _chatDraftRepository.save(
        userId: 'fixture-user',
        conversationId: visualConversationId,
        draft: any(named: 'draft'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => _chatDraftRepository.delete(
        userId: 'fixture-user',
        conversationId: visualConversationId,
      ),
    ).thenAnswer((_) async {});
  }

  TasksDetailsComposition _detailsComposition(
    CustomWorkflowRepository customWorkflow,
    MilestoneRepository milestones,
  ) {
    final attachments = _AttachmentRepository();
    when(
      () => attachments.list(
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        taskId: visualTaskId,
      ),
    ).thenAnswer((_) async => Right(visualFiles));
    return TasksDetailsComposition(
      viewRepository: boardFixture.composition.viewRepository,
      tasksRepository: _tasks,
      acceptanceCriteriaRepository: _AcceptanceRepository(),
      attachmentRepository: attachments,
      checklistRepository: _ChecklistRepository(),
      collaborationRepository: _CollaborationRepository(),
      historyRepository: _HistoryRepository(),
      metadataRepository: _MetadataRepository(),
      recurrenceRepository: _RecurrenceRepository(),
      scheduleRepository: _ScheduleRepository(),
      templateRepository: _TemplateRepository(),
      timeTrackingRepository: _TimeTrackingRepository(),
      milestoneRepository: milestones,
      customWorkflowRepository: customWorkflow,
      storageRepository: _StorageRepository(),
      attachmentUploadTransport: _UploadTransport(),
      resourceChatRepository: _chatRepository,
    );
  }
}

ProjectTaskDetailsResponse visualTaskDetails(TaskDetailVisualMode mode) {
  final archived = mode == TaskDetailVisualMode.archived;
  final canEdit = mode == TaskDetailVisualMode.editable;
  return ProjectTaskDetailsResponse(
    task: ProjectTaskResponse(
      id: visualTaskId,
      number: 100,
      key: 'TASK-100',
      workspaceId: visualWorkspaceId,
      projectId: visualProjectId,
      title: 'Przygotować uruchomienie nowego procesu onboardingu',
      description:
          'Zespół Customer Success potrzebuje powtarzalnego wdrożenia nowych '
          'kont klientów. Do końca sprintu przygotuj przepływ łączący '
          'weryfikację danych, konfigurację workspace i pierwszą sesję '
          'szkoleniową.\n\n'
          'Zakres obejmuje mapowanie pól z formularza sprzedażowego, listę '
          'właścicieli po stronie klienta oraz kontrolę uprawnień przed '
          'wysłaniem zaproszeń. W pilotażu uwzględnij firmy z istniejącymi '
          'workspace’ami, żeby nie tworzyć duplikatów.\n\n'
          'Przed publikacją przejrzyj materiały szkoleniowe z zespołem '
          'operacyjnym i potwierdź, że status wdrożenia jest widoczny dla '
          'opiekuna konta. Po pierwszym tygodniu zbierz uwagi z trzech '
          'wdrożeń i zapisz decyzje dotyczące kolejnej iteracji.',
      status: ProjectTaskStatus.inProgress,
      priority: TaskPriority.high,
      taskType: 'task',
      startAtUtc: DateTime.utc(2026, 9, 28),
      dueAtUtc: DateTime.utc(2026, 10, 8),
      milestoneId: visualMilestoneId,
      estimatedMinutes: 480,
      position: 0,
      createdByUserId: 'fixture-user',
      assignees: [
        TaskAssigneeResponse(
          userId: visualMemberId,
          isPrimary: true,
          createdAtUtc: DateTime.utc(2026, 9, 22),
        ),
      ],
      checklistItems: [
        TaskChecklistItemResponse(
          id: 'onboarding-checklist-data-map',
          title: 'Zmapować pola wymagane w formularzu klienta',
          position: 0,
          isCompleted: true,
          completedByUserId: visualMemberId,
          completedAtUtc: DateTime.utc(2026, 9, 27),
          updatedAtUtc: DateTime.utc(2026, 9, 27),
        ),
        TaskChecklistItemResponse(
          id: 'onboarding-checklist-workspace',
          title: 'Dodać kontrolę istniejącego workspace',
          position: 1,
          isCompleted: true,
          completedByUserId: visualMemberId,
          completedAtUtc: DateTime.utc(2026, 9, 28),
          updatedAtUtc: DateTime.utc(2026, 9, 28),
        ),
        TaskChecklistItemResponse(
          id: 'onboarding-checklist-training',
          title: 'Przygotować agendę pierwszego szkolenia',
          position: 2,
          isCompleted: false,
          updatedAtUtc: DateTime.utc(2026, 9, 29),
        ),
        TaskChecklistItemResponse(
          id: 'onboarding-checklist-review',
          title: 'Przejść pilotaż z trzema klientami',
          position: 3,
          isCompleted: false,
          updatedAtUtc: DateTime.utc(2026, 9, 30),
        ),
      ],
      createdAtUtc: DateTime.utc(2026, 9, 30),
      updatedAtUtc: DateTime.utc(2026, 9, 30),
      archivedAtUtc: archived ? DateTime.utc(2026, 9, 29) : null,
      version: 1,
    ),
    labels: visualLabels,
    customFields: visualCustomFields,
    acceptanceCriteria: [
      TaskAcceptanceCriterionResponse(
        id: 'onboarding-accept-data',
        text: 'Duplikat firmy nie tworzy drugiego workspace.',
        position: 0,
        isAccepted: true,
        acceptedByUserId: visualMemberId,
        acceptedAtUtc: DateTime.utc(2026, 9, 27),
        updatedAtUtc: DateTime.utc(2026, 9, 27),
      ),
      TaskAcceptanceCriterionResponse(
        id: 'onboarding-accept-access',
        text: 'Zaproszenia wysyłamy dopiero po sprawdzeniu uprawnień.',
        position: 1,
        isAccepted: false,
        updatedAtUtc: DateTime.utc(2026, 9, 28),
      ),
      TaskAcceptanceCriterionResponse(
        id: 'onboarding-accept-status',
        text: 'Opiekun widzi status wdrożenia i datę następnego kontaktu.',
        position: 2,
        isAccepted: false,
        updatedAtUtc: DateTime.utc(2026, 9, 29),
      ),
    ],
    dependencies: const [],
    watchers: [
      TaskWatcherResponse(
        userId: visualMemberId,
        createdAtUtc: DateTime.utc(2026, 9, 23),
      ),
    ],
    isWatchedByMe: true,
    isPinnedByMe: false,
    subtasks: [
      ProjectTaskSubtaskSummaryResponse(
        id: 'onboarding-subtask-intake',
        number: 101,
        key: 'TASK-101',
        title: 'Uzgodnić pola formularza z zespołem sprzedaży',
        status: ProjectTaskStatus.done,
        priority: TaskPriority.normal,
        dueAtUtc: DateTime.utc(2026, 9, 25),
        version: 1,
      ),
      ProjectTaskSubtaskSummaryResponse(
        id: 'onboarding-subtask-training',
        number: 102,
        key: 'TASK-102',
        title: 'Przygotować materiały dla opiekunów kont',
        status: ProjectTaskStatus.inProgress,
        priority: TaskPriority.high,
        dueAtUtc: DateTime.utc(2026, 10, 2),
        version: 1,
      ),
      ProjectTaskSubtaskSummaryResponse(
        id: 'onboarding-subtask-pilot',
        number: 103,
        key: 'TASK-103',
        title: 'Zebrać wyniki z pilotażowych wdrożeń',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        dueAtUtc: DateTime.utc(2026, 10, 8),
        version: 1,
      ),
    ],
    workflow: const ProjectTaskWorkflowResponse(
      statuses: [
        ProjectTaskWorkflowStatusResponse(
          status: ProjectTaskStatus.todo,
          displayName: 'Do zrobienia',
          color: '#64748B',
          position: 0,
          isInitial: true,
          isTerminal: false,
          category: TaskStatusCategory.todo,
        ),
        ProjectTaskWorkflowStatusResponse(
          status: ProjectTaskStatus.inProgress,
          displayName: 'W toku',
          color: '#2563EB',
          position: 1,
          isInitial: false,
          isTerminal: false,
          category: TaskStatusCategory.inProgress,
        ),
        ProjectTaskWorkflowStatusResponse(
          status: ProjectTaskStatus.blocked,
          displayName: 'Zablokowane',
          color: '#DC2626',
          position: 2,
          isInitial: false,
          isTerminal: false,
          category: TaskStatusCategory.inProgress,
        ),
        ProjectTaskWorkflowStatusResponse(
          status: ProjectTaskStatus.done,
          displayName: 'Ukończone',
          color: '#16A34A',
          position: 3,
          isInitial: false,
          isTerminal: true,
          category: TaskStatusCategory.done,
        ),
      ],
      transitions: [
        ProjectTaskWorkflowTransitionResponse(
          fromStatus: ProjectTaskStatus.inProgress,
          toStatus: ProjectTaskStatus.todo,
        ),
        ProjectTaskWorkflowTransitionResponse(
          fromStatus: ProjectTaskStatus.inProgress,
          toStatus: ProjectTaskStatus.blocked,
        ),
        ProjectTaskWorkflowTransitionResponse(
          fromStatus: ProjectTaskStatus.inProgress,
          toStatus: ProjectTaskStatus.done,
        ),
      ],
      version: 1,
    ),
    includedUsers: const [
      UserReferenceResponse(
        userId: visualMemberId,
        displayName: 'Marta Nowak',
        isActive: true,
      ),
    ],
    capabilities: TaskCapabilitiesResponse(
      canEdit: canEdit,
      canArchive: canEdit && !archived,
      canRestore: archived,
    ),
  );
}

final visualMilestone = MilestoneResponse(
  id: visualMilestoneId,
  projectId: visualProjectId,
  workspaceId: visualWorkspaceId,
  name: 'Pilotaż onboardingowy',
  dueAtUtc: DateTime.utc(2026, 10, 12),
  status: MilestoneStatus.active,
  progress: 0.58,
  createdAtUtc: DateTime.utc(2026, 9),
  updatedAtUtc: DateTime.utc(2026, 9, 30),
  version: 1,
);

final visualLabels = [
  TaskLabelResponse(
    id: 'label-customer-success',
    name: 'Customer Success',
    color: '#2F6FED',
    createdAtUtc: DateTime.utc(2026, 9),
  ),
  TaskLabelResponse(
    id: 'label-pilot',
    name: 'Pilotaż',
    color: '#16856B',
    createdAtUtc: DateTime.utc(2026, 9),
  ),
];

final visualCustomFields = [
  const TaskCustomFieldDefinitionValueResponse(
    id: 'field-customer-count',
    name: 'Liczba klientów',
    type: TaskCustomFieldType.number,
    isRequired: false,
    position: 0,
    value: 3,
  ),
  const TaskCustomFieldDefinitionValueResponse(
    id: 'field-launch-channel',
    name: 'Kanał wdrożenia',
    type: TaskCustomFieldType.singleSelect,
    isRequired: false,
    position: 1,
    options: ['Remote', 'On-site'],
    value: 'Remote',
  ),
];

final List<StorageFileResponse> visualFiles = [
  for (var index = 0; index < 10; index++)
    StorageFileResponse(
      id: 'visual-file-$index',
      module: StorageModule.workspaces,
      resourceType: StorageResourceType.task,
      resourceId: visualTaskId,
      originalFileName: switch (index) {
        0 => 'Plan wdrożenia klientów.xlsx',
        1 => 'Materiały szkoleniowe.pdf',
        2 => 'Mapa procesu onboardingu.docx',
        _ => 'Załącznik projektu ${index + 1}.pdf',
      },
      extension: index == 0 ? 'xlsx' : 'pdf',
      mimeType: index == 0
          ? 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          : 'application/pdf',
      fileSizeBytes: 128000 + index * 8192,
      version: 1,
      workspaceId: visualWorkspaceId,
      projectId: visualProjectId,
      ownerUserId: 'fixture-user',
      createdByUserId: 'fixture-user',
      createdAtUtc: DateTime.utc(2026, 9, 25),
      updatedAtUtc: DateTime.utc(2026, 9, 28),
      isDeleted: false,
      processingStatus: StorageProcessingStatus.ready,
      scanStatus: StorageScanStatus.clean,
      aiStatus: StorageAiStatus.none,
      accessLevel: StorageEffectiveAccessLevel.owner,
      canRead: true,
      canEdit: true,
      canShare: true,
      canDelete: true,
      canPreview: true,
      canDownload: true,
      canManageVersions: true,
    ),
];

final class _VisualTasksRepository extends Mock implements TasksRepository {
  _VisualTasksRepository(this.mode) {
    when(
      () => getTask(
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        taskId: visualTaskId,
      ),
    ).thenAnswer((_) async {
      if (mode == TaskDetailVisualMode.denied ||
          mode == TaskDetailVisualMode.conflict) {
        final error = mode == TaskDetailVisualMode.denied
            ? const ApiError(
                type: ApiErrorType.forbidden,
                message: 'Fixture access denied',
                backendCode: 403,
              )
            : const ApiError(
                type: ApiErrorType.conflict,
                message: 'Fixture response conflict (409)',
                backendCode: 409,
              );
        return Left(error);
      }
      return Right(visualTaskDetails(mode));
    });
  }

  final TaskDetailVisualMode mode;
}

final class _AcceptanceRepository extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _AttachmentRepository extends Mock
    implements TaskAttachmentRepository {}

final class _ChecklistRepository extends Mock
    implements TaskChecklistRepository {}

final class _CollaborationRepository extends Mock
    implements TaskCollaborationRepository {}

final class _HistoryRepository extends Mock implements TaskHistoryRepository {}

final class _MetadataRepository extends Mock
    implements TaskMetadataRepository {}

final class _RecurrenceRepository extends Mock
    implements TaskRecurrenceRepository {}

final class _ScheduleRepository extends Mock
    implements TaskScheduleRepository {}

final class _TemplateRepository extends Mock
    implements TaskTemplateRepository {}

final class _TimeTrackingRepository extends Mock
    implements TaskTimeTrackingRepository {}

final class _MilestoneRepository extends Mock implements MilestoneRepository {}

final class _CustomWorkflowRepository extends Mock
    implements CustomWorkflowRepository {}

final class _StorageRepository extends Mock implements StorageRepository {}

final class _UploadTransport extends Mock
    implements TaskAttachmentUploadTransport {}

final class _VisualChatRepository extends Mock
    implements
        ChatRepository,
        ChatConversationRepository,
        ResourceChatRepository,
        ChatMessageActionsRepository {}

final class _VisualChatDraftRepository extends Mock
    implements ChatDraftRepository {}

ChatConversation _visualConversation() => ChatConversation(
  id: visualConversationId,
  type: 'resource',
  scopeKind: 'Task',
  scopeKey: visualTaskId,
  workspaceId: visualWorkspaceId,
  projectId: visualProjectId,
  name: 'Wdrożenie onboardingu klientów',
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9, 30),
  postingPermission: 'Member',
  isArchived: false,
);

List<ChatMessage> _visualChatMessages() => List<ChatMessage>.generate(
  100,
  (index) => ChatMessage(
    id: 'visual-message-$index',
    conversationId: visualConversationId,
    authorUserId: index.isEven ? 'fixture-user' : visualMemberId,
    clientMessageId: 'visual-client-message-$index',
    text: _visualChatText(index),
    payloadHash: 'visual-payload-$index',
    version: 1,
    createdAtUtc: DateTime.utc(2026, 9).add(Duration(minutes: index * 13)),
    isDeleted: false,
    deliveryState: ChatMessageDeliveryState.sent,
  ),
);

String _visualChatText(int index) => switch (index % 4) {
  0 =>
    'Przekazałem zespołowi checklistę uruchomienia i potwierdzili '
        'właścicieli kroków dla partii ${index + 1}.',
  1 =>
    'Po weryfikacji dostępu możemy utrzymać termin wdrożenia; '
        'zostały dwa punkty do akceptacji klienta.',
  2 =>
    'Dodałam podsumowanie testów oraz wyniki dla środowiska '
        'przedprodukcyjnego. Proszę sprawdzić załączniki.',
  _ =>
    'Uzgodniliśmy kolejny przegląd na jutro i zapisaliśmy ryzyka '
        'operacyjne w planie projektu.',
};
