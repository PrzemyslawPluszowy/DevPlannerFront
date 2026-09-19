import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

final class _Transport implements WorkspaceSignalRTransport {
  final BehaviorSubject<WorkspaceSignalRConnectionState> statesSubject =
      BehaviorSubject.seeded(
        WorkspaceSignalRConnectionState.disconnected,
      );
  final handlers = <String, MethodInvocationFunc>{};
  final invocations = <(String, List<Object>?)>[];
  Object? replay;

  @override
  Stream<WorkspaceSignalRConnectionState> get states => statesSubject.stream;
  @override
  void on(String methodName, MethodInvocationFunc handler) {
    handlers[methodName] = handler;
  }

  @override
  Future<void> connect() async {
    statesSubject.add(WorkspaceSignalRConnectionState.connected);
  }

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    invocations.add((methodName, args));
    if (methodName == 'GetBoardEvents') return replay;
    return null;
  }

  @override
  Future<void> disconnect() async {}
  @override
  void dispose() => unawaited(statesSubject.close());

  void reconnect() =>
      statesSubject.add(WorkspaceSignalRConnectionState.connected);
  void emit(String method, Map<String, dynamic> payload) =>
      handlers[method]?.call(<Object?>[payload]);
}

void main() {
  test('Whiteboard ponawia subskrypcję, replay i deduplikację', () async {
    final transport = _Transport()
      ..replay = <String, dynamic>{
        'items': <Object?>[
          <String, dynamic>{
            'eventId': 'stored-1',
            'sequence': 2,
            'eventType': 'whiteboard.operation.applied',
            'payloadJson': '{"operationId":"op-1"}',
          },
        ],
        'nextCursor': 'cursor-2',
      };
    final service = WorkspaceScopedRealtimeService(client: transport);
    final events = <WorkspaceScopedRealtimeEvent>[];
    final subscription = service.events.listen(events.add);

    await service.start(
      const WorkspaceScopedRealtimeTarget.resource(
        kind: WorkspaceScopedRealtimeKind.whiteboard,
        resourceId: 'board-1',
      ),
    );
    transport.emit('whiteboard.operation.applied', <String, dynamic>{
      'eventId': 'live-1',
      'sequence': 3,
    });
    transport.emit('whiteboard.operation.applied', <String, dynamic>{
      'eventId': 'live-1',
      'sequence': 3,
    });
    transport.reconnect();
    await Future<void>.delayed(Duration.zero);

    expect(events, hasLength(2));
    expect(
      events.any((event) => event.payload['operationId'] == 'op-1'),
      isTrue,
    );
    expect(
      transport.invocations.map((entry) => entry.$1),
      containsAllInOrder(<String>['SubscribeBoard', 'GetBoardEvents']),
    );
    await subscription.cancel();
    await service.dispose();
  });
}
