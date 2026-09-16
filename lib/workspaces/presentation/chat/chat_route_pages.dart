import 'package:flutter/material.dart';
import 'package:ready_next/workspaces/presentation/chat/chat_conversation_page.dart';
import 'package:ready_next/workspaces/presentation/chat/chat_landing_page.dart';

/// Trasa pełnej listy rozmów; główne wejście pozostaje drawerem.
class GlobalChatPage extends StatelessWidget {
  const GlobalChatPage({super.key});

  @override
  Widget build(BuildContext context) => const ChatLandingPageView();
}

/// Jawny ekran celu rozmowy z powiadomienia lub zakładki przeglądarki.
class GlobalChatConversationPage extends StatelessWidget {
  const GlobalChatConversationPage({
    required this.conversationId,
    super.key,
  });

  final String conversationId;

  @override
  Widget build(BuildContext context) => ChatConversationPageView(
    conversationId: conversationId,
  );
}

/// Jawny ekran wiadomości wskazanej przez deep link.
class GlobalChatMessagePage extends StatelessWidget {
  const GlobalChatMessagePage({
    required this.conversationId,
    required this.messageId,
    super.key,
  });

  final String conversationId;
  final String messageId;

  @override
  Widget build(BuildContext context) => ChatConversationPageView(
    conversationId: conversationId,
    targetMessageId: messageId,
  );
}
