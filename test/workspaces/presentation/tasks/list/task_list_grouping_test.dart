import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/task_list_grouping.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('systemowy workflow ma stałą kolejność niezależną od enumu/API', () {
    final statuses = [...ProjectTaskStatus.values]
      ..sort(
        (left, right) =>
            TaskListGrouping.statusOrder(left).compareTo(
              TaskListGrouping.statusOrder(right),
            ),
      );

    expect(statuses, [
      ProjectTaskStatus.todo,
      ProjectTaskStatus.inProgress,
      ProjectTaskStatus.blocked,
      ProjectTaskStatus.done,
      ProjectTaskStatus.cancelled,
      ProjectTaskStatus.backlog,
    ]);
  });

  test('klucze grup statusu są czytane bez rozróżniania wielkości liter', () {
    expect(
      TaskListGrouping.statusForGroup('status:InProgress'),
      ProjectTaskStatus.inProgress,
    );
    expect(
      TaskListGrouping.statusForGroup('status:inprogress'),
      ProjectTaskStatus.inProgress,
    );
    expect(
      TaskListGrouping.statusForGroup('custom-status:workflow-1'),
      isNull,
    );
  });

  test('tworzenie wiersza jest dozwolone tylko w grupie statusu, workflow lub bez grupowania', () {
    expect(
      TaskListGrouping.canCreateRootTaskInGroup(
        TaskSavedViewGroupBy.status,
        'status:Todo',
      ),
      isTrue,
    );
    expect(
      TaskListGrouping.canCreateRootTaskInGroup(
        TaskSavedViewGroupBy.customStatus,
        'custom-status:workflow-1',
      ),
      isTrue,
    );
    expect(
      TaskListGrouping.canCreateRootTaskInGroup(
        TaskSavedViewGroupBy.customStatus,
        'custom-status:none',
      ),
      isFalse,
    );
    expect(
      TaskListGrouping.canCreateRootTaskInGroup(
        TaskSavedViewGroupBy.none,
        'priority:High',
      ),
      isTrue,
    );
  });

  test('klucz grupy zadania zachowuje status kontraktu API', () {
    final task = ProjectTaskListItemResponse(
      id: 'task-1',
      number: 1,
      key: 'TASK-1',
      title: 'Zadanie',
      status: ProjectTaskStatus.blocked,
      priority: TaskPriority.normal,
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    );

    expect(TaskListGrouping.groupKeyForTask(task), 'status:Blocked');
  });
}
