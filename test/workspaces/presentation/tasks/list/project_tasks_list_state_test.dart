import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const initial = ProjectTasksListReady(
    tasks: [],
    status: null,
    priority: null,
    assigneeUserId: null,
    myInvolvement: null,
    unassignedOnly: false,
    nextCursor: null,
  );
  const empty = ProjectTaskListGroupResponse(
    key: 'status:Todo',
    displayName: 'Do zrobienia',
    position: 0,
    totalCount: 0,
    items: [],
  );
  test('unfiltered empty group stays available for task creation', () {
    expect(initial.hasActiveFilters, isFalse);
    expect(initial.shouldDisplayGroup(empty), isTrue);
  });
  for (final entry in <String, ProjectTasksListReady>{
    'status': initial.copyWith(status: ProjectTaskStatus.done),
    'priority': initial.copyWith(priority: TaskPriority.high),
    'person': initial.copyWith(assigneeUserId: 'qa-user'),
    'involvement': initial.copyWith(
      myInvolvement: TaskInvolvementFilter.watcher,
    ),
    'unassigned': initial.copyWith(unassignedOnly: true),
    'pinned': initial.copyWith(pinnedOnly: true),
  }.entries) {
    test('${entry.key} hides exhausted empty groups', () {
      expect(entry.value.hasActiveFilters, isTrue);
      expect(entry.value.shouldDisplayGroup(empty), isFalse);
    });
  }
  test('filter keeps a group with a remaining cursor or known results', () {
    final filtered = initial.copyWith(status: ProjectTaskStatus.done);
    expect(
      filtered.shouldDisplayGroup(empty.copyWith(nextCursor: 'next-page')),
      isTrue,
    );
    expect(filtered.shouldDisplayGroup(empty.copyWith(totalCount: 1)), isTrue);
  });
}
