import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';

/// Jawne stany historii i dostawy jednej rozmowy Chat.
sealed class ChatConversationState {
  const ChatConversationState();
}

/// Rozmowa nie rozpoczęła jeszcze pobierania danych.
final class ChatConversationInitial extends ChatConversationState {
  const ChatConversationInitial();
}

/// Pierwszy snapshot rozmowy i historii jest w trakcie pobierania.
final class ChatConversationLoading extends ChatConversationState {
  const ChatConversationLoading();
}

/// Gotowy snapshot rozmowy, historia i lokalne stany dostawy wiadomości.
final class ChatConversationReady extends ChatConversationState {
  const ChatConversationReady({
    required this.conversation,
    required this.messages,
    this.nextCursor,
    this.isLoadingMore = false,
    this.loadError,
    this.realtimeError,
  });

  final ChatConversation conversation;
  final List<ChatMessage> messages;
  final String? nextCursor;
  final bool isLoadingMore;
  final String? loadError;
  final String? realtimeError;

  /// Czy w historii jest przynajmniej jedna oczekująca lokalna próba wysyłki.
  bool get isSending => messages.any(
    (message) => message.deliveryState == ChatMessageDeliveryState.sending,
  );
}

/// Pierwsze pobranie rozmowy nie powiodło się bez dostępnej historii.
final class ChatConversationFailure extends ChatConversationState {
  const ChatConversationFailure(this.message);

  final String message;
}

/// Backend odebrał dostęp do rozmowy; lokalna historia musi zostać odłączona.
final class ChatConversationDetached extends ChatConversationState {
  const ChatConversationDetached(this.message);

  final String message;
}
