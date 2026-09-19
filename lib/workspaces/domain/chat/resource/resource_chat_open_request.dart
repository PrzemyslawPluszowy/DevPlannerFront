import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';

/// Dane przekazywane z autoryzowanego resolvera do session-scoped panelu Chat.
final class ResourceChatOpenRequest {
  const ResourceChatOpenRequest({
    required this.conversationId,
    required this.fileContext,
  });

  final String conversationId;
  final ResourceChatFileContext fileContext;
}
