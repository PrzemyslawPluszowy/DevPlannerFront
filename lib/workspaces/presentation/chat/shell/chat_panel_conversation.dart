import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_unread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_typing_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_peer_status_line.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_typing_indicator.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_parts.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

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
      child: _ChatPanelConversationContent(
        conversation: widget.conversation,
        conversationRepository: repository,
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
    required this.conversationRepository,
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
  final ChatConversationRepository conversationRepository;

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
    required this.nextCursor,
    required this.isLoadingMore,
    required this.loadMoreFailed,
    required this.onLoadMore,
    required this.onReply,
    this.onThread,
    this.targetMessageId,
    this.canModerate = false,
    this.participantLabels = const <String, String>{},
    this.participantAvatarUrls = const <String, String?>{},
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final Future<void> Function() onLoadMore;
  final ValueChanged<ChatMessage> onReply;

  /// Otwiera wątek wiadomości; brak oznacza panel bez wątków.
  final ValueChanged<ChatMessage>? onThread;

  /// Wiadomość, do której widok ma przewinąć.
  final String? targetMessageId;

  /// Czy bieżący użytkownik może moderować cudzą treść.
  final bool canModerate;

  /// Etykiety autorów z katalogu; w DM pusta, więc dymek nie pokazuje autora.
  final Map<String, String> participantLabels;

  /// Profile image URLs from the current conversation's participant directory.
  final Map<String, String?> participantAvatarUrls;

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
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycle = state;
    if (state == AppLifecycleState.resumed && mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Panel zamontowany i aplikacja na wierzchu to warunek „faktycznie zobaczone”.
  bool get _isVisible => mounted && _lifecycle == AppLifecycleState.resumed;

  void _onNewestMessageVisible(String messageId) {
    if (!_isVisible || ModalRoute.of(context)?.isCurrent == false) return;
    unawaited(_markVisibleMessageAsRead(messageId));
  }

  Future<void> _markVisibleMessageAsRead(String messageId) async {
    final marked = await context
        .read<ChatConversationCubit>()
        .markVisibleAsRead(messageId);
    if (!marked || !mounted || !_isVisible) return;
    // Odświeżenie strony inboxa aktualizuje unreadCount samej rozmowy oraz
    // globalny licznik; samo refreshUnreadTotal zostawiałoby wiersz jako unread.
    unawaited(context.read<ChatInboxCubit?>()?.refresh());
    unawaited(context.read<ChatUnreadCubit?>()?.refresh());
  }

  @override
  Widget build(BuildContext context) => ChatPanelMessageList(
    messages: widget.messages,
    isSending: widget.isSending,
    onReply: widget.onReply,
    onThread: widget.onThread,
    targetMessageId: widget.targetMessageId,
    canModerate: widget.canModerate,
    participantLabels: widget.participantLabels,
    participantAvatarUrls: widget.participantAvatarUrls,
    nextCursor: widget.nextCursor,
    isLoadingMore: widget.isLoadingMore,
    loadMoreFailed: widget.loadMoreFailed,
    onLoadMore: widget.onLoadMore,
    onNewestMessageVisible: _onNewestMessageVisible,
    onEnsureTargetLoaded: (messageId) =>
        context.read<ChatConversationCubit>().ensureTargetLoaded(messageId),
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

  /// Wpis rozmowy w katalogu skrzynki; brak oznacza brak potwierdzonych danych.
  ChatInboxItem? _inboxItem(BuildContext context) {
    final state = context.watch<ChatInboxCubit?>()?.state;
    if (state is! ChatInboxReady) return null;
    for (final item in state.items) {
      if (item.conversation.id == widget.conversation.id) return item;
    }
    return null;
  }

  /// Etykiety autorów z katalogu skrzynki.
  ///
  /// W DM nie pokazujemy autora, a brak wpisu w skrzynce oznacza brak etykiety —
  /// dymek nie wymyśla nazwy, tylko pokazuje to, co potwierdził serwer.
  Map<String, String> _participantLabels(BuildContext context) {
    if (widget.conversation.type == 'direct') return const <String, String>{};
    final item = _inboxItem(context);
    if (item == null) return const <String, String>{};
    return <String, String>{
      for (final participant in item.participants)
        participant.userId: participant.label,
    };
  }

  /// Nazwy piszących obejmują też rozmówcę z DM, choć dymki DM nie pokazują
  /// prefiksu autora. Wskaźnik pisania musi powiedzieć użytkownikowi, kto pisze.
  Map<String, String> _typingParticipantLabels(BuildContext context) {
    if (widget.conversation.type != 'direct') {
      return _participantLabels(context);
    }
    final others = _inboxItem(context)?.otherParticipants;
    if (others == null || others.isEmpty) return const <String, String>{};
    return <String, String>{
      for (final participant in others) participant.userId: participant.label,
    };
  }

  /// URL zdjęcia autora z ACL-owanego katalogu rozmowy.
  Map<String, String?> _participantAvatarUrls(BuildContext context) {
    if (widget.conversation.type == 'direct') {
      return const <String, String?>{};
    }
    final item = _inboxItem(context);
    if (item == null) return const <String, String?>{};
    return <String, String?>{
      for (final participant in item.participants)
        participant.userId: participant.avatarUrl,
    };
  }

  /// UUID rozmówcy w DM; w grupie `null`, żeby nagłówek użył awatara grupy.
  String? _headerAvatarUserId(BuildContext context) {
    if (widget.conversation.type != 'direct') return null;
    final others = _inboxItem(context)?.otherParticipants;
    if (others == null || others.isEmpty) return null;
    return others.first.userId;
  }

  /// URL zdjęcia rozmówcy pochodzi ze skrzynki. `null` oznacza, że należy
  /// użyć inicjałów zamiast przewidywać endpoint i wywoływać go z 404.
  String? _headerAvatarUrl(BuildContext context) {
    if (widget.conversation.type != 'direct') return null;
    final others = _inboxItem(context)?.otherParticipants;
    if (others == null || others.isEmpty) return null;
    return others.first.avatarUrl;
  }

  /// Jedna linia kontekstu nagłówka: liczba osób, bo stan obecności nie istnieje.
  String? _headerSubtitle(BuildContext context) {
    if (widget.conversation.type == 'direct') return null;
    final item = _inboxItem(context);
    if (item == null || item.participantCount <= 0) return null;
    return context.l10n.chatHeaderParticipantCount(item.participantCount);
  }

  /// Czy wolno zaproponować `@all`: grupa/kanał i rola Owner/Moderator.
  ///
  /// Serwer i tak egzekwuje regułę; UI tylko nie pokazuje opcji, której nie da
  /// się wysłać, i nie odsłania `@all` w rozmowie 1:1 ani obserwatorowi.
  bool _mentionAllEnabled(BuildContext context) {
    final type = widget.conversation.type;
    if (type != 'group' && type != 'channel' && type != 'broadcast') {
      return false;
    }
    final role = _inboxItem(context)?.role;
    return role == 'Owner' || role == 'Moderator';
  }

  /// Nagłówek rozmowy: w DM etykieta rozmówcy z katalogu, inaczej `null`.
  ///
  /// Brak profilu lub nazwy daje neutralny tytuł, nigdy techniczny `scopeKey`.
  String? _conversationTitle(BuildContext context) {
    if (widget.conversation.type != 'direct') return null;
    final others = _inboxItem(context)?.otherParticipants;
    if (others == null || others.isEmpty) return null;
    return others.map((participant) => participant.label).join(', ');
  }

  /// Otwiera listę grupy i dodawanie osób bez szukania akcji w menu `…`.
  void _openMembers() {
    final members = context.read<ChatMembersRepository?>();
    if (members == null) return;
    unawaited(
      ChatMembersSheet.show(
        context,
        membersRepository: members,
        conversation: widget.conversation,
        currentUserId:
            context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
        conversationManagement: context
            .read<ChatConversationManagementRepository?>(),
        presenceRepository: context.read<ChatPresenceRepository?>(),
        directoryRepository: context.read<ChatDirectoryRepository?>(),
      ),
    );
  }

  String? _send(ChatComposerDraft draft) {
    final clientMessageId = context.read<ChatConversationCubit>().sendDraft(
      draft,
    );
    if (clientMessageId != null) _replyTarget.value = null;
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
          conversationRepository: widget.conversationRepository,
          messageActions: widget.messageActions,
          title: _conversationTitle(context),
          avatarUserId: _headerAvatarUserId(context),
          avatarUrl: _headerAvatarUrl(context),
          avatarLabel: _conversationTitle(context) ?? widget.conversation.name,
          subtitle: _headerSubtitle(context),
          subtitleWidget: switch (_headerAvatarUserId(context)) {
            final userId? when userId.isNotEmpty => ChatPeerStatusLine(
              userId: userId,
            ),
            _ => null,
          },
          onOpenMembers:
              widget.conversation.type != 'direct' &&
                  context.read<ChatMembersRepository?>() != null
              ? _openMembers
              : null,
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
                  previous.jumpFailureCode != current.jumpFailureCode ||
                  previous.isWindowedHistory != current.isWindowedHistory),
          builder: (context, state) {
            if (state is! ChatConversationReady) return const SizedBox.shrink();
            if (state.isJumpingToMessage) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: LinearProgressIndicator(minHeight: 2),
              );
            }
            // Tryb okna jest jawny: użytkownik wie, że patrzy na fragment
            // historii, i ma jedną akcję powrotu do najnowszych wiadomości.
            if (state.isWindowedHistory) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: Row(
                  children: [
                    const Icon(Symbols.history, size: 16),
                    const SizedBox(width: Sizes.p8),
                    Expanded(
                      child: Text(
                        context.l10n.chatWindowHistoryBanner,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: () => unawaited(
                        context
                            .read<ChatConversationCubit>()
                            .exitWindowHistory(),
                      ),
                      child: Text(context.l10n.chatWindowHistoryLatest),
                    ),
                  ],
                ),
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
                      style: context.chatTheme.metadataStyle.copyWith(
                        color: context.chatTheme.error,
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
              ChatConversationFailure() || ChatConversationDetached() => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Text(
                    state is ChatConversationDetached
                        ? context.l10n.chatConversationAccessRevokedMessage
                        : context.l10n.chatConversationLoadFailureMessage,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ChatConversationReady(
                :final messages,
                :final isSending,
                :final nextCursor,
                :final isLoadingMore,
                :final loadError,
              ) =>
                _ChatPanelMessages(
                  messages: messages,
                  isSending: isSending,
                  nextCursor: nextCursor,
                  isLoadingMore: isLoadingMore,
                  loadMoreFailed: loadError != null,
                  onLoadMore: () =>
                      context.read<ChatConversationCubit>().loadMore(),
                  onReply: (message) => _replyTarget.value = message,
                  onThread: widget.onOpenThread,
                  targetMessageId: widget.targetMessageId,
                  canModerate: widget.canModerateMessages,
                  participantLabels: _participantLabels(context),
                  participantAvatarUrls: _participantAvatarUrls(context),
                ),
            },
          ),
        ),
        ChatTypingIndicator(labels: _typingParticipantLabels(context)),
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
            mentionAllEnabled: _mentionAllEnabled(context),
            accessRevocation: _accessRevocation,
            replyTarget: replyTarget,
            onCancelReply: () => _replyTarget.value = null,
          ),
        ),
      ],
    ),
  );
}
