import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

final class _TaskTransport implements WorkspaceSignalRTransport {
  final statesSubject = BehaviorSubject<WorkspaceSignalRConnectionState>.seeded(
    WorkspaceSignalRConnectionState.disconnected,
  );
  final handlers = <String, MethodInvocationFunc>{};
  final invocations = <(String, List<Object>?)>[];

  @override
  Stream<WorkspaceSignalRConnectionState> get states => statesSubject.stream;

  @override
  Future<void> connect() async =>
      statesSubject.add(WorkspaceSignalRConnectionState.connected);

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    invocations.add((methodName, args));
    return null;
  }

  @override
  void on(String methodName, MethodInvocationFunc handler) =>
      handlers[methodName] = handler;

  @override
  Future<void> disconnect() async {}

  @override
  void dispose() => unawaited(statesSubject.close());

  void emit(String method, Map<String, dynamic> payload) =>
      handlers[method]?.call(<Object?>[payload]);
}

void main() {
  test('mapuje event zadania i presence na typowane aktualizacje', () async {
    final transport = _TaskTransport();
    final adapter = TaskProjectRealtimeAdapter(
      WorkspaceScopedRealtimeService(client: transport),
    );
    final updates = <TaskProjectRealtimeUpdate>[];
    final subscription = adapter.updates.listen(updates.add);

    await adapter.start(workspaceId: 'workspace-1', projectId: 'project-1');
    transport.emit('task.status_changed', <String, dynamic>{
      'eventId': 'event-1',
      'workspaceId': 'workspace-1',
      'projectId': 'project-1',
      'taskId': 'task-1',
      'number': 42,
      'key': 'TASK-42',
      'version': 7,
      'actorUserId': 'actor-1',
      'correlationId': 'correlation-1',
      'occurredAtUtc': '2026-08-26T10:00:00Z',
      'status': 'Done',
      'previousStatus': 'InProgress',
    });
    transport.emit('project.presence.changed', <String, dynamic>{
      'workspaceId': 'workspace-1',
      'projectId': 'project-1',
      'updatedAtUtc': '2026-08-26T10:01:00Z',
      'users': <Object?>[
        <String, dynamic>{
          'userId': 'user-1',
          'connectionCount': 2,
        },
      ],
    });
    await Future<void>.delayed(Duration.zero);

    expect(transport.invocations.first.$1, 'SubscribeProject');
    final mutation = updates.first as TaskRealtimeMutation;
    expect(mutation.type, TaskRealtimeMutationType.statusChanged);
    expect(mutation.status, ProjectTaskStatus.done);
    expect(mutation.previousStatus, ProjectTaskStatus.inProgress);
    expect(mutation.version, 7);
    expect(mutation.actorUserId, 'actor-1');
    expect(mutation.correlationId, 'correlation-1');
    final presence = updates.last as TaskProjectPresence;
    expect(presence.users.single.userId, 'user-1');
    expect(presence.users.single.connectionCount, 2);

    await subscription.cancel();
    await adapter.dispose();
  });

  test('mapuje wszystkie eventy Kanban wraz z kontekstem workflow', () async {
    final transport = _TaskTransport();
    final adapter = TaskProjectRealtimeAdapter(
      WorkspaceScopedRealtimeService(client: transport),
    );
    final updates = <TaskProjectRealtimeUpdate>[];
    final subscription = adapter.updates.listen(updates.add);
    await adapter.start(workspaceId: 'workspace-1', projectId: 'project-1');

    const methods = <String>[
      'task.kanban_moved',
      'task.kanban_bulk_moved',
      'task.kanban_column_rebalanced',
    ];
    for (var index = 0; index < methods.length; index++) {
      transport.emit(methods[index], <String, dynamic>{
        'eventId': 'kanban-$index',
        'workspaceId': 'workspace-1',
        'projectId': 'project-1',
        'taskId': 'task-$index',
        'number': index + 1,
        'key': 'TASK-${index + 1}',
        'version': index + 1,
        'occurredAtUtc': '2026-09-08T10:00:00Z',
        'parentTaskId': 'parent-1',
        'customStatusId': 'custom-done',
      });
    }
    await Future<void>.delayed(Duration.zero);

    expect(
      transport.handlers.keys,
      containsAll(methods),
    );
    expect(
      updates.map((update) => (update as TaskRealtimeMutation).type),
      <TaskRealtimeMutationType>[
        TaskRealtimeMutationType.kanbanMoved,
        TaskRealtimeMutationType.kanbanBulkMoved,
        TaskRealtimeMutationType.kanbanColumnRebalanced,
      ],
    );
    final mutation = updates.first as TaskRealtimeMutation;
    expect(mutation.parentTaskId, 'parent-1');
    expect(mutation.customStatusId, 'custom-done');

    await subscription.cancel();
    await adapter.dispose();
  });
}
