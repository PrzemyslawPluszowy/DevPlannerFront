import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

/// Wpis trwałego rejestru błędów systemowych.
@freezed
abstract class SystemErrorLogResponse with _$SystemErrorLogResponse {
  /// Zawiera identyfikator śledzenia, żądanie i stan rozwiązania.
  const factory SystemErrorLogResponse({
    required String id,
    required String traceId,
    required int statusCode,
    required String method,
    required String path,
    required String exceptionType,
    required String message,
    String? stackTrace,
    String? coreUserId,
    required DateTime occurredAtUtc,
    required bool isResolved,
    DateTime? resolvedAtUtc,
  }) = _SystemErrorLogResponse;

  /// Odtwarza wpis z JSON.
  factory SystemErrorLogResponse.fromJson(Map<String, dynamic> json) =>
      _$SystemErrorLogResponseFromJson(json);
}

/// Wynik operacji konserwacyjnej administratora.
@freezed
abstract class AdminMaintenanceResultResponse
    with _$AdminMaintenanceResultResponse {
  /// Zwraca liczbę zmienionych rekordów i czas wykonania.
  const factory AdminMaintenanceResultResponse({
    required int affectedRecords,
    required DateTime executedAtUtc,
  }) = _AdminMaintenanceResultResponse;

  /// Odtwarza wynik z JSON.
  factory AdminMaintenanceResultResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminMaintenanceResultResponseFromJson(json);
}

/// Payload usuwania starych błędów systemowych.
@freezed
abstract class PurgeSystemErrorsPayload with _$PurgeSystemErrorsPayload {
  /// Określa retencję i opcjonalny filtr rozwiązanych wpisów.
  const factory PurgeSystemErrorsPayload({
    required int olderThanDays,
    @Default(false) bool onlyResolved,
  }) = _PurgeSystemErrorsPayload;

  /// Odtwarza payload z JSON.
  factory PurgeSystemErrorsPayload.fromJson(Map<String, dynamic> json) =>
      _$PurgeSystemErrorsPayloadFromJson(json);
}

/// Odpowiedź diagnostyki ClamAV.
@freezed
abstract class ClamAvProbeResponse with _$ClamAvProbeResponse {
  /// Zawiera stan usługi i statystyki skanowania.
  const factory ClamAvProbeResponse({
    required bool enabled,
    required bool reachable,
    required String host,
    required int port,
    String? signatureVersion,
    DateTime? lastSignatureUpdateUtc,
    @Default(0) int scannedFilesLast24Hours,
    @Default(0) int threatsDetectedLast24Hours,
    @Default(0) int quarantinedFiles,
  }) = _ClamAvProbeResponse;

  /// Odtwarza odpowiedź z JSON.
  factory ClamAvProbeResponse.fromJson(Map<String, dynamic> json) =>
      _$ClamAvProbeResponseFromJson(json);
}

/// Payload wymuszenia skanowania plików Storage.
@freezed
abstract class StorageRescanPayload with _$StorageRescanPayload {
  /// Wskazuje konkretny plik albo limit kolejki oczekujących plików.
  const factory StorageRescanPayload({
    String? fileId,
    @Default(100) int limit,
  }) = _StorageRescanPayload;

  /// Odtwarza payload z JSON.
  factory StorageRescanPayload.fromJson(Map<String, dynamic> json) =>
      _$StorageRescanPayloadFromJson(json);
}

/// Raport wymuszonego skanowania Storage.
@freezed
abstract class StorageRescanResponse with _$StorageRescanResponse {
  /// Zwraca liczbę przetworzonych i zainfekowanych plików.
  const factory StorageRescanResponse({
    required DateTime executedAtUtc,
    required int requestedFiles,
    required int scannedFiles,
    required int infectedFiles,
    required int failedFiles,
  }) = _StorageRescanResponse;

  /// Odtwarza raport z JSON.
  factory StorageRescanResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageRescanResponseFromJson(json);
}

/// Element kolejki dead-letter.
@freezed
abstract class DeadLetterItemResponse with _$DeadLetterItemResponse {
  /// Zawiera kolejkę, identyfikator i stan retry.
  const factory DeadLetterItemResponse({
    required String queueName,
    required String id,
    required int attemptCount,
    required DateTime createdAtUtc,
    required DateTime nextAttemptAtUtc,
    String? lastError,
    String? detail,
  }) = _DeadLetterItemResponse;

  /// Odtwarza wpis z JSON.
  factory DeadLetterItemResponse.fromJson(Map<String, dynamic> json) =>
      _$DeadLetterItemResponseFromJson(json);
}

/// Stan pojedynczego huba realtime.
@freezed
abstract class AdminRealtimeHubResponse with _$AdminRealtimeHubResponse {
  /// Zwraca liczbę połączeń, pokoi i użytkowników.
  const factory AdminRealtimeHubResponse({
    required String hub,
    required int activeConnections,
    required int openRooms,
    required int activeUsers,
  }) = _AdminRealtimeHubResponse;

  /// Odtwarza stan z JSON.
  factory AdminRealtimeHubResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminRealtimeHubResponseFromJson(json);
}

/// Inspector wszystkich hubów realtime.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AdminRealtimeInspectorResponse
    with _$AdminRealtimeInspectorResponse {
  /// Zwraca huby i backlog outboxu.
  const factory AdminRealtimeInspectorResponse({
    required DateTime generatedAtUtc,
    required List<AdminRealtimeHubResponse> hubs,
    required int pendingOutbox,
    required bool redisConfigured,
  }) = _AdminRealtimeInspectorResponse;

  /// Odtwarza inspector z JSON.
  factory AdminRealtimeInspectorResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminRealtimeInspectorResponseFromJson(json);
}

