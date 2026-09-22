import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_typing_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_typing_indicator.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_parts.dart';
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
    super.key,
  });

  /// Klucz tożsamości gałęzi rozmowy; `null` znaczy „rozmowa z konfiguracji”.
  static ValueKey<String> keyFor(String conversationId) =>
      ValueKey<String>('chat-panel-conversation-$conversationId');

  final ChatConversationRepository? conversationRepository;
  final ChatConversation conversation;

  /// Otwiera wątek wskazanej wiadomości; brak oznacza panel bez wątków.
  final ValueChanged<ChatMessage>? onOpenThread;
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
        if (widget.messageActions != null)
          BlocProvider(
            create: (context) => ChatMessageSecondaryActionsCubit(
              repository: widget.messageActions!,
            ),
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
      child: _ChatPanelConversationContent(
        conversation: widget.conversation,
        onOpenThread: widget.onOpenThread,
        targetMessageId: widget.targetMessageId,
        messageActions: widget.messageActions,
        canModerateMessages: widget.canModerateMessages,
        onBack: widget.onBack,
        onOpenFullView: widget.onOpenFullView,
        resourceContext: widget.resourceContext,
        onResourceAccessRevoked: widget.onResourceAccessRevoked,
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
  });

  final ChatConversation conversation;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ChatPanelConversationHeader(
        conversation: conversation,
        onBack: onBack,
        onOpenFullView: onOpenFullView,
        resourceContext: resourceContext,
      ),
      const Expanded(child: SizedBox.shrink()),
    ],
  );
}

/// Hostuje lokalny wybór odpowiedzi i przekazuje operacje do Cubita rozmowy.
final class _ChatPanelConversationContent extends StatefulWidget {
  const _ChatPanelConversationContent({
    required this.conversation,
    this.onOpenThread,
    this.targetMessageId,
    this.messageActions,
    this.canModerateMessages = false,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
    this.onResourceAccessRevoked,
  });

  final ChatConversation conversation;

  /// Otwiera wątek wskazanej wiadomości; brak oznacza panel bez wątków.
  final ValueChanged<ChatMessage>? onOpenThread;

  /// Wiadomość, do której widok ma przewinąć po otwarciu z wyszukiwania.
  final String? targetMessageId;

  /// Port akcji wiadomości używany przez nagłówek do list przypiętych i zakładek.
  final ChatMessageActionsRepository? messageActions;

  /// Czy rola pozwala moderować cudzą treść.
  final bool canModerateMessages;

  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceAccessRevoked;

  @override
  State<_ChatPanelConversationContent> createState() =>
      _ChatPanelConversationContentState();
}

/// Lista wiadomości panelu oznaczająca odczyt tylko dla widocznego ekranu.
///
/// Widget zna wyłącznie to, co widzi: sam jest zamontowany, a aplikacja ma stan
/// lifecycle. Dopiero na tej podstawie prosi Cubit o oznaczenie odczytu
/// najnowszej cudzej wiadomości — pobranie historii samo w sobie nie wystarcza.
class _ChatPanelMessages extends StatefulWidget {
  const _ChatPanelMessages({
    required this.messages,
    required this.isSending,
    required this.onReply,
    this.onThread,
    this.targetMessageId,
    this.canModerate = false,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final ValueChanged<ChatMessage> onReply;

  /// Otwiera wątek wiadomości; brak oznacza panel bez wątków.
  final ValueChanged<ChatMessage>? onThread;

  /// Wiadomość, do której widok ma przewinąć.
  final String? targetMessageId;

  /// Czy bieżący użytkownik może moderować cudzą treść.
  final bool canModerate;

  @override
  State<_ChatPanelMessages> createState() => _ChatPanelMessagesState();
}

class _ChatPanelMessagesState extends State<_ChatPanelMessages>
    with WidgetsBindingObserver {
  AppLifecycleState _lifecycle = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleReadMarker();
  }

  @override
  void didUpdateWidget(covariant _ChatPanelMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      _scheduleReadMarker();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycle = state;
    if (state == AppLifecycleState.resumed) _scheduleReadMarker();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Panel zamontowany i aplikacja na wierzchu to warunek „faktycznie zobaczone”.
  bool get _isVisible => mounted && _lifecycle == AppLifecycleState.resumed;

  void _scheduleReadMarker() {
    if (!_isVisible || widget.messages.isEmpty) return;
    final newest = widget.messages.last;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !_isVisible) return;
      final marked = await context
          .read<ChatConversationCubit>()
          .markVisibleAsRead(newest.id);
      if (!marked || !mounted) return;
      // Badge w panelu wraca do stanu serwera po realnym odczycie.
      unawaited(context.read<ChatInboxCubit?>()?.refreshUnreadTotal());
    });
  }

  @override
  Widget build(BuildContext context) => ChatPanelMessageList(
    messages: widget.messages,
    isSending: widget.isSending,
    onReply: widget.onReply,
    onThread: widget.onThread,
    targetMessageId: widget.targetMessageId,
    canModerate: widget.canModerate,
  );
}

