import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatPanelSizeController', () {
    test('startuje z około 30% szerokości okna', () {
      final controller = ChatPanelSizeController();

      expect(controller.effectiveWidth(1600), closeTo(480, 0.01));
      expect(controller.effectiveWidth(1000), closeTo(320, 0.01));
    });

    test('pozwala przypiąć wąski panel na szerokim ekranie', () {
      final controller = ChatPanelSizeController();

      // 30% z 1440 to 432 px: panel jest w trybie jednej kolumny, ale okno
      // nadal mieści go obok treści aplikacji.
      expect(controller.effectiveWidth(1440) < 760, isTrue);
      expect(controller.canPinAt(1440), isTrue);
    });

    test('odmawia przypięcia, gdy panel zgniótłby treść aplikacji', () {
      final controller = ChatPanelSizeController();

      // 700 - 320 = 380 < 480 px użytecznej treści, więc przypięcie schodzi
      // tymczasowo do nakładki.
      expect(controller.canPinAt(700), isFalse);
      expect(controller.canPinAt(0), isFalse);
    });

    test('zapamiętana szerokość jest ograniczana do okna', () {
      final controller = ChatPanelSizeController();
      controller.resizeBy(900, available: 1600);

      expect(controller.hasCustomWidth, isTrue);
      expect(controller.effectiveWidth(900), 900);
      expect(controller.canPinAt(900), isFalse);
    });
  });
}
