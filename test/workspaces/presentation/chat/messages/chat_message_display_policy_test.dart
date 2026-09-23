import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_display_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String repeat(String value, int count) =>
      List<String>.filled(count, value).join();

  group('ChatMessageDisplayPolicy.shouldCollapse', () {
    test('zwija ciągły tekst powyżej progu, także bez nowych linii', () {
      expect(
        ChatMessageDisplayPolicy.shouldCollapse(
          repeat('a', ChatMessageDisplayPolicy.collapseCharacterThreshold),
        ),
        isFalse,
      );
      expect(
        ChatMessageDisplayPolicy.shouldCollapse(
          repeat('a', ChatMessageDisplayPolicy.collapseCharacterThreshold + 1),
        ),
        isTrue,
      );
    });

    test('zwija wiadomość przekraczającą limit linii', () {
      final text = List<String>.filled(
        ChatMessageDisplayPolicy.collapseLineThreshold + 1,
        'wiadomość',
      ).join('\n');

      expect(ChatMessageDisplayPolicy.shouldCollapse(text), isTrue);
    });

    test('krótka wiadomość pozostaje rozwinięta', () {
      expect(ChatMessageDisplayPolicy.shouldCollapse('krótki tekst'), isFalse);
    });
  });

  group('ChatMessageDisplayPolicy.addLinkWrapOpportunities', () {
    test('nie zmienia krótkiego linku', () {
      const link = 'https://example.test/krótki';

      expect(
        ChatMessageDisplayPolicy.addLinkWrapOpportunities(link),
        link,
      );
    });

    test('wstawia tylko niewidoczne punkty i zachowuje oryginalny tekst', () {
      final link = 'https://example.test/${repeat('x', 96)}';
      final displayText = ChatMessageDisplayPolicy.addLinkWrapOpportunities(
        link,
      );

      expect(displayText, contains('\u200b'));
      expect(displayText.replaceAll('\u200b', ''), link);
    });

    test('nie rozcina par zastępczych emoji', () {
      final link = 'https://example.test/${repeat('😀', 48)}';
      final displayText = ChatMessageDisplayPolicy.addLinkWrapOpportunities(
        link,
      );

      expect(displayText.replaceAll('\u200b', ''), link);
      expect(displayText.runes.length, greaterThan(link.runes.length));
    });
  });

  group('ChatMessageDisplayPolicy.addPlainTextUrlWrapOpportunities', () {
    test('zawija długi URL bez metadanych linku z backendu', () {
      final url = 'https://example.test/${repeat('x', 96)}';
      final message = 'Link: $url';
      final displayText =
          ChatMessageDisplayPolicy.addPlainTextUrlWrapOpportunities(message);

      expect(displayText, contains('\u200b'));
      expect(displayText.replaceAll('\u200b', ''), message);
    });

    test('nie dodaje punktów łamania do krótkiego adresu', () {
      const message = 'https://example.test/short';

      expect(
        ChatMessageDisplayPolicy.addPlainTextUrlWrapOpportunities(message),
        message,
      );
    });
  });
}
