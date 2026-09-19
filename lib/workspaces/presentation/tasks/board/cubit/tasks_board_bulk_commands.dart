import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Operacje zaznaczenia, masowe oraz przeciąganie kart Kanbana.
final class TasksBoardBulkCommands {
  TasksBoardBulkCommands({
    required this._context,
    required this._repository,
    required this._canMoveTaskTo,
  });

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final bool Function({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
  })
  _canMoveTaskTo;

  void toggleSelection(KanbanTaskCardResponse task) {
    final current = _context.currentState;
    if (current is! TasksBoardReady || current.isBulkSaving) return;
    final selected = {...current.selectedTaskIds};
    selected.contains(task.id)
        ? selected.remove(task.id)
        : selected.add(task.id);
    _context.publish(current.copyWith(selectedTaskIds: selected));
  }

  void clearSelection() {
    final current = _context.currentState;
    if (current is! TasksBoardReady || current.selectedTaskIds.isEmpty) return;
    _context.publish(current.copyWith(selectedTaskIds: const <String>{}));
  }

  void selectAllLoaded() {
    final current = _context.currentState;
    if (current is! TasksBoardReady || current.isBulkSaving) return;
    final ids = {
      for (final column in current.board.columns)
        for (final task in column.tasks) task.id,
    };
    if (ids.isEmpty ||
        (ids.length == current.selectedTaskIds.length &&
            ids.containsAll(current.selectedTaskIds))) {
      return;
    }
    _context.publish(current.copyWith(selectedTaskIds: ids));
  }

  Future<void> bulkMove(KanbanColumnResponse targetColumn) async {
    final current = _beginBulk(_context.currentState);
    if (current == null) return;
    final result = await _repository.bulkMove(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: BulkMoveKanbanTasksPayload(
        targetStatus: targetColumn.status,
        customStatusId: targetColumn.customStatusId,
        tasks: _selectedCards(current)
            .map(
              (card) => BulkMoveKanbanTaskItemPayload(
                taskId: card.id,
                expectedVersion: card.version,
              ),
            )
            .toList(growable: false),
      ),
    );
    await _completeBulk(result);
  }

  Future<void> bulkUpdatePriority(TaskPriority priority) =>
      _bulkUpdate(priority: priority);

  Future<void> bulkUpdateDueDate(DateTime dueAtUtc) =>
      _bulkUpdate(dueAtUtc: dueAtUtc.toUtc());

  Future<void> _bulkUpdate({TaskPriority? priority, DateTime? dueAtUtc}) async {
    final current = _beginBulk(_context.currentState);
    if (current == null) return;
    final result = await _repository.bulkUpdate(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: BulkUpdateKanbanTasksPayload(
        priority: priority,
        dueAtUtc: dueAtUtc,
        tasks: _selectedCards(current)
            .map(
              (card) => BulkUpdateKanbanTaskItemPayload(
                taskId: card.id,
                expectedVersion: card.version,
              ),
            )
            .toList(growable: false),
      ),
    );
    await _completeBulk(result);
  }

