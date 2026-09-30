import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../support/chat_realtime_test_support.dart';

void main() {
  test('foreign inbox never advances conversation cursor or deduplicates its messages', () async {
    final transport = ChatRealtimeTestTransport();
    final service = WorkspaceChatRealtimeService(client: transport);
    final events = <ChatConversationRealtimeEvent>[];
    final subscription = service.conversationEvents.listen(events.add);
    await service.start('conversation-1');
    await ChatRealtimeTestPayload.flush();
    transport.emit(
      'chat.message.created',
      ChatRealtimeTestPayload.message(eventId: 'a10', sequence: 10),
    );
    transport.emit('chat.inbox.changed', {'eventId': 'b20', 'sequence': 20});
    transport.emit(
      'chat.message.created',
      ChatRealtimeTestPayload.message(eventId: 'a11', sequence: 11),
    );
    await ChatRealtimeTestPayload.flush();
    expect(events.map((event) => event.eventId), ['a10', 'a11']);
    transport.reconnect();
    await ChatRealtimeTestPayload.flush();
    expect(
      transport.invocations
          .where((entry) => entry.$1 == 'GetConversationEvents')
          .single
          .$2![1],
      'MTE',
    );
    await subscription.cancel();
    await service.dispose();
  });

  test(
    'live event waits until older missed replay event has been delivered',
    () async {
      final transport = _DelayedReplayTransport();
      final service = WorkspaceChatRealtimeService(client: transport);
      final events = <ChatConversationRealtimeEvent>[];
      final subscription = service.conversationEvents.listen(events.add);
      await service.start('conversation-1');
      await ChatRealtimeTestPayload.flush();
      transport.delegate.emit(
        'chat.message.created',
        ChatRealtimeTestPayload.message(eventId: 'a10', sequence: 10),
      );
      transport.delegate.reconnect();
      await ChatRealtimeTestPayload.flush();
      transport.delegate.emit(
        'chat.message.created',
        ChatRealtimeTestPayload.message(eventId: 'a12', sequence: 12),
      );
      await ChatRealtimeTestPayload.flush();
      expect(events.map((event) => event.eventId), ['a10']);
      transport.replay.complete(
        ChatRealtimeTestPayload.replay(eventId: 'a11', sequence: 11),
      );
      await ChatRealtimeTestPayload.flush();
      expect(events.map((event) => event.eventId), ['a10', 'a11', 'a12']);
      await subscription.cancel();
      await service.dispose();
    },
  );
  test('late replay response from a previous lifecycle cannot enter a restarted conversation', () async {
    final transport = _DelayedReplayTransport();
    final service = WorkspaceChatRealtimeService(client: transport);
    final events = <ChatConversationRealtimeEvent>[];
    final subscription = service.conversationEvents.listen(events.add);
    await service.start('conversation-1');
    await ChatRealtimeTestPayload.flush();
    transport.delegate.reconnect();
    await ChatRealtimeTestPayload.flush();
    await service.stop();
    transport.delegate.emitConnectionState(
      WorkspaceSignalRConnectionState.disconnected,
    );
    await service.start('conversation-1');
    await ChatRealtimeTestPayload.flush();
    transport.replay.complete(
      ChatRealtimeTestPayload.replay(eventId: 'old-lifecycle', sequence: 11),
    );
    await ChatRealtimeTestPayload.flush();
    expect(events, isEmpty);
    transport.delegate.emit(
      'chat.message.created',
      ChatRealtimeTestPayload.message(eventId: 'new-lifecycle', sequence: 12),
    );
    await ChatRealtimeTestPayload.flush();
    expect(events.map((event) => event.eventId), ['new-lifecycle']);
    await subscription.cancel();
    await service.dispose();
  });
}

final class _DelayedReplayTransport implements WorkspaceSignalRTransport {
  final delegate = ChatRealtimeTestTransport();
  final replay = Completer<Object?>();
  @override
  Stream<WorkspaceSignalRConnectionState> get states => delegate.states;
  @override
  Future<void> connect() => delegate.connect();
  @override
  Future<void> disconnect() => delegate.disconnect();
  @override
  void dispose() => delegate.dispose();
  @override
  void on(String name, MethodInvocationFunc handler) =>
      delegate.on(name, handler);
  @override
  Future<Object?> invoke(String name, {List<Object>? args}) =>
      name == 'GetConversationEvents'
      ? replay.future
      : delegate.invoke(name, args: args);
}
