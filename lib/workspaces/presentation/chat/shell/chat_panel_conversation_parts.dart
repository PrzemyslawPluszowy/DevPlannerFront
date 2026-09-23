import 'dart:async';
import 'dart:math' as math;

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_dialogs.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_list_sheets.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_date_separator.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_grouping.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_visibility.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nieblokujący komunikat o stanie połączenia SignalR w panelu Chat.
final class ChatPanelConnectionBanner extends StatelessWidget {
  const ChatPanelConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<ChatRealtimeStatusCubit?>() == null) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<
      ChatRealtimeStatusCubit,
      WorkspaceSignalRConnectionState
    >(
      builder: (context, state) {
        final message = switch (state) {
          WorkspaceSignalRConnectionState.connected => null,
          WorkspaceSignalRConnectionState.connecting =>
            context.l10n.globalChatConnecting,
          WorkspaceSignalRConnectionState.reconnecting =>
            context.l10n.globalChatReconnecting,
          WorkspaceSignalRConnectionState.disconnected =>
            context.l10n.globalChatOffline,
        };
        if (message == null) return const SizedBox.shrink();
        final chat = context.chatTheme;
        return Semantics(
          liveRegion: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: chat.listSurface,
              border: Border(
                bottom: BorderSide(color: chat.separator),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p8,
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.info,
                    size: 18,
                    color: chat.metadataText,
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: chat.metadataStyle.copyWith(
                        color: chat.metadataText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Nagłówek panelu rozmowy oraz kontekst udostępnionego pliku.
final class ChatPanelConversationHeader extends StatelessWidget {
  const ChatPanelConversationHeader({
    required this.conversation,
    required this.onBack,
    this.title,
    this.avatarUserId,
    this.avatarUrl,
    this.avatarLabel,
    this.subtitle,
    this.subtitleWidget,
    this.onOpenMembers,
    this.onOpenFullView,
    this.resourceContext,
    this.messageActions,
    this.conversationRepository,
    super.key,
  });

  final ChatConversation conversation;
  final VoidCallback onBack;

  /// Nagłówek podany przez właściciela, np. etykieta rozmówcy w DM.
  final String? title;

  /// UUID rozmówcy w DM; brak oznacza awatar grupy z inicjałów nazwy.
  final String? avatarUserId;

  /// URL zdjęcia z profilu rozmówcy; brak oznacza awatar z inicjałami.
  final String? avatarUrl;

  /// Etykieta awatara; w DM rozmówca, w grupie nazwa rozmowy.
  final String? avatarLabel;

  /// Jedna linia kontekstu pod nazwą, np. liczba uczestników; brak ją ukrywa.
  final String? subtitle;

  /// Linia kontekstu jako widget (np. status rozmówcy); ma pierwszeństwo
  /// przed [subtitle], bo niesie treść z serwera.
  final Widget? subtitleWidget;

  /// Otwiera uczestników i, zależnie od roli, akcję dodawania osób.
  final VoidCallback? onOpenMembers;

  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  /// Port akcji wiadomości; brak oznacza brak list przypiętych i zakładek.
  final ChatMessageActionsRepository? messageActions;

  /// ACL-owane pobieranie rozmowy dla skoku z zakładki do innej konwersacji.
  final ChatConversationRepository? conversationRepository;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, Sizes.p4),
    child: Column(
      children: [
        if (resourceContext case final current?)
          _ResourceChatHeader(context: current),
        Row(
          children: [
            IconButton(
              tooltip: context.l10n.globalChatBackToConversations,
              onPressed: onBack,
              icon: const Icon(Symbols.arrow_back_rounded, size: 19),
            ),
            AppUserAvatar(
              userId: avatarUserId,
              displayName: avatarLabel ?? _headerTitle(context),
              avatarUrl: avatarUrl,
              hasCustomAvatar: avatarUrl?.trim().isNotEmpty == true,
              radius: context.chatTheme.avatarHeader / 2,
            ),
            const SizedBox(width: Sizes.p8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _headerTitle(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.chatTheme.contentStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.chatTheme.incomingText,
                    ),
                  ),
                  if (subtitleWidget != null)
                    subtitleWidget!
                  else if (subtitle?.trim().isNotEmpty ?? false)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.chatTheme.metadataStyle.copyWith(
                        color: context.chatTheme.metadataText,
                      ),
                    ),
                ],
              ),
            ),
            if (onOpenMembers case final openMembers?)
              IconButton(
                tooltip: context.l10n.chatMembersOpen,
                onPressed: openMembers,
                icon: const Icon(Symbols.group_add, size: 19),
              ),
            Builder(
              builder: (context) {
                final presence = context.read<ChatPresenceRepository?>();
                final userId =
                    context.read<AuthSessionPort?>()?.snapshot.user?.userId ??
                    '';
                if (presence == null || userId.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ChatStatusMenuButton(
                  repository: presence,
                  currentUserId: userId,
                  icon: const Icon(Symbols.mood, size: 18),
                );
              },
            ),
            _ChatConversationActionsMenu(
              conversation: conversation,
              messageActions: messageActions,
              conversationRepository: conversationRepository,
              onOpenFullView: onOpenFullView,
            ),
          ],
        ),
      ],
    ),
  );
}

