import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('task request and response enums round-trip every exact wire value', () {
    const taskStatuses = <ProjectTaskStatus, String>{
      ProjectTaskStatus.backlog: 'Backlog',
      ProjectTaskStatus.todo: 'Todo',
      ProjectTaskStatus.inProgress: 'InProgress',
      ProjectTaskStatus.blocked: 'Blocked',
      ProjectTaskStatus.done: 'Done',
      ProjectTaskStatus.cancelled: 'Cancelled',
    };
    _assertWireValues(
      ProjectTaskStatus.values,
      taskStatuses,
      (wire) => _taskPayloadFromJson(status: wire).status,
      (value) => _taskPayloadFor(status: value).toJson()['status']! as String,
    );

    const priorities = <TaskPriority, String>{
      TaskPriority.low: 'Low',
      TaskPriority.normal: 'Normal',
      TaskPriority.high: 'High',
      TaskPriority.critical: 'Critical',
    };
    _assertWireValues(
      TaskPriority.values,
      priorities,
      (wire) => _taskPayloadFromJson(priority: wire).priority,
      (value) =>
          _taskPayloadFor(priority: value).toJson()['priority']! as String,
    );

    const categories = <TaskStatusCategory, String>{
      TaskStatusCategory.todo: 'Todo',
      TaskStatusCategory.inProgress: 'InProgress',
      TaskStatusCategory.done: 'Done',
      TaskStatusCategory.cancelled: 'Cancelled',
    };
    _assertWireValues(
      TaskStatusCategory.values,
      categories,
      (wire) => _workflowStatusFromJson(wire).category,
      (value) => _workflowStatusFor(value).toJson()['category']! as String,
    );

    const dependencyTypes = <TaskDependencyType, String>{
      TaskDependencyType.blocks: 'Blocks',
      TaskDependencyType.relatedTo: 'RelatedTo',
      TaskDependencyType.duplicate: 'Duplicate',
    };
    _assertWireValues(
      TaskDependencyType.values,
      dependencyTypes,
      (wire) => _dependencyFromJson(type: wire).type,
      (value) => _dependencyFor(type: value).toJson()['type']! as String,
    );

    const dependencyKinds = <TaskDependencyKind, String>{
      TaskDependencyKind.finishToStart: 'FinishToStart',
      TaskDependencyKind.startToStart: 'StartToStart',
      TaskDependencyKind.finishToFinish: 'FinishToFinish',
      TaskDependencyKind.startToFinish: 'StartToFinish',
    };
    _assertWireValues(
      TaskDependencyKind.values,
      dependencyKinds,
      (wire) => _dependencyFromJson(kind: wire).dependencyKind,
      (value) =>
          _dependencyFor(kind: value).toJson()['dependencyKind']! as String,
    );

    const recurrenceModes = <TaskRecurrenceMode, String>{
      TaskRecurrenceMode.scheduled: 'Scheduled',
      TaskRecurrenceMode.afterCompletion: 'AfterCompletion',
    };
    _assertWireValues(
      TaskRecurrenceMode.values,
      recurrenceModes,
      (wire) => _recurrenceFromJson(mode: wire).mode,
      (value) => _recurrenceFor(mode: value).toJson()['mode']! as String,
    );

    const recurrenceFrequencies = <TaskRecurrenceFrequency, String>{
      TaskRecurrenceFrequency.daily: 'Daily',
      TaskRecurrenceFrequency.weekly: 'Weekly',
      TaskRecurrenceFrequency.monthly: 'Monthly',
    };
    _assertWireValues(
      TaskRecurrenceFrequency.values,
      recurrenceFrequencies,
      (wire) => _recurrenceFromJson(frequency: wire).frequency,
      (value) =>
          _recurrenceFor(frequency: value).toJson()['frequency']! as String,
    );

    const runOutcomes = <TaskRecurrenceRunOutcome, String>{
      TaskRecurrenceRunOutcome.created: 'Created',
      TaskRecurrenceRunOutcome.skippedPreviousOpen: 'SkippedPreviousOpen',
    };
    _assertWireValues(
      TaskRecurrenceRunOutcome.values,
      runOutcomes,
      (wire) => _recurrenceRunFromJson(wire).outcome,
      (value) => _recurrenceRunFor(value).toJson()['outcome']! as String,
    );

    const customFieldTypes = <TaskCustomFieldType, String>{
      TaskCustomFieldType.text: 'Text',
      TaskCustomFieldType.number: 'Number',
      TaskCustomFieldType.date: 'Date',
      TaskCustomFieldType.boolean: 'Boolean',
      TaskCustomFieldType.singleSelect: 'SingleSelect',
      TaskCustomFieldType.multiSelect: 'MultiSelect',
      TaskCustomFieldType.user: 'User',
    };
    _assertWireValues<TaskCustomFieldType>(
      TaskCustomFieldType.values,
      customFieldTypes,
      (wire) => _customFieldTypeFromJson(wire).type,
      (value) => _customFieldTypeFor(value).toJson()['type']! as String,
    );

    const historyTypes = <TaskHistoryEventType, String>{
      TaskHistoryEventType.created: 'Created',
      TaskHistoryEventType.updated: 'Updated',
      TaskHistoryEventType.statusChanged: 'StatusChanged',
      TaskHistoryEventType.assigneesChanged: 'AssigneesChanged',
      TaskHistoryEventType.checklistChanged: 'ChecklistChanged',
      TaskHistoryEventType.watcherChanged: 'WatcherChanged',
      TaskHistoryEventType.labelsChanged: 'LabelsChanged',
      TaskHistoryEventType.customFieldsChanged: 'CustomFieldsChanged',
      TaskHistoryEventType.acceptanceCriteriaChanged:
          'AcceptanceCriteriaChanged',
      TaskHistoryEventType.dependencyChanged: 'DependencyChanged',
      TaskHistoryEventType.reordered: 'Reordered',
      TaskHistoryEventType.kanbanMoved: 'KanbanMoved',
      TaskHistoryEventType.kanbanRebalanced: 'KanbanRebalanced',
      TaskHistoryEventType.archived: 'Archived',
      TaskHistoryEventType.restored: 'Restored',
      TaskHistoryEventType.recurrenceChanged: 'RecurrenceChanged',
      TaskHistoryEventType.recurrenceOccurrenceCreated:
          'RecurrenceOccurrenceCreated',
    };
    _assertWireValues(
      TaskHistoryEventType.values,
      historyTypes,
      (wire) => _historyEventFromJson(wire).eventType,
      (value) => _historyEventFor(value).toJson()['eventType']! as String,
    );

    const actorTypes = <TaskActorType, String>{
      TaskActorType.user: 'User',
      TaskActorType.system: 'System',
      TaskActorType.automation: 'Automation',
    };
    _assertWireValues(
      TaskActorType.values,
      actorTypes,
      (wire) => TaskHistoryActorResponse.fromJson({'type': wire}).type,
      (value) =>
          TaskHistoryActorResponse(type: value).toJson()['type']! as String,
    );

    const involvement = <TaskInvolvementFilter, String>{
      TaskInvolvementFilter.any: 'Any',
      TaskInvolvementFilter.primaryAssignee: 'PrimaryAssignee',
      TaskInvolvementFilter.collaborator: 'Collaborator',
      TaskInvolvementFilter.assignee: 'Assignee',
      TaskInvolvementFilter.watcher: 'Watcher',
    };
    _assertWireValues(
      TaskInvolvementFilter.values,
      involvement,
      (wire) =>
          TaskSavedViewFilter.fromJson({'myInvolvement': wire}).myInvolvement!,
      (value) =>
          TaskSavedViewFilter(myInvolvement: value).toJson()['myInvolvement']!
              as String,
    );

    _assertSavedViewEnum<TaskSavedViewSortField>(
      TaskSavedViewSortField.values,
      const {
        TaskSavedViewSortField.position: 'Position',
        TaskSavedViewSortField.updatedAtUtc: 'UpdatedAtUtc',
        TaskSavedViewSortField.dueAtUtc: 'DueAtUtc',
        TaskSavedViewSortField.priority: 'Priority',
        TaskSavedViewSortField.title: 'Title',
      },
      'sortField',
      (view) => view.sortField,
    );
    _assertSavedViewEnum<TaskSavedViewSortDirection>(
      TaskSavedViewSortDirection.values,
      const {
        TaskSavedViewSortDirection.ascending: 'Ascending',
        TaskSavedViewSortDirection.descending: 'Descending',
      },
      'sortDirection',
      (view) => view.sortDirection,
    );
    _assertSavedViewEnum<TaskSavedViewGroupBy>(
      TaskSavedViewGroupBy.values,
      const {
        TaskSavedViewGroupBy.none: 'None',
        TaskSavedViewGroupBy.status: 'Status',
        TaskSavedViewGroupBy.customStatus: 'CustomStatus',
        TaskSavedViewGroupBy.priority: 'Priority',
        TaskSavedViewGroupBy.assignee: 'Assignee',
      },
      'groupBy',
      (view) => view.groupBy,
    );
    _assertWireValues(
      TaskSavedViewColumn.values,
      const {
        TaskSavedViewColumn.key: 'Key',
        TaskSavedViewColumn.title: 'Title',
        TaskSavedViewColumn.status: 'Status',
        TaskSavedViewColumn.customStatus: 'CustomStatus',
        TaskSavedViewColumn.priority: 'Priority',
        TaskSavedViewColumn.assignees: 'Assignees',
        TaskSavedViewColumn.owner: 'Owner',
        TaskSavedViewColumn.collaborators: 'Collaborators',
        TaskSavedViewColumn.labels: 'Labels',
        TaskSavedViewColumn.watchers: 'Watchers',
        TaskSavedViewColumn.startAtUtc: 'StartAtUtc',
        TaskSavedViewColumn.dueAtUtc: 'DueAtUtc',
        TaskSavedViewColumn.checklistProgress: 'ChecklistProgress',
        TaskSavedViewColumn.updatedAtUtc: 'UpdatedAtUtc',
        TaskSavedViewColumn.createdAtUtc: 'CreatedAtUtc',
        TaskSavedViewColumn.taskType: 'TaskType',
        TaskSavedViewColumn.size: 'Size',
        TaskSavedViewColumn.complexity: 'Complexity',
        TaskSavedViewColumn.risk: 'Risk',
        TaskSavedViewColumn.businessValue: 'BusinessValue',
        TaskSavedViewColumn.estimatedMinutes: 'EstimatedMinutes',
        TaskSavedViewColumn.actualMinutes: 'ActualMinutes',
        TaskSavedViewColumn.milestone: 'Milestone',
      },
      (wire) => TaskSavedViewDefinition.fromJson({
        'filter': <String, dynamic>{},
        'sortField': 'Position',
        'sortDirection': 'Ascending',
        'groupBy': 'None',
        'columns': <String>[wire],
      }).columns.single,
      (value) =>
          (_savedView(columns: [value]).toJson()['columns']! as List<dynamic>)
                  .single
              as String,
    );

    const autoScheduleModes = <AutoScheduleMode, String>{
      AutoScheduleMode.manual: 'Manual',
      AutoScheduleMode.pushSuccessorsOnly: 'PushSuccessorsOnly',
      AutoScheduleMode.strictCascade: 'StrictCascade',
    };
    _assertWireValues(
      AutoScheduleMode.values,
      autoScheduleModes,
      (wire) => ProjectScheduleSettingsResponse.fromJson({'mode': wire}).mode,
      (value) =>
          ProjectScheduleSettingsResponse(mode: value).toJson()['mode']!
              as String,
    );

    const capacitySources = <CapacitySource, String>{
      CapacitySource.workspaceDefault: 'WorkspaceDefault',
      CapacitySource.projectUserOverride: 'ProjectUserOverride',
    };
    _assertWireValues(
      CapacitySource.values,
      capacitySources,
      (wire) => _workloadFromJson(capacitySource: wire).capacitySource,
      (value) =>
          _workloadFor(capacitySource: value).toJson()['capacitySource']!
              as String,
    );

    const milestoneStatuses = <MilestoneStatus, String>{
      MilestoneStatus.active: 'Active',
      MilestoneStatus.completed: 'Completed',
      MilestoneStatus.cancelled: 'Cancelled',
    };
    _assertWireValues(
      MilestoneStatus.values,
      milestoneStatuses,
      (wire) =>
          UpdateMilestonePayload.fromJson({'name': 'M', 'status': wire}).status,
      (value) =>
          UpdateMilestonePayload(name: 'M', status: value).toJson()['status']!
              as String,
    );
  });

  test(
    'enum decoders fail on unknown wire values and keep declared null defaults',
    () {
      expect(
        () => _taskPayloadFromJson(status: 'FutureStatus'),
        throwsArgumentError,
      );
      expect(
        () => _dependencyFromJson(kind: 'FutureDependencyKind'),
        throwsArgumentError,
      );
      expect(
        () => _workloadFromJson(capacitySource: 'FutureCapacitySource'),
        throwsArgumentError,
      );
      expect(
        _dependencyFromJson().dependencyKind,
        TaskDependencyKind.finishToStart,
      );
      expect(
        _recurrenceFromJson().occurrenceStatus,
        ProjectTaskStatus.todo,
      );
      expect(
        _workloadFromJson().capacitySource,
        CapacitySource.workspaceDefault,
      );
      expect(
        TaskSavedViewFilter.fromJson({'myInvolvement': null}).myInvolvement,
        isNull,
      );
    },
  );

  test(
    'legacy task list policy parser has explicit defaults for unknown strings',
    () {
      final policy = ProjectTaskListPolicyResponse.fromJson({
        'workspaceId': 'workspace-1',
        'projectId': 'project-1',
        'availableColumns': <String>[],
        'requiredColumns': <String>[],
        'defaultColumns': <String>[],
        'defaultColumnWidths': <String, dynamic>{},
        'defaultSortField': 'FutureSort',
        'defaultSortDirection': 'FutureDirection',
        'defaultGroupBy': 'FutureGroup',
        'updatedAtUtc': '2026-09-30T00:00:00Z',
        'version': 1,
      });

      expect(policy.defaultSortField, TaskSavedViewSortField.position);
      expect(policy.defaultSortDirection, TaskSavedViewSortDirection.ascending);
      expect(policy.defaultGroupBy, TaskSavedViewGroupBy.status);
    },
  );
}

