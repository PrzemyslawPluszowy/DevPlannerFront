import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';

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
