// Importy są ułożone warstwowo: widok zależy od composera i kontraktów Chat.
// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_dialogs.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_state.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';

/// Prawy, lokalny subpanel odpowiedzi jednego wątku bez zmiany trasy.
class ChatThreadSidePanel extends StatefulWidget {
  const ChatThreadSidePanel({
    required this.conversationId,
    required this.rootMessage,
    required this.onClose,
    this.parentConversationStates,
    this.messageActionsRepository,
    this.forwardTargets = const <ChatInboxItem>[],
    this.canModerate = false,
    super.key,
  });
  final String conversationId;
  final ChatMessage rootMessage;
  final VoidCallback onClose;
  final Stream<ChatConversationState>? parentConversationStates;
  final ChatMessageActionsRepository? messageActionsRepository;
  final List<ChatInboxItem> forwardTargets;
  final bool canModerate;

  @override
  State<ChatThreadSidePanel> createState() => _ChatThreadSidePanelState();
}

class _ChatThreadSidePanelState extends State<ChatThreadSidePanel> {
  final ValueNotifier<bool> _accessRevocation = ValueNotifier(false);

  @override
  void dispose() {
    _accessRevocation.dispose();
    super.dispose();
  }

  ChatMessageActionMenu? _messageMenu(
    BuildContext context,
    ChatMessage message,
    String currentUserId,
  ) {
    final secondary = context.read<ChatMessageSecondaryActionsCubit?>();
    if (secondary == null) return null;
    final hasPrimaryActions = widget.messageActionsRepository != null;
    return ChatMessageActionMenu(
      message: message,
      isOwnMessage: message.authorUserId == currentUserId,
      canModerate: widget.canModerate,
      isPinned: secondary.state.pinnedMessageIds.contains(message.id),
      isBookmarked: secondary.state.bookmarkedMessageIds.contains(message.id),
      currentUserId: currentUserId,
      onEdit: hasPrimaryActions
          ? (target) => unawaited(
              ChatMessageActionDialogs.edit(context, message: target),
            )
          : null,
      onDelete: hasPrimaryActions
          ? (target) => unawaited(
              ChatMessageActionDialogs.confirmDelete(context, message: target),
            )
          : null,
      onForward: widget.forwardTargets.isEmpty
          ? null
          : (target) => unawaited(
              ChatMessageActionDialogs.forward(
                context,
                message: target,
                conversations: widget.forwardTargets,
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

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = ChatThreadCubit(
        context.read<ChatThreadRepository>(),
        deliveryRepository: context.read<ChatConversationRepository>(),
        conversationId: widget.conversationId,
        threadRootMessageId: widget.rootMessage.id,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: MultiBlocProvider(
      providers: [
        if (widget.messageActionsRepository case final repository?)
          BlocProvider(
            create: (_) => ChatMessageActionsCubit(repository: repository),
          ),
        if (widget.messageActionsRepository case final repository?)
          BlocProvider(
            create: (_) {
              final cubit = ChatMessageSecondaryActionsCubit(
                repository: repository,
              );
              unawaited(cubit.loadConversationPins(widget.conversationId));
              unawaited(cubit.loadBookmarks());
              return cubit;
            },
          ),
      ],
      child: Builder(
        builder: (context) {
          final chat = context.chatTheme;
          final currentUserId =
              context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '';
          return MultiBlocListener(
            listeners: [
              BlocListener<ChatThreadCubit, ChatThreadState>(
                listenWhen: (_, state) => state is ChatThreadDetached,
                listener: (_, _) => _accessRevocation.value = true,
              ),
              if (widget.messageActionsRepository != null)
                BlocListener<ChatMessageActionsCubit, ChatMessageActionsState>(
                  listener: (context, state) {
                    switch (state) {
                      case ChatMessageActionsUpdated(:final message):
                      case ChatMessageActionsDeleted(:final message):
                        context
                            .read<ChatThreadCubit>()
                            .applyMessageActionResult(message);
                      case ChatMessageActionsAccessRevoked():
                        context
                            .read<ChatThreadCubit>()
                            .detachForMessageAction();
                      case ChatMessageActionsConflict() ||
                          ChatMessageActionsFailure():
                        AppToast.show(
                          context,
                          message: context.l10n.chatActionFailureMessage,
                          tone: AppToastTone.error,
                        );
                      case ChatMessageActionsIdle() ||
                          ChatMessageActionsInProgress() ||
                          ChatMessageActionsRevisions():
                        break;
                    }
                  },
                ),
            ],
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: chat.separator),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.l10n.chatThreadTitle,
                            style: chat.contentStyle.copyWith(
                              color: chat.incomingText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: context.l10n.chatThreadClose,
                          onPressed: widget.onClose,
                          color: chat.metadataText,
                          icon: const Icon(Symbols.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.rootMessage.text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: chat.metadataStyle.copyWith(
                          color: chat.metadataText,
                        ),
                      ),
                    ),
                  ),
                  Gaps.h8,
                  Expanded(
                    child: BlocBuilder<ChatThreadCubit, ChatThreadState>(
                      builder: (context, state) => switch (state) {
                        ChatThreadLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        ChatThreadFailure() => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(Sizes.p16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.l10n.chatThreadLoadFailureMessage,
                                  textAlign: TextAlign.center,
                                  style: chat.contentStyle.copyWith(
                                    color: chat.metadataText,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.read<ChatThreadCubit>().load(),
                                  child: Text(context.l10n.chatInboxRetry),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ChatThreadDetached() => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(Sizes.p16),
                            child: Text(
                              context.l10n.chatThreadLoadFailureMessage,
                              textAlign: TextAlign.center,
                              style: chat.contentStyle.copyWith(
                                color: chat.metadataText,
                              ),
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
                            child: ListView.separated(
                              padding: const EdgeInsets.all(Sizes.p12),
                              itemCount:
                                  messages.length +
                                  (nextCursor == null ? 0 : 1),
                              separatorBuilder: (_, _) => Gaps.h8,
                              itemBuilder: (_, index) {
                                if (index == messages.length) {
                                  if (isLoadingMore) {
                                    return const Padding(
                                      padding: EdgeInsets.all(Sizes.p8),
                                      child: Center(
                                        child: SizedBox.square(
                                          dimension: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (loadMoreFailed) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.p8,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            context
                                                .l10n
                                                .chatInboxLoadMoreFailed,
                                            textAlign: TextAlign.center,
                                            style: chat.metadataStyle.copyWith(
                                              color: chat.metadataText,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => context
                                                .read<ChatThreadCubit>()
                                                .loadMore(),
                                            child: Text(
                                              context.l10n.chatInboxRetry,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return TextButton(
                                    onPressed: () => context
                                        .read<ChatThreadCubit>()
                                        .loadMore(),
                                    child: Text(
                                      context.l10n.chatThreadLoadOlder,
                                    ),
                                  );
                                }
                                final message = messages[index];
                                final isOwn =
                                    message.authorUserId == currentUserId;
                                final messageMenu = _messageMenu(
                                  context,
                                  message,
                                  currentUserId,
                                );
                                return Align(
                                  alignment: isOwn
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: ChatMessageBubble(
                                    message: message,
                                    isOwn: isOwn,
                                    replyTarget:
                                        messages
                                            .where(
                                              (item) =>
                                                  item.id ==
                                                  message.replyToMessageId,
                                            )
                                            .firstOrNull ??
                                        (widget.rootMessage.id ==
                                                message.replyToMessageId
                                            ? widget.rootMessage
                                            : null),
                                    maxWidth: 560,
                                    menu:
                                        messageMenu ??
                                        Builder(
                                          builder: (anchorContext) => IconButton(
                                            tooltip: context
                                                .l10n
                                                .chatMessageActionsTooltip,
                                            padding: EdgeInsets.zero,
                                            iconSize: 16,
                                            onPressed: () => unawaited(
                                              AppContextMenu.show(
                                                anchorContext,
                                                globalPosition:
                                                    AppContextMenu.positionFor(
                                                      anchorContext,
                                                    ),
                                                headerTitle: context
                                                    .l10n
                                                    .chatMessageActionsTooltip,
                                                actions:
                                                    _fallbackMessageActions(
                                                      anchorContext,
                                                      message,
                                                    ),
                                              ),
                                            ),
                                            icon: const Icon(Symbols.more_vert),
                                          ),
                                        ),
                                    onContextMenu: (position) => unawaited(
                                      messageMenu?.showAt(context, position) ??
                                          AppContextMenu.show(
                                            context,
                                            globalPosition: position,
                                            headerTitle: context
                                                .l10n
                                                .chatMessageActionsTooltip,
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
                      },
                    ),
                  ),
                  ChatMessageComposer(
                    compact: true,
                    onSubmit: (draft) {
                      context.read<ChatThreadCubit>().sendDraft(draft);
                      return null;
                    },
                    draftRepository: context.read<ChatDraftRepository>(),
                    userId:
                        context
                            .read<AuthSessionPort?>()
                            ?.snapshot
                            .user
                            ?.userId ??
                        '',
                    conversationId: 'thread:${widget.rootMessage.id}',
                    accessRevocation: _accessRevocation,
                    conversationStates: widget.parentConversationStates,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
