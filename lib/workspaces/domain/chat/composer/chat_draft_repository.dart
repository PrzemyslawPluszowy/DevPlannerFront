import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';

/// Trwały, prywatny magazyn draftów rozmów, rozdzielony per użytkownik i rozmowa.
abstract interface class ChatDraftRepository {
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  });

  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  });

  Future<void> delete({
    required String userId,
    required String conversationId,
  });
}
