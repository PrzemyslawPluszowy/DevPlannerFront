import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_dialogs.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_list_sheets.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_rich_text_body.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart';
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
        return Semantics(
          liveRegion: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              border: Border(
                bottom: BorderSide(color: context.colors.outlineVariant),
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
                    color: context.colors.onSurfaceVariant,
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
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
    this.onOpenFullView,
    this.resourceContext,
    this.messageActions,
    super.key,
  });

  final ChatConversation conversation;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  /// Port akcji wiadomości; brak oznacza brak list przypiętych i zakładek.
  final ChatMessageActionsRepository? messageActions;

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
            Expanded(
              child: Text(
                conversation.name?.trim().isNotEmpty == true
                    ? conversation.name!
                    : conversation.scopeKey,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleSmall,
              ),
            ),
            IconButton(
              key: const ValueKey('chat-panel-members'),
              tooltip: context.l10n.chatMembersActions,
              onPressed: () => unawaited(
                ChatMembersSheet.show(
                  context,
                  membersRepository: context.read<ChatMembersRepository?>(),
                  conversation: conversation,
                  currentUserId:
                      context.read<AuthSessionPort?>()?.snapshot.user?.userId ??
                      '',
                  conversationManagement: context
                      .read<ChatConversationManagementRepository?>(),
                  presenceRepository: context.read<ChatPresenceRepository?>(),
                  directoryRepository: context.read<ChatDirectoryRepository?>(),
                ),
              ),
              icon: const Icon(Symbols.group, size: 18),
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
            ),
            if (onOpenFullView != null)
              IconButton(
                tooltip: context.l10n.globalChatOpenFullView,
                onPressed: onOpenFullView,
                icon: const Icon(Symbols.open_in_new_rounded, size: 18),
              ),
          ],
        ),
      ],
    ),
  );
}

/// Menu rozmowy: wyciszenie, przypięte, zakładki i preferencje powiadomień.
///
/// Każda pozycja ma realny skutek: wyciszenie zapisuje politykę serwera,
/// listy czytają porty akcji, a preferencje otwierają istniejący modal.
class _ChatConversationActionsMenu extends StatelessWidget {
  const _ChatConversationActionsMenu({
    required this.conversation,
    required this.messageActions,
  });

  final ChatConversation conversation;
  final ChatMessageActionsRepository? messageActions;