void _assertWireValues<T extends Object>(
  List<T> enumValues,
  Map<T, String> expected,
  T Function(String wire) decode,
  String Function(T value) encode,
) {
  expect(expected.keys, unorderedEquals(enumValues));
  for (final entry in expected.entries) {
    expect(decode(entry.value), entry.key);
    expect(encode(entry.key), entry.value);
  }
}

void _assertSavedViewEnum<T extends Object>(
  List<T> enumValues,
  Map<T, String> expected,
  String field,
  T Function(TaskSavedViewDefinition view) read,
) {
  _assertWireValues<T>(
    enumValues,
    expected,
    (wire) => read(_savedViewFrom(field, wire)),
    (value) => _savedViewFor(field, value).toJson()[field] as String,
  );
}

TaskSavedViewDefinition _savedView({
  required List<TaskSavedViewColumn> columns,
}) => TaskSavedViewDefinition(
  filter: const TaskSavedViewFilter(),
  sortField: TaskSavedViewSortField.position,
  sortDirection: TaskSavedViewSortDirection.ascending,
  groupBy: TaskSavedViewGroupBy.none,
  columns: columns,
);

TaskSavedViewDefinition _savedViewFrom(String field, String wire) =>
    TaskSavedViewDefinition.fromJson({
      'filter': <String, dynamic>{},
      'sortField': field == 'sortField' ? wire : 'Position',
      'sortDirection': field == 'sortDirection' ? wire : 'Ascending',
      'groupBy': field == 'groupBy' ? wire : 'None',
      'columns': <String>['Title'],
    });

