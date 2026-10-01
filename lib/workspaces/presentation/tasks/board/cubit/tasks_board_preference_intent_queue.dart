import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_api_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

/// Serializuje osobiste preferencje i ponawia konflikt na świeżej wersji.
final class TasksBoardPreferenceIntentQueue {
  TasksBoardPreferenceIntentQueue({
    required this._context,
    required this._repository,
  });

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final List<_PreferenceIntent> _pending = [];
  bool _saving = false;
  UserKanbanPreferenceResponse? _serverBase;
  DateTime? _retryAfterUtc;
  TasksViewError? _cooldownError;

  bool get hasPendingIntents => _pending.isNotEmpty;

  Future<void> toggleColumnCollapsed(KanbanColumnResponse column) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final preference = current.userPreference;
    if (preference == null) return;
    final customStatusId = column.customStatusId;
    final wasCollapsed = customStatusId != null
        ? preference.collapsedCustomStatusIds.contains(customStatusId)
        : preference.collapsedColumns.contains(column.status);
    await _submit(
      _ColumnCollapseIntent(
        collapsed: !wasCollapsed,
        status: customStatusId == null ? column.status : null,
        customStatusId: customStatusId,
      ),
    );
  }

  Future<void> setQuickFilter(KanbanQuickFilter quickFilter) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final preference = current.userPreference;
    if (preference == null || preference.quickFilter == quickFilter) return;
    await _submit(_QuickFilterIntent(quickFilter));
  }

  Future<void> retryPending() async {
    if (_pending.isEmpty) return;
    if (_isRetryBlocked) return;
    _clearRetryGate();
    _publishOptimistic();
    await _drain();
  }

  Future<void> _submit(_PreferenceIntent intent) async {
    _pending.add(intent);
    _publishOptimistic();
    await _drain();
  }

  Future<void> _drain() async {
    if (_saving || _context.isBoardClosed) return;
    if (_isRetryBlocked) {
      final error = _cooldownError;
      if (error != null) _publishFailure(error);
      return;
    }
    _clearRetryGate();
    final workspaceId = _context.workspaceId;
    final projectId = _context.projectId;
    _saving = true;
    try {
      while (_pending.isNotEmpty && _isCurrentScope(workspaceId, projectId)) {
        final batch = List<_PreferenceIntent>.unmodifiable(_pending);
        final base = _basePreference();
        if (base == null) break;
        final outcome = await _save(
          batch: batch,
          base: base,
          rebaseOnConflict: true,
          workspaceId: workspaceId,
          projectId: projectId,
        );
        if (!_isCurrentScope(workspaceId, projectId)) return;
        switch (outcome) {
          case _PreferenceSaved(:final preference):
            _pending.removeRange(0, batch.length);
            _serverBase = _pending.isEmpty ? null : preference;
            _clearRetryGate();
            _publishPending(base: preference, saving: _pending.isNotEmpty);
            if (batch.any((intent) => intent is _QuickFilterIntent)) {
              try {
                await _context.reloadActiveBoard(force: true);
                if (!_isCurrentScope(workspaceId, projectId)) return;
              } on Object catch (error) {
                if (!_isCurrentScope(workspaceId, projectId)) return;
                _publishFailure(
                  tasksViewErrorFrom(
                    TasksBoardApiErrorNormalizer.fromThrown(
                      error,
                      fallbackMessage: 'The board could not be refreshed.',
                    ),
                  ),
                );
              }
            }
          case _PreferenceFailed(:final error, :final preference):
            _serverBase = preference;
            _publishFailure(error);
        }
        if (outcome is! _PreferenceSaved) return;
      }
    } finally {
      _saving = false;
    }
  }

  Future<_PreferenceOutcome> _save({
    required List<_PreferenceIntent> batch,
    required UserKanbanPreferenceResponse base,
    required bool rebaseOnConflict,
    required String workspaceId,
    required String projectId,
  }) async {
    late final Either<ApiError, UserKanbanPreferenceResponse> result;
    try {
      result = await _write(
        batch: batch,
        base: base,
        workspaceId: workspaceId,
        projectId: projectId,
      );
    } on Object catch (error) {
      if (!_isCurrentScope(workspaceId, projectId)) {
        return const _PreferenceFailed(
          TasksViewError(code: TasksViewErrorCodes.loadFailed),
          preference: null,
        );
      }
      final apiError = TasksBoardApiErrorNormalizer.fromThrown(
        error,
        fallbackMessage: 'Board preferences could not be saved.',
      );
      _setRetryGate(apiError);
      return _PreferenceFailed(tasksViewErrorFrom(apiError), preference: base);
    }
    if (!_isCurrentScope(workspaceId, projectId)) {
      return const _PreferenceFailed(
        TasksViewError(code: TasksViewErrorCodes.loadFailed),
        preference: null,
      );
    }
    final failure = result.fold((error) => error, (_) => null);
    if (failure == null) {
      return _PreferenceSaved(result.getOrElse(() => base));
    }
    if (!isTaskSettingsVersionConflict(failure)) {
      _setRetryGate(failure);
      return _PreferenceFailed(tasksViewErrorFrom(failure), preference: base);
    }
    _setRetryGate(failure);
    if (_isRetryBlocked) {
      return _PreferenceFailed(tasksViewErrorFrom(failure), preference: base);
    }
    if (!rebaseOnConflict) {
      return _PreferenceFailed(
        TasksViewError(
          code: TasksViewErrorCodes.versionConflict,
          traceId: failure.traceId,
          apiError: failure,
        ),
        preference: base,
      );
    }

    late final Either<ApiError, UserKanbanPreferenceResponse> refreshed;
    try {
      refreshed = await _repository.getUserPreference(
        workspaceId: workspaceId,
        projectId: projectId,
      );
    } on Object catch (error) {
      if (!_isCurrentScope(workspaceId, projectId)) {
        return const _PreferenceFailed(
          TasksViewError(code: TasksViewErrorCodes.loadFailed),
          preference: null,
        );
      }
      final apiError = TasksBoardApiErrorNormalizer.fromThrown(
        error,
        fallbackMessage: 'Board preferences could not be refreshed.',
      );
      _setRetryGate(apiError);
      return _PreferenceFailed(tasksViewErrorFrom(apiError), preference: base);
    }
    if (!_isCurrentScope(workspaceId, projectId)) {
      return _PreferenceFailed(tasksViewErrorFrom(failure), preference: null);
    }
    final refreshFailure = refreshed.fold((error) => error, (_) => null);
    if (refreshFailure != null) {
      _setRetryGate(refreshFailure);
      return _PreferenceFailed(
        tasksViewErrorFrom(refreshFailure),
        preference: base,
      );
    }
    final fresh = refreshed.getOrElse(() => base);
    return _save(
      batch: batch,
      base: fresh,
      rebaseOnConflict: false,
      workspaceId: workspaceId,
      projectId: projectId,
    );
  }

  Future<Either<ApiError, UserKanbanPreferenceResponse>> _write({
    required List<_PreferenceIntent> batch,
    required UserKanbanPreferenceResponse base,
    required String workspaceId,
    required String projectId,
  }) {
    final desired = _applyIntents(batch, base);
    return _repository.updateUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: UpdateUserKanbanPreferencePayload(
        collapsedColumns: desired.collapsedColumns,
        collapsedCustomStatusIds: desired.collapsedCustomStatusIds,
        quickFilter: desired.quickFilter,
        expectedVersion: base.version,
      ),
    );
  }

  UserKanbanPreferenceResponse _applyIntents(
    List<_PreferenceIntent> intents,
    UserKanbanPreferenceResponse base,
  ) => intents.fold(base, (acc, intent) => intent.applyTo(acc));

  UserKanbanPreferenceResponse? _basePreference() {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return null;
    return _serverBase ??= current.userPreference;
  }

  void _publishOptimistic() => _publishPending(
    saving: !_isRetryBlocked,
    clearError: !_isRetryBlocked,
  );

  void _publishPending({
    required bool saving,
    bool clearError = true,
    UserKanbanPreferenceResponse? base,
  }) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final resolved = base ?? _basePreference();
    if (resolved == null) return;
    _context.publish(
      current.copyWith(
        userPreference: _applyIntents(_pending, resolved),
        savingUserPreference: saving,
        clearError: clearError,
      ),
    );
  }

  void _publishFailure(TasksViewError error) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final base = _basePreference();
    _context.publish(
      current.copyWith(
        userPreference: base == null
            ? current.userPreference
            : _applyIntents(_pending, base),
        savingUserPreference: false,
        error: error,
      ),
    );
  }

  bool get _isRetryBlocked {
    final retryAfter = _retryAfterUtc;
    return retryAfter != null && retryAfter.isAfter(DateTime.now().toUtc());
  }

  void _setRetryGate(ApiError error) {
    _retryAfterUtc = error.retryAfterUtc;
    _cooldownError = tasksViewErrorFrom(error);
  }

  void _clearRetryGate() {
    _retryAfterUtc = null;
    _cooldownError = null;
  }

  bool _isCurrentScope(String workspaceId, String projectId) =>
      !_context.isBoardClosed &&
      workspaceId == _context.workspaceId &&
      projectId == _context.projectId;
}

