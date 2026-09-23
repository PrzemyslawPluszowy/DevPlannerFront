import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatConversationRealtimeReducer', () {
    test('odświeża autorytatywny status dla eventu dostarczenia/odczytu', () {
      final reducer = ChatConversationRealtimeReducer();
      final messages = <ChatMessage>[
        _ChatRealtimeFixture.message(id: 'message-1'),
      ];
      final result = reducer.apply(
        messages: messages,
        event: _ChatRealtimeFixture.event(
          eventId: 'read-1',
          sequence: 1,
          kind: ChatConversationRealtimeEventKind.messageDeliveryChanged,
          messageId: 'message-1',
        ),
      );

      expect(
        result.decision,
        ChatConversationRealtimeDecision.refreshMessageDelivery,
      );
      expect(result.messages, same(messages));
    });

    test('redukuje kolejno utworzenie, zmianę i usunięcie wiadomości', () {
      final reducer = ChatConversationRealtimeReducer();
      final created = reducer.apply(
        messages: const <ChatMessage>[],
        event: _ChatRealtimeFixture.event(
          eventId: 'created-1',
          sequence: 10,
          kind: ChatConversationRealtimeEventKind.messageCreated,
          message: _ChatRealtimeFixture.message(
            id: 'message-1',
            text: 'Wersja 1',
          ),
        ),
      );
      final updated = reducer.apply(
        messages: created.messages,
        event: _ChatRealtimeFixture.event(
          eventId: 'updated-1',
          sequence: 11,
          kind: ChatConversationRealtimeEventKind.messageUpdated,
          message: _ChatRealtimeFixture.message(
            id: 'message-1',
            text: 'Wersja 2',
            version: 2,
            isEdited: true,
          ),
        ),
      );
      final deleted = reducer.apply(
        messages: updated.messages,
        event: _ChatRealtimeFixture.event(
          eventId: 'deleted-1',
          sequence: 12,
          kind: ChatConversationRealtimeEventKind.messageDeleted,
          messageId: 'message-1',
          messageVersion: 3,
        ),
      );

      expect(created.decision, ChatConversationRealtimeDecision.applied);
      expect(updated.messages.single.text, 'Wersja 2');
      expect(updated.messages.single.version, 2);
      expect(deleted.decision, ChatConversationRealtimeDecision.applied);
      expect(deleted.messages.single.isDeleted, isTrue);
      expect(deleted.messages.single.version, 3);
    });

    test('ignoruje identyczny eventId z live i replayu', () {
      final reducer = ChatConversationRealtimeReducer();
      final event = _ChatRealtimeFixture.event(
        eventId: 'message-event-1',
        sequence: 10,
        kind: ChatConversationRealtimeEventKind.messageCreated,
        message: _ChatRealtimeFixture.message(id: 'message-1'),
      );
      final live = reducer.apply(messages: const <ChatMessage>[], event: event);
      final replay = reducer.apply(
        messages: live.messages,
        event: _ChatRealtimeFixture.event(
          eventId: 'message-event-1',
          sequence: 10,
          kind: ChatConversationRealtimeEventKind.messageCreated,
          isReplay: true,
          message: _ChatRealtimeFixture.message(id: 'message-1'),
        ),
      );

      expect(live.decision, ChatConversationRealtimeDecision.applied);
      expect(replay.decision, ChatConversationRealtimeDecision.ignored);
      expect(replay.messages, same(live.messages));
    });

    test('odrzuca starszą sekwencję mimo innego eventId', () {
      final reducer = ChatConversationRealtimeReducer();
      final latest = reducer.apply(
        messages: const <ChatMessage>[],
        event: _ChatRealtimeFixture.event(
          eventId: 'newer',
          sequence: 20,
          kind: ChatConversationRealtimeEventKind.messageCreated,
          message: _ChatRealtimeFixture.message(
            id: 'message-1',
            text: 'Nowsza',
          ),
        ),
      );
      final stale = reducer.apply(
        messages: latest.messages,
        event: _ChatRealtimeFixture.event(
          eventId: 'older',
          sequence: 19,
          kind: ChatConversationRealtimeEventKind.messageUpdated,
          message: _ChatRealtimeFixture.message(
            id: 'message-1',
            text: 'Starsza',
            version: 2,
          ),
        ),
      );

      expect(stale.decision, ChatConversationRealtimeDecision.ignored);
      expect(stale.messages.single.text, 'Nowsza');
    });

    test(
      'starszy event nie zapamiętuje eventId późniejszego poprawnego eventu',
      () {
        final reducer = ChatConversationRealtimeReducer();
        final latest = reducer.apply(
          messages: const <ChatMessage>[],
          event: _ChatRealtimeFixture.event(
            eventId: 'latest',
            sequence: 20,
            kind: ChatConversationRealtimeEventKind.messageCreated,
            message: _ChatRealtimeFixture.message(id: 'message-1'),
          ),
        );
        final stale = reducer.apply(
          messages: latest.messages,
          event: _ChatRealtimeFixture.event(
            eventId: 'reordered-event',
            sequence: 19,
            kind: ChatConversationRealtimeEventKind.messageCreated,
            message: _ChatRealtimeFixture.message(
              id: 'message-2',
              clientMessageId: 'client-2',
            ),
          ),
        );
        final later = reducer.apply(
          messages: stale.messages,
          event: _ChatRealtimeFixture.event(
            eventId: 'reordered-event',
            sequence: 21,
            kind: ChatConversationRealtimeEventKind.messageCreated,
            message: _ChatRealtimeFixture.message(
              id: 'message-2',
              clientMessageId: 'client-2',
            ),
          ),
        );

        expect(stale.decision, ChatConversationRealtimeDecision.ignored);
        expect(later.decision, ChatConversationRealtimeDecision.applied);
        expect(later.messages.map((message) => message.id), <String>[
          'message-1',
          'message-2',
        ]);
      },
    );

    test('żąda pojedynczego snapshotu tylko dla eventu resync', () {
      final reducer = ChatConversationRealtimeReducer();
      final messages = <ChatMessage>[
        _ChatRealtimeFixture.message(id: 'message-1'),
      ];
      final reduction = reducer.apply(
        messages: messages,
        event: _ChatRealtimeFixture.event(
          eventId: 'resync-1',
          sequence: 30,
          kind: ChatConversationRealtimeEventKind.resyncRequired,
        ),
      );
      final duplicate = reducer.apply(
        messages: reduction.messages,
        event: _ChatRealtimeFixture.event(
          eventId: 'resync-1',
          sequence: 30,
          kind: ChatConversationRealtimeEventKind.resyncRequired,
        ),
      );

      expect(
        reduction.decision,
        ChatConversationRealtimeDecision.resyncRequired,
      );
      expect(reduction.messages, same(messages));
      expect(duplicate.decision, ChatConversationRealtimeDecision.ignored);
    });

    test('scala ACK o tym samym clientMessageId z wpisem optymistycznym', () {
      final reducer = ChatConversationRealtimeReducer();
      final optimistic = _ChatRealtimeFixture.message(
        id: 'local:client-1',
        deliveryState: ChatMessageDeliveryState.sending,
      );
      final acknowledgement = reducer.apply(
        messages: <ChatMessage>[optimistic],
        event: _ChatRealtimeFixture.event(
          eventId: 'ack-1',
          sequence: 40,
          kind: ChatConversationRealtimeEventKind.messageCreated,
          message: _ChatRealtimeFixture.message(
            id: 'server-message-1',
          ),
        ),
      );

      expect(acknowledgement.messages, hasLength(1));
      expect(acknowledgement.messages.single.id, 'server-message-1');
      expect(
        acknowledgement.messages.single.deliveryState,
        ChatMessageDeliveryState.sent,
      );
    });
  });
}

