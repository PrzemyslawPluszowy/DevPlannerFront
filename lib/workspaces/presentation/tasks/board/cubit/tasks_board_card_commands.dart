import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_mutation_executor.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/task_recurrence_summary.dart';

/// Intencje pojedynczej karty, ze wspólnym lifecycle zapisu.
final class TasksBoardCardCommands {
  TasksBoardCardCommands({
    required TasksBoardCommandContext context,
    required int Function() scopeRevision,
    required Future<void> Function() refreshAssigneeBoard,
    this.calendarTimeZoneId,
    required this._tasksRepository,
    this.collaborationRepository,
  }) : _context = context,
       _executor = TasksBoardCardMutationExecutor(
         context: context,
         scopeRevision: scopeRevision,
         refreshAssigneeBoard: refreshAssigneeBoard,
       );
  final TasksBoardCommandContext _context;
  final String? calendarTimeZoneId;
  final TasksRepository _tasksRepository;
  final TaskCollaborationRepository? collaborationRepository;
  final TasksBoardCardMutationExecutor _executor;

  Future<bool> togglePinned(KanbanTaskCardResponse task) {
    final repository = collaborationRepository;
    if (repository == null) return Future.value(false);
    late bool desired;
    return _executor.run<Unit>(
      taskId: task.id,
      operation: (current) {
        desired = !current.isPinned;
        return repository.updatePinned(
          workspaceId: _context.workspaceId,
          projectId: _context.projectId,
          taskId: current.id,
          isPinned: desired,
        );
      },
      apply: (state, current, _) => TasksBoardCardStateMutator.replaceCard(
        state,
        current.copyWith(isPinned: desired),
      ),
    );
  }

  Future<bool> toggleWatching(KanbanTaskCardResponse task) {
    final repository = collaborationRepository;
    if (repository == null) return Future.value(false);
    late bool desired;
    return _executor.run<_WatchResult>(
      taskId: task.id,
      operation: (current) async {
        desired = !current.isWatchedByMe;
        final result = desired
            ? await repository.follow(
                workspaceId: _context.workspaceId,
                projectId: _context.projectId,
                taskId: current.id,
                expectedVersion: current.version,
              )
            : await repository.unfollow(
                workspaceId: _context.workspaceId,
                projectId: _context.projectId,
                taskId: current.id,
                expectedVersion: current.version,
              );
        return result.fold<Future<Either<ApiError, _WatchResult>>>(
          (error) async => Left(error),
          (mutation) async {
            if (mutation.data.changed) return Right(_WatchResult(mutation));
            // Idempotentny sukces nie dostarcza liczby obserwatorów. Nie
            // zgadujemy +/-1; odczytujemy istniejący kontrakt listy.
            try {
              final watchers = await repository.listWatchers(
                workspaceId: _context.workspaceId,
                projectId: _context.projectId,
                taskId: current.id,
              );
              return watchers.fold<Either<ApiError, _WatchResult>>(
                (error) => Right(_WatchResult(mutation, refreshError: error)),
                (items) =>
                    Right(_WatchResult(mutation, watcherCount: items.length)),
              );
            } catch (_) {
              return Right(
                _WatchResult(
                  mutation,
                  refreshError: const ApiError(
                    type: ApiErrorType.unknown,
                    message: 'tasks.bulk.save_failed',
                  ),
                ),
              );
            }
          },
        );
      },
      apply: (state, current, result) {
        if (current.version > result.mutation.taskVersion) return state;
        if (result.refreshError != null) {
          return state.copyWith(
            error: tasksViewErrorFrom(result.refreshError!),
          );
        }
        final count =
            result.watcherCount ??
            (result.mutation.data.changed && current.isWatchedByMe != desired
                ? (current.watcherCount + (desired ? 1 : -1)).clamp(0, 1 << 31)
                : current.watcherCount);
        final updated = TasksBoardCardStateMutator.replaceCard(
          state,
          current.copyWith(
            isWatchedByMe: desired,
            watcherCount: count,
            version: result.mutation.taskVersion,
          ),
        );
        return updated;
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
          calendarTimeZoneId: calendarTimeZoneId,
          clearDueAtUtc: dueAtUtc == null,
          expectedVersion: card.version,
        ),
      );

  Future<bool> replaceAssignees(String taskId, List<String> userIds) {
    final repository = collaborationRepository;
    if (repository == null) return Future.value(false);
    final intended = List<String>.unmodifiable(userIds);
    return _executor.run<TaskMutationResponse<ProjectTaskResponse>>(
      refreshPersonsAfterSuccess: true,
      taskId: taskId,
      operation: (card) => repository.replaceAssignees(
        workspaceId: _context.workspaceId,
        projectId: _context.projectId,
        taskId: card.id,
        userIds: intended,
        expectedVersion: card.version,
      ),
      apply: (state, current, mutation) {
        if (current.version > mutation.data.version) return state;
        final primary =
            mutation.data.assignees
                .where((assignee) => assignee.isPrimary)
                .firstOrNull ??
            mutation.data.assignees.firstOrNull;
        return TasksBoardCardStateMutator.replaceCard(
          state,
          current.copyWith(
            primaryAssigneeUserId: primary?.userId,
            assigneeUserIds: mutation.data.assignees
                .map((assignee) => assignee.userId)
                .toList(growable: false),
            version: mutation.data.version,
          ),
        );
      },
    );
  }

  Future<bool> _updateListItem(
    String taskId,
    UpdateTaskListItemPayload Function(KanbanTaskCardResponse) payload,
  ) => _executor.run<TaskMutationResponse<ProjectTaskListItemResponse>>(
    taskId: taskId,
    operation: (card) => _tasksRepository.updateListItem(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      taskId: card.id,
      payload: payload(card),
    ),
    apply: (state, current, mutation) => current.version > mutation.data.version
        ? state
        : TasksBoardCardStateMutator.replaceCard(
            state,
            current.copyWith(
              priority: mutation.data.priority,
              dueAtUtc: mutation.data.dueAtUtc,
              version: mutation.data.version,
            ),
          ),
  );

  void applyRecurrenceMutation(
    KanbanTaskCardResponse task,
    TaskMutationResponse<TaskRecurrenceResponse> mutation,
  ) {
    final current = _context.currentState;
    if (_context.isBoardClosed || current is! TasksBoardReady) return;
    final latest = TasksBoardCardStateMutator.findCard(current, task.id);
    if (latest == null || latest.version > mutation.taskVersion) return;
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

/// HTTP sukces watch jest niezależny od wyniku dodatkowego odczytu licznika.
final class _WatchResult {
  const _WatchResult(this.mutation, {this.watcherCount, this.refreshError});
  final TaskMutationResponse<TaskMutationAcknowledgementResponse> mutation;
  final int? watcherCount;
  final ApiError? refreshError;
}
