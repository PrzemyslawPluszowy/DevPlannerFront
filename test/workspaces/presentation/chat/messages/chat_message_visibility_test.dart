import 'dart:ui' show Rect;

import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_visibility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessageVisibility', () {
    test('requires at least half the message inside the viewport', () {
      const message = Rect.fromLTWH(0, 0, 100, 40);

      expect(
        ChatMessageVisibility.isMajorityVisible(
          message,
          const Rect.fromLTWH(0, 0, 100, 20),
        ),
        isTrue,
      );
      expect(
        ChatMessageVisibility.isMajorityVisible(
          message,
          const Rect.fromLTWH(0, 0, 100, 19),
        ),
        isFalse,
      );
    });

    test('fully offscreen or zero-size messages are not visible', () {
      expect(
        ChatMessageVisibility.isMajorityVisible(
          const Rect.fromLTWH(0, 0, 100, 40),
          const Rect.fromLTWH(120, 80, 100, 40),
        ),
        isFalse,
      );
      expect(
        ChatMessageVisibility.isMajorityVisible(
          const Rect.fromLTWH(0, 0, 0, 40),
          const Rect.fromLTWH(0, 0, 100, 100),
        ),
        isFalse,
      );
    });
  });
}
