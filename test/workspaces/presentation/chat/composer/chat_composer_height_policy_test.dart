import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_height_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatComposerHeightPolicy', () {
    test('limits editor to 30% of a short conversation', () {
      expect(
        ChatComposerHeightPolicy.maxEditorHeight(
          availableConversationHeight: 300,
          themeMaxHeight: 160,
        ),
        90,
      );
    });

    test('never exceeds the theme maximum on a tall conversation', () {
      expect(
        ChatComposerHeightPolicy.maxEditorHeight(
          availableConversationHeight: 900,
          themeMaxHeight: 160,
        ),
        160,
      );
    });

    test('keeps one line available in an extremely short window', () {
      expect(
        ChatComposerHeightPolicy.maxEditorHeight(
          availableConversationHeight: 100,
          themeMaxHeight: 160,
        ),
        ChatComposerHeightPolicy.minimumEditorHeight,
      );
    });

    test('uses theme maximum for unbounded layout constraints', () {
      expect(
        ChatComposerHeightPolicy.maxEditorHeight(
          availableConversationHeight: double.infinity,
          themeMaxHeight: 160,
        ),
        160,
      );
    });
  });
}
