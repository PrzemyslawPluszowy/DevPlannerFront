import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';

/// Jedno odwzorowanie DTO rozmowy na model domenowy.
///
/// Wszystkie adaptery Chat korzystają z tego samego mappera, więc panel nie
/// zależy od kształtu transportu, a zmiana kontraktu wymaga jednej poprawki.
abstract final class ChatConversationMapper {
  /// Mapuje odpowiedź kontraktu na niezależny od transportu model rozmowy.
  static ChatConversation toDomain(ChatConversationResponse response) =>
      ChatConversation(
        id: response.id,
        type: response.type.name,
        scopeKind: response.scopeKind.name,
        scopeKey: response.scopeKey,
        workspaceId: response.workspaceId,
        projectId: response.projectId,
        name: response.name,
        discussionRootMessageId: response.discussionRootMessageId,
        version: response.version,
        createdAtUtc: response.createdAtUtc,
        postingPermission: response.postingPermission,
        isArchived: response.isArchived,
      );
}
