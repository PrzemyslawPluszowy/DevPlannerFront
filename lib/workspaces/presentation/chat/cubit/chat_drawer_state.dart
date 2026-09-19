import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';

/// Stany listy rozmów prezentowanej w globalnym drawerze.
sealed class ChatDrawerState {
  const ChatDrawerState();
}

final class ChatDrawerInitial extends ChatDrawerState {
  const ChatDrawerInitial();
}

final class ChatDrawerLoading extends ChatDrawerState {
  const ChatDrawerLoading();
}

final class ChatDrawerReady extends ChatDrawerState {
  const ChatDrawerReady(this.conversations);

  final List<ChatConversationResponse> conversations;
}

final class ChatDrawerEmpty extends ChatDrawerState {
  const ChatDrawerEmpty();
}

final class ChatDrawerFailure extends ChatDrawerState {
  const ChatDrawerFailure(this.message);

  final String message;
}
