import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';

/// Czyste transformacje lokalnego snapshotu listy.
///
/// Nie wykonuje I/O ani nie zna Cubita. Dzięki temu mutacje potwierdzone przez
/// API i eventy realtime zachowują jedną definicję przenoszenia, podmiany i
/// usuwania rekordów bez resetowania viewportu.
abstract final class TaskListSnapshot {
  static List<ProjectTaskListItemResponse> allLoadedTasks(
    ProjectTasksListReady current,
  ) {
    final seen = <String>{};
    return [
      ...current.tasks,
      for (final children in current.subtasksByParentId.values) ...children,
    ].where((task) => seen.add(task.id)).toList(growable: false);
  }

  static ProjectTaskListItemResponse? findLoadedTask(
    ProjectTasksListReady current,
    String taskId,
  ) {
    for (final group in current.groups) {
      for (final task in group.items) {
        if (task.id == taskId) return task;
      }
    }
    for (final subtasks in current.subtasksByParentId.values) {
      for (final task in subtasks) {
        if (task.id == taskId) return task;
      }
    }
    return null;
  }

  static Iterable<String> loadedGroupTaskIds(
    ProjectTasksListReady current,
    String groupKey,
  ) => current.groups
      .where((group) => group.key == groupKey)
      .expand((group) => group.items)
      .map((task) => task.id);

  static Iterable<String> loadedSubtaskIds(
    ProjectTasksListReady current,
    String parentTaskId,
  ) => (current.subtasksByParentId[parentTaskId] ?? const []).map(
    (task) => task.id,
  );

  static ProjectTasksListReady removeTask(
    ProjectTasksListReady current,
    String taskId,
  ) {
    // `totalCount` opisuje wynik listy zadań głównych. Usunięcie dziecka z
    // cache rozwiniętej gałęzi nie może go zmieniać, natomiast archiwizacja
    // wiersza z grupy musi obniżyć oba liczniki spójnie.
    final removedRootTask = current.groups.any(
      (group) => group.items.any((item) => item.id == taskId),
    );
    final groups = [
      for (final group in current.groups)
        group.copyWith(
          items: group.items.where((item) => item.id != taskId).toList(),
          totalCount: group.items.any((item) => item.id == taskId)
              ? (group.totalCount - 1).clamp(0, group.totalCount)
              : group.totalCount,
        ),
    ];
    return current.copyWith(
      groups: groups,
      tasks: [for (final group in groups) ...group.items],
      totalCount: removedRootTask
          ? (current.totalCount - 1).clamp(0, current.totalCount)
          : current.totalCount,
      subtasksByParentId: {
        for (final entry in current.subtasksByParentId.entries)
          entry.key: entry.value.where((item) => item.id != taskId).toList(),
      },
      selectedTaskIds: {...current.selectedTaskIds}..remove(taskId),
      taskErrorsByTaskId: {...current.taskErrorsByTaskId}..remove(taskId),
    );
  }

  static ProjectTasksListReady appendCreatedRootTask(
    ProjectTasksListReady current,
    ProjectTaskResponse created, {
    required TaskSavedViewGroupBy groupBy,
    required bool hasSavedView,
    TaskSavedViewDefinition? savedViewDefinition,
  }) {
    final task = _toListItem(created);
    // Sprawdzamy czy nowo utworzone zadanie spełnia aktywne filtry listy lub widoku.
    if (!_matchesCurrentRootScope(
      current,
      task,
      hasSavedView: hasSavedView,
      savedViewDefinition: savedViewDefinition,
    )) {
      return current;
    }
    final groupIndex = switch (groupBy) {
      TaskSavedViewGroupBy.status => current.groups.indexWhere(
        (group) => group.key == _statusGroupKey(created.status),
      ),
      TaskSavedViewGroupBy.customStatus when created.customStatusId != null =>
        current.groups.indexWhere(
          (group) => group.key == 'custom-status:${created.customStatusId}',
        ),
      TaskSavedViewGroupBy.none => current.groups.isEmpty ? -1 : 0,
      _ => -1,
    };
    if (groupIndex < 0) return current;
    final groups = [...current.groups];
    final group = groups[groupIndex];
    if (group.items.any((item) => item.id == task.id)) return current;
    groups[groupIndex] = group.copyWith(
      items: [...group.items, task],
      totalCount: group.totalCount + 1,
    );
    return current.copyWith(
      groups: groups,
      tasks: [for (final item in groups) ...item.items],
      totalCount: current.totalCount + 1,
    );
  }

