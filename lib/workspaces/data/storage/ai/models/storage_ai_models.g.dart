// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_ai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiDetectedEntity _$AiDetectedEntityFromJson(Map<String, dynamic> json) =>
    _AiDetectedEntity(
      type: json['type'] as String,
      value: json['value'] as String,
      confidence: (json['confidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AiDetectedEntityToJson(_AiDetectedEntity instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'confidence': instance.confidence,
    };

_AiFileAnalysisAuditEventResponse _$AiFileAnalysisAuditEventResponseFromJson(
  Map<String, dynamic> json,
) => _AiFileAnalysisAuditEventResponse(
  eventId: json['eventId'] as String,
  analysisJobId: json['analysisJobId'] as String,
  fileId: json['fileId'] as String,
  fileVersion: (json['fileVersion'] as num).toInt(),
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  eventType: $enumDecode(_$AiOperationAuditEventTypeEnumMap, json['eventType']),
  provider: $enumDecodeNullable(_$AiProviderKindEnumMap, json['provider']),
  attempt: (json['attempt'] as num).toInt(),
  inputBytes: (json['inputBytes'] as num).toInt(),
  outputBytes: (json['outputBytes'] as num).toInt(),
  failureCode: $enumDecodeNullable(
    _$StorageAnalysisFailureCodeEnumMap,
    json['failureCode'],
  ),
  occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
);

Map<String, dynamic> _$AiFileAnalysisAuditEventResponseToJson(
  _AiFileAnalysisAuditEventResponse instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'analysisJobId': instance.analysisJobId,
  'fileId': instance.fileId,
  'fileVersion': instance.fileVersion,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'eventType': _$AiOperationAuditEventTypeEnumMap[instance.eventType]!,
  'provider': _$AiProviderKindEnumMap[instance.provider],
  'attempt': instance.attempt,
  'inputBytes': instance.inputBytes,
  'outputBytes': instance.outputBytes,
  'failureCode': _$StorageAnalysisFailureCodeEnumMap[instance.failureCode],
  'occurredAtUtc': instance.occurredAtUtc.toIso8601String(),
};

const _$AiOperationAuditEventTypeEnumMap = {
  AiOperationAuditEventType.started: 'started',
  AiOperationAuditEventType.completed: 'completed',
  AiOperationAuditEventType.failed: 'failed',
  AiOperationAuditEventType.reconciled: 'reconciled',
};

const _$AiProviderKindEnumMap = {
  AiProviderKind.disabled: 'disabled',
  AiProviderKind.aifastApi: 'aifastApi',
  AiProviderKind.openAi: 'openAi',
  AiProviderKind.azureOpenAi: 'azureOpenAi',
  AiProviderKind.anthropic: 'anthropic',
  AiProviderKind.ollama: 'ollama',
  AiProviderKind.custom: 'custom',
};

const _$StorageAnalysisFailureCodeEnumMap = {
  StorageAnalysisFailureCode.unknown: 'unknown',
  StorageAnalysisFailureCode.sourceVersionMissing: 'sourceVersionMissing',
  StorageAnalysisFailureCode.storageContentMismatch: 'storageContentMismatch',
  StorageAnalysisFailureCode.unsupportedMedia: 'unsupportedMedia',
  StorageAnalysisFailureCode.invalidProviderResponse: 'invalidProviderResponse',
  StorageAnalysisFailureCode.providerUnauthorized: 'providerUnauthorized',
  StorageAnalysisFailureCode.providerRateLimited: 'providerRateLimited',
  StorageAnalysisFailureCode.providerUnavailable: 'providerUnavailable',
  StorageAnalysisFailureCode.circuitOpen: 'circuitOpen',
  StorageAnalysisFailureCode.disabled: 'disabled',
  StorageAnalysisFailureCode.deadlineExceeded: 'deadlineExceeded',
  StorageAnalysisFailureCode.sourceDeleted: 'sourceDeleted',
  StorageAnalysisFailureCode.sourceNotReady: 'sourceNotReady',
  StorageAnalysisFailureCode.sourceInfected: 'sourceInfected',
};

_AiUsageBucketResponse _$AiUsageBucketResponseFromJson(
  Map<String, dynamic> json,
) => _AiUsageBucketResponse(
  operationType: json['operationType'] as String,
  provider: $enumDecodeNullable(_$AiProviderKindEnumMap, json['provider']),
  model: json['model'] as String?,
  startedCount: (json['startedCount'] as num).toInt(),
  completedCount: (json['completedCount'] as num).toInt(),
  failedCount: (json['failedCount'] as num).toInt(),
  inputCharacters: (json['inputCharacters'] as num).toInt(),
  outputBytes: (json['outputBytes'] as num).toInt(),
);

Map<String, dynamic> _$AiUsageBucketResponseToJson(
  _AiUsageBucketResponse instance,
) => <String, dynamic>{
  'operationType': instance.operationType,
  'provider': _$AiProviderKindEnumMap[instance.provider],
  'model': instance.model,
  'startedCount': instance.startedCount,
  'completedCount': instance.completedCount,
  'failedCount': instance.failedCount,
  'inputCharacters': instance.inputCharacters,
  'outputBytes': instance.outputBytes,
};

_AiUsageSummaryResponse _$AiUsageSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _AiUsageSummaryResponse(
  workspaceId: json['workspaceId'] as String,
  fromUtc: DateTime.parse(json['fromUtc'] as String),
  toUtc: DateTime.parse(json['toUtc'] as String),
  startedCount: (json['startedCount'] as num).toInt(),
  completedCount: (json['completedCount'] as num).toInt(),
  failedCount: (json['failedCount'] as num).toInt(),
  inputCharacters: (json['inputCharacters'] as num).toInt(),
  outputBytes: (json['outputBytes'] as num).toInt(),
  buckets: (json['buckets'] as List<dynamic>)
      .map((e) => AiUsageBucketResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AiUsageSummaryResponseToJson(
  _AiUsageSummaryResponse instance,
) => <String, dynamic>{
  'workspaceId': instance.workspaceId,
  'fromUtc': instance.fromUtc.toIso8601String(),
  'toUtc': instance.toUtc.toIso8601String(),
  'startedCount': instance.startedCount,
  'completedCount': instance.completedCount,
  'failedCount': instance.failedCount,
  'inputCharacters': instance.inputCharacters,
  'outputBytes': instance.outputBytes,
  'buckets': instance.buckets,
};

_AiReportScheduleRecipientPayload _$AiReportScheduleRecipientPayloadFromJson(
  Map<String, dynamic> json,
) => _AiReportScheduleRecipientPayload(
  userId: json['userId'] as String,
  channel: $enumDecode(_$AiReportDeliveryChannelEnumMap, json['channel']),
  emailAddress: json['emailAddress'] as String?,
);

Map<String, dynamic> _$AiReportScheduleRecipientPayloadToJson(
  _AiReportScheduleRecipientPayload instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'channel': _$AiReportDeliveryChannelEnumMap[instance.channel]!,
  'emailAddress': instance.emailAddress,
};

const _$AiReportDeliveryChannelEnumMap = {
  AiReportDeliveryChannel.email: 'email',
  AiReportDeliveryChannel.inApp: 'inApp',
};

_CreateAiReportSchedulePayload _$CreateAiReportSchedulePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateAiReportSchedulePayload(
  reportType: json['reportType'] as String,
  contractVersion: json['contractVersion'] as String,
  reportVersion: json['reportVersion'] as String,
  cadence: $enumDecode(_$AiReportScheduleCadenceEnumMap, json['cadence']),
  timeZoneId: json['timeZoneId'] as String,
  localTime: json['localTime'] as String,
  weekday: json['weekday'] as String?,
  dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
  executionUserId: json['executionUserId'] as String?,
  recipients: (json['recipients'] as List<dynamic>)
      .map(
        (e) => AiReportScheduleRecipientPayload.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$CreateAiReportSchedulePayloadToJson(
  _CreateAiReportSchedulePayload instance,
) => <String, dynamic>{
  'reportType': instance.reportType,
  'contractVersion': instance.contractVersion,
  'reportVersion': instance.reportVersion,
  'cadence': _$AiReportScheduleCadenceEnumMap[instance.cadence]!,
  'timeZoneId': instance.timeZoneId,
  'localTime': instance.localTime,
  'weekday': instance.weekday,
  'dayOfMonth': instance.dayOfMonth,
  'executionUserId': instance.executionUserId,
  'recipients': instance.recipients,
};

const _$AiReportScheduleCadenceEnumMap = {
  AiReportScheduleCadence.daily: 'daily',
  AiReportScheduleCadence.weekly: 'weekly',
  AiReportScheduleCadence.monthly: 'monthly',
};

_UpdateAiReportSchedulePayload _$UpdateAiReportSchedulePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateAiReportSchedulePayload(
  cadence: $enumDecode(_$AiReportScheduleCadenceEnumMap, json['cadence']),
  timeZoneId: json['timeZoneId'] as String,
  localTime: json['localTime'] as String,
  weekday: json['weekday'] as String?,
  dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
  executionUserId: json['executionUserId'] as String,
);

Map<String, dynamic> _$UpdateAiReportSchedulePayloadToJson(
  _UpdateAiReportSchedulePayload instance,
) => <String, dynamic>{
  'cadence': _$AiReportScheduleCadenceEnumMap[instance.cadence]!,
  'timeZoneId': instance.timeZoneId,
  'localTime': instance.localTime,
  'weekday': instance.weekday,
  'dayOfMonth': instance.dayOfMonth,
  'executionUserId': instance.executionUserId,
};

_AiReportScheduleRecipientResponse _$AiReportScheduleRecipientResponseFromJson(
  Map<String, dynamic> json,
) => _AiReportScheduleRecipientResponse(
  userId: json['userId'] as String,
  channel: $enumDecode(_$AiReportDeliveryChannelEnumMap, json['channel']),
  emailAddress: json['emailAddress'] as String?,
  enabled: json['enabled'] as bool,
);

Map<String, dynamic> _$AiReportScheduleRecipientResponseToJson(
  _AiReportScheduleRecipientResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'channel': _$AiReportDeliveryChannelEnumMap[instance.channel]!,
  'emailAddress': instance.emailAddress,
  'enabled': instance.enabled,
};

_AiReportScheduleResponse _$AiReportScheduleResponseFromJson(
  Map<String, dynamic> json,
) => _AiReportScheduleResponse(
  scheduleId: json['scheduleId'] as String,
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  reportType: json['reportType'] as String,
  contractVersion: json['contractVersion'] as String,
  reportVersion: json['reportVersion'] as String,
  cadence: $enumDecode(_$AiReportScheduleCadenceEnumMap, json['cadence']),
  timeZoneId: json['timeZoneId'] as String,
  localTime: json['localTime'] as String,
  weekday: json['weekday'] as String?,
  dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
  executionUserId: json['executionUserId'] as String,
  nextRunAtUtc: DateTime.parse(json['nextRunAtUtc'] as String),
  enabled: json['enabled'] as bool,
  recipients: (json['recipients'] as List<dynamic>)
      .map(
        (e) => AiReportScheduleRecipientResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$AiReportScheduleResponseToJson(
  _AiReportScheduleResponse instance,
) => <String, dynamic>{
  'scheduleId': instance.scheduleId,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'reportType': instance.reportType,
  'contractVersion': instance.contractVersion,
  'reportVersion': instance.reportVersion,
  'cadence': _$AiReportScheduleCadenceEnumMap[instance.cadence]!,
  'timeZoneId': instance.timeZoneId,
  'localTime': instance.localTime,
  'weekday': instance.weekday,
  'dayOfMonth': instance.dayOfMonth,
  'executionUserId': instance.executionUserId,
  'nextRunAtUtc': instance.nextRunAtUtc.toIso8601String(),
  'enabled': instance.enabled,
  'recipients': instance.recipients,
};

_AiReportScheduleRunResponse _$AiReportScheduleRunResponseFromJson(
  Map<String, dynamic> json,
) => _AiReportScheduleRunResponse(
  runId: json['runId'] as String,
  scheduleId: json['scheduleId'] as String,
  occurrenceKey: json['occurrenceKey'] as String,
  scheduledForUtc: DateTime.parse(json['scheduledForUtc'] as String),
  reportJobId: json['reportJobId'] as String?,
  status: $enumDecode(_$AiReportScheduleRunStatusEnumMap, json['status']),
  runAttemptCount: (json['runAttemptCount'] as num).toInt(),
  maxAttempts: (json['maxAttempts'] as num).toInt(),
  nextAttemptAtUtc: DateTime.parse(json['nextAttemptAtUtc'] as String),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  completedAtUtc: json['completedAtUtc'] == null
      ? null
      : DateTime.parse(json['completedAtUtc'] as String),
  lastError: json['lastError'] as String?,
);

Map<String, dynamic> _$AiReportScheduleRunResponseToJson(
  _AiReportScheduleRunResponse instance,
) => <String, dynamic>{
  'runId': instance.runId,
  'scheduleId': instance.scheduleId,
  'occurrenceKey': instance.occurrenceKey,
  'scheduledForUtc': instance.scheduledForUtc.toIso8601String(),
  'reportJobId': instance.reportJobId,
  'status': _$AiReportScheduleRunStatusEnumMap[instance.status]!,
  'runAttemptCount': instance.runAttemptCount,
  'maxAttempts': instance.maxAttempts,
  'nextAttemptAtUtc': instance.nextAttemptAtUtc.toIso8601String(),
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'completedAtUtc': instance.completedAtUtc?.toIso8601String(),
  'lastError': instance.lastError,
};

const _$AiReportScheduleRunStatusEnumMap = {
  AiReportScheduleRunStatus.pending: 'pending',
  AiReportScheduleRunStatus.reportCreated: 'reportCreated',
  AiReportScheduleRunStatus.completed: 'completed',
  AiReportScheduleRunStatus.failed: 'failed',
};

_AiReportDeliveryResponse _$AiReportDeliveryResponseFromJson(
  Map<String, dynamic> json,
) => _AiReportDeliveryResponse(
  deliveryId: json['deliveryId'] as String,
  scheduleRunId: json['scheduleRunId'] as String,
  reportJobId: json['reportJobId'] as String,
  recipientUserId: json['recipientUserId'] as String,
  channel: $enumDecode(_$AiReportDeliveryChannelEnumMap, json['channel']),
  status: $enumDecode(_$AiReportDeliveryStatusEnumMap, json['status']),
  attemptCount: (json['attemptCount'] as num).toInt(),
  maxAttempts: (json['maxAttempts'] as num).toInt(),
  availableAtUtc: DateTime.parse(json['availableAtUtc'] as String),
  deliveredAtUtc: json['deliveredAtUtc'] == null
      ? null
      : DateTime.parse(json['deliveredAtUtc'] as String),
  failedAtUtc: json['failedAtUtc'] == null
      ? null
      : DateTime.parse(json['failedAtUtc'] as String),
  sentUnknownAtUtc: json['sentUnknownAtUtc'] == null
      ? null
      : DateTime.parse(json['sentUnknownAtUtc'] as String),
  lastError: json['lastError'] as String?,
);

Map<String, dynamic> _$AiReportDeliveryResponseToJson(
  _AiReportDeliveryResponse instance,
) => <String, dynamic>{
  'deliveryId': instance.deliveryId,
  'scheduleRunId': instance.scheduleRunId,
  'reportJobId': instance.reportJobId,
  'recipientUserId': instance.recipientUserId,
  'channel': _$AiReportDeliveryChannelEnumMap[instance.channel]!,
  'status': _$AiReportDeliveryStatusEnumMap[instance.status]!,
  'attemptCount': instance.attemptCount,
  'maxAttempts': instance.maxAttempts,
  'availableAtUtc': instance.availableAtUtc.toIso8601String(),
  'deliveredAtUtc': instance.deliveredAtUtc?.toIso8601String(),
  'failedAtUtc': instance.failedAtUtc?.toIso8601String(),
  'sentUnknownAtUtc': instance.sentUnknownAtUtc?.toIso8601String(),
  'lastError': instance.lastError,
};

const _$AiReportDeliveryStatusEnumMap = {
  AiReportDeliveryStatus.pending: 'pending',
  AiReportDeliveryStatus.processing: 'processing',
  AiReportDeliveryStatus.delivered: 'delivered',
  AiReportDeliveryStatus.failed: 'failed',
  AiReportDeliveryStatus.skipped: 'skipped',
  AiReportDeliveryStatus.sentUnknown: 'sentUnknown',
};

_ResolveAiReportDeliveryPayload _$ResolveAiReportDeliveryPayloadFromJson(
  Map<String, dynamic> json,
) => _ResolveAiReportDeliveryPayload(
  targetStatus: $enumDecode(
    _$AiReportDeliveryResolutionStatusEnumMap,
    json['targetStatus'],
  ),
  error: json['error'] as String?,
);

Map<String, dynamic> _$ResolveAiReportDeliveryPayloadToJson(
  _ResolveAiReportDeliveryPayload instance,
) => <String, dynamic>{
  'targetStatus':
      _$AiReportDeliveryResolutionStatusEnumMap[instance.targetStatus]!,
  'error': instance.error,
};

const _$AiReportDeliveryResolutionStatusEnumMap = {
  AiReportDeliveryResolutionStatus.delivered: 'delivered',
  AiReportDeliveryResolutionStatus.failed: 'failed',
};

_AiReportAuditEventResponse _$AiReportAuditEventResponseFromJson(
  Map<String, dynamic> json,
) => _AiReportAuditEventResponse(
  eventId: json['eventId'] as String,
  reportJobId: json['reportJobId'] as String,
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  requestedByUserId: json['requestedByUserId'] as String,
  operationType: json['operationType'] as String,
  contractVersion: json['contractVersion'] as String,
  promptVersion: json['promptVersion'] as String,
  eventType: $enumDecode(_$AiOperationAuditEventTypeEnumMap, json['eventType']),
  provider: $enumDecodeNullable(_$AiProviderKindEnumMap, json['provider']),
  model: json['model'] as String?,
  attempt: (json['attempt'] as num).toInt(),
  inputCharacters: (json['inputCharacters'] as num).toInt(),
  outputBytes: (json['outputBytes'] as num).toInt(),
  failureCode: $enumDecodeNullable(
    _$StorageAiReportFailureCodeEnumMap,
    json['failureCode'],
  ),
  occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
);

Map<String, dynamic> _$AiReportAuditEventResponseToJson(
  _AiReportAuditEventResponse instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'reportJobId': instance.reportJobId,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'requestedByUserId': instance.requestedByUserId,
  'operationType': instance.operationType,
  'contractVersion': instance.contractVersion,
  'promptVersion': instance.promptVersion,
  'eventType': _$AiOperationAuditEventTypeEnumMap[instance.eventType]!,
  'provider': _$AiProviderKindEnumMap[instance.provider],
  'model': instance.model,
  'attempt': instance.attempt,
  'inputCharacters': instance.inputCharacters,
  'outputBytes': instance.outputBytes,
  'failureCode': _$StorageAiReportFailureCodeEnumMap[instance.failureCode],
  'occurredAtUtc': instance.occurredAtUtc.toIso8601String(),
};

const _$StorageAiReportFailureCodeEnumMap = {
  StorageAiReportFailureCode.unknown: 'unknown',
  StorageAiReportFailureCode.sourceAccessRevoked: 'sourceAccessRevoked',
  StorageAiReportFailureCode.sourceSnapshotEmpty: 'sourceSnapshotEmpty',
  StorageAiReportFailureCode.unsupportedProvider: 'unsupportedProvider',
  StorageAiReportFailureCode.invalidProviderResponse: 'invalidProviderResponse',
  StorageAiReportFailureCode.providerUnauthorized: 'providerUnauthorized',
  StorageAiReportFailureCode.providerRateLimited: 'providerRateLimited',
  StorageAiReportFailureCode.providerUnavailable: 'providerUnavailable',
  StorageAiReportFailureCode.circuitOpen: 'circuitOpen',
  StorageAiReportFailureCode.disabled: 'disabled',
  StorageAiReportFailureCode.outputStorageFailed: 'outputStorageFailed',
  StorageAiReportFailureCode.sourceContentMismatch: 'sourceContentMismatch',
  StorageAiReportFailureCode.deadlineExceeded: 'deadlineExceeded',
  StorageAiReportFailureCode.sourceChanged: 'sourceChanged',
};

_StorageFileAnalysisJobResponse _$StorageFileAnalysisJobResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileAnalysisJobResponse(
  jobId: json['jobId'] as String,
  fileId: json['fileId'] as String,
  fileVersion: (json['fileVersion'] as num).toInt(),
  status: $enumDecode(_$StorageFileAnalysisJobStatusEnumMap, json['status']),
  attemptCount: (json['attemptCount'] as num).toInt(),
  maxAttempts: (json['maxAttempts'] as num).toInt(),
  nextAttemptAtUtc: json['nextAttemptAtUtc'] == null
      ? null
      : DateTime.parse(json['nextAttemptAtUtc'] as String),
  lastError: json['lastError'] as String?,
  provider:
      $enumDecodeNullable(_$AiProviderKindEnumMap, json['provider']) ??
      AiProviderKind.disabled,
  providerStatus:
      $enumDecodeNullable(_$AiProviderStatusEnumMap, json['providerStatus']) ??
      AiProviderStatus.unknown,
  retryable: json['retryable'] as bool? ?? true,
  lastAttemptAtUtc: json['lastAttemptAtUtc'] == null
      ? null
      : DateTime.parse(json['lastAttemptAtUtc'] as String),
  failureCode: $enumDecodeNullable(
    _$StorageAnalysisFailureCodeEnumMap,
    json['failureCode'],
  ),
  contractVersion: json['contractVersion'] as String?,
  operationId: json['operationId'] as String?,
  operationLifecycleStatus: $enumDecodeNullable(
    _$AiOperationStatusEnumMap,
    json['operationLifecycleStatus'],
  ),
  retryAfterSeconds: (json['retryAfterSeconds'] as num?)?.toInt(),
  error: json['error'] == null
      ? null
      : StorageFileAnalysisErrorResponse.fromJson(
          json['error'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$StorageFileAnalysisJobResponseToJson(
  _StorageFileAnalysisJobResponse instance,
) => <String, dynamic>{
  'jobId': instance.jobId,
  'fileId': instance.fileId,
  'fileVersion': instance.fileVersion,
  'status': _$StorageFileAnalysisJobStatusEnumMap[instance.status]!,
  'attemptCount': instance.attemptCount,
  'maxAttempts': instance.maxAttempts,
  'nextAttemptAtUtc': instance.nextAttemptAtUtc?.toIso8601String(),
  'lastError': instance.lastError,
  'provider': _$AiProviderKindEnumMap[instance.provider]!,
  'providerStatus': _$AiProviderStatusEnumMap[instance.providerStatus]!,
  'retryable': instance.retryable,
  'lastAttemptAtUtc': instance.lastAttemptAtUtc?.toIso8601String(),
  'failureCode': _$StorageAnalysisFailureCodeEnumMap[instance.failureCode],
  'contractVersion': instance.contractVersion,
  'operationId': instance.operationId,
  'operationLifecycleStatus':
      _$AiOperationStatusEnumMap[instance.operationLifecycleStatus],
  'retryAfterSeconds': instance.retryAfterSeconds,
  'error': instance.error,
};

const _$StorageFileAnalysisJobStatusEnumMap = {
  StorageFileAnalysisJobStatus.pending: 'Pending',
  StorageFileAnalysisJobStatus.processing: 'Processing',
  StorageFileAnalysisJobStatus.completed: 'Completed',
  StorageFileAnalysisJobStatus.failed: 'Failed',
};

const _$AiProviderStatusEnumMap = {
  AiProviderStatus.unknown: 'unknown',
  AiProviderStatus.healthy: 'healthy',
  AiProviderStatus.degraded: 'degraded',
  AiProviderStatus.unavailable: 'unavailable',
  AiProviderStatus.disabled: 'disabled',
};

const _$AiOperationStatusEnumMap = {
  AiOperationStatus.queued: 'queued',
  AiOperationStatus.processing: 'processing',
  AiOperationStatus.completed: 'completed',
  AiOperationStatus.degraded: 'degraded',
  AiOperationStatus.failedRetryable: 'failedRetryable',
  AiOperationStatus.failedTerminal: 'failedTerminal',
  AiOperationStatus.cancelled: 'cancelled',
};

_StorageFileAnalysisStatusResponse _$StorageFileAnalysisStatusResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileAnalysisStatusResponse(
  fileId: json['fileId'] as String,
  fileVersion: (json['fileVersion'] as num).toInt(),
  scanStatus: $enumDecode(_$StorageScanStatusEnumMap, json['scanStatus']),
  status: $enumDecode(_$StorageAiStatusEnumMap, json['status']),
  jobId: json['jobId'] as String?,
  jobStatus: $enumDecodeNullable(
    _$StorageFileAnalysisJobStatusEnumMap,
    json['jobStatus'],
  ),
  attemptCount: (json['attemptCount'] as num).toInt(),
  maxAttempts: (json['maxAttempts'] as num).toInt(),
  provider: $enumDecode(_$AiProviderKindEnumMap, json['provider']),
  providerStatus: $enumDecode(
    _$AiProviderStatusEnumMap,
    json['providerStatus'],
  ),
  retryable: json['retryable'] as bool,
  createdAtUtc: json['createdAtUtc'] == null
      ? null
      : DateTime.parse(json['createdAtUtc'] as String),
  updatedAtUtc: json['updatedAtUtc'] == null
      ? null
      : DateTime.parse(json['updatedAtUtc'] as String),
  startedAtUtc: json['startedAtUtc'] == null
      ? null
      : DateTime.parse(json['startedAtUtc'] as String),
  completedAtUtc: json['completedAtUtc'] == null
      ? null
      : DateTime.parse(json['completedAtUtc'] as String),
  failedAtUtc: json['failedAtUtc'] == null
      ? null
      : DateTime.parse(json['failedAtUtc'] as String),
  nextAttemptAtUtc: json['nextAttemptAtUtc'] == null
      ? null
      : DateTime.parse(json['nextAttemptAtUtc'] as String),
  lastError: json['lastError'] as String?,
  failureCode: $enumDecodeNullable(
    _$StorageAnalysisFailureCodeEnumMap,
    json['failureCode'],
  ),
  contractVersion: json['contractVersion'] as String?,
  operationId: json['operationId'] as String?,
  operationLifecycleStatus: $enumDecodeNullable(
    _$AiOperationStatusEnumMap,
    json['operationLifecycleStatus'],
  ),
  retryAfterSeconds: (json['retryAfterSeconds'] as num?)?.toInt(),
  error: json['error'] == null
      ? null
      : StorageFileAnalysisErrorResponse.fromJson(
          json['error'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$StorageFileAnalysisStatusResponseToJson(
  _StorageFileAnalysisStatusResponse instance,
) => <String, dynamic>{
  'fileId': instance.fileId,
  'fileVersion': instance.fileVersion,
  'scanStatus': _$StorageScanStatusEnumMap[instance.scanStatus]!,
  'status': _$StorageAiStatusEnumMap[instance.status]!,
  'jobId': instance.jobId,
  'jobStatus': _$StorageFileAnalysisJobStatusEnumMap[instance.jobStatus],
  'attemptCount': instance.attemptCount,
  'maxAttempts': instance.maxAttempts,
  'provider': _$AiProviderKindEnumMap[instance.provider]!,
  'providerStatus': _$AiProviderStatusEnumMap[instance.providerStatus]!,
  'retryable': instance.retryable,
  'createdAtUtc': instance.createdAtUtc?.toIso8601String(),
  'updatedAtUtc': instance.updatedAtUtc?.toIso8601String(),
  'startedAtUtc': instance.startedAtUtc?.toIso8601String(),
  'completedAtUtc': instance.completedAtUtc?.toIso8601String(),
  'failedAtUtc': instance.failedAtUtc?.toIso8601String(),
  'nextAttemptAtUtc': instance.nextAttemptAtUtc?.toIso8601String(),
  'lastError': instance.lastError,
  'failureCode': _$StorageAnalysisFailureCodeEnumMap[instance.failureCode],
  'contractVersion': instance.contractVersion,
  'operationId': instance.operationId,
  'operationLifecycleStatus':
      _$AiOperationStatusEnumMap[instance.operationLifecycleStatus],
  'retryAfterSeconds': instance.retryAfterSeconds,
  'error': instance.error,
};

const _$StorageScanStatusEnumMap = {
  StorageScanStatus.pending: 'Pending',
  StorageScanStatus.clean: 'Clean',
  StorageScanStatus.infected: 'Infected',
  StorageScanStatus.skipped: 'Skipped',
};

const _$StorageAiStatusEnumMap = {
  StorageAiStatus.none: 'None',
  StorageAiStatus.queued: 'Queued',
  StorageAiStatus.processing: 'Processing',
  StorageAiStatus.completed: 'Completed',
  StorageAiStatus.failed: 'Failed',
};

_StorageFileAnalysisErrorResponse _$StorageFileAnalysisErrorResponseFromJson(
  Map<String, dynamic> json,
) => _StorageFileAnalysisErrorResponse(
  code: json['code'] as String,
  message: json['message'] as String,
  retryable: json['retryable'] as bool,
  retryAfterSeconds: (json['retryAfterSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$StorageFileAnalysisErrorResponseToJson(
  _StorageFileAnalysisErrorResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'retryable': instance.retryable,
  'retryAfterSeconds': instance.retryAfterSeconds,
};
