import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_api_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Doładowuje strony kolumn i odrzuca wyniki dla nieaktualnego zapytania.
final class TasksBoardColumnPageLoader {
  factory TasksBoardColumnPageLoader({
    required TasksBoardCommandContext context,
    required KanbanRepository repository,
    required int Function() queryRevision,
  }) => TasksBoardColumnPageLoader._(context, repository, queryRevision);

  TasksBoardColumnPageLoader._(
    this._context,
    this._repository,
    this._queryRevision,
  );

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final int Function() _queryRevision;
  final Map<String, int> _retryRevisionByColumn = <String, int>{};

  Future<void> loadMore(KanbanColumnResponse column) async {
    final current = _context.currentState;
    final key = _columnKey(column);
    if (current is! TasksBoardReady) return;
    final revision = _queryRevision();
    if (current.loadingColumnKeys.contains(key)) return;
    KanbanColumnResponse? currentColumn;
    for (final candidate in current.board.columns) {
      if (_columnKey(candidate) == key) {
        currentColumn = candidate;
        break;
      }
    }
    if (currentColumn == null || currentColumn.nextCursor == null) return;
    final previousError = current.columnLoadApiErrors[key];
    final retryAfter = previousError?.retryAfterUtc;
    if (_retryRevisionByColumn[key] == revision &&
        retryAfter != null &&
        retryAfter.isAfter(DateTime.now().toUtc())) {
      return;
    }
    if (_retryRevisionByColumn[key] != revision) {
      _retryRevisionByColumn.remove(key);
    }
    _context.publish(
      current.copyWith(
        loadingColumnKeys: {...current.loadingColumnKeys, key},
        columnLoadErrors: {...current.columnLoadErrors}..remove(key),
        columnLoadApiErrors: {...current.columnLoadApiErrors}..remove(key),
      ),
    );
    final query = current.filter.toColumnQuery(
      cursor: currentColumn.nextCursor,
    );
    final workspaceId = _context.workspaceId;
    final projectId = _context.projectId;
    final result = await _loadPage(
      column: currentColumn,
      workspaceId: workspaceId,
      projectId: projectId,
      query: query,
    );
    final ready = _context.currentState;
    if (_context.isBoardClosed ||
        workspaceId != _context.workspaceId ||
        projectId != _context.projectId ||
        revision != _queryRevision() ||
        ready is! TasksBoardReady) {
      return;
    }
    result.fold(
      (error) => _finishLoading(key, error, revision),
      (page) {
        _retryRevisionByColumn.remove(key);
        final columns = ready.board.columns
            .map((candidate) {
              if (_columnKey(candidate) != key) return candidate;
              final known = candidate.tasks.map((task) => task.id).toSet();
              return candidate.copyWith(
                tasks: [
                  ...candidate.tasks,
                  ...page.items.where((task) => known.add(task.id)),
                ],
                nextCursor: page.nextCursor,
              );
            })
            .toList(growable: false);
        _context.publish(
          ready.copyWith(
            board: ready.board.copyWith(columns: columns),
            loadingColumnKeys: {...ready.loadingColumnKeys}..remove(key),
          ),
        );
      },
    );
  }

  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  _loadPage({
    required KanbanColumnResponse column,
    required String workspaceId,
    required String projectId,
    required KanbanColumnQuery query,
  }) async {
    try {
      return column.customStatusId == null
          ? await _repository.getSystemColumn(
              workspaceId: workspaceId,
              projectId: projectId,
              status: column.status,
              query: query,
            )
          : await _repository.getCustomColumn(
              workspaceId: workspaceId,
              projectId: projectId,
              customStatusId: column.customStatusId!,
              query: query,
            );
    } on Object catch (error) {
      return Left(
        TasksBoardApiErrorNormalizer.fromThrown(
          error,
          fallbackMessage:
              TasksBoardApiErrorNormalizer.columnPageFallbackMessage,
        ),
      );
    }
  }

  void _finishLoading(String key, ApiError error, int revision) {
    _retryRevisionByColumn[key] = revision;
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    _context.publish(
      current.copyWith(
        loadingColumnKeys: {...current.loadingColumnKeys}..remove(key),
        columnLoadErrors: {...current.columnLoadErrors, key: error.message},
        columnLoadApiErrors: {...current.columnLoadApiErrors, key: error},
      ),
    );
  }

  String _columnKey(KanbanColumnResponse column) =>
      column.customStatusId ?? column.status.name;
}
