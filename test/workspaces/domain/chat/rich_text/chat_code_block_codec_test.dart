import 'dart:convert';

import 'package:devplanner/workspaces/domain/chat/rich_text/chat_code_block_codec.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_rich_text_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatCodeBlockCodec', () {
    test('atrybut code-block ląduje na operacji kończącej linię', () {
      final ops = ChatCodeBlockCodec.build(
        code: 'final x = 1;',
        language: 'dart',
      );

      expect(ops, hasLength(2));
      expect(ops.first['insert'], 'final x = 1;');
      expect(ops.last['insert'], '\n');
      expect(ops.last['attributes'], {'code-block': 'dart'});
    });

    test('bez języka blok kodu używa wartości logicznej', () {
      final ops = ChatCodeBlockCodec.build(code: 'ls -la', language: '  ');

      expect(ops.last['attributes'], {'code-block': true});
    });

    test('wstawienie w środku akapitu oddziela poprzedni tekst', () {
      final ops = ChatCodeBlockCodec.buildInsertion(
        code: 'print(1)',
        language: 'python',
        precedingText: 'opis',
      );

      expect(ops.first, {'insert': '\n'});
      expect(ops[1], {'insert': 'print(1)'});
      expect(ops.last, {
        'insert': '\n',
        'attributes': {'code-block': 'python'},
      });
    });

    test('wstawienie na początku linii nie dodaje pustej linii', () {
      final ops = ChatCodeBlockCodec.buildInsertion(
        code: 'print(1)',
        precedingText: 'opis\n',
      );

      expect(ops, ChatCodeBlockCodec.build(code: 'print(1)'));
    });

    test('wstawiony blok rozdziela zwykły tekst i zachowuje kod jako blok', () {
      final operations = <Map<String, Object?>>[
        {'insert': 'opis'},
        ...ChatCodeBlockCodec.buildInsertion(
          code: 'print(1)',
          language: 'python',
          precedingText: 'opis',
        ),
        {'insert': 'dalszy tekst\n'},
      ];

      final blocks = ChatRichTextCodec.tryParse(jsonEncode(operations));

      expect(blocks, isNotNull);
      expect(
        blocks!.map((block) => block.kind),
        [
          ChatRichTextBlockKind.paragraph,
          ChatRichTextBlockKind.code,
          ChatRichTextBlockKind.paragraph,
        ],
      );
      expect(blocks[1].language, 'python');
      expect(blocks[1].spans.single.text, 'print(1)');
    });

    test('pusty kod nie tworzy bloku', () {
      expect(
        ChatCodeBlockCodec.build(code: '   \n', language: 'dart'),
        isEmpty,
      );
    });

    test('kod jest przycinany do limitu, a końcowe puste linie usuwane', () {
      final ops = ChatCodeBlockCodec.build(
        code: '${'a' * (ChatCodeBlockCodec.maxCodeLength + 10)}\n\n',
      );

      final inserted = ops.first['insert']! as String;
      expect(inserted.length, ChatCodeBlockCodec.maxCodeLength);
      expect(ops.last['insert'], '\n');
    });

    test('zaszyfrowany JSON jest czytelny dla renderera historii', () {
      final encoded = ChatCodeBlockCodec.encode(code: 'x = 1', language: 'py');

      final blocks = ChatRichTextCodec.tryParse(encoded);

      expect(blocks, isNotNull);
      expect(blocks!.single.kind, ChatRichTextBlockKind.code);
      expect(blocks.single.language, 'py');
      expect(blocks.single.spans.single.text, 'x = 1');
      // Sanity check: to prawidłowa tablica operacji, nie koperta `ops`.
      expect(jsonDecode(encoded), isA<List<Object?>>());
    });
  });
}
