import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';

/// Czysty kontrakt kluczy i kolejności grup używany przez listę zadań.
///
/// Klasa nie przechowuje stanu i nie wykonuje I/O. Kolejność systemowego
/// workflow nie zależy od kolejności zwróconej przez API; własne statusy
/// zachowują pozycję nadaną przez backend.
final class TaskListGrouping {
  const TaskListGrouping._();

  static int statusOrder(ProjectTaskStatus status) => switch (status) {
    ProjectTaskStatus.todo => 0,
    ProjectTaskStatus.inProgress => 1,
    ProjectTaskStatus.blocked => 2,
    ProjectTaskStatus.done => 3,
    ProjectTaskStatus.cancelled => 4,
    ProjectTaskStatus.backlog => 5,
  };

  static ProjectTaskStatus? statusForGroup(String groupKey) {
    const prefix = 'status:';
    if (!groupKey.startsWith(prefix)) return null;
    final value = groupKey.substring(prefix.length);
    for (final status in ProjectTaskStatus.values) {
      if (status.name.toLowerCase() == value.toLowerCase()) return status;
    }
    return null;
  }

  static String? customStatusIdForGroup(String groupKey) {
    const prefix = 'custom-status:';
    if (!groupKey.startsWith(prefix)) return null;
    final id = groupKey.substring(prefix.length);
    return isUnassignedCustomStatusGroup(groupKey) ? null : id;
  }

  static bool isUnassignedCustomStatusGroup(String groupKey) =>
      groupKey == 'custom-status:none';

  static bool canCreateRootTaskInGroup(
    TaskSavedViewGroupBy groupBy,
    String groupKey,
  ) =>
      statusForGroup(groupKey) != null ||
      customStatusIdForGroup(groupKey) != null ||
      groupBy == TaskSavedViewGroupBy.none;

  static String groupKeyForTask(ProjectTaskListItemResponse task) =>
      'status:${task.status.name[0].toUpperCase()}${task.status.name.substring(1)}';
}
