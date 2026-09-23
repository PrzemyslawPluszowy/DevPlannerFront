import 'package:devplanner/workspaces/presentation/chat/presence/chat_typing_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatTypingLabels', () {
    test('brak piszących daje neutralną decyzję', () {
      final decision = ChatTypingLabels.decide(
        typingUserIds: const <String>[],
        participantLabels: const {'u1': 'Anna'},
      );
      expect(decision, isA<ChatTypingUnknown>());
    });

    test('jedna znana osoba pisze sama', () {
      final decision = ChatTypingLabels.decide(
        typingUserIds: const ['u1'],
        participantLabels: const {'u1': 'Anna'},
      );
      expect(decision, isA<ChatTypingSingle>());
      expect((decision as ChatTypingSingle).name, 'Anna');
    });

    test('dwie znane osoby dają parę imion', () {
      final decision = ChatTypingLabels.decide(
        typingUserIds: const ['u2', 'u1'],
        participantLabels: const {'u1': 'Anna', 'u2': 'Piotr'},
      );
      expect(decision, isA<ChatTypingPair>());
      final pair = decision as ChatTypingPair;
      expect([pair.first, pair.second], containsAll(<String>['Anna', 'Piotr']));
    });

    test('trzy osoby dają pierwszą nazwę i liczbę pozostałych', () {
      final decision = ChatTypingLabels.decide(
        typingUserIds: const ['u1', 'u2', 'u3'],
        participantLabels: const {'u1': 'Anna', 'u2': 'Piotr'},
      );
      expect(decision, isA<ChatTypingCrowd>());
      final crowd = decision as ChatTypingCrowd;
      expect(crowd.others, 2);
      expect(crowd.first, isNotEmpty);
    });

    test('nieznane etykiety nie udają imion', () {
      final decision = ChatTypingLabels.decide(
        typingUserIds: const ['u9'],
        participantLabels: const {'u1': 'Anna'},
      );
      expect(decision, isA<ChatTypingUnknown>());
    });

    test('jedna znana etykieta przy wielu piszących daje liczebność', () {
      final decision = ChatTypingLabels.decide(
        typingUserIds: const ['u1', 'u9'],
        participantLabels: const {'u1': 'Anna'},
      );
      expect(decision, isA<ChatTypingCrowd>());
      expect((decision as ChatTypingCrowd).others, 1);
    });

    test('kolejność zbioru nie zmienia wybranej osoby', () {
      final first = ChatTypingLabels.decide(
        typingUserIds: const ['u1', 'u2'],
        participantLabels: const {'u1': 'Anna', 'u2': 'Piotr'},
      ) as ChatTypingPair;
      final second = ChatTypingLabels.decide(
        typingUserIds: const ['u2', 'u1'],
        participantLabels: const {'u1': 'Anna', 'u2': 'Piotr'},
      ) as ChatTypingPair;
      expect(first.first, second.first);
      expect(first.second, second.second);
    });
  });
}
