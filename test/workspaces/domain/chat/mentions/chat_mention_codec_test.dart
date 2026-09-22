import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const userId = '11111111-1111-1111-1111-111111111111';

  group('ChatMentionCodec', () {
    test('buduje token transportu i etykietę prezentacji', () {
      expect(ChatMentionCodec.tokenFor(userId), '@$userId');
      expect(
        ChatMentionCodec.labelFor(
          userId: userId,
          displayName: 'Ola Kowalska',
          login: 'ola.k',
        ),
        'Ola Kowalska',
      );
      expect(
        ChatMentionCodec.labelFor(userId: userId, login: 'ola.k'),
        'ola.k',
        reason: 'brak nazwy wyświetlanej nie może pokazywać UUID',
      );
    });

    test('renderer podmienia token na etykietę, a nieznany zostawia', () {
      const unknown = '22222222-2222-2222-2222-222222222222';
      const text = 'Hej @$userId i @$unknown oraz @all';

      final rendered = ChatMentionCodec.renderText(text, {userId: 'Ola'});

      expect(rendered, 'Hej @Ola i @$unknown oraz @all');
    });

    test('wykrywa aktywne wywołanie wzmianki z frazą', () {
      final query = ChatMentionCodec.activeQuery('Hej @ol', 7);

      expect(query, isNotNull);
      expect(query!.start, 4);
      expect(query.end, 7);
      expect(query.term, 'ol');
    });

    test('samo @ otwiera listę z pustą frazą', () {
      final query = ChatMentionCodec.activeQuery('Hej @', 5);

      expect(query, isNotNull);
      expect(query!.term, isEmpty);
    });

    test('nie traktuje adresu e-mail ani spacji jako wzmianki', () {
      expect(ChatMentionCodec.activeQuery('mail do ola@example', 18), isNull);
      expect(ChatMentionCodec.activeQuery('Hej @ol kowalska', 17), isNull);
      expect(ChatMentionCodec.activeQuery('bez wzmianki', 12), isNull);
    });

    test('kursor przed @ nie tworzy wywołania', () {
      expect(ChatMentionCodec.activeQuery('Hej @ol', 4), isNull);
    });

    test('wysyłany tekst zamienia etykiety na tokeny UUID', () {
      const peer = '22222222-2222-2222-2222-222222222222';
      final wire = ChatMentionCodec.toWireText(
        visibleText: 'Hej @Ola i @Jan, zobacz',
        mentions: const [
          ChatMentionReference(userId: userId, label: 'Ola'),
          ChatMentionReference(userId: peer, label: 'Jan'),
        ],
      );

      expect(wire, 'Hej @$userId i @$peer, zobacz');
    });

    test('ręcznie wpisana nazwa bez wyboru osoby nie pinguje', () {
      final wire = ChatMentionCodec.toWireText(
        visibleText: 'Piszę do @Ola',
        mentions: const [],
      );

      expect(
        wire,
        'Piszę do @Ola',
        reason: 'bez wyboru osoby nie ma tokenu UUID, więc serwer nie zapisze wzmianki',
      );
      expect(wire, isNot(contains('@11111111')));
    });

    test('render i wysyłka tworzą spójną rundę', () {
      const peer = '22222222-2222-2222-2222-222222222222';
      const wire = 'Hej @$peer i @all';

      final rendered = ChatMentionCodec.renderText(wire, {peer: 'Jan'});
      final back = ChatMentionCodec.toWireText(
        visibleText: rendered,
        mentions: const [ChatMentionReference(userId: peer, label: 'Jan')],
      );

      expect(rendered, 'Hej @Jan i @all');
      expect(back, wire);
    });
  });
}
