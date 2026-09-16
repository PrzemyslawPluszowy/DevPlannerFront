import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;

/// Rozstrzyga skrót wysyłki tekstowego composera bez ingerencji w IME.
final class ChatComposerKeyboardPolicy {
  /// Obsługuje Enter tylko poza aktywną kompozycją IME i bez klawisza Shift.
  KeyEventResult handle({
    required KeyEvent event,
    required TextEditingValue value,
    required VoidCallback onSubmit,
  }) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.enter) {
      return KeyEventResult.ignored;
    }
    if (HardwareKeyboard.instance.isShiftPressed || _hasImeComposition(value)) {
      return KeyEventResult.ignored;
    }
    onSubmit();
    return KeyEventResult.handled;
  }

  bool _hasImeComposition(TextEditingValue value) =>
      value.composing.isValid && !value.composing.isCollapsed;
}
