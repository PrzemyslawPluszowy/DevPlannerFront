import 'dart:convert';

import 'package:devplanner/workspaces/data/shared/enums/automation_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:flutter_test/flutter_test.dart';

/// Chroni mapowanie JSON pełnego kontraktu automatyzacji Workspaces.
///
/// Fixture odpowiada nazwom pól i PascalCase enumom backendu C#.
void main() {
  test('payloady reguły zachowują pola i wartości enum wymagane przez API', () {
    const condition = AutomationCondition(
      type: AutomationConditionType.taskStatusIs,
      status: ProjectTaskStatus.todo,
    );
    const action = AutomationAction(
      type: AutomationActionType.setTaskPriority,
      priority: TaskPriority.high,
    );
    const create = CreateAutomationRulePayload(
      name: 'Pilne nowe zadania',
      triggerType: AutomationTriggerType.taskCreated,
      triggerConfig: {},
      conditions: [
        condition,
        AutomationCondition(
          type: AutomationConditionType.taskDueWithinDays,
          days: 14,
        ),
        AutomationCondition(
          type: AutomationConditionType.taskTitleContains,
          text: 'oferta',
        ),
      ],
      actions: [action],
    );
    const update = UpdateAutomationRulePayload(
      name: 'Pilne nowe zadania',
      triggerType: AutomationTriggerType.taskDueSoon,
      triggerConfig: {'days': 3},
      conditions: [condition],
      actions: [action],
      expectedVersion: 9,
    );

    final createJson =
        jsonDecode(jsonEncode(create.toJson())) as Map<String, dynamic>;
    expect(createJson['name'], 'Pilne nowe zadania');
    expect(createJson['triggerType'], 'TaskCreated');
    expect(createJson['triggerConfig'], <String, dynamic>{});
    expect(createJson['conditions'], [
      containsPair('type', 'TaskStatusIs'),
      containsPair('type', 'TaskDueWithinDays'),
      containsPair('type', 'TaskTitleContains'),
    ]);
    expect(
      ((createJson['conditions'] as List).first
          as Map<String, dynamic>)['status'],
      'Todo',
    );
    final conditions = createJson['conditions'] as List<dynamic>;
    expect(
      (conditions[1] as Map<String, dynamic>)['days'],
      14,
    );
    expect(
      (conditions[2] as Map<String, dynamic>)['text'],
      'oferta',
    );
    expect(createJson['actions'], [
      containsPair('type', 'SetTaskPriority'),
    ]);
    expect(
      ((createJson['actions'] as List).single
          as Map<String, dynamic>)['priority'],
      'High',
    );
    final updateJson =
        jsonDecode(jsonEncode(update.toJson())) as Map<String, dynamic>;
    expect(updateJson['expectedVersion'], 9);
    expect(updateJson['triggerType'], 'TaskDueSoon');
    expect(updateJson['triggerConfig'], {'days': 3});
    expect(
      const SetAutomationRuleEnabledPayload(
        enabled: false,
        expectedVersion: 9,
      ).toJson(),
      {'enabled': false, 'expectedVersion': 9},
    );
    expect(
      const AutomationDryRunPayload(
        taskId: '11111111-1111-1111-1111-111111111111',
        eventPayload: {'source': 'test'},
      ).toJson(),
      {
        'taskId': '11111111-1111-1111-1111-111111111111',
        'eventPayload': {'source': 'test'},
      },
    );
    expect(
      const ApplyAutomationRecipePayload(
        name: 'Własna nazwa',
        expectedVersion: 4,
      ).toJson(),
      {'name': 'Własna nazwa', 'expectedVersion': 4},
    );
  });

  test('odpowiedzi automatyzacji odczytują enumy PascalCase, daty i listy', () {
    final rule = AutomationRuleResponse.fromJson({
      'id': 'rule-1',
      'projectId': 'project-1',
      'name': 'Blokuj pilne',
      'triggerType': 'TaskCreated',
      'triggerConfig': <String, dynamic>{},
      'conditions': [
        {'type': 'TaskTitleContains', 'text': 'pilne'},
      ],
      'actions': [
        {'type': 'SetTaskStatus', 'status': 'Blocked'},
      ],
      'isEnabled': true,
      'executionCount': 7,
      'lastExecutedAtUtc': '2026-08-27T12:00:00.000Z',
      'updatedAtUtc': '2026-08-27T13:00:00.000Z',
      'version': 2,
      'archivedAtUtc': null,
    });
    final run = AutomationRunResponse.fromJson({
      'id': 'run-1',
      'ruleId': 'rule-1',
      'triggerEventId': 'event-1',
      'triggerSourceEntity': 'Task',
      'triggerSourceEntityId': 'task-1',
      'status': 'PartiallySucceeded',
      'durationMs': 42,
      'errorMessage': null,
      'executionDetails': {'actions': 1},
      'executedAtUtc': '2026-08-27T12:00:00.000Z',
      'correlationId': 'correlation-1',
      'chainDepth': 0,
    });
    final dryRun = AutomationDryRunResponse.fromJson({
      'ruleId': 'rule-1',
      'taskId': 'task-1',
      'conditionsMatched': true,
      'actions': [
        {
          'type': 'SetTaskStatus',
          'supported': true,
          'description': 'Ustaw status.',
        },
      ],
      'skipReason': null,
    });

    expect(rule.triggerType, AutomationTriggerType.taskCreated);
    expect(rule.actions.single.status, ProjectTaskStatus.blocked);
    expect(rule.lastExecutedAtUtc, DateTime.utc(2026, 8, 27, 12));
    expect(run.status, AutomationRunStatus.partiallySucceeded);
    expect(run.executionDetails, {'actions': 1});
    expect(dryRun.actions.single.type, AutomationActionType.setTaskStatus);
  });

  test('katalog i recipe zachowują deklaracje PascalCase', () {
    final recipe = AutomationRecipe.fromJson({
      'key': 'priority',
      'name': 'Priorytet',
      'description': 'Opis',
      'triggerType': 'TaskKanbanMoved',
      'triggerConfig': <String, dynamic>{},
      'conditions': <Map<String, dynamic>>[],
      'actions': [
        {'type': 'SetTaskPriority', 'priority': 'Critical'},
      ],
    });
    final catalog = AutomationCatalogResponse.fromJson({
      'triggers': [
        {
          'type': 'TaskCreated',
          'supported': true,
          'description': 'Utworzenie zadania.',
        },
      ],
      'conditions': [
        {'type': 'TaskDueWithinDays', 'description': 'Termin.'},
      ],
      'actions': [
        {
          'type': 'CreateSubtask',
          'supported': true,
          'description': 'Podzadanie.',
        },
      ],
    });

    expect(recipe.actions.single.priority, TaskPriority.critical);
    expect(catalog.triggers.single.type, AutomationTriggerType.taskCreated);
    expect(
      catalog.conditions.single.type,
      AutomationConditionType.taskDueWithinDays,
    );
    expect(catalog.actions.single.type, AutomationActionType.createSubtask);
  });
}
