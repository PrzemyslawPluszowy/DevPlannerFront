import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_typing_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_content.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_header.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Treść jednej rozmowy wyświetlana wewnątrz globalnego panelu Chat.
///
/// Każde otwarcie tworzy mały `ChatConversationCubit` o lifecycle ograniczonym
/// do panelu. Wybór rozmowy nie dotyka routera; pełny widok jest jawną akcją.
///
/// Tożsamość rozmowy jest częścią lifecycle widoku: dzierżawa realtime powstaje
/// raz w `initState`, a zmiana `conversation.id` odtwarza dzierżawę tak samo jak
/// Cubity wydane niżej. Dzięki temu nagłówek, historia i wysyłka nigdy nie
/// pochodzą z dwóch różnych rozmów.
final class ChatPanelConversation extends StatefulWidget {
  const ChatPanelConversation({
    required this.conversationRepository,
    required this.conversation,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
    this.onResourceAccessRevoked,
    this.createRealtime,
    this.messageActions,
    this.onOpenThread,
    this.targetMessageId,
    this.notificationSettings,
    this.canModerateMessages = false,
    this.showBackButton = true,
    this.desktopWebComposer = false,
    super.key,
  });

  /// Klucz tożsamości gałęzi rozmowy; `null` znaczy „rozmowa z konfiguracji”.
  static ValueKey<String> keyFor(String conversationId) =>
      ValueKey<String>('chat-panel-conversation-$conversationId');

  final ChatConversationRepository? conversationRepository;
  final ChatConversation conversation;

  /// Otwiera wątek wskazanej wiadomości; brak oznacza panel bez wątków.
  final void Function(BuildContext context, ChatMessage message)? onOpenThread;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceAccessRevoked;
  final WorkspaceChatRealtimeLease Function(String conversationId)?
  createRealtime;

  /// Port akcji drugorzędnych; brak oznacza panel bez menu wiadomości.
  final ChatMessageActionsRepository? messageActions;

  /// Wiadomość, do której panel ma przewinąć po otwarciu z wyszukiwania.
  final String? targetMessageId;

  /// Port ustawień powiadomień; brak oznacza panel bez wyciszenia rozmowy.
  final ChatNotificationSettingsRepository? notificationSettings;

  /// Czy rola bieżącego użytkownika pozwala moderować cudzą treść.
  final bool canModerateMessages;

  /// False for a task-scoped surface where leaving the conversation would
  /// leave the task modal rather than return to an inbox.
  final bool showBackButton;

  /// Uses the workbench composer shape and action density inside task details.
  final bool desktopWebComposer;

  @override
  State<ChatPanelConversation> createState() => _ChatPanelConversationState();
}

final class _ChatPanelConversationState extends State<ChatPanelConversation> {
  WorkspaceChatRealtimeLease? _realtime;

  @override
  void initState() {
    super.initState();
    _openLease();
  }

  @override
  void didUpdateWidget(covariant ChatPanelConversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Bez klucza po stronie wywołującego ta sama gałąź mogłaby dostać inną
    // rozmowę; wtedy dzierżawę trzeba wymienić razem z Cubitami.
    if (oldWidget.conversation.id != widget.conversation.id) {
      unawaited(_realtime?.dispose());
      _openLease();
    }
  }

  @override
  void dispose() {
    // Dzierżawa należy do widoku, a nie do Cubita: widok tworzy ją raz i zamyka
    // dokładnie raz, więc przebudowa nie otwiera kolejnego połączenia.
    unawaited(_realtime?.dispose());
    super.dispose();
  }

  void _openLease() {
    // Tworzenie połączenia w `build` otwierało nową dzierżawę przy każdym
    // odświeżeniu panelu i gubiło subskrypcje poprzedniej.
    _realtime = widget.createRealtime?.call(widget.conversation.id);
  }

