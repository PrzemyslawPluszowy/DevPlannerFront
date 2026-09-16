import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_refresh_interceptor.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/config/app_api_module.dart';
import 'package:ready_next/core/config/app_env.dart';
import 'package:ready_next/core/network/app_api_factory.dart';
import 'package:ready_next/features/bhp/data/api/bhp_api.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/workspaces/data/chat/api/chat_api.dart';
import 'package:ready_next/workspaces/data/chat/attachments/chat_attachment_upload_port_adapter.dart';
import 'package:ready_next/workspaces/data/chat/repositories/chat_notification_settings_repository_impl.dart';
import 'package:ready_next/workspaces/data/chat/repositories/chat_repository_impl.dart';
import 'package:ready_next/workspaces/data/corkboard/api/corkboard_api.dart';
import 'package:ready_next/workspaces/data/kanban/api/kanban_api.dart';
import 'package:ready_next/workspaces/data/kanban/repositories/kanban_repository_impl.dart';
import 'package:ready_next/workspaces/data/notifications/api/notifications_api.dart';
import 'package:ready_next/workspaces/data/notifications/repositories/notification_digest_repository_impl.dart';
import 'package:ready_next/workspaces/data/notifications/repositories/notification_preferences_repository_impl.dart';
import 'package:ready_next/workspaces/data/notifications/repositories/notification_reply_repository_impl.dart';
import 'package:ready_next/workspaces/data/notifications/repositories/notifications_repository_impl.dart';
import 'package:ready_next/workspaces/data/okr/api/okr_api.dart';
import 'package:ready_next/workspaces/data/okr/repositories/okr_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/api/projects_api.dart';
import 'package:ready_next/workspaces/data/projects/custom_workflow/api/custom_workflow_api.dart';
import 'package:ready_next/workspaces/data/projects/custom_workflow/repositories/custom_workflow_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/milestones/api/milestones_api.dart';
import 'package:ready_next/workspaces/data/projects/milestones/repositories/milestone_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/repositories/project_member_profiles_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/repositories/project_resources_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/repositories/projects_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_advanced_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_capacity_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_schedule_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_templates_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_time_tracking_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_views_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/tasks_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_acceptance_criteria_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_attachment_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_capacity_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_checklist_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_collaboration_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_history_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_list_configuration_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_metadata_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_recurrence_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_schedule_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_template_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_time_tracking_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_view_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/task_workflow_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/repositories/tasks_repository_impl.dart';
import 'package:ready_next/workspaces/data/projects/tasks/services/task_attachment_presigned_upload_transport.dart';
import 'package:ready_next/workspaces/data/projects/templates/api/project_templates_api.dart';
import 'package:ready_next/workspaces/data/projects/templates/repositories/project_templates_repository_impl.dart';
import 'package:ready_next/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/data/storage/api/storage_api.dart';
import 'package:ready_next/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:ready_next/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:ready_next/workspaces/data/whiteboard/api/whiteboard_api.dart';
import 'package:ready_next/workspaces/data/wiki/api/wiki_api.dart';
import 'package:ready_next/workspaces/data/workspaces/api/automation_api.dart';
import 'package:ready_next/workspaces/data/workspaces/api/workspace_feature_api.dart';
import 'package:ready_next/workspaces/data/workspaces/api/workspaces_api.dart';
import 'package:ready_next/workspaces/data/workspaces/repositories/automation_repository_impl.dart';
import 'package:ready_next/workspaces/data/workspaces/repositories/workspace_features_repository_impl.dart';
import 'package:ready_next/workspaces/data/workspaces/repositories/workspaces_repository_impl.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_digest_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_preferences_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_reply_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/automation_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/kanban_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/milestone_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/okr_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_history_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_template_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_view_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/workspace_features_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Zestaw wspólnych klientów HTTP dla aplikacji i modułów.
class AppHttpClients {
  factory AppHttpClients({
    required String? Function() accessTokenProvider,
    required int Function() sessionGenerationProvider,
    bool enableLogging = kDebugMode,
  }) {
    final sessionRequests = _SessionRequestCancellation();

    return AppHttpClients._(
      inventoryDio: AppApiFactory.createDio(
        baseUrl: AppEnv.apiBaseUrlFor(AppApiModule.inventory),
        module: AppApiModule.inventory,
        accessTokenProvider: accessTokenProvider,
        cancelTokenProvider: () => sessionRequests.token,
        sessionGenerationProvider: sessionGenerationProvider,
        enableLogging: enableLogging,
      ),
      authDio: AppApiFactory.createAuthDio(
        baseUrl: AppEnv.apiBaseUrlFor(AppApiModule.auth),
        module: AppApiModule.auth,
        enableLogging: enableLogging,
      ),
      coreDio: AppApiFactory.createDio(
        baseUrl: AppEnv.apiBaseUrlFor(AppApiModule.auth),
        module: AppApiModule.auth,
        accessTokenProvider: accessTokenProvider,
        cancelTokenProvider: () => sessionRequests.token,
        sessionGenerationProvider: sessionGenerationProvider,
        enableLogging: enableLogging,
      ),
      bhpDio: AppApiFactory.createDio(
        baseUrl: AppEnv.apiBaseUrlFor(AppApiModule.bhp),
        module: AppApiModule.bhp,
        accessTokenProvider: accessTokenProvider,
        cancelTokenProvider: () => sessionRequests.token,
        sessionGenerationProvider: sessionGenerationProvider,
        enableLogging: enableLogging,
      ),
      workspacesDio: AppApiFactory.createDio(
        baseUrl: AppEnv.apiBaseUrlFor(AppApiModule.workspaces),
        module: AppApiModule.workspaces,
        accessTokenProvider: accessTokenProvider,
        cancelTokenProvider: () => sessionRequests.token,
        sessionGenerationProvider: sessionGenerationProvider,
        enableLogging: enableLogging,
      ),
      sessionRequests: sessionRequests,
    );
  }