  /// Dopisuje zdalnie utworzone podzadanie tylko do już rozwiniętej gałęzi.
  /// Zamknięta gałąź pozostaje lekka; po jej otwarciu pobierze własną stronę.
  static ProjectTasksListReady appendCreatedSubtaskIfLoaded(
    ProjectTasksListReady current,
    ProjectTaskResponse created, {
    required bool hasSavedView,
  }) {
    final parentId = created.parentTaskId;
    if (parentId == null || !current.subtasksByParentId.containsKey(parentId)) {
      return current;
    }
    final task = _toListItem(created);
    if (!_matchesCurrentRootScope(current, task, hasSavedView: hasSavedView)) {
      return current;
    }
    final children = current.subtasksByParentId[parentId]!;
    if (children.any((item) => item.id == task.id)) return current;
    final groups = [
      for (final group in current.groups)
        group.copyWith(
          items: [
            for (final item in group.items)
              if (item.id == parentId)
                item.copyWith(subtaskCount: item.subtaskCount + 1)
              else
                item,
          ],
        ),
    ];
    return current.copyWith(
      groups: groups,
      tasks: [for (final group in groups) ...group.items],
      subtasksByParentId: {
        ...current.subtasksByParentId,
        parentId: [...children, task],
      },
    );
  }

  static ProjectTasksListReady replaceTask(
    ProjectTasksListReady state,
    ProjectTaskListItemResponse replacement, {
    required TaskSavedViewGroupBy groupBy,
    String? errorForTaskId,
    String? error,
  }) {
    List<ProjectTaskListItemResponse> replace(
      List<ProjectTaskListItemResponse> tasks,
    ) => [
      for (final item in tasks)
        if (item.id == replacement.id) replacement else item,
    ];
    final sourceIndex = state.groups.indexWhere(
      (group) => group.items.any((item) => item.id == replacement.id),
    );
    final targetKey = replacement.parentTaskId != null
        ? null
        : switch (groupBy) {
            TaskSavedViewGroupBy.status =>
              'status:${replacement.status.name[0].toUpperCase()}'
                  '${replacement.status.name.substring(1)}',
            TaskSavedViewGroupBy.customStatus =>
              'custom-status:${replacement.customStatusId ?? 'none'}',
            _ => null,
          };
    final targetIndex = targetKey == null
        ? -1
        : state.groups.indexWhere((group) => group.key == targetKey);
    final groups = [
      for (final group in state.groups)
        group.copyWith(items: replace(group.items)),
    ];

    if (sourceIndex >= 0 && targetIndex >= 0 && sourceIndex != targetIndex) {
      final source = groups[sourceIndex];
      final target = groups[targetIndex];
      groups[sourceIndex] = source.copyWith(
        items: source.items.where((item) => item.id != replacement.id).toList(),
        totalCount: (source.totalCount - 1).clamp(0, source.totalCount),
      );
      groups[targetIndex] = target.copyWith(
        items: [...target.items, replacement],
        totalCount: target.totalCount + 1,
      );
    }
    return state.copyWith(
      groups: groups,
      tasks: [for (final group in groups) ...group.items],
      subtasksByParentId: {
        for (final entry in state.subtasksByParentId.entries)
          entry.key: replace(entry.value),
      },
      taskErrorsByTaskId: errorForTaskId == null
          ? ({...state.taskErrorsByTaskId}..remove(replacement.id))
          : {...state.taskErrorsByTaskId, errorForTaskId: error ?? ''},
    );
  }

