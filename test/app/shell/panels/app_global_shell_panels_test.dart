import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_global_shell.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/app/shell/panels/app_global_panels_scope.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/chat_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_open_request.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:ready_next/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../support/shell_test_dependencies.dart';

/// Klucze dla geometrii contentu i prywatnej trasy paneli.
abstract final class AppGlobalShellPanelsTestKeys {
  /// Akcja contentu służąca do wykrywania blokady tła.
  static const contentAction = ValueKey<String>('panels-content-action');
}

/// Chat repozytorium z jedną rozmową do testu wyboru w przypiętym panelu.
class _PanelsChatRepository
    implements ChatRepository, ChatConversationRepository {
  _PanelsChatRepository({this.denyConversation = false});

  final bool denyConversation;

  static final ChatConversationResponse _conversation =
      ChatConversationResponse(
        id: '11111111-1111-4111-8111-111111111111',
        type: ChatConversationType.channel,
        scopeKind: ChatScopeKind.workspace,
        scopeKey: 'workspace:alpha',
        name: 'Rozmowa Alpha',
        version: 1,
        createdAtUtc: DateTime(2026),
      );

  static final ChatConversation _conversationSnapshot = ChatConversation(
    id: _conversation.id,
    type: 'Channel',
    scopeKind: 'Workspace',
    scopeKey: _conversation.scopeKey,
    version: _conversation.version,
    createdAtUtc: _conversation.createdAtUtc,
    postingPermission: 'Everyone',
    isArchived: false,
    name: _conversation.name,
  );

  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() async => Right([_conversation]);

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

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) async => denyConversation
      ? const Left(
          ApiError(type: ApiErrorType.forbidden, message: 'Dostęp cofnięty.'),
        )
      : Right(_conversationSnapshot);

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async => const Right(ChatMessagePage(items: []));

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) => throw UnimplementedError();
}

/// Puste repozytorium powiadomień, bez transportu i efektów zewnętrznych.
class _PanelsNotificationsRepository implements NotificationsRepository {
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

/// Pusty magazyn draftów pozwala renderować composer panelu bez persystencji.
class _PanelsChatDraftRepository implements ChatDraftRepository {
  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {}

  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async => null;

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {}
}

/// Picker testowy nie dotyka platformy ani systemu plików.
class _PanelsFilePickerPort implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async => const <StorageUploadInput>[];
}

/// Upload nie jest przedmiotem testów shellu i nie może wykonać transportu.
class _PanelsChatAttachmentUploadPort implements ChatAttachmentUploadPort {
  Never _unsupported() => throw UnsupportedError('Nie użyto uploadu w teście.');

  @override
  Future<void> cancelSession(String conversationId, String sessionId) async =>
      _unsupported();

  @override
  Future<void> complete(String storageFileId) async => _unsupported();

  @override
  Future<ChatAttachmentUploadSession> createSession(
    String conversationId,
  ) async => _unsupported();

  @override
  Future<ChatAttachmentTicket> createTicket({
    required String sessionId,
    required StorageUploadInput input,
  }) async => _unsupported();

  @override
  Future<ChatAttachmentRemoteStatus> status(String storageFileId) async =>
      _unsupported();

  @override
  Future<void> upload(
    ChatAttachmentTicket ticket,
    StorageUploadInput input,
  ) async => _unsupported();
}

/// SignalR bez sieci dla renderowania globalnego drawera powiadomień.
class _PanelsSignalRTransport implements WorkspaceSignalRTransport {
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

/// Prywatna strona z mierzalną akcją w tle globalnego panelu.
class _PanelsPrivateRoute extends StatefulWidget {
  const _PanelsPrivateRoute();

  @override
  State<_PanelsPrivateRoute> createState() => _PanelsPrivateRouteState();
}

/// Stan strony potwierdzający, że overlay nie przepuszcza pointer eventów.
class _PanelsPrivateRouteState extends State<_PanelsPrivateRoute> {
  int contentTapCount = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TextButton(
        key: AppGlobalShellPanelsTestKeys.contentAction,
        onPressed: () => setState(() => contentTapCount += 1),
        child: const Text('Akcja private contentu'),
      ),
    ),
  );
}

