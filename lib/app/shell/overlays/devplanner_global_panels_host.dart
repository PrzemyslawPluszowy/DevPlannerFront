import 'dart:async';
import 'dart:math' as math;

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_modal_layer.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_open_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_drawer.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:devplanner/workspaces/presentation/notifications/global_notifications_composition.dart';
import 'package:devplanner/workspaces/presentation/notifications/global_notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Jeden session-scoped host dla Chatu i powiadomień nad aktywną trasą.
///
/// Host zachowuje trasę i stan widoku pod spodem. Kontroluje focus, Escape i
/// barrier, a zależności dostaje wyłącznie od root composition — panel nie
/// tworzy transportu HTTP ani połączeń realtime samodzielnie.
final class DevPlannerGlobalPanelsHost extends StatefulWidget {
  const DevPlannerGlobalPanelsHost({
    required this.child,
    required this.navigation,
    this.chat,
    this.notifications,
    this.authSession,
    super.key,
  });

  final Widget child;
  final DevPlannerNavigation navigation;
  final DevPlannerGlobalChatComposition? chat;
  final DevPlannerGlobalNotificationsComposition? notifications;
  final AuthSessionPort? authSession;

  @override
  State<DevPlannerGlobalPanelsHost> createState() =>
      _DevPlannerGlobalPanelsHostState();
}

