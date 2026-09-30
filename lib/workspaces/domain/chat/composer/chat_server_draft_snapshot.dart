import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';

/// Szkic wraz z autorytatywną wersją optimistic concurrency backendu.
final class ChatServerDraftSnapshot {
  const ChatServerDraftSnapshot({required this.draft, required this.version});

  final ChatComposerDraft draft;
  final int version;
}
