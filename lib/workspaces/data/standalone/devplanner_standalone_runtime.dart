import 'dart:async';

import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/attachments/chat_attachment_session_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/attachments/chat_attachment_upload_port_adapter.dart';
import 'package:devplanner/workspaces/data/chat/delivery/chat_pending_send_store_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_conversation_management_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_directory_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_inbox_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_members_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_message_actions_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_notification_settings_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_presence_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_search_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_server_draft_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_thread_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/secure_chat_draft_repository.dart';
import 'package:devplanner/workspaces/data/notifications/api/notifications_api.dart';
import 'package:devplanner/workspaces/data/notifications/repositories/notifications_repository_impl.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/storage/transport/file_picker_port_impl.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/notifications_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/notifications/global_notifications_composition.dart';

/// Sesyjny composition root dla globalnego Chatu i Notifications.
///
/// Ten seam jest jedynym miejscem, w którym wygenerowane klienty Retrofit są
/// składane z transportem HTTP. Kompozycje są udostępniane wyłącznie przy
/// aktywnej sesji lokalnego DevPlanner `UserId` oraz transporcie spełniającym
/// kontrakt Web BFF albo Desktop PKCE/vault. Brak tych warunków zwraca `null`,
/// dzięki czemu router pokazuje istniejący ekran unavailable zamiast pustych
/// danych albo żądania z domyśloną tożsamością.
final class DevPlannerStandaloneRuntime {
  DevPlannerStandaloneRuntime({
    required this.auth,
    required this.transport,
    ChatDraftRepository? draftRepository,
    this.attachmentUploadPort,
    this.filePickerPort,
    this.storageRepository,
    this.attachmentUploadTransport,
  }) : _draftRepository = draftRepository ?? SecureChatDraftRepository(),
       _chatApi = ChatApi(transport.apiDio, baseUrl: transport.baseUrl),
       _notificationsApi = NotificationsApi(
         transport.apiDio,
         baseUrl: transport.baseUrl,
       ) {
    _sessionListener = _stopRealtimeAfterSessionEnds;
    auth.session.addListener(_sessionListener);
  }

  /// Auth composition właściciela sesji. Runtime nie tworzy auth i nie
  /// przyjmuje tokenu z launch contextu.
  final AuthComposition auth;

  /// Jeden transport sesyjny współdzielony przez oba moduły.
  final DevPlannerHttpTransport transport;

  /// Opcjonalny, jawnie zatwierdzony port uploadu Chat/Storage.
  final ChatAttachmentUploadPort? attachmentUploadPort;

  /// Opcjonalny adapter platformowego file pickera.
  final FilePickerPort? filePickerPort;

  /// Repozytorium Storage używane do ticketów uploadu załączników Chat.
  final StorageRepository? storageRepository;

  /// Binarny transport uploadu; `null` oznacza środowisko bez bezpiecznego
  /// transferu bezpośredniego (Web/BFF), gdzie załączniki nie są udostępniane.
  final UploadTransport? attachmentUploadTransport;

  final ChatDraftRepository _draftRepository;
  final ChatApi _chatApi;
  final NotificationsApi _notificationsApi;

  late final ChatRepository _chatRepository = ChatRepositoryImpl(_chatApi);
  ChatAttachmentUploadPortAdapter? _attachmentAdapter;

  /// Port uploadu załączników: jawny z konstruktora albo złożony z sesji Chat,
  /// Storage i zatwierdzonego transportu binarnego. Bez obu części jest `null`,
  /// więc panel nie pokazuje akcji, których nie da się bezpiecznie wykonać.
  ChatAttachmentUploadPort? get _attachmentUpload {
    final explicit = attachmentUploadPort;
    if (explicit != null) return explicit;
    final storage = storageRepository;
    final transfer = attachmentUploadTransport;
    if (storage == null || transfer == null) return null;
    return _attachmentAdapter ??= ChatAttachmentUploadPortAdapter(
      sessionRepository: ChatAttachmentSessionRepositoryImpl(_chatApi),
      storageRepository: storage,
      uploadTransport: transfer,
    );
  }