final class _DevPlannerGlobalPanelsHostState
    extends State<DevPlannerGlobalPanelsHost>
    with WidgetsBindingObserver {
  final DevPlannerPanelsController _controller = DevPlannerPanelsController();
  final ValueNotifier<_ChatPanelRequest?> _chatRequest = ValueNotifier(null);
  final GlobalKey<NavigatorState> _modalNavigatorKey =
      GlobalKey<NavigatorState>();
  final FocusNode _panelFocusNode = FocusNode(debugLabel: 'devplanner-panel');
  final ChatPanelSizeController _panelSize = ChatPanelSizeController();
  final ValueNotifier<bool> _collapsing = ValueNotifier<bool>(false);
  late final OverlayEntry _rootEntry;
  FocusNode? _focusBeforeOpen;
  DevPlannerPanel? _lastActivePanel;

  @override
  void initState() {
    super.initState();
    // Obserwator jest rejestrowany przed routerem (host jest nad nim), więc
    // back systemowy najpierw zamyka modal, a dopiero potem zmienia trasę.
    WidgetsBinding.instance.addObserver(this);
    _rootEntry = OverlayEntry(builder: _buildRootEntry);
    _controller.addListener(_restoreFocusAfterClose);
  }

  @override
  void didUpdateWidget(covariant DevPlannerGlobalPanelsHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _rootEntry.markNeedsBuild();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller
      ..removeListener(_restoreFocusAfterClose)
      ..dispose();
    _rootEntry
      ..remove()
      ..dispose();
    _panelFocusNode.dispose();
    _panelSize.dispose();
    _collapsing.dispose();
    _chatRequest.dispose();
    super.dispose();
  }

  /// Back systemowy zamyka modal warstwy, zanim router zmieni trasę.
  ///
  /// Zwrócenie `false` oddaje zdarzenie routerowi, więc zachowanie poza
  /// modalem pozostaje niezmienione.
  @override
  Future<bool> didPopRoute() async {
    final navigator = _modalNavigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) return false;
    return navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_rootEntry]);

  Widget _buildRootEntry(BuildContext context) => DevPlannerModalLayer(
    navigatorKey: _modalNavigatorKey,
    content: _buildAppContent(),
  );

  Widget _buildAppContent() {
    var routedChild = widget.child;
    final repository = widget.chat?.repository;
    if (repository case final ResourceChatRepository resourceRepository) {
      routedChild = RepositoryProvider<ResourceChatRepository>.value(
        value: resourceRepository,
        child: routedChild,
      );
    }
    Widget panelHost = CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _handleEscape,
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _panelSize]),
        builder: (context, _) {
          // Rezerwacja jest publikowana przez scope i odejmowana wewnątrz
          // shella, więc ani router, ani tapeta nie zmieniają rozmiaru.
          final reserved = _reservedWidth(MediaQuery.sizeOf(context).width);
          return DevPlannerPanelsScope(
            controller: _controller,
            openConversation: _openConversation,
            openResourceConversation: _openResourceConversation,
            reservedWidth: reserved,
            child: Stack(
              fit: StackFit.expand,
              children: [
                routedChild,
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _controller,
                    _panelSize,
                    _collapsing,
                  ]),
                  builder: (context, _) => _PanelOverlay(
                    activePanel: _controller.activePanel,
                    onClose: _closePanel,
                    focusNode: _panelFocusNode,
                    size: _panelSize,
                    onTogglePin: () =>
                        _panelSize.setPinned(pinned: !_panelSize.pinned),
                    onResizeStart: _panelSize.beginResize,
                    onResize: (delta) => _panelSize.resizeBy(
                      delta,
                      available: MediaQuery.sizeOf(context).width,
                    ),
                    onResizeEnd: _handleResizeEnd,
                    collapsing: _collapsing.value,
                    onCollapsed: _finishCollapse,
                    child: _buildActivePanel(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Porty serwerowego szkicu i trwałej kolejki wysyłki są montowane nad oboma
    // panelami, bo sięgają po nie zarówno panel, jak i modale.
    final serverDrafts = widget.chat?.serverDraftRepository;
    if (serverDrafts != null) {
      panelHost = RepositoryProvider<ChatServerDraftRepository>.value(
        value: serverDrafts,
        child: panelHost,
      );
    }
    final pendingSends = widget.chat?.pendingSendStore;
    if (pendingSends != null) {
      panelHost = RepositoryProvider<ChatPendingSendStore>.value(
        value: pendingSends,
        child: panelHost,
      );
    }
    // Port ustawień powiadomień Chat jest montowany nad oboma panelami, bo modale
    // ustawień są rootowe i sięgają po niego z kontekstu wywołującego panel.
    final notificationSettings = widget.chat?.notificationSettingsRepository;
    if (notificationSettings == null) return panelHost;
    return RepositoryProvider<ChatNotificationSettingsRepository>.value(
      value: notificationSettings,
      child: panelHost,
    );
  }

  void _openConversation(String conversationId) {
    _chatRequest.value = _ChatPanelRequest.conversation(conversationId);
    _controller.showChat();
  }

  void _openResourceConversation(ResourceChatOpenRequest request) {
    _chatRequest.value = _ChatPanelRequest.resource(request);
    _controller.showChat();
  }

  void _restoreFocusAfterClose() {
    final activePanel = _controller.activePanel;
    if (_lastActivePanel == null && activePanel != null) {
      _focusBeforeOpen = FocusManager.instance.primaryFocus;
      // Panel przejmuje focus jawnie: `autofocus` nie wystarcza, gdy panel
      // dostaje własną warstwę modali, a Escape panelu działa tylko wtedy, gdy
      // focus jest w jego poddrzewie.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.activePanel != null) {
          _panelFocusNode.requestFocus();
        }
      });
    }
    if (_lastActivePanel != null && activePanel == null) {
      _focusBeforeOpen?.requestFocus();
      _focusBeforeOpen = null;
      _chatRequest.value = null;
    }
    _lastActivePanel = activePanel;
  }

  /// Zamyka panel i czyści stan zwijania.
  void _closePanel() {
    _collapsing.value = false;
    _controller.close();
  }

  /// Kończy gest uchwytu: nadwyżka poza minimum zwija panel animacją.
  void _handleResizeEnd(double available) {
    if (_panelSize.endResize(available: available)) {
      _collapsing.value = true;
    }
  }

  /// Domika zwinięcie po animacji.
  void _finishCollapse() {
    if (!mounted || !_collapsing.value) return;
    _collapsing.value = false;
    _controller.close();
  }

  /// Escape z dowolnego miejsca w shellu chowa panel.
  ///
  /// Modal jest bliżej focusu, więc własne Escape modala nadal wygrywa; ten
  /// skrót działa, gdy focus jest w treści aplikacji, a panel jest otwarty.
  void _handleEscape() {
    if (_controller.activePanel != null) _closePanel();
  }

  /// Szerokość, którą przypięty panel rezerwuje w treści aplikacji.
  ///
  /// Bez przypięcia panel pływa nad treścią, więc aplikacja zachowuje pełną
  /// szerokość. Rezerwacja obowiązuje tylko wtedy, gdy w oknie zostaje
  /// użyteczna szerokość treści; inaczej panel wraca do nakładki i nie zgniata
  /// aplikacji. Preferencja przypięcia nie jest przy tym kasowana.
  double _reservedWidth(double available) {
    if (_controller.activePanel == null || !_panelSize.pinned) return 0;
    if (!_canPin(available)) return 0;
    return _panelSize.effectiveWidth(available);
  }

  /// Czy w oknie jest miejsce na przypięty panel obok treści aplikacji.
  bool _canPin(double available) =>
      _controller.activePanel != null && _panelSize.canPinAt(available);

  Widget _buildActivePanel() => switch (_controller.activePanel) {
    DevPlannerPanel.chat => _buildChatPanel(),
    DevPlannerPanel.notifications => _buildNotificationsPanel(),
    null => const SizedBox.shrink(),
  };

  Widget _buildChatPanel() {
    final composition = widget.chat;
    if (composition == null) {
      return const _GlobalPanelUnavailable(
        key: ValueKey('devplanner-chat-unavailable'),
        message: 'Czat jest niedostępny dla bieżącej sesji.',
      );
    }
    // Port skrzynki jest wymagany: bez niego panel cofnąłby się do zastępczej
    // listy rozmów z kontraktu bazowego, udając nowy produkt.
    final inboxRepository = composition.inboxRepository;
    if (inboxRepository == null) {
      return const _GlobalPanelUnavailable(
        key: ValueKey('devplanner-chat-incomplete-composition'),
        message:
            'Konfiguracja Czatu jest niekompletna: brak portu skrzynki rozmów.',
      );
    }
    Widget panel = ValueListenableBuilder<_ChatPanelRequest?>(
      valueListenable: _chatRequest,
      builder: (context, request, _) => AppGlobalChatPanel(
        repository: composition.repository,
        onClose: _controller.close,
        initialConversationId: request?.conversationId,
        resourceConversationId: request?.resourceRequest?.conversationId,
        resourceContext: request?.resourceRequest?.fileContext,
        onResourceContextDismissed: _clearResourceRequest,
        fillAvailableWidth: true,
        pinned: _panelSize.pinned,
        canPin: _canPin(MediaQuery.sizeOf(context).width),
        onTogglePin: () => _panelSize.setPinned(pinned: !_panelSize.pinned),
      ),
    );
    panel = RepositoryProvider<ChatInboxRepository>.value(
      value: inboxRepository,
      child: panel,
    );
    panel = RepositoryProvider<ChatDraftRepository>.value(
      value: composition.draftRepository,
      child: panel,
    );
    final authSession = widget.authSession;
    if (authSession != null) {
      panel = ListenableProvider<AuthSessionPort>.value(
        value: authSession,
        child: panel,
      );
    }
    final realtimeFactory = composition.realtimeFactory;
    if (realtimeFactory != null) {
      panel = RepositoryProvider<WorkspaceChatRealtimeFactory>.value(
        value: realtimeFactory,
        child: panel,
      );
    }
    final directoryRepository = composition.directoryRepository;
    if (directoryRepository != null) {
      panel = RepositoryProvider<ChatDirectoryRepository>.value(
        value: directoryRepository,
        child: panel,
      );
    }
    final managementRepository = composition.conversationManagementRepository;
    if (managementRepository != null) {
      panel = RepositoryProvider<ChatConversationManagementRepository>.value(
        value: managementRepository,
        child: panel,
      );
    }
    final threadRepository = composition.threadRepository;
    if (threadRepository != null) {
      panel = RepositoryProvider<ChatThreadRepository>.value(
        value: threadRepository,
        child: panel,
      );
    }
    final discussionRepository = composition.discussionRepository;
    if (discussionRepository != null) {
      panel = RepositoryProvider<ChatDiscussionRepository>.value(
        value: discussionRepository,
        child: panel,
      );
    }
    final messageActions = composition.messageActions;
    if (messageActions != null) {
      panel = RepositoryProvider<ChatMessageActionsRepository>.value(
        value: messageActions,
        child: panel,
      );
    }
    final membersRepository = composition.membersRepository;
    if (membersRepository != null) {
      panel = RepositoryProvider<ChatMembersRepository>.value(
        value: membersRepository,
        child: panel,
      );
    }
    final presenceRepository = composition.presenceRepository;
    if (presenceRepository != null) {
      panel = RepositoryProvider<ChatPresenceRepository>.value(
        value: presenceRepository,
        child: panel,
      );
    }
    final searchRepository = composition.searchRepository;
    if (searchRepository != null) {
      panel = RepositoryProvider<ChatSearchRepository>.value(
        value: searchRepository,
        child: panel,
      );
    }
    final uploadPort = composition.attachmentUploadPort;
    if (uploadPort != null) {
      panel = RepositoryProvider<ChatAttachmentUploadPort>.value(
        value: uploadPort,
        child: panel,
      );
    }
    final filePicker = composition.filePickerPort;
    if (filePicker != null) {
      panel = RepositoryProvider<FilePickerPort>.value(
        value: filePicker,
        child: panel,
      );
    }
    return panel;
  }

  Widget _buildNotificationsPanel() {
    final composition = widget.notifications;
    if (composition == null) {
      return const _GlobalPanelUnavailable(
        key: ValueKey('devplanner-notifications-unavailable'),
        message: 'Powiadomienia są niedostępne dla bieżącej sesji.',
      );
    }
    Widget panel = AppGlobalNotificationsPanel(
      repository: composition.repository,
      onClose: _controller.close,
      fillAvailableWidth: true,
    );
    final realtime = composition.realtime;
    if (realtime != null) {
      panel = RepositoryProvider<WorkspaceNotificationsRealtimeService>.value(
        value: realtime,
        child: panel,
      );
    }
    return panel;
  }

  void _clearResourceRequest() {
    final request = _chatRequest.value;
    if (request?.resourceRequest != null) _chatRequest.value = null;
  }
}

