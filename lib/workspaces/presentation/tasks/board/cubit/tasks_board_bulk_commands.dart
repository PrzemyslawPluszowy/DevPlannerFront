import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

/// Atomowe operacje zaznaczenia z jawnym stanem zapisu i ponowienia.
final class TasksBoardBulkCommands {
  TasksBoardBulkCommands({
    required this._context,
    required this._repository,
    required this._tasksRepository,
    required this._boardQueryRevision,
    required this._scopeRevision,
    this.calendarTimeZoneId,
  });

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final TasksRepository _tasksRepository;
  final int Function() _boardQueryRevision;
  final int Function() _scopeRevision;
  final String? calendarTimeZoneId;
  bool _inFlight = false;
  Future<void> Function()? _retry;
  TasksBoardReady? _failedScope;
  Set<String> _failedIds = const {};

  void toggleSelection(KanbanTaskCardResponse task) {
    final current = _context.currentState;
    if (current is! TasksBoardReady || _inFlight || current.isBulkSaving) {
      return;
    }
    final selected = {...current.selectedTaskIds};
    selected.contains(task.id)
        ? selected.remove(task.id)
        : selected.add(task.id);
    _selectionChanged(current, selected);
  }

  void clearSelection() {
    final current = _context.currentState;
    if (current is! TasksBoardReady ||
        _inFlight ||
        current.isBulkSaving ||
        current.selectedTaskIds.isEmpty) {
      return;
    }
    _selectionChanged(current, const {});
  }

  void selectAllLoaded() {
    final current = _context.currentState;
    if (current is! TasksBoardReady || _inFlight || current.isBulkSaving) {
      return;
    }
    _selectionChanged(current, {
      for (final task in _loadedCards(current)) task.id,
    });
  }

  void _selectionChanged(TasksBoardReady current, Set<String> selected) {
    _retry = null;
    _context.publish(
      current.copyWith(
        selectedTaskIds: selected,
        clearBulkError: true,
        canRetryBulk: false,
      ),
    );
  }

  Future<void> retryBulkOperation() async {
    final current = _context.currentState;
    final retry = _retry;
    if (_inFlight ||
        _context.isBoardClosed ||
        retry == null ||
        current is! TasksBoardReady ||
        !current.canRetryBulk ||
        !_sameScope(current, _failedScope) ||
        current.selectedTaskIds.length != _failedIds.length ||
        !current.selectedTaskIds.containsAll(_failedIds)) {
      return;
    }
    await retry();
  }

  Future<void> bulkMove(KanbanColumnResponse targetColumn) => _run(
    (current) => _repository.bulkMove(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: BulkMoveKanbanTasksPayload(
        targetStatus: targetColumn.status,
        customStatusId: targetColumn.customStatusId,
        tasks: [
          for (final card in _selectedCards(current))
            BulkMoveKanbanTaskItemPayload(
              taskId: card.id,
              expectedVersion: card.version,
            ),
        ],
      ),
    ),
    retry: () => bulkMove(targetColumn),
  );

  Future<void> bulkUpdatePriority(TaskPriority priority) =>
      _bulkUpdate(priority: priority);
  Future<void> bulkUpdateDueDate(DateTime dueAtUtc) =>
      _bulkUpdate(dueAtUtc: dueAtUtc.toUtc());

  Future<void> bulkClearDueDate() => _run(
    (current) => _tasksRepository.bulkUpdateTaskSelection(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: BulkUpdateTaskSelectionPayload(
        selectionToken: '',
        clearDueAtUtc: true,
        calendarTimeZoneId: calendarTimeZoneId,
        tasks: [
          for (final card in _selectedCards(current))
            BulkUpdateTaskItemPayload(
              taskId: card.id,
              expectedVersion: card.version,
            ),
        ],
        returnTaskIds: [for (final card in _selectedCards(current)) card.id],
      ),
    ),
    retry: bulkClearDueDate,
  );

  Future<void> _bulkUpdate({TaskPriority? priority, DateTime? dueAtUtc}) =>
      _run(
        (current) => _repository.bulkUpdate(
          workspaceId: _context.workspaceId,
          projectId: _context.projectId,
          payload: BulkUpdateKanbanTasksPayload(
            priority: priority,
            dueAtUtc: dueAtUtc,
            calendarTimeZoneId: dueAtUtc == null ? null : calendarTimeZoneId,
            tasks: [
              for (final card in _selectedCards(current))
                BulkUpdateKanbanTaskItemPayload(
                  taskId: card.id,
                  expectedVersion: card.version,
                ),
            ],
          ),
        ),
        retry: () => _bulkUpdate(priority: priority, dueAtUtc: dueAtUtc),
      );

