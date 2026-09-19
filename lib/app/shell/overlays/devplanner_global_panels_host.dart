import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_open_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_drawer.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
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
    extends State<DevPlannerGlobalPanelsHost> {
  final DevPlannerPanelsController _controller = DevPlannerPanelsController();
  final ValueNotifier<_ChatPanelRequest?> _chatRequest = ValueNotifier(null);
  late final OverlayEntry _rootEntry;
  FocusNode? _focusBeforeOpen;
  DevPlannerPanel? _lastActivePanel;

  @override
  void initState() {
    super.initState();
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
    _controller
      ..removeListener(_restoreFocusAfterClose)
      ..dispose();
    _rootEntry
      ..remove()
      ..dispose();
    _chatRequest.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_rootEntry]);

  Widget _buildRootEntry(BuildContext context) {
    var routedChild = widget.child;
    final repository = widget.chat?.repository;
    if (repository case final ResourceChatRepository resourceRepository) {
      routedChild = RepositoryProvider<ResourceChatRepository>.value(
        value: resourceRepository,
        child: routedChild,
      );
    }
    return DevPlannerPanelsScope(
      controller: _controller,
      openConversation: _openConversation,
      openResourceConversation: _openResourceConversation,
      child: Stack(
        fit: StackFit.expand,
        children: [
          routedChild,
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => _PanelOverlay(
              activePanel: _controller.activePanel,
              onClose: _controller.close,
              child: _buildActivePanel(),
            ),
          ),
        ],
      ),
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
    }
    if (_lastActivePanel != null && activePanel == null) {
      _focusBeforeOpen?.requestFocus();
      _focusBeforeOpen = null;
      _chatRequest.value = null;
    }
    _lastActivePanel = activePanel;
  }

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
      ),
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
    required this.child,
  });

  final DevPlannerPanel? activePanel;
  final VoidCallback onClose;
  final Widget child;

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
          autofocus: true,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                key: const ValueKey('devplanner-panel-barrier'),
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.scrim.withValues(
                    alpha: .18,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox(
                    width: constraints.maxWidth < 448
                        ? constraints.maxWidth
                        : 420,
                    height: double.infinity,
                    child: child,
                  ),
                ),
              ),
            ],
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