  @override
  Widget build(BuildContext context) {
    final widget = this.widget;
    final repository = widget.conversationRepository;
    if (repository == null) {
      return _ChatPanelConversationUnavailable(
        conversation: widget.conversation,
        onBack: widget.onBack,
        onOpenFullView: widget.onOpenFullView,
        resourceContext: widget.resourceContext,
        showBackButton: widget.showBackButton,
      );
    }
    final realtime = _realtime;
    final currentUserId =
        context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '';
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final pendingStore = context.read<ChatPendingSendStore?>();
            final cubit = ChatConversationCubit(
              repository: repository,
              conversationId: widget.conversation.id,
              // Tożsamość i trwały magazyn są częścią konstrukcji Cubita, bo bez
              // nich kolejka nie wznawia prób po restarcie, a odczyt nie odróżnia
              // własnych wiadomości.
              currentUserId: currentUserId,
              deliveryQueue: ChatMessageDeliveryQueue(
                repository,
                pendingStore: pendingStore,
                userId: currentUserId,
              ),
              realtime: realtime,
            );
            unawaited(
              cubit.load().then((_) {
                final target = widget.targetMessageId;
                if (target == null || target.isEmpty) return;
                // Skok z wyszukiwania, zapisanych albo przypiętych: jeśli celu nie ma
                // w pierwszej stronie, doładowujemy okno wokół niego.
                unawaited(cubit.ensureTargetLoaded(target));
              }),
            );
            return cubit;
          },
        ),
        // Edycja i usunięcie z panelu wymagają tego Cubita; bez niego dialogi
        // akcji nie mają właściciela wersji i konfliktu.
        if (widget.messageActions != null)
          BlocProvider(
            create: (context) =>
                ChatMessageActionsCubit(repository: widget.messageActions!),
          ),
        if (realtime != null)
          BlocProvider(
            create: (context) =>
                ChatRealtimeStatusCubit(realtime.connectionStates),
          ),
        BlocProvider(
          create: (context) => ChatTypingCubit(
            realtime: realtime,
            currentUserId: currentUserId,
          ),
        ),
        BlocProvider(
          create: (_) => ChatConversationPresenceCubit(realtime: realtime),
        ),
        if (widget.messageActions != null)
          BlocProvider(
            create: (context) {
              final cubit = ChatMessageSecondaryActionsCubit(
                repository: widget.messageActions!,
              );
              unawaited(cubit.loadConversationPins(widget.conversation.id));
              final events = realtime?.conversationEvents;
              if (events != null) {
                cubit.watchConversationPins(
                  conversationId: widget.conversation.id,
                  events: events,
                );
              }
              unawaited(cubit.loadBookmarks());
              return cubit;
            },
          ),
        if (widget.notificationSettings != null)
          BlocProvider(
            create: (context) {
              final cubit = ChatConversationMuteCubit(
                repository: widget.notificationSettings!,
                conversationId: widget.conversation.id,
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
      ],
      child: ChatPanelConversationContent(
        conversation: widget.conversation,
        conversationRepository: repository,
        onOpenThread: widget.onOpenThread,
        targetMessageId: widget.targetMessageId,
        messageActions: widget.messageActions,
        canModerateMessages: widget.canModerateMessages,
        showBackButton: widget.showBackButton,
        onBack: widget.onBack,
        onOpenFullView: widget.onOpenFullView,
        resourceContext: widget.resourceContext,
        onResourceAccessRevoked: widget.onResourceAccessRevoked,
        desktopWebComposer: widget.desktopWebComposer,
      ),
    );
  }
}

/// Fallback hosta, który nie dostarczył kontraktu rozmów.
///
/// Nie udostępnia historii ani composera, więc nie wykonuje żądania z
/// niepełnym kontraktem.
final class _ChatPanelConversationUnavailable extends StatelessWidget {
  const _ChatPanelConversationUnavailable({
    required this.conversation,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
    required this.showBackButton,
  });

  final ChatConversation conversation;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ChatPanelConversationHeader(
        conversation: conversation,
        onBack: onBack,
        onOpenFullView: onOpenFullView,
        resourceContext: resourceContext,
        showBackButton: showBackButton,
      ),
      const Expanded(child: SizedBox.shrink()),
    ],
  );
}
