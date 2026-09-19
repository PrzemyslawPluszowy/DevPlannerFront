import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';

/// Czyste przejścia stanu rozwiniętej gałęzi podzadań.
abstract final class TaskListTreeSnapshot {
  /// Wylicza zmianę rozwinięcia gałęzi bez uruchamiania odczytu.
  ///
  /// Cubit wykonuje I/O tylko wtedy, gdy [TaskListTreeExpansion.shouldLoad] jest
  /// prawdą. Dzięki temu ponowne rozwinięcie już zbuforowanej gałęzi nie może
  /// przypadkiem wykonać drugiego żądania ani zgubić jej kursora.
  static TaskListTreeExpansion toggleExpansion(
    ProjectTasksListReady state, {
    required String parentId,
  }) {
    if (state.expandedTaskIds.contains(parentId)) {
      return TaskListTreeExpansion(
        state.copyWith(
          expandedTaskIds: {...state.expandedTaskIds}..remove(parentId),
        ),
        shouldLoad: false,
      );
    }
    final expandedTaskIds = {...state.expandedTaskIds, parentId};
    if (state.subtasksByParentId.containsKey(parentId)) {
      return TaskListTreeExpansion(
        state.copyWith(expandedTaskIds: expandedTaskIds),
        shouldLoad: false,
      );
    }
    return TaskListTreeExpansion(
      state,
      shouldLoad: true,
      expandedTaskIdsForLoad: expandedTaskIds,
    );
  }

  static ProjectTasksListReady startLoading(
    ProjectTasksListReady state, {
    required String parentId,
    required Set<String> expandedTaskIds,
  }) => state.copyWith(
    expandedTaskIds: expandedTaskIds,
    loadingSubtaskParentIds: {...state.loadingSubtaskParentIds, parentId},
    subtaskErrorsByParentId: {...state.subtaskErrorsByParentId}
      ..remove(parentId),
  );

  static ProjectTasksListReady loadFailed(
    ProjectTasksListReady state, {
    required String parentId,
    required String message,
  }) => state.copyWith(
    expandedTaskIds: {...state.expandedTaskIds}..remove(parentId),
    loadingSubtaskParentIds: {...state.loadingSubtaskParentIds}
      ..remove(parentId),
    subtaskErrorsByParentId: {
      ...state.subtaskErrorsByParentId,
      parentId: message,
    },
  );

  static ProjectTasksListReady mergePage(
    ProjectTasksListReady state, {
    required String parentId,
    required List<ProjectTaskListItemResponse> items,
    required String? nextCursor,
    required bool append,
  }) {
    final existing = append
        ? state.subtasksByParentId[parentId] ?? const []
        : const <ProjectTaskListItemResponse>[];
    final knownIds = existing.map((task) => task.id).toSet();
    return state.copyWith(
      loadingSubtaskParentIds: {...state.loadingSubtaskParentIds}
        ..remove(parentId),
      subtasksByParentId: {
        ...state.subtasksByParentId,
        parentId: [
          ...existing,
          ...items.where((task) => knownIds.add(task.id)),
        ],
      },
      nextSubtaskCursorByParentId: {
        ...state.nextSubtaskCursorByParentId,
        parentId: nextCursor,
      },
    );
  }
}

/// Wynik czystej decyzji o rozwinięciu podzadań.
final class TaskListTreeExpansion {
  const TaskListTreeExpansion(
    this.state, {
    required this.shouldLoad,
    this.expandedTaskIdsForLoad,
  });

  final ProjectTasksListReady state;
  final bool shouldLoad;
  final Set<String>? expandedTaskIdsForLoad;
}
