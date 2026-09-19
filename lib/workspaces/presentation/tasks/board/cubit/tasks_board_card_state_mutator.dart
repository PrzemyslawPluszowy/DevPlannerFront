import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Deterministyczne, lokalne transformacje snapshotu kart Kanbana.
final class TasksBoardCardStateMutator {
  const TasksBoardCardStateMutator._();

  static TasksBoardReady replaceCard(
    TasksBoardReady current,
    KanbanTaskCardResponse replacement,
  ) => current.copyWith(
    board: current.board.copyWith(
      columns: [
        for (final column in current.board.columns)
          column.copyWith(
            tasks: [
              for (final task in column.tasks)
                if (task.id == replacement.id) replacement else task,
            ],
          ),
      ],
    ),
    clearError: true,
    taskDataRevision: current.taskDataRevision + 1,
  );

  static KanbanTaskCardResponse? findCard(
    TasksBoardReady current,
    String taskId,
  ) => current.board.columns
      .expand((column) => column.tasks)
      .where((card) => card.id == taskId)
      .firstOrNull;
}
