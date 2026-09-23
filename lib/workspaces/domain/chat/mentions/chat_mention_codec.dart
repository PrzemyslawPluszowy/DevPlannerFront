import 'package:equatable/equatable.dart';

/// Aktywne wywołanie wzmianki `@` w tekście composera.
///
/// [start] wskazuje znak `@`, [end] pozycję kursora, a [term] frazę po `@`
/// (może być pusta — samo `@` też otwiera listę podpowiedzi).
final class ChatMentionQuery extends Equatable {
  /// Tworzy opis aktywnego wywołania wzmianki.
  const ChatMentionQuery({
    required this.start,
    required this.end,
    required this.term,
  });

  final int start;
  final int end;
  final String term;

  @override
  List<Object?> get props => [start, end, term];
}

/// Wzmianka wybrana w composerze: stabilny UUID i etykieta widoczna w polu.
///
/// Pole tekstowe pokazuje etykietę, a wysyłany tekst musi zawierać token
/// `@<uuid>`, bo tylko taki format serwer rozpoznaje jako wzmiankę.
final class ChatMentionReference extends Equatable {
  /// Tworzy referencję wzmianki.
  const ChatMentionReference({required this.userId, required this.label});

  final String userId;
  final String label;

  @override
  List<Object?> get props => [userId, label];
}

/// Wspólny kontrakt wzmianek między plain textem, deltą Quill i transportem.
///
/// W transporcie wzmianka jest stabilnym tokenem `@<uuid>` (albo `@all`), bo
/// serwer rozpoznaje wyłącznie taki format. W UI pokazujemy nazwę wyświetlaną,
/// więc renderer podmienia token na etykietę, a wysyłany tekst pozostaje
/// niezmienionym kontraktem. Dzięki temu nazwa osoby nie jest źródłem
/// uprawnień ani identyfikatorem.
abstract final class ChatMentionCodec {
  /// Token wzmianki wszystkich uprawnionych uczestników.
  static const String allToken = '@all';

  /// Znak rozpoczynający wzmiankę.
  static const String trigger = '@';

  /// Buduje token transportu dla wskazanego użytkownika.
  static String tokenFor(String userId) => '@${userId.trim()}';

  /// Buduje etykietę prezentacji: nazwa, login, a na końcu UUID.
  static String labelFor({
    required String userId,
    String? displayName,
    String? login,
    String fallbackLabel = 'Member',
  }) {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty && !_looksLikeUuid(name)) return name;
    final fallback = login?.trim();
    if (fallback != null && fallback.isNotEmpty && !_looksLikeUuid(fallback)) {
      return fallback;
    }
    return fallbackLabel.trim().isEmpty ? 'Member' : fallbackLabel.trim();
  }

  /// Podmienia aktywne wywołanie wzmianki na etykietę wybranej osoby.
  ///
  /// Dodaje spację na końcu, żeby token był zamknięty i kolejny znak nie
  /// przedłużał frazy wyszukiwania.
  static String applyMention({
    required String text,
    required ChatMentionQuery query,
    required String label,
  }) {
    final normalized = label.trim();
    if (normalized.isEmpty) return text;
    final caret = query.end.clamp(0, text.length);
    final start = query.start.clamp(0, caret);
    return text.replaceRange(start, caret, '$trigger$normalized ');
  }

  /// Odrzuca wzmianki, których etykiety nie ma już w tekście.
  ///
  /// Dzięki temu skasowanie fragmentu z nazwą nie wysyła wzmianki do osoby,
  /// o której użytkownik już nie pisze.
  static List<ChatMentionReference> pruneMentions({
    required String text,
    required List<ChatMentionReference> mentions,
  }) {
    if (mentions.isEmpty) return const <ChatMentionReference>[];
    final kept = mentions
        .where((mention) => text.contains('$trigger${mention.label}'))
        .toList(growable: false);
    return kept.length == mentions.length ? mentions : kept;
  }

  /// Zamienia widoczny tekst composera na kontrakt transportu.
  ///
  /// Każda wybrana wzmianka podmienia pierwsze wystąpienie swojej etykiety na
  /// token `@<uuid>`; tekst wpisany ręcznie bez wyboru osoby nie staje się
  /// wzmianką, więc nie pinguje nikogo. Kolejność referencji rozstrzyga
  /// ewentualne powtórzenia tej samej etykiety.
  static String toWireText({
    required String visibleText,
    required List<ChatMentionReference> mentions,
  }) {
    if (visibleText.isEmpty || mentions.isEmpty) return visibleText;
    var wire = visibleText;
    for (final mention in mentions) {
      final label = mention.label.trim();
      if (label.isEmpty) continue;
      final needle = '$trigger$label';
      final index = wire.indexOf(needle);
      if (index < 0) continue;
      wire = wire.replaceRange(
        index,
        index + needle.length,
        tokenFor(mention.userId),
      );
    }
    return wire;
  }

  /// Podmienia tokeny `@<uuid>` na etykiety do prezentacji.
  ///
  /// Nieznany identyfikator zostaje jako token, żeby renderer nigdy nie ukrył
  /// wzmianki, której etykiety nie zna.
  static String renderText(String text, Map<String, String> labelsByUserId) {
    if (text.isEmpty || labelsByUserId.isEmpty) return text;
    return text.replaceAllMapped(_uuidToken, (match) {
      final userId = match.group(1)!;
      final label =
          labelsByUserId[userId] ?? labelsByUserId[_normalize(userId)];
      return label == null ? match.group(0)! : '$trigger$label';
    });
  }

  /// Wykrywa aktywne wywołanie wzmianki na pozycji kursora.
  ///
  /// Zwraca `null`, gdy kursor nie jest w tokenie wzmianki, gdy token jest
  /// częścią adresu e-mail (`x@y`) albo gdy fraza zawiera spację lub `@`.
  static ChatMentionQuery? activeQuery(String text, int caretOffset) {
    if (text.isEmpty) return null;
    final caret = caretOffset.clamp(0, text.length);
    var at = -1;
    for (var index = caret - 1; index >= 0; index--) {
      final char = text[index];
      if (char == trigger) {
        at = index;
        break;
      }
      if (char.trim().isEmpty) return null;
    }
    if (at < 0) return null;
    // Adres e-mail albo login nie jest wywołaniem wzmianki.
    if (at > 0 && _isWordChar(text[at - 1])) return null;
    final term = text.substring(at + 1, caret);
    if (term.contains(trigger) || term.contains(' ')) return null;
    return ChatMentionQuery(start: at, end: caret, term: term);
  }

  static final RegExp _uuidToken = RegExp(
    '@([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})',
  );

  static bool _isWordChar(String char) => RegExp('[A-Za-z0-9_]').hasMatch(char);

  static bool _looksLikeUuid(String value) => RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  ).hasMatch(value.trim());

  static String _normalize(String value) => value.toLowerCase();
}
