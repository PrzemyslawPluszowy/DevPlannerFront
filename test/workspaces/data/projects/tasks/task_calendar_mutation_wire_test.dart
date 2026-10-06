import 'dart:convert';

import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every date mutation preserves IANA and exact UTC wire instant', () {
    final instant = DateTime.utc(2026, 10, 27, 8, 23, 4, 123, 456);
    final full = UpdateProjectTaskPayload(
      title: 'QA',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      position: 0,
      expectedVersion: 7,
      startAtUtc: instant,
      dueAtUtc: instant,
      calendarTimeZoneId: 'Europe/Warsaw',
    );
    final inline = UpdateTaskListItemPayload(
      expectedVersion: 7,
      dueAtUtc: instant,
      calendarTimeZoneId: 'Europe/Warsaw',
    );
    final selected = BulkUpdateTaskSelectionPayload(
      selectionToken: '',
      tasks: const [
        BulkUpdateTaskItemPayload(taskId: 'task-1', expectedVersion: 7),
      ],
      dueAtUtc: instant,
      calendarTimeZoneId: 'Europe/Warsaw',
    );
    final board = BulkUpdateKanbanTasksPayload(
      tasks: const [
        BulkUpdateKanbanTaskItemPayload(taskId: 'task-1', expectedVersion: 7),
      ],
      dueAtUtc: instant,
      calendarTimeZoneId: 'Europe/Warsaw',
    );
    for (final json in [
      full.toJson(),
      inline.toJson(),
      selected.toJson(),
      board.toJson(),
    ]) {
      expect(json['calendarTimeZoneId'], 'Europe/Warsaw');
      expect(json['dueAtUtc'], '2026-10-27T08:23:04.123456Z');
    }
    expect(UpdateProjectTaskPayload.fromJson(full.toJson()), full);
    expect(UpdateTaskListItemPayload.fromJson(inline.toJson()), inline);
    expect(
      BulkUpdateTaskSelectionPayload.fromJson(
        jsonDecode(jsonEncode(selected.toJson())) as Map<String, dynamic>,
      ),
      selected,
    );
    expect(
      BulkUpdateKanbanTasksPayload.fromJson(
        jsonDecode(jsonEncode(board.toJson())) as Map<String, dynamic>,
      ),
      board,
    );
    expect(
      (jsonDecode(jsonEncode(selected.toJson()))
          as Map<String, dynamic>)['tasks'],
      [
        {'taskId': 'task-1', 'expectedVersion': 7},
      ],
    );
  });

  test('legacy callers omit calendar zone and explicit selection fields', () {
    final payloads = [
      const UpdateProjectTaskPayload(
        title: 'QA',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        position: 0,
        expectedVersion: 1,
      ).toJson(),
      const UpdateTaskListItemPayload(expectedVersion: 1).toJson(),
      const BulkUpdateTaskSelectionPayload(selectionToken: 'token').toJson(),
      const BulkUpdateKanbanTasksPayload(tasks: []).toJson(),
    ];
    for (final json in payloads) {
      expect(json.containsKey('calendarTimeZoneId'), isFalse);
    }
    expect(payloads[2].containsKey('tasks'), isFalse);
  });
}
