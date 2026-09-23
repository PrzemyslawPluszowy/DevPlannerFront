import 'dart:async';
import 'dart:math' as math;

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/message_actions_widgets.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lista historii rozmowy z obsługą wskazanego deep linkiem wpisu.
///
/// Zachowuje wyłącznie stan przewinięcia; akcje biznesowe przekazuje do rodzica.
final class ChatConversationMessageList extends StatefulWidget {
  const ChatConversationMessageList({
    required this.messages,
    required this.currentUserId,
    required this.isSending,
    required this.onReply,
    required this.onThread,
    required this.onDiscussion,
    this.realtimeError,
    this.targetMessageId,
    super.key,
  });

  final List<ChatMessage> messages;
  final String currentUserId;
  final bool isSending;
  final String? realtimeError;
  final String? targetMessageId;
  final ValueChanged<ChatMessage> onReply;
  final ValueChanged<ChatMessage> onThread;
  final ValueChanged<ChatMessage> onDiscussion;

  @override
  State<ChatConversationMessageList> createState() =>
      _ChatConversationMessageListState();
}

final class _ChatConversationMessageListState
    extends State<ChatConversationMessageList> {
  final GlobalKey _targetKey = GlobalKey();
  String? _replyTargetMessageId;

  @override
  void initState() {
    super.initState();
    _scrollToTarget();
  }

  @override
  void didUpdateWidget(covariant ChatConversationMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetMessageId != oldWidget.targetMessageId ||
        widget.messages != oldWidget.messages) {
      if (widget.targetMessageId != oldWidget.targetMessageId) {
        _replyTargetMessageId = null;
      }
      _scrollToTarget();
    }
  }

  void _scrollToTarget() {
    final targetMessageId = _replyTargetMessageId ?? widget.targetMessageId;
    if (targetMessageId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = _targetKey.currentContext;
      if (targetContext != null && mounted) {
        Scrollable.ensureVisible(
          targetContext,
          alignment: .45,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _openReplyTarget(String messageId) {
    setState(() => _replyTargetMessageId = messageId);
    unawaited(
      context.read<ChatConversationCubit>().ensureTargetLoaded(messageId),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (widget.realtimeError case final error?)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            Sizes.p12,
            Sizes.p8,
            Sizes.p12,
            Sizes.p4,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p8,
          ),
          decoration: BoxDecoration(
            color: context.chatTheme.error.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.chatTheme.error.withValues(alpha: .35),
            ),
          ),
          child: Tooltip(
            message: error,
            child: Row(
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 18,
                  color: context.chatTheme.error,
                ),
                const SizedBox(width: Sizes.p8),
                Expanded(
                  child: Text(
                    context.l10n.chatRealtimeConnectionIssue,
                    style: context.chatTheme.metadataStyle.copyWith(
                      color: context.chatTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) => ListView.separated(
            reverse: true,
            itemCount: widget.messages.length + (widget.isSending ? 1 : 0),
            separatorBuilder: (context, index) =>
                const SizedBox(height: Sizes.p8),
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
              final isTarget =
                  message.id ==
                  (_replyTargetMessageId ?? widget.targetMessageId);
              final isOwn =
                  widget.currentUserId.isNotEmpty &&
                  message.authorUserId == widget.currentUserId;
              final menu = message.isDeleted
                  ? null
                  : ChatMessageActionMenu(
                      message: message,
                      onReply: widget.onReply,
                      onThread: widget.onThread,
                      onDiscussion: widget.onDiscussion,
                    );
              return Align(
                // Stabilny klucz po identyfikatorze wiadomości: doładowanie starszej
                // strony nie przebudowuje wierszy ani nie gubi pozycji przewijania.
                key: isTarget
                    ? _targetKey
                    : ValueKey<String>('chat-message-${message.id}'),
                alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
                child: ChatMessageBubble(
                  message: message,
                  isOwn: isOwn,
                  replyTarget: widget.messages
                      .where((item) => item.id == message.replyToMessageId)
                      .firstOrNull,
                  onOpenReplyTarget: _openReplyTarget,
                  maxWidth: math.min(
                    constraints.maxWidth * .78,
                    context.chatTheme.maxBubbleWidth,
                  ),
                  highlighted: isTarget,
                  menu: menu,
                  onContextMenu: menu == null
                      ? null
                      : (position) => unawaited(menu.showAt(context, position)),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