/// Nazwa w nagłówku: etykieta właściciela, nazwa rozmowy albo neutralny fallback.
extension on ChatPanelConversationHeader {
  /// Zwraca etykietę tytułu bez powtarzania reguły w kilku miejscach.
  String _headerTitle(BuildContext context) => title?.trim().isNotEmpty == true
      ? title!.trim()
      : conversation.name?.trim().isNotEmpty == true
      ? conversation.name!.trim()
      : context.l10n.chatMembersFallbackName;
}

/// Menu rozmowy: wyciszenie, przypięte, zakładki i preferencje powiadomień.
///
/// Każda pozycja ma realny skutek: wyciszenie zapisuje politykę serwera,
/// listy czytają porty akcji, a preferencje otwierają istniejący modal.
class _ChatConversationActionsMenu extends StatelessWidget {
  const _ChatConversationActionsMenu({
    required this.conversation,
    required this.messageActions,
    required this.conversationRepository,
    this.onOpenFullView,
  });

  final ChatConversation conversation;
  final ChatMessageActionsRepository? messageActions;
  final ChatConversationRepository? conversationRepository;

  /// Otwiera pełny widok rozmowy; brak oznacza brak pozycji w menu.
  final VoidCallback? onOpenFullView;

  @override
  Widget build(BuildContext context) {
    final muteCubit = context.watch<ChatConversationMuteCubit?>();
    final isMuted = muteCubit?.state.isMuted ?? false;
    return Builder(
      builder: (anchorContext) => IconButton(
        tooltip: context.l10n.chatMembersActions,
        onPressed: () => unawaited(
          AppContextMenu.show(
            anchorContext,
            globalPosition: AppContextMenu.positionFor(anchorContext),
            actions: [
              AppContextMenuAction(
                label: isMuted
                    ? context.l10n.chatMuteUnmute
                    : context.l10n.chatMuteMute,
                icon: isMuted ? Symbols.volume_up : Symbols.volume_off,
                enabled: muteCubit != null && !muteCubit.state.isBusy,
                onTap: (_) => _handle(context, 'mute'),
              ),
              AppContextMenuAction(
                label: context.l10n.chatPinnedOpen,
                icon: Symbols.push_pin,
                enabled: messageActions != null,
                onTap: (_) => _handle(context, 'pinned'),
              ),
              AppContextMenuAction(
                label: context.l10n.chatBookmarksOpen,
                icon: Symbols.bookmarks,
                enabled: messageActions != null,
                onTap: (_) => _handle(context, 'bookmarks'),
              ),
              AppContextMenuAction(
                label: conversation.isArchived
                    ? context.l10n.chatRestoreAction
                    : context.l10n.chatArchiveAction,
                icon: conversation.isArchived
                    ? Symbols.unarchive
                    : Symbols.archive,
                onTap: (_) => _handle(
                  context,
                  conversation.isArchived ? 'restore' : 'archive',
                ),
              ),
              AppContextMenuAction(
                label: context.l10n.chatSearchOpen,
                icon: Symbols.search,
                enabled: context.read<ChatSearchCubit?>() != null,
                onTap: (_) => _handle(context, 'search'),
              ),
              AppContextMenuAction(
                label: context.l10n.chatMembersActions,
                icon: Symbols.group,
                enabled: context.read<ChatMembersRepository?>() != null,
                onTap: (_) => _handle(context, 'members'),
              ),
              if (onOpenFullView != null)
                AppContextMenuAction(
                  label: context.l10n.globalChatOpenFullView,
                  icon: Symbols.open_in_new_rounded,
                  onTap: (_) => _handle(context, 'fullView'),
                ),
              AppContextMenuAction(
                label: context.l10n.chatConversationNotificationSettingsOpen,
                icon: Symbols.notifications_rounded,
                onTap: (_) => _handle(context, 'preferences'),
              ),
            ],
          ),
        ),
        icon: const Icon(Symbols.more_vert, size: 18),
      ),
    );
  }