  Future<void> _run<T>(
    Future<Either<ApiError, T>> Function(TasksBoardReady) operation, {
    required Future<void> Function() retry,
  }) async {
    final initial = _context.currentState;
    if (_context.isBoardClosed ||
        _inFlight ||
        initial is! TasksBoardReady ||
        initial.isBulkSaving ||
        initial.pendingTaskIds.isNotEmpty ||
        initial.selectedTaskIds.isEmpty) {
      return;
    }
    final cards = _selectedCards(initial);
    if (cards.isEmpty) {
      return;
    }
    if (cards.length > 100) {
      _context.publish(
        initial.copyWith(
          bulkError: const TasksViewError(
            code: 'tasks.bulk.kanban_selection_limit',
            canRetry: false,
          ),
          canRetryBulk: false,
        ),
      );
      return;
    }
    final revision = _scopeRevision();
    _retry = null;
    _inFlight = true;
    _context.publish(
      initial.copyWith(
        isBulkSaving: true,
        clearBulkError: true,
        canRetryBulk: false,
      ),
    );
    try {
      final result = await operation(initial);
      final current = _context.currentState;
      if (_context.isBoardClosed ||
          current is! TasksBoardReady ||
          revision != _scopeRevision() ||
          !_sameScope(current, initial)) {
        return;
      }
      await result.fold(
        (error) async {
          _failedScope = current;
          _failedIds = Set.unmodifiable(current.selectedTaskIds);
          final allowed =
              error.type != ApiErrorType.unauthorized &&
              error.type != ApiErrorType.forbidden &&
              error.type != ApiErrorType.notFound;
          _retry = allowed ? retry : null;
          _context.publish(
            current.copyWith(
              isBulkSaving: false,
              bulkError: tasksViewErrorFrom(error, canRetry: allowed),
              canRetryBulk: allowed,
            ),
          );
        },
        (_) async {
          final saved = current.copyWith(
            selectedTaskIds: current.selectedTaskIds.difference(
              initial.selectedTaskIds,
            ),
            clearBulkError: true,
            canRetryBulk: false,
          );
          _context.publish(saved);
          await _refreshSaved(saved);
        },
      );
    } catch (_) {
      final current = _context.currentState;
      if (!_context.isBoardClosed &&
          current is TasksBoardReady &&
          revision == _scopeRevision() &&
          _sameScope(current, initial)) {
        _failedScope = current;
        _failedIds = Set.unmodifiable(current.selectedTaskIds);
        _retry = retry;
        _context.publish(
          current.copyWith(
            bulkError: const TasksViewError(code: 'tasks.bulk.save_failed'),
            canRetryBulk: true,
          ),
        );
      }
    } finally {
      _inFlight = false;
      final current = _context.currentState;
      if (!_context.isBoardClosed &&
          current is TasksBoardReady &&
          current.isBulkSaving) {
        _context.publish(current.copyWith(isBulkSaving: false));
      }
    }
  }

  /// Po udanym zapisie ponawiamy tylko odczyt, nigdy samą mutację.
  Future<void> _refreshSaved(TasksBoardReady saved) async {
    final revision = _boardQueryRevision();
    final scopeRevision = _scopeRevision();
    try {
      await _context.reloadActiveBoard(force: true);
      if (_context.isBoardClosed ||
          _scopeRevision() != scopeRevision ||
          _boardQueryRevision() != revision + 1) {
        return;
      }
      if (_context.currentState is! TasksBoardFailure) {
        return;
      }
    } catch (_) {
      if (_context.isBoardClosed ||
          _scopeRevision() != scopeRevision ||
          _boardQueryRevision() != revision + 1) {
        return;
      }
    }
    _failedScope = saved;
    _failedIds = Set.unmodifiable(saved.selectedTaskIds);
    _retry = () {
      final current = _context.currentState;
      if (current is! TasksBoardReady) return Future<void>.value();
      return _retryRefresh(current);
    };
    _context.publish(
      saved.copyWith(
        isBulkSaving: false,
        bulkError: const TasksViewError(
          code: TasksViewErrorCodes.boardRefreshFailed,
        ),
        canRetryBulk: true,
      ),
    );
  }

  Future<void> _retryRefresh(TasksBoardReady saved) async {
    if (_inFlight) {
      return;
    }
    _inFlight = true;
    _context.publish(
      saved.copyWith(
        isBulkSaving: true,
        clearBulkError: true,
        canRetryBulk: false,
      ),
    );
    try {
      await _refreshSaved(saved);
    } finally {
      _inFlight = false;
      final current = _context.currentState;
      if (!_context.isBoardClosed && current is TasksBoardReady) {
        _context.publish(current.copyWith(isBulkSaving: false));
      }
    }
  }

  bool _sameScope(TasksBoardReady current, TasksBoardReady? initial) =>
      initial != null &&
      current.filter == initial.filter &&
      current.grouping == initial.grouping;

  List<KanbanTaskCardResponse> _selectedCards(TasksBoardReady state) => [
    for (final task in _loadedCards(state))
      if (state.selectedTaskIds.contains(task.id)) task,
  ];

  List<KanbanTaskCardResponse> _loadedCards(TasksBoardReady state) {
    final cards = state.grouping == TasksBoardGrouping.assignee
        ? [
            for (final group
                in state.assigneeBoard?.groups ??
                    <AssigneeKanbanGroupResponse>[])
              ...group.tasks,
          ]
        : [for (final column in state.board.columns) ...column.tasks];
    final byId = <String, KanbanTaskCardResponse>{};
    for (final card in cards) {
      if (card.version >= (byId[card.id]?.version ?? 0)) byId[card.id] = card;
    }
    return byId.values.toList(growable: false);
  }
}
