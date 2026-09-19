import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';

/// Klasyfikacja błędu lokalnej subskrypcji rozmowy Chat.
enum ChatConversationRealtimeErrorKind { transport, accessRevoked, protocol }

/// Typowany błąd transportu, który presentation może bezpiecznie obsłużyć.
final class ChatConversationRealtimeError {
  /// Tworzy błąd z komunikatem backendu albo adaptera bez przecieku wyjątku.
  const ChatConversationRealtimeError({
    required this.kind,
    required this.message,
  });

  final ChatConversationRealtimeErrorKind kind;
  final String message;
}

/// Minimalny lifecycle i strumienie jednej subskrypcji rozmowy Chat.
abstract interface class ChatConversationRealtimeClient {
  /// Typowane eventy bieżącej rozmowy bez modelu SignalR w presentation.
  Stream<ChatConversationRealtimeEvent> get conversationEvents;

  /// Błędy subskrypcji rozróżniające revoke od zwykłej awarii transportu.
  Stream<ChatConversationRealtimeError> get conversationErrors;

  /// Otwiera subskrypcję i ewentualny replay dla wskazanej rozmowy.
  Future<void> start(String conversationId);

  /// Kończy subskrypcję bez niszczenia współdzielonego właściciela transportu.
  Future<void> stop();
}
