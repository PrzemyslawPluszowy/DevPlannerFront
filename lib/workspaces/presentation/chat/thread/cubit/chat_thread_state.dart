import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';

sealed class ChatThreadState {
  const ChatThreadState();
}

final class ChatThreadLoading extends ChatThreadState {
  const ChatThreadLoading();
}

final class ChatThreadReady extends ChatThreadState {
  const ChatThreadReady({
    required this.messages,
    this.nextCursor,
    this.isLoadingMore = false,
  });
  final List<ChatMessage> messages;
  final String? nextCursor;
  final bool isLoadingMore;
}

final class ChatThreadFailure extends ChatThreadState {
  const ChatThreadFailure(this.message);
  final String message;
}

final class ChatThreadDetached extends ChatThreadState {
  const ChatThreadDetached(this.message);
  final String message;
}
