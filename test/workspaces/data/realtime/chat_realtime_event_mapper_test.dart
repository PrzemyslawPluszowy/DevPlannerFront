import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatRealtimeEventMapper wersja kontraktu', () {
    test('event z nowszą wersją kontraktu trafia do resyncu', () {
      final mapper = ChatRealtimeEventMapper();
      final normalized = mapper.normalizeLiveEnvelope(<String, dynamic>{
        'EventId': 'event-1',
        'Sequence': 7,
        'ContractVersion': workspaceChatRealtimeContractVersion + 1,
        'PayloadJson':
            '{"conversationId":"conversation-1","messageId":"message-1"}',
      });

      final event = mapper.map(
        method: 'chat.message.deleted',
        payload: normalized!,
        isReplay: false,
      );

      expect(
        event!.kind,
        ChatConversationRealtimeEventKind.unsupported,
        reason: 'nieznana wersja kontraktu nie może być zastosowana po staremu',
      );
      expect(event.sequence, 7, reason: 'deduplikacja musi nadal działać');
    });

    test('event bez wersji kontraktu jest zgodny wstecznie', () {
      final mapper = ChatRealtimeEventMapper();
      final normalized = mapper.normalizeLiveEnvelope(<String, dynamic>{
        'EventId': 'event-2',
        'Sequence': 8,
        'PayloadJson':
            '{"conversationId":"conversation-1","messageId":"message-1"}',
      });

      final event = mapper.map(
        method: 'chat.message.deleted',
        payload: normalized!,
        isReplay: false,
      );

      expect(event!.kind, ChatConversationRealtimeEventKind.messageDeleted);
    });
  });

  group('ChatRealtimeEventMapper PascalCase backend envelope', () {
    test(
      'normalizuje pełny MessageCreated PayloadJson z ChatRealtimeEventFactory',
      () {
        final mapper = ChatRealtimeEventMapper();
        final normalized = mapper.normalizeLiveEnvelope(
          <String, dynamic>{
            'EventId': 'event-created-1',
            'Sequence': 41,
            'ConversationId': 'conversation-1',
            'PayloadJson': _ChatRealtimeBackendPayload.fullMessageJson,
          },
        );
        final event = mapper.map(
          method: 'chat.message.created',
          payload: normalized!,
          isReplay: false,
        );
        final updated = mapper.map(
          method: 'chat.message.updated',
          payload: normalized,
          isReplay: false,
        );

        expect(event, isNotNull);
        expect(event!.eventId, 'event-created-1');
        expect(event.sequence, 41);
        expect(event.conversationId, 'conversation-1');
        expect(event.kind, ChatConversationRealtimeEventKind.messageCreated);
        expect(event.message?.id, 'message-1');
        expect(event.message?.authorUserId, 'user-1');
        expect(event.message?.clientMessageId, 'client-1');
        expect(event.message?.deltaJson, '{"ops":[{"insert":"Cześć"}]}');
        expect(event.message?.replyToMessageId, 'message-parent-1');
        expect(event.message?.threadRootMessageId, 'thread-1');
        expect(event.message?.isEdited, isTrue);
        expect(event.message?.deletedAtUtc, DateTime.utc(2026, 9, 13, 10, 1));
        expect(updated?.kind, ChatConversationRealtimeEventKind.messageUpdated);
        expect(updated?.message?.version, 6);
      },
    );

    test('mapuje PascalCase MessageDeleted z replayu i zachowuje cursor', () {
      final mapper = ChatRealtimeEventMapper();
      final page = mapper.decodeReplay(<String, dynamic>{
        'Items': <Object?>[
          <String, dynamic>{
            'EventId': 'event-deleted-1',
            'Sequence': 42,
            'ConversationId': 'conversation-1',
            'EventType': 'chat.message.deleted',
            'PayloadJson': _ChatRealtimeBackendPayload.deletedMessageJson,
          },
        ],
        'NextCursor': 'cursor-42',
        'ResyncRequired': false,
      });
      final replay = page.events.single;
      final event = mapper.map(
        method: replay.method,
        payload: replay.payload,
        isReplay: true,
      );

      expect(page.nextCursor, 'cursor-42');
      expect(page.resyncRequired, isFalse);
      expect(event, isNotNull);
      expect(event!.eventId, 'event-deleted-1');
      expect(event.sequence, 42);
      expect(event.conversationId, 'conversation-1');
      expect(event.kind, ChatConversationRealtimeEventKind.messageDeleted);
      expect(event.messageId, 'message-1');
      expect(event.messageVersion, 7);
      expect(event.isReplay, isTrue);
    });

    test(
      'fail-closed dla brakującego Id albo błędnego Version w PayloadJson',
      () {
        final mapper = ChatRealtimeEventMapper();
        final reducer = ChatConversationRealtimeReducer();
        final malformedEvents = <ChatConversationRealtimeEvent>[];
        for (final payloadJson in <String>[
          _ChatRealtimeBackendPayload.missingIdMessageJson,
          _ChatRealtimeBackendPayload.wrongVersionMessageJson,
        ]) {
          final normalized = mapper.normalizeLiveEnvelope(<String, dynamic>{
            'EventId': 'malformed-${malformedEvents.length}',
            'Sequence': 50 + malformedEvents.length,
            'ConversationId': 'conversation-1',
            'PayloadJson': payloadJson,
          });
          final event = mapper.map(
            method: 'chat.message.created',
            payload: normalized!,
            isReplay: false,
          );

          expect(event, isNotNull);
          expect(event!.message, isNull);
          malformedEvents.add(event);
        }

        for (final event in malformedEvents) {
          final reduction = reducer.apply(
            messages: const [],
            event: event,
          );
          expect(
            reduction.decision,
            ChatConversationRealtimeDecision.resyncRequired,
          );
        }
      },
    );

    test('decodeReplay pomija wadliwe mapy i listy bez rzucania wyjątku', () {
      final mapper = ChatRealtimeEventMapper();

      expect(
        () => mapper.decodeReplay(<String, dynamic>{
          'Items': <Object?>[
            'nie-mapa',
            <String, dynamic>{'EventType': 5, 'PayloadJson': <Object?>[]},
            <String, dynamic>{
              'EventType': 'chat.message.created',
              'PayloadJson': <String, dynamic>{'Id': 'nie-JSON'},
            },
          ],
          'NextCursor': 17,
          'ResyncRequired': 'true',
        }),
        returnsNormally,
      );
      final page = mapper.decodeReplay(<String, dynamic>{
        'Items': <Object?>[
          'nie-mapa',
          <String, dynamic>{'EventType': 5, 'PayloadJson': <Object?>[]},
        ],
      });

      expect(page.events, isEmpty);
      expect(page.nextCursor, isNull);
      expect(page.resyncRequired, isFalse);
    });
  });
}

