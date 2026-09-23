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
    this.isJumpingToMessage = false,
    this.jumpFailureCode,
    this.jumpAnchorMessageId,
  });

  final ChatConversation conversation;
  final List<ChatMessage> messages;
  final String? nextCursor;
  final bool isLoadingMore;
  final String? loadError;
  final String? realtimeError;

  /// Czy trwa doładowanie okna wokół wskazanej wiadomości poza bieżącą stroną.
  final bool isJumpingToMessage;

  /// Kod domenowy nieudanego skoku do wiadomości; UI pokazuje go z ponowieniem.
  final String? jumpFailureCode;

  /// Punkt zaczepienia, gdy historia pokazuje okno wokół wiadomości.
  ///
  /// Niepusty identyfikator oznacza tryb okna: lista zawiera ciągły zakres wokół
  /// wiadomości, a nie najnowszą stronę, więc scalanie z najnowszymi utworzyłoby
  /// niewidoczną lukę. Wyjście z trybu pobiera najnowszą stronę od nowa.
  final String? jumpAnchorMessageId;

  /// Czy historia pokazuje okno wokół wskazanej wiadomości.
  bool get isWindowedHistory => jumpAnchorMessageId != null;

  /// Czy w historii jest przynajmniej jedna oczekująca lokalna próba wysyłki.
  bool get isSending => messages.any(
    (message) => message.deliveryState == ChatMessageDeliveryState.sending,
  );

  /// Tworzy kopię stanu z nowymi wartościami; `clearJumpFailure` usuwa kod błędu.
  ChatConversationReady copyWith({
    List<ChatMessage>? messages,
    String? nextCursor,
    bool? isLoadingMore,
    String? loadError,
    String? realtimeError,
    bool? isJumpingToMessage,
    String? jumpFailureCode,
    bool clearJumpFailure = false,
    String? jumpAnchorMessageId,
    bool clearWindowHistory = false,
  }) => ChatConversationReady(
    conversation: conversation,
    messages: messages ?? this.messages,
    nextCursor: nextCursor ?? this.nextCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadError: loadError ?? this.loadError,
    realtimeError: realtimeError ?? this.realtimeError,
    isJumpingToMessage: isJumpingToMessage ?? this.isJumpingToMessage,
    jumpFailureCode: clearJumpFailure
        ? null
        : jumpFailureCode ?? this.jumpFailureCode,
    jumpAnchorMessageId: clearWindowHistory
        ? null
        : jumpAnchorMessageId ?? this.jumpAnchorMessageId,
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