final class _ChatPanelConversationContentState
    extends State<_ChatPanelConversationContent> {
  final ValueNotifier<ChatMessage?> _replyTarget = ValueNotifier(null);
  final ValueNotifier<bool> _accessRevocation = ValueNotifier(false);

  @override
  void dispose() {
    _replyTarget.dispose();
    _accessRevocation.dispose();
    super.dispose();
  }

  String? _send(ChatComposerDraft draft) {
    final clientMessageId = context.read<ChatConversationCubit>().sendDraft(
      draft,
    );
    _replyTarget.value = null;
    return clientMessageId;
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<ChatConversationCubit, ChatConversationState>(
    listenWhen: (_, state) => state is ChatConversationDetached,
    listener: (context, state) {
      _accessRevocation.value = true;
      if (widget.resourceContext != null) {
        widget.onResourceAccessRevoked?.call();
      }
      widget.onBack();
    },
    child: Column(
      children: [
        ChatPanelConversationHeader(
          conversation: widget.conversation,
          onBack: widget.onBack,
          onOpenFullView: widget.onOpenFullView,
          resourceContext: widget.resourceContext,
        ),
        const ChatPanelConnectionBanner(),
        // Skok do starej wiadomości ma jawny stan: ładowanie albo komunikat
        // odmowy/braku z ponowieniem, nigdy cichej pustej historii.
        BlocBuilder<ChatConversationCubit, ChatConversationState>(
          buildWhen: (previous, current) =>
              current is ChatConversationReady &&
              (previous is! ChatConversationReady ||
                  previous.isJumpingToMessage != current.isJumpingToMessage ||
                  previous.jumpFailureCode != current.jumpFailureCode),
          builder: (context, state) {
            if (state is! ChatConversationReady) return const SizedBox.shrink();
            if (state.isJumpingToMessage) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: LinearProgressIndicator(minHeight: 2),
              );
            }
            final failure = state.jumpFailureCode;
            if (failure == null) return const SizedBox.shrink();
            final target = widget.targetMessageId ?? '';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      failure,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: target.isEmpty
                        ? null
                        : () => unawaited(
                            context
                                .read<ChatConversationCubit>()
                                .ensureTargetLoaded(target),
                          ),
                    child: Text(context.l10n.chatInboxRetry),
                  ),
                ],
              ),
            );
          },
        ),
        Expanded(
          child: BlocBuilder<ChatConversationCubit, ChatConversationState>(
            builder: (context, state) => switch (state) {
              ChatConversationInitial() || ChatConversationLoading() =>
                const Center(child: CircularProgressIndicator()),
              ChatConversationFailure(:final message) ||
              ChatConversationDetached(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Text(message, textAlign: TextAlign.center),
                ),
              ),
              ChatConversationReady(:final messages, :final isSending) =>
                _ChatPanelMessages(
                  messages: messages,
                  isSending: isSending,
                  onReply: (message) => _replyTarget.value = message,
                  onThread: widget.onOpenThread,
                  targetMessageId: widget.targetMessageId,
                  canModerate: widget.canModerateMessages,
                ),
            },
          ),
        ),
        const ChatTypingIndicator(),
        ValueListenableBuilder<ChatMessage?>(
          valueListenable: _replyTarget,
          builder: (context, replyTarget, _) => ChatMessageComposer(
            compact: true,
            onSubmit: _send,
            draftRepository: context.read<ChatDraftRepository>(),
            userId:
                context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
            conversationId: context
                .read<ChatConversationCubit>()
                .conversationId,
            conversationStates: context.read<ChatConversationCubit>().stream,
            deliveryConfirmations: context
                .read<ChatConversationCubit>()
                .deliveryConfirmations,
            attachmentUploadPort: context.read<ChatAttachmentUploadPort?>(),
            filePickerPort: context.read<FilePickerPort?>(),
            accessRevocation: _accessRevocation,
            replyTarget: replyTarget,
            onCancelReply: () => _replyTarget.value = null,
          ),
        ),
      ],
    ),
  );
}
