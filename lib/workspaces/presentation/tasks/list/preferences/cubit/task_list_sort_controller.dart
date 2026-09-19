import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';

/// Oblicza kolejne ustawienie sortowania bez zależności od UI ani repozytorium.
final class TaskListSortController {
  const TaskListSortController._();

  static TaskListSortChange next(
    TaskListPreferencesReady current,
    TaskSavedViewSortField field,
  ) {
    final initial = switch (field) {
      TaskSavedViewSortField.priority || TaskSavedViewSortField.updatedAtUtc =>
        TaskSavedViewSortDirection.descending,
      _ => TaskSavedViewSortDirection.ascending,
    };
    if (current.sortField != field) {
      return TaskListSortChange(field, initial);
    }
    if (current.sortDirection == initial) {
      final opposite = initial == TaskSavedViewSortDirection.ascending
          ? TaskSavedViewSortDirection.descending
          : TaskSavedViewSortDirection.ascending;
      return TaskListSortChange(field, opposite);
    }
    return const TaskListSortChange(
      TaskSavedViewSortField.position,
      TaskSavedViewSortDirection.ascending,
    );
  }
}

/// Wartość następnego sortowania gotowa do trwałego zapisu.
final class TaskListSortChange {
  const TaskListSortChange(this.field, this.direction);

  final TaskSavedViewSortField field;
  final TaskSavedViewSortDirection direction;
}
