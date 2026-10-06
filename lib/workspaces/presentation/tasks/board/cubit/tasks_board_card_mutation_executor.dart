import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

/// Lifecycle pojedynczego zapisu karty, niezależny od rodzaju mutacji.
final class TasksBoardCardMutationExecutor {
  TasksBoardCardMutationExecutor({
    required this.context,
    required this.scopeRevision,
    required this.refreshAssigneeBoard,
  });
  final TasksBoardCommandContext context;
  final int Function() scopeRevision;
  final Future<void> Function() refreshAssigneeBoard;

  Future<bool> run<T>({
    required String taskId,
    required Future<Either<ApiError, T>> Function(KanbanTaskCardResponse)
    operation,
    required TasksBoardReady Function(
      TasksBoardReady,
      KanbanTaskCardResponse,
      T,
    )
    apply,
    bool refreshPersonsAfterSuccess = false,
  }) async {
    final initial = context.currentState;
    if (context.isBoardClosed ||
        initial is! TasksBoardReady ||
        initial.isBulkSaving ||
        initial.pendingTaskIds.contains(taskId)) {
      return false;
    }
    final card = TasksBoardCardStateMutator.findCard(initial, taskId);
    if (card == null) return false;
    final revision = scopeRevision();
    final owner = Object();
    context.publish(
      initial.copyWith(
        pendingTaskIds: {...initial.pendingTaskIds, taskId},
        pendingCardOwners: {...initial.pendingCardOwners, taskId: owner},
        clearError: true,
      ),
    );
    try {
      final result = await operation(card);
      final current = _current(initial, revision, taskId, owner);
      if (current == null) return false;
      return await result.fold<Future<bool>>(
        (error) async {
          context.publish(current.copyWith(error: tasksViewErrorFrom(error)));
          return false;
        },
        (value) async {
          final latest = TasksBoardCardStateMutator.findCard(current, taskId);
          if (latest == null) return true;
          final saved = apply(current, latest, value);
          context.publish(saved);
          if (refreshPersonsAfterSuccess &&
              saved.grouping == TasksBoardGrouping.assignee) {
            await _refreshCommitted(saved, revision, taskId, owner);
          }
          return true;
        },
      );
    } catch (_) {
      final current = _current(initial, revision, taskId, owner);
      if (current != null) {
        context.publish(
          current.copyWith(
            error: const TasksViewError(code: 'tasks.bulk.save_failed'),
          ),
        );
      }
      return false;
    } finally {
      final current = context.currentState;
      if (!context.isBoardClosed &&
          current is TasksBoardReady &&
          identical(current.pendingCardOwners[taskId], owner)) {
        context.publish(
          current.copyWith(
            pendingTaskIds: {...current.pendingTaskIds}..remove(taskId),
          ),
        );
      }
    }
  }

  Future<void> _refreshCommitted(
    TasksBoardReady saved,
    int revision,
    String taskId,
    Object owner,
  ) async {
    try {
      await refreshAssigneeBoard();
      // Celowany odczyt grup zachowuje bieżący Ready i pozostałe karty.
      // Jego typed failure zostaje w stanie; nie cofamy potwierdzonego zapisu.
    } catch (_) {
      final current = _current(saved, revision, taskId, owner);
      if (current != null) {
        context.publish(
          current.copyWith(
            error: const TasksViewError(
              code: TasksViewErrorCodes.boardCommittedReloadFailed,
            ),
          ),
        );
      }
    }
  }

  TasksBoardReady? _current(
    TasksBoardReady initial,
    int revision,
    String taskId,
    Object owner,
  ) {
    final current = context.currentState;
    if (context.isBoardClosed ||
        current is! TasksBoardReady ||
        scopeRevision() != revision ||
        current.filter != initial.filter ||
        current.grouping != initial.grouping ||
        current.userPreference?.quickFilter !=
            initial.userPreference?.quickFilter ||
        !identical(current.pendingCardOwners[taskId], owner)) {
      return null;
    }
    return current;
  }
}