/// Warstwa z klawiaturowym i wskaźnikowym zamknięciem, bez własnej nawigacji.
final class _PanelOverlay extends StatelessWidget {
  const _PanelOverlay({
    required this.activePanel,
    required this.onClose,
    required this.focusNode,
    required this.size,
    required this.onTogglePin,
    required this.onResizeStart,
    required this.onResize,
    required this.onResizeEnd,
    required this.collapsing,
    required this.onCollapsed,
    required this.child,
  });

  final DevPlannerPanel? activePanel;
  final VoidCallback onClose;

  /// Węzeł focusu panelu; host prosi go o focus przy otwarciu, aby Escape
  /// zamykał panel i aby modal oddawał focus z powrotem do panelu.
  final FocusNode focusNode;

  /// Rozmiar i tryb przypięcia panelu.
  final ChatPanelSizeController size;

  /// Przełącza przypięcie panelu (rezerwacja szerokości w layoucie).
  final VoidCallback onTogglePin;

  /// Zaczyna przeciąganie uchwytu.
  final VoidCallback onResizeStart;

  /// Zmienia szerokość panelu o przyrost z uchwytu.
  final ValueChanged<double> onResize;

  /// Kończy przeciąganie uchwytu i rozstrzyga o zwinięciu panelu.
  final ValueChanged<double> onResizeEnd;

