import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_realtime_test_support.dart';

void main() {
  test(
    'session inbox channel invalidates after connect, events and reconnect',
    () async {
      final transport = ChatRealtimeTestTransport();
      final service = WorkspaceChatInboxRealtimeService(client: transport);
      var invalidations = 0;
      final subscription = service.invalidations.listen((_) => invalidations++);

      await service.start();
      await ChatRealtimeTestPayload.flush();
      transport.emit('chat.inbox.changed', <String, dynamic>{'eventId': 'e1'});
      transport.reconnect();
      await ChatRealtimeTestPayload.flush();

      expect(invalidations, 3);
      await service.dispose();
      await subscription.cancel();
      expect(transport.isDisposed, isTrue);
    },
  );

  group('WorkspaceChatRealtimeService typed conversation events', () {
    test('mapuje snapshot online z backendu i zachowuje liczbę sesji', () {
      final mapper = ChatRealtimeEventMapper();
      final snapshot = mapper.mapPresence(<String, dynamic>{
        'ConversationId': 'conversation-1',
        'ChangedAtUtc': '2026-09-22T12:00:00Z',
        'Users': <Object?>[
          <String, Object>{
            'UserId': 'peer-1',
            'ConnectionCount': 2,
            'IsOnline': true,
          },
        ],
      });

      expect(snapshot?.conversationId, 'conversation-1');
      expect(snapshot?.onlineUserIds, contains('peer-1'));
      expect(snapshot?.users.single.connectionCount, 2);
      expect(
        mapper.mapPresence(<String, dynamic>{'conversationId': 'bad'}),
        isNull,
      );
    });

    test('mapuje zmianę statusu i jawne wyczyszczenie z backendu', () {
      final mapper = ChatRealtimeEventMapper();
      final change = mapper.mapUserStatusChanged(<String, dynamic>{
        'UserId': 'peer-1',
        'Status': <String, dynamic>{
          'UserId': 'peer-1',
          'Emoji': '🌴',
          'Text': 'Na urlopie',
          'ExpiresAtUtc': '2026-09-24T12:00:00Z',
          'IsDnd': false,
          'UpdatedAtUtc': '2026-09-23T12:00:00Z',
        },
      });
      expect(change?.userId, 'peer-1');
      expect(change?.status?.text, 'Na urlopie');
      expect(change?.status?.emoji, '🌴');
      expect(
        mapper.mapUserStatusChanged(<String, dynamic>{
          'userId': 'peer-1',
          'status': null,
        })?.status,
        isNull,
      );
      expect(
        mapper.mapUserStatusChanged(<String, dynamic>{
          'userId': 'peer-1',
          'status': <String, dynamic>{'userId': 'another-user'},
        }),
        isNull,
      );
    });

    test('emituje live zmiany statusu i jego wyczyszczenie', () async {
      final transport = ChatRealtimeTestTransport();
      final service = WorkspaceChatRealtimeService(client: transport);
      final changes = <ChatUserStatusChanged>[];
      final subscription = service.userStatusChanges.listen(changes.add);

      await service.start('conversation-1');
      transport.emit('chat.user_status.changed', <String, dynamic>{
        'userId': 'peer-1',
        'status': <String, dynamic>{
          'userId': 'peer-1',
          'emoji': '🌴',
          'text': 'Na urlopie',
          'expiresAtUtc': null,
          'isDnd': true,
          'updatedAtUtc': '2026-09-23T12:00:00Z',
        },
      });
      transport.emit('chat.user_status.changed', <String, dynamic>{
        'userId': 'peer-1',
        'status': null,
      });
      await ChatRealtimeTestPayload.flush();

      expect(changes, hasLength(2));
      expect(changes.first.status?.isDnd, isTrue);
      expect(changes.last.status, isNull);

      await subscription.cancel();
      await service.dispose();
    });

    test(
      'emituje presence.changed i odnawia lease automatycznie po subskrypcji',
      () async {
        final transport = ChatRealtimeTestTransport();
        final service = WorkspaceChatRealtimeService(client: transport);
        final snapshots = <ChatConversationPresenceSnapshot?>[];
        final subscription = service.presenceSnapshots.listen(snapshots.add);

        await service.start('conversation-1');
        transport.emit('chat.presence.changed', <String, dynamic>{
          'conversationId': 'conversation-1',
          'changedAtUtc': '2026-09-22T12:00:00Z',
          'users': <Object?>[
            <String, Object>{
              'userId': 'peer-1',
              'connectionCount': 1,
              'isOnline': true,
            },
          ],
        });
        await ChatRealtimeTestPayload.flush();

        expect(
          snapshots.whereType<ChatConversationPresenceSnapshot>(),
          hasLength(1),
        );
        expect(
          snapshots
              .whereType<ChatConversationPresenceSnapshot>()
              .single
              .onlineUserIds,
          contains('peer-1'),
        );
        expect(
          transport.invocations.where(
            (entry) => entry.$1 == 'HeartbeatPresence',
          ),
          isNotEmpty,
        );

        await service.stop();
        expect(snapshots.last, isNull);
        await subscription.cancel();
        await service.dispose();
      },
    );

    test(
      'heartbeat utrzymuje lease i zatrzymuje się po odsubskrypcji',
      () async {
        final transport = ChatRealtimeTestTransport();
        final service = WorkspaceChatRealtimeService(
          client: transport,
          presenceHeartbeatInterval: const Duration(milliseconds: 5),
        );

        await service.start('conversation-1');
        await ChatRealtimeTestPayload.flush();
        await Future<void>.delayed(const Duration(milliseconds: 25));
        final beforeStop = transport.invocations
            .where((entry) => entry.$1 == 'HeartbeatPresence')
            .length;
        expect(beforeStop, greaterThanOrEqualTo(2));

        await service.stop();
        final afterStop = transport.invocations
            .where((entry) => entry.$1 == 'HeartbeatPresence')
            .length;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(
          transport.invocations
              .where((entry) => entry.$1 == 'HeartbeatPresence')
              .length,
          afterStop,
        );
        await service.dispose();
      },
    );

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