  AppHttpClients._({
    required this.inventoryDio,
    required this.authDio,
    required this.coreDio,
    required this.bhpDio,
    required this.workspacesDio,
    required this._sessionRequests,
  });

  final Dio inventoryDio;
  final Dio authDio;
  final Dio coreDio;
  final Dio bhpDio;
  final Dio workspacesDio;
  final _SessionRequestCancellation _sessionRequests;

  /// Anuluje żądania modułów należące do kończonej sesji użytkownika.
  void cancelAuthenticatedRequests() {
    _sessionRequests.cancel();
  }

  void attachRefreshInterceptors({
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  }) {
    for (final dio in [inventoryDio, bhpDio, workspacesDio, coreDio]) {
      dio.interceptors.add(
        AuthRefreshInterceptor(
          dio: dio,
          authRepository: authRepository,
          onLogout: authCubit.logout,
        ),
      );
    }
  }

  void attachSentry() {
    if (!kReleaseMode || AppEnv.sentryDsn.trim().isEmpty) {
      return;
    }

    for (final dio in [inventoryDio, authDio, coreDio, bhpDio, workspacesDio]) {
      dio.addSentry(
        failedRequestStatusCodes: [
          SentryStatusCode.range(100, 199),
          SentryStatusCode.range(300, 599),
        ],
        captureFailedRequests: true,
      );
    }
  }

  void dispose() {
    bhpDio.close(force: true);
    coreDio.close(force: true);
    authDio.close(force: true);
    inventoryDio.close(force: true);
    workspacesDio.close(force: true);
  }
}

/// Współdzieli token anulowania pomiędzy klientami modułów jednej sesji.
class _SessionRequestCancellation {
  CancelToken _token = CancelToken();

  /// Token używany przez wszystkie nowe żądania modułów.
  CancelToken get token => _token;

  /// Anuluje bieżącą grupę żądań i przygotowuje token dla następnej sesji.
  void cancel() {
    _token.cancel('Sesja użytkownika została zakończona.');
    _token = CancelToken();
  }
}

/// Binding repozytoriów dla modułu BHP.
class BhpModuleBindings {
  factory BhpModuleBindings({required Dio dio}) {
    final api = BhpApi(dio);

    return BhpModuleBindings._(
      dashboardRepository: BhpDashboardRepositoryImpl(api: api),
      usersRepository: BhpUsersRepositoryImpl(api: api),
      positionsRepository: BhpPositionsRepositoryImpl(api: api),
      equipmentRepository: BhpEquipmentRepositoryImpl(api: api),
    );
  }