  /// Archiwizuje albo przywraca rozmowę i zamyka widok po sukcesie.
  ///
  /// Archiwizacja wymaga potwierdzenia, bo zmienia listę rozmów; przywrócenie
  /// nie, bo jest odwracalne i nie ukrywa niczego.
  Future<void> _setArchived(
    BuildContext context, {
    required bool archived,
  }) async {
    final management = context.read<ChatConversationManagementRepository?>();
    if (management == null) return;
    if (archived) {
      final confirmed = await DevPlannerModalHost.showDialog<bool>(
        context,
        builder: (dialogContext) => ChatSurfaceDialog(
          title: dialogContext.l10n.chatArchiveConfirmTitle,
          content: Text(dialogContext.l10n.chatArchiveConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.l10n.chatCreationCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(dialogContext.l10n.chatArchiveAction),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
    }
    final result = archived
        ? await management.archiveConversation(conversation.id)
        : await management.restoreConversation(conversation.id);
    if (!context.mounted) return;
    result.fold((_) {}, (_) {
      // Rozmowa wyszła z bieżącego widoku, więc panel wraca do listy.
      context.read<ChatPanelSelectionCubit>().clear();
      unawaited(context.read<ChatInboxCubit?>()?.refresh());
    });
  }

  Future<void> _handle(BuildContext context, String value) async {
    switch (value) {
      case 'search':
        context.read<ChatSearchCubit?>()?.open();
      case 'members':
        await ChatMembersSheet.show(
          context,
          membersRepository: context.read<ChatMembersRepository?>(),
          conversation: conversation,
          currentUserId:
              context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
          conversationManagement: context
              .read<ChatConversationManagementRepository?>(),
          presenceRepository: context.read<ChatPresenceRepository?>(),
          directoryRepository: context.read<ChatDirectoryRepository?>(),
        );
      case 'fullView':
        onOpenFullView?.call();
      case 'mute':
        await context.read<ChatConversationMuteCubit?>()?.toggleMute();
      case 'pinned':
        await ChatPinnedMessagesSheet.show(
          context,
          repository: messageActions,
          conversationId: conversation.id,
          onOpenMessage: (messageId) => unawaited(
            context.read<ChatConversationCubit>().ensureTargetLoaded(messageId),
          ),
        );
      case 'bookmarks':
        await ChatBookmarksSheet.show(
          context,
          repository: messageActions,
          onOpenMessage: (conversationId, messageId) => unawaited(
            _openSavedMessage(context, conversationId, messageId),
          ),
        );
      case 'archive':
        await _setArchived(context, archived: true);
      case 'restore':
        await _setArchived(context, archived: false);
      case 'preferences':
        if (!context.mounted) return;
        await ChatConversationNotificationSettingsModal.show(
          context,
          conversationId: conversation.id,
        );
    }
  }

  Future<void> _openSavedMessage(
    BuildContext context,
    String conversationId,
    String messageId,
  ) async {
    final selection = context.read<ChatPanelSelectionCubit?>();
    if (selection == null) return;
    final inbox = context.read<ChatInboxCubit?>()?.state;
    if (inbox case ChatInboxReady(:final items)) {
      for (final item in items) {
        if (item.conversation.id == conversationId) {
          selection.select(
            item.conversation,
            role: item.role,
            targetMessageId: messageId,
          );
          return;
        }
      }
    }
    final repository = conversationRepository;
    if (repository == null) return;
    final result = await repository.getConversation(conversationId);
    if (!context.mounted) return;
    result.fold(
      (_) => AppToast.show(
        context,
        message: context.l10n.globalChatLoadFailureTitle,
        tone: AppToastTone.error,
      ),
      (conversation) => selection.select(
        conversation,
        targetMessageId: messageId,
      ),
    );
  }
}

/// Zwięzły, świeży kontekst pliku nad rozmową Resource Chat.
final class _ResourceChatHeader extends StatelessWidget {
  const _ResourceChatHeader({required this.context});

  final ResourceChatFileContext context;

  @override
  Widget build(BuildContext buildContext) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p8,
        Sizes.p4,
        Sizes.p8,
        Sizes.p8,
      ),
      child: Text(
        buildContext.l10n.resourceChatFileHeader(
          context.fileName,
          context.ownerUserId,
          context.accessLevel,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: buildContext.text.labelSmall?.copyWith(
          color: buildContext.colors.onSurfaceVariant,
        ),
      ),
    ),
  );
}

/// Zwarta lista wiadomości używana wyłącznie w prawym panelu Chat.
final class ChatPanelMessageList extends StatefulWidget {
  const ChatPanelMessageList({
    required this.messages,
    required this.isSending,
    required this.nextCursor,
    required this.isLoadingMore,
    required this.loadMoreFailed,
    required this.onLoadMore,
    required this.onNewestMessageVisible,
    required this.onReply,
    required this.onEnsureTargetLoaded,
    this.onThread,
    this.targetMessageId,
    this.canModerate = false,
    this.participantLabels = const <String, String>{},
    this.participantAvatarUrls = const <String, String?>{},
    this.compact = true,
    super.key,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final Future<void> Function() onLoadMore;
  final ValueChanged<String> onNewestMessageVisible;
  final ValueChanged<ChatMessage> onReply;
  final Future<void> Function(String messageId) onEnsureTargetLoaded;

  /// Otwiera wątek wiadomości.
  final ValueChanged<ChatMessage>? onThread;

  /// Wiadomość, do której widok ma przewinąć po otwarciu z wyszukiwania.
  final String? targetMessageId;

  /// Etykiety autorów z katalogu; w DM mapa jest pusta, więc autor się nie pokazuje.
  final Map<String, String> participantLabels;

  /// Adresy avatarów autorów potwierdzone przez katalog uczestników.
  final Map<String, String?> participantAvatarUrls;

  /// Czy rola pozwala moderować cudzą treść; backend i tak egzekwuje ponownie.
  final bool canModerate;

  /// Tryb compact: mniejszy gutter historii i szersze dymki w panelu.
  final bool compact;

  @override
  State<ChatPanelMessageList> createState() => _ChatPanelMessageListState();
}

class _ChatPanelMessageListState extends State<ChatPanelMessageList> {
  /// Odległość od dolnej krawędzi, przy której uznajemy, że użytkownik ją widzi.
  static const double _bottomThreshold = 24;
  static const double _historyEdgeThreshold = 180;

  final GlobalKey _targetKey = GlobalKey();
  final GlobalKey _newestMessageKey = GlobalKey();
  final GlobalKey _viewportKey = GlobalKey();
  final ScrollController _scroll = ScrollController();
  bool _scrolledToTarget = false;
  bool _atBottom = true;
  int _pendingNew = 0;
  String? _autoRequestedCursor;
  String? _reportedNewestMessageId;
  bool _visibilityCheckScheduled = false;
  String? _replyTargetMessageId;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    FocusManager.instance.addListener(_scheduleVisibilityCheck);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadMore());
    _scheduleVisibilityCheck();
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    FocusManager.instance.removeListener(_scheduleVisibilityCheck);
    super.dispose();
  }

