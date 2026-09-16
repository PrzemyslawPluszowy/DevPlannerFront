import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';

export 'task_list_preferences_state.dart';

/// Zarządza stanem widoczności, kolejności, szerokości i sortowania kolumn
/// listy zadań z automatycznym zapisem do backendu i obsługą współbieżności.
final class TaskListPreferencesCubit extends Cubit<TaskListPreferencesState> {
  TaskListPreferencesCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskListPreferencesLoading());

  final TaskListConfigurationRepository repository;
  final String workspaceId;
  final String projectId;

  Timer? _autosaveTimer;
  static const Duration _autosaveDelay = Duration(milliseconds: 500);
  bool _isSaving = false;
  bool _hasPendingSave = false;

  /// Pobiera efektywną konfigurację kolumn i sortowania z backendu.
  Future<void> load() async {
    final result = await repository.getEffectiveConfiguration(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(TaskListPreferencesError(error.message)),
      (config) => emit(
        TaskListPreferencesReady(
          workspaceId: workspaceId,
          projectId: projectId,
          effectiveVisibleColumns: config.effectiveVisibleColumns
              .map(TaskColumnReference.fromId)
              .toList(),
          availableColumns: config.availableColumns.toSet(),
          requiredColumns: config.requiredColumns.toSet(),
          columnWidths: Map<String, double>.from(config.effectiveColumnWidths),
          sortField: config.sortField,
          sortDirection: config.sortDirection,
          groupBy: config.groupBy,
          activeSavedViewId: config.activeSavedViewId,
          userPreferenceVersion: config.userPreferenceVersion,
          policyVersion: config.policyVersion,
        ),
      ),
    );
  }

  /// Ładuje domyślne kolumny polityki projektu jako niezależny draft edycyjny.
  Future<void> loadProjectPolicyDraft() async {
    final current = state;
    if (current is! TaskListPreferencesReady) return;
    if (current.projectDefaultColumnsDraft != null &&
        !current.isLoadingProjectPolicy) {
      return;
    }

    emit(
      current.copyWith(
        isLoadingProjectPolicy: true,
        clearProjectPolicyError: true,
      ),
    );

    final result = await repository.getPolicy(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return;

    final latest = state;
    if (latest is! TaskListPreferencesReady) return;

    result.fold(
      (error) {
        emit(
          latest.copyWith(
            isLoadingProjectPolicy: false,
            projectPolicyError: error.message,
            projectDefaultColumnsDraft:
                latest.projectDefaultColumnsDraft ??
                latest.effectiveVisibleColumns,
          ),
        );
      },
      (policy) {
        emit(
          latest.copyWith(
            isLoadingProjectPolicy: false,
            clearProjectPolicyError: true,
            policyVersion: policy.version,
            projectDefaultColumnsDraft: policy.defaultColumns
                .map(TaskColumnReference.fromId)
                .toList(),
          ),
        );
      },
    );
  }

  /// Włącza lub wyłącza kolumnę w roboczym drafcie polityki projektu (NIE uruchamia autosave).
  void toggleProjectDefaultColumn(TaskColumnReference column) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    final draft = List<TaskColumnReference>.from(
      current.effectiveProjectDefaultColumns,
    );
    final isVisible = draft.any(
      (c) => c.id.toLowerCase() == column.id.toLowerCase(),
    );

    if (isVisible) {
      if (current.isColumnRequired(column.id)) return;
      draft.removeWhere(
        (c) => c.id.toLowerCase() == column.id.toLowerCase(),
      );
    } else {
      if (!current.isColumnAvailable(column.id)) return;
      draft.add(column);
    }

    emit(current.copyWith(projectDefaultColumnsDraft: draft));
  }

  /// Zmienia kolejność kolumn w roboczym drafcie polityki projektu (NIE uruchamia autosave).
  void reorderProjectDefaultColumns(int oldIndex, int newIndex) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    final draft = List<TaskColumnReference>.from(
      current.effectiveProjectDefaultColumns,
    );
    if (oldIndex < 0 ||
        oldIndex >= draft.length ||
        newIndex < 0 ||
        newIndex >= draft.length ||
        oldIndex == newIndex) {
      return;
    }

    final moved = draft.removeAt(oldIndex);
    draft.insert(newIndex, moved);

    emit(current.copyWith(projectDefaultColumnsDraft: draft));
  }

  /// Włącza lub wyłącza kolumnę. Kolumny wymagane nie mogą być wyłączone,
  /// a kolumny zablokowane przez administratora nie mogą być włączone.
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

  /// Zmienia kolejność kolumn (np. w wyniku przeciągnięcia Drag and Drop).
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

  /// Aktualizuje szerokość pojedynczej kolumny po przesunięciu separatora.
  void resizeColumn(String columnId, double width) {
    final current = state;
    if (current is! TaskListPreferencesReady) return;

    final clamped = width.clamp(50.0, 1000.0);
    final updatedWidths = Map<String, double>.from(current.columnWidths)
      ..[columnId] = clamped;

    emit(current.copyWith(columnWidths: updatedWidths));
    _scheduleAutosave();
  }

  /// Przełącza cyklicznie sortowanie kolumny:
  /// Brak sortowania -> Rosnąco -> Malejąco -> Domyślne (pozycja).
  /// Zmiana sortowania zapisywana jest w backendzie przed emisją nowego stanu,
  /// eliminując wyścig zapisu preferencji z odświeżeniem listy zadań.
  Future<void> cycleSort(TaskSavedViewSortField field) async {
    final current = state;
    if (current is! TaskListPreferencesReady || current.isSaving) return;

    final initialDirection = switch (field) {
      TaskSavedViewSortField.priority => TaskSavedViewSortDirection.descending,
      TaskSavedViewSortField.updatedAtUtc =>
        TaskSavedViewSortDirection.descending,
      _ => TaskSavedViewSortDirection.ascending,
    };

    final TaskSavedViewSortField nextField;
    final TaskSavedViewSortDirection nextDirection;

    if (current.sortField != field) {
      nextField = field;
      nextDirection = initialDirection;
    } else {
      final oppositeDirection =
          initialDirection == TaskSavedViewSortDirection.ascending
          ? TaskSavedViewSortDirection.descending
          : TaskSavedViewSortDirection.ascending;

      if (current.sortDirection == initialDirection) {
        nextField = field;
        nextDirection = oppositeDirection;
      } else {
        nextField = TaskSavedViewSortField.position;
        nextDirection = TaskSavedViewSortDirection.ascending;
      }
    }

    await _saveSortExplicitly(nextField, nextDirection);
  }

  /// Ustawia pole i kierunek sortowania z potwierdzonym zapisem w backendzie.
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

  /// Ustawia sposób grupowania listy zadań z potwierdzonym zapisem do backendu.
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

  /// Ustawia aktywny zapisany widok i natychmiast zapisuje preferencje do backendu.
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

  /// Natychmiastowo zapisuje oczekujące preferencje bez oczekiwania na timer.
  Future<void> saveNow() async {
    _autosaveTimer?.cancel();
    await _performAutosave();
  }

  /// Przywraca domyślny układ kolumn z polityki projektu.
  Future<void> resetToProjectDefaults() async {
    _autosaveTimer?.cancel();
    final result = await repository.resetUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return;

    await result.fold(
      (error) async => emit(TaskListPreferencesError(error.message)),
      (_) async => load(),
    );
  }

  /// Zapisuje aktualny układ kolumn jako domyślny dla całego projektu (dla administratora).
  Future<bool> saveAsProjectDefaults() async {
    final current = state;
    if (current is! TaskListPreferencesReady) return false;

    emit(current.copyWith(isSaving: true, clearSaveError: true));

    final targetColumns = current.effectiveProjectDefaultColumns;
    final payload = UpdateProjectTaskListPolicyPayload(
      availableColumns: current.availableColumns.toList(),
      requiredColumns: current.requiredColumns.toList(),
      defaultColumns: targetColumns.map((c) => c.id).toList(),
      defaultColumnWidths: current.columnWidths,
      defaultSortField: current.sortField,
      defaultSortDirection: current.sortDirection,
      defaultGroupBy: current.groupBy,
      expectedVersion: current.policyVersion,
    );

    final result = await repository.updatePolicy(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: payload,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, saveError: error.message));
        return false;
      },
      (policy) {
        emit(
          current.copyWith(
            isSaving: false,
            policyVersion: policy.version,
            projectDefaultColumnsDraft: policy.defaultColumns
                .map(TaskColumnReference.fromId)
                .toList(),
            clearSaveError: true,
          ),
        );
        return true;
      },
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