  BhpModuleBindings._({
    required this.dashboardRepository,
    required this.usersRepository,
    required this.positionsRepository,
    required this.equipmentRepository,
  });

  final BhpDashboardRepository dashboardRepository;
  final BhpUsersRepository usersRepository;
  final BhpPositionsRepository positionsRepository;
  final BhpEquipmentRepository equipmentRepository;
}

/// Binding repozytoriów dla modułu Workspaces.
class WorkspacesModuleBindings {
  /// Tworzy repozytoria Workspaces z uwierzytelnionego klienta HTTP.
  factory WorkspacesModuleBindings({
    required Dio dio,
    required Future<String?> Function() accessTokenProvider,
  }) {
    final api = WorkspacesApi(dio);
    final projectsApi = ProjectsApi(dio);
    final customWorkflowApi = CustomWorkflowApi(dio);
    final milestonesApi = MilestonesApi(dio);
    final tasksApi = TasksApi(dio);
    final taskOperationsApi = TaskOperationsApi(dio);
    final taskScheduleApi = TaskScheduleApi(dio);
    final taskAdvancedApi = TaskAdvancedApi(dio);
    final taskCapacityApi = TaskCapacityApi(dio);
    final taskTemplatesApi = TaskTemplatesApi(dio);
    final taskTimeTrackingApi = TaskTimeTrackingApi(dio);
    final taskViewsApi = TaskViewsApi(dio);
    final kanbanApi = KanbanApi(
      dio,
      errorLogger: const KanbanParseErrorLogger(),
    );
    final whiteboardApi = WhiteboardApi(dio);
    final wikiApi = WikiApi(dio);
    final storageApi = StorageApi(dio);
    final automationApi = AutomationApi(dio);
    final corkboardApi = CorkboardApi(dio);
    final notificationsApi = NotificationsApi(dio);
    final okrApi = OkrApi(dio);
    final chatApi = ChatApi(dio);
    final notificationsRepository = NotificationsRepositoryImpl(
      notificationsApi,
    );
    final notificationPreferencesRepository =
        NotificationPreferencesRepositoryImpl(notificationsApi);
    final notificationDigestRepository = NotificationDigestRepositoryImpl(
      notificationsApi,
    );
    final notificationReplyRepository = NotificationReplyRepositoryImpl(
      notificationsApi,
    );
    final projectTemplatesApi = ProjectTemplatesApi(dio);
    final projectTemplatesRepository = ProjectTemplatesRepositoryImpl(
      api: projectTemplatesApi,
    );
    final workspaceFeatureApi = WorkspaceFeatureApi(dio);
    final realtimeBaseUrl = AppEnv.apiBaseUrlFor(
      AppApiModule.workspaces,
    ).replaceFirst(RegExp(r'/+$'), '');
    final chatRepository = ChatRepositoryImpl(chatApi);
    final chatNotificationSettingsRepository =
        ChatNotificationSettingsRepositoryImpl(chatApi);
    final storageRepository = StorageRepositoryImpl(storageApi);
    final chatAttachmentUploadPort = ChatAttachmentUploadPortAdapter(
      sessionRepository: chatRepository,
      storageRepository: storageRepository,
      uploadTransport: PresignedUploadTransport(),
    );
    return WorkspacesModuleBindings._(
      workspacesRepository: WorkspacesRepositoryImpl(api: api),
      workspaceFeaturesRepository: WorkspaceFeaturesRepositoryImpl(
        workspaceFeatureApi,
      ),
      projectsRepository: ProjectsRepositoryImpl(api: projectsApi),
      projectTemplatesRepository: projectTemplatesRepository,
      projectMemberProfilesRepository: ProjectMemberProfilesRepositoryImpl(
        api: projectsApi,
      ),
      milestoneRepository: MilestoneRepositoryImpl(milestonesApi),
      tasksRepository: TasksRepositoryImpl(tasksApi),
      taskAttachmentRepository: TaskAttachmentRepositoryImpl(taskOperationsApi),
      taskAttachmentUploadTransport: TaskAttachmentPresignedUploadTransport(),
      taskAcceptanceCriteriaRepository: TaskAcceptanceCriteriaRepositoryImpl(
        taskOperationsApi,
      ),
      taskChecklistRepository: TaskChecklistRepositoryImpl(taskOperationsApi),
      taskCapacityRepository: TaskCapacityRepositoryImpl(taskCapacityApi),
      taskCollaborationRepository: TaskCollaborationRepositoryImpl(
        taskOperationsApi,
      ),
      taskMetadataRepository: TaskMetadataRepositoryImpl(taskOperationsApi),
      taskHistoryRepository: TaskHistoryRepositoryImpl(taskAdvancedApi),
      taskRecurrenceRepository: TaskRecurrenceRepositoryImpl(taskAdvancedApi),
      taskScheduleRepository: TaskScheduleRepositoryImpl(taskScheduleApi),
      taskTemplateRepository: TaskTemplateRepositoryImpl(taskTemplatesApi),
      taskTimeTrackingRepository: TaskTimeTrackingRepositoryImpl(
        taskTimeTrackingApi,
      ),
      taskViewRepository: TaskViewRepositoryImpl(taskViewsApi),
      taskListConfigurationRepository: TaskListConfigurationRepositoryImpl(dio),
      taskWorkflowRepository: TaskWorkflowRepositoryImpl(taskAdvancedApi),
      customWorkflowRepository: CustomWorkflowRepositoryImpl(customWorkflowApi),
      kanbanRepository: KanbanRepositoryImpl(kanbanApi),
      automationRepository: AutomationRepositoryImpl(automationApi),
      projectResourcesRepository: ProjectResourcesRepositoryImpl(
        tasksApi: tasksApi,
        whiteboardApi: whiteboardApi,
        wikiApi: wikiApi,
        storageApi: storageApi,
        automationApi: automationApi,
        corkboardApi: corkboardApi,
      ),
      storageRepository: storageRepository,
      okrRepository: OkrRepositoryImpl(api: okrApi),
      notificationsRepository: notificationsRepository,
      notificationPreferencesRepository: notificationPreferencesRepository,
      notificationDigestRepository: notificationDigestRepository,
      notificationReplyRepository: notificationReplyRepository,
      chatRepository: chatRepository,
      chatNotificationSettingsRepository: chatNotificationSettingsRepository,
      chatAttachmentUploadPort: chatAttachmentUploadPort,
      resourceChatRepository: chatRepository,
      notificationsRealtime: WorkspaceNotificationsRealtimeService(
        client: WorkspaceSignalRClient(
          '$realtimeBaseUrl/api/v1/realtime/notifications',
          accessTokenProvider,
        ),
        notificationsRepository: notificationsRepository,
      ),
      chatRealtimeFactory: WorkspaceChatRealtimeFactory(
        baseUrl: realtimeBaseUrl,
        accessTokenProvider: accessTokenProvider,
      ),
      scopedRealtimeFactory: WorkspaceScopedRealtimeFactory(
        baseUrl: realtimeBaseUrl,
        accessTokenProvider: accessTokenProvider,
      ),
    );
  }