  /// Lista jest odwrócona, więc dół historii to pozycja zerowa.
  void _onScroll() {
    _maybeLoadMore();
    _scheduleVisibilityCheck();
    final atBottom = !_scroll.hasClients || _scroll.offset <= _bottomThreshold;
    if (atBottom != _atBottom || (atBottom && _pendingNew != 0)) {
      setState(() {
        _atBottom = atBottom;
        if (atBottom) _pendingNew = 0;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleVisibilityCheck();
  }

  void _scheduleVisibilityCheck() {
    if (_visibilityCheckScheduled) return;
    _visibilityCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visibilityCheckScheduled = false;
      if (!mounted || widget.messages.isEmpty) return;
      if (ModalRoute.of(context)?.isCurrent == false) {
        _reportedNewestMessageId = null;
        return;
      }
      final messageId = widget.messages.last.id;
      final messageObject = _newestMessageKey.currentContext
          ?.findRenderObject();
      final viewportObject = _viewportKey.currentContext?.findRenderObject();
      if (messageObject is! RenderBox ||
          viewportObject is! RenderBox ||
          !messageObject.attached ||
          !viewportObject.attached ||
          messageObject.size.isEmpty ||
          viewportObject.size.isEmpty) {
        _reportedNewestMessageId = null;
        return;
      }
      final messageRect =
          messageObject.localToGlobal(Offset.zero) & messageObject.size;
      final viewportRect =
          viewportObject.localToGlobal(Offset.zero) & viewportObject.size;
      final isVisible = ChatMessageVisibility.isMajorityVisible(
        messageRect,
        viewportRect,
      );
      if (!isVisible) {
        _reportedNewestMessageId = null;
        return;
      }
      if (_reportedNewestMessageId == messageId) return;
      _reportedNewestMessageId = messageId;
      widget.onNewestMessageVisible(messageId);
    });
  }

  /// Pobiera starszą stronę, gdy użytkownik dochodzi do górnej krawędzi.
  ///
  /// Cursor jest traktowany jako nieprzezroczysty klucz; ta sama strona nie
  /// jest automatycznie żądana wielokrotnie po błędzie.
  void _maybeLoadMore() {
    if (!_scroll.hasClients ||
        widget.nextCursor == null ||
        widget.isLoadingMore ||
        widget.loadMoreFailed) {
      return;
    }
    final position = _scroll.position;
    if (position.maxScrollExtent - position.pixels > _historyEdgeThreshold) {
      return;
    }
    final cursor = widget.nextCursor!;
    if (_autoRequestedCursor == cursor) return;
    _autoRequestedCursor = cursor;
    unawaited(widget.onLoadMore());
  }

  void _retryLoadMore() {
    final cursor = widget.nextCursor;
    if (cursor == null || widget.isLoadingMore) return;
    _autoRequestedCursor = cursor;
    unawaited(widget.onLoadMore());
  }

  /// Wraca do najnowszych wiadomości i czyści licznik nowych.
  Future<void> _jumpToLatest() async {
    if (!_scroll.hasClients) return;
    setState(() => _pendingNew = 0);
    await _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(covariant ChatPanelMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleVisibilityCheck();
    if (oldWidget.nextCursor != widget.nextCursor ||
        oldWidget.isLoadingMore != widget.isLoadingMore ||
        oldWidget.loadMoreFailed != widget.loadMoreFailed) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadMore());
    }
    if (oldWidget.targetMessageId != widget.targetMessageId) {
      _replyTargetMessageId = null;
      _scrolledToTarget = false;
    }
    // Wiadomość, która przyszła, gdy użytkownik czyta starszy fragment, nigdy
    // nie przewija mu widoku; tylko liczy się do wskaźnika nad dolną krawędzią.
    final added = ChatMessageGrouping.countNewArrivals(
      oldWidget.messages,
      widget.messages,
    );
    if (added > 0 && !_atBottom) {
      _pendingNew += added;
    }
  }

