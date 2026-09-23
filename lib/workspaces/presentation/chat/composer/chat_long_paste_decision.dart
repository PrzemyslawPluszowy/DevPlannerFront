import 'dart:convert';

import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';

/// Jak potraktować długie wklejenie.
enum ChatLongPasteKind {
  /// Tekst mieści się w zwykłej wiadomości.
  text,

  /// Warto zaproponować wysłanie tekstu jako pliku TXT.
  file,

  /// Tekst przekracza limit wejścia snippet-u; potrzebny jest konkretny komunikat.
  overLimit,
}

/// Ocena wklejenia wraz z danymi do karty decyzji.
final class ChatLongPasteAssessment {
  /// Tworzy ocenę wklejenia.
  const ChatLongPasteAssessment({
    required this.kind,
    required this.characters,
    required this.byteLength,
    required this.previewLines,
  });

  /// Rozstrzygnięcie: tekst, plik albo przekroczony limit.
  final ChatLongPasteKind kind;

  /// Liczba znaków liczona jak w backendzie (jednostki UTF-16).
  final int characters;

  /// Rozmiar treści w bajtach UTF-8, czyli to, co realnie poleci do pliku.
  final int byteLength;

  /// Pierwsze linie podglądu; reszta treści pozostaje nietknięta.
  final List<String> previewLines;
}

/// Rozstrzyga, czy wklejenie wymaga decyzji użytkownika.
///
/// Progi pochodzą wyłącznie z polityki serwera; brak polityki oznacza brak
/// propozycji pliku TXT — klient nie zgaduje liczb ani nie obcina treści.
abstract final class ChatLongPasteDecision {
  /// Liczba linii pokazywanych w podglądzie karty.
  static const int previewLineCount = 3;

  /// Ocenia wklejenie wobec polityki serwera.
  static ChatLongPasteAssessment assess({
    required String text,
    required ChatLinkPolicy? policy,
  }) {
    final characters = text.length;
    final bytes = utf8.encode(text).length;
    return ChatLongPasteAssessment(
      kind: _kind(characters, policy),
      characters: characters,
      byteLength: bytes,
      previewLines: preview(text),
    );
  }

  static ChatLongPasteKind _kind(int characters, ChatLinkPolicy? policy) {
    if (policy == null) return ChatLongPasteKind.text;
    if (characters > policy.messageMaxCharacters) {
      return characters > policy.snippetInputMaxCharacters
          ? ChatLongPasteKind.overLimit
          : ChatLongPasteKind.file;
    }
    if (characters >= policy.snippetThresholdCharacters &&
        characters <= policy.snippetInputMaxCharacters) {
      return ChatLongPasteKind.file;
    }
    return ChatLongPasteKind.text;
  }

  /// Pierwsze linie treści, bez modyfikowania oryginału.
  static List<String> preview(String text) {
    if (text.isEmpty) return const <String>[];
    final lines = text.split('\n');
    if (lines.length <= previewLineCount) {
      return List<String>.unmodifiable(lines);
    }
    return List<String>.unmodifiable(lines.take(previewLineCount));
  }
}
