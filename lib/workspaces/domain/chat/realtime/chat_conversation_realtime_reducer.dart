import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';

/// Decyzja reduktora po walidacji kolejności i aktualizacji historii.
enum ChatConversationRealtimeDecision { applied, ignored, resyncRequired }

/// Wynik czystej redukcji jednego eventu dla aktualnie otwartej rozmowy.
final class ChatConversationRealtimeReduction {
  /// Tworzy wynik z nową, niemutowalną listą wiadomości i decyzją Cubita.
  const ChatConversationRealtimeReduction({
    required this.decision,
    required this.messages,
  });

  final ChatConversationRealtimeDecision decision;
  final List<ChatMessage> messages;
}

/// Zachowuje deduplikację i monotoniczność eventów jednej rozmowy.
///
/// Sekwencja backendu jest globalnie monotoniczna, a nie ciągła per rozmowa;
/// reducer odrzuca wyłącznie event starszy, nie interpretuje luk jako utraty.
final class ChatConversationRealtimeReducer {
  final Set<String> _seenEventIds = <String>{};
  int? _latestSequence;

  /// Redukuje event bez wywołań REST, UI ani transportu SignalR.
  ChatConversationRealtimeReduction apply({
    required List<ChatMessage> messages,
    required ChatConversationRealtimeEvent event,
  }) {
    if (!_accept(event)) {
      return ChatConversationRealtimeReduction(
        decision: ChatConversationRealtimeDecision.ignored,
        messages: messages,
      );
    }
    if (event.kind == ChatConversationRealtimeEventKind.resyncRequired ||
        event.kind == ChatConversationRealtimeEventKind.membershipChanged ||
        event.kind == ChatConversationRealtimeEventKind.unsupported) {
      return ChatConversationRealtimeReduction(
        decision: ChatConversationRealtimeDecision.resyncRequired,
        messages: messages,
      );
    }
    final updated = List<ChatMessage>.of(messages);
    switch (event.kind) {
      case ChatConversationRealtimeEventKind.messageCreated:
      case ChatConversationRealtimeEventKind.messageUpdated:
        final message = event.message;
        if (message == null) {
          return ChatConversationRealtimeReduction(
            decision: ChatConversationRealtimeDecision.resyncRequired,
            messages: messages,
          );
        }
        _upsert(updated, message);
      case ChatConversationRealtimeEventKind.messageDeleted:
        _markDeleted(updated, event);
      case ChatConversationRealtimeEventKind.membershipChanged:
      case ChatConversationRealtimeEventKind.resyncRequired:
      case ChatConversationRealtimeEventKind.unsupported:
        break;
    }
    return ChatConversationRealtimeReduction(
      decision: ChatConversationRealtimeDecision.applied,
      messages: List<ChatMessage>.unmodifiable(updated),
    );
  }

  /// Czyści per-session deduplikację po zatrzymaniu lokalnej subskrypcji.
  void clear() {
    _seenEventIds.clear();
    _latestSequence = null;
  }

  bool _accept(ChatConversationRealtimeEvent event) {
    final sequence = event.sequence;
    final latest = _latestSequence;
    if (sequence != null && latest != null && sequence <= latest) return false;
    final eventId = event.eventId;
    if (eventId != null && !_seenEventIds.add(eventId)) return false;
    if (sequence != null) _latestSequence = sequence;
    return true;
  }

  void _upsert(List<ChatMessage> messages, ChatMessage message) {
    final index = messages.indexWhere(
      (item) =>
          item.id == message.id ||
          item.clientMessageId == message.clientMessageId,
    );
    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }
  }

  void _markDeleted(
    List<ChatMessage> messages,
    ChatConversationRealtimeEvent event,
  ) {
    final messageId = event.messageId;
    if (messageId == null) return;
    final index = messages.indexWhere((item) => item.id == messageId);
    if (index == -1) return;
    final version = event.messageVersion;
    if (version == null || version < messages[index].version) return;
    messages[index] = messages[index].copyWithDeletion(version: version);
  }
}
