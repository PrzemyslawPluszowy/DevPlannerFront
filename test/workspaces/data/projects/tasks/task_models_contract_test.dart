import 'dart:convert';

import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Kontrakt JSON zależności zadań', () {
    test('payload edycji zachowuje rodzaj, lag i wersję optimistic lock', () {
      const payload = UpdateTaskDependencyPayload(
        dependencyKind: TaskDependencyKind.startToStart,
        lagDays: -2,
        expectedVersion: 14,
      );

      expect(payload.toJson(), {
        'dependencyKind': 'StartToStart',
        'lagDays': -2,
        'expectedVersion': 14,
      });
      expect(
        UpdateTaskDependencyPayload.fromJson(payload.toJson()),
        payload,
      );
    });

    test('stary response bez nowych pól zachowuje kompatybilne wartości', () {
      final dependency = TaskDependencyResponse.fromJson({
        'id': 'dependency-1',
        'sourceTaskId': 'task-1',
        'targetTaskId': 'task-2',
        'type': 'Blocks',
        'createdAtUtc': '2026-08-26T10:00:00.000Z',
      });

      expect(dependency.dependencyKind, TaskDependencyKind.finishToStart);
      expect(dependency.lagDays, 0);
    });

    test('response detailu odczytuje typ oraz lag zwrócone przez backend', () {
      final dependency = TaskDependencyDetailsResponse.fromJson({
        'id': 'dependency-1',
        'sourceTaskId': 'task-1',
        'targetTaskId': 'task-2',
        'type': 'Blocks',
        'createdAtUtc': '2026-08-26T10:00:00.000Z',
        'dependencyKind': 'FinishToFinish',
        'lagDays': 5,
        'relatedTask': {
          'id': 'task-2',
          'number': 2,
          'key': 'TASK-2',
          'title': 'Projekt',
          'status': 'Todo',
          'version': 3,
        },
      });

      expect(dependency.dependencyKind, TaskDependencyKind.finishToFinish);
      expect(dependency.lagDays, 5);
      expect(dependency.relatedTask.status, ProjectTaskStatus.todo);
    });
  });

  group('Kontrakt JSON tworzenia zadania', () {
    test('payload zachowuje docelową własną kolumnę workflow', () {
      const payload = CreateProjectTaskPayload(
        title: 'Task w realizacji',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        customStatusId: 'custom-status-1',
      );

      final json = payload.toJson();
      expect(json['customStatusId'], 'custom-status-1');
      expect(json['targetStatus'], isNull);
      expect(
        CreateProjectTaskPayload.fromJson(json).customStatusId,
        'custom-status-1',
      );
    });
  });

  group('Kontrakt JSON wpisów czasu', () {
    test('dekoduje i koduje wszystkie enumy oraz per-entry capabilities', () {
      final base = TaskTimeEntryResponse(
        id: 'entry-1',
        taskId: 'task-1',
        userId: 'user-1',
        kind: TaskTimeEntryKind.manual,
        startedAtUtc: DateTime.utc(2026, 9, 30, 10),
        durationMinutes: 45,
        isBillable: false,
        createdAtUtc: DateTime.utc(2026, 9, 30, 10),
        approvalStatus: TaskTimeEntryApprovalStatus.draft,
        version: 1,
        canSubmit: true,
      );
      const kindWire = <TaskTimeEntryKind, String>{
        TaskTimeEntryKind.manual: 'Manual',
        TaskTimeEntryKind.timer: 'Timer',
      };
      const approvalWire = <TaskTimeEntryApprovalStatus, String>{
        TaskTimeEntryApprovalStatus.draft: 'Draft',
        TaskTimeEntryApprovalStatus.submitted: 'Submitted',
        TaskTimeEntryApprovalStatus.approved: 'Approved',
        TaskTimeEntryApprovalStatus.rejected: 'Rejected',
      };

      for (final entryKind in TaskTimeEntryKind.values) {
        for (final status in TaskTimeEntryApprovalStatus.values) {
          final source = base.copyWith(kind: entryKind, approvalStatus: status);
          final json = source.toJson();
          expect(json['kind'], kindWire[entryKind]);
          expect(json['approvalStatus'], approvalWire[status]);
          expect(json['canSubmit'], isTrue);
          expect(json['canReview'], isFalse);
          expect(json['canStopTimer'], isFalse);
          expect(TaskTimeEntryResponse.fromJson(json), source);
        }
      }
    });
  });

  group('Kontrakt JSON szczegółów zadania', () {
    test('odczytuje i zapisuje milestone, możliwości oraz własny status', () {
      final details = ProjectTaskDetailsResponse.fromJson({
        'task': {
          'id': 'task-1',
          'number': 1,
          'key': 'TASK-1',
          'workspaceId': 'workspace-1',
          'projectId': 'project-1',
          'title': 'Zadanie',
          'status': 'InProgress',
          'priority': 'High',
          'taskType': 'Task',
          'position': 1000,
          'createdByUserId': 'user-1',
          'assignees': <dynamic>[],
          'checklistItems': <dynamic>[],
          'createdAtUtc': '2026-09-30T10:00:00.000Z',
          'updatedAtUtc': '2026-09-30T10:00:00.000Z',
          'version': 3,
          'customStatusId': 'status-1',
          'milestoneId': 'milestone-1',
        },
        'labels': <dynamic>[],
        'customFields': <dynamic>[],
        'acceptanceCriteria': <dynamic>[],
        'dependencies': <dynamic>[],
        'watchers': <dynamic>[],
        'isWatchedByMe': false,
        'isPinnedByMe': false,
        'subtasks': <dynamic>[],
        'workflow': {'statuses': <dynamic>[], 'transitions': <dynamic>[], 'version': 1},
        'includedUsers': <dynamic>[],
        'capabilities': {
          'canEdit': true,
          'canArchive': false,
          'canRestore': false,
        },
        'customStatus': {
          'id': 'status-1',
          'name': 'W toku',
          'color': '#123ABC',
          'category': 'InProgress',
        },
      });

      expect(details.task.status, ProjectTaskStatus.inProgress);
      expect(details.task.priority, TaskPriority.high);
      expect(details.task.milestoneId, 'milestone-1');
      expect(details.capabilities?.canEdit, isTrue);
      expect(details.customStatus?.category.name, 'inProgress');

      final encoded =
          jsonDecode(jsonEncode(details.toJson())) as Map<String, dynamic>;
      final encodedTask = encoded['task'] as Map<String, dynamic>;
      expect(encodedTask['milestoneId'], 'milestone-1');
      expect(encoded['capabilities'], {
        'canEdit': true,
        'canArchive': false,
        'canRestore': false,
      });
      expect(
        (encoded['customStatus'] as Map<String, dynamic>)['category'],
        'InProgress',
      );
      expect(ProjectTaskDetailsResponse.fromJson(encoded), details);
    });
  });

  group('Kontrakt JSON bulk własnego workflow', () {
    test('payload rozróżnia wyczyszczenie statusu custom od braku zmiany', () {
      const payload = BulkUpdateTaskSelectionPayload(
        selectionToken: 'selection-token',
        clearCustomStatus: true,
        returnTaskIds: ['task-1'],
      );

      final json = payload.toJson();
      expect(json['clearCustomStatus'], isTrue);
      expect(json['customStatusId'], isNull);
      expect(
        BulkUpdateTaskSelectionPayload.fromJson(json).clearCustomStatus,
        isTrue,
      );
    });
  });
}
