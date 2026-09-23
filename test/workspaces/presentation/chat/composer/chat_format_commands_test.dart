import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_commands.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatFormatCommands', () {
    test(
      'pasek zaznaczenia ma pogrubienie, kursywę, przekreślenie, kod i link',
      () {
        expect(
          ChatFormatCommands.selectionBar,
          containsAll(<ChatFormatCommand>[
            ChatFormatCommand.bold,
            ChatFormatCommand.italic,
            ChatFormatCommand.strike,
            ChatFormatCommand.inlineCode,
            ChatFormatCommand.link,
            ChatFormatCommand.clear,
          ]),
        );
      },
    );

    test('klucze atrybutów odpowiadają transportowi wiadomości', () {
      expect(ChatFormatCommands.attributeKeys[ChatFormatCommand.bold], 'bold');
      expect(
        ChatFormatCommands.attributeKeys[ChatFormatCommand.strike],
        'strike',
      );
      expect(
        ChatFormatCommands.attributeKeys[ChatFormatCommand.inlineCode],
        'code',
      );
      expect(ChatFormatCommands.attributeKeys[ChatFormatCommand.link], 'link');
      expect(
        ChatFormatCommands.attributeKeys.containsKey(ChatFormatCommand.clear),
        isFalse,
      );
    });

    test('przełączanie włącza i zdejmuje atrybut', () {
      expect(
        ChatFormatCommands.toggledValue(
          ChatFormatCommand.bold,
          currentlyActive: false,
        ),
        isTrue,
      );
      expect(
        ChatFormatCommands.toggledValue(
          ChatFormatCommand.bold,
          currentlyActive: true,
        ),
        isNull,
      );
    });

    test('wyłączenie formatowania zawsze zdejmuje atrybut', () {
      expect(
        ChatFormatCommands.toggledValue(
          ChatFormatCommand.clear,
          currentlyActive: false,
        ),
        isNull,
      );
      expect(
        ChatFormatCommands.toggledValue(
          ChatFormatCommand.clear,
          currentlyActive: true,
        ),
        isNull,
      );
    });

    test('link bez adresu nie jest stosowany', () {
      expect(
        ChatFormatCommands.toggledValue(
          ChatFormatCommand.link,
          currentlyActive: false,
        ),
        isNull,
      );
      expect(
        ChatFormatCommands.toggledValue(
          ChatFormatCommand.link,
          currentlyActive: false,
          link: '   ',
        ),
        isNull,
      );
      expect(
        ChatFormatCommands.toggledValue(
          ChatFormatCommand.link,
          currentlyActive: false,
          link: 'https://devplanner.example/docs',
        ),
        'https://devplanner.example/docs',
      );
    });

    test('aktywność atrybutu odróżnia brak od wartości fałszywej', () {
      expect(
        ChatFormatCommands.isActive(ChatFormatCommand.bold, const {}),
        isFalse,
      );
      expect(
        ChatFormatCommands.isActive(ChatFormatCommand.bold, const {
          'bold': false,
        }),
        isFalse,
      );
      expect(
        ChatFormatCommands.isActive(ChatFormatCommand.bold, const {
          'bold': true,
        }),
        isTrue,
      );
      expect(
        ChatFormatCommands.isActive(ChatFormatCommand.link, const {
          'link': 'https://example.test',
        }),
        isTrue,
      );
    });

    test('dopuszczalne są tylko bezpieczne adresy', () {
      expect(ChatFormatCommands.isSafeLink('https://example.test/a'), isTrue);
      expect(ChatFormatCommands.isSafeLink('HTTP://EXAMPLE.TEST'), isTrue);
      expect(ChatFormatCommands.isSafeLink('/workspaces/1/chat'), isTrue);
      expect(ChatFormatCommands.isSafeLink('javascript:alert(1)'), isFalse);
      expect(ChatFormatCommands.isSafeLink('data:text/html,<b>x</b>'), isFalse);
      expect(ChatFormatCommands.isSafeLink(''), isFalse);
      expect(ChatFormatCommands.isSafeLink(null), isFalse);
    });

    test('adres bez schematu dostaje https, a ścieżka aplikacji zostaje', () {
      expect(
        ChatFormatCommands.normalizeLink('devplanner.example'),
        'https://devplanner.example',
      );
      expect(
        ChatFormatCommands.normalizeLink('https://a.test'),
        'https://a.test',
      );
      expect(
        ChatFormatCommands.normalizeLink('/workspaces/2'),
        '/workspaces/2',
      );
    });
  });

  group('ChatLineFormatCommands', () {
    test('listy dzielą klucz, ale różnią się wartością', () {
      expect(
        ChatLineFormatCommands.attributeKeys[ChatLineFormatCommand.bulletList],
        'list',
      );
      expect(
        ChatLineFormatCommands.toggledValue(
          ChatLineFormatCommand.bulletList,
          currentlyActive: false,
        ),
        const <Object?>['bullet'],
      );
      expect(
        ChatLineFormatCommands.toggledValue(
          ChatLineFormatCommand.orderedList,
          currentlyActive: false,
        ),
        const <Object?>['ordered'],
      );
    });

    test('cytat i blok kodu są atrybutami linii', () {
      expect(
        ChatLineFormatCommands.attributeKeys[ChatLineFormatCommand.quote],
        'blockquote',
      );
      expect(
        ChatLineFormatCommands.attributeKeys[ChatLineFormatCommand.codeBlock],
        'code-block',
      );
    });

    test('aktywna linia zdejmuje atrybut, a listy rozróżnia wartość', () {
      expect(
        ChatLineFormatCommands.toggledValue(
          ChatLineFormatCommand.quote,
          currentlyActive: true,
        ),
        isNull,
      );
      expect(
        ChatLineFormatCommands.isActive(
          ChatLineFormatCommand.bulletList,
          const {
            'list': <Object?>['bullet'],
          },
        ),
        isTrue,
      );
      expect(
        ChatLineFormatCommands.isActive(
          ChatLineFormatCommand.orderedList,
          const {
            'list': <Object?>['bullet'],
          },
        ),
        isFalse,
      );
    });

    test('pasek linii ma dokładnie listę, cycat i blok kodu', () {
      expect(ChatLineFormatCommands.toolbar, hasLength(4));
    });
  });
}
