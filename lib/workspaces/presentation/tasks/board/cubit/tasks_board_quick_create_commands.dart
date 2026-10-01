import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_api_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

/// Obsługuje tworzenie zadania z Kanbana i publikuje typowane błędy operacji.
final class TasksBoardQuickCreateCommands {
  factory TasksBoardQuickCreateCommands({
    required TasksBoardCommandContext context,
    required TasksRepository tasksRepository,
    required TaskTemplateRepository? taskTemplateRepository,
    required int Function() boardQueryRevision,
  }) => TasksBoardQuickCreateCommands._(
    context,
    tasksRepository,
    taskTemplateRepository,
    boardQueryRevision,
  );

  TasksBoardQuickCreateCommands._(
    this._context,
    this._tasksRepository,
    this._taskTemplateRepository,
    this._boardQueryRevision,
  );

  final TasksBoardCommandContext _context;
  final TasksRepository _tasksRepository;
  final TaskTemplateRepository? _taskTemplateRepository;
  final int Function() _boardQueryRevision;

  /// Tworzy zadanie w kolumnie i zostawia błąd w stanie tablicy do odczytu.
  Future<bool> createQuickTask({
    required KanbanColumnResponse column,
    required String title,
    String? taskTemplateId,
    bool useDefaultTemplate = true,
  }) async {
    final current = _context.currentState;
    final normalizedTitle = title.trim();
    if (_context.isBoardClosed ||
        current is! TasksBoardReady ||
        normalizedTitle.isEmpty) {
      return false;
    }
    final workspaceId = _context.workspaceId;
    final projectId = _context.projectId;
    final queryRevision = _boardQueryRevision();

    final Either<ApiError, TaskMutationResponse<ProjectTaskResponse>> result;
    try {
      result = await _tasksRepository.quickCreateTask(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: QuickCreateProjectTaskPayload(
          title: normalizedTitle,
          targetStatus: column.customStatusId == null ? column.status : null,
          customStatusId: column.customStatusId,
          taskTemplateId: taskTemplateId,
          useDefaultTemplate: useDefaultTemplate,
        ),
      );
    } on Object catch (error) {
      _publishFailureIfCurrent(
        TasksBoardApiErrorNormalizer.fromThrown(
          error,
          fallbackMessage: 'Task creation failed.',
        ),
        workspaceId,
        projectId,
        queryRevision,
      );
      return false;
    }
    if (_context.isBoardClosed || !_hasSameScope(workspaceId, projectId)) {
      return false;
    }
    return result.fold<Future<bool>>(
      (error) async {
        _publishFailureIfCurrent(error, workspaceId, projectId, queryRevision);
        return false;
      },
      (_) => _finishCreatedTask(workspaceId, projectId, queryRevision),
    );
  }

  /// Zastosowuje szablon i zachowuje diagnostykę odmowy lub awarii transportu.
  Future<bool> applyTaskTemplate({
    required String templateId,
    required String title,
  }) async {
    final current = _context.currentState;
    final repository = _taskTemplateRepository;
    if (_context.isBoardClosed ||
        current is! TasksBoardReady ||
        repository == null) {
      return false;
    }
    final workspaceId = _context.workspaceId;
    final projectId = _context.projectId;
    final queryRevision = _boardQueryRevision();

    final Either<ApiError, ProjectTaskResponse> result;
    try {
      result = await repository.apply(
        workspaceId: workspaceId,
        templateId: templateId,
        payload: ApplyTaskTemplatePayload(
          projectId: projectId,
          titleOverride: title.trim(),
        ),
      );
    } on Object catch (error) {
      _publishFailureIfCurrent(
        TasksBoardApiErrorNormalizer.fromThrown(
          error,
          fallbackMessage: 'Task template could not be applied.',
        ),
        workspaceId,
        projectId,
        queryRevision,
      );
      return false;
    }
    if (_context.isBoardClosed || !_hasSameScope(workspaceId, projectId)) {
      return false;
    }
    return result.fold<Future<bool>>(
      (error) async {
        _publishFailureIfCurrent(error, workspaceId, projectId, queryRevision);
        return false;
      },
      (_) => _finishCreatedTask(workspaceId, projectId, queryRevision),
    );
  }

  void _publishFailure(ApiError error) {
    _publishTaskError(
      error,
      displayCode: TasksViewErrorCodes.quickCreateFailed,
    );
  }

  Future<bool> _finishCreatedTask(
    String workspaceId,
    String projectId,
    int queryRevision,
  ) async {
    if (!_hasSameScope(workspaceId, projectId)) return false;
    if (queryRevision != _boardQueryRevision()) return true;
    final refreshBaseRevision = _boardQueryRevision();
    try {
      await _context.reloadActiveBoard(force: true);
    } on Object catch (error) {
      if (!_hasSameScope(workspaceId, projectId) ||
          _boardQueryRevision() != refreshBaseRevision + 1) {
        return true;
      }
      _publishTaskError(
        TasksBoardApiErrorNormalizer.fromThrown(
          error,
          fallbackMessage: 'Task created, but board refresh failed.',
        ),
        displayCode: TasksViewErrorCodes.boardRefreshFailed,
        canRetry: false,
      );
    }
    return true;
  }

  void _publishTaskError(
    ApiError error, {
    required String displayCode,
    bool canRetry = true,
  }) {
    if (_context.isBoardClosed) return;
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    _context.publish(
      current.copyWith(
        error: tasksViewErrorFrom(
          error,
          displayCode: displayCode,
          canRetry: canRetry,
        ),
      ),
    );
  }

  void _publishFailureIfCurrent(
    ApiError error,
    String workspaceId,
    String projectId,
    int queryRevision,
  ) {
    if (!_isCurrent(workspaceId, projectId, queryRevision)) return;
    _publishFailure(error);
  }

  bool _isCurrent(String workspaceId, String projectId, int queryRevision) =>
      _hasSameScope(workspaceId, projectId) &&
      queryRevision == _boardQueryRevision();

  bool _hasSameScope(String workspaceId, String projectId) =>
      !_context.isBoardClosed &&
      workspaceId == _context.workspaceId &&
      projectId == _context.projectId;
}
