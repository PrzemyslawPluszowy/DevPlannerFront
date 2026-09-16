import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';

/// Kontrakt kluczy i kolejności grup używany przez listę zadań.
///
/// Kolejność systemowego workflow nie zależy od kolejności zwróconej przez API;
/// własne statusy zachowują pozycję nadaną przez backend.
int taskListStatusOrder(ProjectTaskStatus status) => switch (status) {
  ProjectTaskStatus.todo => 0,
  ProjectTaskStatus.inProgress => 1,
  ProjectTaskStatus.blocked => 2,
  ProjectTaskStatus.done => 3,
  ProjectTaskStatus.cancelled => 4,
  ProjectTaskStatus.backlog => 5,
};

ProjectTaskStatus? taskListStatusForGroup(String groupKey) {
  const prefix = 'status:';
  if (!groupKey.startsWith(prefix)) return null;
  final value = groupKey.substring(prefix.length);
  for (final status in ProjectTaskStatus.values) {
    if (status.name.toLowerCase() == value.toLowerCase()) return status;
  }
  return null;
}

String? taskListCustomStatusIdForGroup(String groupKey) {
  const prefix = 'custom-status:';
  if (!groupKey.startsWith(prefix)) return null;
  final id = groupKey.substring(prefix.length);
  return taskListIsUnassignedCustomStatusGroup(groupKey) ? null : id;
}

bool taskListIsUnassignedCustomStatusGroup(String groupKey) =>
    groupKey == 'custom-status:none';

bool taskListCanCreateRootTaskInGroup(
  TaskSavedViewGroupBy groupBy,
  String groupKey,
) =>
    taskListStatusForGroup(groupKey) != null ||
    taskListCustomStatusIdForGroup(groupKey) != null ||
    groupBy == TaskSavedViewGroupBy.none;

String taskListGroupKeyForTask(ProjectTaskListItemResponse task) =>
    'status:${task.status.name[0].toUpperCase()}${task.status.name.substring(1)}';
