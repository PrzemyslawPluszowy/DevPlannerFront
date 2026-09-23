import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Prezentacyjny stan transportu realtime dla jednej otwartej rozmowy Chat.
///
/// Nie inicjuje połączenia ani nie zna rozmowy. Właścicielem połączenia
/// pozostaje `ChatConversationCubit`; ten mały Cubit jedynie obserwuje jego
/// istniejący strumień, aby panel mógł komunikować reconnect/offline bez
/// mieszania tego stanu z historią wiadomości.
final class ChatRealtimeStatusCubit
    extends Cubit<WorkspaceSignalRConnectionState> {
  ChatRealtimeStatusCubit(
    Stream<WorkspaceSignalRConnectionState> connectionStates,
  ) : super(WorkspaceSignalRConnectionState.connecting) {
    _subscription = connectionStates.listen(_handleConnectionState);
  }

  late final StreamSubscription<WorkspaceSignalRConnectionState> _subscription;
  bool _hasObservedConnectionLifecycle = false;

  void _handleConnectionState(WorkspaceSignalRConnectionState state) {
    // Transporty odtwarzają stan początkowy `disconnected`. Nie jest to
    // awaria: żadna próba połączenia nie została jeszcze podjęta. Pozostaw
    // etykietę „łączenie” ustawioną przez ten Cubit do pierwszego zdarzenia
    // cyklu życia. Późniejszy disconnect zawsze jest widoczny.
    if (state == WorkspaceSignalRConnectionState.disconnected &&
        !_hasObservedConnectionLifecycle) {
      return;
    }
    _hasObservedConnectionLifecycle = true;
    emit(state);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
