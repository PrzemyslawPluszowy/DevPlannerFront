import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';

/// Lokalny lifecycle realtime jednego projektu Tasks.
abstract interface class TaskProjectRealtime {
  Stream<TaskProjectRealtimeUpdate> get updates;
  Stream<WorkspaceSignalRConnectionState> get connectionStates;
  Stream<WorkspaceScopedRealtimeError> get errors;

  Future<void> start({
    required String workspaceId,
    required String projectId,
  });

  Future<void> dispose();
}