  WorkspacesModuleBindings._({
    required this.workspacesRepository,
    required this.workspaceFeaturesRepository,
    required this.projectsRepository,
    required this.projectTemplatesRepository,
    required this.projectMemberProfilesRepository,
    required this.milestoneRepository,
    required this.tasksRepository,
    required this.taskAttachmentRepository,
    required this.taskAttachmentUploadTransport,
    required this.taskAcceptanceCriteriaRepository,
    required this.taskChecklistRepository,
    required this.taskCapacityRepository,
    required this.taskCollaborationRepository,
    required this.taskMetadataRepository,
    required this.taskHistoryRepository,
    required this.taskRecurrenceRepository,
    required this.taskScheduleRepository,
    required this.taskTemplateRepository,
    required this.taskTimeTrackingRepository,
    required this.taskViewRepository,
    required this.taskListConfigurationRepository,
    required this.taskWorkflowRepository,
    required this.customWorkflowRepository,
    required this.kanbanRepository,
    required this.automationRepository,
    required this.projectResourcesRepository,
    required this.storageRepository,
    required this.okrRepository,
    required this.notificationsRepository,
    required this.notificationPreferencesRepository,
    required this.notificationDigestRepository,
    required this.notificationReplyRepository,
    required this.chatRepository,
    required this.chatNotificationSettingsRepository,
    required this.chatAttachmentUploadPort,
    required this.resourceChatRepository,
    required this.notificationsRealtime,
    required this.chatRealtimeFactory,
    required this.scopedRealtimeFactory,
  });

