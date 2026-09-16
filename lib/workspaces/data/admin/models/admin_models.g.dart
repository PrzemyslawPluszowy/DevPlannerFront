// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SystemErrorLogResponse _$SystemErrorLogResponseFromJson(
  Map<String, dynamic> json,
) => _SystemErrorLogResponse(
  id: json['id'] as String,
  traceId: json['traceId'] as String,
  statusCode: (json['statusCode'] as num).toInt(),
  method: json['method'] as String,
  path: json['path'] as String,
  exceptionType: json['exceptionType'] as String,
  message: json['message'] as String,
  stackTrace: json['stackTrace'] as String?,
  coreUserId: json['coreUserId'] as String?,
  occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
  isResolved: json['isResolved'] as bool,
  resolvedAtUtc: json['resolvedAtUtc'] == null
      ? null
      : DateTime.parse(json['resolvedAtUtc'] as String),
);

Map<String, dynamic> _$SystemErrorLogResponseToJson(
  _SystemErrorLogResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'traceId': instance.traceId,
  'statusCode': instance.statusCode,
  'method': instance.method,
  'path': instance.path,
  'exceptionType': instance.exceptionType,
  'message': instance.message,
  'stackTrace': instance.stackTrace,
  'coreUserId': instance.coreUserId,
  'occurredAtUtc': instance.occurredAtUtc.toIso8601String(),
  'isResolved': instance.isResolved,
  'resolvedAtUtc': instance.resolvedAtUtc?.toIso8601String(),
};

_AdminMaintenanceResultResponse _$AdminMaintenanceResultResponseFromJson(
  Map<String, dynamic> json,
) => _AdminMaintenanceResultResponse(
  affectedRecords: (json['affectedRecords'] as num).toInt(),
  executedAtUtc: DateTime.parse(json['executedAtUtc'] as String),
);

Map<String, dynamic> _$AdminMaintenanceResultResponseToJson(
  _AdminMaintenanceResultResponse instance,
) => <String, dynamic>{
  'affectedRecords': instance.affectedRecords,
  'executedAtUtc': instance.executedAtUtc.toIso8601String(),
};

_PurgeSystemErrorsPayload _$PurgeSystemErrorsPayloadFromJson(
  Map<String, dynamic> json,
) => _PurgeSystemErrorsPayload(
  olderThanDays: (json['olderThanDays'] as num).toInt(),
  onlyResolved: json['onlyResolved'] as bool? ?? false,
);

Map<String, dynamic> _$PurgeSystemErrorsPayloadToJson(
  _PurgeSystemErrorsPayload instance,
) => <String, dynamic>{
  'olderThanDays': instance.olderThanDays,
  'onlyResolved': instance.onlyResolved,
};