TaskSavedViewDefinition _savedViewFor(String field, Object value) =>
    TaskSavedViewDefinition(
      filter: const TaskSavedViewFilter(),
      sortField: field == 'sortField'
          ? value as TaskSavedViewSortField
          : TaskSavedViewSortField.position,
      sortDirection: field == 'sortDirection'
          ? value as TaskSavedViewSortDirection
          : TaskSavedViewSortDirection.ascending,
      groupBy: field == 'groupBy'
          ? value as TaskSavedViewGroupBy
          : TaskSavedViewGroupBy.none,
      columns: const [TaskSavedViewColumn.title],
    );

CreateProjectTaskPayload _taskPayloadFromJson({
  String status = 'Todo',
  String priority = 'Normal',
}) => CreateProjectTaskPayload.fromJson({
  'title': 'Task',
  'status': status,
  'priority': priority,
});

CreateProjectTaskPayload _taskPayloadFor({
  ProjectTaskStatus status = ProjectTaskStatus.todo,
  TaskPriority priority = TaskPriority.normal,
}) => CreateProjectTaskPayload(
  title: 'Task',
  status: status,
  priority: priority,
);

ProjectTaskWorkflowStatusResponse _workflowStatusFromJson(String category) =>
    ProjectTaskWorkflowStatusResponse.fromJson({
      'status': 'Todo',
      'displayName': 'Do zrobienia',
      'color': '#123456',
      'position': 1,
      'isInitial': true,
      'isTerminal': false,
      'category': category,
    });

