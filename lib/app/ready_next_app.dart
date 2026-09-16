// Importy istniejącego pliku są grupowane historycznie według modułów DI.
// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:ready_next/app/modules/app_runtime_bindings.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/router/auth_redirect_policy.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_api.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_session_storage.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/config/app_env.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/dashboard/data/api/dashboard_preferences_api.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/data/repositories/synchronized_dashboard_preferences_repository.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/features/settings/data/repositories/local_settings_repository.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:ready_next/workspaces/data/chat/repositories/secure_chat_draft_repository.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:ready_next/workspaces/data/storage/transport/file_picker_port_impl.dart';
import 'package:ready_next/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:ready_next/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:ready_next/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:ready_next/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_digest_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/chat_notification_settings_repository.dart';
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
import 'package:sentry_flutter/sentry_flutter.dart';

/// Glowny widget aplikacji.
///
/// Dostaje gotowy kontekst startowy i sesje z bootstrapa, a potem:
/// - podpina theme,
/// - ustawia trase startowa,
/// - deleguje budowanie ekranow do routera.
class ReadyNextApp extends StatefulWidget {
  const ReadyNextApp({
    required this.launchContext,
    super.key,
    this.initialSettings,
    this.authSessionStorage,
    this.authRepository,
    this.dashboardPreferencesRepository,
    this.enableNotificationsRealtime = true,
  });

  final HostLaunchContext launchContext;
  final LocalSettingsModel? initialSettings;
  final AuthSessionStorage? authSessionStorage;
  final AuthRepository? authRepository;

  /// Opcjonalne źródło preferencji pulpitu, wykorzystywane przez testy
  /// uruchamiające aplikację bez połączenia z Core.
  final DashboardPreferencesRepository? dashboardPreferencesRepository;

  /// Pozwala testom widgetowym nie otwierać zewnętrznego huba SignalR.
  ///
  /// Produkcja zachowuje domyślne uruchamianie realtime po uwierzytelnieniu.
  final bool enableNotificationsRealtime;

  @override
  State<ReadyNextApp> createState() => _ReadyNextAppState();
}

/// Stan glownego widgetu aplikacji.
class _ReadyNextAppState extends State<ReadyNextApp> {
  late final MaterialTheme _theme;
  late final AuthSessionStorage _authSessionStorage;
  late final AuthRepository _authRepository;
  late final AuthCubit _authCubit;
  late final LocalSettingsCubit _localSettingsCubit;
  late final DashboardPreferencesRepository _dashboardPreferencesRepository;
  late final LocalSettingsRepository _localSettingsRepository;
  late final AppHttpClients _httpClients;
  late final BhpModuleBindings _bhpBindings;
  late final WorkspacesModuleBindings _workspacesBindings;
  late final AppRouter _appRouter;
  late final Future<void> _restoreSessionFuture;

  Future<void> _restoreSessionAndScheduleStartupNavigation() async {
    await _authCubit.restoreSession();
  }

  ThemeData _buildLightTheme(
    MaterialTheme theme,
    LocalSettingsModel settings,
  ) {
    return switch (settings.themePalette) {
      AppThemePalette.classic => theme.light(),
      AppThemePalette.material => theme.theme(
        ColorScheme.fromSeed(
          seedColor: _seedColor(settings.themeSeedColor),
        ),
      ),
    };
  }

  ThemeData _buildDarkTheme(
    MaterialTheme theme,
    LocalSettingsModel settings,
  ) {
    return switch (settings.themePalette) {
      AppThemePalette.classic => theme.dark(),
      AppThemePalette.material => theme.theme(
        ColorScheme.fromSeed(
          seedColor: _seedColor(settings.themeSeedColor),
          brightness: Brightness.dark,
        ),
      ),
    };
  }

  Color _seedColor(AppThemeSeedColor color) => switch (color) {
    AppThemeSeedColor.blue => const Color(0xff0b57d0),
    AppThemeSeedColor.emerald => const Color(0xff0f766e),
    AppThemeSeedColor.amber => const Color(0xffb45309),
    AppThemeSeedColor.rose => const Color(0xffbe185d),
    AppThemeSeedColor.violet => const Color(0xff6d28d9),
    AppThemeSeedColor.teal => const Color(0xff0d9488),
    AppThemeSeedColor.indigo => const Color(0xff4338ca),
    AppThemeSeedColor.orange => const Color(0xffc2410c),
    AppThemeSeedColor.crimson => const Color(0xffbe123c),
  };

