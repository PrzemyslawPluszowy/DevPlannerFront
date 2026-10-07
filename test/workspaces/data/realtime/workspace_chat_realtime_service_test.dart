import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

final class _FakeChatTransport implements WorkspaceSignalRTransport {
  final BehaviorSubject<WorkspaceSignalRConnectionState> _states =
      BehaviorSubject.seeded(WorkspaceSignalRConnectionState.disconnected);
  final Map<String, MethodInvocationFunc> handlers = {};
  final List<(String, List<Object>?)> invocations = [];
  final Map<String, Object?> replayResultsByCursor = <String, Object?>{};
  Object? replayResult;
  Completer<Object?>? replayCompletion;
  Completer<Object?>? heartbeatCompletion;

  @override
  Stream<WorkspaceSignalRConnectionState> get states => _states.stream;

  @override
  void on(String methodName, MethodInvocationFunc handler) {
    handlers[methodName] = handler;
  }

  @override
  Future<void> connect() async {
    _states.add(WorkspaceSignalRConnectionState.connected);
  }

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    invocations.add((methodName, args));
    if (methodName == 'HeartbeatPresence' && heartbeatCompletion != null) {
      return heartbeatCompletion!.future;
    }
    if (methodName == 'GetConversationEvents') {
      if (replayCompletion case final pending?) return pending.future;
      final cursor = args != null && args.length > 1 ? args[1] as String : '';
      return replayResultsByCursor[cursor] ?? replayResult;
    }
    return null;
  }

  @override
  Future<void> disconnect() async {
    _states.add(WorkspaceSignalRConnectionState.disconnected);
  }

  @override
  void dispose() {
    unawaited(_states.close());
  }

  void reconnect() {
    _states.add(WorkspaceSignalRConnectionState.reconnecting);
    _states.add(WorkspaceSignalRConnectionState.connected);
  }

  void emit(String method, Map<String, dynamic> payload) {
    handlers[method]?.call(<Object?>[payload]);
  }
}

