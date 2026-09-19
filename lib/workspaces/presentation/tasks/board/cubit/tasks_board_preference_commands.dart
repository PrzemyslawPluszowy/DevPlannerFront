import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

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

  /// Intencje czekające na zapis, w kolejności zgłoszenia przez użytkownika.
  final List<_KanbanPreferenceIntent> _pendingIntents = [];
  bool _isSavingPreference = false;

  /// Snapshot z Backendu, na którym budowane są intencje.
  ///
  /// Trzymamy go osobno od stanu, bo stan pokazuje intencje już nałożone —
  /// a zapis musi znać wersję i pola, które faktycznie przyszły z serwera.
  UserKanbanPreferenceResponse? _serverBase;

  /// Czy w kolejce czekają niezapisane intencje użytkownika.
  bool get hasPendingIntents => _pendingIntents.isNotEmpty;

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

  /// Ponawia zapis zaparkowanych intencji po nieudanym zapisie albo konflikcie.
  Future<void> retryPending() async {
    if (_pendingIntents.isEmpty) return;
    _publishOptimistic();
    await _drain();
  }

  /// Dopisuje intencję do kolejki i uruchamia pojedynczy zapis.
  ///
  /// Kolejne kliknięcia nie są ignorowane, gdy trwa zapis: intencja czeka na
  /// zakończenie bieżącego żądania, a wynik widać od razu w interfejsie.
  Future<void> _submit(_KanbanPreferenceIntent intent) async {
    _pendingIntents.add(intent);
    _publishOptimistic();
    await _drain();
  }

  /// Wysyła intencje po jednej partii, z ponowieniem po konflikcie wersji.
  ///
  /// Partia jest zawsze nakładana na świeży snapshot z Backendu, więc ponowienie
  /// nie przenosi nieaktualnych wartości pól, których użytkownik nie ruszył.
  Future<void> _drain() async {
    if (_isSavingPreference) return;
    _isSavingPreference = true;
    try {
      while (_pendingIntents.isNotEmpty && !_context.isBoardClosed) {
        final batch = List<_KanbanPreferenceIntent>.unmodifiable(
          _pendingIntents,
        );
        final base = _basePreference();
        if (base == null) break;
        final outcome = await _save(
          batch: batch,
          base: base,
          rebaseOnConflict: true,
        );
        if (_context.isBoardClosed) return;
        switch (outcome) {
          case _PreferenceSaved(:final preference):
            _pendingIntents.removeRange(0, batch.length);
            _serverBase = _pendingIntents.isEmpty ? null : preference;
            _publishPending(
              base: preference,
              saving: _pendingIntents.isNotEmpty,
            );
            if (batch.any((intent) => intent is _QuickFilterIntent)) {
              // Szybki filtr zawęża karty po stronie Backendu, więc sama zmiana
              // preferencji nie wystarcza: tablica musi wrócić po świeży zestaw.
              await _context.reloadBoard(force: true);
            }
          case _PreferenceFailed(:final error, :final preference):
            _serverBase = preference;
            _publishFailure(error);
        }
        if (outcome is! _PreferenceSaved) return;
      }
    } finally {
      _isSavingPreference = false;
    }
  }

  Future<_PreferenceOutcome> _save({
    required List<_KanbanPreferenceIntent> batch,
    required UserKanbanPreferenceResponse base,
    required bool rebaseOnConflict,
  }) async {
    final result = await _write(batch: batch, base: base);
    final failure = result.fold((error) => error, (_) => null);
    if (failure == null) {
      return _PreferenceSaved(result.getOrElse(() => base));
    }
    if (!isTaskSettingsVersionConflict(failure)) {
      return _PreferenceFailed(tasksViewErrorFrom(failure), preference: base);
    }
    if (!rebaseOnConflict) {
      // Drugi konflikt: nie ponawiamy w kółko tej samej intencji. Zostaje
      // zaparkowana, a użytkownik decyduje, czy ponowić ją na świeżym stanie.
      return _PreferenceFailed(
        const TasksViewError(code: TasksViewErrorCodes.versionConflict),
        preference: base,
      );
    }

    final refreshed = await _repository.getUserPreference(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
    );
    if (_context.isBoardClosed) {
      return _PreferenceFailed(tasksViewErrorFrom(failure), preference: null);
    }
    final fresh = refreshed.fold((_) => null, (value) => value);
    if (fresh == null) {
      // Bez świeżej wersji nie ma na co nakładać intencji.
      return _PreferenceFailed(
        const TasksViewError(code: TasksViewErrorCodes.loadFailed),
        preference: base,
      );
    }
    final retried = await _save(
      batch: batch,
      base: fresh,
      rebaseOnConflict: false,
    );
    return retried;
  }

  Future<Either<ApiError, UserKanbanPreferenceResponse>> _write({
    required List<_KanbanPreferenceIntent> batch,
    required UserKanbanPreferenceResponse base,
  }) {
    final desired = _applyIntents(batch, base);
    return _repository.updateUserPreference(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      payload: UpdateUserKanbanPreferencePayload(
        collapsedColumns: desired.collapsedColumns,
        collapsedCustomStatusIds: desired.collapsedCustomStatusIds,
        quickFilter: desired.quickFilter,
        expectedVersion: base.version,
      ),
    );
  }

  UserKanbanPreferenceResponse _applyIntents(
    List<_KanbanPreferenceIntent> intents,
    UserKanbanPreferenceResponse base,
  ) => intents.fold(base, (acc, intent) => intent.applyTo(acc));

  UserKanbanPreferenceResponse? _basePreference() {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return null;
    return _serverBase ??= current.userPreference;
  }

  /// Pokazuje intencje nałożone na ostatni znany stan serwera.
  void _publishOptimistic() => _publishPending(saving: true);

  /// Pokazuje stan serwera z nałożonymi intencjami, które jeszcze czekają.
  ///
  /// [base] podaje zapisany właśnie snapshot; bez niego punktem odniesienia jest
  /// ostatni znany stan serwera, a nie optymistyczny obraz na ekranie.
  void _publishPending({
    required bool saving,
    UserKanbanPreferenceResponse? base,
  }) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final resolved = base ?? _basePreference();
    if (resolved == null) return;
    _context.publish(
      current.copyWith(
        userPreference: _applyIntents(_pendingIntents, resolved),
        savingUserPreference: saving,
        clearError: true,
      ),
    );
  }

  /// Zostawia intencje widoczne na ekranie i melduje, że nie zostały zapisane.
  ///
  /// Intencja zostaje w kolejce, więc „Ponów” ponowi ją, a nie zapisze
  /// odświeżonego stanu serwera.
  void _publishFailure(TasksViewError error) {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final base = _basePreference();
    _context.publish(
      current.copyWith(
        userPreference: base == null
            ? current.userPreference
            : _applyIntents(_pendingIntents, base),
        savingUserPreference: false,
        error: error,
      ),
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
    // Kolejna strona musi nieść ten sam filtr tablicy, inaczej kursor opisuje
    // inny zestaw kart niż licznik kolumny.
    final query = current.filter.toColumnQuery(cursor: cursor);
    final result = column.customStatusId == null
        ? await _repository.getSystemColumn(
            workspaceId: _context.workspaceId,
            projectId: _context.projectId,
            status: column.status,
            query: query,
          )
        : await _repository.getCustomColumn(
            workspaceId: _context.workspaceId,
            projectId: _context.projectId,
            customStatusId: column.customStatusId!,
            query: query,
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
          _context.publish(ready.copyWith(error: tasksViewErrorFrom(error)));
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
          _context.publish(ready.copyWith(error: tasksViewErrorFrom(error)));
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

/// Docelowa zmiana osobistych preferencji widoku.
///
/// Intencja opisuje wartość, którą użytkownik chce osiągnąć — a nie różnicę
/// względem stanu, który widział. Dzięki temu można ją nałożyć na świeży
/// snapshot z Backendu i ponowienie po konflikcie nie nadpisze równoległej
/// zmiany w polach, których użytkownik nie ruszył.
sealed class _KanbanPreferenceIntent {
  const _KanbanPreferenceIntent();

  UserKanbanPreferenceResponse applyTo(UserKanbanPreferenceResponse base);
}

final class _ColumnCollapseIntent extends _KanbanPreferenceIntent {
  const _ColumnCollapseIntent({
    required this.collapsed,
    this.status,
    this.customStatusId,
  }) : assert(
         status != null || customStatusId != null,
         'Zwinięcie kolumny musi wskazywać kolumnę systemową albo własny status.',
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

final class _QuickFilterIntent extends _KanbanPreferenceIntent {
  const _QuickFilterIntent(this.quickFilter);

  final KanbanQuickFilter quickFilter;

  @override
  UserKanbanPreferenceResponse applyTo(UserKanbanPreferenceResponse base) =>
      base.copyWith(quickFilter: quickFilter);
}

/// Wynik zapisu partii intencji.
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

  /// Świeży stan serwera, na którym ma oprzeć się kolejna próba albo `null`,
  /// gdy odczyt wersji też się nie powiódł.
  final UserKanbanPreferenceResponse? preference;
}
