import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';

part 'storage_ai_models.freezed.dart';
part 'storage_ai_models.g.dart';

/// Encja wykryta przez analizę AI pliku.
@freezed
abstract class AiDetectedEntity with _$AiDetectedEntity {
  /// Zawiera typ, wartość i opcjonalną pewność detekcji.
  const factory AiDetectedEntity({
    required String type,
    required String value,
    double? confidence,
  }) = _AiDetectedEntity;

  /// Odtwarza encję z JSON.
  factory AiDetectedEntity.fromJson(Map<String, dynamic> json) =>
      _$AiDetectedEntityFromJson(json);
}

/// Zdarzenie audytu analizy AI pliku.
@freezed
abstract class AiFileAnalysisAuditEventResponse
    with _$AiFileAnalysisAuditEventResponse {
  /// Zawiera plik, wersję, providera i wynik operacji.
  const factory AiFileAnalysisAuditEventResponse({
    required String eventId,
    required String analysisJobId,
    required String fileId,
    required int fileVersion,
    String? workspaceId,
    String? projectId,
    required AiOperationAuditEventType eventType,
    AiProviderKind? provider,
    required int attempt,
    required int inputBytes,
    required int outputBytes,
    StorageAnalysisFailureCode? failureCode,
    required DateTime occurredAtUtc,
  }) = _AiFileAnalysisAuditEventResponse;

  /// Odtwarza zdarzenie audytu z JSON.
  factory AiFileAnalysisAuditEventResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AiFileAnalysisAuditEventResponseFromJson(json);
}

/// Kubełek użycia providera AI.
@freezed
abstract class AiUsageBucketResponse with _$AiUsageBucketResponse {
  /// Zawiera liczniki i rozmiary operacji.
  const factory AiUsageBucketResponse({
    required String operationType,
    AiProviderKind? provider,
    String? model,
    required int startedCount,
    required int completedCount,
    required int failedCount,
    required int inputCharacters,
    required int outputBytes,
  }) = _AiUsageBucketResponse;

  /// Odtwarza kubełek z JSON.
  factory AiUsageBucketResponse.fromJson(Map<String, dynamic> json) =>
      _$AiUsageBucketResponseFromJson(json);
}

/// Podsumowanie użycia AI workspace.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AiUsageSummaryResponse with _$AiUsageSummaryResponse {
  /// Zawiera zakres, liczniki i rozbicie na operacje.
  const factory AiUsageSummaryResponse({
    required String workspaceId,
    required DateTime fromUtc,
    required DateTime toUtc,
    required int startedCount,
    required int completedCount,
    required int failedCount,
    required int inputCharacters,
    required int outputBytes,
    required List<AiUsageBucketResponse> buckets,
  }) = _AiUsageSummaryResponse;

  /// Odtwarza podsumowanie z JSON.
  factory AiUsageSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$AiUsageSummaryResponseFromJson(json);
}

/// Odbiorca harmonogramu raportu AI — payload.
@freezed
abstract class AiReportScheduleRecipientPayload
    with _$AiReportScheduleRecipientPayload {
  /// Wskazuje użytkownika i kanał dostarczenia.
  const factory AiReportScheduleRecipientPayload({
    required String userId,
    required AiReportDeliveryChannel channel,
    String? emailAddress,
  }) = _AiReportScheduleRecipientPayload;

  /// Odtwarza payload z JSON.
  factory AiReportScheduleRecipientPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$AiReportScheduleRecipientPayloadFromJson(json);
}

/// Payload utworzenia harmonogramu raportu AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateAiReportSchedulePayload
    with _$CreateAiReportSchedulePayload {
  /// Ustawia typ raportu, kadencję, czas i odbiorców.
  const factory CreateAiReportSchedulePayload({
    required String reportType,
    required String contractVersion,
    required String reportVersion,
    required AiReportScheduleCadence cadence,
    required String timeZoneId,
    required String localTime,
    String? weekday,
    int? dayOfMonth,
    String? executionUserId,
    required List<AiReportScheduleRecipientPayload> recipients,
  }) = _CreateAiReportSchedulePayload;

  /// Odtwarza payload z JSON.
  factory CreateAiReportSchedulePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateAiReportSchedulePayloadFromJson(json);
}

