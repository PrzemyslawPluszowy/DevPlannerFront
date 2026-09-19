import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_list_view_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskListViewSnapshot', () {
    test('poprawnie porównuje dwa identyczne snapshoty przez operator == i hashCode', () {
      final snapshot1 = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(
          statuses: [ProjectTaskStatus.inProgress],
          priorities: [TaskPriority.high],
          pinnedOnly: true,
        ),
        sortField: TaskSavedViewSortField.dueAtUtc,
        sortDirection: TaskSavedViewSortDirection.descending,
        groupBy: TaskSavedViewGroupBy.status,
        columns: const [
          TaskSavedViewColumn.title,
          TaskSavedViewColumn.dueAtUtc,
        ],
        customFieldIds: const ['cf-1', 'cf-2'],
        columnOrder: const ['sys:title', 'cf:cf-1', 'sys:dueAtUtc', 'cf:cf-2'],
      );

      final snapshot2 = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(
          statuses: [ProjectTaskStatus.inProgress],
          priorities: [TaskPriority.high],
          pinnedOnly: true,
        ),
        sortField: TaskSavedViewSortField.dueAtUtc,
        sortDirection: TaskSavedViewSortDirection.descending,
        groupBy: TaskSavedViewGroupBy.status,
        columns: const [
          TaskSavedViewColumn.title,
          TaskSavedViewColumn.dueAtUtc,
        ],
        customFieldIds: const ['cf-1', 'cf-2'],
        columnOrder: const ['sys:title', 'cf:cf-1', 'sys:dueAtUtc', 'cf:cf-2'],
      );

      expect(snapshot1, equals(snapshot2));
      expect(snapshot1.hashCode, equals(snapshot2.hashCode));
    });

    test('wykrywa różnice w filtrach, kolumnach lub sortowaniu', () {
      final base = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(),
        sortField: TaskSavedViewSortField.position,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.none,
        columns: const [TaskSavedViewColumn.title],
        customFieldIds: const [],
        columnOrder: const ['sys:title'],
      );

      final modifiedFilter = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(pinnedOnly: true),
        sortField: TaskSavedViewSortField.position,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.none,
        columns: const [TaskSavedViewColumn.title],
        customFieldIds: const [],
        columnOrder: const ['sys:title'],
      );

      final modifiedSort = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(),
        sortField: TaskSavedViewSortField.title,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.none,
        columns: const [TaskSavedViewColumn.title],
        customFieldIds: const [],
        columnOrder: const ['sys:title'],
      );

      final modifiedOrder = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(),
        sortField: TaskSavedViewSortField.position,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.none,
        columns: const [TaskSavedViewColumn.title, TaskSavedViewColumn.status],
        customFieldIds: const [],
        columnOrder: const ['sys:status', 'sys:title'],
      );

      expect(base == modifiedFilter, isFalse);
      expect(base == modifiedSort, isFalse);
      expect(base == modifiedOrder, isFalse);
    });

    test('toDefinition i fromDefinition poprawnie zachowują pełny stan i kolejność kolumn', () {
      final original = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(
          statuses: [ProjectTaskStatus.todo],
          search: 'dokumentacja',
        ),
        sortField: TaskSavedViewSortField.updatedAtUtc,
        sortDirection: TaskSavedViewSortDirection.descending,
        groupBy: TaskSavedViewGroupBy.priority,
        columns: const [
          TaskSavedViewColumn.title,
          TaskSavedViewColumn.priority,
        ],
        customFieldIds: const ['custom-1'],
        columnOrder: const ['sys:title', 'cf:custom-1', 'sys:priority'],
      );

      final definition = original.toDefinition();
      final restored = TaskListViewSnapshot.fromDefinition(definition);

      expect(restored, equals(original));
      expect(
        restored.columnOrder,
        equals(['sys:title', 'cf:custom-1', 'sys:priority']),
      );
    });

    test('activeFiltersCount precyzyjnie zlicza aktywne filtry', () {
      final emptySnapshot = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(),
        sortField: TaskSavedViewSortField.position,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.none,
        columns: const [TaskSavedViewColumn.title],
        customFieldIds: const [],
        columnOrder: const ['sys:title'],
      );
      expect(emptySnapshot.activeFiltersCount, 0);

      final activeSnapshot = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(
          statuses: [ProjectTaskStatus.inProgress],
          priorities: [TaskPriority.critical],
          pinnedOnly: true,
          search: 'refactor',
        ),
        sortField: TaskSavedViewSortField.position,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.none,
        columns: const [TaskSavedViewColumn.title],
        customFieldIds: const [],
        columnOrder: const ['sys:title'],
      );
      expect(activeSnapshot.activeFiltersCount, 4);
    });
  });
}
