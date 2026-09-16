import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:ready_next/workspaces/domain/chat/realtime/chat_realtime_export.dart';

import '../../support/chat_realtime_test_support.dart';

void main() {
  group('WorkspaceChatRealtimeService typed conversation events', () {
    test(
      'mapuje utworzenie, zmianę i usunięcie do typowanego kontraktu',
      () async {
        final transport = ChatRealtimeTestTransport();
        final service = WorkspaceChatRealtimeService(client: transport);
        final events = <ChatConversationRealtimeEvent>[];
        final subscription = service.conversationEvents.listen(events.add);

        await service.start('conversation-1');
        transport.emit(
          'chat.message.created',
          ChatRealtimeTestPayload.message(eventId: 'created-1', sequence: 1),
        );
        transport.emit(
          'chat.message.updated',
          ChatRealtimeTestPayload.message(
            eventId: 'updated-1',
            sequence: 2,
            text: 'Po zmianie',
            version: 2,
          ),
        );
        transport.emit(
          'chat.message.deleted',
          ChatRealtimeTestPayload.deletion(eventId: 'deleted-1', sequence: 3),
        );
        await ChatRealtimeTestPayload.flush();

        expect(
          events.map((event) => event.kind),
          <ChatConversationRealtimeEventKind>[
            ChatConversationRealtimeEventKind.messageCreated,
            ChatConversationRealtimeEventKind.messageUpdated,
            ChatConversationRealtimeEventKind.messageDeleted,
          ],
        );
        expect(events[0].message?.id, 'message-1');
        expect(events[1].message?.text, 'Po zmianie');
        expect(events[2].messageId, 'message-1');
        await subscription.cancel();
        await service.dispose();
      },
    );

    test(
      'nie emituje duplikatu z live i replayu ani starszej sekwencji',
      () async {
        final transport = ChatRealtimeTestTransport();
        final service = WorkspaceChatRealtimeService(client: transport);
        final events = <ChatConversationRealtimeEvent>[];
        final subscription = service.conversationEvents.listen(events.add);

        await service.start('conversation-1');
        transport.emit(
          'chat.message.created',
          ChatRealtimeTestPayload.message(eventId: 'event-1', sequence: 10),
        );
        transport.replayResult = ChatRealtimeTestPayload.replay(
          eventId: 'event-1',
          sequence: 10,
        );
        transport.reconnect();
        transport.emit(
          'chat.message.updated',
          ChatRealtimeTestPayload.message(
            eventId: 'older-event',
            sequence: 9,
            version: 2,
            text: 'Stara wersja',
          ),
        );
        await ChatRealtimeTestPayload.flush();

        expect(events, hasLength(1));
        expect(events.single.eventId, 'event-1');
        expect(events.single.isReplay, isFalse);
        await subscription.cancel();
        await service.dispose();
      },
    );

    test(
      'przekazuje resyncRequired z replayu dokładnie jako jeden event',
      () async {
        final transport = ChatRealtimeTestTransport()
          ..replayResult = const <String, dynamic>{'resyncRequired': true};
        final service = WorkspaceChatRealtimeService(client: transport);
        final events = <ChatConversationRealtimeEvent>[];
        final subscription = service.conversationEvents.listen(events.add);

        await service.start('conversation-1');
        transport.reconnect();
        await ChatRealtimeTestPayload.flush();

        expect(events, hasLength(1));
        expect(
          events.single.kind,
          ChatConversationRealtimeEventKind.resyncRequired,
        );
        expect(events.single.conversationId, 'conversation-1');
        await subscription.cancel();
        await service.dispose();
      },
    );
  });
}
