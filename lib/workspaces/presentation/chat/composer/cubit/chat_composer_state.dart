import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';

/// Niemutowalny stan interakcji jednego composera rozmowy.
final class ChatComposerState {
  /// Tworzy stan local-only composera bez odczytu lub zapisu przez API.
  const ChatComposerState({
    required this.draft,
    this.mode = ChatComposerMode.plainText,
  });

  /// Snapshot przekazywany do kolejki dokładnie w chwili wysłania.
  final ChatComposerDraft draft;

  /// Wybrany przez użytkownika sposób edycji tej wiadomości.
  final ChatComposerMode mode;

  /// Zwraca kopię ze zmienionym draftem lub trybem edycji.
  ChatComposerState copyWith({
    ChatComposerDraft? draft,
    ChatComposerMode? mode,
  }) => ChatComposerState(
    draft: draft ?? this.draft,
    mode: mode ?? this.mode,
  );
}
