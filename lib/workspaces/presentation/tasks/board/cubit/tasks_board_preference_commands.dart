import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Osobiste preferencje Kanbana, stronicowanie kolumn i szybkie tworzenie.
final class TasksBoardPreferenceCommands {
  TasksBoardPreferenceCommands({
    required this._context,
    required this._repository,
    required this._tasksRepository,
    this.taskTemplateRepository,
    required this._boardQueryRevision,
  });

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final TasksRepository _tasksRepository;
  final TaskTemplateRepository? taskTemplateRepository;
  final int Function() _boardQueryRevision;

  Future<void> toggleColumnCollapsed(KanbanColumnResponse column) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || current.savingUserPreference) return;
    final preference = current.userPreference;
    if (preference == null) return;
    final statuses = {...preference.collapsedColumns};
    final customStatuses = {...preference.collapsedCustomStatusIds};
    final isCustom = column.customStatusId != null;
    final wasCollapsed = isCustom
        ? customStatuses.contains(column.customStatusId)
        : statuses.contains(column.status);
    if (isCustom) {
      wasCollapsed
          ? customStatuses.remove(column.customStatusId)
          : customStatuses.add(column.customStatusId!);
    } else {
      wasCollapsed
          ? statuses.remove(column.status)
          : statuses.add(column.status);
    }
    final optimistic = preference.copyWith(
      collapsedColumns: statuses.toList(growable: false),
      collapsedCustomStatusIds: customStatuses.toList(growable: false),
    );
    _context.publish(
      current.copyWith(
        userPreference: optimistic,
        savingUserPreference: true,
        clearMutationError: true,
      ),
    );
    final result = await _repository.updateUserPreference(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: UpdateUserKanbanPreferencePayload(
        collapsedColumns: optimistic.collapsedColumns,
        collapsedCustomStatusIds: optimistic.collapsedCustomStatusIds,
        quickFilter: preference.quickFilter,
        expectedVersion: preference.version,
      ),
    );
    final ready = _context.currentState;
    if (_context.isBoardClosed || ready is! TasksBoardReady) return;
    result.fold(
      (error) => _context.publish(
        ready.copyWith(
          userPreference: preference,
          savingUserPreference: false,
          mutationError: error.message,
          mutationSerial: ready.mutationSerial + 1,
        ),
      ),
      (saved) => _context.publish(
        ready.copyWith(userPreference: saved, savingUserPreference: false),
      ),
    );
  }

  Future<void> setQuickFilter(KanbanQuickFilter quickFilter) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || current.savingUserPreference) return;
    final preference = current.userPreference;
    if (preference == null || preference.quickFilter == quickFilter) return;
    final optimistic = preference.copyWith(quickFilter: quickFilter);
    _context.publish(
      current.copyWith(
        userPreference: optimistic,
        savingUserPreference: true,
        clearMutationError: true,
      ),
    );
    final result = await _repository.updateUserPreference(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: UpdateUserKanbanPreferencePayload(
        collapsedColumns: preference.collapsedColumns,
        collapsedCustomStatusIds: preference.collapsedCustomStatusIds,
        quickFilter: quickFilter,
        expectedVersion: preference.version,
      ),
    );
    final ready = _context.currentState;
    if (_context.isBoardClosed || ready is! TasksBoardReady) return;
    await result.fold(
      (error) async => _context.publish(
        ready.copyWith(
          userPreference: preference,
          savingUserPreference: false,
          mutationError: error.message,
          mutationSerial: ready.mutationSerial + 1,
        ),
      ),
      (saved) async {
        _context.publish(
          ready.copyWith(userPreference: saved, savingUserPreference: false),
        );
        await _context.reloadBoard(force: true);
      },
    );
  }

  Future<void> loadMore(KanbanColumnResponse column) async {
    final current = _context.currentState;
    final cursor = column.nextCursor;
    final key = _columnKey(column);
    if (current is! TasksBoardReady ||
        cursor == null ||
        current.loadingColumnKeys.contains(key)) {
      return;
    }
    final queryRevision = _boardQueryRevision();
    _context.publish(
      current.copyWith(
        loadingColumnKeys: {...current.loadingColumnKeys, key},
        columnLoadErrors: {...current.columnLoadErrors}..remove(key),
      ),
    );
    final result = column.customStatusId == null
        ? await _repository.getSystemColumn(
            workspaceId: _context.workspaceId,
            projectId: _context.projectId,
            status: column.status,
            query: KanbanColumnQuery(cursor: cursor),
          )
        : await _repository.getCustomColumn(
            workspaceId: _context.workspaceId,
            projectId: _context.projectId,
            customStatusId: column.customStatusId!,
            query: KanbanColumnQuery(cursor: cursor),
          );
    final ready = _context.currentState;
    if (_context.isBoardClosed ||
        queryRevision != _boardQueryRevision() ||
        ready is! TasksBoardReady) {
      return;
    }
    result.fold(
      (error) => _finishColumnLoading(key, error.message),
      (page) {
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

  Future<bool> createQuickTask({
    required KanbanColumnResponse column,
    required String title,
    String? taskTemplateId,
    bool useDefaultTemplate = true,
  }) async {
    final current = _context.currentState;
    final normalizedTitle = title.trim();
    if (current is! TasksBoardReady || normalizedTitle.isEmpty) return false;
    final result = await _tasksRepository.quickCreateTask(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: QuickCreateProjectTaskPayload(
        title: normalizedTitle,
        targetStatus: column.customStatusId == null ? column.status : null,
        customStatusId: column.customStatusId,
        taskTemplateId: taskTemplateId,
        useDefaultTemplate: useDefaultTemplate,
      ),
    );
    if (_context.isBoardClosed) return false;
    var created = false;
    await result.fold(
      (error) async {
        final ready = _context.currentState;
        if (ready is TasksBoardReady) {
          _context.publish(
            ready.copyWith(
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
      },
      (_) async {
        created = true;
        await _context.reloadBoard(force: true);
      },
    );
    return created;
  }

  Future<bool> applyTaskTemplate({
    required String templateId,
    required String title,
  }) async {
    final current = _context.currentState;
    final repository = taskTemplateRepository;
    if (current is! TasksBoardReady || repository == null) return false;
    final result = await repository.apply(
      workspaceId: _context.workspaceId,
      templateId: templateId,
      payload: ApplyTaskTemplatePayload(
        projectId: _context.projectId,
        titleOverride: title.trim(),
      ),
    );
    if (_context.isBoardClosed) return false;
    return result.fold(
      (error) {
        final ready = _context.currentState;
        if (ready is TasksBoardReady) {
          _context.publish(
            ready.copyWith(
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
        return false;
      },
      (_) async {
        await _context.reloadBoard(force: true);
        return true;
      },
    );
  }

  void _finishColumnLoading(String key, String error) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    _context.publish(
      current.copyWith(
        loadingColumnKeys: {...current.loadingColumnKeys}..remove(key),
        columnLoadErrors: {...current.columnLoadErrors, key: error},
      ),
    );
  }

  String _columnKey(KanbanColumnResponse column) =>
      column.customStatusId ?? column.status.name;
}
