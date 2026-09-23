// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_feature_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateDashboardPreferencePayload _$UpdateDashboardPreferencePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateDashboardPreferencePayload(
  layout: json['layout'] as Map<String, dynamic>,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateDashboardPreferencePayloadToJson(
  _UpdateDashboardPreferencePayload instance,
) => <String, dynamic>{
  'layout': instance.layout,
  'expectedVersion': instance.expectedVersion,
};

_DashboardPreferenceResponse _$DashboardPreferenceResponseFromJson(
  Map<String, dynamic> json,
) => _DashboardPreferenceResponse(
  workspaceId: json['workspaceId'] as String,
  userId: json['userId'] as String,
  context: $enumDecode(_$DashboardContextKindEnumMap, json['context']),
  projectId: json['projectId'] as String?,
  layout: json['layout'] as Map<String, dynamic>,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$DashboardPreferenceResponseToJson(
  _DashboardPreferenceResponse instance,
) => <String, dynamic>{
  'workspaceId': instance.workspaceId,
  'userId': instance.userId,
  'context': _$DashboardContextKindEnumMap[instance.context]!,
  'projectId': instance.projectId,
  'layout': instance.layout,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

const _$DashboardContextKindEnumMap = {
  DashboardContextKind.personal: 'Personal',
  DashboardContextKind.project: 'Project',
};

_WorkspaceActivityItemResponse _$WorkspaceActivityItemResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceActivityItemResponse(
  id: json['id'] as String,
  sourceModule: json['sourceModule'] as String,
  eventType: json['eventType'] as String,
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String?,
  entityId: json['entityId'] as String,
  actorCoreUserId: json['actorCoreUserId'] as String?,
  occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
  metadataJson: json['metadataJson'] as String?,
);

Map<String, dynamic> _$WorkspaceActivityItemResponseToJson(
  _WorkspaceActivityItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceModule': instance.sourceModule,
  'eventType': instance.eventType,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'entityId': instance.entityId,
  'actorCoreUserId': instance.actorCoreUserId,
  'occurredAtUtc': instance.occurredAtUtc.toIso8601String(),
  'metadataJson': instance.metadataJson,
};

_WorkspaceActivityPageResponse _$WorkspaceActivityPageResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceActivityPageResponse(
  items: (json['items'] as List<dynamic>)
      .map(
        (e) =>
            WorkspaceActivityItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$WorkspaceActivityPageResponseToJson(
  _WorkspaceActivityPageResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'nextCursor': instance.nextCursor,
};

_CreateCrossModuleSyncLinkPayload _$CreateCrossModuleSyncLinkPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateCrossModuleSyncLinkPayload(
  taskId: json['taskId'] as String,
  sourceKind: $enumDecode(
    _$CrossModuleSyncSourceKindEnumMap,
    json['sourceKind'],
  ),
  sourceId: json['sourceId'] as String,
);

Map<String, dynamic> _$CreateCrossModuleSyncLinkPayloadToJson(
  _CreateCrossModuleSyncLinkPayload instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'sourceKind': _$CrossModuleSyncSourceKindEnumMap[instance.sourceKind]!,
  'sourceId': instance.sourceId,
};

const _$CrossModuleSyncSourceKindEnumMap = {
  CrossModuleSyncSourceKind.whiteboardStickyNote: 'WhiteboardStickyNote',
  CrossModuleSyncSourceKind.wikiPage: 'WikiPage',
};

_CrossModuleSyncLinkResponse _$CrossModuleSyncLinkResponseFromJson(
  Map<String, dynamic> json,
) => _CrossModuleSyncLinkResponse(
  id: json['id'] as String,
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  taskId: json['taskId'] as String,
  sourceKind: $enumDecode(
    _$CrossModuleSyncSourceKindEnumMap,
    json['sourceKind'],
  ),
  sourceId: json['sourceId'] as String,
  status: $enumDecode(_$CrossModuleSyncLinkStatusEnumMap, json['status']),
  lastTaskVersion: (json['lastTaskVersion'] as num).toInt(),
  lastSourceVersion: (json['lastSourceVersion'] as num).toInt(),
  lastCorrelationId: json['lastCorrelationId'] as String?,
  lastError: json['lastError'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$CrossModuleSyncLinkResponseToJson(
  _CrossModuleSyncLinkResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'taskId': instance.taskId,
  'sourceKind': _$CrossModuleSyncSourceKindEnumMap[instance.sourceKind]!,
  'sourceId': instance.sourceId,
  'status': _$CrossModuleSyncLinkStatusEnumMap[instance.status]!,
  'lastTaskVersion': instance.lastTaskVersion,
  'lastSourceVersion': instance.lastSourceVersion,
  'lastCorrelationId': instance.lastCorrelationId,
  'lastError': instance.lastError,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'version': instance.version,
};

const _$CrossModuleSyncLinkStatusEnumMap = {
  CrossModuleSyncLinkStatus.active: 'Active',
  CrossModuleSyncLinkStatus.paused: 'Paused',
  CrossModuleSyncLinkStatus.conflict: 'Conflict',
};

_SetCrossModuleSyncLinkStatePayload
_$SetCrossModuleSyncLinkStatePayloadFromJson(Map<String, dynamic> json) =>
    _SetCrossModuleSyncLinkStatePayload(
      paused: json['paused'] as bool,
      expectedVersion: (json['expectedVersion'] as num).toInt(),
    );

Map<String, dynamic> _$SetCrossModuleSyncLinkStatePayloadToJson(
  _SetCrossModuleSyncLinkStatePayload instance,
) => <String, dynamic>{
  'paused': instance.paused,
  'expectedVersion': instance.expectedVersion,
};

_HomeDashboardTaskResponse _$HomeDashboardTaskResponseFromJson(
  Map<String, dynamic> json,
) => _HomeDashboardTaskResponse(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  title: json['title'] as String,
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String,
  status: $enumDecode(_$ProjectTaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  deepLink: json['deepLink'] as String,
);

Map<String, dynamic> _$HomeDashboardTaskResponseToJson(
  _HomeDashboardTaskResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'title': instance.title,
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'status': _$ProjectTaskStatusEnumMap[instance.status]!,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'deepLink': instance.deepLink,
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

_HomeDashboardActivityResponse _$HomeDashboardActivityResponseFromJson(
  Map<String, dynamic> json,
) => _HomeDashboardActivityResponse(
  id: json['id'] as String,
  sourceModule: json['sourceModule'] as String,
  eventType: json['eventType'] as String,
  projectId: json['projectId'] as String?,
  entityId: json['entityId'] as String?,
  occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
);

Map<String, dynamic> _$HomeDashboardActivityResponseToJson(
  _HomeDashboardActivityResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceModule': instance.sourceModule,
  'eventType': instance.eventType,
  'projectId': instance.projectId,
  'entityId': instance.entityId,
  'occurredAtUtc': instance.occurredAtUtc.toIso8601String(),
};

_HomeDashboardResourceResponse _$HomeDashboardResourceResponseFromJson(
  Map<String, dynamic> json,
) => _HomeDashboardResourceResponse(
  id: json['id'] as String,
  resourceType: json['resourceType'] as String,
  name: json['name'] as String,
  projectId: json['projectId'] as String?,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  deepLink: json['deepLink'] as String,
);

Map<String, dynamic> _$HomeDashboardResourceResponseToJson(
  _HomeDashboardResourceResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'resourceType': instance.resourceType,
  'name': instance.name,
  'projectId': instance.projectId,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'deepLink': instance.deepLink,
};

_HomeDashboardDiscussionResponse _$HomeDashboardDiscussionResponseFromJson(
  Map<String, dynamic> json,
) => _HomeDashboardDiscussionResponse(
  conversationId: json['conversationId'] as String,
  name: json['name'] as String?,
  unreadMessageCount: (json['unreadMessageCount'] as num).toInt(),
  latestMessageAtUtc: DateTime.parse(json['latestMessageAtUtc'] as String),
  deepLink: json['deepLink'] as String,
);

Map<String, dynamic> _$HomeDashboardDiscussionResponseToJson(
  _HomeDashboardDiscussionResponse instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'name': instance.name,
  'unreadMessageCount': instance.unreadMessageCount,
  'latestMessageAtUtc': instance.latestMessageAtUtc.toIso8601String(),
  'deepLink': instance.deepLink,
};

_HomeDashboardKeyResultResponse _$HomeDashboardKeyResultResponseFromJson(
  Map<String, dynamic> json,
) => _HomeDashboardKeyResultResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  currentValue: (json['currentValue'] as num).toDouble(),
  targetValue: (json['targetValue'] as num).toDouble(),
  projectId: json['projectId'] as String?,
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  deepLink: json['deepLink'] as String,
);

Map<String, dynamic> _$HomeDashboardKeyResultResponseToJson(
  _HomeDashboardKeyResultResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'currentValue': instance.currentValue,
  'targetValue': instance.targetValue,
  'projectId': instance.projectId,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'deepLink': instance.deepLink,
};

_HomeDashboardResponse _$HomeDashboardResponseFromJson(
  Map<String, dynamic> json,
) => _HomeDashboardResponse(
  workspaceId: json['workspaceId'] as String,
  unreadNotifications: (json['unreadNotifications'] as num).toInt(),
  openTasks: (json['openTasks'] as num).toInt(),
  dueToday: (json['dueToday'] as num).toInt(),
  overdue: (json['overdue'] as num).toInt(),
  nextTasks: (json['nextTasks'] as List<dynamic>)
      .map((e) => HomeDashboardTaskResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentActivity: (json['recentActivity'] as List<dynamic>)
      .map(
        (e) =>
            HomeDashboardActivityResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
  recentResources: (json['recentResources'] as List<dynamic>?)
      ?.map(
        (e) =>
            HomeDashboardResourceResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  unreadDiscussions: (json['unreadDiscussions'] as List<dynamic>?)
      ?.map(
        (e) =>
            HomeDashboardDiscussionResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  assignedKeyResults: (json['assignedKeyResults'] as List<dynamic>?)
      ?.map(
        (e) =>
            HomeDashboardKeyResultResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  teamActivity: (json['teamActivity'] as List<dynamic>?)
      ?.map(
        (e) =>
            HomeDashboardActivityResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$HomeDashboardResponseToJson(
  _HomeDashboardResponse instance,
) => <String, dynamic>{
  'workspaceId': instance.workspaceId,
  'unreadNotifications': instance.unreadNotifications,
  'openTasks': instance.openTasks,
  'dueToday': instance.dueToday,
  'overdue': instance.overdue,
  'nextTasks': instance.nextTasks,
  'recentActivity': instance.recentActivity,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
  'recentResources': instance.recentResources,
  'unreadDiscussions': instance.unreadDiscussions,
  'assignedKeyResults': instance.assignedKeyResults,
  'teamActivity': instance.teamActivity,
};

_ProjectDashboardMilestoneResponse _$ProjectDashboardMilestoneResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectDashboardMilestoneResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$MilestoneStatusEnumMap, json['status']),
  progress: (json['progress'] as num).toDouble(),
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
);

Map<String, dynamic> _$ProjectDashboardMilestoneResponseToJson(
  _ProjectDashboardMilestoneResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': _$MilestoneStatusEnumMap[instance.status]!,
  'progress': instance.progress,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
};

const _$MilestoneStatusEnumMap = {
  MilestoneStatus.active: 'Active',
  MilestoneStatus.completed: 'Completed',
  MilestoneStatus.cancelled: 'Cancelled',
};

_ProjectDashboardResponse _$ProjectDashboardResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectDashboardResponse(
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String,
  kanbanColumnCounts: Map<String, int>.from(json['kanbanColumnCounts'] as Map),
  milestones: (json['milestones'] as List<dynamic>)
      .map(
        (e) => ProjectDashboardMilestoneResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  teamWorkload: TaskWorkloadResponse.fromJson(
    json['teamWorkload'] as Map<String, dynamic>,
  ),
  recentActivity: (json['recentActivity'] as List<dynamic>)
      .map(
        (e) =>
            HomeDashboardActivityResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
  isWipLimitExceeded: json['isWipLimitExceeded'] as bool? ?? false,
  velocityCompletedLast14Days:
      (json['velocityCompletedLast14Days'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProjectDashboardResponseToJson(
  _ProjectDashboardResponse instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'kanbanColumnCounts': instance.kanbanColumnCounts,
  'milestones': instance.milestones,
  'teamWorkload': instance.teamWorkload,
  'recentActivity': instance.recentActivity,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
  'isWipLimitExceeded': instance.isWipLimitExceeded,
  'velocityCompletedLast14Days': instance.velocityCompletedLast14Days,
};

_GlobalSearchTaskResult _$GlobalSearchTaskResultFromJson(
  Map<String, dynamic> json,
) => _GlobalSearchTaskResult(
  id: json['id'] as String,
  taskCode: json['taskCode'] as String,
  title: json['title'] as String,
  status: json['status'] as String,
  projectId: json['projectId'] as String,
);

Map<String, dynamic> _$GlobalSearchTaskResultToJson(
  _GlobalSearchTaskResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'taskCode': instance.taskCode,
  'title': instance.title,
  'status': instance.status,
  'projectId': instance.projectId,
};

_GlobalSearchProjectResult _$GlobalSearchProjectResultFromJson(
  Map<String, dynamic> json,
) => _GlobalSearchProjectResult(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$GlobalSearchProjectResultToJson(
  _GlobalSearchProjectResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
};

_GlobalSearchWikiResult _$GlobalSearchWikiResultFromJson(
  Map<String, dynamic> json,
) => _GlobalSearchWikiResult(
  id: json['id'] as String,
  projectId: json['projectId'] as String?,
  title: json['title'] as String,
  isVerified: json['isVerified'] as bool,
);

Map<String, dynamic> _$GlobalSearchWikiResultToJson(
  _GlobalSearchWikiResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'title': instance.title,
  'isVerified': instance.isVerified,
};

_GlobalSearchFileResult _$GlobalSearchFileResultFromJson(
  Map<String, dynamic> json,
) => _GlobalSearchFileResult(
  id: json['id'] as String,
  projectId: json['projectId'] as String?,
  name: json['name'] as String,
  mimeType: json['mimeType'] as String,
);

Map<String, dynamic> _$GlobalSearchFileResultToJson(
  _GlobalSearchFileResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'name': instance.name,
  'mimeType': instance.mimeType,
};

_GlobalSearchWhiteboardResult _$GlobalSearchWhiteboardResultFromJson(
  Map<String, dynamic> json,
) => _GlobalSearchWhiteboardResult(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$GlobalSearchWhiteboardResultToJson(
  _GlobalSearchWhiteboardResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'name': instance.name,
};

_GlobalSearchChatResult _$GlobalSearchChatResultFromJson(
  Map<String, dynamic> json,
) => _GlobalSearchChatResult(
  messageId: json['messageId'] as String,
  conversationId: json['conversationId'] as String,
  authorCoreUserId: json['authorCoreUserId'] as String,
  conversationName: json['conversationName'] as String?,
  snippet: json['snippet'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$GlobalSearchChatResultToJson(
  _GlobalSearchChatResult instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'conversationId': instance.conversationId,
  'authorCoreUserId': instance.authorCoreUserId,
  'conversationName': instance.conversationName,
  'snippet': instance.snippet,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_GlobalSearchResponse _$GlobalSearchResponseFromJson(
  Map<String, dynamic> json,
) => _GlobalSearchResponse(
  query: json['query'] as String,
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => GlobalSearchTaskResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  projects: (json['projects'] as List<dynamic>)
      .map((e) => GlobalSearchProjectResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  wikiPages: (json['wikiPages'] as List<dynamic>)
      .map((e) => GlobalSearchWikiResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  files: (json['files'] as List<dynamic>)
      .map((e) => GlobalSearchFileResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  whiteboards: (json['whiteboards'] as List<dynamic>)
      .map(
        (e) => GlobalSearchWhiteboardResult.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  chatMessages: (json['chatMessages'] as List<dynamic>)
      .map((e) => GlobalSearchChatResult.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GlobalSearchResponseToJson(
  _GlobalSearchResponse instance,
) => <String, dynamic>{
  'query': instance.query,
  'tasks': instance.tasks,
  'projects': instance.projects,
  'wikiPages': instance.wikiPages,
  'files': instance.files,
  'whiteboards': instance.whiteboards,
  'chatMessages': instance.chatMessages,
};
