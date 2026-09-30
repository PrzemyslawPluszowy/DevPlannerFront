import 'dart:convert';

import 'package:devplanner/workspaces/domain/chat/rich_text/chat_delta_contract_sanitizer.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_quill_controller_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatDeltaContractSanitizer', () {
    test('preserves supported text formats and valid code language', () {
      final result = ChatDeltaContractSanitizer.sanitize([
        {
          'insert': 'bold',
          'attributes': {'bold': true, 'color': '#f00'},
        },
        {
          'insert': 'url',
          'attributes': {'link': 'https://example.test/path'},
        },
        {
          'insert': '\n',
          'attributes': {'list': 'ordered', 'code-block': 'csharp'},
        },
      ]);

      expect(result, [
        {
          'insert': 'bold',
          'attributes': {'bold': true},
        },
        {
          'insert': 'url',
          'attributes': {'link': 'https://example.test/path'},
        },
        {
          'insert': '\n',
          'attributes': {'list': 'ordered', 'code-block': 'csharp'},
        },
      ]);
    });

    test('preserves every formatting attribute accepted by Chat API', () {
      final result = ChatDeltaContractSanitizer.sanitize([
        {
          'insert': 'sformatowany',
          'attributes': {
            'bold': true,
            'italic': true,
            'underline': true,
            'strike': true,
            'code': true,
            'blockquote': true,
            'link': 'https://example.test/docs',
          },
        },
        {
          'insert': 'kod\n',
          'attributes': {'code-block': 'dart'},
        },
        {
          'insert': '\n',
          'attributes': {'list': 'bullet'},
        },
        {
          'insert': '\n',
          'attributes': {'list': 'ordered'},
        },
      ]);

      expect(result, [
        {
          'insert': 'sformatowany',
          'attributes': {
            'bold': true,
            'italic': true,
            'underline': true,
            'strike': true,
            'code': true,
            'blockquote': true,
            'link': 'https://example.test/docs',
          },
        },
        {
          'insert': 'kod\n',
          'attributes': {'code-block': 'dart'},
        },
        {
          'insert': '\n',
          'attributes': {'list': 'bullet'},
        },
        {
          'insert': '\n',
          'attributes': {'list': 'ordered'},
        },
      ]);
    });

    test('keeps text but strips malformed or unsupported formatting', () {
      final result = ChatDeltaContractSanitizer.sanitize([
        {
          'insert': 'tekst',
          'attributes': {
            'bold': 'true',
            'header': 1,
            'link': 'javascript:alert(1)',
          },
        },
        {
          'insert': '\n',
          'attributes': {'list': 'checked'},
        },
      ]);

      expect(result, [
        {'insert': 'tekst'},
        {'insert': '\n'},
      ]);
    });

    test('drops malformed Delta JSON so text-only send can continue', () {
      expect(ChatDeltaContractSanitizer.sanitizeJson('{bad json'), isNull);
      expect(ChatDeltaContractSanitizer.sanitizeJson('[]'), isNull);
      expect(ChatDeltaContractSanitizer.sanitizeJson(null), isNull);
    });

    test('falls back to text when Delta exceeds Backend limits', () {
      final tooManyOperations = jsonEncode(
        List<Map<String, String>>.generate(
          10001,
          (_) => {'insert': 'x'},
          growable: false,
        ),
      );
      final tooLarge = jsonEncode([
        {'insert': 'x' * 200001},
      ]);

      expect(
        ChatDeltaContractSanitizer.sanitizeJson(tooManyOperations),
        isNull,
      );
      expect(ChatDeltaContractSanitizer.sanitizeJson(tooLarge), isNull);
    });

    test('converts pasted embeds to visible attachment guidance', () {
      final result = ChatDeltaContractSanitizer.sanitize([
        {'insert': 'przed'},
        {
          'insert': {'image': 'https://example.test/image.png'},
        },
        {
          'insert': {'custom-widget': 'payload'},
        },
        {'insert': 'po'},
      ]);

      expect(result, [
        {'insert': 'przed'},
        {'insert': '[wklejony obraz — dodaj jako załącznik]'},
        {'insert': '[nieobsługiwany element]'},
        {'insert': 'po'},
      ]);
    });

    test('normalizes an older draft before restoring the Quill document', () {
      final result = ChatQuillControllerFactory.normalizeDelta(
        jsonEncode([
          {
            'insert': 'zachowany tekst',
            'attributes': {'bold': true, 'color': '#f00'},
          },
          {
            'insert': {'image': 'https://example.test/photo.png'},
          },
          {
            'insert': '\n',
            'attributes': {'header': 1},
          },
        ]),
      );

      expect(result, isNotNull);
      expect(
        result!.text,
        'zachowany tekst[wklejony obraz — dodaj jako załącznik]',
      );
      expect(result.json, isNot(contains('color')));
      expect(result.json, isNot(contains('header')));
      expect(result.operations, isNotEmpty);
    });
  });
}
