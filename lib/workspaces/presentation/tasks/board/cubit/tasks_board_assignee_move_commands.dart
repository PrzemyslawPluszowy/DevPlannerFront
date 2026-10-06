import 'dart:async';

import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

/// Jedna zmiana głównego wykonawcy, należąca do konkretnej operacji i zakresu.
final class TasksBoardAssigneeMoveCommands {
  TasksBoardAssigneeMoveCommands({
    required this._context,
    required this._repository,
    required this._scopeRevision,
    required this._reloadAfterSettingsConflict,
  });

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final int Function() _scopeRevision;
  final Future<void> Function() _reloadAfterSettingsConflict;
  static const _unassigned = 'unassigned';
  static String _key(AssigneeKanbanGroupResponse group) =>
      group.assigneeUserId ?? _unassigned;

  Future<bool> move({
    required KanbanTaskCardResponse task,
    required String? targetUserId,
  }) async {
    final initial = _context.currentState;
    if (_context.isBoardClosed ||
        initial is! TasksBoardReady ||
        initial.grouping != TasksBoardGrouping.assignee ||
        initial.isBulkSaving ||
        initial.pendingTaskIds.contains(task.id)) {
      return false;
    }
    final board = initial.assigneeBoard;
    if (board == null) return false;
    if (_activeCard(initial, task.id) == null) return false;
    final latest = TasksBoardCardStateMutator.findCard(initial, task.id);
    if (latest == null) return false;
    final source = board.groups
        .where(
          (group) => group.tasks.any((item) => item.id == latest.id),
        )
        .firstOrNull;
    if (source == null) return false;
    final sourceKey = _key(source);
    final targetKey = targetUserId ?? _unassigned;
    if (sourceKey == targetKey) return true;
    if (!board.groups.any((group) => _key(group) == targetKey)) return false;
    final revision = _scopeRevision();
    final owner = Object();
    final optimistic = latest.copyWith(
      primaryAssigneeUserId: targetUserId,
      assigneeUserIds: targetUserId == null
          ? const <String>[]
          : ({...?latest.assigneeUserIds, targetUserId}.toList()..sort()),
    );
    final optimisticBoard = _withCardMoved(
      board,
      card: optimistic,
      sourceKey: sourceKey,
      targetKey: targetKey,
    );
    _context.publish(
      initial.copyWith(
        assigneeBoard: optimisticBoard,
        pendingMoveOwners: {...initial.pendingMoveOwners, latest.id: owner},
        pendingTaskIds: {...initial.pendingTaskIds, latest.id},
        clearError: true,
      ),
    );
    try {
      final result = await _repository.changePrimaryAssignee(
        workspaceId: _context.workspaceId,
        projectId: _context.projectId,
        taskId: latest.id,
        targetUserId: targetUserId,
        expectedVersion: latest.version,
      );
      if (!_isCurrent(initial, revision, latest.id, owner)) return false;
      return result.fold<bool>(
        (error) {
          _rollback(
            latest,
            sourceKey,
            targetKey,
            tasksViewErrorFrom(error),
            notFound:
                error.statusCode == 404 || error.apiCode == 'task.not_found',
          );
          if (isTaskSettingsVersionConflict(error)) {
            unawaited(_reloadAfterSettingsConflict());
          }
          return false;
        },
        (response) {
          _confirm(latest.id, response, optimisticBoard);
          return true;
        },
      );
    } catch (_) {
      if (_isCurrent(initial, revision, latest.id, owner)) {
        _rollback(
          latest,
          sourceKey,
          targetKey,
          const TasksViewError(code: 'tasks.bulk.save_failed'),
        );
      }
      return false;
    } finally {
      _release(latest.id, owner);
    }
  }