_ClamAvProbeResponse _$ClamAvProbeResponseFromJson(Map<String, dynamic> json) =>
    _ClamAvProbeResponse(
      enabled: json['enabled'] as bool,
      reachable: json['reachable'] as bool,
      host: json['host'] as String,
      port: (json['port'] as num).toInt(),
      signatureVersion: json['signatureVersion'] as String?,
      lastSignatureUpdateUtc: json['lastSignatureUpdateUtc'] == null
          ? null
          : DateTime.parse(json['lastSignatureUpdateUtc'] as String),
      scannedFilesLast24Hours:
          (json['scannedFilesLast24Hours'] as num?)?.toInt() ?? 0,
      threatsDetectedLast24Hours:
          (json['threatsDetectedLast24Hours'] as num?)?.toInt() ?? 0,
      quarantinedFiles: (json['quarantinedFiles'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ClamAvProbeResponseToJson(
  _ClamAvProbeResponse instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'reachable': instance.reachable,
  'host': instance.host,
  'port': instance.port,
  'signatureVersion': instance.signatureVersion,
  'lastSignatureUpdateUtc': instance.lastSignatureUpdateUtc?.toIso8601String(),
  'scannedFilesLast24Hours': instance.scannedFilesLast24Hours,
  'threatsDetectedLast24Hours': instance.threatsDetectedLast24Hours,
  'quarantinedFiles': instance.quarantinedFiles,
};

_StorageRescanPayload _$StorageRescanPayloadFromJson(
  Map<String, dynamic> json,
) => _StorageRescanPayload(
  fileId: json['fileId'] as String?,
  limit: (json['limit'] as num?)?.toInt() ?? 100,
);

Map<String, dynamic> _$StorageRescanPayloadToJson(
  _StorageRescanPayload instance,
) => <String, dynamic>{'fileId': instance.fileId, 'limit': instance.limit};

_StorageRescanResponse _$StorageRescanResponseFromJson(
  Map<String, dynamic> json,
) => _StorageRescanResponse(
  executedAtUtc: DateTime.parse(json['executedAtUtc'] as String),
  requestedFiles: (json['requestedFiles'] as num).toInt(),
  scannedFiles: (json['scannedFiles'] as num).toInt(),
  infectedFiles: (json['infectedFiles'] as num).toInt(),
  failedFiles: (json['failedFiles'] as num).toInt(),
);

Map<String, dynamic> _$StorageRescanResponseToJson(
  _StorageRescanResponse instance,
) => <String, dynamic>{
  'executedAtUtc': instance.executedAtUtc.toIso8601String(),
  'requestedFiles': instance.requestedFiles,
  'scannedFiles': instance.scannedFiles,
  'infectedFiles': instance.infectedFiles,
  'failedFiles': instance.failedFiles,
};

_DeadLetterItemResponse _$DeadLetterItemResponseFromJson(
  Map<String, dynamic> json,
) => _DeadLetterItemResponse(
  queueName: json['queueName'] as String,
  id: json['id'] as String,
  attemptCount: (json['attemptCount'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  nextAttemptAtUtc: DateTime.parse(json['nextAttemptAtUtc'] as String),
  lastError: json['lastError'] as String?,
  detail: json['detail'] as String?,
);

Map<String, dynamic> _$DeadLetterItemResponseToJson(
  _DeadLetterItemResponse instance,
) => <String, dynamic>{
  'queueName': instance.queueName,
  'id': instance.id,
  'attemptCount': instance.attemptCount,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'nextAttemptAtUtc': instance.nextAttemptAtUtc.toIso8601String(),
  'lastError': instance.lastError,
  'detail': instance.detail,
};

_AdminRealtimeHubResponse _$AdminRealtimeHubResponseFromJson(
  Map<String, dynamic> json,
) => _AdminRealtimeHubResponse(
  hub: json['hub'] as String,
  activeConnections: (json['activeConnections'] as num).toInt(),
  openRooms: (json['openRooms'] as num).toInt(),
  activeUsers: (json['activeUsers'] as num).toInt(),
);

Map<String, dynamic> _$AdminRealtimeHubResponseToJson(
  _AdminRealtimeHubResponse instance,
) => <String, dynamic>{
  'hub': instance.hub,
  'activeConnections': instance.activeConnections,
  'openRooms': instance.openRooms,
  'activeUsers': instance.activeUsers,
};

_AdminRealtimeInspectorResponse _$AdminRealtimeInspectorResponseFromJson(
  Map<String, dynamic> json,
) => _AdminRealtimeInspectorResponse(
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
  hubs: (json['hubs'] as List<dynamic>)
      .map((e) => AdminRealtimeHubResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  pendingOutbox: (json['pendingOutbox'] as num).toInt(),
  redisConfigured: json['redisConfigured'] as bool,
);

Map<String, dynamic> _$AdminRealtimeInspectorResponseToJson(
  _AdminRealtimeInspectorResponse instance,
) => <String, dynamic>{
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
  'hubs': instance.hubs,
  'pendingOutbox': instance.pendingOutbox,
  'redisConfigured': instance.redisConfigured,
};

_WorkerHeartbeatResponse _$WorkerHeartbeatResponseFromJson(
  Map<String, dynamic> json,
) => _WorkerHeartbeatResponse(
  workerName: json['workerName'] as String,
  lastBeatAtUtc: DateTime.parse(json['lastBeatAtUtc'] as String),
  lastErrorAtUtc: json['lastErrorAtUtc'] == null
      ? null
      : DateTime.parse(json['lastErrorAtUtc'] as String),
  lastError: json['lastError'] as String?,
  processedItems: (json['processedItems'] as num).toInt(),
  pendingQueueSize: (json['pendingQueueSize'] as num).toInt(),
  deadLetterCount: (json['deadLetterCount'] as num).toInt(),
  healthy: json['healthy'] as bool,
);

Map<String, dynamic> _$WorkerHeartbeatResponseToJson(
  _WorkerHeartbeatResponse instance,
) => <String, dynamic>{
  'workerName': instance.workerName,
  'lastBeatAtUtc': instance.lastBeatAtUtc.toIso8601String(),
  'lastErrorAtUtc': instance.lastErrorAtUtc?.toIso8601String(),
  'lastError': instance.lastError,
  'processedItems': instance.processedItems,
  'pendingQueueSize': instance.pendingQueueSize,
  'deadLetterCount': instance.deadLetterCount,
  'healthy': instance.healthy,
};

_AdminIntegrationHealthResponse _$AdminIntegrationHealthResponseFromJson(
  Map<String, dynamic> json,
) => _AdminIntegrationHealthResponse(
  name: json['name'] as String,
  configured: json['configured'] as bool,
  reachable: json['reachable'] as bool,
  latencyMilliseconds: (json['latencyMilliseconds'] as num).toInt(),
  detail: json['detail'] as String?,
  databaseSizeMb: (json['databaseSizeMb'] as num?)?.toDouble(),
  activeConnections: (json['activeConnections'] as num?)?.toInt(),
  idleConnections: (json['idleConnections'] as num?)?.toInt(),
  maxConnections: (json['maxConnections'] as num?)?.toInt(),
  slowQueries: (json['slowQueries'] as num?)?.toInt(),
  deadlocks: (json['deadlocks'] as num?)?.toInt(),
  successfulRequestsLastHour: (json['successfulRequestsLastHour'] as num?)
      ?.toInt(),
  failedRequestsLastHour: (json['failedRequestsLastHour'] as num?)?.toInt(),
  activeSessions: (json['activeSessions'] as num?)?.toInt(),
);

Map<String, dynamic> _$AdminIntegrationHealthResponseToJson(
  _AdminIntegrationHealthResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'configured': instance.configured,
  'reachable': instance.reachable,
  'latencyMilliseconds': instance.latencyMilliseconds,
  'detail': instance.detail,
  'databaseSizeMb': instance.databaseSizeMb,
  'activeConnections': instance.activeConnections,
  'idleConnections': instance.idleConnections,
  'maxConnections': instance.maxConnections,
  'slowQueries': instance.slowQueries,
  'deadlocks': instance.deadlocks,
  'successfulRequestsLastHour': instance.successfulRequestsLastHour,
  'failedRequestsLastHour': instance.failedRequestsLastHour,
  'activeSessions': instance.activeSessions,
};

_AdminIntegrationsResponse _$AdminIntegrationsResponseFromJson(
  Map<String, dynamic> json,
) => _AdminIntegrationsResponse(
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
  database: AdminIntegrationHealthResponse.fromJson(
    json['database'] as Map<String, dynamic>,
  ),
  redis: AdminIntegrationHealthResponse.fromJson(
    json['redis'] as Map<String, dynamic>,
  ),
  onlyOffice: AdminIntegrationHealthResponse.fromJson(
    json['onlyOffice'] as Map<String, dynamic>,
  ),
  aiProvider: AdminIntegrationHealthResponse.fromJson(
    json['aiProvider'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AdminIntegrationsResponseToJson(
  _AdminIntegrationsResponse instance,
) => <String, dynamic>{
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
  'database': instance.database,
  'redis': instance.redis,
  'onlyOffice': instance.onlyOffice,
  'aiProvider': instance.aiProvider,
};

_AdminOpsDashboardResponse _$AdminOpsDashboardResponseFromJson(
  Map<String, dynamic> json,
) => _AdminOpsDashboardResponse(
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
  bufferedErrors: (json['bufferedErrors'] as num).toInt(),
  errorsLast24Hours: (json['errorsLast24Hours'] as num).toInt(),
  pendingRealtimeOutbox: (json['pendingRealtimeOutbox'] as num).toInt(),
  activeStorageFiles: (json['activeStorageFiles'] as num).toInt(),
  activeSignalRConnections: (json['activeSignalRConnections'] as num).toInt(),
  openRealtimeRooms: (json['openRealtimeRooms'] as num).toInt(),
  activeRealtimeUsers: (json['activeRealtimeUsers'] as num).toInt(),
  redisConfigured: json['redisConfigured'] as bool,
  onlyOfficeConfigured: json['onlyOfficeConfigured'] as bool,
  aiConfigured: json['aiConfigured'] as bool,
  workers: (json['workers'] as List<dynamic>)
      .map((e) => WorkerHeartbeatResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AdminOpsDashboardResponseToJson(
  _AdminOpsDashboardResponse instance,
) => <String, dynamic>{
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
  'bufferedErrors': instance.bufferedErrors,
  'errorsLast24Hours': instance.errorsLast24Hours,
  'pendingRealtimeOutbox': instance.pendingRealtimeOutbox,
  'activeStorageFiles': instance.activeStorageFiles,
  'activeSignalRConnections': instance.activeSignalRConnections,
  'openRealtimeRooms': instance.openRealtimeRooms,
  'activeRealtimeUsers': instance.activeRealtimeUsers,
  'redisConfigured': instance.redisConfigured,
  'onlyOfficeConfigured': instance.onlyOfficeConfigured,
  'aiConfigured': instance.aiConfigured,
  'workers': instance.workers,
};

_StorageOrphanItemResponse _$StorageOrphanItemResponseFromJson(
  Map<String, dynamic> json,
) => _StorageOrphanItemResponse(
  fileId: json['fileId'] as String,
  originalFileName: json['originalFileName'] as String,
  storageObjectKey: json['storageObjectKey'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  reason: json['reason'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$StorageOrphanItemResponseToJson(
  _StorageOrphanItemResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'originalFileName': instance.originalFileName,
  'storageObjectKey': instance.storageObjectKey,
  'fileSizeBytes': instance.fileSizeBytes,
  'reason': instance.reason,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_StorageOrphanScanReportResponse _$StorageOrphanScanReportResponseFromJson(
  Map<String, dynamic> json,
) => _StorageOrphanScanReportResponse(
  scannedAtUtc: DateTime.parse(json['scannedAtUtc'] as String),
  expiredIncompleteUploadsCount: (json['expiredIncompleteUploadsCount'] as num)
      .toInt(),
  expiredIncompleteUploadsSizeBytes:
      (json['expiredIncompleteUploadsSizeBytes'] as num).toInt(),
  expiredTrashFilesCount: (json['expiredTrashFilesCount'] as num).toInt(),
  expiredTrashFilesSizeBytes: (json['expiredTrashFilesSizeBytes'] as num)
      .toInt(),
  totalReclaimableSizeBytes: (json['totalReclaimableSizeBytes'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => StorageOrphanItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StorageOrphanScanReportResponseToJson(
  _StorageOrphanScanReportResponse instance,
) => <String, dynamic>{
  'scannedAtUtc': instance.scannedAtUtc.toIso8601String(),
  'expiredIncompleteUploadsCount': instance.expiredIncompleteUploadsCount,
  'expiredIncompleteUploadsSizeBytes':
      instance.expiredIncompleteUploadsSizeBytes,
  'expiredTrashFilesCount': instance.expiredTrashFilesCount,
  'expiredTrashFilesSizeBytes': instance.expiredTrashFilesSizeBytes,
  'totalReclaimableSizeBytes': instance.totalReclaimableSizeBytes,
  'items': instance.items,
};

_StorageOrphanPurgePayload _$StorageOrphanPurgePayloadFromJson(
  Map<String, dynamic> json,
) => _StorageOrphanPurgePayload(
  trashRetentionDays: (json['trashRetentionDays'] as num?)?.toInt() ?? 30,
  purgeIncompleteUploads: json['purgeIncompleteUploads'] as bool? ?? true,
  purgeTrash: json['purgeTrash'] as bool? ?? true,
);

Map<String, dynamic> _$StorageOrphanPurgePayloadToJson(
  _StorageOrphanPurgePayload instance,
) => <String, dynamic>{
  'trashRetentionDays': instance.trashRetentionDays,
  'purgeIncompleteUploads': instance.purgeIncompleteUploads,
  'purgeTrash': instance.purgeTrash,
};

_StorageOrphanPurgeReportResponse _$StorageOrphanPurgeReportResponseFromJson(
  Map<String, dynamic> json,
) => _StorageOrphanPurgeReportResponse(
  purgedAtUtc: DateTime.parse(json['purgedAtUtc'] as String),
  purgedFilesCount: (json['purgedFilesCount'] as num).toInt(),
  purgedSizeBytes: (json['purgedSizeBytes'] as num).toInt(),
  purgedObjectKeys: (json['purgedObjectKeys'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$StorageOrphanPurgeReportResponseToJson(
  _StorageOrphanPurgeReportResponse instance,
) => <String, dynamic>{
  'purgedAtUtc': instance.purgedAtUtc.toIso8601String(),
  'purgedFilesCount': instance.purgedFilesCount,
  'purgedSizeBytes': instance.purgedSizeBytes,
  'purgedObjectKeys': instance.purgedObjectKeys,
};
