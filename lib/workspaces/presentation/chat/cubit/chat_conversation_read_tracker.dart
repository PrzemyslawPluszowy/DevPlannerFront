import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';

/// Wynik próby ACK odczytu; rozróżnia błąd sieci od sytuacji bez działania.
enum ChatReadMarkOutcome { marked, ignored, failed }

/// Koordynuje idempotentne potwierdzenie faktycznie widocznej wiadomości.
final class ChatConversationReadTracker {
  ChatConversationReadTracker({
    required this.repository,
    required this.conversationId,
    required this.isClosed,
  });

  final ChatConversationRepository repository;
  final String conversationId;
  final bool Function() isClosed;
  final Set<String> _inFlight = <String>{};
  String? _lastReadMessageId;
  ChatMessage? _lastReadMessage;

  String? get lastReadMessageId => _lastReadMessageId;

  /// Oznacza wiadomość dopiero po potwierdzeniu jej widoczności przez UI.
  Future<ChatReadMarkOutcome> markVisibleAsRead({
    required ChatConversationReady current,
    required String messageId,
  }) async {
    if (isClosed()) return ChatReadMarkOutcome.ignored;
    if (messageId.isEmpty ||
        messageId == _lastReadMessageId ||
        _inFlight.contains(messageId)) {
      return ChatReadMarkOutcome.ignored;
    }
    final message = current.messages
        .where((item) => item.id == messageId)
        .firstOrNull;
    if (message == null ||
        message.isDeleted ||
        message.id.startsWith('local:')) {
      return ChatReadMarkOutcome.ignored;
    }
    final readCursor = _lastReadMessage;
    if (readCursor != null && _compare(message, readCursor) <= 0) {
      return ChatReadMarkOutcome.ignored;
    }

    _inFlight.add(messageId);
    var outcome = ChatReadMarkOutcome.failed;
    try {
      final result = await repository.markConversationRead(
        conversationId: conversationId,
        messageId: messageId,
      );
      if (!isClosed()) {
        result.fold(
          (_) {
            outcome = ChatReadMarkOutcome.failed;
          },
          (_) {
            final latestRead = _lastReadMessage;
            if (latestRead == null || _compare(message, latestRead) > 0) {
              _lastReadMessage = message;
              _lastReadMessageId = messageId;
              outcome = ChatReadMarkOutcome.marked;
            } else {
              outcome = ChatReadMarkOutcome.ignored;
            }
          },
        );
      } else {
        outcome = ChatReadMarkOutcome.ignored;
      }
    } finally {
      _inFlight.remove(messageId);
    }
    return outcome;
  }

  /// Tiebreaker identyczny z backendowym kursorem `(CreatedAtUtc, Id)`.
  static int _compare(ChatMessage left, ChatMessage right) {
    final timestamp = left.createdAtUtc.compareTo(right.createdAtUtc);
    return timestamp != 0 ? timestamp : left.id.compareTo(right.id);
  }
}
