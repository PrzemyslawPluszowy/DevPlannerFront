import 'dart:async';

import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Właściciel lifecycle snapshotu Kanbana oraz subskrypcji realtime.
final class TasksBoardRuntimeCoordinator {
  TasksBoardRuntimeCoordinator({
    required this._context,
    required this._repository,
    required this._realtime,
    this.workflowRepository,
    this.memberProfilesRepository,
  });

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final TaskProjectRealtime _realtime;
  final TaskWorkflowRepository? workflowRepository;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  StreamSubscription<TaskProjectRealtimeUpdate>? _updates;
  StreamSubscription<WorkspaceSignalRConnectionState>? _connections;
  StreamSubscription<WorkspaceScopedRealtimeError>? _realtimeErrors;
  Timer? _resyncDebounce;
  Set<String>? _allowedWorkflowTransitions;
  final Set<String> _seenRealtimeEventIds = <String>{};
  final List<String> _realtimeEventOrder = <String>[];
  final Map<String, int> _lastTaskVersions = <String, int>{};
  int _boardQueryRevision = 0;

  int get boardQueryRevision => _boardQueryRevision;

  Future<void> load({bool force = false}) async {
    final revision = ++_boardQueryRevision;
    if (_context.isBoardClosed ||
        (!force && _context.currentState is TasksBoardLoading)) {
      return;
    }
    if (_context.currentState is! TasksBoardReady) {
      _context.publish(const TasksBoardLoading());
    }
    final result = await _repository.getBoard(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
    );
    if (_context.isBoardClosed || revision != _boardQueryRevision) return;
    result.fold(
      (error) => _context.publish(_failure(error)),
      (board) {
        final previous = _context.currentState;
        _context.publish(
          TasksBoardReady(
            board: board,
            connectionState: previous is TasksBoardReady
                ? previous.connectionState
                : WorkspaceSignalRConnectionState.disconnected,
            presence: previous is TasksBoardReady
                ? previous.presence
                : const <TaskProjectPresenceUser>[],
            memberProfilesByUserId: previous is TasksBoardReady
                ? previous.memberProfilesByUserId
                : const {},
            userPreference: previous is TasksBoardReady
                ? previous.userPreference
                : null,
            realtimeRevision: previous is TasksBoardReady
                ? previous.realtimeRevision
                : 0,
            latestRealtimeMutation: previous is TasksBoardReady
                ? previous.latestRealtimeMutation
                : null,
          ),
        );
      },
    );
  }

  Future<void> start() async {
    await load();
    if (_context.isBoardClosed || _context.currentState is TasksBoardFailure) {
      return;
    }
    await _updates?.cancel();
    await _connections?.cancel();
    await _realtimeErrors?.cancel();
    _updates = _realtime.updates.listen(_onRealtimeUpdate);
    _connections = _realtime.connectionStates.listen(_onConnectionState);
    _realtimeErrors = _realtime.errors.listen((_) => _scheduleResync());
    await _realtime.start(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
    );
    unawaited(_loadUserPreference());
    unawaited(refreshWorkflow());
    unawaited(_loadMemberProfiles());
  }

  Future<void> refreshWorkflow() async {
    final repository = workflowRepository;
    if (repository == null) return;
    final result = await repository.getWorkflow(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
    );
    if (_context.isBoardClosed) return;
    result.fold(
      (_) {},
      (workflow) => _allowedWorkflowTransitions = {
        for (final transition in workflow.transitions)
          _transitionKey(transition.fromStatus, transition.toStatus),
      },
    );
  }

  bool canMoveTaskTo({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
  }) {
    final current = _context.currentState;
    if (current is TasksBoardReady &&
        current.pendingTaskIds.contains(task.id)) {
      return false;
    }
    final transitions = _allowedWorkflowTransitions;
    if (transitions == null ||
        task.customStatusId != null ||
        targetColumn.customStatusId != null ||
        task.status == targetColumn.status) {
      return true;
    }
    return transitions.contains(
      _transitionKey(task.status, targetColumn.status),
    );
  }

  Future<void> dispose() async {
    _resyncDebounce?.cancel();
    await _updates?.cancel();
    await _connections?.cancel();
    await _realtimeErrors?.cancel();
    await _realtime.dispose();
  }