  /// Przewija do wiadomości z wyszukiwania, gdy ta jest już zbudowana.
  ///
  /// Lista panelu buduje wiersze leniwie, więc skok działa w ramach
  /// załadowanej historii; pozycję spoza strony otwiera doładowanie historii.
  void _scheduleScrollToTarget() {
    final targetMessageId = _replyTargetMessageId ?? widget.targetMessageId;
    if (_scrolledToTarget || targetMessageId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = _targetKey.currentContext;
      if (targetContext == null || !mounted) return;
      _scrolledToTarget = true;
      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.4,
        duration: const Duration(milliseconds: 200),
      );
    });
  }

  void _openReplyTarget(String messageId) {
    setState(() {
      _replyTargetMessageId = messageId;
      _scrolledToTarget = false;
    });
    unawaited(widget.onEnsureTargetLoaded(messageId));
  }

  @override
  Widget build(BuildContext context) {
    _scheduleScrollToTarget();
    final currentUserId =
        context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '';
    final secondary = context.read<ChatMessageSecondaryActionsCubit?>();
    final isPinned = secondary?.state.pinnedMessageIds ?? const <String>{};
    final isBookmarked =
        secondary?.state.bookmarkedMessageIds ?? const <String>{};
    final forwardTargets = _forwardTargets(context);
    final chat = context.chatTheme;
    final showIdentity = widget.participantLabels.isNotEmpty;
    // Lista jest odwrócona, więc historię czytamy od końca.
    final timeline = ChatMessageGrouping.timeline(
      widget.messages,
      currentUserId: currentUserId,
    ).reversed.toList(growable: false);
    return LayoutBuilder(
      builder: (context, constraints) {
        final gutter = widget.compact
            ? chat.compactHistoryGutter
            : chat.historyGutter;
        final identityWidth = showIdentity
            ? chat.avatarBubble + chat.seriesGap + Sizes.p4
            : 0.0;
        final factor = widget.compact
            ? chat.compactMaxBubbleWidthFactor
            : chat.maxBubbleWidthFactor;
        final available = math.max(
          0.0,
          constraints.maxWidth - gutter * 2 - identityWidth,
        );
        final maxBubbleWidth = math.min(
          available * factor,
          chat.maxBubbleWidth,
        );
        // Zaznaczanie działa myszą i klawiaturą, a menu akcji oferuje kopiowanie
        // całości albo wyłącznie zaznaczenia.
        return ClipRect(
          key: _viewportKey,
          child: SelectionArea(
            child: Stack(
              children: [
                ListView.separated(
                  controller: _scroll,
                  padding: EdgeInsets.symmetric(
                    horizontal: gutter,
                    vertical: Sizes.p8,
                  ),
                  reverse: true,
                  itemCount:
                      timeline.length +
                      (widget.isSending ? 1 : 0) +
                      (widget.nextCursor != null ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    if (widget.isSending && index == 0) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final timelineIndex = index - (widget.isSending ? 1 : 0);
                    if (timelineIndex >= timeline.length) {
                      if (widget.loadMoreFailed) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Sizes.p12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.l10n.chatInboxLoadMoreFailed,
                                style: chat.metadataStyle.copyWith(
                                  color: chat.error,
                                ),
                              ),
                              const SizedBox(width: Sizes.p8),
                              TextButton(
                                onPressed: _retryLoadMore,
                                child: Text(context.l10n.chatInboxRetry),
                              ),
                            ],
                          ),
                        );
                      }
                      if (widget.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.p12),
                          child: Center(
                            child: SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      return const SizedBox(height: Sizes.p8);
                    }
                    final entry = timeline[timelineIndex];
                    if (entry is ChatTimelineDate) {
                      return ChatMessageDateSeparator(day: entry.day);
                    }
                    final item = (entry as ChatTimelineSeries).series;
                    return ChatMessageSeriesView(
                      series: item,
                      maxWidth: maxBubbleWidth,
                      authorLabel: widget.participantLabels[item.authorUserId],
                      authorAvatarUrl:
                          widget.participantAvatarUrls[item.authorUserId],
                      showIdentity: showIdentity,
                      bubbleBuilder: (message, isFirst, position) {
                        final messageMenu = message.isDeleted
                            ? null
                            : ChatMessageActionMenu(
                                message: message,
                                isOwnMessage: item.isOwnAuthor,
                                canModerate: widget.canModerate,
                                isPinned: isPinned.contains(message.id),
                                isBookmarked: isBookmarked.contains(message.id),
                                currentUserId: currentUserId,
                                onReply: widget.onReply,
                                onThread: widget.onThread,
                                onEdit: (target) => unawaited(
                                  ChatMessageActionDialogs.edit(
                                    context,
                                    message: target,
                                  ),
                                ),
                                onDelete: (target) => unawaited(
                                  ChatMessageActionDialogs.confirmDelete(
                                    context,
                                    message: target,
                                  ),
                                ),
                                onForward: (target) => unawaited(
                                  ChatMessageActionDialogs.forward(
                                    context,
                                    message: target,
                                    conversations: forwardTargets,
                                  ),
                                ),
                              );
                        final replyTarget = widget.messages
                            .where(
                              (item) => item.id == message.replyToMessageId,
                            )
                            .firstOrNull;
                        final bubble = ChatMessageBubble(
                          key:
                              message.id ==
                                  (_replyTargetMessageId ??
                                      widget.targetMessageId)
                              ? _targetKey
                              : ValueKey<String>(
                                  'chat-panel-message-${message.id}',
                                ),
                          message: message,
                          isOwn: item.isOwnAuthor,
                          replyTarget: replyTarget,
                          replyTargetAuthorLabel: replyTarget == null
                              ? null
                              : widget.participantLabels[replyTarget
                                    .authorUserId],
                          maxWidth: maxBubbleWidth,
                          seriesPosition: position,
                          authorLabel:
                              widget.participantLabels[message.authorUserId],
                          showAuthor: isFirst,
                          highlighted:
                              message.id ==
                              (_replyTargetMessageId ?? widget.targetMessageId),
                          onOpenReplyTarget: _openReplyTarget,
                          onPickReaction: () => unawaited(
                            showChatQuickReactionPicker(
                              context,
                              message: message,
                            ),
                          ),
                          onRetry: message.clientMessageId.isEmpty
                              ? null
                              : () => context
                                    .read<ChatConversationCubit?>()
                                    ?.retry(
                                      message.clientMessageId,
                                    ),
                          menu: messageMenu,
                          onContextMenu: messageMenu == null
                              ? null
                              : (position) => unawaited(
                                  messageMenu.showAt(context, position),
                                ),
                          reactions: message.reactions.isEmpty
                              ? null
                              : ChatMessageReactionsBar(
                                  summaries: message.reactions,
                                  onToggle: (emoji, isOwn) => unawaited(
                                    isOwn
                                        ? context
                                              .read<
                                                ChatMessageSecondaryActionsCubit
                                              >()
                                              .removeReaction(
                                                messageId: message.id,
                                                emoji: emoji,
                                              )
                                        : context
                                              .read<
                                                ChatMessageSecondaryActionsCubit
                                              >()
                                              .react(
                                                messageId: message.id,
                                                emoji: emoji,
                                              ),
                                  ),
                                ),
                        );
                        return message.id == widget.messages.last.id
                            ? SizedBox(key: _newestMessageKey, child: bubble)
                            : bubble;
                      },
                    );
                  },
                ),
                if (_pendingNew > 0)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: Sizes.p8,
                    child: Center(
                      child: Material(
                        color: chat.selectedSurface,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        child: InkWell(
                          key: const ValueKey('chat-new-messages'),
                          onTap: () => unawaited(_jumpToLatest()),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.p12,
                              vertical: Sizes.p6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.l10n.chatNewMessages(_pendingNew),
                                  style: chat.metadataStyle.copyWith(
                                    color: chat.linkText,
                                  ),
                                ),
                                const SizedBox(width: Sizes.p4),
                                Icon(
                                  Symbols.arrow_downward,
                                  size: 14,
                                  color: chat.linkText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Rozmowy dostępne jako cel przekazania; brak listy oznacza brak akcji.
  static List<ChatInboxItem> _forwardTargets(BuildContext context) {
    final state = context.read<ChatInboxCubit?>()?.state;
    return state is ChatInboxReady ? state.items : const <ChatInboxItem>[];
  }
}
