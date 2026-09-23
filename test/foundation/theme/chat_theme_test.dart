import 'package:devplanner/foundation/theme/chat_theme.dart';
import 'package:devplanner/foundation/theme/menu_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'jasny ChatTheme ma własne zielone akcenty i miętowy dymek wychodzący',
    () {
      final chat = DevPlannerChatTheme.of(
        ThemeData.light().textTheme,
        const ColorScheme.light(),
      );

      expect(chat.sendButtonSurface, const Color(0xff00a884));
      expect(chat.actionText, const Color(0xff008069));
      expect(chat.linkText, const Color(0xff027eb5));
      expect(chat.focusRing, const Color(0xff00a884));
      expect(chat.outgoingBubble, const Color(0xffd9fdd3));
      expect(chat.conversationSurface, const Color(0xffefeae2));
      expect(chat.outgoingText, const Color(0xff111b21));
    },
  );

  test(
    'ciemny ChatTheme ma grafitowe powierzchnie i czytelny zielony dymek',
    () {
      final chat = DevPlannerChatTheme.of(
        ThemeData.dark().textTheme,
        const ColorScheme.dark(),
      );

      expect(chat.panelSurface, const Color(0xff111b21));
      expect(chat.conversationSurface, const Color(0xff0b141a));
      expect(chat.incomingBubble, const Color(0xff202c33));
      expect(chat.outgoingBubble, const Color(0xff005c4b));
      expect(chat.actionText, const Color(0xff25d366));
      expect(chat.outgoingText, const Color(0xffe9edef));
    },
  );

  test(
    'ChatTheme nakłada własny styl na kontrolki bez zmiany bazowej palety',
    () {
      final base = ThemeData.light().copyWith(
        extensions: [
          DevPlannerMenuTheme.of(
            ThemeData.light().textTheme,
            ThemeData.light().colorScheme,
          ),
        ],
      );
      final chat = DevPlannerChatTheme.of(base.textTheme, base.colorScheme);
      final controls = chat.applyControls(base);

      expect(
        controls.filledButtonTheme.style?.backgroundColor?.resolve(const {}),
        chat.sendButtonSurface,
      );
      expect(
        controls.textButtonTheme.style?.foregroundColor?.resolve(const {}),
        chat.actionText,
      );
      expect(
        controls.iconButtonTheme.style?.foregroundColor?.resolve(const {}),
        chat.metadataText,
      );
      expect(controls.textSelectionTheme.cursorColor, chat.focusRing);
      expect(controls.textSelectionTheme.selectionHandleColor, chat.focusRing);
      expect(controls.inputDecorationTheme.fillColor, chat.composerSurface);
      final menu = controls.extension<DevPlannerMenuTheme>()!;
      expect(menu.surface, chat.panelSurface);
      expect(menu.itemSelectedForeground, chat.focusRing);
    },
  );

  test('ChatTheme ma osobną geometrię i kolory wspólnego menu', () {
    final base = ThemeData.light();
    final chat = DevPlannerChatTheme.of(base.textTheme, base.colorScheme);
    final menu = chat.applyMenuTheme(
      DevPlannerMenuTheme.of(base.textTheme, base.colorScheme),
    );

    expect(menu.surface, chat.panelSurface);
    expect(menu.itemForeground, chat.incomingText);
    expect(menu.itemSelectedForeground, chat.focusRing);
    expect(menu.itemHover, chat.hoverSurface);
    expect(menu.rowHeight, 40);
    expect(menu.radius, 14);
  });
}
