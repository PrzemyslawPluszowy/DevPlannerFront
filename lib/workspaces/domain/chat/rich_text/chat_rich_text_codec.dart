import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Rodzaj bloku wiadomości renderowanej z delty Quill.
enum ChatRichTextBlockKind {
  /// Zwykły akapit.
  paragraph,

  /// Element listy punktowanej.
  bulletList,

  /// Element listy numerowanej.
  orderedList,

  /// Cytat.
  quote,

  /// Blok kodu.
  code,
}

/// Fragment tekstu z formatowaniem inline.
final class ChatRichTextSpan extends Equatable {
  /// Tworzy fragment tekstu.
  const ChatRichTextSpan({
    required this.text,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strike = false,
    this.isCode = false,
    this.link,
    this.unsupported = false,
  });

  /// Tworzy znacznik treści nieobsługiwanej (np. osadzonego obrazu).
  const ChatRichTextSpan.unsupported() : this(text: '', unsupported: true);

  final String text;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strike;

  /// Kod inline (`code`).
  final bool isCode;

  /// Adres linku tylko gdy jest bezpieczny (HTTP/HTTPS albo ścieżka aplikacji).
  final String? link;

  /// Treść, której renderer nie obsługuje; nie może zepsuć reszty historii.
  final bool unsupported;

  @override
  List<Object?> get props => [
    text,
    bold,
    italic,
    underline,
    strike,
    isCode,
    link,
    unsupported,
  ];
}

/// Blok wiadomości gotowy do renderowania.
final class ChatRichTextBlock extends Equatable {
  /// Tworzy blok.
  const ChatRichTextBlock({
    required this.kind,
    required this.spans,
    this.language,
  });

  final ChatRichTextBlockKind kind;
  final List<ChatRichTextSpan> spans;

  /// Język bloku kodu zapisany w delcie albo `null`.
  final String? language;

  /// Czy blok nie zawiera nic do pokazania.
  bool get isEmpty =>
      spans.every((span) => !span.unsupported && span.text.isEmpty);

  @override
  List<Object?> get props => [kind, spans, language];
}

/// Zamienia deltę Quill na bloki historii wiadomości.
///
/// Renderer dostaje wyłącznie dane: żaden fragment nie jest wykonywany jako
/// HTML ani skrypt. Nieczytelna delta zwraca `null`, więc UI pokazuje tekst
/// zapisany w wiadomości, a nie pusty ekran.
abstract final class ChatRichTextCodec {
  /// Parsuje deltę Quill; `null` oznacza brak albo nieczytelną deltę.
  static List<ChatRichTextBlock>? tryParse(String? deltaJson) {
    if (deltaJson == null || deltaJson.trim().isEmpty) return null;
    Object? decoded;
    try {
      decoded = jsonDecode(deltaJson);
    } on FormatException {
      return null;
    }
    if (decoded is! Map) return null;
    final ops = decoded['ops'];
    if (ops is! List) return null;
    final blocks = _parseOps(ops);
    return blocks.isEmpty ? null : blocks;
  }

  static List<ChatRichTextBlock> _parseOps(List<Object?> ops) {
    final blocks = <ChatRichTextBlock>[];
    var spans = <ChatRichTextSpan>[];
    var kind = ChatRichTextBlockKind.paragraph;
    String? language;

    void flush() {
      if (spans.isNotEmpty) {
        blocks.add(
          ChatRichTextBlock(
            kind: kind,
            spans: List.of(spans),
            language: language,
          ),
        );
      }
      spans = <ChatRichTextSpan>[];
      kind = ChatRichTextBlockKind.paragraph;
      language = null;
    }

    for (final raw in ops) {
      if (raw is! Map) continue;
      final op = raw.cast<String, Object?>();
      final attributes =
          (op['attributes'] as Map?)?.cast<String, Object?>() ??
          const <String, Object?>{};
      final insert = op['insert'];
      if (insert is Map) {
        // Osadzony obiekt (obraz, wideo, formuła): pokazujemy znacznik, ale
        // nie przerywamy renderowania reszty wiadomości.
        spans.add(const ChatRichTextSpan.unsupported());
        continue;
      }
      if (insert is! String) continue;
      final segments = insert.split('\n');
      for (var index = 0; index < segments.length; index++) {
        if (segments[index].isNotEmpty) {
          spans.add(_span(segments[index], attributes));
        }
        final isLineBreak = index < segments.length - 1;
        if (!isLineBreak) continue;
        final blockKind = _blockKind(attributes);
        kind = blockKind.$1;
        language = blockKind.$2;
        flush();
      }
    }
    if (spans.isNotEmpty) flush();
    return blocks.where((block) => !block.isEmpty).toList(growable: false);
  }

  static ChatRichTextSpan _span(String text, Map<String, Object?> attributes) =>
      ChatRichTextSpan(
        text: text,
        bold: attributes['bold'] == true,
        italic: attributes['italic'] == true,
        underline: attributes['underline'] == true,
        strike: attributes['strike'] == true,
        isCode: attributes['code'] == true,
        link: _safeLink(attributes['link']),
      );

  static (ChatRichTextBlockKind, String?) _blockKind(
    Map<String, Object?> attributes,
  ) {
    final code = attributes['code-block'];
    if (code == true || code is String) {
      return (
        ChatRichTextBlockKind.code,
        code is String && code.isNotEmpty ? code : null,
      );
    }
    if (attributes['blockquote'] == true) {
      return (ChatRichTextBlockKind.quote, null);
    }
    if (attributes['list'] == 'ordered') {
      return (ChatRichTextBlockKind.orderedList, null);
    }
    if (attributes['list'] == 'bullet') {
      return (ChatRichTextBlockKind.bulletList, null);
    }
    return (ChatRichTextBlockKind.paragraph, null);
  }

  /// Przepuszcza wyłącznie adresy bezpieczne do otwarcia; nie pobiera treści.
  static String? _safeLink(Object? value) {
    if (value is! String) return null;
    final link = value.trim();
    if (link.isEmpty) return null;
    final uri = Uri.tryParse(link);
    if (uri == null) return null;
    if (uri.scheme == 'http' || uri.scheme == 'https') return link;
    if (uri.scheme.isEmpty && link.startsWith('/')) return link;
    return null;
  }
}
