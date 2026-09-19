import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/cubit/task_saved_views_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'task_saved_views_state.dart';

/// Stan zapisanych, prywatnych widoków jednego projektu Tasks z synchronizacją
/// aktywnego widoku w preferencjach użytkownika na backendzie.
final class TaskSavedViewsCubit extends Cubit<TaskSavedViewsState> {
  TaskSavedViewsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    this.preferencesRepository,
  }) : super(const TaskSavedViewsLoading());

  final TaskViewRepository repository;
  final TaskListConfigurationRepository? preferencesRepository;
  final String workspaceId;
  final String projectId;

  /// Pobiera listę zapisanych widoków oraz aktywny identyfikator z preferencji backendowych.
  Future<void> load() async {
    emit(const TaskSavedViewsLoading());
    final result = await repository.list(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;

    String? activeId;
    final prefsRepo = preferencesRepository;
    if (prefsRepo != null) {
      final prefResult = await prefsRepo.getEffectiveConfiguration(
        workspaceId: workspaceId,
        projectId: projectId,
      );
      if (isClosed) return;
      prefResult.fold(
        (_) => null,
        (config) => activeId = config.activeSavedViewId,
      );
    }

    result.fold(
      (error) => emit(TaskSavedViewsFailure(error.message)),
      (views) {
        final effectiveActiveId =
            (activeId != null && views.any((item) => item.id == activeId))
            ? activeId
            : null;
        emit(
          TaskSavedViewsReady(views: views, activeViewId: effectiveActiveId),
        );
      },
    );
  }

  /// Przełącza aktywny widok.
  ///
  /// Przekazanie `null` oznacza powrót do widoku domyślnego.
  void select(String? viewId) {
    final current = state;
    if (current is! TaskSavedViewsReady ||
        (viewId != null && !current.views.any((item) => item.id == viewId))) {
      return;
    }
    emit(
      viewId == null
          ? current.copyWith(clearActiveView: true, clearError: true)
          : current.copyWith(activeViewId: viewId, clearError: true),
    );
    unawaited(_persistActiveViewPreference(viewId));
  }

  /// Tworzy nowy zapisany widok ze snapshotu i natychmiast go aktywuje.
  Future<bool> create(CreateTaskSavedViewPayload payload) async {
    final current = state;
    if (current is! TaskSavedViewsReady ||
        current.busy ||
        payload.name.trim().isEmpty) {
      return false;
    }
    emit(
      current.copyWith(
        busyAction: TaskSavedViewBusyAction.create,
        clearError: true,
      ),
    );
    final result = await repository.create(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: payload.copyWith(name: payload.name.trim()),
    );
    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(
          current.copyWith(
            clearBusyAction: true,
            error: error.message,
          ),
        );
        return false;
      },
      (value) {
        unawaited(_persistActiveViewPreference(value.id));
        emit(
          current.copyWith(
            views: [...current.views, value],
            activeViewId: value.id,
            clearBusyAction: true,
            clearError: true,
            successMessage: 'Widok zapisany',
            successSerial: current.successSerial + 1,
          ),
        );
        return true;
      },
    );
  }

  /// Aktualizuje definicję istniejącego widoku (np. nadpisanie zmian lub zmiana nazwy).
  Future<bool> update(String id, UpdateTaskSavedViewPayload payload) async {
    final current = state;
    if (current is! TaskSavedViewsReady ||
        current.busy ||
        payload.name.trim().isEmpty) {
      return false;
    }
    emit(
      current.copyWith(
        busyAction: TaskSavedViewBusyAction.update,
        clearError: true,
      ),
    );
    final result = await repository.update(
      workspaceId: workspaceId,
      projectId: projectId,
      viewId: id,
      payload: payload.copyWith(name: payload.name.trim()),
    );
    if (isClosed) return false;

    return result.fold(
      (error) {
        final errorMessage =
            (error.statusCode == 409 || error.type == ApiErrorType.conflict)
            ? 'Widok został zmodyfikowany przez innego użytkownika. Odśwież dane.'
            : error.message;
        emit(
          current.copyWith(
            clearBusyAction: true,
            error: errorMessage,
          ),
        );
        return false;
      },
      (value) {
        emit(
          current.copyWith(
            views: [
              for (final item in current.views)
                if (item.id == id) value else item,
            ],
            clearBusyAction: true,
            clearError: true,
            successMessage: 'Widok zaktualizowany',
            successSerial: current.successSerial + 1,
          ),
        );
        return true;
      },
    );
  }

  /// Usuwa wskazany zapisany widok. Jeśli był aktywny, następuje powrót do widoku domyślnego.
  Future<bool> delete(String id) async {
    final current = state;
    if (current is! TaskSavedViewsReady || current.busy) return false;
    emit(
      current.copyWith(
        busyAction: TaskSavedViewBusyAction.delete,
        clearError: true,
      ),
    );
    final result = await repository.delete(
      workspaceId: workspaceId,
      projectId: projectId,
      viewId: id,
    );
    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(
          current.copyWith(
            clearBusyAction: true,
            error: error.message,
          ),
        );
        return false;
      },
      (_) {
        final wasActive = current.activeViewId == id;
        if (wasActive) {
          unawaited(_persistActiveViewPreference(null));
        }
        emit(
          current.copyWith(
            views: current.views.where((item) => item.id != id).toList(),
            clearBusyAction: true,
            clearError: true,
            clearActiveView: wasActive,
            successMessage: 'Widok usunięty',
            successSerial: current.successSerial + 1,
          ),
        );
        return true;
      },
    );
  }

  /// Czyści aktywny komunikat błędu.
  void clearError() {
    final current = state;
    if (current is TaskSavedViewsReady && current.error != null) {
      emit(current.copyWith(clearError: true));
    }
  }

  Future<void> _persistActiveViewPreference(String? viewId) async {
    final prefsRepo = preferencesRepository;
    if (prefsRepo == null) return;

    for (var attempt = 0; attempt < 2; attempt++) {
      if (isClosed) return;
      final prefResult = await prefsRepo.getUserPreference(
        workspaceId: workspaceId,
        projectId: projectId,
      );
      if (isClosed) return;

      final shouldRetry = await prefResult.fold(
        (_) async {
          _notifyPreferencePersistFailed();
          return false;
        },
        (pref) async {
          final updateResult = await prefsRepo.updateUserPreference(
            workspaceId: workspaceId,
            projectId: projectId,
            payload: UpdateTaskListUserPreferencePayload(
              visibleColumns: pref.visibleColumns,
              columnWidths: pref.columnWidths,
              sortField: pref.sortField,
              sortDirection: pref.sortDirection,
              groupBy: pref.groupBy,
              activeSavedViewId: viewId,
              expectedVersion: pref.version,
            ),
          );
          if (isClosed) return false;
          return updateResult.fold(
            (error) {
              if (error.statusCode == 409) return true;
              _notifyPreferencePersistFailed();
              return false;
            },
            (_) => false,
          );
        },
      );
      if (!shouldRetry) break;
    }
  }

  void _notifyPreferencePersistFailed() {
    if (isClosed) return;
    final current = state;
    if (current is TaskSavedViewsReady) {
      emit(
        current.copyWith(
          error: 'Widok aktywny tylko w tej sesji; nie udało się zapisać preferencji.',
        ),
      );
    }
  }
}
