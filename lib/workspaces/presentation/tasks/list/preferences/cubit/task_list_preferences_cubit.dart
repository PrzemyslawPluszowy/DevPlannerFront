import 'dart:async';

import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
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

  Future<void> load() async {
    await _loader.load(isClosed: isClosed, emit: emit);
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

  Future<void> cycleSort(TaskSavedViewSortField field) async {
    final current = state;
    if (current is! TaskListPreferencesReady || current.isSaving) return;
    final next = TaskListSortController.next(current, field);
    await _saveSortExplicitly(next.field, next.direction);
  }

  Future<void> setSort(
    TaskSavedViewSortField field,
    TaskSavedViewSortDirection direction,
  ) async {
    final current = state;
    if (current is! TaskListPreferencesReady || current.isSaving) return;
    await _saveSortExplicitly(field, direction);
  }

  Future<void> _saveSortExplicitly(
    TaskSavedViewSortField field,
    TaskSavedViewSortDirection direction,
  ) async {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    _autosaveTimer?.cancel();
    emit(current.copyWith(isSaving: true, clearSaveError: true));

    final payload = UpdateTaskListUserPreferencePayload(
      visibleColumns: current.effectiveVisibleColumns.map((c) => c.id).toList(),
      columnWidths: current.columnWidths,
      sortField: field,
      sortDirection: direction,
      groupBy: current.groupBy,
      activeSavedViewId: current.activeSavedViewId,
      expectedVersion: current.userPreferenceVersion,
    );

    final result = await repository.updateUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: payload,
    );

    if (isClosed) return;

    final latest = state;
    if (latest is! TaskListPreferencesReady) return;

    result.fold(
      (error) {
        if (error.statusCode == 409) {
          unawaited(
            load().then((_) {
              final s = state;
              if (s is TaskListPreferencesReady) {
                emit(
                  s.copyWith(
                    saveError: 'Układ kolumn został zmodyfikowany w innej sesji. Pobrano najnowszy stan z serwera.',
                  ),
                );
              }
            }),
          );
        } else {
          emit(latest.copyWith(isSaving: false, saveError: error.message));
        }
      },
      (saved) {
        emit(
          latest.copyWith(
            sortField: field,
            sortDirection: direction,
            isSaving: false,
            userPreferenceVersion: saved.version,
            clearSaveError: true,
          ),
        );
      },
    );
  }

  Future<void> setGroupBy(TaskSavedViewGroupBy groupBy) async {
    final current = state;
    if (current is! TaskListPreferencesReady || current.isSaving) return;

    _autosaveTimer?.cancel();
    emit(current.copyWith(isSaving: true, clearSaveError: true));

    final payload = UpdateTaskListUserPreferencePayload(
      visibleColumns: current.effectiveVisibleColumns.map((c) => c.id).toList(),
      columnWidths: current.columnWidths,
      sortField: current.sortField,
      sortDirection: current.sortDirection,
      groupBy: groupBy,
      activeSavedViewId: current.activeSavedViewId,
      expectedVersion: current.userPreferenceVersion,
    );

    final result = await repository.updateUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: payload,
    );

    if (isClosed) return;
    final latest = state;
    if (latest is! TaskListPreferencesReady) return;

    result.fold(
      (error) {
        if (error.statusCode == 409) {
          unawaited(
            load().then((_) {
              final s = state;
              if (s is TaskListPreferencesReady) {
                emit(
                  s.copyWith(
                    saveError: 'Preferencje zostały zmodyfikowane w innej sesji. Pobrano najnowszy stan z serwera.',
                  ),
                );
              }
            }),
          );
        } else {
          emit(latest.copyWith(isSaving: false, saveError: error.message));
        }
      },
      (saved) {
        emit(
          latest.copyWith(
            groupBy: groupBy,
            isSaving: false,
            userPreferenceVersion: saved.version,
            clearSaveError: true,
          ),
        );
      },
    );
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
    _autosaveTimer?.cancel();
    await _performAutosave();
  }

  Future<void> saveNow() async {
    _autosaveTimer?.cancel();
    await _performAutosave();
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

        emit(current.copyWith(isSaving: true, clearSaveError: true));

        final payload = UpdateTaskListUserPreferencePayload(
          visibleColumns: current.effectiveVisibleColumns
              .map((c) => c.id)
              .toList(),
          columnWidths: current.columnWidths,
          sortField: current.sortField,
          sortDirection: current.sortDirection,
          groupBy: current.groupBy,
          activeSavedViewId: current.activeSavedViewId,
          expectedVersion: current.userPreferenceVersion,
        );

        final result = await repository.updateUserPreference(
          workspaceId: workspaceId,
          projectId: projectId,
          payload: payload,
        );

        if (isClosed) return;

        final latest = state;
        if (latest is! TaskListPreferencesReady) break;

        result.fold(
          (error) {
            // Przy konflikcie współbieżności odświeżamy układ ze świeżą wersją i informujemy użytkownika
            if (error.statusCode == 409) {
              _hasPendingSave = false;
              unawaited(
                load().then((_) {
                  final s = state;
                  if (s is TaskListPreferencesReady) {
                    emit(
                      s.copyWith(
                        saveError: 'Układ kolumn został zmodyfikowany w innej sesji. Pobrano najnowszy stan z serwera.',
                      ),
                    );
                  }
                }),
              );
            } else {
              emit(latest.copyWith(isSaving: false, saveError: error.message));
            }
          },
          (saved) {
            emit(
              latest.copyWith(
                isSaving: false,
                userPreferenceVersion: saved.version,
                clearSaveError: true,
              ),
            );
          },
        );
      } while (_hasPendingSave && !isClosed);
    } finally {
      _isSaving = false;
    }
  }

  @override
  Future<void> close() {
    _autosaveTimer?.cancel();
    return super.close();
  }
}