sealed class _PreferenceIntent {
  const _PreferenceIntent();

  UserKanbanPreferenceResponse applyTo(UserKanbanPreferenceResponse base);
}

final class _ColumnCollapseIntent extends _PreferenceIntent {
  const _ColumnCollapseIntent({
    required this.collapsed,
    this.status,
    this.customStatusId,
  }) : assert(
         status != null || customStatusId != null,
         'Wskaż status systemowy lub własny status.',
       );

  final bool collapsed;
  final ProjectTaskStatus? status;
  final String? customStatusId;

  @override
  UserKanbanPreferenceResponse applyTo(UserKanbanPreferenceResponse base) {
    final statuses = {...base.collapsedColumns};
    final customStatuses = {...base.collapsedCustomStatusIds};
    if (customStatusId case final id?) {
      collapsed ? customStatuses.add(id) : customStatuses.remove(id);
    } else if (status case final columnStatus?) {
      collapsed ? statuses.add(columnStatus) : statuses.remove(columnStatus);
    }
    return base.copyWith(
      collapsedColumns: statuses.toList(growable: false),
      collapsedCustomStatusIds: customStatuses.toList(growable: false),
    );
  }
}

final class _QuickFilterIntent extends _PreferenceIntent {
  const _QuickFilterIntent(this.quickFilter);

  final KanbanQuickFilter quickFilter;

  @override
  UserKanbanPreferenceResponse applyTo(UserKanbanPreferenceResponse base) =>
      base.copyWith(quickFilter: quickFilter);
}

sealed class _PreferenceOutcome {
  const _PreferenceOutcome();
}

final class _PreferenceSaved extends _PreferenceOutcome {
  const _PreferenceSaved(this.preference);

  final UserKanbanPreferenceResponse preference;
}

final class _PreferenceFailed extends _PreferenceOutcome {
  const _PreferenceFailed(this.error, {required this.preference});

  final TasksViewError error;
  final UserKanbanPreferenceResponse? preference;
}