  /// Stosuje potwierdzoną mutację tokenową tylko do rekordów widocznych w
  /// lokalnym snapshotie. Serwer zwraca wersje właśnie tych rekordów, dlatego
  /// nie trzeba odczytywać ponownie grup ani materializować niezaładowanych ID.
  static ProjectTasksListReady applyBulkMutation(
    ProjectTasksListReady current,
    List<BulkUpdatedTaskVersionResponse> updatedTasks, {
    required TaskSavedViewGroupBy groupBy,
    ProjectTaskStatus? status,
    String? customStatusId,
    bool clearCustomStatus = false,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    List<String>? assigneeIds,
    bool archive = false,
  }) {
    var next = current;
    for (final updated in updatedTasks) {
      final task = findLoadedTask(next, updated.taskId);
      if (task == null) continue;
      if (archive) {
        next = removeTask(next, task.id);
        continue;
      }
      final replacement = task.copyWith(
        status: status ?? task.status,
        customStatusId: status != null
            ? null
            : clearCustomStatus
            ? null
            : customStatusId ?? task.customStatusId,
        customStatusName: status != null || clearCustomStatus
            ? null
            : task.customStatusName,
        customStatusColor: status != null || clearCustomStatus
            ? null
            : task.customStatusColor,
        priority: priority ?? task.priority,
        dueAtUtc: clearDueAtUtc ? null : dueAtUtc ?? task.dueAtUtc,
        assignees: assigneeIds == null
            ? task.assignees
            : [
                for (final (index, coreUserId) in assigneeIds.indexed)
                  TaskAssigneeResponse(
                    coreUserId: coreUserId,
                    isPrimary: index == 0,
                    createdAtUtc: updated.updatedAtUtc,
                  ),
              ],
        version: updated.version,
        updatedAtUtc: updated.updatedAtUtc,
      );
      next = replaceTask(next, replacement, groupBy: groupBy);
    }
    return next.copyWith(
      selectedTaskIds: const {},
      clearSelectionAnchor: true,
    );
  }

  static String _statusGroupKey(ProjectTaskStatus status) =>
      'status:${status.name[0].toUpperCase()}${status.name.substring(1)}';

  static bool _matchesCurrentRootScope(
    ProjectTasksListReady current,
    ProjectTaskListItemResponse task, {
    required bool hasSavedView,
    TaskSavedViewDefinition? savedViewDefinition,
  }) {
    if (hasSavedView) {
      if (savedViewDefinition == null) return false;
      final filter = savedViewDefinition.filter;
      if (filter.statuses != null &&
          filter.statuses!.isNotEmpty &&
          !filter.statuses!.contains(task.status)) {
        return false;
      }
      if (filter.priorities != null &&
          filter.priorities!.isNotEmpty &&
          !filter.priorities!.contains(task.priority)) {
        return false;
      }
      if (filter.pinnedOnly) return false;
      if (filter.myInvolvement != null) return false;
      if (filter.assigneeCoreUserIds != null &&
          filter.assigneeCoreUserIds!.isNotEmpty) {
        final matches = task.assignees.any(
          (assignee) =>
              filter.assigneeCoreUserIds!.contains(assignee.coreUserId),
        );
        if (!matches) return false;
      }
      if (filter.search != null && filter.search!.trim().isNotEmpty) {
        final query = filter.search!.trim().toLowerCase();
        if (!task.title.toLowerCase().contains(query) &&
            !task.key.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }
    if (current.myInvolvement != null) return false;
    if (current.status != null && task.status != current.status) return false;
    if (current.priority != null && task.priority != current.priority) {
      return false;
    }
    if (current.pinnedOnly) return false;
    if (current.unassignedOnly && task.assignees.isNotEmpty) return false;
    if (current.assigneeCoreUserId case final assigneeId?) {
      return task.assignees.any(
        (assignee) => assignee.coreUserId == assigneeId,
      );
    }
    return true;
  }

  static ProjectTaskListItemResponse _toListItem(ProjectTaskResponse created) =>
      ProjectTaskListItemResponse(
        id: created.id,
        number: created.number,
        key: created.key,
        parentTaskId: created.parentTaskId,
        title: created.title,
        status: created.status,
        priority: created.priority,
        startAtUtc: created.startAtUtc,
        dueAtUtc: created.dueAtUtc,
        assignees: created.assignees,
        checklistCompletedCount: created.checklistItems
            .where((item) => item.isCompleted)
            .length,
        checklistTotalCount: created.checklistItems.length,
        updatedAtUtc: created.updatedAtUtc,
        createdAtUtc: created.createdAtUtc,
        version: created.version,
        customStatusId: created.customStatusId,
        taskType: created.taskType,
        size: created.size,
        complexity: created.complexity,
        risk: created.risk,
        businessValue: created.businessValue,
        estimatedMinutes: created.estimatedMinutes,
        actualMinutes: created.actualMinutes,
      );
}
