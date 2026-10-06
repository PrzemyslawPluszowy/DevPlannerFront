import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_error_messages.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

/// Pojedyncze przeciągnięcie karty z optymistycznym rollbackiem.
final class TasksBoardMoveCommands {
  TasksBoardMoveCommands({
    required this._context,
    required this._repository,
    required this._canMoveTaskTo,
    required this._scopeRevision,
  });
  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final int Function() _scopeRevision;
  final bool Function({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
  })
  _canMoveTaskTo;
  Future<void> move({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
    required int targetIndex,
  }) async {
    final current = _context.currentState;
    if (_context.isBoardClosed ||
        current is! TasksBoardReady ||
        current.isBulkSaving ||
        current.pendingTaskIds.contains(task.id)) {
      return;
    }
    final revision = _scopeRevision();
    final target = current.board.columns
        .where((column) => _columnKey(column) == _columnKey(targetColumn))
        .firstOrNull;
    if (target == null) return;
    final latestTask = TasksBoardCardStateMutator.findCard(current, task.id);
    if (latestTask == null) {
      _publishError(
        current,
        'Zadanie nie jest już dostępne na aktualnej tablicy.',
      );
      return;
    }
    if (!_canMoveTaskTo(task: latestTask, targetColumn: target)) {
      _publishError(
        current,
        'To przejście statusu nie jest dozwolone w workflow.',
      );
      return;
    }
    final sourceColumn = current.board.columns
        .where((column) => column.tasks.any((item) => item.id == latestTask.id))
        .firstOrNull;
    if (sourceColumn == null) {
      return;
    }
    final sourceKey = _columnKey(sourceColumn);
    final targetKey = _columnKey(target);
    final sameColumn = sourceKey == targetKey;
    final sourceIndex = sourceColumn.tasks.indexWhere(
      (item) => item.id == latestTask.id,
    );
    final adjustedIndex =
        sameColumn && sourceIndex >= 0 && sourceIndex < targetIndex
        ? targetIndex - 1
        : targetIndex;
    final targetCards = target.tasks
        .where((item) => item.id != latestTask.id)
        .toList(growable: true);
    // Backend waliduje wstawienie względem pełnej kolumny, a filtr może ukryć
    // całą jej zawartość. Wtedy nie da się wskazać sąsiada, więc zamiast
    // wysyłać żądanie, które Backend musi odrzucić, zatrzymujemy ruch lokalnie.
    if (targetCards.isEmpty && _hidesColumnContents(current)) {
      _publishError(current, TasksBoardErrorCodes.moveBlockedByFilter);
      return;
    }
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
        status: target.status,
        customStatusId: target.customStatusId,
      ),
    );
    final owner = Object();
    _context.publish(
      current.copyWith(
        pendingMoveOwners: {...current.pendingMoveOwners, latestTask.id: owner},
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
        clearError: true,
      ),
    );
    try {
      final result = await _repository.moveTask(
        workspaceId: _context.workspaceId,
        projectId: _context.projectId,
        taskId: latestTask.id,
        payload: MoveKanbanTaskPayload(
          targetStatus: target.status,
          previousTaskId: previousTaskId,
          nextTaskId: nextTaskId,
          expectedVersion: latestTask.version,
          customStatusId: target.customStatusId,
        ),
      );
      if (!_isCurrentScope(current, revision, latestTask.id, owner)) return;
      result.fold(
        (error) => _rollbackMove(
          task: latestTask,
          sourceKey: sourceKey,
          targetKey: targetKey,
          sourceIndex: sourceIndex,
          sameColumn: sameColumn,
          error: tasksViewErrorFrom(error),
        ),
        (response) => _confirmMove(
          taskId: latestTask.id,
          targetKey: targetKey,
          response: response,
        ),
      );
    } catch (_) {
      if (!_isCurrentScope(current, revision, latestTask.id, owner)) return;
      _rollbackMove(
        task: latestTask,
        sourceKey: sourceKey,
        targetKey: targetKey,
        sourceIndex: sourceIndex,
        sameColumn: sameColumn,
        error: const TasksViewError(code: 'tasks.bulk.save_failed'),
      );
    } finally {
      _releasePending(latestTask.id, owner);
    }
  }

  void _releasePending(String taskId, Object owner) {
    final current = _context.currentState;
    if (_context.isBoardClosed ||
        current is! TasksBoardReady ||
        !identical(current.pendingMoveOwners[taskId], owner)) {
      return;
    }
    _context.publish(
      current.copyWith(
        pendingTaskIds: {...current.pendingTaskIds}..remove(taskId),
      ),
    );
  }

  bool _isCurrentScope(
    TasksBoardReady initial,
    int revision,
    String taskId,
    Object owner,
  ) {
    final current = _context.currentState;
    return !_context.isBoardClosed &&
        current is TasksBoardReady &&
        _scopeRevision() == revision &&
        identical(current.pendingMoveOwners[taskId], owner) &&
        current.filter == initial.filter &&
        current.grouping == initial.grouping &&
        current.userPreference?.quickFilter ==
            initial.userPreference?.quickFilter;
  }

  void _rollbackMove({
    required KanbanTaskCardResponse task,
    required String sourceKey,
    required String targetKey,
    required int sourceIndex,
    required bool sameColumn,
    required TasksViewError error,
  }) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) {
      return;
    }
    final latest = TasksBoardCardStateMutator.findCard(current, task.id);
    if (latest == null || latest.version != task.version) {
      _context.publish(
        current.copyWith(
          pendingTaskIds: {...current.pendingTaskIds}..remove(task.id),
          failedTaskIds: {...current.failedTaskIds, task.id},
          error: error,
        ),
      );
      return;
    }
    final columns = current.board.columns
        .map((column) {
          final key = _columnKey(column);
          if (key == targetKey && !sameColumn) {
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
        failedTaskIds: {...current.failedTaskIds, task.id},
        error: error,
      ),
    );
  }

  void _confirmMove({
    required String taskId,
    required String targetKey,
    required MoveKanbanTaskResponse response,
  }) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) {
      return;
    }
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
        failedTaskIds: {...current.failedTaskIds}..remove(taskId),
      ),
    );
  }

  /// Czy aktywny filtr może ukrywać karty poza tym, co widać na tablicy.
  ///
  /// Filtr tablicy i osobisty szybki filtr zawężają karty po stronie Backendu,
  /// więc pusta kolumna na ekranie nie musi być pusta w bazie.
  bool _hidesColumnContents(TasksBoardReady state) =>
      state.filter.isActive ||
      (state.userPreference?.quickFilter ?? KanbanQuickFilter.all) !=
          KanbanQuickFilter.all;

  void _publishError(TasksBoardReady state, String message) => _context.publish(
    state.copyWith(error: TasksViewError(code: message)),
  );

  String _columnKey(KanbanColumnResponse column) =>
      column.customStatusId ?? column.status.name;
}
