import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';

/// Ładuje efektywną konfigurację listy bez mieszania jej z mutacjami UI.
final class TaskListPreferencesLoader {
  const TaskListPreferencesLoader({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  });

  final TaskListConfigurationRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load({
    required bool isClosed,
    required void Function(TaskListPreferencesState) emit,
  }) async {
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
}
