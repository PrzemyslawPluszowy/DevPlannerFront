import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';

sealed class ChatDiscussionState {
  const ChatDiscussionState();
}

final class ChatDiscussionIdle extends ChatDiscussionState {
  const ChatDiscussionIdle();
}

final class ChatDiscussionResolving extends ChatDiscussionState {
  const ChatDiscussionResolving();
}

final class ChatDiscussionReady extends ChatDiscussionState {
  const ChatDiscussionReady(this.conversation);
  final ChatConversation conversation;
}

final class ChatDiscussionFailure extends ChatDiscussionState {
  const ChatDiscussionFailure(this.message);
  final String message;
}

final class ChatDiscussionDetached extends ChatDiscussionState {
  const ChatDiscussionDetached(this.message);
  final String message;
}