  Future<void> _loadMemberProfiles() async {
    final repository = memberProfilesRepository;
    if (repository == null) return;
    final result = await repository.listProfiles(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      forceRefresh: true,
    );
    final current = _context.currentState;
    if (_context.isBoardClosed || current is! TasksBoardReady) return;
    result.fold(
      (_) {},
      (profiles) {
        final latest = _context.currentState;
        if (_context.isBoardClosed || latest is! TasksBoardReady) return;
        _context.publish(
          latest.copyWith(
            memberProfilesByUserId: {
              for (final profile in profiles) profile.userId: profile,
            },
          ),
        );
      },
    );
  }

  Future<void> _loadUserPreference() async {
    final result = await _repository.getUserPreference(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
    );
    final current = _context.currentState;
    if (_context.isBoardClosed || current is! TasksBoardReady) return;
    result.fold(
      (_) {},
      (preference) => _context.publish(
        current.copyWith(userPreference: preference),
      ),
    );
  }

  void _onConnectionState(WorkspaceSignalRConnectionState connectionState) {
    final current = _context.currentState;
    if (!_context.isBoardClosed && current is TasksBoardReady) {
      _context.publish(current.copyWith(connectionState: connectionState));
    }
  }

  void _onRealtimeUpdate(TaskProjectRealtimeUpdate update) {
    final current = _context.currentState;
    if (_context.isBoardClosed || current is! TasksBoardReady) return;
    switch (update) {
      case TaskProjectPresence(:final users):
        _context.publish(current.copyWith(presence: List.unmodifiable(users)));
      case TaskRealtimeMutation(
        :final type,
        :final eventId,
        :final taskId,
        :final version,
      ):
        if (!_acceptRealtimeMutation(eventId, taskId, version)) return;
        if (type == TaskRealtimeMutationType.updated) {
          _patchLoadedCard(update);
        } else {
          _context.publish(
            current.copyWith(
              realtimeRevision: current.realtimeRevision + 1,
              latestRealtimeMutation: update,
            ),
          );
          _scheduleResync();
        }
    }
  }

  bool _acceptRealtimeMutation(String eventId, String taskId, int version) {
    if (_seenRealtimeEventIds.contains(eventId)) return false;
    final lastVersion = _lastTaskVersions[taskId];
    if (lastVersion != null && version <= lastVersion) return false;
    _seenRealtimeEventIds.add(eventId);
    _realtimeEventOrder.add(eventId);
    if (_realtimeEventOrder.length > 500) {
      _seenRealtimeEventIds.remove(_realtimeEventOrder.removeAt(0));
    }
    _lastTaskVersions[taskId] = version;
    return true;
  }

  void _patchLoadedCard(TaskRealtimeMutation mutation) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    var changed = false;
    final columns = current.board.columns
        .map((column) {
          final cards = column.tasks
              .map((card) {
                if (card.id != mutation.taskId ||
                    card.version >= mutation.version) {
                  return card;
                }
                changed = true;
                return card.copyWith(
                  title: mutation.title ?? card.title,
                  priority: mutation.priority ?? card.priority,
                  dueAtUtc: mutation.hasDueAtUtc
                      ? mutation.dueAtUtc
                      : card.dueAtUtc,
                  position: mutation.position ?? card.position,
                  version: mutation.version,
                );
              })
              .toList(growable: false);
          return column.copyWith(tasks: cards);
        })
        .toList(growable: false);
    _context.publish(
      current.copyWith(
        board: changed ? current.board.copyWith(columns: columns) : null,
        realtimeRevision: current.realtimeRevision + 1,
        latestRealtimeMutation: mutation,
      ),
    );
  }

  void _scheduleResync() {
    _resyncDebounce?.cancel();
    _resyncDebounce = Timer(
      const Duration(milliseconds: 180),
      () => unawaited(_context.reloadBoard(force: true)),
    );
  }

  TasksBoardFailure _failure(ApiError error) => TasksBoardFailure(
    message: error.message,
    kind: switch (error.type) {
      ApiErrorType.forbidden ||
      ApiErrorType.unauthorized => TasksBoardFailureKind.forbidden,
      ApiErrorType.notFound => TasksBoardFailureKind.notFound,
      ApiErrorType.connectionTimeout ||
      ApiErrorType.sendTimeout ||
      ApiErrorType.receiveTimeout ||
      ApiErrorType.connection => TasksBoardFailureKind.offline,
      _ => TasksBoardFailureKind.other,
    },
    backendCode: error.backendCode?.toString(),
  );

  String _transitionKey(ProjectTaskStatus from, ProjectTaskStatus to) =>
      '${from.name}:${to.name}';
}