/// Heartbeat workera tła.
@freezed
abstract class WorkerHeartbeatResponse with _$WorkerHeartbeatResponse {
  /// Zawiera stan zdrowia i kolejki workera.
  const factory WorkerHeartbeatResponse({
    required String workerName,
    required DateTime lastBeatAtUtc,
    DateTime? lastErrorAtUtc,
    String? lastError,
    required int processedItems,
    required int pendingQueueSize,
    required int deadLetterCount,
    required bool healthy,
  }) = _WorkerHeartbeatResponse;

  /// Odtwarza heartbeat z JSON.
  factory WorkerHeartbeatResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkerHeartbeatResponseFromJson(json);
}

/// Stan pojedynczej integracji infrastrukturalnej.
@freezed
abstract class AdminIntegrationHealthResponse
    with _$AdminIntegrationHealthResponse {
  /// Zawiera dostępność, opóźnienie i opcjonalne metryki.
  const factory AdminIntegrationHealthResponse({
    required String name,
    required bool configured,
    required bool reachable,
    required int latencyMilliseconds,
    String? detail,
    double? databaseSizeMb,
    int? activeConnections,
    int? idleConnections,
    int? maxConnections,
    int? slowQueries,
    int? deadlocks,
    int? successfulRequestsLastHour,
    int? failedRequestsLastHour,
    int? activeSessions,
  }) = _AdminIntegrationHealthResponse;

  /// Odtwarza stan integracji z JSON.
  factory AdminIntegrationHealthResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminIntegrationHealthResponseFromJson(json);
}

/// Zbiorczy stan integracji administratora.
@freezed
abstract class AdminIntegrationsResponse with _$AdminIntegrationsResponse {
  /// Zwraca stan bazy, Redis, OnlyOffice i AI.
  const factory AdminIntegrationsResponse({
    required DateTime generatedAtUtc,
    required AdminIntegrationHealthResponse database,
    required AdminIntegrationHealthResponse redis,
    required AdminIntegrationHealthResponse onlyOffice,
    required AdminIntegrationHealthResponse aiProvider,
  }) = _AdminIntegrationsResponse;

  /// Odtwarza stan integracji z JSON.
  factory AdminIntegrationsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminIntegrationsResponseFromJson(json);
}

/// Dashboard diagnostyczny Ops.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AdminOpsDashboardResponse with _$AdminOpsDashboardResponse {
  /// Zwraca telemetrię błędów, realtime, Storage i workerów.
  const factory AdminOpsDashboardResponse({
    required DateTime generatedAtUtc,
    required int bufferedErrors,
    required int errorsLast24Hours,
    required int pendingRealtimeOutbox,
    required int activeStorageFiles,
    required int activeSignalRConnections,
    required int openRealtimeRooms,
    required int activeRealtimeUsers,
    required bool redisConfigured,
    required bool onlyOfficeConfigured,
    required bool aiConfigured,
    required List<WorkerHeartbeatResponse> workers,
  }) = _AdminOpsDashboardResponse;

  /// Odtwarza dashboard z JSON.
  factory AdminOpsDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminOpsDashboardResponseFromJson(json);
}

/// Wykryty osierocony plik Storage.
@freezed
abstract class StorageOrphanItemResponse with _$StorageOrphanItemResponse {
  /// Zawiera przyczynę kwalifikacji i rozmiar pliku.
  const factory StorageOrphanItemResponse({
    required String fileId,
    required String originalFileName,
    required String storageObjectKey,
    required int fileSizeBytes,
    required String reason,
    required DateTime createdAtUtc,
  }) = _StorageOrphanItemResponse;

  /// Odtwarza element z JSON.
  factory StorageOrphanItemResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageOrphanItemResponseFromJson(json);
}

/// Raport skanowania osieroconych plików.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageOrphanScanReportResponse
    with _$StorageOrphanScanReportResponse {
  /// Zwraca statystyki i listę wykrytych elementów.
  const factory StorageOrphanScanReportResponse({
    required DateTime scannedAtUtc,
    required int expiredIncompleteUploadsCount,
    required int expiredIncompleteUploadsSizeBytes,
    required int expiredTrashFilesCount,
    required int expiredTrashFilesSizeBytes,
    required int totalReclaimableSizeBytes,
    required List<StorageOrphanItemResponse> items,
  }) = _StorageOrphanScanReportResponse;

  /// Odtwarza raport z JSON.
  factory StorageOrphanScanReportResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageOrphanScanReportResponseFromJson(json);
}

/// Payload fizycznego czyszczenia osieroconych plików.
@freezed
abstract class StorageOrphanPurgePayload with _$StorageOrphanPurgePayload {
  /// Określa retencję i zakres czyszczenia.
  const factory StorageOrphanPurgePayload({
    @Default(30) int trashRetentionDays,
    @Default(true) bool purgeIncompleteUploads,
    @Default(true) bool purgeTrash,
  }) = _StorageOrphanPurgePayload;

  /// Odtwarza payload z JSON.
  factory StorageOrphanPurgePayload.fromJson(Map<String, dynamic> json) =>
      _$StorageOrphanPurgePayloadFromJson(json);
}

/// Raport fizycznego czyszczenia Storage.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageOrphanPurgeReportResponse
    with _$StorageOrphanPurgeReportResponse {
  /// Zwraca liczbę usuniętych plików, rozmiar i klucze obiektów.
  const factory StorageOrphanPurgeReportResponse({
    required DateTime purgedAtUtc,
    required int purgedFilesCount,
    required int purgedSizeBytes,
    required List<String> purgedObjectKeys,
  }) = _StorageOrphanPurgeReportResponse;

  /// Odtwarza raport z JSON.
  factory StorageOrphanPurgeReportResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageOrphanPurgeReportResponseFromJson(json);
}