  bool _isCurrent(
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

  void _release(String taskId, Object owner) {
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

  KanbanTaskCardResponse? _activeCard(TasksBoardReady current, String taskId) {
    KanbanTaskCardResponse? latest;
    for (final group
        in current.assigneeBoard?.groups ?? <AssigneeKanbanGroupResponse>[]) {
      for (final card in group.tasks) {
        if (card.id == taskId &&
            (latest == null || card.version > latest.version)) {
          latest = card;
        }
      }
    }
    return latest;
  }

  void _rollback(
    KanbanTaskCardResponse before,
    String sourceKey,
    String targetKey,
    TasksViewError error, {
    bool notFound = false,
  }) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final board = current.assigneeBoard;
    final active = _activeCard(current, before.id);
    final latest = TasksBoardCardStateMutator.findCard(current, before.id);
    final mayRollback =
        board != null &&
        active != null &&
        active.version == before.version &&
        (latest == null || latest.version <= before.version);
    _context.publish(
      current.copyWith(
        assigneeBoard: mayRollback
            ? notFound
                  ? _withoutCard(board, before.id)
                  : _withCardMoved(
                      board,
                      card: active.copyWith(
                        primaryAssigneeUserId: before.primaryAssigneeUserId,
                        assigneeUserIds: before.assigneeUserIds,
                      ),
                      sourceKey: targetKey,
                      targetKey: sourceKey,
                    )
            : board,
        failedTaskIds: notFound
            ? ({...current.failedTaskIds}..remove(before.id))
            : {...current.failedTaskIds, before.id},
        error: error,
      ),
    );
  }

  void _confirm(
    String taskId,
    ChangeKanbanPrimaryAssigneeResponse response,
    AssigneeKanbanBoardResponse optimisticBoard,
  ) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final active = _activeCard(current, taskId);
    final latest = TasksBoardCardStateMutator.findCard(current, taskId);
    if (active == null ||
        response.task.id != taskId ||
        (latest != null && latest.version > response.task.version)) {
      return;
    }
    final comparable =
        identical(current.assigneeBoard, optimisticBoard) &&
        !current.filter.isActive &&
        (current.userPreference?.quickFilter ?? KanbanQuickFilter.all) ==
            KanbanQuickFilter.all;
    final replaced = TasksBoardCardStateMutator.replaceCard(
      current,
      response.task.copyWith(isPinned: active.isPinned),
    );
    final targetKey = response.targetAssigneeUserId ?? _unassigned;
    final actualSource = replaced.assigneeBoard!.groups
        .where((group) => group.tasks.any((card) => card.id == taskId))
        .firstOrNull;
    final membershipBoard =
        actualSource != null &&
            _key(actualSource) != targetKey &&
            replaced.assigneeBoard!.groups.any(
              (group) => _key(group) == targetKey,
            )
        ? _withCardMoved(
            replaced.assigneeBoard!,
            card: response.task.copyWith(isPinned: active.isPinned),
            sourceKey: _key(actualSource),
            targetKey: targetKey,
          )
        : replaced.assigneeBoard!;
    _context.publish(
      replaced.copyWith(
        assigneeBoard: membershipBoard.copyWith(
          groups: [
            for (final group in membershipBoard.groups)
              if (comparable &&
                  _key(group) ==
                      (response.previousAssigneeUserId ?? _unassigned))
                group.copyWith(totalTaskCount: response.previousGroupTaskCount)
              else if (comparable &&
                  _key(group) == (response.targetAssigneeUserId ?? _unassigned))
                group.copyWith(totalTaskCount: response.targetGroupTaskCount)
              else
                group,
          ],
        ),
        failedTaskIds: {...current.failedTaskIds}..remove(taskId),
      ),
    );
  }

  AssigneeKanbanBoardResponse _withCardMoved(
    AssigneeKanbanBoardResponse board, {
    required KanbanTaskCardResponse card,
    required String sourceKey,
    required String targetKey,
  }) => board.copyWith(
    groups: board.groups
        .map((group) {
          final key = _key(group);
          if (key == sourceKey) {
            final remaining = group.tasks
                .where((item) => item.id != card.id)
                .toList(growable: false);
            return group.copyWith(
              tasks: remaining,
              totalTaskCount:
                  (group.totalTaskCount -
                          (group.tasks.any((item) => item.id == card.id)
                              ? 1
                              : 0))
                      .clamp(0, 1 << 31),
            );
          }
          if (key == targetKey) {
            final withoutDuplicates =
                group.tasks
                    .where((item) => item.id != card.id)
                    .toList(growable: true)
                  ..insert(0, card);
            return group.copyWith(
              tasks: withoutDuplicates,
              totalTaskCount:
                  (group.totalTaskCount +
                          (group.tasks.any((item) => item.id == card.id)
                              ? 0
                              : 1))
                      .clamp(0, 1 << 31),
            );
          }
          return group;
        })
        .toList(growable: false),
  );

  AssigneeKanbanBoardResponse _withoutCard(
    AssigneeKanbanBoardResponse board,
    String taskId,
  ) => board.copyWith(
    groups: board.groups
        .map((group) {
          if (!group.tasks.any((item) => item.id == taskId)) return group;
          return group.copyWith(
            tasks: group.tasks
                .where((item) => item.id != taskId)
                .toList(growable: false),
            totalTaskCount: (group.totalTaskCount - 1).clamp(0, 1 << 31),
          );
        })
        .toList(growable: false),
  );
}
