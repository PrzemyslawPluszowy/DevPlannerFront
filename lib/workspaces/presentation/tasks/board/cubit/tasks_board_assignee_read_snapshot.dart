import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Oddziela zmiany danych i optymistycznych operacji od presence/loadera.
final class TasksBoardAssigneeReadSnapshot {
  const TasksBoardAssigneeReadSnapshot(this.before);
  final TasksBoardReady before;

  bool changed(TasksBoardReady after) =>
      before.taskDataRevision != after.taskDataRevision ||
      before.realtimeRevision != after.realtimeRevision ||
      after.pendingMoveOwners.isNotEmpty ||
      before.pendingTaskIds.length != after.pendingTaskIds.length ||
      !before.pendingTaskIds.containsAll(after.pendingTaskIds) ||
      !_sameOwners(before.pendingMoveOwners, after.pendingMoveOwners) ||
      !_sameOwners(before.pendingCardOwners, after.pendingCardOwners);

  bool _sameOwners(Map<String, Object> left, Map<String, Object> right) =>
      left.length == right.length &&
      left.entries.every((entry) => identical(entry.value, right[entry.key]));
}