void main() {
  test('duplicate connected does not strand a pending heartbeat', () async {
    final transport = _FakeChatTransport()
      ..heartbeatCompletion = Completer<Object?>();
    final service = WorkspaceChatRealtimeService(
      client: transport,
      presenceHeartbeatInterval: const Duration(milliseconds: 5),
    );
    await service.start('conversation-1');
    await Future<void>.delayed(Duration.zero);
    expect(
      transport.invocations.where((entry) => entry.$1 == 'HeartbeatPresence'),
      hasLength(1),
    );
    transport._states.add(WorkspaceSignalRConnectionState.connected);
    await Future<void>.delayed(Duration.zero);
    expect(
      transport.invocations.where(
        (entry) => entry.$1 == 'SubscribeConversation',
      ),
      hasLength(1),
    );
    transport.heartbeatCompletion!.complete(null);
    await Future<void>.delayed(const Duration(milliseconds: 25));
    expect(
      transport.invocations
          .where((entry) => entry.$1 == 'HeartbeatPresence')
          .length,
      greaterThan(1),
    );
    await service.dispose();
  });

  for (final disconnectedState in [
    WorkspaceSignalRConnectionState.disconnected,
    WorkspaceSignalRConnectionState.reconnecting,
  ]) {
    test(
      'presence becomes unknown on $disconnectedState until a fresh snapshot',
      () async {
        final transport = _FakeChatTransport();
        final service = WorkspaceChatRealtimeService(client: transport);
        final cubit = ChatConversationPresenceCubit(realtime: service);
        await service.start('conversation-1');
        await Future<void>.delayed(Duration.zero);
        transport.emit('chat.presence.changed', _presencePayload);
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.forUser('peer'), ChatPeerLivePresence.online);
        transport._states.add(disconnectedState);
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.forUser('peer'), ChatPeerLivePresence.unknown);
        transport.emit('chat.presence.changed', _presencePayload);
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.forUser('peer'), ChatPeerLivePresence.unknown);
        transport.reconnect();
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.forUser('peer'), ChatPeerLivePresence.unknown);
        transport.emit('chat.presence.changed', _presencePayload);
        await Future<void>.delayed(Duration.zero);
        expect(cubit.state.forUser('peer'), ChatPeerLivePresence.online);
        await cubit.close();
        await service.dispose();
      },
    );
  }

  test(
    'disconnect invalidates an outstanding replay before its reply arrives',
    () async {
      final transport = _FakeChatTransport();
      final service = WorkspaceChatRealtimeService(client: transport);
      final events = <ChatRealtimeEvent>[];
      final sub = service.events.listen(events.add);
      await service.start('conversation-1');
      await Future<void>.delayed(Duration.zero);
      transport.replayCompletion = Completer<Object?>();
      transport.reconnect();
      await Future<void>.delayed(Duration.zero);
      expect(
        transport.invocations.where(
          (entry) => entry.$1 == 'GetConversationEvents',
        ),
        hasLength(1),
      );
      await transport.disconnect();
      await Future<void>.delayed(Duration.zero);
      transport.replayCompletion!.complete(<String, dynamic>{
        'events': [
          <String, dynamic>{
            'method': 'chat.message.created',
            'payload': <String, dynamic>{'eventId': 'stale', 'sequence': 7},
          },
        ],
      });
      await Future<void>.delayed(Duration.zero);
      expect(events, isEmpty);
      await sub.cancel();
      await service.dispose();
    },
  );

  test('subskrybuje rozmowę, obsługuje akcje i odsubskrybowuje ją', () async {
    final transport = _FakeChatTransport();
    final service = WorkspaceChatRealtimeService(client: transport);

    await service.start('conversation-1');
    await service.setTyping(true);
    await service.heartbeatPresence();
    await service.stop();

    expect(
      transport.invocations.map((entry) => entry.$1),
      containsAllInOrder(<String>[
        'SubscribeConversation',
        'SetTyping',
        'HeartbeatPresence',
        'UnsubscribeConversation',
      ]),
    );
    await service.dispose();
  });

  test('odrzuca duplikaty eventId i starsze sekwencje', () async {
    final transport = _FakeChatTransport();
    final service = WorkspaceChatRealtimeService(client: transport);
    final events = <ChatRealtimeEvent>[];
    final subscription = service.events.listen(events.add);

    await service.start('conversation-1');
    final payload = <String, dynamic>{
      'eventId': 'event-1',
      'realtimeSequence': 2,
      'message': 'hello',
    };
    transport.emit('chat.message.created', payload);
    transport.emit('chat.message.created', payload);
    transport.emit('chat.message.created', <String, dynamic>{
      'eventId': 'event-2',
      'realtimeSequence': 1,
    });
    await Future<void>.delayed(Duration.zero);

    expect(events, hasLength(1));
    expect(events.single.payload['message'], 'hello');
    await subscription.cancel();
    await service.dispose();
  });

  test('po reconnect ponawia subskrypcję i replay z kursorem', () async {
    final transport = _FakeChatTransport()
      ..replayResultsByCursor[''] = <String, dynamic>{
        'events': <Object?>[
          <String, dynamic>{
            'method': 'chat.message.created',
            'payload': <String, dynamic>{
              'eventId': 'replayed-1',
              'sequence': 4,
            },
          },
        ],
        'nextCursor': 'cursor-4',
      }
      ..replayResultsByCursor['cursor-4'] = const <String, dynamic>{
        'events': <Object?>[],
      };
    final service = WorkspaceChatRealtimeService(client: transport);
    final events = <ChatRealtimeEvent>[];
    final subscription = service.events.listen(events.add);

    await service.start('conversation-1');
    transport.reconnect();
    await Future<void>.delayed(Duration.zero);

    expect(events.single.isReplay, isTrue);
    final replays = transport.invocations
        .where((entry) => entry.$1 == 'GetConversationEvents')
        .toList();
    expect(
      replays.map((entry) => entry.$2?[1]),
      <Object?>['', 'cursor-4'],
    );
    await subscription.cancel();
    await service.dispose();
  });

  test('replay rozumie backendowy envelope items z payloadJson', () async {
    final transport = _FakeChatTransport()
      ..replayResult = <String, dynamic>{
        'items': <Object?>[
          <String, dynamic>{
            'eventId': 'backend-event-1',
            'sequence': 8,
            'eventType': 'chat.message.created',
            'payloadJson': '{"messageId":"message-1"}',
          },
        ],
        'nextCursor': 'cursor-8',
      };
    final service = WorkspaceChatRealtimeService(client: transport);
    final events = <ChatRealtimeEvent>[];
    final subscription = service.events.listen(events.add);

    await service.start('conversation-1');
    transport.reconnect();
    await Future<void>.delayed(Duration.zero);

    expect(events.single.payload['messageId'], 'message-1');
    expect(events.single.sequence, 8);
    await subscription.cancel();
    await service.dispose();
  });
}

const _presencePayload = <String, dynamic>{
  'conversationId': 'conversation-1',
  'changedAtUtc': '2026-10-07T12:00:00Z',
  'users': [
    <String, dynamic>{'userId': 'peer', 'connectionCount': 1, 'isOnline': true},
  ],
};
