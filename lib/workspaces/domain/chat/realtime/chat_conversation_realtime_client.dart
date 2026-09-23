import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_presence.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_user_status_changed.dart';

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

  /// Snapshoty obecności online/offline z autoryzowanego Chat Huba.
  Stream<ChatConversationPresenceSnapshot?> get presenceSnapshots;

  /// Zmiany własnych statusów uczestników aktywnej rozmowy.
  Stream<ChatUserStatusChanged> get userStatusChanges;

  /// Otwiera subskrypcję i ewentualny replay dla wskazanej rozmowy.
  Future<void> start(String conversationId);

  /// Kończy subskrypcję bez niszczenia współdzielonego właściciela transportu.
  Future<void> stop();

  /// Zgłasza do huba, że bieżący użytkownik pisze albo przestał pisać.
  ///
  /// Sygnał jest ulotny: serwer trzyma własny TTL, więc brak „stop” nie zostawia
  /// pisania na zawsze.
  Future<void> setTyping(bool isTyping);

  /// Odnawia lease obecności w aktywnej rozmowie.
  Future<void> heartbeatPresence();
}