  String _currentRoutePath() {
    final path = _appRouter.currentPath.trim();
    if (path.isNotEmpty && path != '/') return path;
    final launchPath = widget.launchContext.initialRoute.trim();
    if (launchPath.isNotEmpty && launchPath != '/') return launchPath;
    return AppRoutePaths.dashboard;
  }

  String _currentRouteLocation() {
    final currentUrl = _appRouter.currentPath.trim();
    final launchPath = widget.launchContext.initialRoute.trim();
    if ((currentUrl.isEmpty ||
            currentUrl == '/' ||
            currentUrl == AppRoutePaths.dashboard) &&
        launchPath.isNotEmpty &&
        launchPath != AppRoutePaths.dashboard) {
      return launchPath;
    }
    if (currentUrl.isNotEmpty) {
      return currentUrl;
    }
    return launchPath;
  }

  void _handleAuthStateChanged(AuthState state) {
    _handleNotificationsRealtime(state);
    final currentLocation = _currentRouteLocation();
    final currentPath = _currentRoutePath();
    if (shouldRedirectFromLoginOnAuthenticated(
      state: state,
      currentPath: currentPath,
    )) {
      unawaited(
        _appRouter.replacePath(
          resolvePostLoginPath(
            currentLocation: currentLocation,
            fallbackPath: widget.launchContext.initialRoute,
          ),
        ),
      );
      return;
    }

    if (!shouldRedirectToLoginOnUnauthenticated(
      state: state,
      currentPath: currentPath,
    )) {
      return;
    }

    unawaited(
      _appRouter.replacePath(buildLoginPath(redirectTo: currentLocation)),
    );
  }

  void _handleNotificationsRealtime(AuthState state) {
    if (!widget.enableNotificationsRealtime) return;
    if (state is AuthAuthenticated) {
      unawaited(
        _workspacesBindings.notificationsRealtime.start().catchError((
          Object error,
        ) {
          if (kDebugMode) {
            debugPrint('[REALTIME][NOTIFICATIONS] start failed: $error');
          }
        }),
      );
      return;
    }

    unawaited(_workspacesBindings.notificationsRealtime.stop());
  }

  @override
  void initState() {
    super.initState();
    _theme = MaterialTheme.crm();
    _authSessionStorage = widget.authSessionStorage ?? HiveAuthSessionStorage();
    _httpClients = AppHttpClients(
      accessTokenProvider: () => _authRepository.accessToken,
      sessionGenerationProvider: () => _authRepository.sessionGeneration,
    );
    final authApi = DioAuthApi(api: CoreAuthApi(_httpClients.authDio));
    _authRepository =
        widget.authRepository ??
        AuthRepositoryImpl(
          api: authApi,
          storage: _authSessionStorage,
        );
    _authCubit = AuthCubit(
      authRepository: _authRepository,
      beforeLogout: () async {
        _httpClients.cancelAuthenticatedRequests();
        await _workspacesBindings.notificationsRealtime.stop();
      },
    );
    _dashboardPreferencesRepository =
        widget.dashboardPreferencesRepository ??
        SynchronizedDashboardPreferencesRepository(
          api: DashboardPreferencesApi(_httpClients.coreDio),
          localRepository: HiveDashboardPreferencesRepository(),
        );
    _localSettingsRepository = HiveLocalSettingsRepository();
    _localSettingsCubit = LocalSettingsCubit(
      repository: _localSettingsRepository,
      initialState: widget.initialSettings,
    );
    unawaited(_localSettingsCubit.load());

    _httpClients.attachRefreshInterceptors(
      authRepository: _authRepository,
      authCubit: _authCubit,
    );
    _httpClients.attachSentry();
    _bhpBindings = BhpModuleBindings(dio: _httpClients.bhpDio);
    _workspacesBindings = WorkspacesModuleBindings(
      dio: _httpClients.workspacesDio,
      accessTokenProvider: () async => _authRepository.accessToken,
    );

    _appRouter = AppRouter(
      authRepository: _authRepository,
      ensureSessionRestored: () => _restoreSessionFuture,
      initialLocation: resolvePlatformInitialLocation(
        platformUri: Uri.base,
        isWeb: kIsWeb,
        launchPath: widget.launchContext.initialRoute,
      ),
      navigatorObservers: !kReleaseMode || AppEnv.sentryDsn.trim().isEmpty
          ? const []
          : [SentryNavigatorObserver()],
    );
    _restoreSessionFuture = _restoreSessionAndScheduleStartupNavigation();
  }

