import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_grouping.dart';
import 'package:flutter_test/flutter_test.dart';

ChatMessage _message({
  required String id,
  required String author,
  required DateTime createdAtUtc,
  bool isDeleted = false,
}) => ChatMessage(
  id: id,
  conversationId: 'conversation-1',
  authorUserId: author,
  clientMessageId: 'client-$id',
  text: 'treść $id',
  payloadHash: 'hash-$id',
  version: 1,
  createdAtUtc: createdAtUtc,
  isDeleted: isDeleted,
  deliveryState: ChatMessageDeliveryState.sent,
);

void main() {
  final base = DateTime.utc(2026, 9, 22, 10);

  group('ChatMessageGrouping', () {
    test('starsza strona historii nie jest liczona jako nowe wiadomości', () {
      final previous = [
        _message(id: '2', author: 'anna', createdAtUtc: base),
        _message(
          id: '3',
          author: 'anna',
          createdAtUtc: base.add(const Duration(minutes: 1)),
        ),
      ];
      final withOlderPage = [
        _message(
          id: '1',
          author: 'anna',
          createdAtUtc: base.subtract(const Duration(minutes: 1)),
        ),
        ...previous,
      ];

      expect(
        ChatMessageGrouping.countNewArrivals(previous, withOlderPage),
        0,
      );
    });

    test('nowa wiadomość po dotychczasowym końcu jest liczona', () {
      final previous = [
        _message(id: '1', author: 'anna', createdAtUtc: base),
      ];
      final current = [
        ...previous,
        _message(
          id: '2',
          author: 'piotr',
          createdAtUtc: base.add(const Duration(minutes: 1)),
        ),
      ];

      expect(ChatMessageGrouping.countNewArrivals(previous, current), 1);
    });

    test('pusta historia nie tworzy serii', () {
      expect(
        ChatMessageGrouping.group(const [], currentUserId: 'me'),
        isEmpty,
      );
    });

    test('ten sam autor w oknie pięciu minut tworzy jedną serię', () {
      final series = ChatMessageGrouping.group(
        [
          _message(id: '1', author: 'anna', createdAtUtc: base),
          _message(
            id: '2',
            author: 'anna',
            createdAtUtc: base.add(const Duration(minutes: 4)),
          ),
          _message(
            id: '3',
            author: 'anna',
            createdAtUtc: base.add(const Duration(minutes: 5)),
          ),
        ],
        currentUserId: 'me',
      );

      expect(series, hasLength(1));
      expect(series.single.messages.map((m) => m.id), ['1', '2', '3']);
      expect(series.single.isOwnAuthor, isFalse);
    });

    test('przerwa powyżej okna zamyka serię', () {
      final series = ChatMessageGrouping.group(
        [
          _message(id: '1', author: 'anna', createdAtUtc: base),
          _message(
            id: '2',
            author: 'anna',
            createdAtUtc: base.add(const Duration(minutes: 6)),
          ),
        ],
        currentUserId: 'me',
      );

      expect(series, hasLength(2));
      expect(series.first.messages.single.id, '1');
      expect(series.last.messages.single.id, '2');
    });

    test('zmiana autora startuje nową serię i przenosi stronę dymka', () {
      final series = ChatMessageGrouping.group(
        [
          _message(id: '1', author: 'anna', createdAtUtc: base),
          _message(
            id: '2',
            author: 'me',
            createdAtUtc: base.add(const Duration(minutes: 1)),
          ),
        ],
        currentUserId: 'me',
      );

      expect(series, hasLength(2));
      expect(series.first.isOwnAuthor, isFalse);
      expect(series.last.isOwnAuthor, isTrue);
    });

    test('granica dnia rozdziela serie nawet przy małej przerwie', () {
      final lateEvening = DateTime.utc(2026, 9, 22, 23, 58);
      final series = ChatMessageGrouping.group(
        [
          _message(id: '1', author: 'anna', createdAtUtc: lateEvening),
          _message(
            id: '2',
            author: 'anna',
            createdAtUtc: lateEvening.add(const Duration(minutes: 3)),
          ),
        ],
        currentUserId: 'me',
        toLocal: (value) => value,
      );

      expect(series, hasLength(2));
    });

    test('usunięcie wiadomości rozdziela serie tego samego autora', () {
      final series = ChatMessageGrouping.group(
        [
          _message(id: '1', author: 'anna', createdAtUtc: base),
          _message(
            id: '2',
            author: 'anna',
            createdAtUtc: base.add(const Duration(minutes: 1)),
            isDeleted: true,
          ),
        ],
        currentUserId: 'me',
      );

      expect(series, hasLength(2));
    });

    test('pusty identyfikator sesji nie oznacza wiadomości jako własnej', () {
      final series = ChatMessageGrouping.group(
        [_message(id: '1', author: 'me', createdAtUtc: base)],
        currentUserId: '',
      );

      expect(series.single.isOwnAuthor, isFalse);
    });

    test('własne wiadomości idą na prawo, gdy sesja jest znana', () {
      final series = ChatMessageGrouping.group(
        [_message(id: '1', author: 'me', createdAtUtc: base)],
        currentUserId: 'me',
      );

      expect(series.single.isOwnAuthor, isTrue);
      expect(series.single.first.id, '1');
    });
  });

  group('ChatMessageGrouping.timeline', () {
    test('separator dnia poprzedza serie z tego dnia', () {
      final timeline = ChatMessageGrouping.timeline(
        [
          _message(
            id: '1',
            author: 'anna',
            createdAtUtc: DateTime.utc(2026, 9, 22, 8),
          ),
          _message(
            id: '2',
            author: 'anna',
            createdAtUtc: DateTime.utc(2026, 9, 23, 9),
          ),
        ],
        currentUserId: 'me',
        toLocal: (value) => value,
      );

      expect(timeline, hasLength(4));
      expect(timeline[0], isA<ChatTimelineDate>());
      expect(timeline[1], isA<ChatTimelineSeries>());
      expect(timeline[2], isA<ChatTimelineDate>());
      expect(timeline[3], isA<ChatTimelineSeries>());
      expect((timeline[2] as ChatTimelineDate).day, DateTime(2026, 9, 23));
    });

    test('jedna seria w jednym dniu ma dokładnie jeden separator', () {
      final timeline = ChatMessageGrouping.timeline(
        [
          _message(
            id: '1',
            author: 'anna',
            createdAtUtc: DateTime.utc(2026, 9, 22, 8),
          ),
          _message(
            id: '2',
            author: 'anna',
            createdAtUtc: DateTime.utc(2026, 9, 22, 8, 2),
          ),
        ],
        currentUserId: 'me',
        toLocal: (value) => value,
      );

      expect(timeline, hasLength(2));
      expect(timeline.first, isA<ChatTimelineDate>());
      expect(
        (timeline.last as ChatTimelineSeries).series.messages,
        hasLength(2),
      );
    });

    test('pusta historia nie tworzy wpisów', () {
      expect(
        ChatMessageGrouping.timeline(const [], currentUserId: 'me'),
        isEmpty,
      );
    });
  });
}
