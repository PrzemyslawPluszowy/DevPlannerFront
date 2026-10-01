import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';

/// Projects persisted move metadata into one readable status transition.
/// Keeps the API response immutable and leaves unknown fields intact.
abstract final class TaskHistoryChanges {
  static TaskHistoryEventResponse prepare(TaskHistoryEventResponse event) {
    final isMove =
        event.eventType == TaskHistoryEventType.kanbanMoved ||
        event.eventType == TaskHistoryEventType.reordered;
    TaskHistoryChangeResponse? previous;
    TaskHistoryChangeResponse? target;
    if (isMove) {
      for (final change in event.changes) {
        if (change.field == 'status' || change.field == 'oldStatus') {
          previous = change;
        }
        if (change.field == 'targetStatus') target = change;
      }
    }
    final combineStatus = previous != null && target != null;
    final changes = <TaskHistoryChangeResponse>[];
    for (final change in event.changes) {
      if (combineStatus && identical(change, target)) continue;
      final projected = combineStatus && identical(change, previous)
          ? TaskHistoryChangeResponse(
              field: 'status',
              before: previous.before ?? previous.after,
              after: target.after,
            )
          : change;
      if (projected.before != projected.after) changes.add(projected);
    }
    return event.copyWith(changes: List.unmodifiable(changes));
  }
}
