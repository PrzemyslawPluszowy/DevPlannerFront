import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Prezentacyjny status transportu realtime dla jednego widoku inboxa.
///
/// Nie uruchamia ani nie zatrzymuje huba: lifecycle połączenia pozostaje w
/// `NotificationsCubit`. Ten mały Cubit tylko tłumaczy istniejący stream na
/// stan bannera UI i dlatego nie dubluje logiki domenowej ani sieciowej.
final class NotificationsRealtimeStatusCubit
    extends Cubit<WorkspaceSignalRConnectionState> {
  NotificationsRealtimeStatusCubit(
    WorkspaceNotificationsRealtimeService realtime,
  ) : super(WorkspaceSignalRConnectionState.connecting) {
    _subscription = realtime.connectionStates.listen(emit);
  }

  late final StreamSubscription<WorkspaceSignalRConnectionState> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
