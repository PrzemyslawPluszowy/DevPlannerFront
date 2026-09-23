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
