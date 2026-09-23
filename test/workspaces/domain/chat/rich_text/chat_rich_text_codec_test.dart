import 'dart:convert';

import 'package:devplanner/workspaces/domain/chat/rich_text/chat_rich_text_codec.dart';
import 'package:flutter_test/flutter_test.dart';

/// Kontrakt transportu to tablica operacji Quill (tak wysyła composer).
String delta(List<Object?> ops) => jsonEncode(ops);

void main() {
  group('ChatRichTextCodec', () {
    test('akceptuje tablicę operacji i starszą kopertę ops', () {
      final arrayForm = ChatRichTextCodec.tryParse(
        '[{"insert":"Hej\\n"}]',
      );
      final wrappedForm = ChatRichTextCodec.tryParse(
        jsonEncode({
          'ops': [
            {'insert': 'Hej\n'},
          ],
        }),
      );

      expect(arrayForm, isNotNull);
      expect(
        wrappedForm,
        isNotNull,
        reason: 'starsza koperta nie może ukrywać formatowania',
      );
      expect(arrayForm!.single.spans.single.text, 'Hej');
      expect(wrappedForm!.single.spans.single.text, 'Hej');
    });

    test('brak albo nieczytelna delta degraduje do tekstu wiadomości', () {
      expect(ChatRichTextCodec.tryParse(null), isNull);
      expect(ChatRichTextCodec.tryParse('   '), isNull);
      expect(ChatRichTextCodec.tryParse('{not-json'), isNull);
      expect(ChatRichTextCodec.tryParse('{"ops":"nie-lista"}'), isNull);
      expect(ChatRichTextCodec.tryParse('{"insert":"nie-tablica"}'), isNull);
    });

    test('dzieli akapity i formatuje inline', () {
      final blocks = ChatRichTextCodec.tryParse(
        delta([
          {
            'insert': 'Hej ',
          },
          {
            'insert': 'świecie',
            'attributes': {'bold': true},
          },
          {'insert': '\n'},
          {'insert': 'Druga linia'},
          {'insert': '\n'},
        ]),
      );

      expect(blocks, isNotNull);
      final parsed = blocks!;
      expect(parsed, hasLength(2));
      expect(parsed.first.kind, ChatRichTextBlockKind.paragraph);
      expect(parsed.first.spans.last.bold, isTrue);
      expect(parsed.last.spans.single.text, 'Druga linia');
    });

    test('rozpoznaje blok kodu z językiem i zachowuje whitespace', () {
      final blocks = ChatRichTextCodec.tryParse(
        delta([
          {
            'insert': 'final x = 1;\n',
            'attributes': {'code-block': 'dart'},
          },
          {'insert': 'Tekst po kodzie\n'},
        ]),
      );

      expect(blocks, isNotNull);
      final code = blocks!.first;
      expect(code.kind, ChatRichTextBlockKind.code);
      expect(code.language, 'dart');
      expect(code.plainTextOf(), 'final x = 1;');
      expect(blocks.last.kind, ChatRichTextBlockKind.paragraph);
    });

    test('rozpoznaje listy punktowane, numerowane i cytat', () {
      final blocks = ChatRichTextCodec.tryParse(
        delta([
          {
            'insert': 'punkt\n',
            'attributes': {'list': 'bullet'},
          },
          {
            'insert': 'krok\n',
            'attributes': {'list': 'ordered'},
          },
          {
            'insert': 'cytat\n',
            'attributes': {'blockquote': true},
          },
        ]),
      );

      expect(blocks!.map((block) => block.kind), [
        ChatRichTextBlockKind.bulletList,
        ChatRichTextBlockKind.orderedList,
        ChatRichTextBlockKind.quote,
      ]);
    });

    test('osadzony obiekt nie psuje reszty historii', () {
      final blocks = ChatRichTextCodec.tryParse(
        delta([
          {'insert': 'Przed'},
          {
            'insert': {'image': 'https://example.test/x.png'},
          },
          {'insert': 'Po\n'},
        ]),
      );

      expect(blocks, isNotNull);
      final spans = blocks!.single.spans;
      expect(spans.any((span) => span.unsupported), isTrue);
      expect(
        spans.map((span) => span.text).join(),
        'PrzedPo',
        reason: 'reszta treści pozostaje czytelna',
      );
    });

    test('przepuszcza tylko bezpieczne linki', () {
      final blocks = ChatRichTextCodec.tryParse(
        delta([
          {
            'insert': 'opis',
            'attributes': {'link': 'https://example.test/a'},
          },
          {
            'insert': ' i ',
          },
          {
            'insert': 'zły',
            'attributes': {'link': 'javascript:alert(1)'},
          },
          {'insert': '\n'},
        ]),
      );

      final spans = blocks!.single.spans;
      expect(spans.first.link, 'https://example.test/a');
      expect(
        spans.last.link,
        isNull,
        reason: 'schemat inny niż HTTP/HTTPS albo ścieżka aplikacji nie jest linkiem',
      );
    });
  });
}

/// Lokalne rozszerzenie czytelności asercji w teście.
extension on ChatRichTextBlock {
  String plainTextOf() => spans.map((span) => span.text).join();
}
