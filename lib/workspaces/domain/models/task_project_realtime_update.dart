import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';

/// Typ zdarzenia domenowego przesyłanego przez hub Tasks.
enum TaskRealtimeMutationType {
  created,
  updated,
  statusChanged,
  kanbanMoved,
  kanbanBulkMoved,
  kanbanColumnRebalanced,
  archived,
  restored,
  recurrenceChanged,
}

/// Typowana aktualizacja projektu odebrana przez SignalR.
sealed class TaskProjectRealtimeUpdate {
  const TaskProjectRealtimeUpdate();
}

/// Częściowy, wersjonowany snapshot zmiany jednego zadania.
final class TaskRealtimeMutation extends TaskProjectRealtimeUpdate {
  const TaskRealtimeMutation({
    required this.eventId,
    required this.type,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    required this.number,
    required this.key,
    required this.version,
    required this.occurredAtUtc,
    required this.isReplay,
    this.actorUserId,
    this.correlationId,
    this.status,
    this.previousStatus,
    this.position,
    this.title,
    this.description,
    this.priority,
    this.dueAtUtc,
    this.hasDueAtUtc = false,
    this.archivedAtUtc,
    this.parentTaskId,
    this.customStatusId,
  });

  final String eventId;
  final TaskRealtimeMutationType type;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final int number;
  final String key;
  final int version;
  final String? actorUserId;
  final String? correlationId;
  final DateTime occurredAtUtc;
  final ProjectTaskStatus? status;
  final ProjectTaskStatus? previousStatus;
  final int? position;
  final String? title;
  final String? description;
  final TaskPriority? priority;
  final DateTime? dueAtUtc;
  final bool hasDueAtUtc;
  final DateTime? archivedAtUtc;
  final String? parentTaskId;
  final String? customStatusId;
  final bool isReplay;
}

/// Obecność jednego użytkownika, zagregowana po kartach i urządzeniach.
final class TaskProjectPresenceUser {
  const TaskProjectPresenceUser({
    required this.userId,
    required this.connectionCount,
  });

  final String userId;
  final int connectionCount;
}

/// Aktualny snapshot osób obecnych w widoku Tasks projektu.
final class TaskProjectPresence extends TaskProjectRealtimeUpdate {
  const TaskProjectPresence({
    required this.workspaceId,
    required this.projectId,
    required this.users,
    required this.updatedAtUtc,
  });

  final String workspaceId;
  final String projectId;
  final List<TaskProjectPresenceUser> users;
  final DateTime updatedAtUtc;
}
