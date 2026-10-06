import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Snapshot zegarów rzeczywiście zaznaczonych kart w aktywnym grupowaniu.
final class TasksBoardBulkDueScope {
  TasksBoardBulkDueScope.fromReady(TasksBoardReady state) {
    final cards = state.grouping == TasksBoardGrouping.assignee
        ? [
            for (final group
                in state.assigneeBoard?.groups ??
                    <AssigneeKanbanGroupResponse>[])
              ...group.tasks,
          ]
        : [for (final column in state.board.columns) ...column.tasks];
    final selected = <String, KanbanTaskCardResponse>{};
    for (final card in cards) {
      if (state.selectedTaskIds.contains(card.id) &&
          card.version >= (selected[card.id]?.version ?? -1)) {
        selected[card.id] = card;
      }
    }
    values = List.unmodifiable(selected.values.map((card) => card.dueAtUtc));
    isComplete = selected.length == state.selectedTaskIds.length;
  }

  late final List<DateTime?> values;
  late final bool isComplete;
}
