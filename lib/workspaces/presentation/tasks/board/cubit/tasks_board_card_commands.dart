import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/task_recurrence_summary.dart';

/// Komendy mutujące pojedynczą kartę; nie obsługują realtime ani widoku.
final class TasksBoardCardCommands {
  TasksBoardCardCommands({
    required this._context,
    required this._tasksRepository,
    this.collaborationRepository,
  });

  final TasksBoardCommandContext _context;
  final TasksRepository _tasksRepository;
  final TaskCollaborationRepository? collaborationRepository;

  Future<bool> togglePinned(KanbanTaskCardResponse task) async {
    final current = _context.currentState;
    final repository = collaborationRepository;
    if (current is! TasksBoardReady || repository == null) return false;
    final result = await repository.updatePinned(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      taskId: task.id,
      isPinned: !task.isPinned,
    );
    final latest = _context.currentState;
    if (_context.isBoardClosed || latest is! TasksBoardReady) return false;
    return result.fold(
      (error) {
        _context.publish(
          latest.copyWith(
            mutationError: error.message,
            mutationSerial: latest.mutationSerial + 1,
          ),
        );
        return false;
      },
      (_) {
        final card =
            TasksBoardCardStateMutator.findCard(latest, task.id) ?? task;
        _context.publish(
          TasksBoardCardStateMutator.replaceCard(
            latest,
            card.copyWith(isPinned: !card.isPinned),
          ),
        );
        return true;
      },
    );
  }

  Future<bool> toggleWatching(KanbanTaskCardResponse task) async {
    final current = _context.currentState;
    final repository = collaborationRepository;
    if (current is! TasksBoardReady || repository == null) return false;
    final result = task.isWatchedByMe
        ? await repository.unfollow(
            workspaceId: _context.workspaceId,
            projectId: _context.projectId,
            taskId: task.id,
            expectedVersion: task.version,
          )
        : await repository.follow(
            workspaceId: _context.workspaceId,
            projectId: _context.projectId,
            taskId: task.id,
            expectedVersion: task.version,
          );
    final latest = _context.currentState;
    if (_context.isBoardClosed || latest is! TasksBoardReady) return false;
    return result.fold(
      (error) {
        _context.publish(
          latest.copyWith(
            mutationError: error.message,
            mutationSerial: latest.mutationSerial + 1,
          ),
        );
        return false;
      },
      (mutation) {
        final card =
            TasksBoardCardStateMutator.findCard(latest, task.id) ?? task;
        final watching = !card.isWatchedByMe;
        _context.publish(
          TasksBoardCardStateMutator.replaceCard(
            latest,
            card.copyWith(
              isWatchedByMe: watching,
              watcherCount: watching
                  ? card.watcherCount + 1
                  : (card.watcherCount - 1).clamp(0, card.watcherCount),
              version: mutation.taskVersion,
            ),
          ),
        );
        return true;
      },
    );
  }

  Future<bool> updatePriority(String taskId, TaskPriority priority) =>
      _updateListItem(
        taskId,
        (card) => UpdateTaskListItemPayload(
          priority: priority,
          expectedVersion: card.version,
        ),
      );

  Future<bool> updateDueDate(String taskId, DateTime? dueAtUtc) =>
      _updateListItem(
        taskId,
        (card) => UpdateTaskListItemPayload(
          dueAtUtc: dueAtUtc,
          clearDueAtUtc: dueAtUtc == null,
          expectedVersion: card.version,
        ),
      );

  Future<bool> replaceAssignees(String taskId, List<String> userIds) async {
    final current = _context.currentState;
    final repository = collaborationRepository;
    if (current is! TasksBoardReady ||
        repository == null ||
        current.pendingTaskIds.contains(taskId)) {
      return false;
    }
    final card = TasksBoardCardStateMutator.findCard(current, taskId);
    if (card == null) return false;
    _context.publish(
      current.copyWith(pendingTaskIds: {...current.pendingTaskIds, taskId}),
    );
    final result = await repository.replaceAssignees(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      taskId: taskId,
      userIds: userIds,
      expectedVersion: card.version,
    );
    final ready = _context.currentState;
    if (_context.isBoardClosed || ready is! TasksBoardReady) return false;
    return result.fold(
      (error) {
        _context.publish(
          ready.copyWith(
            pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            mutationError: error.message,
            mutationSerial: ready.mutationSerial + 1,
          ),
        );
        return false;
      },
      (mutation) {
        final latest = TasksBoardCardStateMutator.findCard(ready, taskId);
        if (latest == null || mutation.data.version < latest.version) {
          _context.publish(
            ready.copyWith(
              pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            ),
          );
          return true;
        }
        final primary =
            mutation.data.assignees
                .where((assignee) => assignee.isPrimary)
                .firstOrNull ??
            mutation.data.assignees.firstOrNull;
        _context.publish(
          TasksBoardCardStateMutator.replaceCard(
            ready,
            latest.copyWith(
              primaryAssigneeUserId: primary?.userId,
              version: mutation.data.version,
            ),
          ).copyWith(
            pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
          ),
        );
        return true;
      },
    );
  }

  Future<bool> _updateListItem(
    String taskId,
    UpdateTaskListItemPayload Function(KanbanTaskCardResponse card) payload,
  ) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady ||
        current.pendingTaskIds.contains(taskId)) {
      return false;
    }
    final card = TasksBoardCardStateMutator.findCard(current, taskId);
    if (card == null) return false;
    _context.publish(
      current.copyWith(pendingTaskIds: {...current.pendingTaskIds, taskId}),
    );
    final result = await _tasksRepository.updateListItem(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      taskId: taskId,
      payload: payload(card),
    );
    final ready = _context.currentState;
    if (_context.isBoardClosed || ready is! TasksBoardReady) return false;
    return result.fold(
      (error) {
        _context.publish(
          ready.copyWith(
            pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            mutationError: error.message,
            mutationSerial: ready.mutationSerial + 1,
          ),
        );
        return false;
      },
      (mutation) {
        final latest = TasksBoardCardStateMutator.findCard(ready, taskId);
        if (latest == null || mutation.data.version < latest.version) {
          _context.publish(
            ready.copyWith(
              pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            ),
          );
          return true;
        }
        _context.publish(
          TasksBoardCardStateMutator.replaceCard(
            ready,
            latest.copyWith(
              priority: mutation.data.priority,
              dueAtUtc: mutation.data.dueAtUtc,
              version: mutation.data.version,
            ),
          ).copyWith(pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId)),
        );
        return true;
      },
    );
  }

  void applyRecurrenceMutation(
    KanbanTaskCardResponse task,
    TaskMutationResponse<TaskRecurrenceResponse> mutation,
  ) {
    final current = _context.currentState;
    if (_context.isBoardClosed || current is! TasksBoardReady) return;
    final latest =
        TasksBoardCardStateMutator.findCard(current, task.id) ?? task;
    _context.publish(
      TasksBoardCardStateMutator.replaceCard(
        current,
        latest.copyWith(
          version: mutation.taskVersion,
          recurrence: TaskRecurrenceSummaryMapper.fromResponse(
            mutation.data,
            taskId: latest.id,
          ),
        ),
      ),
    );
  }
}