  /// Repozytorium listy i podstawowych operacji workspace.
  final WorkspacesRepository workspacesRepository;

  /// Repozytorium dashboardów, wyszukiwania i aktywności workspace.
  final WorkspaceFeaturesRepository workspaceFeaturesRepository;

  /// Repozytorium projektów ładowanych leniwie po rozwinięciu workspace’u.
  final ProjectsRepository projectsRepository;

  /// Repozytorium szablonów projektów w workspace.
  final ProjectTemplatesRepository projectTemplatesRepository;

  /// Profile osób ograniczone do ACL konkretnego projektu.
  final ProjectMemberProfilesRepository projectMemberProfilesRepository;
  final MilestoneRepository milestoneRepository;

  /// Repozytorium podstawowego agregatu zadań projektu.
  final TasksRepository tasksRepository;

  /// Repozytorium załączników zadania i kontrolowanego bulk uploadu.
  final TaskAttachmentRepository taskAttachmentRepository;
  final TaskAttachmentUploadTransport taskAttachmentUploadTransport;

  /// Repozytorium atomowych mutacji kryteriów akceptacji zadania.
  final TaskAcceptanceCriteriaRepository taskAcceptanceCriteriaRepository;

  /// Repozytorium atomowych mutacji checklisty zadania.
  final TaskChecklistRepository taskChecklistRepository;
  final TaskCapacityRepository taskCapacityRepository;
  final TaskCollaborationRepository taskCollaborationRepository;
  final TaskMetadataRepository taskMetadataRepository;
  final TaskHistoryRepository taskHistoryRepository;
  final TaskRecurrenceRepository taskRecurrenceRepository;
  final TaskScheduleRepository taskScheduleRepository;
  final TaskTemplateRepository taskTemplateRepository;
  final TaskTimeTrackingRepository taskTimeTrackingRepository;
  final TaskViewRepository taskViewRepository;
  final TaskListConfigurationRepository taskListConfigurationRepository;
  final TaskWorkflowRepository taskWorkflowRepository;
  final CustomWorkflowRepository customWorkflowRepository;

  /// Repozytorium tablicy Kanban, DnD, bulk actions i jej ustawień.
  final KanbanRepository kanbanRepository;
  final AutomationRepository automationRepository;

  /// Repozytorium zasobów projektu ładowanych dopiero po rozwinięciu gałęzi.
  final ProjectResourcesRepository projectResourcesRepository;

  /// Repozytorium szczegółów plików dla bezpośrednich tras Storage.
  final StorageRepository storageRepository;

  /// Repozytorium celu OKR dla deep-linków i kontekstu workspace’u.
  final OkrRepository okrRepository;

  /// Repozytorium globalnej skrzynki powiadomień.
  final NotificationsRepository notificationsRepository;

  /// Port osobistych ustawień dostarczania powiadomień.
  final NotificationPreferencesRepository notificationPreferencesRepository;

  /// Port read-only snapshotu digestu powiadomień.
  final NotificationDigestRepository notificationDigestRepository;

  /// Port idempotentnej odpowiedzi Chat z pojedynczego powiadomienia.
  final NotificationReplyRepository notificationReplyRepository;

  /// Repozytorium rozmów globalnego Chat.
  final ChatRepository chatRepository;

  /// Port globalnych i per-rozmowa ustawień dostarczania Chat.
  final ChatNotificationSettingsRepository chatNotificationSettingsRepository;

  /// Port uploadu Chat kompozyjnie łączący sesje, Storage i presigned PUT.
  final ChatAttachmentUploadPort chatAttachmentUploadPort;

  final ResourceChatRepository resourceChatRepository;

  /// Lifecycle huba globalnych powiadomień dla aktualnej sesji.
  final WorkspaceNotificationsRealtimeService notificationsRealtime;

  /// Tworzy lokalny transport Chat dla konkretnego ekranu rozmowy.
  final WorkspaceChatRealtimeFactory chatRealtimeFactory;

  /// Tworzy zakresowy transport Tasks, Whiteboard albo Wiki dla jednego ekranu.
  final WorkspaceScopedRealtimeFactory scopedRealtimeFactory;

  /// Zamyka transport realtime przed zamknięciem aplikacji.
  Future<void> dispose() => notificationsRealtime.dispose();
}
