import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/message_actions_widgets.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_rich_text_body.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista historii rozmowy z obsługą wskazanego deep linkiem wpisu.
///
/// Zachowuje wyłącznie stan przewinięcia; akcje biznesowe przekazuje do rodzica.
final class ChatConversationMessageList extends StatefulWidget {
  const ChatConversationMessageList({
    required this.messages,
    required this.isSending,
    required this.onReply,
    required this.onThread,
    required this.onDiscussion,
    this.realtimeError,
    this.targetMessageId,
    super.key,
  });

  final List<ChatMessage> messages;
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
      _scrollToTarget();
    }
  }

  void _scrollToTarget() {
    if (widget.targetMessageId == null) return;
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

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (widget.realtimeError case final error?)
        MaterialBanner(
          content: Text('Realtime Chat: $error'),
          actions: const <Widget>[SizedBox.shrink()],
        ),
      Expanded(
        child: ListView.separated(
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
            final isTarget = message.id == widget.targetMessageId;
            return Align(
              // Stabilny klucz po identyfikatorze wiadomości: doładowanie starszej
              // strony nie przebudowuje wierszy ani nie gubi pozycji przewijania.
              key: isTarget
                  ? _targetKey
                  : ValueKey<String>('chat-message-${message.id}'),
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
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
                  padding: const EdgeInsets.all(Sizes.p12),
                  child: Row(
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
                        IconButton(
                          tooltip: context.l10n.chatComposerReplyAction,
                          onPressed: () => widget.onReply(message),
                          icon: const Icon(Symbols.reply_rounded, size: 18),
                        ),
                      if (!message.isDeleted)
                        IconButton(
                          tooltip: context.l10n.chatThreadOpen,
                          onPressed: () => widget.onThread(message),
                          icon: const Icon(Symbols.forum_rounded, size: 18),
                        ),
                      if (!message.isDeleted)
                        IconButton(
                          tooltip: context.l10n.chatDiscussionOpen,
                          onPressed: () => widget.onDiscussion(message),
                          icon: const Icon(Symbols.topic_rounded, size: 18),
                        ),
                      if (!message.isDeleted)
                        ChatMessageActionMenu(message: message),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
