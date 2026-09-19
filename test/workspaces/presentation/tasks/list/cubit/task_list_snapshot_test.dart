import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_tree_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskListSnapshot.applyBulkMutation', () {
    test(
      'przenosi tylko zwrócony wiersz, zachowuje wersję i czyści selekcję',
      () {
        final updatedAtUtc = DateTime.utc(2026, 9, 1, 12);
        final current = _ready(
          groups: [
            _group('status:Todo', [_task('todo-1')]),
            _group(
              'status:Blocked',
              [_task('blocked-1', status: ProjectTaskStatus.blocked)],
            ),
          ],
          selectedTaskIds: {'todo-1', 'blocked-1'},
          selectionAnchorTaskId: 'todo-1',
        );

        final next = TaskListSnapshot.applyBulkMutation(
          current,
          [
            BulkUpdatedTaskVersionResponse(
              taskId: 'todo-1',
              version: 7,
              updatedAtUtc: updatedAtUtc,
            ),
          ],
          groupBy: TaskSavedViewGroupBy.status,
          status: ProjectTaskStatus.blocked,
        );

        expect(next.groups[0].items, isEmpty);
        expect(next.groups[0].totalCount, 0);
        expect(next.groups[1].items.map((task) => task.id), [
          'blocked-1',
          'todo-1',
        ]);
        final moved = next.groups[1].items.last;
        expect(moved.status, ProjectTaskStatus.blocked);
        expect(moved.version, 7);
        expect(moved.updatedAtUtc, updatedAtUtc);
        expect(next.selectedTaskIds, isEmpty);
        expect(next.selectionAnchorTaskId, isNull);
      },
    );

    test('archiwizuje wyłącznie rekordy zwrócone przez backend', () {
      final current = _ready(
        groups: [
          _group('status:Todo', [_task('task-1'), _task('task-2')]),
        ],
        selectedTaskIds: {'task-1', 'task-2'},
      );

      final next = TaskListSnapshot.applyBulkMutation(
        current,
        [
          BulkUpdatedTaskVersionResponse(
            taskId: 'task-1',
            version: 2,
            updatedAtUtc: DateTime.utc(2026, 9),
          ),
        ],
        groupBy: TaskSavedViewGroupBy.status,
        archive: true,
      );

      expect(next.groups.single.items.map((task) => task.id), ['task-2']);
      expect(next.groups.single.totalCount, 1);
      expect(next.totalCount, 1);
      expect(next.selectedTaskIds, isEmpty);
    });

    test('usunięcie podzadania nie zmienia licznika zadań głównych', () {
      final root = _task('root');
      final current =
          _ready(
            groups: [
              _group('status:Todo', [root]),
            ],
          ).copyWith(
            subtasksByParentId: {
              root.id: [_task('child').copyWith(parentTaskId: root.id)],
            },
          );

      final next = TaskListSnapshot.removeTask(current, 'child');

      expect(next.groups.single.items.map((task) => task.id), ['root']);
      expect(next.totalCount, 1);
      expect(next.subtasksByParentId[root.id], isEmpty);
    });
  });

  group('TaskListTreeSnapshot.toggleExpansion', () {
    test('zwija istniejącą gałąź bez żądania', () {
      final current = _ready(
        groups: [
          _group('status:Todo', [_task('root')]),
        ],
      ).copyWith(expandedTaskIds: {'root'});

      final result = TaskListTreeSnapshot.toggleExpansion(
        current,
        parentId: 'root',
      );

      expect(result.shouldLoad, isFalse);
      expect(result.state.expandedTaskIds, isEmpty);
    });

    test('otwiera zbuforowaną gałąź bez drugiego żądania', () {
      final root = _task('root');
      final current =
          _ready(
            groups: [
              _group('status:Todo', [root]),
            ],
          ).copyWith(
            subtasksByParentId: {
              root.id: [_task('child').copyWith(parentTaskId: root.id)],
            },
          );

      final result = TaskListTreeSnapshot.toggleExpansion(
        current,
        parentId: root.id,
      );

      expect(result.shouldLoad, isFalse);
      expect(result.state.expandedTaskIds, {root.id});
      expect(result.state.subtasksByParentId[root.id], hasLength(1));
    });

    test(
      'niezbuforowana gałąź zleca odczyt z właściwym stanem rozwinięcia',
      () {
        final current = _ready(
          groups: [
            _group('status:Todo', [_task('root')]),
          ],
        );

        final result = TaskListTreeSnapshot.toggleExpansion(
          current,
          parentId: 'root',
        );

        expect(result.shouldLoad, isTrue);
        expect(result.state, same(current));
        expect(result.expandedTaskIdsForLoad, {'root'});
      },
    );
  });
}

ProjectTasksListReady _ready({
  required List<ProjectTaskListGroupResponse> groups,
  Set<String> selectedTaskIds = const {},
  String? selectionAnchorTaskId,
}) => ProjectTasksListReady(
  tasks: [for (final group in groups) ...group.items],
  status: null,
  priority: null,
  assigneeUserId: null,
  myInvolvement: null,
  unassignedOnly: false,
  nextCursor: null,
  groups: groups,
  totalCount: groups.fold(0, (sum, group) => sum + group.totalCount),
  selectedTaskIds: selectedTaskIds,
  selectionAnchorTaskId: selectionAnchorTaskId,
);

ProjectTaskListGroupResponse _group(
  String key,
  List<ProjectTaskListItemResponse> items,
) => ProjectTaskListGroupResponse(
  key: key,
  displayName: key,
  position: 0,
  totalCount: items.length,
  items: items,
);

ProjectTaskListItemResponse _task(
  String id, {
  ProjectTaskStatus status = ProjectTaskStatus.todo,
}) => ProjectTaskListItemResponse(
  id: id,
  number: 1,
  key: 'TASK-$id',
  title: id,
  status: status,
  priority: TaskPriority.normal,
  assignees: const [],
  checklistCompletedCount: 0,
  checklistTotalCount: 0,
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);