  /// Picker plików tylko tam, gdzie istnieje ścieżka uploadu.
  FilePickerPort? get _effectiveFilePicker =>
      filePickerPort ??
      (_attachmentUpload != null ? const FilePickerPortImpl() : null);
  late final ChatInboxRepository _chatInboxRepository = ChatInboxRepositoryImpl(
    _chatApi,
  );
  late final ChatNotificationSettingsRepository _chatNotificationSettings =
      ChatNotificationSettingsRepositoryImpl(_chatApi);
  late final ChatConversationManagementRepository _chatManagement =
      ChatConversationManagementRepositoryImpl(_chatApi);
  late final ChatDirectoryRepository _chatDirectory =
      ChatDirectoryRepositoryImpl(_chatApi);
  late final ChatPendingSendStore _chatPendingSends =
      ChatPendingSendStoreImpl();
  late final ChatServerDraftRepository _chatServerDrafts =
      ChatServerDraftRepositoryImpl(_chatApi);
  late final ChatThreadRepositoryImpl _chatThreads = ChatThreadRepositoryImpl(
    _chatApi,
  );
  late final ChatMembersRepository _chatMembers = ChatMembersRepositoryImpl(
    _chatApi,
  );
  late final ChatSearchRepository _chatSearch = ChatSearchRepositoryImpl(
    _chatApi,
  );
  late final ChatPresenceRepository _chatPresence = ChatPresenceRepositoryImpl(
    _chatApi,
  );
  late final ChatMessageActionsRepository _chatMessageActions =
      ChatMessageActionsRepositoryImpl(_chatApi);
  late final NotificationsRepository _notificationsRepository =
      NotificationsRepositoryImpl(_notificationsApi);

  WorkspaceChatRealtimeFactory? _chatRealtimeFactory;
  String? _lastAuthenticatedUserId;
  WorkspaceNotificationsRealtimeRealtime? _notificationsRealtime;
  late final void Function() _sessionListener;
  bool _disposed = false;

  /// Globalny Chat dla bieżącej sesji albo `null`, gdy runtime nie jest gotowy.
  DevPlannerGlobalChatComposition? get chatComposition {
    if (!_isSessionReady) return null;
    return DevPlannerGlobalChatComposition(
      repository: _chatRepository,
      userId: _userId,
      draftRepository: _draftRepository,
      inboxRepository: _chatInboxRepository,
      conversationManagementRepository: _chatManagement,
      directoryRepository: _chatDirectory,
      pendingSendStore: _chatPendingSends,
      serverDraftRepository: _chatServerDrafts,
      threadRepository: _chatThreads,
      discussionRepository: _chatThreads,
      membersRepository: _chatMembers,
      searchRepository: _chatSearch,
      presenceRepository: _chatPresence,
      messageActions: _chatMessageActions,
      notificationSettingsRepository: _chatNotificationSettings,
      attachmentUploadPort: _attachmentUpload,
      filePickerPort: _effectiveFilePicker,
      realtimeFactory: _chatRealtime(),
    );
  }

  /// Globalne Notifications dla bieżącej sesji albo `null` przy braku
  /// bezpiecznego transportu. Web pozostaje poprawnie obsługiwany przez REST
  /// cookie/CSRF, ale nie dostaje klienta SignalR wymagającego Bearera.
  DevPlannerGlobalNotificationsComposition? get notificationsComposition {
    if (!_isSessionReady) return null;
    return DevPlannerGlobalNotificationsComposition(
      repository: _notificationsRepository,
      realtime: _notificationsRealtimeService(),
    );
  }

