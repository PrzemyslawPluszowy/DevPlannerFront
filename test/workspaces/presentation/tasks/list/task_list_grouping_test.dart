import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/task_list_grouping.dart';

void main() {
  test('systemowy workflow ma stałą kolejność niezależną od enumu/API', () {
    final statuses = [...ProjectTaskStatus.values]
      ..sort(
        (left, right) =>
            taskListStatusOrder(left).compareTo(taskListStatusOrder(right)),
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
      taskListStatusForGroup('status:InProgress'),
      ProjectTaskStatus.inProgress,
    );
    expect(
      taskListStatusForGroup('status:inprogress'),
      ProjectTaskStatus.inProgress,
    );
    expect(taskListStatusForGroup('custom-status:workflow-1'), isNull);
  });

  test('tworzenie wiersza jest dozwolone tylko w grupie statusu, workflow lub bez grupowania', () {
    expect(
      taskListCanCreateRootTaskInGroup(
        TaskSavedViewGroupBy.status,
        'status:Todo',
      ),
      isTrue,
    );
    expect(
      taskListCanCreateRootTaskInGroup(
        TaskSavedViewGroupBy.customStatus,
        'custom-status:workflow-1',
      ),
      isTrue,
    );
    expect(
      taskListCanCreateRootTaskInGroup(
        TaskSavedViewGroupBy.customStatus,
        'custom-status:none',
      ),
      isFalse,
    );
    expect(
      taskListCanCreateRootTaskInGroup(
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

    expect(taskListGroupKeyForTask(task), 'status:Blocked');
  });
}
