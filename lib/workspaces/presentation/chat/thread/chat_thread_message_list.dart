import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_dialogs.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SelectedContent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Historia, selekcja i akcje wiadomości w panelu odpowiedzi wątku.
class ChatThreadMessageList extends StatelessWidget {
  const ChatThreadMessageList({
    required this.state,
    required this.rootMessage,
    required this.currentUserId,
    required this.hasTextSelection,
    required this.onSelectionChanged,
    this.messageActionsRepository,
    this.forwardTargets = const <ChatInboxItem>[],
    this.canModerate = false,
    super.key,
  });

  final ChatThreadState state;
  final ChatMessage rootMessage;
  final String currentUserId;
  final bool hasTextSelection;
  final ValueChanged<SelectedContent?> onSelectionChanged;
  final ChatMessageActionsRepository? messageActionsRepository;
  final List<ChatInboxItem> forwardTargets;
  final bool canModerate;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return switch (state) {
      ChatThreadLoading() => const Center(child: CircularProgressIndicator()),
      ChatThreadFailure() => Center(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.chatThreadLoadFailureMessage,
                textAlign: TextAlign.center,
                style: chat.contentStyle.copyWith(color: chat.metadataText),
              ),
              TextButton(
                onPressed: () => context.read<ChatThreadCubit>().load(),
                child: Text(context.l10n.chatInboxRetry),
              ),
            ],
          ),
        ),
      ),
      ChatThreadDetached(:final message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Text(
            message.isEmpty
                ? context.l10n.chatThreadLoadFailureMessage
                : message,
            textAlign: TextAlign.center,
            style: chat.contentStyle.copyWith(color: chat.metadataText),
          ),
        ),
      ),
      ChatThreadReady(
        :final messages,
        :final nextCursor,
        :final isLoadingMore,
        :final loadMoreFailed,
      ) =>
        SelectionArea(
          onSelectionChanged: onSelectionChanged,
          child: ListView.separated(
            padding: const EdgeInsets.all(Sizes.p12),
            itemCount: messages.length + (nextCursor == null ? 0 : 1),
            separatorBuilder: (_, _) => Gaps.h8,
            itemBuilder: (context, index) {
              if (index == messages.length) {
                if (isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(Sizes.p8),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                if (loadMoreFailed) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.chatInboxLoadMoreFailed,
                          textAlign: TextAlign.center,
                          style: chat.metadataStyle.copyWith(
                            color: chat.metadataText,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.read<ChatThreadCubit>().loadMore(),
                          child: Text(context.l10n.chatInboxRetry),
                        ),
                      ],
                    ),
                  );
                }
                return TextButton(
                  onPressed: () => context.read<ChatThreadCubit>().loadMore(),
                  child: Text(context.l10n.chatThreadLoadOlder),
                );
              }
              final message = messages[index];
              final isOwn = message.authorUserId == currentUserId;
              final menu = _messageMenu(context, message);
              return Align(
                alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
                child: ChatMessageBubble(
                  message: message,
                  isOwn: isOwn,
                  replyTarget:
                      messages
                          .where((item) => item.id == message.replyToMessageId)
                          .firstOrNull ??
                      (rootMessage.id == message.replyToMessageId
                          ? rootMessage
                          : null),
                  maxWidth: 560,
                  menu:
                      menu ??
                      Builder(
                        builder: (anchorContext) => IconButton(
                          tooltip: context.l10n.chatMessageActionsTooltip,
                          padding: EdgeInsets.zero,
                          iconSize: 16,
                          onPressed: () => unawaited(
                            AppContextMenu.show(
                              anchorContext,
                              globalPosition: AppContextMenu.positionFor(
                                anchorContext,
                              ),
                              headerTitle:
                                  context.l10n.chatMessageActionsTooltip,
                              actions: _fallbackMessageActions(
                                anchorContext,
                                message,
                              ),
                            ),
                          ),
                          icon: const Icon(Symbols.more_vert),
                        ),
                      ),
                  onContextMenu: hasTextSelection
                      ? null
                      : (position) => unawaited(
                          menu?.showAt(context, position) ??
                              AppContextMenu.show(
                                context,
                                globalPosition: position,
                                headerTitle:
                                    context.l10n.chatMessageActionsTooltip,
                                actions: _fallbackMessageActions(
                                  context,
                                  message,
                                ),
                              ),
                        ),
                ),
              );
            },
          ),
        ),
    };
  }

  ChatMessageActionMenu? _messageMenu(
    BuildContext context,
    ChatMessage message,
  ) {
    final secondary = context.read<ChatMessageSecondaryActionsCubit?>();
    if (secondary == null) return null;
    return ChatMessageActionMenu(
      message: message,
      isOwnMessage: message.authorUserId == currentUserId,
      canModerate: canModerate,
      isPinned: secondary.state.pinnedMessageIds.contains(message.id),
      isBookmarked: secondary.state.bookmarkedMessageIds.contains(message.id),
      currentUserId: currentUserId,
      onEdit: messageActionsRepository == null
          ? null
          : (target) => unawaited(
              ChatMessageActionDialogs.edit(context, message: target),
            ),
      onDelete: messageActionsRepository == null
          ? null
          : (target) => unawaited(
              ChatMessageActionDialogs.confirmDelete(context, message: target),
            ),
      onForward: forwardTargets.isEmpty
          ? null
          : (target, position) => unawaited(
              ChatMessageActionDialogs.forward(
                context,
                message: target,
                conversations: forwardTargets,
                globalPosition: position,
              ),
            ),
    );
  }

  List<AppContextMenuAction> _fallbackMessageActions(
    BuildContext context,
    ChatMessage message,
  ) => <AppContextMenuAction>[
    AppContextMenuAction(
      label: context.l10n.chatMessageCopy,
      icon: Symbols.content_copy,
      onTap: (_) => unawaited(copyChatMessage(context, message)),
    ),
    AppContextMenuAction(
      label: context.l10n.chatMessageCopySelection,
      icon: Symbols.copy_all,
      onTap: (_) => unawaited(copyChatSelection(context)),
    ),
  ];
}
