import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_keyboard_policy.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatComposerKeyboardPolicy', () {
    test('Enter wysyła gotowy draft', () {
      var submissions = 0;

      final result = ChatComposerKeyboardPolicy().handle(
        event: _KeyboardFixture.enterDown(),
        value: const TextEditingValue(text: 'Gotowa wiadomość'),
        onSubmit: () => submissions++,
      );

      expect(result, KeyEventResult.handled);
      expect(submissions, 1);
    });

    test('Enter podczas kompozycji IME pozostaje w edytorze', () {
      var submissions = 0;

      final result = ChatComposerKeyboardPolicy().handle(
        event: _KeyboardFixture.enterDown(),
        value: const TextEditingValue(
          text: 'ka',
          composing: TextRange(start: 0, end: 2),
        ),
        onSubmit: () => submissions++,
      );

      expect(result, KeyEventResult.ignored);
      expect(submissions, 0);
    });
  });
}

abstract final class _KeyboardFixture {
  static KeyDownEvent enterDown() => const KeyDownEvent(
    physicalKey: PhysicalKeyboardKey.enter,
    logicalKey: LogicalKeyboardKey.enter,
    timeStamp: Duration.zero,
  );
}