  /// Czy trwa animacja zwijania panelu.
  final bool collapsing;

  /// Wywoływane po zakończeniu animacji zwijania.
  final VoidCallback onCollapsed;
  final Widget child;

  /// Czas animacji panelu; systemowe ograniczenie ruchu wyłącza animację.
  static Duration panelAnimationDuration(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations == true
      ? Duration.zero
      : const Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    if (activePanel == null) return const SizedBox.shrink();
    return Positioned(
      top: 64,
      right: 0,
      bottom: 0,
      left: 0,
      child: CallbackShortcuts(
        bindings: {const SingleActivator(LogicalKeyboardKey.escape): onClose},
        child: Focus(
          focusNode: focusNode,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final available = constraints.maxWidth;
              // O tym, czy panel jest modalny, decyduje szerokość okna, a nie
              // szerokość panelu: przy wąskim oknie panel zajmuje całą
              // przestrzeń roboczą i przyciemnia treść, a przy szerokim jest
              // wąskim panelem obok aplikacji, która pozostaje klikalna.
              final modal =
                  available < ChatPanelSizeController.compactBreakpoint;
              // Uchwyt zajmuje 12 px, więc szerokość treści panelu jest o tyle
              // mniejsza i całość nigdy nie wychodzi za dostępną przestrzeń.
              final handleWidth = modal
                  ? 0.0
                  : ChatPanelSizeController.resizeHandleWidth;
              final width = math.max(
                0.0,
                (modal ? available : size.effectiveWidth(available)) -
                    handleWidth,
              );
              // Układ kolumn rozstrzyga sam scaffold panelu po swojej
              // szerokości: poniżej progu pokazuje rail i jedną kolumnę, a przy
              // 30% okna panel startuje właśnie w tym trybie.
              return Stack(
                fit: StackFit.expand,
                children: [
                  if (modal)
                    GestureDetector(
                      key: const ValueKey('devplanner-panel-barrier'),
                      behavior: HitTestBehavior.opaque,
                      onTap: onClose,
                      child: ColoredBox(
                        color: Theme.of(
                          context,
                        ).colorScheme.scrim.withValues(alpha: .18),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Uchwyt jest dostępny, gdy tylko panel nie zajmuje
                        // całego okna: przy 30% startowej szerokości to jedyna
                        // droga, żeby poszerzyć panel do trzech kolumn.
                        if (!modal && !collapsing)
                          _ChatPanelResizeHandle(
                            onDragStart: onResizeStart,
                            onDrag: (delta) => onResize(-delta),
                            onDragEnd: () => onResizeEnd(available),
                            onReset: size.reset,
                          ),
                        // Szerokość jest animowana, więc zwinięcie gestem albo
                        // przyciskiem wygląda jak zsunięcie panelu, a nie
                        // zniknięcie klatki.
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(end: collapsing ? 0 : width),
                          duration: panelAnimationDuration(context),
                          curve: Curves.easeInCubic,
                          onEnd: collapsing ? onCollapsed : null,
                          builder: (context, animatedWidth, child) =>
                              // Stały klucz powierzchni panelu: testy i shell
                              // znajdują panel w obu trybach, także bez barrieru.
                              SizedBox(
                                key: const ValueKey(
                                  'devplanner-panel-surface',
                                ),
                                width: math.max(0, animatedWidth),
                                child: child,
                              ),
                          child: child,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Uchwyt zmiany szerokości panelu na lewej krawędzi.
///
/// Szerokość jest ograniczana do dostępnej przestrzeni w kontrolerze, więc
/// przeciągnięcie poza okno ani zmiana rozmiaru okna nie zostawiają panelu
/// szerszego niż shell.
class _ChatPanelResizeHandle extends StatelessWidget {
  const _ChatPanelResizeHandle({
    required this.onDragStart,
    required this.onDrag,
    required this.onDragEnd,
    required this.onReset,
  });

  final VoidCallback onDragStart;
  final ValueChanged<double> onDrag;
  final VoidCallback onDragEnd;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    // Host paneli bywa montowany w testach i kompozycjach bez delegatów
    // lokalizacji, więc brak tekstu nie może wywracać powierzchni panelu.
    final label = AppLocalizations.of(context)?.chatPanelResizeHandle;
    return Tooltip(
      message: label ?? '',
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: Semantics(
          label: label,
          child: GestureDetector(
            key: const ValueKey('devplanner-panel-resize-handle'),
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (_) => onDragStart(),
            onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
            onHorizontalDragEnd: (_) => onDragEnd(),
            onDoubleTap: onReset,
            child: SizedBox(
              width: ChatPanelSizeController.resizeHandleWidth,
              child: Center(
                child: Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: .9),
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Jawnym stanem braku kontraktu jest komunikat, nigdy pusty panel.
final class _GlobalPanelUnavailable extends StatelessWidget {
  const _GlobalPanelUnavailable({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    ),
  );
}

/// Wybrana rozmowa panelu, w tym opcjonalny świeży kontekst pliku Storage.
final class _ChatPanelRequest {
  const _ChatPanelRequest._({this.conversationId, this.resourceRequest});

  const _ChatPanelRequest.conversation(String conversationId)
    : this._(conversationId: conversationId);

  _ChatPanelRequest.resource(ResourceChatOpenRequest request)
    : this._(
        conversationId: request.conversationId,
        resourceRequest: request,
      );

  final String? conversationId;
  final ResourceChatOpenRequest? resourceRequest;
}
