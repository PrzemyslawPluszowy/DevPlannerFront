import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_typing_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Klient realtime z kontrolowanym strumieniem zdarzeń.
final class _TypingRealtimeFake implements ChatConversationRealtimeClient {
  final List<ChatConversationRealtimeEvent> emitted =
      <ChatConversationRealtimeEvent>[];

  @override
  Stream<ChatConversationRealtimeEvent> get conversationEvents =>
      Stream<ChatConversationRealtimeEvent>.fromIterable(emitted);

  @override
  Stream<ChatConversationRealtimeError> get conversationErrors =>
      const Stream<ChatConversationRealtimeError>.empty();

  @override
  Stream<ChatConversationPresenceSnapshot?> get presenceSnapshots =>
      const Stream<ChatConversationPresenceSnapshot?>.empty();

  @override
  Stream<ChatUserStatusChanged> get userStatusChanges =>
      const Stream<ChatUserStatusChanged>.empty();

  @override
  Future<void> start(String conversationId) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> setTyping(bool isTyping) async {}

  @override
  Future<void> heartbeatPresence() async {}
}

ChatConversationRealtimeEvent typingEvent({
  required String userId,
  required bool isTyping,
  DateTime? expiresAtUtc,
  String? conversationId,
}) => ChatConversationRealtimeEvent(
  eventId: 'event-$userId-${isTyping ? 'on' : 'off'}',
  sequence: null,
  conversationId: conversationId ?? 'conversation-1',
  kind: ChatConversationRealtimeEventKind.typingChanged,
  isReplay: false,
  typingUserId: userId,
  isTyping: isTyping,
  typingExpiresAtUtc: expiresAtUtc,
);

void main() {
  group('ChatRealtimeEventMapper — pisanie', () {
    test('mapuje chat.typing.changed z TTL serwera', () {
      final mapper = ChatRealtimeEventMapper();
      final normalized = mapper.normalizeLiveEnvelope(<String, dynamic>{
        'eventId': 'event-1',
        'conversationId': 'conversation-1',
        'payload': <String, dynamic>{
          'conversationId': 'conversation-1',
          'userId': 'peer-1',
          'isTyping': true,
          'expiresAtUtc': '2026-09-21T12:00:08Z',
        },
      });

      final event = mapper.map(
        method: 'chat.typing.changed',
        payload: normalized!,
        isReplay: false,
      );

      expect(event!.kind, ChatConversationRealtimeEventKind.typingChanged);
      expect(event.typingUserId, 'peer-1');
      expect(event.isTyping, isTrue);
      expect(event.typingExpiresAtUtc, DateTime.utc(2026, 9, 21, 12, 0, 8));
    });

    test('brak wygaśnięcia jest dopuszczalny dla zdarzenia stop', () {
      final mapper = ChatRealtimeEventMapper();
      final normalized = mapper.normalizeLiveEnvelope(<String, dynamic>{
        'conversationId': 'conversation-1',
        'payload': <String, dynamic>{
          'conversationId': 'conversation-1',
          'userId': 'peer-1',
          'isTyping': false,
        },
      });

      final event = mapper.map(
        method: 'chat.typing.changed',
        payload: normalized!,
        isReplay: false,
      );

      expect(event!.isTyping, isFalse);
      expect(event.typingExpiresAtUtc, isNull);
    });
  });

  group('ChatConversationRealtimeReducer — pisanie', () {
    test('pisanie nie zmienia historii i nie wymaga resyncu', () {
      final reducer = ChatConversationRealtimeReducer();
      final messages = <ChatMessage>[
        ChatMessage(
          id: 'm1',
          conversationId: 'conversation-1',
          authorUserId: 'peer',
          clientMessageId: 'client-m1',
          text: 'Treść',
          payloadHash: 'hash',
          version: 1,
          createdAtUtc: DateTime.utc(2026, 9, 21),
          isDeleted: false,
          deliveryState: ChatMessageDeliveryState.sent,
        ),
      ];

      final reduction = reducer.apply(
        messages: messages,
        event: typingEvent(userId: 'peer', isTyping: true),
      );

      expect(reduction.decision, ChatConversationRealtimeDecision.ignored);
      expect(reduction.messages, same(messages));
    });
  });

  group('ChatTypingCubit', () {
    test('pokazuje cudze pisanie i wygasza je po TTL serwera', () async {
      final realtime = _TypingRealtimeFake()
        ..emitted.add(
          typingEvent(
            userId: 'peer-1',
            isTyping: true,
            expiresAtUtc: DateTime.now().add(const Duration(milliseconds: 40)),
          ),
        );
      final cubit = ChatTypingCubit(
        realtime: realtime,
        currentUserId: 'me',
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(cubit.state.isTyping, isTrue);
      expect(cubit.state.typingUserIds, contains('peer-1'));

      // Po TTL wskaźnik znika bez zdarzenia „stop”.
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(cubit.state.isTyping, isFalse);
      await cubit.close();
    });

    test('zdarzenie stop usuwa wpis natychmiast', () async {
      final realtime = _TypingRealtimeFake()
        ..emitted.addAll(<ChatConversationRealtimeEvent>[
          typingEvent(
            userId: 'peer-1',
            isTyping: true,
            expiresAtUtc: DateTime.now().add(const Duration(seconds: 30)),
          ),
          typingEvent(userId: 'peer-1', isTyping: false),
        ]);
      final cubit = ChatTypingCubit(realtime: realtime, currentUserId: 'me');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(cubit.state.isTyping, isFalse);
      await cubit.close();
    });

    test('własne pisanie nie jest pokazywane', () async {
      final realtime = _TypingRealtimeFake()
        ..emitted.add(
          typingEvent(
            userId: 'me',
            isTyping: true,
            expiresAtUtc: DateTime.now().add(const Duration(seconds: 30)),
          ),
        );
      final cubit = ChatTypingCubit(realtime: realtime, currentUserId: 'me');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(cubit.state.isTyping, isFalse);
      await cubit.close();
    });

    test('brak klienta realtime nie tworzy stanu pisania', () async {
      final cubit = ChatTypingCubit(realtime: null, currentUserId: 'me');

      expect(cubit.state.isTyping, isFalse);
      await cubit.close();
    });
  });
}