ProjectTaskWorkflowStatusResponse _workflowStatusFor(
  TaskStatusCategory category,
) => ProjectTaskWorkflowStatusResponse(
  status: ProjectTaskStatus.todo,
  displayName: 'Do zrobienia',
  color: '#123456',
  position: 1,
  isInitial: true,
  isTerminal: false,
  category: category,
);

TaskDependencyResponse _dependencyFromJson({
  String type = 'Blocks',
  String kind = 'FinishToStart',
}) => TaskDependencyResponse.fromJson({
  'id': 'dependency-1',
  'sourceTaskId': 'task-1',
  'targetTaskId': 'task-2',
  'type': type,
  'createdAtUtc': '2026-09-30T00:00:00Z',
  'dependencyKind': kind,
});

TaskDependencyResponse _dependencyFor({
  TaskDependencyType type = TaskDependencyType.blocks,
  TaskDependencyKind kind = TaskDependencyKind.finishToStart,
}) => TaskDependencyResponse(
  id: 'dependency-1',
  sourceTaskId: 'task-1',
  targetTaskId: 'task-2',
  type: type,
  createdAtUtc: DateTime.utc(2026, 9, 30),
  dependencyKind: kind,
);

CreateTaskRecurrencePayload _recurrenceFromJson({
  String mode = 'Scheduled',
  String frequency = 'Weekly',
}) => CreateTaskRecurrencePayload.fromJson({
  'mode': mode,
  'frequency': frequency,
  'interval': 1,
  'timeZoneId': 'Europe/Warsaw',
  'expectedVersion': 1,
});