/// Dostarcza pełne modele domenowe wymagane przez rzeczywisty reducer.
abstract final class _ChatRealtimeFixture {
  /// Tworzy znormalizowane zdarzenie, bez modelowania surowego SignalR.
  static ChatConversationRealtimeEvent event({
    required String eventId,
    required int sequence,
    required ChatConversationRealtimeEventKind kind,
    ChatMessage? message,
    String? messageId,
    int? messageVersion,
    bool isReplay = false,
  }) => ChatConversationRealtimeEvent(
    eventId: eventId,
    sequence: sequence,
    conversationId: 'conversation-1',
    kind: kind,
    isReplay: isReplay,
    message: message,
    messageId: messageId,
    messageVersion: messageVersion,
  );

  /// Tworzy wiadomość historii lub lokalny wpis optymistyczny.
  static ChatMessage message({
    required String id,
    String clientMessageId = 'client-1',
    String text = 'Treść',
    int version = 1,
    bool isEdited = false,
    ChatMessageDeliveryState deliveryState = ChatMessageDeliveryState.sent,
  }) => ChatMessage(
    id: id,
    conversationId: 'conversation-1',
    authorUserId: 'user-1',
    clientMessageId: clientMessageId,
    text: text,
    payloadHash: 'hash-1',
    version: version,
    createdAtUtc: DateTime.utc(2026),
    isDeleted: false,
    isEdited: isEdited,
    deliveryState: deliveryState,
  );
}
