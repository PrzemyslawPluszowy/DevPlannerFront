import 'dart:async';
import 'dart:math' as math;

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_dialogs.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_date_separator.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_grouping.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_series_view.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SelectedContent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Widok listy historii wiadomości; stan przewijania pozostaje w jej właścicielu.
final class ChatPanelMessageListView extends StatelessWidget {
  const ChatPanelMessageListView({
    required this.list,
    required this.scrollController,
    required this.viewportKey,
    required this.newestMessageKey,
    required this.targetKey,
    required this.pendingNew,
    required this.replyTargetMessageId,
    required this.hasTextSelection,
    required this.onSelectionChanged,
    required this.onRetryLoadMore,
    required this.onJumpToLatest,
    required this.onOpenReplyTarget,
    super.key,
  });

  final ChatPanelMessageList list;
  final ScrollController scrollController;
  final GlobalKey viewportKey;
  final GlobalKey newestMessageKey;
  final GlobalKey targetKey;
  final int pendingNew;
  final String? replyTargetMessageId;
  final bool hasTextSelection;
  final ValueChanged<SelectedContent?> onSelectionChanged;
  final VoidCallback onRetryLoadMore;
  final Future<void> Function() onJumpToLatest;
  final ValueChanged<String> onOpenReplyTarget;

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '';
    final secondary = context.read<ChatMessageSecondaryActionsCubit?>();
    final isPinned = secondary?.state.pinnedMessageIds ?? const <String>{};
    final isBookmarked =
        secondary?.state.bookmarkedMessageIds ?? const <String>{};
    final forwardTargets = _forwardTargets(context);
    final chat = context.chatTheme;
    final showIdentity = list.participantLabels.isNotEmpty;
    // Lista jest odwrócona, więc historię czytamy od końca.
    final timeline = ChatMessageGrouping.timeline(
      list.messages,
      currentUserId: currentUserId,
    ).reversed.toList(growable: false);
    return LayoutBuilder(
      builder: (context, constraints) {
        final gutter = list.compact
            ? chat.compactHistoryGutter
            : chat.historyGutter;
        final identityWidth = showIdentity
            ? chat.avatarBubble + chat.seriesGap + Sizes.p4
            : 0.0;
        final factor = list.compact
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
          key: viewportKey,
          child: SelectionArea(
            onSelectionChanged: onSelectionChanged,
            child: Stack(
              children: [
                ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: gutter,
                    vertical: Sizes.p8,
                  ),
                  reverse: true,
                  itemCount:
                      timeline.length +
                      (list.isSending ? 1 : 0) +
                      (list.nextCursor != null ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    if (list.isSending && index == 0) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final timelineIndex = index - (list.isSending ? 1 : 0);
                    if (timelineIndex >= timeline.length) {
                      if (list.loadMoreFailed) {
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
                                onPressed: onRetryLoadMore,
                                child: Text(context.l10n.chatInboxRetry),
                              ),
                            ],
                          ),
                        );
                      }
                      if (list.isLoadingMore) {
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
                      authorLabel: list.participantLabels[item.authorUserId],
                      authorAvatarUrl:
                          list.participantAvatarUrls[item.authorUserId],
                      showIdentity: showIdentity,
                      bubbleBuilder: (message, isFirst, position) {
                        final messageMenu = message.isDeleted
                            ? null
                            : ChatMessageActionMenu(
                                message: message,
                                isOwnMessage: item.isOwnAuthor,
                                canModerate: list.canModerate,
                                isPinned: isPinned.contains(message.id),
                                isBookmarked: isBookmarked.contains(message.id),
                                currentUserId: currentUserId,
                                onReply: list.onReply,
                                onThread: list.onThread,
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
                                onForward: (target, position) => unawaited(
                                  ChatMessageActionDialogs.forward(
                                    context,
                                    message: target,
                                    conversations: forwardTargets,
                                    globalPosition: position,
                                  ),
                                ),
                              );
                        final replyTarget = list.messages
                            .where(
                              (item) => item.id == message.replyToMessageId,
                            )
                            .firstOrNull;
                        final bubble = ChatMessageBubble(
                          key:
                              message.id ==
                                  (replyTargetMessageId ?? list.targetMessageId)
                              ? targetKey
                              : ValueKey<String>(
                                  'chat-panel-message-${message.id}',
                                ),
                          message: message,
                          isOwn: item.isOwnAuthor,
                          replyTarget: replyTarget,
                          replyTargetAuthorLabel: replyTarget == null
                              ? null
                              : list.participantLabels[replyTarget
                                    .authorUserId],
                          maxWidth: maxBubbleWidth,
                          seriesPosition: position,
                          authorLabel:
                              list.participantLabels[message.authorUserId],
                          showAuthor: isFirst,
                          highlighted:
                              message.id ==
                              (replyTargetMessageId ?? list.targetMessageId),
                          onOpenReplyTarget: onOpenReplyTarget,
                          onPickReaction: (position) => unawaited(
                            showChatQuickReactionPicker(
                              context,
                              message: message,
                              globalPosition: position,
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
                          onContextMenu: messageMenu == null || hasTextSelection
                              ? null
                              : (position) => unawaited(
                                  messageMenu.showAt(context, position),
                                ),
                          reactions: message.reactions.isEmpty
                              ? null
                              : ChatMessageReactionsBar(
                                  summaries: message.reactions,
                                  onToggle: (emoji, isOwn) => unawaited(
                                    () async {
                                      final actions = context
                                          .read<
                                            ChatMessageSecondaryActionsCubit
                                          >();
                                      if (isOwn) {
                                        final outcome = await actions
                                            .removeReaction(
                                              messageId: message.id,
                                              emoji: emoji,
                                            );
                                        if (outcome ==
                                                ChatMessageSecondaryActionOutcome
                                                    .failed &&
                                            context.mounted) {
                                          AppToast.show(
                                            context,
                                            message: context
                                                .l10n
                                                .chatActionFailureMessage,
                                            tone: AppToastTone.error,
                                          );
                                        }
                                      } else {
                                        final outcome = await actions.react(
                                          messageId: message.id,
                                          emoji: emoji,
                                        );
                                        if (outcome ==
                                                ChatMessageSecondaryActionOutcome
                                                    .failed &&
                                            context.mounted) {
                                          AppToast.show(
                                            context,
                                            message: context
                                                .l10n
                                                .chatActionFailureMessage,
                                            tone: AppToastTone.error,
                                          );
                                        }
                                      }
                                    }(),
                                  ),
                                ),
                        );
                        return message.id == list.messages.last.id
                            ? SizedBox(key: newestMessageKey, child: bubble)
                            : bubble;
                      },
                    );
                  },
                ),
                if (pendingNew > 0)
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
                          onTap: () => unawaited(onJumpToLatest()),
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
                                  context.l10n.chatNewMessages(pendingNew),
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
