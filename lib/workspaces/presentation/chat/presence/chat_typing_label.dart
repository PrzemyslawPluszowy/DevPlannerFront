/// Decyzja o treści wskaźnika pisania.
///
/// Dzięki temu podziałowi tekst zależy wyłącznie od liczby piszących i znanych
/// etykiet, a nie od kolejności zbioru z realtime; widget tylko tłumaczy
/// decyzję na localization, więc pluralizacja zostaje w ARB.
sealed class ChatTypingLabelDecision {
  const ChatTypingLabelDecision();
}

/// Pisze dokładnie jedna znana osoba.
final class ChatTypingSingle extends ChatTypingLabelDecision {
  /// Tworzy decyzję o jednej osobie.
  const ChatTypingSingle(this.name);

  final String name;
}

/// Piszą dwie znane osoby.
final class ChatTypingPair extends ChatTypingLabelDecision {
  /// Tworzy decyzję o dwóch osobach.
  const ChatTypingPair(this.first, this.second);

  final String first;
  final String second;
}

/// Pisze co najmniej trzy osoby albo nie wszystkie nazwy są jeszcze znane.
final class ChatTypingCrowd extends ChatTypingLabelDecision {
  /// Tworzy decyzję o grupie.
  const ChatTypingCrowd(this.first, this.others);

  /// Pierwsza znana osoba.
  final String first;

  /// Liczba pozostałych piszących osób.
  final int others;
}

/// Nie znamy jeszcze żadnej etykiety piszącego.
final class ChatTypingUnknown extends ChatTypingLabelDecision {
  /// Tworzy neutralną decyzję bez nazw.
  const ChatTypingUnknown();
}

/// Buduje decyzję wskaźnika pisania z identyfikatorów i znanych etykiet.
abstract final class ChatTypingLabels {
  /// Rozstrzyga treść wskaźnika.
  ///
  /// Identyfikatory sortujemy, żeby kolejność zbioru z realtime nie zmieniała
  /// nazwy wyświetlanej osoby przy każdym zdarzeniu.
  static ChatTypingLabelDecision decide({
    required Iterable<String> typingUserIds,
    required Map<String, String> participantLabels,
  }) {
    final ids = typingUserIds.toList(growable: false)..sort();
    if (ids.isEmpty) return const ChatTypingUnknown();
    final names = <String>[];
    for (final id in ids) {
      final label = participantLabels[id]?.trim();
      names.add(label == null || label.isEmpty ? '' : label);
    }
    final known = names
        .where((name) => name.isNotEmpty)
        .toList(growable: false);
    if (known.isEmpty) return const ChatTypingUnknown();
    if (ids.length == 1) return ChatTypingSingle(known.first);
    if (ids.length == 2 && known.length >= 2) {
      return ChatTypingPair(known[0], known[1]);
    }
    return ChatTypingCrowd(known.first, ids.length - 1);
  }
}