/// Dokładne PayloadJson C# używane przez kontrakt Chat realtime backendu.
abstract final class _ChatRealtimeBackendPayload {
  /// Pełny `ChatMessageResponse` serializowany przez `ChatRealtimeEventFactory`.
  static const String fullMessageJson =
      '{"Id":"message-1","ConversationId":"conversation-1","AuthorUserId":"user-1","ClientMessageId":"client-1","Text":"Cześć","DeltaJson":"{\\"ops\\":[{\\"insert\\":\\"Cześć\\"}]}","ReplyToMessageId":"message-parent-1","PayloadHash":"HASH-1","Version":6,"CreatedAtUtc":"2026-09-13T10:00:00Z","IsDeleted":false,"Links":[],"Reactions":[],"ThreadRootMessageId":"thread-1","IsEdited":true,"DeletedAtUtc":"2026-09-13T10:01:00Z"}';

  /// Payload usunięcia, odczytywany po nazwie `MessageId` przez backendowy test.
  static const String deletedMessageJson =
      '{"MessageId":"message-1","Version":7}';

  /// Wersja create bez wymaganego Id, odrzucona przez wygenerowany fromJson.
  static const String missingIdMessageJson =
      '{"ConversationId":"conversation-1","AuthorUserId":"user-1","ClientMessageId":"client-1","Text":"Cześć","PayloadHash":"HASH-1","Version":6,"CreatedAtUtc":"2026-09-13T10:00:00Z","IsDeleted":false}';

  /// Wersja create z liczbą `Version` zastąpioną tekstem.
  static const String wrongVersionMessageJson =
      '{"Id":"message-1","ConversationId":"conversation-1","AuthorUserId":"user-1","ClientMessageId":"client-1","Text":"Cześć","PayloadHash":"HASH-1","Version":"sześć","CreatedAtUtc":"2026-09-13T10:00:00Z","IsDeleted":false}';
}