/// Payload aktualizacji harmonogramu AI.
@freezed
abstract class UpdateAiReportSchedulePayload
    with _$UpdateAiReportSchedulePayload {
  /// Aktualizuje czas, kadencję i użytkownika wykonującego.
  const factory UpdateAiReportSchedulePayload({
    required AiReportScheduleCadence cadence,
    required String timeZoneId,
    required String localTime,
    String? weekday,
    int? dayOfMonth,
    required String executionUserId,
  }) = _UpdateAiReportSchedulePayload;

  /// Odtwarza payload z JSON.
  factory UpdateAiReportSchedulePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateAiReportSchedulePayloadFromJson(json);
}

/// Odbiorca harmonogramu AI w odpowiedzi.
@freezed
abstract class AiReportScheduleRecipientResponse
    with _$AiReportScheduleRecipientResponse {
  /// Zawiera zweryfikowany adres i aktywność odbiorcy.
  const factory AiReportScheduleRecipientResponse({
    required String userId,
    required AiReportDeliveryChannel channel,
    String? emailAddress,
    required bool enabled,
  }) = _AiReportScheduleRecipientResponse;

  /// Odtwarza odbiorcę z JSON.
  factory AiReportScheduleRecipientResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AiReportScheduleRecipientResponseFromJson(json);
}

/// Harmonogram raportu AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AiReportScheduleResponse with _$AiReportScheduleResponse {
  /// Zawiera konfigurację harmonogramu i następne uruchomienie.
  const factory AiReportScheduleResponse({
    required String scheduleId,
    required String workspaceId,
    required String projectId,
    required String reportType,
    required String contractVersion,
    required String reportVersion,
    required AiReportScheduleCadence cadence,
    required String timeZoneId,
    required String localTime,
    String? weekday,
    int? dayOfMonth,
    required String executionUserId,
    required DateTime nextRunAtUtc,
    required bool enabled,
    required List<AiReportScheduleRecipientResponse> recipients,
  }) = _AiReportScheduleResponse;

  /// Odtwarza harmonogram z JSON.
  factory AiReportScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$AiReportScheduleResponseFromJson(json);
}

/// Uruchomienie harmonogramu raportu AI.
@freezed
abstract class AiReportScheduleRunResponse with _$AiReportScheduleRunResponse {
  /// Zawiera stan, próby i powiązany job raportu.
  const factory AiReportScheduleRunResponse({
    required String runId,
    required String scheduleId,
    required String occurrenceKey,
    required DateTime scheduledForUtc,
    String? reportJobId,
    required AiReportScheduleRunStatus status,
    required int runAttemptCount,
    required int maxAttempts,
    required DateTime nextAttemptAtUtc,
    required DateTime createdAtUtc,
    DateTime? completedAtUtc,
    String? lastError,
  }) = _AiReportScheduleRunResponse;

  /// Odtwarza uruchomienie z JSON.
  factory AiReportScheduleRunResponse.fromJson(Map<String, dynamic> json) =>
      _$AiReportScheduleRunResponseFromJson(json);
}

/// Dostarczenie raportu AI do odbiorcy.
@freezed
abstract class AiReportDeliveryResponse with _$AiReportDeliveryResponse {
  /// Zawiera kanał, stan i czasy dostarczenia.
  const factory AiReportDeliveryResponse({
    required String deliveryId,
    required String scheduleRunId,
    required String reportJobId,
    required String recipientUserId,
    required AiReportDeliveryChannel channel,
    required AiReportDeliveryStatus status,
    required int attemptCount,
    required int maxAttempts,
    required DateTime availableAtUtc,
    DateTime? deliveredAtUtc,
    DateTime? failedAtUtc,
    DateTime? sentUnknownAtUtc,
    String? lastError,
  }) = _AiReportDeliveryResponse;

  /// Odtwarza dostarczenie z JSON.
  factory AiReportDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      _$AiReportDeliveryResponseFromJson(json);
}

/// Payload ręcznej rekonsyliacji dostarczenia AI.
@freezed
abstract class ResolveAiReportDeliveryPayload
    with _$ResolveAiReportDeliveryPayload {
  /// Ustawia docelowy status i opcjonalny powód błędu.
  const factory ResolveAiReportDeliveryPayload({
    required AiReportDeliveryResolutionStatus targetStatus,
    String? error,
  }) = _ResolveAiReportDeliveryPayload;

  /// Odtwarza payload z JSON.
  factory ResolveAiReportDeliveryPayload.fromJson(Map<String, dynamic> json) =>
      _$ResolveAiReportDeliveryPayloadFromJson(json);
}