  @override
  Widget build(BuildContext context) {
    final muteCubit = context.watch<ChatConversationMuteCubit?>();
    final isMuted = muteCubit?.state.isMuted ?? false;
    return PopupMenuButton<String>(
      tooltip: context.l10n.chatMembersActions,
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'mute',
          enabled: muteCubit != null && !muteCubit.state.isBusy,
          child: Row(
            children: [
              Icon(isMuted ? Symbols.volume_up : Symbols.volume_off, size: 18),
              const SizedBox(width: Sizes.p8),
              Text(
                isMuted
                    ? context.l10n.chatMuteUnmute
                    : context.l10n.chatMuteMute,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'pinned',
          enabled: messageActions != null,
          child: Row(
            children: [
              const Icon(Symbols.push_pin, size: 18),
              const SizedBox(width: Sizes.p8),
              Text(context.l10n.chatPinnedOpen),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'bookmarks',
          enabled: messageActions != null,
          child: Row(
            children: [
              const Icon(Symbols.bookmarks, size: 18),
              const SizedBox(width: Sizes.p8),
              Text(context.l10n.chatBookmarksOpen),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: conversation.isArchived ? 'restore' : 'archive',
          child: Row(
            children: [
              Icon(
                conversation.isArchived ? Symbols.unarchive : Symbols.archive,
                size: 18,
              ),
              const SizedBox(width: Sizes.p8),
              Text(
                conversation.isArchived
                    ? context.l10n.chatRestoreAction
                    : context.l10n.chatArchiveAction,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'preferences',
          child: Row(
            children: [
              const Icon(Symbols.notifications_rounded, size: 18),
              const SizedBox(width: Sizes.p8),
              Text(context.l10n.chatConversationNotificationSettingsOpen),
            ],
          ),
        ),
      ],
      onSelected: (value) => unawaited(_handle(context, value)),
      icon: const Icon(Symbols.more_vert, size: 18),
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
        builder: (dialogContext) => AlertDialog(
          title: Text(dialogContext.l10n.chatArchiveConfirmTitle),
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
      case 'mute':
        await context.read<ChatConversationMuteCubit?>()?.toggleMute();
      case 'pinned':
        await ChatPinnedMessagesSheet.show(
          context,
          repository: messageActions,
          conversationId: conversation.id,
        );
      case 'bookmarks':
        await ChatBookmarksSheet.show(context, repository: messageActions);
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
    required this.onReply,
    this.onThread,
    this.targetMessageId,
    this.canModerate = false,
    super.key,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final ValueChanged<ChatMessage> onReply;

  /// Otwiera wątek wiadomości.
  final ValueChanged<ChatMessage>? onThread;

  /// Wiadomość, do której widok ma przewinąć po otwarciu z wyszukiwania.
  final String? targetMessageId;

  /// Czy rola pozwala moderować cudzą treść; backend i tak egzekwuje ponownie.
  final bool canModerate;

  @override
  State<ChatPanelMessageList> createState() => _ChatPanelMessageListState();
}

class _ChatPanelMessageListState extends State<ChatPanelMessageList> {
  final GlobalKey _targetKey = GlobalKey();
  bool _scrolledToTarget = false;

  @override
  void didUpdateWidget(covariant ChatPanelMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetMessageId != widget.targetMessageId) {
      _scrolledToTarget = false;
    }
  }

  /// Przewija do wiadomości z wyszukiwania, gdy ta jest już zbudowana.
  ///
  /// Lista panelu buduje wiersze leniwie, więc skok działa w ramach
  /// załadowanej historii; pozycję spoza strony otwiera doładowanie historii.
  void _scheduleScrollToTarget() {
    if (_scrolledToTarget || widget.targetMessageId == null) return;
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
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p8,
      ),
      reverse: true,
      itemCount: widget.messages.length + (widget.isSending ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: Sizes.p8),
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
        final message =
            widget.messages[widget.messages.length -
                1 -
                (widget.isSending ? index - 1 : index)];
        final reactions = message.reactions;
        final isTarget = message.id == widget.targetMessageId;
        return DecoratedBox(
          key: isTarget
              ? _targetKey
              : ValueKey<String>('chat-panel-message-${message.id}'),
          decoration: BoxDecoration(
            color: isTarget
                ? context.colors.primaryContainer
                : context.colors.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: isTarget
                ? Border.all(color: context.colors.primary, width: 1.2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: message.isDeleted
                          ? Text(context.l10n.globalChatDeletedMessage)
                          : ChatRichTextBody(
                              text: message.text,
                              deltaJson: message.deltaJson,
                            ),
                    ),
                    if (!message.isDeleted)
                      ChatMessageActionMenu(
                        message: message,
                        isOwnMessage:
                            currentUserId.isNotEmpty &&
                            message.authorUserId == currentUserId,
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
                      ),
                  ],
                ),
                if (reactions.isNotEmpty) ...[
                  const SizedBox(height: Sizes.p4),
                  ChatMessageReactionsBar(
                    summaries: reactions,
                    onToggle: (emoji, isOwn) => unawaited(
                      isOwn
                          ? context
                                .read<ChatMessageSecondaryActionsCubit>()
                                .removeReaction(
                                  messageId: message.id,
                                  emoji: emoji,
                                )
                          : context
                                .read<ChatMessageSecondaryActionsCubit>()
                                .react(messageId: message.id, emoji: emoji),
                    ),
                  ),
                ],
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
