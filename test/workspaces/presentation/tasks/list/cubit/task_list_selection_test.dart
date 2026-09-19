import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_selection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskListSelection', () {
    test('toggle selects a contiguous range in visible order', () {
      final result = TaskListSelection.toggle(
        selectedIds: {'outside'},
        orderedScopeIds: ['task-1', 'task-2', 'task-3', 'task-4'],
        taskId: 'task-4',
        anchorTaskId: 'task-2',
        range: true,
      );

      expect(result, {'outside', 'task-2', 'task-3', 'task-4'});
    });

    test(
      'toggle falls back to a single task when anchor is no longer loaded',
      () {
        final result = TaskListSelection.toggle(
          selectedIds: {'task-1'},
          orderedScopeIds: ['task-1', 'task-2'],
          taskId: 'task-2',
          anchorTaskId: 'task-no-longer-loaded',
          range: true,
        );

        expect(result, {'task-1', 'task-2'});
      },
    );

    test('toggle ignores a task outside the visible scope', () {
      final result = TaskListSelection.toggle(
        selectedIds: {'task-1'},
        orderedScopeIds: ['task-1'],
        taskId: 'task-2',
        anchorTaskId: 'task-1',
        range: false,
      );

      expect(result, {'task-1'});
    });

    test('containsAll is false for an empty scope', () {
      expect(
        TaskListSelection.containsAll({'task-1'}, const <String>[]),
        isFalse,
      );
    });

    test('containsAll requires every task in the explicit scope', () {
      expect(
        TaskListSelection.containsAll(
          {'task-1', 'task-2'},
          {
            'task-1',
            'task-2',
          },
        ),
        isTrue,
      );
      expect(
        TaskListSelection.containsAll({'task-1'}, {'task-1', 'task-2'}),
        isFalse,
      );
    });

    test('selecting a group scope preserves selections from other groups', () {
      final result = TaskListSelection.setScope(
        selectedIds: {'backlog-1'},
        scopeIds: {'in-progress-1', 'in-progress-2'},
        selected: true,
      );

      expect(result, {'backlog-1', 'in-progress-1', 'in-progress-2'});
    });

    test('clearing a branch scope does not clear parent or another group', () {
      final result = TaskListSelection.setScope(
        selectedIds: {'parent', 'child-1', 'child-2', 'backlog-1'},
        scopeIds: {'child-1', 'child-2'},
        selected: false,
      );

      expect(result, {'parent', 'backlog-1'});
    });

    test('setScope does not mutate the previous selection', () {
      final selectedIds = {'task-1'};

      final result = TaskListSelection.setScope(
        selectedIds: selectedIds,
        scopeIds: {'task-2'},
        selected: true,
      );

      expect(selectedIds, {'task-1'});
      expect(result, {'task-1', 'task-2'});
      expect(() => result.add('task-3'), throwsUnsupportedError);
    });
  });
}
