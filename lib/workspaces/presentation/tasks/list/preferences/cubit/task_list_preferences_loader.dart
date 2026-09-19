import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
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

  /// Odczytuje efektywny układ kolumn i wersję preferencji.
  ///
  /// Zwraca stan zamiast go emitować, żeby ten sam odczyt obsłużył zarówno
  /// pierwsze wczytanie widoku, jak i scalenie po konflikcie zapisu.
  Future<Either<ApiError, TaskListPreferencesReady>> fetch() async {
    final result = await repository.getEffectiveConfiguration(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    return result.map(
      (config) => TaskListPreferencesReady(
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
    );
  }
}
