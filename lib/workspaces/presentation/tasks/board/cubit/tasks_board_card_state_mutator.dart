import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Deterministyczne transformacje obu snapshotów kart Kanbana.
final class TasksBoardCardStateMutator {
  const TasksBoardCardStateMutator._();

  static TasksBoardReady replaceCard(
    TasksBoardReady current,
    KanbanTaskCardResponse replacement,
  ) => current.copyWith(
    board: current.board.copyWith(
      columns: [
        for (final column in current.board.columns)
          column.copyWith(tasks: _replace(column.tasks, replacement)),
      ],
    ),
    assigneeBoard: current.assigneeBoard?.copyWith(
      groups: [
        for (final group in current.assigneeBoard!.groups)
          group.copyWith(tasks: _replace(group.tasks, replacement)),
      ],
    ),
    clearError: true,
    taskDataRevision: current.taskDataRevision + 1,
  );

  static List<KanbanTaskCardResponse> _replace(
    List<KanbanTaskCardResponse> cards,
    KanbanTaskCardResponse replacement,
  ) => [
    for (final card in cards)
      if (card.id == replacement.id && card.version <= replacement.version)
        replacement
      else
        card,
  ];

  static KanbanTaskCardResponse? findCard(
    TasksBoardReady current,
    String taskId,
  ) {
    final active = current.grouping == TasksBoardGrouping.assignee
        ? [
            for (final group
                in current.assigneeBoard?.groups ??
                    <AssigneeKanbanGroupResponse>[])
              ...group.tasks,
          ]
        : [for (final column in current.board.columns) ...column.tasks];
    KanbanTaskCardResponse? activeCard;
    for (final card in active) {
      if (card.id == taskId &&
          (activeCard == null || card.version > activeCard.version)) {
        activeCard = card;
      }
    }
    if (activeCard == null) return null;
    final other = current.grouping == TasksBoardGrouping.assignee
        ? [for (final column in current.board.columns) ...column.tasks]
        : [
            for (final group
                in current.assigneeBoard?.groups ??
                    <AssigneeKanbanGroupResponse>[])
              ...group.tasks,
          ];
    KanbanTaskCardResponse? latest;
    // Przy równej wersji aktywny snapshot jest źródłem osobistych flag.
    for (final card in [...active, ...other]) {
      if (card.id == taskId &&
          (latest == null || card.version > latest.version)) {
        latest = card;
      }
    }
    // Przypięcie jest osobistą preferencją bez taskVersion. Nowsza wersja
    // nieaktywnego cache nie jest dowodem świeższej flagi przypięcia.
    return latest?.copyWith(isPinned: activeCard.isPinned);
  }
}
