import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:flutter/foundation.dart';

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

  /// Czy zmiana wymaga przebudowania całej powierzchni composera.
  ///
  /// Zmiany tekstu i Delta są renderowane bezpośrednio przez kontrolery
  /// TextField/Quill. Przebudowujemy rodzica tylko wtedy, gdy zmieni się
  /// struktura lub stan wysyłki; inaczej rebuild na każdą literę może zerwać
  /// kompozycję IME i sprawiać wrażenie, że tekst pojawia się dopiero później.
  bool shouldRebuildComparedTo(ChatComposerState previous) {
    final before = previous.draft;
    return mode != previous.mode ||
        draft.isEmpty != before.isEmpty ||
        draft.replyToMessageId != before.replyToMessageId ||
        !listEquals(draft.attachmentIds, before.attachmentIds) ||
        !listEquals(draft.mentions, before.mentions);
  }

  /// Zwraca kopię ze zmienionym draftem lub trybem edycji.
  ChatComposerState copyWith({
    ChatComposerDraft? draft,
    ChatComposerMode? mode,
  }) => ChatComposerState(
    draft: draft ?? this.draft,
    mode: mode ?? this.mode,
  );
}
