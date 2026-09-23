import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Nawigacja panelu w trybie compact: rail pokazuje listę sekcji, a wybór
/// rozmowy pokazuje rozmowę. Bez tego kliknięcie Plików czy Kanałów z otwartą
/// rozmową nie pokazywało niczego.
void main() {
  group('ChatPanelSectionCubit', () {
    test('start pokazuje listę czatów', () {
      final cubit = ChatPanelSectionCubit();

      expect(cubit.state.section, ChatPanelSection.chats);
      expect(cubit.state.showList, isTrue);
    });

    test(
      'globalny licznik nieprzeczytanych należy tylko do skrzynki Czaty',
      () {
        expect(ChatPanelSection.chats.showsGlobalUnreadBadge, isTrue);
        for (final section in ChatPanelSection.values.where(
          (section) => section != ChatPanelSection.chats,
        )) {
          expect(section.showsGlobalUnreadBadge, isFalse, reason: '$section');
        }
      },
    );

    test('wybór sekcji pokazuje jej listę', () {
      final cubit = ChatPanelSectionCubit();

      cubit.showConversation();
      cubit.select(ChatPanelSection.files);

      expect(cubit.state.section, ChatPanelSection.files);
      expect(
        cubit.state.showList,
        isTrue,
        reason: 'sekcja wybrana na railu ma pokazać własną listę',
      );
    });

    test('ponowny wybór tej samej sekcji wraca z rozmowy do listy', () {
      final cubit = ChatPanelSectionCubit();
      cubit.select(ChatPanelSection.channels);
      cubit.showConversation();

      cubit.select(ChatPanelSection.channels);

      expect(cubit.state.section, ChatPanelSection.channels);
      expect(cubit.state.showList, isTrue);
    });

    test('wybór rozmowy nie zmienia sekcji i nie emituje bez potrzeby', () {
      final cubit = ChatPanelSectionCubit();
      cubit.select(ChatPanelSection.groups);
      final showing = cubit.state;

      cubit.showConversation();
      expect(cubit.state.section, ChatPanelSection.groups);
      expect(cubit.state.showList, isFalse);

      final conversation = cubit.state;
      cubit.showConversation();
      expect(cubit.state, same(conversation));
      expect(cubit.state, isNot(same(showing)));
    });
  });
}