CreateTaskRecurrencePayload _recurrenceFor({
  TaskRecurrenceMode mode = TaskRecurrenceMode.scheduled,
  TaskRecurrenceFrequency frequency = TaskRecurrenceFrequency.weekly,
}) => CreateTaskRecurrencePayload(
  mode: mode,
  frequency: frequency,
  interval: 1,
  timeZoneId: 'Europe/Warsaw',
  expectedVersion: 1,
);

ProjectTaskRecurrenceRunResponse _recurrenceRunFromJson(String outcome) =>
    ProjectTaskRecurrenceRunResponse.fromJson({
      'id': 'run-1',
      'recurrenceRuleId': 'rule-1',
      'sourceTaskId': 'task-1',
      'taskKey': 'TASK-1',
      'taskTitle': 'Task',
      'scheduledAtUtc': '2026-09-30T00:00:00Z',
      'executedAtUtc': '2026-09-30T00:00:00Z',
      'outcome': outcome,
    });

ProjectTaskRecurrenceRunResponse _recurrenceRunFor(
  TaskRecurrenceRunOutcome outcome,
) => ProjectTaskRecurrenceRunResponse(
  id: 'run-1',
  recurrenceRuleId: 'rule-1',
  sourceTaskId: 'task-1',
  taskKey: 'TASK-1',
  taskTitle: 'Task',
  scheduledAtUtc: DateTime.utc(2026, 9, 30),
  executedAtUtc: DateTime.utc(2026, 9, 30),
  outcome: outcome,
);

TaskCustomFieldResponse _customFieldTypeFromJson(String type) =>
    TaskCustomFieldResponse.fromJson({
      'id': 'field-1',
      'name': 'Pole',
      'type': type,
      'required': false,
      'position': 1,
    });

TaskCustomFieldResponse _customFieldTypeFor(TaskCustomFieldType type) =>
    TaskCustomFieldResponse(
      id: 'field-1',
      name: 'Pole',
      type: type,
      isRequired: false,
      position: 1,
    );

TaskHistoryEventResponse _historyEventFromJson(String eventType) =>
    TaskHistoryEventResponse.fromJson({
      'eventId': 'event-1',
      'eventType': eventType,
      'actionLabel': 'Zmiana',
      'actor': {'type': 'User'},
      'changes': <dynamic>[],
      'taskVersion': 1,
      'correlationId': 'correlation-1',
      'createdAtUtc': '2026-09-30T00:00:00Z',
    });

TaskHistoryEventResponse _historyEventFor(TaskHistoryEventType eventType) =>
    TaskHistoryEventResponse(
      eventId: 'event-1',
      eventType: eventType,
      actionLabel: 'Zmiana',
      actor: const TaskHistoryActorResponse(type: TaskActorType.user),
      changes: const [],
      taskVersion: 1,
      correlationId: 'correlation-1',
      createdAtUtc: DateTime.utc(2026, 9, 30),
    );

TaskWorkloadUserResponse _workloadFromJson({
  String capacitySource = 'WorkspaceDefault',
}) => TaskWorkloadUserResponse.fromJson({
  'userId': 'user-1',
  'assignedTaskCount': 1,
  'estimatedMinutes': 30,
  'loggedMinutes': 15,
  'capacitySource': capacitySource,
});

TaskWorkloadUserResponse _workloadFor({
  CapacitySource capacitySource = CapacitySource.workspaceDefault,
}) => TaskWorkloadUserResponse(
  userId: 'user-1',
  assignedTaskCount: 1,
  estimatedMinutes: 30,
  loggedMinutes: 15,
  capacitySource: capacitySource,
);
