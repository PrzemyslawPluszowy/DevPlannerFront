// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectTaskResponse _$ProjectTaskResponseFromJson(Map<String, dynamic> json) =>
    _ProjectTaskResponse(
      id: json['id'] as String,
      number: (json['number'] as num).toInt(),
      key: json['key'] as String,
      workspaceId: json['workspaceId'] as String,
      projectId: json['projectId'] as String,
      parentTaskId: json['parentTaskId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      descriptionDeltaJson: json['descriptionDeltaJson'] as String?,
      status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      taskType: json['taskType'] as String,
      size: (json['size'] as num?)?.toInt(),
      complexity: (json['complexity'] as num?)?.toInt(),
      risk: (json['risk'] as num?)?.toInt(),
      businessValue: (json['businessValue'] as num?)?.toInt(),
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt(),
      actualMinutes: (json['actualMinutes'] as num?)?.toInt(),
      position: (json['position'] as num).toInt(),
      startAtUtc: json['startAtUtc'] == null
          ? null
          : DateTime.parse(json['startAtUtc'] as String),
      dueAtUtc: json['dueAtUtc'] == null
          ? null
          : DateTime.parse(json['dueAtUtc'] as String),
      createdByUserId: json['createdByUserId'] as String,
      assignees: (json['assignees'] as List<dynamic>)
          .map((e) => TaskAssigneeResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      checklistItems: (json['checklistItems'] as List<dynamic>)
          .map(
            (e) =>
                TaskChecklistItemResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      recurrence: json['recurrence'] == null
          ? null
          : TaskRecurrenceSummaryResponse.fromJson(
              json['recurrence'] as Map<String, dynamic>,
            ),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      archivedAtUtc: json['archivedAtUtc'] == null
          ? null
          : DateTime.parse(json['archivedAtUtc'] as String),
      version: (json['version'] as num).toInt(),
      customStatusId: json['customStatusId'] as String?,
      milestoneId: json['milestoneId'] as String?,
    );

Map<String, dynamic> _$ProjectTaskResponseToJson(
  _ProjectTaskResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'parentTaskId': instance.parentTaskId,
  'title': instance.title,
  'description': instance.description,
  'descriptionDeltaJson': instance.descriptionDeltaJson,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'taskType': instance.taskType,
  'size': instance.size,
  'complexity': instance.complexity,
  'risk': instance.risk,
  'businessValue': instance.businessValue,
  'estimatedMinutes': instance.estimatedMinutes,
  'actualMinutes': instance.actualMinutes,
  'position': instance.position,
  'startAtUtc': instance.startAtUtc?.toIso8601String(),
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'createdByUserId': instance.createdByUserId,
  'assignees': instance.assignees,
  'checklistItems': instance.checklistItems,
  'recurrence': instance.recurrence,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
  'version': instance.version,
  'customStatusId': instance.customStatusId,
  'milestoneId': instance.milestoneId,
};

const _$ProjectTaskStatusEnumMap = {
  ProjectTaskStatus.backlog: 'Backlog',
  ProjectTaskStatus.todo: 'Todo',
  ProjectTaskStatus.inProgress: 'InProgress',
  ProjectTaskStatus.blocked: 'Blocked',
  ProjectTaskStatus.done: 'Done',
  ProjectTaskStatus.cancelled: 'Cancelled',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'Low',
  TaskPriority.normal: 'Normal',
  TaskPriority.high: 'High',
  TaskPriority.critical: 'Critical',
};

_TaskMutationResponse<T> _$TaskMutationResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _TaskMutationResponse<T>(
  taskId: json['taskId'] as String,
  taskVersion: (json['taskVersion'] as num).toInt(),
  taskUpdatedAtUtc: DateTime.parse(json['taskUpdatedAtUtc'] as String),
  data: fromJsonT(json['data']),
);

Map<String, dynamic> _$TaskMutationResponseToJson<T>(
  _TaskMutationResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'taskVersion': instance.taskVersion,
  'taskUpdatedAtUtc': instance.taskUpdatedAtUtc.toIso8601String(),
  'data': toJsonT(instance.data),
};

_ReorderedTaskVersionResponse _$ReorderedTaskVersionResponseFromJson(
  Map<String, dynamic> json,
) => _ReorderedTaskVersionResponse(
  taskId: json['taskId'] as String,
  taskVersion: (json['taskVersion'] as num).toInt(),
  taskUpdatedAtUtc: DateTime.parse(json['taskUpdatedAtUtc'] as String),
);

Map<String, dynamic> _$ReorderedTaskVersionResponseToJson(
  _ReorderedTaskVersionResponse instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'taskVersion': instance.taskVersion,
  'taskUpdatedAtUtc': instance.taskUpdatedAtUtc.toIso8601String(),
};

_TaskDependencyResponse _$TaskDependencyResponseFromJson(
  Map<String, dynamic> json,
) => _TaskDependencyResponse(
  id: json['id'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  targetTaskId: json['targetTaskId'] as String,
  type: $enumDecode(_$TaskDependencyTypeEnumMap, json['type']),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  dependencyKind:
      $enumDecodeNullable(
        _$TaskDependencyKindEnumMap,
        json['dependencyKind'],
      ) ??
      TaskDependencyKind.finishToStart,
  lagDays: (json['lagDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TaskDependencyResponseToJson(
  _TaskDependencyResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceTaskId': instance.sourceTaskId,
  'targetTaskId': instance.targetTaskId,
  'type': _$TaskDependencyTypeEnumMap[instance.type]!,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'dependencyKind': _$TaskDependencyKindEnumMap[instance.dependencyKind]!,
  'lagDays': instance.lagDays,
};

const _$TaskDependencyTypeEnumMap = {
  TaskDependencyType.blocks: 'Blocks',
  TaskDependencyType.relatedTo: 'RelatedTo',
  TaskDependencyType.duplicate: 'Duplicate',
};

const _$TaskDependencyKindEnumMap = {
  TaskDependencyKind.finishToStart: 'FinishToStart',
  TaskDependencyKind.startToStart: 'StartToStart',
  TaskDependencyKind.finishToFinish: 'FinishToFinish',
  TaskDependencyKind.startToFinish: 'StartToFinish',
};

_TaskAcceptanceCriterionResponse _$TaskAcceptanceCriterionResponseFromJson(
  Map<String, dynamic> json,
) => _TaskAcceptanceCriterionResponse(
  id: json['id'] as String,
  text: json['text'] as String,
  position: (json['position'] as num).toInt(),
  isAccepted: json['isAccepted'] as bool,
  acceptedByUserId: json['acceptedByUserId'] as String?,
  acceptedAtUtc: json['acceptedAtUtc'] == null
      ? null
      : DateTime.parse(json['acceptedAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$TaskAcceptanceCriterionResponseToJson(
  _TaskAcceptanceCriterionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'position': instance.position,
  'isAccepted': instance.isAccepted,
  'acceptedByUserId': instance.acceptedByUserId,
  'acceptedAtUtc': instance.acceptedAtUtc?.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_TaskWatcherResponse _$TaskWatcherResponseFromJson(Map<String, dynamic> json) =>
    _TaskWatcherResponse(
      userId: json['userId'] as String,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
    );

Map<String, dynamic> _$TaskWatcherResponseToJson(
  _TaskWatcherResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_TaskMutationAcknowledgementResponse
_$TaskMutationAcknowledgementResponseFromJson(Map<String, dynamic> json) =>
    _TaskMutationAcknowledgementResponse(changed: json['changed'] as bool);

Map<String, dynamic> _$TaskMutationAcknowledgementResponseToJson(
  _TaskMutationAcknowledgementResponse instance,
) => <String, dynamic>{'changed': instance.changed};

_CreateTaskAcceptanceCriterionPayload
_$CreateTaskAcceptanceCriterionPayloadFromJson(Map<String, dynamic> json) =>
    _CreateTaskAcceptanceCriterionPayload(
      text: json['text'] as String,
      expectedVersion: (json['expectedVersion'] as num).toInt(),
    );

Map<String, dynamic> _$CreateTaskAcceptanceCriterionPayloadToJson(
  _CreateTaskAcceptanceCriterionPayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'expectedVersion': instance.expectedVersion,
};

_UpdateTaskAcceptanceCriterionPayload
_$UpdateTaskAcceptanceCriterionPayloadFromJson(Map<String, dynamic> json) =>
    _UpdateTaskAcceptanceCriterionPayload(
      text: json['text'] as String,
      position: (json['position'] as num).toInt(),
      isAccepted: json['isAccepted'] as bool,
      expectedVersion: (json['expectedVersion'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateTaskAcceptanceCriterionPayloadToJson(
  _UpdateTaskAcceptanceCriterionPayload instance,
) => <String, dynamic>{
  'text': instance.text,
  'position': instance.position,
  'isAccepted': instance.isAccepted,
  'expectedVersion': instance.expectedVersion,
};

_UpdateTaskUserPreferencePayload _$UpdateTaskUserPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateTaskUserPreferencePayload(isPinned: json['isPinned'] as bool);

Map<String, dynamic> _$UpdateTaskUserPreferencePayloadToJson(
  _UpdateTaskUserPreferencePayload instance,
) => <String, dynamic>{'isPinned': instance.isPinned};

_ProjectTaskDetailsResponse _$ProjectTaskDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskDetailsResponse(
  task: ProjectTaskResponse.fromJson(json['task'] as Map<String, dynamic>),
  labels: (json['labels'] as List<dynamic>)
      .map((e) => TaskLabelResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  customFields: (json['customFields'] as List<dynamic>)
      .map(
        (e) => TaskCustomFieldDefinitionValueResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  acceptanceCriteria: (json['acceptanceCriteria'] as List<dynamic>)
      .map(
        (e) =>
            TaskAcceptanceCriterionResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  dependencies: (json['dependencies'] as List<dynamic>)
      .map(
        (e) =>
            TaskDependencyDetailsResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  watchers: (json['watchers'] as List<dynamic>)
      .map((e) => TaskWatcherResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  isWatchedByMe: json['isWatchedByMe'] as bool,
  isPinnedByMe: json['isPinnedByMe'] as bool,
  subtasks: (json['subtasks'] as List<dynamic>)
      .map(
        (e) => ProjectTaskSubtaskSummaryResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  workflow: ProjectTaskWorkflowResponse.fromJson(
    json['workflow'] as Map<String, dynamic>,
  ),
  includedUsers: (json['includedUsers'] as List<dynamic>)
      .map((e) => UserReferenceResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  capabilities: json['capabilities'] == null
      ? null
      : TaskCapabilitiesResponse.fromJson(
          json['capabilities'] as Map<String, dynamic>,
        ),
  customStatus: json['customStatus'] == null
      ? null
      : ProjectTaskCustomStatusResponse.fromJson(
          json['customStatus'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ProjectTaskDetailsResponseToJson(
  _ProjectTaskDetailsResponse instance,
) => <String, dynamic>{
  'task': instance.task,
  'labels': instance.labels,
  'customFields': instance.customFields,
  'acceptanceCriteria': instance.acceptanceCriteria,
  'dependencies': instance.dependencies,
  'watchers': instance.watchers,
  'isWatchedByMe': instance.isWatchedByMe,
  'isPinnedByMe': instance.isPinnedByMe,
  'subtasks': instance.subtasks,
  'workflow': instance.workflow,
  'includedUsers': instance.includedUsers,
  'capabilities': instance.capabilities,
  'customStatus': instance.customStatus,
};

_TaskCapabilitiesResponse _$TaskCapabilitiesResponseFromJson(
  Map<String, dynamic> json,
) => _TaskCapabilitiesResponse(
  canEdit: json['canEdit'] as bool,
  canArchive: json['canArchive'] as bool,
  canRestore: json['canRestore'] as bool,
);

Map<String, dynamic> _$TaskCapabilitiesResponseToJson(
  _TaskCapabilitiesResponse instance,
) => <String, dynamic>{
  'canEdit': instance.canEdit,
  'canArchive': instance.canArchive,
  'canRestore': instance.canRestore,
};

_ProjectTaskCustomStatusResponse _$ProjectTaskCustomStatusResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskCustomStatusResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  color: json['color'] as String,
  category: $enumDecode(_$TaskStatusCategoryEnumMap, json['category']),
);

Map<String, dynamic> _$ProjectTaskCustomStatusResponseToJson(
  _ProjectTaskCustomStatusResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'category': _$TaskStatusCategoryEnumMap[instance.category]!,
};

const _$TaskStatusCategoryEnumMap = {
  TaskStatusCategory.todo: 'Todo',
  TaskStatusCategory.inProgress: 'InProgress',
  TaskStatusCategory.done: 'Done',
  TaskStatusCategory.cancelled: 'Cancelled',
};

_UserReferenceResponse _$UserReferenceResponseFromJson(
  Map<String, dynamic> json,
) => _UserReferenceResponse(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$UserReferenceResponseToJson(
  _UserReferenceResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'isActive': instance.isActive,
};

_TaskCustomFieldDefinitionValueResponse
_$TaskCustomFieldDefinitionValueResponseFromJson(Map<String, dynamic> json) =>
    _TaskCustomFieldDefinitionValueResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$TaskCustomFieldTypeEnumMap, json['type']),
      isRequired: json['required'] as bool,
      position: (json['position'] as num).toInt(),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      value: json['value'],
      valueUpdatedAtUtc: json['valueUpdatedAtUtc'] == null
          ? null
          : DateTime.parse(json['valueUpdatedAtUtc'] as String),
    );

Map<String, dynamic> _$TaskCustomFieldDefinitionValueResponseToJson(
  _TaskCustomFieldDefinitionValueResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$TaskCustomFieldTypeEnumMap[instance.type]!,
  'required': instance.isRequired,
  'position': instance.position,
  'options': instance.options,
  'value': instance.value,
  'valueUpdatedAtUtc': instance.valueUpdatedAtUtc?.toIso8601String(),
};

const _$TaskCustomFieldTypeEnumMap = {
  TaskCustomFieldType.text: 'Text',
  TaskCustomFieldType.number: 'Number',
  TaskCustomFieldType.date: 'Date',
  TaskCustomFieldType.boolean: 'Boolean',
  TaskCustomFieldType.singleSelect: 'SingleSelect',
  TaskCustomFieldType.multiSelect: 'MultiSelect',
  TaskCustomFieldType.user: 'User',
};

_TaskDependencyDetailsResponse _$TaskDependencyDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _TaskDependencyDetailsResponse(
  id: json['id'] as String,
  sourceTaskId: json['sourceTaskId'] as String,
  targetTaskId: json['targetTaskId'] as String,
  type: $enumDecode(_$TaskDependencyTypeEnumMap, json['type']),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  relatedTask: ProjectTaskReferenceResponse.fromJson(
    json['relatedTask'] as Map<String, dynamic>,
  ),
  dependencyKind:
      $enumDecodeNullable(
        _$TaskDependencyKindEnumMap,
        json['dependencyKind'],
      ) ??
      TaskDependencyKind.finishToStart,
  lagDays: (json['lagDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TaskDependencyDetailsResponseToJson(
  _TaskDependencyDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceTaskId': instance.sourceTaskId,
  'targetTaskId': instance.targetTaskId,
  'type': _$TaskDependencyTypeEnumMap[instance.type]!,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'relatedTask': instance.relatedTask,
  'dependencyKind': _$TaskDependencyKindEnumMap[instance.dependencyKind]!,
  'lagDays': instance.lagDays,
};

_ProjectTaskReferenceResponse _$ProjectTaskReferenceResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskReferenceResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  title: json['title'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  archivedAtUtc: json['archivedAtUtc'] == null
      ? null
      : DateTime.parse(json['archivedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProjectTaskReferenceResponseToJson(
  _ProjectTaskReferenceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'title': instance.title,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'archivedAtUtc': instance.archivedAtUtc?.toIso8601String(),
  'version': instance.version,
};

_ProjectTaskSubtaskSummaryResponse _$ProjectTaskSubtaskSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectTaskSubtaskSummaryResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  key: json['key'] as String,
  title: json['title'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  version: (json['version'] as num).toInt(),
  customStatusId: json['customStatusId'] as String?,
  customStatusName: json['customStatusName'] as String?,
  customStatusColor: json['customStatusColor'] as String?,
);

Map<String, dynamic> _$ProjectTaskSubtaskSummaryResponseToJson(
  _ProjectTaskSubtaskSummaryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'key': instance.key,
  'title': instance.title,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'version': instance.version,
  'customStatusId': instance.customStatusId,
  'customStatusName': instance.customStatusName,
  'customStatusColor': instance.customStatusColor,
};
