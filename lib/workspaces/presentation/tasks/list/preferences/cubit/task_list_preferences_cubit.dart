import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preference_merge.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_loader.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_project_policy_controller.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_sort_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'task_list_preferences_state.dart';

final class TaskListPreferencesCubit extends Cubit<TaskListPreferencesState> {
  TaskListPreferencesCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskListPreferencesLoading());

  final TaskListConfigurationRepository repository;
  final String workspaceId;
  final String projectId;
  late final TaskListProjectPolicyController _projectPolicy =
      TaskListProjectPolicyController(
        repository: repository,
        workspaceId: workspaceId,
        projectId: projectId,
      );
  late final TaskListPreferencesLoader _loader = TaskListPreferencesLoader(
    repository: repository,
    workspaceId: workspaceId,
    projectId: projectId,
  );

  Timer? _autosaveTimer;
  static const Duration _autosaveDelay = Duration(milliseconds: 500);
  bool _isSaving = false;
  bool _hasPendingSave = false;

  /// Ostatni stan potwierdzony przez Backend.
  ///
  /// Punkt odniesienia scalenia: pole, które różni się od niego, jest zmianą
  /// użytkownika i wygrywa ze świeżym stanem serwera.
  TaskListPreferencesReady? _lastSaved;

  Future<void> load() async {
    final result = await _loader.fetch();
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskListPreferencesError(error.message)),
      (ready) {
        _lastSaved = ready;
        emit(ready);
      },
    );
  }

  Future<void> loadProjectPolicyDraft() async {
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    await _projectPolicy.loadDraft(
      current: current,
      isClosed: isClosed,
      readReady: () => state is TaskListPreferencesReady
          ? state as TaskListPreferencesReady
          : null,
      emit: emit,
    );
  }

  void toggleProjectDefaultColumn(TaskColumnReference column) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    final next = _projectPolicy.toggleColumn(current, column);
    if (next != null) emit(next);
  }

  void reorderProjectDefaultColumns(int oldIndex, int newIndex) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    final next = _projectPolicy.reorderColumns(current, oldIndex, newIndex);
    if (next != null) emit(next);
  }

  void toggleColumn(TaskColumnReference column) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    final isVisible = current.isColumnVisible(column.id);
    if (isVisible) {
      if (current.isColumnRequired(column.id)) return;
      final updated = current.effectiveVisibleColumns
          .where((c) => c.id.toLowerCase() != column.id.toLowerCase())
          .toList();
      emit(current.copyWith(effectiveVisibleColumns: updated));
      _scheduleAutosave();
    } else {
      if (!current.isColumnAvailable(column.id)) return;
      final updated = [...current.effectiveVisibleColumns, column];
      emit(current.copyWith(effectiveVisibleColumns: updated));
      _scheduleAutosave();
    }
  }

  void reorderColumns(int oldIndex, int newIndex) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    if (oldIndex < 0 ||
        oldIndex >= current.effectiveVisibleColumns.length ||
        newIndex < 0 ||
        newIndex >= current.effectiveVisibleColumns.length ||
        oldIndex == newIndex) {
      return;
    }

    final updated = List<TaskColumnReference>.from(
      current.effectiveVisibleColumns,
    );
    final moved = updated.removeAt(oldIndex);
    updated.insert(newIndex, moved);

    emit(current.copyWith(effectiveVisibleColumns: updated));
    _scheduleAutosave();
  }

  void resizeColumn(String columnId, double width) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    final clamped = width.clamp(50.0, 1000.0);
    final updatedWidths = Map<String, double>.from(current.columnWidths)
      ..[columnId] = clamped;

    emit(current.copyWith(columnWidths: updatedWidths));
    _scheduleAutosave();
  }

  /// Przełącza sortowanie wybranej kolumny.
  ///
  /// Zapis idzie tą samą kolejką co autosave, więc kliknięcie w trakcie zapisu
  /// nie jest ignorowane — jego intencja czeka na koniec bieżącego żądania.
  Future<void> cycleSort(TaskSavedViewSortField field) async {
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    final next = TaskListSortController.next(current, field);
    emit(
      current.copyWith(sortField: next.field, sortDirection: next.direction),
    );
    await saveNow();
  }

  Future<void> setSort(
    TaskSavedViewSortField field,
    TaskSavedViewSortDirection direction,
  ) async {
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    emit(current.copyWith(sortField: field, sortDirection: direction));
    await saveNow();
  }

  Future<void> setGroupBy(TaskSavedViewGroupBy groupBy) async {
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    emit(current.copyWith(groupBy: groupBy));
    await saveNow();
  }

  Future<void> setActiveSavedViewId(String? viewId) async {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    emit(
      current.copyWith(
        activeSavedViewId: viewId,
        clearActiveSavedViewId: viewId == null,
      ),
    );
    await saveNow();
  }

  /// Zapisuje bieżący draft natychmiast, poza opóźnieniem autosave.
  Future<void> saveNow() async {
    _autosaveTimer?.cancel();
    await _performAutosave();
  }

  /// Ukrywa komunikat o nieudanym zapisie.
  void dismissSaveFailure() {
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    emit(current.copyWith(clearSaveFailure: true));
  }

  Future<void> resetToProjectDefaults() async {
    _autosaveTimer?.cancel();
    await _projectPolicy.resetToDefaults(
      isClosed: isClosed,
      emit: emit,
      reload: load,
    );
  }

  Future<bool> saveAsProjectDefaults() async {
    final current = state;
    if (current is! TaskListPreferencesReady) return false;
    return _projectPolicy.saveDraft(
      current: current,
      isClosed: isClosed,
      emit: emit,
    );
  }

  void _scheduleAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(_autosaveDelay, () {
      if (!isClosed) unawaited(_performAutosave());
    });
  }

  /// Pojedyncza, szeregowana ścieżka zapisu preferencji.
  ///
  /// Dopóki trwa żądanie, kolejne zmiany tylko ustawiają [._hasPendingSave],
  /// a pętla zapisuje je po powrocie — dzięki temu żadne kliknięcie nie ginie
  /// i nie powstaje drugi, równoległy zapis z tą samą wersją.
  Future<void> _performAutosave() async {
    if (_isSaving) {
      _hasPendingSave = true;
      return;
    }

    _isSaving = true;
    try {
      do {
        _hasPendingSave = false;
        final current = state;
        if (current is! TaskListPreferencesReady) break;

        emit(current.copyWith(isSaving: true, clearSaveFailure: true));
        final saved = await _persist(current);
        // Niepowodzenie przerywa ponawianie, ale nie kasuje zmiany zgłoszonej
        // w trakcie żądania: jeśli taka jest, pętla zapisuje ją w kolejnej
        // iteracji (kolejna iteracja wymaga nowej zmiany użytkownika, więc nie
        // ma pętli ponowień).
        if (!saved && !_hasPendingSave) break;
      } while (_hasPendingSave && !isClosed);
    } finally {
      _isSaving = false;
    }
  }

  /// Zapisuje draft, a po konflikcie wersji scala go ze świeżym stanem serwera.
  ///
  /// Zwraca `true`, gdy serwer przyjął zapis.
  Future<bool> _persist(TaskListPreferencesReady draft) async {
    final first = await _write(draft);
    if (isClosed) return false;

    final failure = first.fold((error) => error, (_) => null);
    if (failure == null) {
      _applySaved(draft, first);
      return true;
    }
    if (!isTaskSettingsVersionConflict(failure)) {
      _publishFailure(tasksViewErrorFrom(failure));
      return false;
    }

    final fresh = await _fetchFresh();
    if (isClosed) return false;
    if (fresh == null) {
      _publishFailure(
        const TasksViewError(code: TasksViewErrorCodes.loadFailed),
      );
      return false;
    }

    // Intencja użytkownika wędruje na świeży stan serwera: zapisujemy draft
    // scalony, a nie to, co serwer właśnie zwrócił.
    final merged = mergeTaskListPreferences(
      fresh: fresh,
      lastSaved: _lastSaved ?? fresh,
      draft: draft,
    );
    final retry = await _write(merged);
    if (isClosed) return false;

    final retryFailure = retry.fold((error) => error, (_) => null);
    if (retryFailure == null) {
      _applySaved(merged, retry);
      return true;
    }

    // `_lastSaved` zostaje ostatnim potwierdzonym zapisem: to on jest punktem
    // odniesienia scalenia. Świeżą wersję niesie już `kept` (powstaje ze stanu
    // serwera), więc ponowienie użyje właściwego `expectedVersion` bez
    // nadpisywania baseline'u.
    if (!isTaskSettingsVersionConflict(retryFailure)) {
      _publishFailure(tasksViewErrorFrom(retryFailure), rebasedOn: fresh);
      return false;
    }

    // Drugi konflikt: przerywamy ponawianie. Draft zostaje na ekranie, więc
    // „Ponów” ponowi intencję użytkownika, a nie zapis stanu serwera.
    _publishFailure(
      const TasksViewError(code: TasksViewErrorCodes.versionConflict),
      rebasedOn: fresh,
    );
    return false;
  }

  Future<Either<ApiError, TaskListUserPreferenceResponse>> _write(
    TaskListPreferencesReady snapshot,
  ) => repository.updateUserPreference(
    workspaceId: workspaceId,
    projectId: projectId,
    payload: UpdateTaskListUserPreferencePayload(
      visibleColumns: snapshot.effectiveVisibleColumns
          .map((c) => c.id)
          .toList(),
      columnWidths: snapshot.columnWidths,
      sortField: snapshot.sortField,
      sortDirection: snapshot.sortDirection,
      groupBy: snapshot.groupBy,
      activeSavedViewId: snapshot.activeSavedViewId,
      expectedVersion: snapshot.userPreferenceVersion,
    ),
  );

  Future<TaskListPreferencesReady?> _fetchFresh() async {
    final result = await _loader.fetch();
    return result.fold((_) => null, (ready) => ready);
  }

  void _applySaved(
    TaskListPreferencesReady snapshot,
    Either<ApiError, TaskListUserPreferenceResponse> result,
  ) {
    final saved = result.fold((_) => null, (value) => value);
    if (saved == null) return;
    _lastSaved = snapshot.copyWith(userPreferenceVersion: saved.version);
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    // Stan mógł w międzyczasie zyskać nowsze zmiany użytkownika, więc
    // aktualizujemy wersję, a nie pola.
    emit(
      current.copyWith(
        userPreferenceVersion: saved.version,
        isSaving: false,
        clearSaveFailure: true,
      ),
    );
  }

  /// Melduje błąd na bieżącym stanie, a nie na snapshocie sprzed żądania.
  ///
  /// [rebasedOn] podaje świeży stan serwera, gdy konflikt zdążył go odczytać.
  /// Wtedy bieżący draft przechodzi przez to samo scalenie co zapis: pola
  /// zmienione lokalnie — także te z ostatniej chwili — zostają, a pola, których
  /// użytkownik nie ruszył, przyjmują wartości serwera. Bez scalenia błąd
  /// cofałby zmiany wykonane w trakcie żądania i pokazywał nieaktualny stan.
  void _publishFailure(
    TasksViewError error, {
    TaskListPreferencesReady? rebasedOn,
  }) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    final kept = rebasedOn == null
        ? current
        : mergeTaskListPreferences(
            fresh: rebasedOn,
            lastSaved: _lastSaved ?? rebasedOn,
            draft: current,
          );
    emit(kept.copyWith(isSaving: false, saveFailure: error));
  }

  @override
  Future<void> close() {
    _autosaveTimer?.cancel();
    return super.close();
  }
}