  Future<void> move({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
    required int targetIndex,
  }) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final latestTask = TasksBoardCardStateMutator.findCard(current, task.id);
    if (latestTask == null) {
      _publishError(
        current,
        'Zadanie nie jest już dostępne na aktualnej tablicy.',
      );
      return;
    }
    if (!_canMoveTaskTo(task: latestTask, targetColumn: targetColumn)) {
      _publishError(
        current,
        'To przejście statusu nie jest dozwolone w workflow.',
      );
      return;
    }
    final sourceColumn = current.board.columns
        .where((column) => column.tasks.any((item) => item.id == latestTask.id))
        .firstOrNull;
    if (sourceColumn == null) return;
    final sourceKey = _columnKey(sourceColumn);
    final targetKey = _columnKey(targetColumn);
    final sameColumn = sourceKey == targetKey;
    final sourceIndex = sourceColumn.tasks.indexWhere(
      (item) => item.id == latestTask.id,
    );
    final adjustedIndex =
        sameColumn && sourceIndex >= 0 && sourceIndex < targetIndex
        ? targetIndex - 1
        : targetIndex;
    final targetCards = targetColumn.tasks
        .where((item) => item.id != latestTask.id)
        .toList(growable: true);
    final safeIndex = adjustedIndex.clamp(0, targetCards.length);
    final previousTaskId = safeIndex == 0
        ? null
        : targetCards[safeIndex - 1].id;
    final nextTaskId = safeIndex == targetCards.length
        ? null
        : targetCards[safeIndex].id;
    targetCards.insert(
      safeIndex,
      latestTask.copyWith(
        status: targetColumn.status,
        customStatusId: targetColumn.customStatusId,
      ),
    );
    _context.publish(
      current.copyWith(
        board: current.board.copyWith(
          columns: current.board.columns
              .map((column) {
                final key = _columnKey(column);
                if (key == targetKey) {
                  return column.copyWith(
                    tasks: targetCards,
                    totalTaskCount: sameColumn
                        ? column.totalTaskCount
                        : column.totalTaskCount + 1,
                  );
                }
                if (key == sourceKey) {
                  return column.copyWith(
                    tasks: column.tasks
                        .where((item) => item.id != latestTask.id)
                        .toList(),
                    totalTaskCount: (column.totalTaskCount - 1).clamp(
                      0,
                      1 << 31,
                    ),
                  );
                }
                return column;
              })
              .toList(growable: false),
        ),
        pendingTaskIds: {...current.pendingTaskIds, latestTask.id},
        clearMutationError: true,
      ),
    );
    final result = await _repository.moveTask(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      taskId: latestTask.id,
      payload: MoveKanbanTaskPayload(
        targetStatus: targetColumn.status,
        previousTaskId: previousTaskId,
        nextTaskId: nextTaskId,
        expectedVersion: latestTask.version,
        customStatusId: targetColumn.customStatusId,
      ),
    );
    if (_context.isBoardClosed) return;
    result.fold(
      (error) => _rollbackMove(
        task: latestTask,
        sourceKey: sourceKey,
        targetKey: targetKey,
        sourceIndex: sourceIndex,
        sameColumn: sameColumn,
        errorMessage: error.message,
      ),
      (response) => _confirmMove(
        taskId: latestTask.id,
        targetKey: targetKey,
        response: response,
      ),
    );
  }

  TasksBoardReady? _beginBulk(TasksBoardState state) {
    if (state is! TasksBoardReady ||
        state.isBulkSaving ||
        state.selectedTaskIds.isEmpty) {
      return null;
    }
    final cards = _selectedCards(state);
    if (cards.isEmpty) return null;
    _context.publish(
      state.copyWith(isBulkSaving: true, clearMutationError: true),
    );
    return state;
  }

  Future<void> _completeBulk<T>(Either<ApiError, T> result) async {
    if (_context.isBoardClosed) return;
    await result.fold(
      (error) async {
        final ready = _context.currentState;
        if (ready is TasksBoardReady) {
          _context.publish(
            ready.copyWith(
              isBulkSaving: false,
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
      },
      (_) async => _context.reloadBoard(force: true),
    );
  }

  List<KanbanTaskCardResponse> _selectedCards(TasksBoardReady state) => [
    for (final column in state.board.columns)
      for (final task in column.tasks)
        if (state.selectedTaskIds.contains(task.id)) task,
  ];

  void _rollbackMove({
    required KanbanTaskCardResponse task,
    required String sourceKey,
    required String targetKey,
    required int sourceIndex,
    required bool sameColumn,
    required String errorMessage,
  }) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final columns = current.board.columns
        .map((column) {
          final key = _columnKey(column);
          if (key == targetKey) {
            return column.copyWith(
              tasks: column.tasks.where((item) => item.id != task.id).toList(),
              totalTaskCount: sameColumn
                  ? column.totalTaskCount
                  : (column.totalTaskCount - 1).clamp(0, 1 << 31),
            );
          }
          if (key == sourceKey) {
            final restored = column.tasks
                .where((item) => item.id != task.id)
                .toList();
            restored.insert(sourceIndex.clamp(0, restored.length), task);
            return column.copyWith(
              tasks: restored,
              totalTaskCount: sameColumn
                  ? column.totalTaskCount
                  : column.totalTaskCount + 1,
            );
          }
          return column;
        })
        .toList(growable: false);
    _context.publish(
      current.copyWith(
        board: current.board.copyWith(columns: columns),
        pendingTaskIds: {...current.pendingTaskIds}..remove(task.id),
        mutationError: errorMessage,
        mutationSerial: current.mutationSerial + 1,
      ),
    );
  }

  void _confirmMove({
    required String taskId,
    required String targetKey,
    required MoveKanbanTaskResponse response,
  }) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final card = TasksBoardCardStateMutator.findCard(current, response.task.id);
    if (card != null && card.version > response.task.version) {
      _context.publish(
        current.copyWith(
          pendingTaskIds: {...current.pendingTaskIds}..remove(taskId),
        ),
      );
      return;
    }
    final columns = current.board.columns
        .map((column) {
          if (_columnKey(column) != targetKey) return column;
          return column.copyWith(
            tasks: column.tasks
                .map(
                  (item) => item.id == response.task.id ? response.task : item,
                )
                .toList(growable: false),
            totalTaskCount: response.targetColumnTaskCount,
            wipLimit: response.targetColumnWipLimit,
            isWipLimitExceeded: response.isWipLimitExceeded,
          );
        })
        .toList(growable: false);
    _context.publish(
      current.copyWith(
        board: current.board.copyWith(columns: columns),
        pendingTaskIds: {...current.pendingTaskIds}..remove(taskId),
      ),
    );
  }

  void _publishError(TasksBoardReady state, String message) => _context.publish(
    state.copyWith(
      mutationError: message,
      mutationSerial: state.mutationSerial + 1,
    ),
  );

  String _columnKey(KanbanColumnResponse column) =>
      column.customStatusId ?? column.status.name;
}
