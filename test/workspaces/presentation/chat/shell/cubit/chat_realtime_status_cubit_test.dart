import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/chat_realtime_test_support.dart';

void main() {
  test('obserwuje reconnect i offline bez uruchamiania transportu', () async {
    final transport = ChatRealtimeTestTransport();
    final realtime = WorkspaceChatRealtimeService(client: transport);
    final cubit = ChatRealtimeStatusCubit(realtime.connectionStates);
    addTearDown(cubit.close);
    addTearDown(realtime.dispose);

    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, WorkspaceSignalRConnectionState.disconnected);

    transport.emitConnectionState(
      WorkspaceSignalRConnectionState.reconnecting,
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, WorkspaceSignalRConnectionState.reconnecting);

    transport.emitConnectionState(WorkspaceSignalRConnectionState.connected);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, WorkspaceSignalRConnectionState.connected);
  });
}