/// Zdarzenie audytu raportu AI.
@freezed
abstract class AiReportAuditEventResponse with _$AiReportAuditEventResponse {
  /// Zawiera operację, provider, koszty i status zdarzenia.
  const factory AiReportAuditEventResponse({
    required String eventId,
    required String reportJobId,
    required String workspaceId,
    required String projectId,
    required String requestedByUserId,
    required String operationType,
    required String contractVersion,
    required String promptVersion,
    required AiOperationAuditEventType eventType,
    AiProviderKind? provider,
    String? model,
    required int attempt,
    required int inputCharacters,
    required int outputBytes,
    StorageAiReportFailureCode? failureCode,
    required DateTime occurredAtUtc,
  }) = _AiReportAuditEventResponse;

  /// Odtwarza audyt z JSON.
  factory AiReportAuditEventResponse.fromJson(Map<String, dynamic> json) =>
      _$AiReportAuditEventResponseFromJson(json);
}

/// Stan trwałego zadania analizy AI pliku.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageFileAnalysisJobResponse
    with _$StorageFileAnalysisJobResponse {
  /// Zawiera status, provider, retry i błąd analizy.
  const factory StorageFileAnalysisJobResponse({
    required String jobId,
    required String fileId,
    required int fileVersion,
    required StorageFileAnalysisJobStatus status,
    required int attemptCount,
    required int maxAttempts,
    DateTime? nextAttemptAtUtc,
    String? lastError,
    @Default(AiProviderKind.disabled) AiProviderKind provider,
    @Default(AiProviderStatus.unknown) AiProviderStatus providerStatus,
    @Default(true) bool retryable,
    DateTime? lastAttemptAtUtc,
    StorageAnalysisFailureCode? failureCode,
    String? contractVersion,
    String? operationId,
    AiOperationStatus? operationLifecycleStatus,
    int? retryAfterSeconds,
    StorageFileAnalysisErrorResponse? error,
  }) = _StorageFileAnalysisJobResponse;

  /// Odtwarza zadanie analizy z JSON.
  factory StorageFileAnalysisJobResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFileAnalysisJobResponseFromJson(json);
}

/// Snapshot statusu analizy AI pliku.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageFileAnalysisStatusResponse
    with _$StorageFileAnalysisStatusResponse {
  /// Zawiera status pliku, joba i providera.
  const factory StorageFileAnalysisStatusResponse({
    required String fileId,
    required int fileVersion,
    required StorageScanStatus scanStatus,
    required StorageAiStatus status,
    String? jobId,
    StorageFileAnalysisJobStatus? jobStatus,
    required int attemptCount,
    required int maxAttempts,
    required AiProviderKind provider,
    required AiProviderStatus providerStatus,
    required bool retryable,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    DateTime? startedAtUtc,
    DateTime? completedAtUtc,
    DateTime? failedAtUtc,
    DateTime? nextAttemptAtUtc,
    String? lastError,
    StorageAnalysisFailureCode? failureCode,
    String? contractVersion,
    String? operationId,
    AiOperationStatus? operationLifecycleStatus,
    int? retryAfterSeconds,
    StorageFileAnalysisErrorResponse? error,
  }) = _StorageFileAnalysisStatusResponse;

  /// Odtwarza status analizy z JSON.
  factory StorageFileAnalysisStatusResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageFileAnalysisStatusResponseFromJson(json);
}

/// Bezpieczny błąd analizy AI pliku.
@freezed
abstract class StorageFileAnalysisErrorResponse
    with _$StorageFileAnalysisErrorResponse {
  /// Zawiera kod błędu, komunikat i możliwość retry.
  const factory StorageFileAnalysisErrorResponse({
    required String code,
    required String message,
    required bool retryable,
    int? retryAfterSeconds,
  }) = _StorageFileAnalysisErrorResponse;

  /// Odtwarza błąd z JSON.
  factory StorageFileAnalysisErrorResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageFileAnalysisErrorResponseFromJson(json);
}