  bool get _isSessionReady {
    final snapshot = auth.session.snapshot;
    final userId = snapshot.user?.userId.trim() ?? '';
    if (!snapshot.isAuthenticated || userId.isEmpty) return false;
    return switch (snapshot.clientKind) {
      AuthClientKind.webBff => transport.isBffCookieTransport,
      AuthClientKind.desktopPkce =>
        !transport.isBffCookieTransport &&
            transport.realtimeAccessTokenProvider != null &&
            transport.supportsStandaloneApiClients,
    };
  }

  String get _userId => auth.session.snapshot.user!.userId.trim();

  /// Jedyne źródło poświadczeń realtime pochodzi z transportu tej samej sesji:
  /// desktop używa access tokenu PKCE, a Web cookie BFF z nagłówkiem CSRF.
  WorkspaceChatRealtimeFactory? _chatRealtime() {
    final credentials = WorkspaceRealtimeCredentials.fromTransport(transport);
    if (credentials == null) return null;
    return _chatRealtimeFactory ??= WorkspaceChatRealtimeFactory(
      baseUrl: transport.baseUrl,
      credentials: credentials,
    );
  }

  WorkspaceNotificationsRealtimeService? _notificationsRealtimeService() {
    final tokenProvider = transport.realtimeAccessTokenProvider;
    if (tokenProvider == null) return null;
    return _notificationsRealtime ??= WorkspaceNotificationsRealtimeService(
      client: WorkspaceSignalRClient(
        '${transport.baseUrl}/api/v1/realtime/notifications',
        WorkspaceRealtimeCredentials.bearer(tokenProvider),
      ),
      notificationsRepository: _notificationsRepository,
    );
  }

  /// Zwalnia ewentualny owner huba Notifications przed logoutem/wyjściem.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    auth.session.removeListener(_sessionListener);
    final notifications = _notificationsRealtime;
    final chatRealtime = _chatRealtimeFactory;
    _notificationsRealtime = null;
    _chatRealtimeFactory = null;
    await chatRealtime?.closeAll();
    await notifications?.dispose();
  }

  void _stopRealtimeAfterSessionEnds() {
    final snapshot = auth.session.snapshot;
    final userId = snapshot.user?.userId.trim() ?? '';
    if (snapshot.isAuthenticated && userId.isNotEmpty) {
      // Sesja trwa: zapamiętujemy tożsamość, żeby po wylogowaniu usunąć
      // wyłącznie jej prywatny stan.
      _lastAuthenticatedUserId = userId;
      return;
    }
    if (_disposed) return;
    final signedOutUserId = _lastAuthenticatedUserId;
    _lastAuthenticatedUserId = null;
    // Detach the old owners synchronously, before awaiting their cleanup.
    unawaited(_endSessionAsync(signedOutUserId));
  }

  /// Zamyka połączenia i usuwa prywatny stan użytkownika po zakończeniu sesji.
  ///
  /// Kolejka wysyłki i historie żyją w Cubitach panelu, więc kończy je
  /// zamknięcie panelu; trwałym stanem prywatnym, który musi zniknąć, są szkice
  /// w systemowym secure storage.
  Future<void> _endSessionAsync(String? signedOutUserId) async {
    final notifications = _notificationsRealtime;
    final chatRealtime = _chatRealtimeFactory;
    _notificationsRealtime = null;
    _chatRealtimeFactory = null;
    await chatRealtime?.closeAll();
    await notifications?.dispose();
    if (signedOutUserId == null || signedOutUserId.isEmpty) return;
    await _draftRepository.deleteAllForUser(userId: signedOutUserId);
    // Trwałe intencje wysyłki poprzedniej sesji nie mogą zostać ponowione.
    await _chatPendingSends.clearForUser(userId: signedOutUserId);
  }
}

/// Nazwa pomocnicza utrzymuje typ huba w obrębie composition rootu i zapobiega
/// przypadkowemu udostępnieniu implementacji realtime prezentacji.
typedef WorkspaceNotificationsRealtimeRealtime =
    WorkspaceNotificationsRealtimeService;
