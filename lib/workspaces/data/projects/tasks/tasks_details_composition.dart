import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/api/custom_workflow_api.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/repositories/custom_workflow_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/milestones/api/milestones_api.dart';
import 'package:devplanner/workspaces/data/projects/milestones/repositories/milestone_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_advanced_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_recurrence_time_zone_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_schedule_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_templates_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_time_tracking_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_views_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/tasks_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_acceptance_criteria_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_attachment_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_checklist_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_collaboration_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_history_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_metadata_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_recurrence_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_schedule_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_template_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_time_tracking_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/task_view_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/tasks_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/services/task_attachment_presigned_upload_transport.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
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
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';

/// Kompozycja desktopowego ekranu szczegółów zadania.
///
/// Zbiera wyłącznie typed repositories dla istniejącego pionu Task Details.
/// Web używa API przez transport BFF cookie/CSRF. Realtime jest osobną,
/// opcjonalną capability i nie warunkuje odczytu REST ani edycji zadania.
final class TasksDetailsComposition {
  const TasksDetailsComposition({
    required this.tasksRepository,
    required this.viewRepository,
    required this.acceptanceCriteriaRepository,
    required this.attachmentRepository,
    required this.checklistRepository,
    required this.collaborationRepository,
    required this.historyRepository,
    required this.metadataRepository,
    required this.recurrenceRepository,
    required this.scheduleRepository,
    required this.templateRepository,
    required this.timeTrackingRepository,
    required this.milestoneRepository,
    required this.customWorkflowRepository,
    required this.storageRepository,
    required this.attachmentUploadTransport,
    required this.resourceChatRepository,
  });

  final TasksRepository tasksRepository;
  final TaskViewRepository viewRepository;
  final TaskAcceptanceCriteriaRepository acceptanceCriteriaRepository;
  final TaskAttachmentRepository attachmentRepository;
  final TaskChecklistRepository checklistRepository;
  final TaskCollaborationRepository collaborationRepository;
  final TaskHistoryRepository historyRepository;
  final TaskMetadataRepository metadataRepository;
  final TaskRecurrenceRepository recurrenceRepository;
  final TaskScheduleRepository scheduleRepository;
  final TaskTemplateRepository templateRepository;
  final TaskTimeTrackingRepository timeTrackingRepository;
  final MilestoneRepository milestoneRepository;
  final CustomWorkflowRepository customWorkflowRepository;
  final StorageRepository storageRepository;
  final TaskAttachmentUploadTransport attachmentUploadTransport;
  final ResourceChatRepository resourceChatRepository;

  /// Buduje realny desktopowy kontrakt z jednego uwierzytelnionego transportu.
  /// Zwraca `null` wyłącznie, gdy transport nie ma bezpiecznej sesji API.
  static TasksDetailsComposition? fromTransport(
    DevPlannerHttpTransport transport,
  ) {
    if (!transport.supportsStandaloneApiClients) return null;
    final dio = transport.apiDio;
    final baseUrl = transport.baseUrl;
    final operationsApi = TaskOperationsApi(dio, baseUrl: baseUrl);
    final advancedApi = TaskAdvancedApi(dio, baseUrl: baseUrl);
    return TasksDetailsComposition(
      viewRepository: TaskViewRepositoryImpl(
        TaskViewsApi(dio, baseUrl: baseUrl),
      ),
      tasksRepository: TasksRepositoryImpl(
        TasksApi(dio, baseUrl: baseUrl),
      ),
      acceptanceCriteriaRepository: TaskAcceptanceCriteriaRepositoryImpl(
        operationsApi,
      ),
      attachmentRepository: TaskAttachmentRepositoryImpl(operationsApi),
      checklistRepository: TaskChecklistRepositoryImpl(operationsApi),
      collaborationRepository: TaskCollaborationRepositoryImpl(operationsApi),
      historyRepository: TaskHistoryRepositoryImpl(advancedApi),
      metadataRepository: TaskMetadataRepositoryImpl(operationsApi),
      recurrenceRepository: TaskRecurrenceRepositoryImpl(
        advancedApi,
        TaskRecurrenceTimeZoneApi(dio, baseUrl: baseUrl),
      ),
      scheduleRepository: TaskScheduleRepositoryImpl(
        TaskScheduleApi(dio, baseUrl: baseUrl),
      ),
      templateRepository: TaskTemplateRepositoryImpl(
        TaskTemplatesApi(dio, baseUrl: baseUrl),
      ),
      timeTrackingRepository: TaskTimeTrackingRepositoryImpl(
        TaskTimeTrackingApi(dio, baseUrl: baseUrl),
      ),
      milestoneRepository: MilestoneRepositoryImpl(
        MilestonesApi(dio, baseUrl: baseUrl),
      ),
      customWorkflowRepository: CustomWorkflowRepositoryImpl(
        CustomWorkflowApi(dio, baseUrl: baseUrl),
      ),
      storageRepository: StorageRepositoryImpl(
        StorageApi(dio, baseUrl: baseUrl),
      ),
      attachmentUploadTransport: TaskAttachmentPresignedUploadTransport(),
      resourceChatRepository: ChatRepositoryImpl(
        ChatApi(dio, baseUrl: baseUrl),
      ),
    );
  }
}