  @override
  void dispose() {
    unawaited(_authCubit.close());
    unawaited(_localSettingsCubit.close());
    unawaited(_localSettingsRepository.close());
    unawaited(_dashboardPreferencesRepository.close());
    unawaited(_workspacesBindings.dispose());
    _appRouter.dispose();
    _httpClients.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jeden punkt tworzenia motywu, z ktorego korzysta cale MaterialApp.

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HostLaunchContext>.value(
          value: widget.launchContext,
        ),
        RepositoryProvider<Dio>.value(value: _httpClients.inventoryDio),
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<AuthSessionStorage>.value(
          value: _authSessionStorage,
        ),
        RepositoryProvider<ChatDraftRepository>(
          create: (_) => SecureChatDraftRepository(),
        ),
        RepositoryProvider<DashboardPreferencesRepository>.value(
          value: _dashboardPreferencesRepository,
        ),
        RepositoryProvider<BhpDashboardRepository>.value(
          value: _bhpBindings.dashboardRepository,
        ),
        RepositoryProvider<BhpUsersRepository>.value(
          value: _bhpBindings.usersRepository,
        ),
        RepositoryProvider<BhpPositionsRepository>.value(
          value: _bhpBindings.positionsRepository,
        ),
        RepositoryProvider<BhpEquipmentRepository>.value(
          value: _bhpBindings.equipmentRepository,
        ),
        RepositoryProvider<WorkspacesRepository>.value(
          value: _workspacesBindings.workspacesRepository,
        ),
        RepositoryProvider<WorkspaceFeaturesRepository>.value(
          value: _workspacesBindings.workspaceFeaturesRepository,
        ),
        RepositoryProvider<ProjectsRepository>.value(
          value: _workspacesBindings.projectsRepository,
        ),
        RepositoryProvider<ProjectTemplatesRepository>.value(
          value: _workspacesBindings.projectTemplatesRepository,
        ),
        RepositoryProvider<ProjectMemberProfilesRepository>.value(
          value: _workspacesBindings.projectMemberProfilesRepository,
        ),
        RepositoryProvider<MilestoneRepository>.value(
          value: _workspacesBindings.milestoneRepository,
        ),
        RepositoryProvider<ProjectResourcesRepository>.value(
          value: _workspacesBindings.projectResourcesRepository,
        ),
        RepositoryProvider<TasksRepository>.value(
          value: _workspacesBindings.tasksRepository,
        ),
        RepositoryProvider<TaskAttachmentRepository>.value(
          value: _workspacesBindings.taskAttachmentRepository,
        ),
        RepositoryProvider<TaskAttachmentUploadTransport>.value(
          value: _workspacesBindings.taskAttachmentUploadTransport,
        ),
        RepositoryProvider<TaskAcceptanceCriteriaRepository>.value(
          value: _workspacesBindings.taskAcceptanceCriteriaRepository,
        ),
        RepositoryProvider<TaskChecklistRepository>.value(
          value: _workspacesBindings.taskChecklistRepository,
        ),
        RepositoryProvider<TaskCapacityRepository>.value(
          value: _workspacesBindings.taskCapacityRepository,
        ),
        RepositoryProvider<TaskCollaborationRepository>.value(
          value: _workspacesBindings.taskCollaborationRepository,
        ),
        RepositoryProvider<TaskMetadataRepository>.value(
          value: _workspacesBindings.taskMetadataRepository,
        ),
        RepositoryProvider<TaskHistoryRepository>.value(
          value: _workspacesBindings.taskHistoryRepository,
        ),
        RepositoryProvider<TaskRecurrenceRepository>.value(
          value: _workspacesBindings.taskRecurrenceRepository,
        ),
        RepositoryProvider<TaskScheduleRepository>.value(
          value: _workspacesBindings.taskScheduleRepository,
        ),
        RepositoryProvider<TaskTemplateRepository>.value(
          value: _workspacesBindings.taskTemplateRepository,
        ),
        RepositoryProvider<TaskTimeTrackingRepository>.value(
          value: _workspacesBindings.taskTimeTrackingRepository,
        ),
        RepositoryProvider<TaskViewRepository>.value(
          value: _workspacesBindings.taskViewRepository,
        ),
        RepositoryProvider<TaskListConfigurationRepository>.value(
          value: _workspacesBindings.taskListConfigurationRepository,
        ),
        RepositoryProvider<TaskWorkflowRepository>.value(
          value: _workspacesBindings.taskWorkflowRepository,
        ),
        RepositoryProvider<CustomWorkflowRepository>.value(
          value: _workspacesBindings.customWorkflowRepository,
        ),
        RepositoryProvider<KanbanRepository>.value(
          value: _workspacesBindings.kanbanRepository,
        ),
        RepositoryProvider<AutomationRepository>.value(
          value: _workspacesBindings.automationRepository,
        ),
        RepositoryProvider<StorageRepository>.value(
          value: _workspacesBindings.storageRepository,
        ),
        RepositoryProvider<OkrRepository>.value(
          value: _workspacesBindings.okrRepository,
        ),
        RepositoryProvider<NotificationsRepository>.value(
          value: _workspacesBindings.notificationsRepository,
        ),
        RepositoryProvider<NotificationPreferencesRepository>.value(
          value: _workspacesBindings.notificationPreferencesRepository,
        ),
        RepositoryProvider<NotificationDigestRepository>.value(
          value: _workspacesBindings.notificationDigestRepository,
        ),
        RepositoryProvider<NotificationReplyRepository>.value(
          value: _workspacesBindings.notificationReplyRepository,
        ),
        RepositoryProvider<ChatNotificationSettingsRepository>.value(
          value: _workspacesBindings.chatNotificationSettingsRepository,
        ),
        RepositoryProvider<WorkspaceNotificationsRealtimeService>.value(
          value: _workspacesBindings.notificationsRealtime,
        ),
        RepositoryProvider<WorkspaceChatRealtimeFactory>.value(
          value: _workspacesBindings.chatRealtimeFactory,
        ),
        RepositoryProvider<WorkspaceScopedRealtimeFactory>.value(
          value: _workspacesBindings.scopedRealtimeFactory,
        ),
        RepositoryProvider<ChatRepository>.value(
          value: _workspacesBindings.chatRepository,
        ),
        RepositoryProvider<ChatConversationRepository>.value(
          value:
              _workspacesBindings.chatRepository as ChatConversationRepository,
        ),
        RepositoryProvider<ChatMessageActionsRepository>.value(
          value:
              _workspacesBindings.chatRepository
                  as ChatMessageActionsRepository,
        ),
        RepositoryProvider<ChatThreadRepository>.value(
          value: _workspacesBindings.chatRepository as ChatThreadRepository,
        ),
        RepositoryProvider<ChatDiscussionRepository>.value(
          value: _workspacesBindings.chatRepository as ChatDiscussionRepository,
        ),
        RepositoryProvider<ChatAttachmentUploadPort>.value(
          value: _workspacesBindings.chatAttachmentUploadPort,
        ),
        RepositoryProvider<FilePickerPort>(
          create: (_) => const FilePickerPortImpl(),
        ),
        RepositoryProvider<ResourceChatRepository>.value(
          value: _workspacesBindings.resourceChatRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: _authCubit),
          BlocProvider<LocalSettingsCubit>.value(value: _localSettingsCubit),
          BlocProvider<CurrentUserAvatarCubit>(
            create: (context) => CurrentUserAvatarCubit(
              storageRepository: _workspacesBindings.storageRepository,
              uploadTransport:
                  _workspacesBindings.taskAttachmentUploadTransport,
            ),
          ),
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            final avatarCubit = context.read<CurrentUserAvatarCubit>();
            if (state is AuthAuthenticated) {
              // Ładujemy avatar raz na wejście do sesji, a nie dopiero po
              // otwarciu Ustawień. Dzięki temu globalny rail nie "przeskakuje"
              // między inicjałami a obrazem po zmianie ekranu.
              unawaited(avatarCubit.load());
            } else {
              avatarCubit.clear();
            }
            _handleAuthStateChanged(state);
          },
          child: BlocBuilder<LocalSettingsCubit, LocalSettingsModel>(
            builder: (context, settingsState) {
              return MaterialApp.router(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)!.appName,
                debugShowCheckedModeBanner: false,
                locale: Locale(
                  switch (settingsState.language) {
                    AppLanguage.pl => 'pl',
                    AppLanguage.en => 'en',
                  },
                ),
                supportedLocales: const [Locale('pl'), Locale('en')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FlutterQuillLocalizations.delegate,
                ],
                theme: _buildLightTheme(_theme, settingsState),
                darkTheme: _buildDarkTheme(_theme, settingsState),
                themeMode: settingsState.themeMode,
                routerConfig: _appRouter.config,
                builder: (context, child) {
                  return ListenableProvider<AppRouter>.value(
                    value: _appRouter,
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
