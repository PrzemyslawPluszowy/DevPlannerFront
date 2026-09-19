import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';

/// Koordynuje odrębny draft administracyjnej polityki kolumn projektu.
final class TaskListProjectPolicyController {
  const TaskListProjectPolicyController({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  });

  final TaskListConfigurationRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> loadDraft({
    required TaskListPreferencesReady current,
    required bool isClosed,
    required TaskListPreferencesReady? Function() readReady,
    required void Function(TaskListPreferencesState) emit,
  }) async {
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
    final latest = readReady();
    if (latest == null) return;
    result.fold(
      (error) => emit(
        latest.copyWith(
          isLoadingProjectPolicy: false,
          projectPolicyError: error.message,
          projectDefaultColumnsDraft:
              latest.projectDefaultColumnsDraft ??
              latest.effectiveVisibleColumns,
        ),
      ),
      (policy) => emit(
        latest.copyWith(
          isLoadingProjectPolicy: false,
          clearProjectPolicyError: true,
          policyVersion: policy.version,
          projectDefaultColumnsDraft: policy.defaultColumns
              .map(TaskColumnReference.fromId)
              .toList(),
        ),
      ),
    );
  }

  TaskListPreferencesReady? toggleColumn(
    TaskListPreferencesReady current,
    TaskColumnReference column,
  ) {
    final draft = List<TaskColumnReference>.from(
      current.effectiveProjectDefaultColumns,
    );
    final visible = draft.any(
      (item) => item.id.toLowerCase() == column.id.toLowerCase(),
    );
    if (visible) {
      if (current.isColumnRequired(column.id)) return null;
      draft.removeWhere(
        (item) => item.id.toLowerCase() == column.id.toLowerCase(),
      );
    } else {
      if (!current.isColumnAvailable(column.id)) return null;
      draft.add(column);
    }
    return current.copyWith(projectDefaultColumnsDraft: draft);
  }

  TaskListPreferencesReady? reorderColumns(
    TaskListPreferencesReady current,
    int oldIndex,
    int newIndex,
  ) {
    final draft = List<TaskColumnReference>.from(
      current.effectiveProjectDefaultColumns,
    );
    if (oldIndex < 0 ||
        oldIndex >= draft.length ||
        newIndex < 0 ||
        newIndex >= draft.length ||
        oldIndex == newIndex) {
      return null;
    }
    final moved = draft.removeAt(oldIndex);
    draft.insert(newIndex, moved);
    return current.copyWith(projectDefaultColumnsDraft: draft);
  }

  Future<bool> saveDraft({
    required TaskListPreferencesReady current,
    required bool isClosed,
    required void Function(TaskListPreferencesState) emit,
  }) async {
    emit(current.copyWith(isSaving: true, clearSaveError: true));
    final result = await repository.updatePolicy(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: UpdateProjectTaskListPolicyPayload(
        availableColumns: current.availableColumns.toList(),
        requiredColumns: current.requiredColumns.toList(),
        defaultColumns: current.effectiveProjectDefaultColumns
            .map((column) => column.id)
            .toList(),
        defaultColumnWidths: current.columnWidths,
        defaultSortField: current.sortField,
        defaultSortDirection: current.sortDirection,
        defaultGroupBy: current.groupBy,
        expectedVersion: current.policyVersion,
      ),
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

  Future<void> resetToDefaults({
    required bool isClosed,
    required void Function(TaskListPreferencesState) emit,
    required Future<void> Function() reload,
  }) async {
    final result = await repository.resetUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    await result.fold(
      (error) async => emit(TaskListPreferencesError(error.message)),
      (_) => reload(),
    );
  }
}
