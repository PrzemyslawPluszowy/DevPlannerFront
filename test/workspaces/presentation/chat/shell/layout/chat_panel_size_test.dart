import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatPanelSizeController', () {
    test('trzy kolumny wymagają sumy minimów, a nie progu modalnego', () {
      final minimum = ChatPanelSizeController.twoColumnMinimumWidth(
        compactRail: false,
      );

      expect(minimum, 722);
      expect(
        ChatPanelSizeController.fitsTwoColumns(
          available: minimum - 1,
          compactRail: false,
        ),
        isFalse,
      );
      expect(
        ChatPanelSizeController.fitsTwoColumns(
          available: minimum,
          compactRail: false,
        ),
        isTrue,
      );
    });

    test(
      'lista rośnie dopiero ponad szerokość minimalną układu trzech kolumn',
      () {
        expect(
          ChatPanelSizeController.listColumnWidth(
            available: 722,
            compactRail: false,
          ),
          304,
        );
        expect(
          ChatPanelSizeController.listColumnWidth(
            available: 762,
            compactRail: false,
          ),
          344,
        );
        expect(
          ChatPanelSizeController.listColumnWidth(
            available: 1200,
            compactRail: false,
          ),
          344,
        );
      },
    );

    test('domyślnie pokazuje pełny układ na typowym desktopie', () {
      final controller = ChatPanelSizeController();

      expect(controller.effectiveWidth(1600), 1120);
      expect(controller.effectiveWidth(1280), 960);
      expect(controller.effectiveWidth(1000), 750);
      expect(controller.effectiveWidth(900), 734);
    });

    test('szerokość panelu jest ograniczona do dostępnego okna', () {
      final controller = ChatPanelSizeController();

      expect(controller.effectiveWidth(700), 700);
      expect(ChatPanelSizeController.compactBreakpoint, 960);
      expect(controller.effectiveWidth(1440), 1080);
    });

    test('po zwężeniu panelu można przypiąć go obok treści', () {
      final controller = ChatPanelSizeController();
      controller.resizeBy(-500, available: 1440);

      expect(controller.effectiveWidth(1440), 580);
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
      controller.resizeBy(-100, available: 1600);

      expect(controller.hasCustomWidth, isTrue);
      expect(controller.effectiveWidth(900), 900);
      expect(controller.canPinAt(900), isFalse);
    });
  });
}
