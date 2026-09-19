import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';

/// Typowany adapter huba Tasks dla jednego ekranu projektu.
final class TaskProjectRealtimeAdapter implements TaskProjectRealtime {
  TaskProjectRealtimeAdapter(this._service);

  /// Tworzy niezależne połączenie huba Tasks dla właściciela ekranu.
  factory TaskProjectRealtimeAdapter.fromFactory(
    WorkspaceScopedRealtimeFactory factory,
  ) => TaskProjectRealtimeAdapter(
    factory.create(WorkspaceScopedRealtimeKind.tasks),
  );

  final WorkspaceScopedRealtimeService _service;
  final StreamController<TaskProjectRealtimeUpdate> _updates =
      StreamController<TaskProjectRealtimeUpdate>.broadcast();
  StreamSubscription<WorkspaceScopedRealtimeEvent>? _subscription;

  @override
  Stream<TaskProjectRealtimeUpdate> get updates => _updates.stream;
  @override
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      _service.connectionStates;
  @override
  Stream<WorkspaceScopedRealtimeError> get errors => _service.errors;

  @override
  Future<void> start({
    required String workspaceId,
    required String projectId,
  }) async {
    await _subscription?.cancel();
    _subscription = _service.events.listen(_onEvent);
    await _service.start(
      WorkspaceScopedRealtimeTarget.tasks(
        workspaceId: workspaceId,
        resourceId: projectId,
      ),
    );
  }

  void _onEvent(WorkspaceScopedRealtimeEvent event) {
    final update = switch (event.method) {
      'project.presence.changed' => _presence(event.payload),
      'task.created' ||
      'task.updated' ||
      'task.status_changed' ||
      'task.kanban_moved' ||
      'task.kanban_bulk_moved' ||
      'task.kanban_column_rebalanced' ||
      'task.archived' ||
      'task.restored' ||
      'task.recurrence_changed' => _mutation(event),
      _ => null,
    };
    if (update != null && !_updates.isClosed) _updates.add(update);
  }

  TaskRealtimeMutation? _mutation(WorkspaceScopedRealtimeEvent event) {
    final payload = event.payload;
    final eventId = _string(payload, 'eventId');
    final workspaceId = _string(payload, 'workspaceId');
    final projectId = _string(payload, 'projectId');
    final taskId = _string(payload, 'taskId');
    final number = _integer(payload, 'number');
    final key = _string(payload, 'key');
    final version = _integer(payload, 'version');
    final occurredAtUtc = _date(payload, 'occurredAtUtc');
    if (eventId == null ||
        workspaceId == null ||
        projectId == null ||
        taskId == null ||
        number == null ||
        key == null ||
        version == null ||
        occurredAtUtc == null) {
      return null;
    }

    return TaskRealtimeMutation(
      eventId: eventId,
      type: switch (event.method) {
        'task.created' => TaskRealtimeMutationType.created,
        'task.updated' => TaskRealtimeMutationType.updated,
        'task.status_changed' => TaskRealtimeMutationType.statusChanged,
        'task.kanban_moved' => TaskRealtimeMutationType.kanbanMoved,
        'task.kanban_bulk_moved' => TaskRealtimeMutationType.kanbanBulkMoved,
        'task.kanban_column_rebalanced' =>
          TaskRealtimeMutationType.kanbanColumnRebalanced,
        'task.archived' => TaskRealtimeMutationType.archived,
        'task.restored' => TaskRealtimeMutationType.restored,
        _ => TaskRealtimeMutationType.recurrenceChanged,
      },
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      number: number,
      key: key,
      version: version,
      actorUserId: _string(payload, 'actorUserId'),
      correlationId: _string(payload, 'correlationId'),
      occurredAtUtc: occurredAtUtc,
      status: _status(_string(payload, 'status')),
      previousStatus: _status(_string(payload, 'previousStatus')),
      position: _integer(payload, 'position'),
      title: _string(payload, 'title'),
      description: _string(payload, 'description'),
      priority: _priority(_string(payload, 'priority')),
      dueAtUtc: _date(payload, 'dueAtUtc'),
      hasDueAtUtc: payload.containsKey('dueAtUtc'),
      archivedAtUtc: _date(payload, 'archivedAtUtc'),
      parentTaskId: _string(payload, 'parentTaskId'),
      customStatusId: _string(payload, 'customStatusId'),
      isReplay: event.isReplay,
    );
  }

  TaskProjectPresence? _presence(Map<String, dynamic> payload) {
    final workspaceId = _string(payload, 'workspaceId');
    final projectId = _string(payload, 'projectId');
    final updatedAtUtc = _date(payload, 'updatedAtUtc');
    final rawUsers = _value(payload, 'users');
    if (workspaceId == null ||
        projectId == null ||
        updatedAtUtc == null ||
        rawUsers is! List) {
      return null;
    }
    final users = <TaskProjectPresenceUser>[];
    for (final raw in rawUsers) {
      if (raw is! Map) continue;
      final map = Map<String, dynamic>.from(raw);
      final userId = _string(map, 'userId');
      final connectionCount = _integer(map, 'connectionCount');
      if (userId != null && connectionCount != null) {
        users.add(
          TaskProjectPresenceUser(
            userId: userId,
            connectionCount: connectionCount,
          ),
        );
      }
    }
    return TaskProjectPresence(
      workspaceId: workspaceId,
      projectId: projectId,
      users: List.unmodifiable(users),
      updatedAtUtc: updatedAtUtc,
    );
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _service.dispose();
    await _updates.close();
  }

  static Object? _value(Map<String, dynamic> map, String key) =>
      map[key] ?? map['${key[0].toUpperCase()}${key.substring(1)}'];

  static String? _string(Map<String, dynamic> map, String key) {
    final value = _value(map, key);
    return value?.toString();
  }

  static int? _integer(Map<String, dynamic> map, String key) {
    final value = _value(map, key);
    return value is int ? value : int.tryParse(value?.toString() ?? '');
  }

  static DateTime? _date(Map<String, dynamic> map, String key) {
    final value = _string(map, key);
    return value == null ? null : DateTime.tryParse(value)?.toUtc();
  }

  static ProjectTaskStatus? _status(String? value) =>
      switch (value?.toLowerCase()) {
        'backlog' => ProjectTaskStatus.backlog,
        'todo' => ProjectTaskStatus.todo,
        'inprogress' => ProjectTaskStatus.inProgress,
        'blocked' => ProjectTaskStatus.blocked,
        'done' => ProjectTaskStatus.done,
        'cancelled' => ProjectTaskStatus.cancelled,
        _ => null,
      };

  static TaskPriority? _priority(String? value) =>
      switch (value?.toLowerCase()) {
        'low' => TaskPriority.low,
        'normal' => TaskPriority.normal,
        'high' => TaskPriority.high,
        'critical' => TaskPriority.critical,
        _ => null,
      };
}
