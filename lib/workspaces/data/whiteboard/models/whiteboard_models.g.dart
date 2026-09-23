// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whiteboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateWhiteboardPayload _$CreateWhiteboardPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWhiteboardPayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  type: json['type'] as String? ?? 'Canvas',
);

Map<String, dynamic> _$CreateWhiteboardPayloadToJson(
  _CreateWhiteboardPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'type': instance.type,
};

_UpdateWhiteboardPayload _$UpdateWhiteboardPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWhiteboardPayload(
  name: json['name'] as String,
  description: json['description'] as String?,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateWhiteboardPayloadToJson(
  _UpdateWhiteboardPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'expectedVersion': instance.expectedVersion,
};

_CreateWhiteboardPagePayload _$CreateWhiteboardPagePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWhiteboardPagePayload(
  name: json['name'] as String,
  orientation: json['orientation'] as String? ?? 'Portrait',
  pageFormat: json['pageFormat'] as String? ?? 'A4',
  position: (json['position'] as num?)?.toInt(),
  clientOperationId: json['clientOperationId'] as String?,
);

Map<String, dynamic> _$CreateWhiteboardPagePayloadToJson(
  _CreateWhiteboardPagePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'orientation': instance.orientation,
  'pageFormat': instance.pageFormat,
  'position': instance.position,
  'clientOperationId': instance.clientOperationId,
};

_UpdateWhiteboardPagePayload _$UpdateWhiteboardPagePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWhiteboardPagePayload(
  name: json['name'] as String,
  orientation: json['orientation'] as String,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateWhiteboardPagePayloadToJson(
  _UpdateWhiteboardPagePayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'orientation': instance.orientation,
  'expectedVersion': instance.expectedVersion,
};

_WhiteboardPoint _$WhiteboardPointFromJson(Map<String, dynamic> json) =>
    _WhiteboardPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$WhiteboardPointToJson(_WhiteboardPoint instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};

_WhiteboardConnectorGeometry _$WhiteboardConnectorGeometryFromJson(
  Map<String, dynamic> json,
) => _WhiteboardConnectorGeometry(
  sourceObjectId: json['sourceObjectId'] as String,
  targetObjectId: json['targetObjectId'] as String,
  sourcePort: json['sourcePort'] as String?,
  targetPort: json['targetPort'] as String?,
  controlPoints: (json['controlPoints'] as List<dynamic>)
      .map((e) => WhiteboardPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  endCap: json['endCap'] as String? ?? 'FilledArrow',
);

Map<String, dynamic> _$WhiteboardConnectorGeometryToJson(
  _WhiteboardConnectorGeometry instance,
) => <String, dynamic>{
  'sourceObjectId': instance.sourceObjectId,
  'targetObjectId': instance.targetObjectId,
  'sourcePort': instance.sourcePort,
  'targetPort': instance.targetPort,
  'controlPoints': instance.controlPoints,
  'endCap': instance.endCap,
};

_CreateWhiteboardObjectPayload _$CreateWhiteboardObjectPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWhiteboardObjectPayload(
  kind: json['kind'] as String,
  position: WhiteboardPoint.fromJson(json['position'] as Map<String, dynamic>),
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
  rotation: (json['rotation'] as num).toDouble(),
  data: json['data'] as Map<String, dynamic>,
  connector: json['connector'] == null
      ? null
      : WhiteboardConnectorGeometry.fromJson(
          json['connector'] as Map<String, dynamic>,
        ),
  pageId: json['pageId'] as String?,
  clientOperationId: json['clientOperationId'] as String?,
);

Map<String, dynamic> _$CreateWhiteboardObjectPayloadToJson(
  _CreateWhiteboardObjectPayload instance,
) => <String, dynamic>{
  'kind': instance.kind,
  'position': instance.position,
  'width': instance.width,
  'height': instance.height,
  'rotation': instance.rotation,
  'data': instance.data,
  'connector': instance.connector,
  'pageId': instance.pageId,
  'clientOperationId': instance.clientOperationId,
};

_UpdateWhiteboardObjectPayload _$UpdateWhiteboardObjectPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWhiteboardObjectPayload(
  position: WhiteboardPoint.fromJson(json['position'] as Map<String, dynamic>),
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
  rotation: (json['rotation'] as num).toDouble(),
  data: json['data'] as Map<String, dynamic>,
  connector: json['connector'] == null
      ? null
      : WhiteboardConnectorGeometry.fromJson(
          json['connector'] as Map<String, dynamic>,
        ),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateWhiteboardObjectPayloadToJson(
  _UpdateWhiteboardObjectPayload instance,
) => <String, dynamic>{
  'position': instance.position,
  'width': instance.width,
  'height': instance.height,
  'rotation': instance.rotation,
  'data': instance.data,
  'connector': instance.connector,
  'expectedVersion': instance.expectedVersion,
};

_WhiteboardOperation _$WhiteboardOperationFromJson(Map<String, dynamic> json) =>
    _WhiteboardOperation(
      operationId: json['operationId'] as String,
      kind: json['kind'] as String,
      objectId: json['objectId'] as String?,
      payload: json['payload'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$WhiteboardOperationToJson(
  _WhiteboardOperation instance,
) => <String, dynamic>{
  'operationId': instance.operationId,
  'kind': instance.kind,
  'objectId': instance.objectId,
  'payload': instance.payload,
};

_ApplyWhiteboardOperationsPayload _$ApplyWhiteboardOperationsPayloadFromJson(
  Map<String, dynamic> json,
) => _ApplyWhiteboardOperationsPayload(
  baseVersion: (json['baseVersion'] as num).toInt(),
  operations: (json['operations'] as List<dynamic>)
      .map((e) => WhiteboardOperation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ApplyWhiteboardOperationsPayloadToJson(
  _ApplyWhiteboardOperationsPayload instance,
) => <String, dynamic>{
  'baseVersion': instance.baseVersion,
  'operations': instance.operations,
};

_WhiteboardSummaryResponse _$WhiteboardSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardSummaryResponse(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  type: json['type'] as String,
  version: (json['version'] as num).toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  taskId: json['taskId'] as String?,
  taskMetadata: json['taskMetadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$WhiteboardSummaryResponseToJson(
  _WhiteboardSummaryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'name': instance.name,
  'description': instance.description,
  'type': instance.type,
  'version': instance.version,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'taskId': instance.taskId,
  'taskMetadata': instance.taskMetadata,
};

_WhiteboardResponse _$WhiteboardResponseFromJson(Map<String, dynamic> json) =>
    _WhiteboardResponse(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      version: (json['version'] as num).toInt(),
      currentCursor: json['currentCursor'] as String?,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );

Map<String, dynamic> _$WhiteboardResponseToJson(_WhiteboardResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'version': instance.version,
      'currentCursor': instance.currentCursor,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
    };

_WhiteboardPageResponse _$WhiteboardPageResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardPageResponse(
  id: json['id'] as String,
  whiteboardId: json['whiteboardId'] as String,
  name: json['name'] as String,
  orientation: json['orientation'] as String,
  pageFormat: json['pageFormat'] as String,
  position: (json['position'] as num).toInt(),
  version: (json['version'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$WhiteboardPageResponseToJson(
  _WhiteboardPageResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'whiteboardId': instance.whiteboardId,
  'name': instance.name,
  'orientation': instance.orientation,
  'pageFormat': instance.pageFormat,
  'position': instance.position,
  'version': instance.version,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_WhiteboardObjectResponse _$WhiteboardObjectResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardObjectResponse(
  id: json['id'] as String,
  whiteboardId: json['whiteboardId'] as String,
  pageId: json['pageId'] as String?,
  kind: json['kind'] as String,
  position: WhiteboardPoint.fromJson(json['position'] as Map<String, dynamic>),
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
  rotation: (json['rotation'] as num).toDouble(),
  data: json['data'] as Map<String, dynamic>,
  connector: json['connector'] == null
      ? null
      : WhiteboardConnectorGeometry.fromJson(
          json['connector'] as Map<String, dynamic>,
        ),
  version: (json['version'] as num).toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
  taskId: json['taskId'] as String?,
  taskMetadata: json['taskMetadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$WhiteboardObjectResponseToJson(
  _WhiteboardObjectResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'whiteboardId': instance.whiteboardId,
  'pageId': instance.pageId,
  'kind': instance.kind,
  'position': instance.position,
  'width': instance.width,
  'height': instance.height,
  'rotation': instance.rotation,
  'data': instance.data,
  'connector': instance.connector,
  'version': instance.version,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
  'taskId': instance.taskId,
  'taskMetadata': instance.taskMetadata,
};

_StickyNoteTaskResponse _$StickyNoteTaskResponseFromJson(
  Map<String, dynamic> json,
) => _StickyNoteTaskResponse(
  objectId: json['objectId'] as String,
  taskId: json['taskId'] as String,
  title: json['title'] as String,
  status: json['status'] as String,
  priority: json['priority'] as String,
  alreadyLinked: json['alreadyLinked'] as bool,
  objectVersion: (json['objectVersion'] as num).toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$StickyNoteTaskResponseToJson(
  _StickyNoteTaskResponse instance,
) => <String, dynamic>{
  'objectId': instance.objectId,
  'taskId': instance.taskId,
  'title': instance.title,
  'status': instance.status,
  'priority': instance.priority,
  'alreadyLinked': instance.alreadyLinked,
  'objectVersion': instance.objectVersion,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_CreateTaskFromStickyNotePayload _$CreateTaskFromStickyNotePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateTaskFromStickyNotePayload(
  title: json['title'] as String?,
  description: json['description'] as String?,
  priority:
      $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
      TaskPriority.normal,
  dueAtUtc: json['dueAtUtc'] == null
      ? null
      : DateTime.parse(json['dueAtUtc'] as String),
  assigneeUserIds: (json['assigneeUserIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CreateTaskFromStickyNotePayloadToJson(
  _CreateTaskFromStickyNotePayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'assigneeUserIds': instance.assigneeUserIds,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'Low',
  TaskPriority.normal: 'Normal',
  TaskPriority.high: 'High',
  TaskPriority.critical: 'Critical',
};

_BulkCreateTasksFromStickyNotesPayload
_$BulkCreateTasksFromStickyNotesPayloadFromJson(Map<String, dynamic> json) =>
    _BulkCreateTasksFromStickyNotesPayload(
      objectIds: (json['objectIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      priority:
          $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.normal,
      dueAtUtc: json['dueAtUtc'] == null
          ? null
          : DateTime.parse(json['dueAtUtc'] as String),
      assigneeUserIds: (json['assigneeUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BulkCreateTasksFromStickyNotesPayloadToJson(
  _BulkCreateTasksFromStickyNotesPayload instance,
) => <String, dynamic>{
  'objectIds': instance.objectIds,
  'description': instance.description,
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'dueAtUtc': instance.dueAtUtc?.toIso8601String(),
  'assigneeUserIds': instance.assigneeUserIds,
};

_BulkCreateTasksFromStickyNotesResponse
_$BulkCreateTasksFromStickyNotesResponseFromJson(Map<String, dynamic> json) =>
    _BulkCreateTasksFromStickyNotesResponse(
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => StickyNoteTaskResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdCount: (json['createdCount'] as num).toInt(),
      alreadyLinkedCount: (json['alreadyLinkedCount'] as num).toInt(),
    );

Map<String, dynamic> _$BulkCreateTasksFromStickyNotesResponseToJson(
  _BulkCreateTasksFromStickyNotesResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'createdCount': instance.createdCount,
  'alreadyLinkedCount': instance.alreadyLinkedCount,
};

_WhiteboardSnapshotResponse _$WhiteboardSnapshotResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardSnapshotResponse(
  whiteboard: WhiteboardResponse.fromJson(
    json['whiteboard'] as Map<String, dynamic>,
  ),
  pages: (json['pages'] as List<dynamic>)
      .map((e) => WhiteboardPageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  objects: (json['objects'] as List<dynamic>)
      .map((e) => WhiteboardObjectResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['nextCursor'] as String?,
  resyncRequired: json['resyncRequired'] as bool,
);

Map<String, dynamic> _$WhiteboardSnapshotResponseToJson(
  _WhiteboardSnapshotResponse instance,
) => <String, dynamic>{
  'whiteboard': instance.whiteboard,
  'pages': instance.pages,
  'objects': instance.objects,
  'nextCursor': instance.nextCursor,
  'resyncRequired': instance.resyncRequired,
};

_WhiteboardEventResponse _$WhiteboardEventResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardEventResponse(
  eventId: json['eventId'] as String,
  operationId: json['operationId'] as String,
  version: (json['version'] as num).toInt(),
  eventType: json['eventType'] as String,
  pageId: json['pageId'] as String?,
  objectId: json['objectId'] as String?,
  payload: json['payload'] as Map<String, dynamic>,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$WhiteboardEventResponseToJson(
  _WhiteboardEventResponse instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'operationId': instance.operationId,
  'version': instance.version,
  'eventType': instance.eventType,
  'pageId': instance.pageId,
  'objectId': instance.objectId,
  'payload': instance.payload,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ApplyWhiteboardOperationsResponse _$ApplyWhiteboardOperationsResponseFromJson(
  Map<String, dynamic> json,
) => _ApplyWhiteboardOperationsResponse(
  version: (json['version'] as num).toInt(),
  cursor: json['cursor'] as String?,
  appliedOperationIds: (json['appliedOperationIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ApplyWhiteboardOperationsResponseToJson(
  _ApplyWhiteboardOperationsResponse instance,
) => <String, dynamic>{
  'version': instance.version,
  'cursor': instance.cursor,
  'appliedOperationIds': instance.appliedOperationIds,
};

_WhiteboardTemplateResponse _$WhiteboardTemplateResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardTemplateResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: json['type'] as String,
  pageCount: (json['pageCount'] as num).toInt(),
  objectCount: (json['objectCount'] as num).toInt(),
);

Map<String, dynamic> _$WhiteboardTemplateResponseToJson(
  _WhiteboardTemplateResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'type': instance.type,
  'pageCount': instance.pageCount,
  'objectCount': instance.objectCount,
};

_CreateWhiteboardFromTemplatePayload
_$CreateWhiteboardFromTemplatePayloadFromJson(Map<String, dynamic> json) =>
    _CreateWhiteboardFromTemplatePayload(
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateWhiteboardFromTemplatePayloadToJson(
  _CreateWhiteboardFromTemplatePayload instance,
) => <String, dynamic>{
  'templateId': instance.templateId,
  'name': instance.name,
  'description': instance.description,
};

_DuplicateWhiteboardPayload _$DuplicateWhiteboardPayloadFromJson(
  Map<String, dynamic> json,
) => _DuplicateWhiteboardPayload(
  targetProjectId: json['targetProjectId'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$DuplicateWhiteboardPayloadToJson(
  _DuplicateWhiteboardPayload instance,
) => <String, dynamic>{
  'targetProjectId': instance.targetProjectId,
  'name': instance.name,
  'description': instance.description,
};

_CreateWhiteboardExportPayload _$CreateWhiteboardExportPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWhiteboardExportPayload(
  format: $enumDecode(_$WhiteboardExportFormatEnumMap, json['format']),
  scope: $enumDecode(_$WhiteboardExportScopeEnumMap, json['scope']),
  pageId: json['pageId'] as String?,
  viewport: json['viewport'] == null
      ? null
      : WhiteboardExportViewport.fromJson(
          json['viewport'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CreateWhiteboardExportPayloadToJson(
  _CreateWhiteboardExportPayload instance,
) => <String, dynamic>{
  'format': _$WhiteboardExportFormatEnumMap[instance.format]!,
  'scope': _$WhiteboardExportScopeEnumMap[instance.scope]!,
  'pageId': instance.pageId,
  'viewport': instance.viewport,
};

const _$WhiteboardExportFormatEnumMap = {
  WhiteboardExportFormat.pdf: 'Pdf',
  WhiteboardExportFormat.png: 'Png',
  WhiteboardExportFormat.svg: 'Svg',
};

const _$WhiteboardExportScopeEnumMap = {
  WhiteboardExportScope.entireCanvas: 'EntireCanvas',
  WhiteboardExportScope.currentView: 'CurrentView',
  WhiteboardExportScope.page: 'Page',
};

_WhiteboardExportViewport _$WhiteboardExportViewportFromJson(
  Map<String, dynamic> json,
) => _WhiteboardExportViewport(
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
);

Map<String, dynamic> _$WhiteboardExportViewportToJson(
  _WhiteboardExportViewport instance,
) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
  'width': instance.width,
  'height': instance.height,
};

_WhiteboardExportResponse _$WhiteboardExportResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardExportResponse(
  id: json['id'] as String,
  status: $enumDecode(_$WhiteboardExportJobStatusEnumMap, json['status']),
  format: $enumDecode(_$WhiteboardExportFormatEnumMap, json['format']),
  scope: $enumDecode(_$WhiteboardExportScopeEnumMap, json['scope']),
  storageFileId: json['storageFileId'] as String?,
  failureCode: json['failureCode'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  completedAtUtc: json['completedAtUtc'] == null
      ? null
      : DateTime.parse(json['completedAtUtc'] as String),
);

Map<String, dynamic> _$WhiteboardExportResponseToJson(
  _WhiteboardExportResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': _$WhiteboardExportJobStatusEnumMap[instance.status]!,
  'format': _$WhiteboardExportFormatEnumMap[instance.format]!,
  'scope': _$WhiteboardExportScopeEnumMap[instance.scope]!,
  'storageFileId': instance.storageFileId,
  'failureCode': instance.failureCode,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'completedAtUtc': instance.completedAtUtc?.toIso8601String(),
};

const _$WhiteboardExportJobStatusEnumMap = {
  WhiteboardExportJobStatus.pending: 'Pending',
  WhiteboardExportJobStatus.processing: 'Processing',
  WhiteboardExportJobStatus.completed: 'Completed',
  WhiteboardExportJobStatus.failed: 'Failed',
};

_WhiteboardAiClusterPayload _$WhiteboardAiClusterPayloadFromJson(
  Map<String, dynamic> json,
) => _WhiteboardAiClusterPayload(
  objectIds: (json['objectIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  instruction: json['instruction'] as String?,
);

Map<String, dynamic> _$WhiteboardAiClusterPayloadToJson(
  _WhiteboardAiClusterPayload instance,
) => <String, dynamic>{
  'objectIds': instance.objectIds,
  'instruction': instance.instruction,
};

_WhiteboardAiGenerateFlowPayload _$WhiteboardAiGenerateFlowPayloadFromJson(
  Map<String, dynamic> json,
) => _WhiteboardAiGenerateFlowPayload(
  instruction: json['instruction'] as String,
  pageId: json['pageId'] as String?,
  contextObjectIds: (json['contextObjectIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$WhiteboardAiGenerateFlowPayloadToJson(
  _WhiteboardAiGenerateFlowPayload instance,
) => <String, dynamic>{
  'instruction': instance.instruction,
  'pageId': instance.pageId,
  'contextObjectIds': instance.contextObjectIds,
};

_WhiteboardAiClusterResponse _$WhiteboardAiClusterResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardAiClusterResponse(
  clusterId: json['clusterId'] as String,
  label: json['label'] as String,
  objectIds: (json['objectIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$WhiteboardAiClusterResponseToJson(
  _WhiteboardAiClusterResponse instance,
) => <String, dynamic>{
  'clusterId': instance.clusterId,
  'label': instance.label,
  'objectIds': instance.objectIds,
};

_WhiteboardAiGeneratedObjectResponse
_$WhiteboardAiGeneratedObjectResponseFromJson(Map<String, dynamic> json) =>
    _WhiteboardAiGeneratedObjectResponse(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      kind: json['kind'] as String,
      position: WhiteboardPoint.fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$WhiteboardAiGeneratedObjectResponseToJson(
  _WhiteboardAiGeneratedObjectResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'kind': instance.kind,
  'position': instance.position,
  'width': instance.width,
  'height': instance.height,
  'data': instance.data,
};

_WhiteboardAiGeneratedConnectorResponse
_$WhiteboardAiGeneratedConnectorResponseFromJson(Map<String, dynamic> json) =>
    _WhiteboardAiGeneratedConnectorResponse(
      id: json['id'] as String,
      sourceClientId: json['sourceClientId'] as String,
      targetClientId: json['targetClientId'] as String,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$WhiteboardAiGeneratedConnectorResponseToJson(
  _WhiteboardAiGeneratedConnectorResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceClientId': instance.sourceClientId,
  'targetClientId': instance.targetClientId,
  'label': instance.label,
};

_WhiteboardAiOperationResponse _$WhiteboardAiOperationResponseFromJson(
  Map<String, dynamic> json,
) => _WhiteboardAiOperationResponse(
  operationId: json['operationId'] as String,
  operationType: json['operationType'] as String,
  provider: json['provider'] as String,
  idempotentReplay: json['idempotentReplay'] as bool,
  boardVersion: (json['boardVersion'] as num).toInt(),
  clusters: (json['clusters'] as List<dynamic>)
      .map(
        (e) => WhiteboardAiClusterResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  objects: (json['objects'] as List<dynamic>)
      .map(
        (e) => WhiteboardAiGeneratedObjectResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  connectors: (json['connectors'] as List<dynamic>)
      .map(
        (e) => WhiteboardAiGeneratedConnectorResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$WhiteboardAiOperationResponseToJson(
  _WhiteboardAiOperationResponse instance,
) => <String, dynamic>{
  'operationId': instance.operationId,
  'operationType': instance.operationType,
  'provider': instance.provider,
  'idempotentReplay': instance.idempotentReplay,
  'boardVersion': instance.boardVersion,
  'clusters': instance.clusters,
  'objects': instance.objects,
  'connectors': instance.connectors,
  'warnings': instance.warnings,
};
