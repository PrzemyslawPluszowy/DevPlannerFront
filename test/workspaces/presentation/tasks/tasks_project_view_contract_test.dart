import 'package:devplanner/workspaces/presentation/tasks/tasks_project_view_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TasksProjectView', () {
    test('opens the List on the canonical Tasks address', () {
      expect(TasksProjectView.fromQuery(null), TasksProjectView.list);
      expect(TasksProjectView.fromQuery(''), TasksProjectView.list);
      expect(TasksProjectView.fromQuery('   '), TasksProjectView.list);
    });

    test('resolves the frozen kanban query and its board alias', () {
      expect(TasksProjectView.fromQuery('kanban'), TasksProjectView.board);
      expect(TasksProjectView.fromQuery('KANBAN'), TasksProjectView.board);
      expect(TasksProjectView.fromQuery('board'), TasksProjectView.board);
    });

    test('resolves the remaining Tasks views from the URL', () {
      expect(TasksProjectView.fromQuery('list'), TasksProjectView.list);
      expect(TasksProjectView.fromQuery('timeline'), TasksProjectView.timeline);
      expect(TasksProjectView.fromQuery('workload'), TasksProjectView.workload);
      expect(
        TasksProjectView.fromQuery('recurrence'),
        TasksProjectView.recurrence,
      );
    });

    test('keeps the default view for an unknown query', () {
      expect(TasksProjectView.fromQuery('przeglad'), TasksProjectView.list);
      expect(TasksProjectView.fromQuery('board '), TasksProjectView.board);
    });

    test('serializes every view to its canonical query value', () {
      expect(TasksProjectView.board.queryValue, 'kanban');
      expect(TasksProjectView.list.queryValue, 'list');
      expect(TasksProjectView.timeline.queryValue, 'timeline');
      expect(TasksProjectView.workload.queryValue, 'workload');
      expect(TasksProjectView.recurrence.queryValue, 'recurrence');
    });

    test('round-trips every view through the URL contract', () {
      for (final view in TasksProjectView.values) {
        expect(TasksProjectView.fromQuery(view.queryValue), view);
      }
    });
  });
}