/// Prawdziwy router i shell z kontrolowanymi repozytoriami paneli globalnych.
class _PanelsShellHarness extends StatefulWidget {
  const _PanelsShellHarness({
    required this.initialSettings,
    this.textScale = 1,
    this.denyConversation = false,
  });

  final LocalSettingsModel initialSettings;
  final double textScale;
  final bool denyConversation;

  @override
  State<_PanelsShellHarness> createState() => _PanelsShellHarnessState();
}

/// Stan harnessu udostępnia URI i ustawienia sprawdzane przez asercje testów.
class _PanelsShellHarnessState extends State<_PanelsShellHarness> {
  late final ShellTestAuthRepository _authRepository =
      ShellTestAuthRepository();
  late final AuthCubit _authCubit = AuthCubit(authRepository: _authRepository)
    ..emit(
      const AuthAuthenticated(
        user: AuthUser(userId: 7, login: 'tester', displayName: 'Test User'),
      ),
    );
  late final ShellTestSettingsRepository _settingsRepository =
      ShellTestSettingsRepository()..settings = widget.initialSettings;
  late final LocalSettingsCubit _settingsCubit = LocalSettingsCubit(
    repository: _settingsRepository,
    initialState: widget.initialSettings,
  );
  late final CurrentUserAvatarCubit _avatarCubit =
      ShellTestDependencies.createAvatarCubit();
  late final _PanelsChatRepository _chatRepository = _PanelsChatRepository(
    denyConversation: widget.denyConversation,
  );
  late final _PanelsNotificationsRepository _notificationsRepository =
      _PanelsNotificationsRepository();
  late final _PanelsChatDraftRepository _chatDraftRepository =
      _PanelsChatDraftRepository();
  late final _PanelsFilePickerPort _filePickerPort = _PanelsFilePickerPort();
  late final _PanelsChatAttachmentUploadPort _chatAttachmentUploadPort =
      _PanelsChatAttachmentUploadPort();
  late final WorkspaceNotificationsRealtimeService _realtime =
      WorkspaceNotificationsRealtimeService(
        client: _PanelsSignalRTransport(),
        notificationsRepository: _notificationsRepository,
      );
  late final WorkspaceChatRealtimeFactory _chatRealtimeFactory =
      WorkspaceChatRealtimeFactory(
        baseUrl: 'http://127.0.0.1:1',
        accessTokenProvider: () async => null,
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
            builder: (context, state) => const _PanelsPrivateRoute(),
          ),
        ],
      ),
    ],
  );

  /// Bieżący URI z prawdziwego GoRoutera.
  String get location => _router.routeInformationProvider.value.uri.toString();

  /// Widoczny stan lokalnych preferencji zapisanych przez shell.
  LocalSettingsModel get settings => _settingsCubit.state;

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
        RepositoryProvider<ChatDraftRepository>.value(
          value: _chatDraftRepository,
        ),
        RepositoryProvider<FilePickerPort>.value(value: _filePickerPort),
        RepositoryProvider<ChatAttachmentUploadPort>.value(
          value: _chatAttachmentUploadPort,
        ),
        RepositoryProvider<NotificationsRepository>.value(
          value: _notificationsRepository,
        ),
        RepositoryProvider<WorkspaceNotificationsRealtimeService>.value(
          value: _realtime,
        ),
        RepositoryProvider<WorkspaceChatRealtimeFactory>.value(
          value: _chatRealtimeFactory,
        ),
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(widget.textScale),
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'wide Chat z topbara przypina panel i rezerwuje szerokość contentu',
    (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        const _PanelsShellHarness(
          initialSettings: LocalSettingsModel.defaults(),
        ),
      );
      await tester.pumpAndSettle();
      final harness = tester.state<_PanelsShellHarnessState>(
        find.byType(_PanelsShellHarness),
      );
      final contentBefore = tester.getRect(
        find.byKey(AppShellMetrics.routedContentKey),
      );

      await tester.tap(find.byTooltip('Chat'));
      await tester.pumpAndSettle();

      final contentAfter = tester.getRect(
        find.byKey(AppShellMetrics.routedContentKey),
      );
      expect(contentAfter.right, lessThan(contentBefore.right));
      expect(contentBefore.right - contentAfter.right, 384);
      expect(harness.location, '/private/alpha?tab=files#comment-7');
      expect(harness.settings.globalChatPinned, isTrue);
      expect(harness.settings.globalChatWidth, 384);
    },
  );

  testWidgets('wybór rozmowy przypiętego Chat zachowuje trasę i preferencję', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      const _PanelsShellHarness(initialSettings: LocalSettingsModel.defaults()),
    );
    await tester.pumpAndSettle();
    final harness = tester.state<_PanelsShellHarnessState>(
      find.byType(_PanelsShellHarness),
    );
    await tester.tap(find.byTooltip('Chat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rozmowa Alpha'));
    await tester.pumpAndSettle();

    expect(find.text('Rozmowa Alpha'), findsOneWidget);
    expect(find.text('Live chat is offline'), findsOneWidget);
    expect(harness.location, '/private/alpha?tab=files#comment-7');
    expect(
      harness.settings.globalChatLastConversationId,
      '11111111-1111-4111-8111-111111111111',
    );
  });

  testWidgets('przypięty Chat przywraca ostatnią rozmowę bez zmiany URI', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      _PanelsShellHarness(
        initialSettings: (const LocalSettingsModel.defaults()).copyWith(
          globalChatPinned: true,
          globalChatLastConversationId: '11111111-1111-4111-8111-111111111111',
        ),
      ),
    );
    await tester.pumpAndSettle();
    final harness = tester.state<_PanelsShellHarnessState>(
      find.byType(_PanelsShellHarness),
    );

    await tester.tap(find.byTooltip('Chat'));
    await tester.pumpAndSettle();

    expect(find.byType(ChatPanelConversation), findsOneWidget);
    expect(harness.location, '/private/alpha?tab=files#comment-7');
  });

  testWidgets(
    'session-scoped otwarcie autoryzowanej rozmowy zachowuje URI na wide i compact',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      const conversationId = '11111111-1111-4111-8111-111111111111';

      for (final size in const <Size>[Size(1280, 800), Size(800, 600)]) {
        tester.view.physicalSize = size;
        await tester.pumpWidget(
          const _PanelsShellHarness(
            initialSettings: LocalSettingsModel.defaults(),
          ),
        );
        await tester.pumpAndSettle();
        final harness = tester.state<_PanelsShellHarnessState>(
          find.byType(_PanelsShellHarness),
        );
        final openConversation = AppGlobalPanelsScope.openConversationOf(
          tester.element(find.byType(_PanelsPrivateRoute)),
        );

        openConversation!(conversationId);
        await tester.pumpAndSettle();

        expect(harness.location, '/private/alpha?tab=files#comment-7');
        expect(harness.settings.globalChatLastConversationId, conversationId);
        if (size.width >= 1024) {
          expect(find.byType(ChatPanelConversation), findsOneWidget);
        } else {
          expect(find.byType(ModalBarrier), findsWidgets);
        }
      }
    },
  );

  testWidgets(
    'Resource Chat pokazuje świeży nagłówek pliku i bezpieczny powrót bez zmiany URI',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        const _PanelsShellHarness(
          initialSettings: LocalSettingsModel.defaults(),
        ),
      );
      await tester.pumpAndSettle();
      final harness = tester.state<_PanelsShellHarnessState>(
        find.byType(_PanelsShellHarness),
      );
      final openResourceConversation =
          AppGlobalPanelsScope.openResourceConversationOf(
            tester.element(find.byType(_PanelsPrivateRoute)),
          );

      openResourceConversation!(
        const ResourceChatOpenRequest(
          conversationId: '11111111-1111-4111-8111-111111111111',
          fileContext: ResourceChatFileContext(
            fileId: 'file-1',
            fileName: 'Resource.pdf',
            ownerUserId: 'owner-1',
            accessLevel: 'reader',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Resource.pdf'), findsOneWidget);
      expect(harness.location, '/private/alpha?tab=files#comment-7');

      await tester.tap(find.byTooltip('Back to conversations'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Resource.pdf'), findsNothing);
      expect(harness.location, '/private/alpha?tab=files#comment-7');
    },
  );

  testWidgets('403 rozmowy Resource Chat czyści nagłówek i wraca do listy', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      const _PanelsShellHarness(
        initialSettings: LocalSettingsModel.defaults(),
        denyConversation: true,
      ),
    );
    await tester.pumpAndSettle();
    final harness = tester.state<_PanelsShellHarnessState>(
      find.byType(_PanelsShellHarness),
    );
    final openResourceConversation =
        AppGlobalPanelsScope.openResourceConversationOf(
          tester.element(find.byType(_PanelsPrivateRoute)),
        );

    openResourceConversation!(
      const ResourceChatOpenRequest(
        conversationId: '11111111-1111-4111-8111-111111111111',
        fileContext: ResourceChatFileContext(
          fileId: 'file-1',
          fileName: 'Cofnięty.pdf',
          ownerUserId: 'owner-1',
          accessLevel: 'reader',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Cofnięty.pdf'), findsNothing);
    expect(find.text('Rozmowa Alpha'), findsOneWidget);
    expect(harness.location, '/private/alpha?tab=files#comment-7');
  });

  testWidgets(
    'resize wide do compact nie pozostawia ujemnej geometrii contentu',
    (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        const _PanelsShellHarness(
          initialSettings: LocalSettingsModel.defaults(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Chat'));
      await tester.pumpAndSettle();

      tester.view.physicalSize = const Size(320, 600);
      await tester.pumpAndSettle();

      final content = tester.getRect(
        find.byKey(AppShellMetrics.routedContentKey),
      );
      expect(content.width, greaterThan(0));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'medium Chat i powiadomienia są root overlayami i blokują content',
    (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 600);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        const _PanelsShellHarness(
          initialSettings: LocalSettingsModel.defaults(),
        ),
      );
      await tester.pumpAndSettle();
      final harness = tester.state<_PanelsShellHarnessState>(
        find.byType(_PanelsShellHarness),
      );
      final privateState = tester.state<_PanelsPrivateRouteState>(
        find.byType(_PanelsPrivateRoute),
      );

      await tester.tap(find.byTooltip('Chat'));
      await tester.pumpAndSettle();
      expect(find.byType(ModalBarrier), findsWidgets);
      await tester.tap(
        find.byKey(AppGlobalShellPanelsTestKeys.contentAction),
        warnIfMissed: false,
      );
      expect(privateState.contentTapCount, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Notifications'));
      await tester.pumpAndSettle();
      expect(find.byType(ModalBarrier), findsWidgets);
      expect(harness.location, '/private/alpha?tab=files#comment-7');
    },
  );

  testWidgets(
    'szerokość panelu jest klamrowana, zapisywana i nie overflowuje przy 320px',
    (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        const _PanelsShellHarness(
          initialSettings: LocalSettingsModel(
            themeMode: ThemeMode.light,
            themePalette: AppThemePalette.classic,
            themeSeedColor: AppThemeSeedColor.blue,
            language: AppLanguage.pl,
            sideMenuOrders: {},
            globalChatPinned: true,
            globalChatWidth: 100,
          ),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Chat'));
      await tester.pumpAndSettle();
      final harness = tester.state<_PanelsShellHarnessState>(
        find.byType(_PanelsShellHarness),
      );

      expect(harness.settings.globalChatWidth, 320);
      expect(tester.takeException(), isNull);
    },
  );
}
