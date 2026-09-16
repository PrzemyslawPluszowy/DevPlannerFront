import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_global_shell.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/chat_drawer.dart';
import 'package:ready_next/workspaces/presentation/notifications/global_notifications_page.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../support/shell_test_dependencies.dart';

/// Repozytorium Chat zwracające pustą listę bez wykonania rzeczywistego API.
class _EmptyChatRepository implements ChatRepository {
  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() async => const Right([]);

  @override
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  ) async => const Right([]);

  @override
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  }) => throw UnimplementedError();
}

/// Repozytorium powiadomień zwracające puste dane bez wykonania rzeczywistego API.
class _EmptyNotificationsRepository implements NotificationsRepository {
  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>>
  listNotifications({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, CursorPageResponse<NotificationGroupResponse>>>
  listGroups({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, int>> unreadCount() async => const Right(0);

  @override
  Future<Either<ApiError, void>> archiveGroup(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, void>> markAllRead() async => const Right(null);

  @override
  Future<Either<ApiError, void>> markGroupRead(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, void>> quickAction(
    String notificationId,
    NotificationQuickActionKind action,
  ) async => const Right(null);
}

/// Transport SignalR bez połączenia sieciowego dla drawera powiadomień.
class _EmptySignalRTransport implements WorkspaceSignalRTransport {
  @override
  Stream<WorkspaceSignalRConnectionState> get states => const Stream.empty();

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  void dispose() {}

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async => null;

  @override
  void on(String methodName, MethodInvocationFunc handler) {}
}

/// Prywatny child prawdziwego shellu; jest źródłem kontekstu dla obu wejść globalnych.
class _GlobalPanelRouteProbe extends StatefulWidget {
  const _GlobalPanelRouteProbe();

  @override
  State<_GlobalPanelRouteProbe> createState() => _GlobalPanelRouteProbeState();
}

/// Stan private child route sterujący prawdziwymi publicznymi API Chat i Notifications.
class _GlobalPanelRouteProbeState extends State<_GlobalPanelRouteProbe> {
  /// Otwiera globalny panel przez callback podany przez harness.
  void open(VoidCallback callback) => callback();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Prywatna trasa shella')),
  );
}

/// Prawdziwy [AppGlobalShell] osadzony w [GoRouter] z pełnymi zależnościami chrome'u.
class _AppGlobalShellRouterHarness extends StatefulWidget {
  const _AppGlobalShellRouterHarness();

  @override
  State<_AppGlobalShellRouterHarness> createState() =>
      _AppGlobalShellRouterHarnessState();
}

/// Stan hosta udostępniający akcje topbara bez imitowania prywatnego shellu.
class _AppGlobalShellRouterHarnessState
    extends State<_AppGlobalShellRouterHarness> {
  late final ShellTestAuthRepository _authRepository =
      ShellTestAuthRepository();
  late final AuthCubit _authCubit = AuthCubit(authRepository: _authRepository)
    ..emit(
      const AuthAuthenticated(
        user: AuthUser(userId: 7, login: 'tester', displayName: 'Test User'),
      ),
    );
  late final LocalSettingsCubit _settingsCubit = LocalSettingsCubit(
    repository: ShellTestSettingsRepository(),
  );
  late final CurrentUserAvatarCubit _avatarCubit =
      ShellTestDependencies.createAvatarCubit();
  late final _EmptyChatRepository _chatRepository = _EmptyChatRepository();
  late final _EmptyNotificationsRepository _notificationsRepository =
      _EmptyNotificationsRepository();
  late final WorkspaceNotificationsRealtimeService _realtime =
      WorkspaceNotificationsRealtimeService(
        client: _EmptySignalRTransport(),
        notificationsRepository: _notificationsRepository,
      );
  late final AppRouter _chromeRouter = ShellTestDependencies.createRouter(
    authRepository: _authRepository,
  );
  late final GoRouter _router = GoRouter(
    initialLocation: '/private/alpha?tab=files#comment-7',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppGlobalShell(
          appRouter: _chromeRouter,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/private/:workspaceId',
            builder: (context, state) => const _GlobalPanelRouteProbe(),
          ),
        ],
      ),
    ],
  );

  /// Bieżąca lokalizacja prawdziwego GoRoutera z query i fragmentem.
  String get location => _router.routeInformationProvider.value.uri.toString();

  /// Repozytorium przekazywane do rzeczywistego wejścia powiadomień w teście.
  NotificationsRepository get notificationsRepository =>
      _notificationsRepository;

  /// Repozytorium przekazywane do rzeczywistego wejścia Chat w teście.
  ChatRepository get chatRepository => _chatRepository;

  /// Router wymagany przez publiczne API drawera Chat.
  AppRouter get chromeRouter => _chromeRouter;

  @override
  void dispose() {
    unawaited(_authCubit.close());
    unawaited(_settingsCubit.close());
    unawaited(_avatarCubit.close());
    unawaited(_realtime.dispose());
    _chromeRouter.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _authCubit),
      BlocProvider.value(value: _settingsCubit),
      BlocProvider.value(value: _avatarCubit),
    ],
    child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<HostLaunchContext>.value(
          value: const HostLaunchContext(
            initialRoute: '/private/alpha',
            userId: '7',
            userDisplayName: 'Test User',
          ),
        ),
        RepositoryProvider<DashboardPreferencesRepository>.value(
          value: ShellTestDashboardPreferencesRepository(),
        ),
        RepositoryProvider<ChatRepository>.value(value: _chatRepository),
        RepositoryProvider<NotificationsRepository>.value(
          value: _notificationsRepository,
        ),
        RepositoryProvider<WorkspaceNotificationsRealtimeService>.value(
          value: _realtime,
        ),
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    ),
  );
}

void main() {
  testWidgets(
    'AppGlobalShell i GoRouter dopuszczają tylko jeden prawdziwy panel globalny',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 600);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(const _AppGlobalShellRouterHarness());
      await tester.pumpAndSettle();
      final harness = tester.state<_AppGlobalShellRouterHarnessState>(
        find.byType(_AppGlobalShellRouterHarness),
      );
      expect(find.byType(AppGlobalShell), findsOneWidget);

      final privateContext = tester.element(
        find.byType(_GlobalPanelRouteProbe),
      );
      unawaited(
        AppGlobalChatDrawer.show(
          privateContext,
          repository: harness.chatRepository,
          router: harness.chromeRouter,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Chat'), findsOneWidget);
      expect(harness.location, '/private/alpha?tab=files#comment-7');

      await AppGlobalNotificationsDrawer.show(
        privateContext,
        repository: harness.notificationsRepository,
      );
      await tester.pump();
      expect(find.text('Notifications'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Chat'), findsNothing);
      unawaited(
        AppGlobalNotificationsDrawer.show(
          privateContext,
          repository: harness.notificationsRepository,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Notifications'), findsOneWidget);
      expect(harness.location, '/private/alpha?tab=files#comment-7');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    },
  );
}
