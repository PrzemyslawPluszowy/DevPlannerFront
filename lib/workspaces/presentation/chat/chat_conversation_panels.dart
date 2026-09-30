import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:flutter/foundation.dart';

@immutable
final class ChatConversationPanels {
  const ChatConversationPanels({
    this.replyTarget,
    this.threadRoot,
    this.discussionRoot,
  });

  final ChatMessage? replyTarget;
  final ChatMessage? threadRoot;
  final ChatMessage? discussionRoot;

  ChatConversationPanels clearReply() => copyWith(clearReplyTarget: true);

  ChatConversationPanels clearPanels() =>
      copyWith(clearThreadRoot: true, clearDiscussionRoot: true);

  ChatConversationPanels copyWith({
    ChatMessage? replyTarget,
    ChatMessage? threadRoot,
    ChatMessage? discussionRoot,
    bool clearReplyTarget = false,
    bool clearThreadRoot = false,
    bool clearDiscussionRoot = false,
  }) => ChatConversationPanels(
    replyTarget: clearReplyTarget ? null : replyTarget ?? this.replyTarget,
    threadRoot: clearThreadRoot ? null : threadRoot ?? this.threadRoot,
    discussionRoot: clearDiscussionRoot
        ? null
        : discussionRoot ?? this.discussionRoot,
  );

  @override
  bool operator ==(Object other) =>
      other is ChatConversationPanels &&
      other.replyTarget == replyTarget &&
      other.threadRoot == threadRoot &&
      other.discussionRoot == discussionRoot;

  @override
  int get hashCode => Object.hash(replyTarget, threadRoot, discussionRoot);
}
