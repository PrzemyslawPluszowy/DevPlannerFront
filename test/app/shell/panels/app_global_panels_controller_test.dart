import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/shell/panels/app_global_panels_controller.dart';

void main() {
  group('AppGlobalPanelsController', () {
    test(
      'przełącza Chat i powiadomienia bez utraty preferencji przypięcia',
      () {
        final controller = AppGlobalPanelsController();
        addTearDown(controller.dispose);

        controller.restore(chatPinned: true, chatWidth: 420);
        controller.showChat(pinned: true);

        expect(controller.activePanel, AppGlobalPanel.chat);
        expect(controller.isPinnedChatVisible, isTrue);
        expect(controller.chatWidth, 420);

        controller.showNotifications();

        expect(controller.activePanel, AppGlobalPanel.notifications);
        expect(controller.isPinnedChatVisible, isFalse);
        expect(controller.isChatPinned, isTrue);

        controller.close();

        expect(controller.activePanel, isNull);
        expect(controller.isPinnedChatVisible, isFalse);
        expect(controller.isChatPinned, isTrue);
      },
    );

    test('klamruje szerokość i przechowuje ostatnią rozmowę lokalnie', () {
      final controller = AppGlobalPanelsController();
      addTearDown(controller.dispose);

      controller.restore(chatPinned: false, chatWidth: 100);
      controller.adjustChatWidth(900);
      controller.selectLastConversation('conversation-7');

      expect(controller.chatWidth, 560);
      expect(controller.lastChatConversationId, 'conversation-7');
    });

    test('dwie instancje sesyjne nie dzielą widoczności panelu', () {
      final first = AppGlobalPanelsController();
      final second = AppGlobalPanelsController();
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      first.showChat(pinned: true);
      second.showNotifications();

      expect(first.activePanel, AppGlobalPanel.chat);
      expect(second.activePanel, AppGlobalPanel.notifications);
      expect(first.isPinnedChatVisible, isTrue);
      expect(second.isPinnedChatVisible, isFalse);
    });
  });
}
