import 'dart:async';

import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/secure_chat_draft_repository.dart';
import 'package:devplanner/workspaces/data/notifications/api/notifications_api.dart';
import 'package:devplanner/workspaces/data/notifications/repositories/notifications_repository_impl.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/notifications_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
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

  final ChatDraftRepository _draftRepository;
  final ChatApi _chatApi;
  final NotificationsApi _notificationsApi;

  late final ChatRepository _chatRepository = ChatRepositoryImpl(_chatApi);
  late final NotificationsRepository _notificationsRepository =
      NotificationsRepositoryImpl(_notificationsApi);

  WorkspaceChatRealtimeFactory? _chatRealtimeFactory;
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
      attachmentUploadPort: attachmentUploadPort,
      filePickerPort: filePickerPort,
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

  WorkspaceChatRealtimeFactory? _chatRealtime() {
    final tokenProvider = transport.realtimeAccessTokenProvider;
    if (tokenProvider == null) return null;
    return _chatRealtimeFactory ??= WorkspaceChatRealtimeFactory(
      baseUrl: transport.baseUrl,
      accessTokenProvider: tokenProvider,
    );
  }

  WorkspaceNotificationsRealtimeService? _notificationsRealtimeService() {
    final tokenProvider = transport.realtimeAccessTokenProvider;
    if (tokenProvider == null) return null;
    return _notificationsRealtime ??= WorkspaceNotificationsRealtimeService(
      client: WorkspaceSignalRClient(
        '${transport.baseUrl}/api/v1/realtime/notifications',
        tokenProvider,
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
    _notificationsRealtime = null;
    _chatRealtimeFactory = null;
    await notifications?.dispose();
  }

  void _stopRealtimeAfterSessionEnds() {
    if (auth.session.snapshot.isAuthenticated || _disposed) return;
    // Detach the old owner synchronously, before awaiting its cleanup.
    unawaited(_disposeRealtimeForSignedOutSession());
  }

  Future<void> _disposeRealtimeForSignedOutSession() async {
    final notifications = _notificationsRealtime;
    _notificationsRealtime = null;
    _chatRealtimeFactory = null;
    await notifications?.dispose();
  }
}

/// Nazwa pomocnicza utrzymuje typ huba w obrębie composition rootu i zapobiega
/// przypadkowemu udostępnieniu implementacji realtime prezentacji.
typedef WorkspaceNotificationsRealtimeRealtime =
    WorkspaceNotificationsRealtimeService;
