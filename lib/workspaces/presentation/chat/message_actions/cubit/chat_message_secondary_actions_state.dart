import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';
import 'package:equatable/equatable.dart';

/// Rodzaj akcji drugorzędnej wykonanej na wiadomości.
enum ChatMessageSecondaryAction {
  /// Przypięcie wiadomości w rozmowie.
  pin,

  /// Odpięcie wiadomości.
  unpin,

  /// Dodanie prywatnej zakładki.
  bookmark,

  /// Usunięcie prywatnej zakładki.
  removeBookmark,

  /// Dodanie reakcji emoji.
  reaction,

  /// Usunięcie własnej reakcji emoji.
  removeReaction,

  /// Przekazanie wiadomości do innej rozmowy.
  forward,
}

/// Stan akcji drugorzędnych jednej wiadomości.
class ChatMessageSecondaryActionsState extends Equatable {
  /// Tworzy stan bez akcji w toku.
  const ChatMessageSecondaryActionsState({
    this.pending = const <String, ChatMessageSecondaryAction>{},
    this.failures = const <String, String>{},
    this.lastCompleted,
    this.pinnedConversationId,
    this.forwardedMessageId,
    this.pinnedMessageIds = const <String>{},
    this.bookmarkedMessageIds = const <String>{},
  });

  /// Wiadomości z akcją w toku, kluczowane identyfikatorem wiadomości.
  final Map<String, ChatMessageSecondaryAction> pending;

  /// Kody błędów per wiadomość; UI mapuje je na tekst przez ARB.
  final Map<String, String> failures;

  /// Ostatnio zakończona akcja, żeby UI mogło pokazać potwierdzenie.
  final ChatMessageSecondaryAction? lastCompleted;

  /// Rozmowa, w której zmieniły się przypięcia.
  final String? pinnedConversationId;

  /// Ostatnio przekazana wiadomość.
  final String? forwardedMessageId;

  /// Wiadomości przypięte w otwartej rozmowie.
  final Set<String> pinnedMessageIds;

  /// Wiadomości zapisane w prywatnych zakładkach użytkownika.
  final Set<String> bookmarkedMessageIds;

  /// Czy dla wskazanej wiadomości trwa akcja.
  bool isPending(String messageId) => pending.containsKey(messageId);

  /// Kod błędu dla wiadomości albo `null`.
  String? failureFor(String messageId) => failures[messageId];

  /// Tworzy kopię stanu z nowymi wartościami.
  ChatMessageSecondaryActionsState copyWith({
    Map<String, ChatMessageSecondaryAction>? pending,
    Map<String, String>? failures,
    ChatMessageSecondaryAction? lastCompleted,
    String? pinnedConversationId,
    String? forwardedMessageId,
    bool clearPinnedConversation = false,
    bool clearForwardedMessage = false,
    Set<String>? pinnedMessageIds,
    Set<String>? bookmarkedMessageIds,
  }) => ChatMessageSecondaryActionsState(
    pending: pending ?? this.pending,
    failures: failures ?? this.failures,
    lastCompleted: lastCompleted ?? this.lastCompleted,
    pinnedConversationId: clearPinnedConversation
        ? null
        : pinnedConversationId ?? this.pinnedConversationId,
    forwardedMessageId: clearForwardedMessage
        ? null
        : forwardedMessageId ?? this.forwardedMessageId,
    pinnedMessageIds: pinnedMessageIds ?? this.pinnedMessageIds,
    bookmarkedMessageIds: bookmarkedMessageIds ?? this.bookmarkedMessageIds,
  );

  @override
  List<Object?> get props => [
    pending,
    failures,
    lastCompleted,
    pinnedConversationId,
    forwardedMessageId,
    pinnedMessageIds,
    bookmarkedMessageIds,
  ];
}

/// Stan akcji drugorzędnych z reakcjami widocznymi dla wiadomości.
class ChatMessageReactionsState extends Equatable {
  /// Tworzy stan reakcji per wiadomość.
  const ChatMessageReactionsState({
    this.reactions = const <String, List<ChatMessageReaction>>{},
  });

  /// Reakcje wiadomości, kluczowane identyfikatorem wiadomości.
  final Map<String, List<ChatMessageReaction>> reactions;

  /// Reakcje wskazanej wiadomości.
  List<ChatMessageReaction> forMessage(String messageId) =>
      reactions[messageId] ?? const <ChatMessageReaction>[];

  /// Tworzy kopię stanu z nowymi reakcjami.
  ChatMessageReactionsState copyWith({
    Map<String, List<ChatMessageReaction>>? reactions,
  }) => ChatMessageReactionsState(reactions: reactions ?? this.reactions);

  @override
  List<Object?> get props => [reactions];
}
