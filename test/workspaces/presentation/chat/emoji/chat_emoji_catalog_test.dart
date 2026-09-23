import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_catalog.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatEmojiCatalog', () {
    test('katalog ma wpisy w każdej kategorii z listy pickera', () {
      const categories = <ChatEmojiCategory>[
        ChatEmojiCategory.people,
        ChatEmojiCategory.nature,
        ChatEmojiCategory.food,
        ChatEmojiCategory.activity,
        ChatEmojiCategory.travel,
        ChatEmojiCategory.objects,
        ChatEmojiCategory.symbols,
      ];
      for (final category in categories) {
        expect(
          ChatEmojiCatalog.byCategory[category],
          isNotEmpty,
          reason: 'brak wpisów w kategorii $category',
        );
      }
      expect(ChatEmojiCatalog.all, isNotEmpty);
    });

    test('puste zapytanie zwraca cały katalog', () {
      expect(
        ChatEmojiCatalog.search('   '),
        hasLength(ChatEmojiCatalog.all.length),
      );
    });

    test(
      'wyszukiwanie po nazwie i słowie kluczowym nie zależy od wielkości liter',
      () {
        final byName = ChatEmojiCatalog.search('Kciuk');
        expect(byName.map((entry) => entry.emoji), contains('👍'));
        final byKeyword = ChatEmojiCatalog.search('ROCKET');
        expect(byKeyword.map((entry) => entry.emoji), contains('🚀'));
      },
    );

    test('zapytanie bez dopasowania zwraca pustą listę', () {
      expect(ChatEmojiCatalog.search('zzz-nie-ma-takiego'), isEmpty);
    });

    test('szybkie reakcje są kompletne i unikalne', () {
      expect(ChatEmojiCatalog.quickReactions, hasLength(6));
      expect(
        ChatEmojiCatalog.quickReactions.toSet(),
        hasLength(ChatEmojiCatalog.quickReactions.length),
      );
    });
  });

  group('ChatEmojiSkinTone', () {
    final thumb = ChatEmojiCatalog.all.firstWhere(
      (entry) => entry.emoji == '👍',
    );
    final rocket = ChatEmojiCatalog.all.firstWhere(
      (entry) => entry.emoji == '🚀',
    );

    test('wariant jest doklejany tylko do znaków, które go wspierają', () {
      expect(ChatEmojiSkinTone.apply(thumb, 3), '👍\u{1F3FD}');
      expect(ChatEmojiSkinTone.apply(rocket, 3), '🚀');
    });

    test('domyślny i niepoprawny indeks zwracają znak bazowy', () {
      expect(ChatEmojiSkinTone.apply(thumb, 0), '👍');
      expect(ChatEmojiSkinTone.apply(thumb, 99), '👍');
    });

    test('każdy wariant dokleja dokładnie jeden modyfikator', () {
      for (var index = 1; index < ChatEmojiSkinTone.modifiers.length; index++) {
        expect(
          ChatEmojiSkinTone.apply(thumb, index),
          '${thumb.emoji}${ChatEmojiSkinTone.modifiers[index]}',
        );
      }
    });
  });

  group('ChatEmojiRecentCubit', () {
    test('nowy znak trafia na początek listy', () {
      final cubit = ChatEmojiRecentCubit();
      addTearDown(cubit.close);
      cubit.remember('👍');
      cubit.remember('🎉');
      expect(cubit.state, ['🎉', '👍']);
    });

    test('powtórzone użycie przenosi znak, nie duplikuje go', () {
      final cubit = ChatEmojiRecentCubit();
      addTearDown(cubit.close);
      cubit.remember('👍');
      cubit.remember('🎉');
      cubit.remember('👍');
      expect(cubit.state, ['👍', '🎉']);
    });

    test('lista respektuje limit pozycji', () {
      final cubit = ChatEmojiRecentCubit(limit: 2);
      addTearDown(cubit.close);
      cubit.remember('👍');
      cubit.remember('🎉');
      cubit.remember('🚀');
      expect(cubit.state, ['🚀', '🎉']);
    });

    test('pusty znak nie zmienia listy, a clear ją czyści', () {
      final cubit = ChatEmojiRecentCubit();
      addTearDown(cubit.close);
      cubit.remember('   ');
      expect(cubit.state, isEmpty);
      cubit.remember('👍');
      cubit.clear();
      expect(cubit.state, isEmpty);
    });
  });
}
