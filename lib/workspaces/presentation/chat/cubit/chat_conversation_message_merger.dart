import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';

/// Scala strony i aktualizacje realtime do chronologicznej historii rozmowy.
abstract final class ChatConversationMessageMerger {
  /// Zastępuje duplikaty serwerowymi wersjami i sortuje po kursorze backendu.
  static List<ChatMessage> merge(
    List<ChatMessage> current,
    List<ChatMessage> incoming,
  ) {
    final merged = List<ChatMessage>.of(current);
    for (final message in incoming) {
      final index = merged.indexWhere(
        (item) =>
            item.id == message.id ||
            item.clientMessageId == message.clientMessageId,
      );
      if (index == -1) {
        merged.add(message);
      } else if (message.version >= merged[index].version &&
          !(merged[index].isDeleted &&
              !message.isDeleted &&
              message.version == merged[index].version)) {
        // Opóźniony HTTP/ACK nie może cofnąć nowszej edycji lub delete realtime.
        merged[index] = message;
      }
    }
    // Historia i ACK odczytu wymagają kolejności chronologicznej.
    merged.sort((left, right) {
      final timestamp = left.createdAtUtc.compareTo(right.createdAtUtc);
      return timestamp != 0 ? timestamp : left.id.compareTo(right.id);
    });
    return List<ChatMessage>.unmodifiable(merged);
  }
}
