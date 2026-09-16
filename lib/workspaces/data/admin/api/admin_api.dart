import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/admin/models/admin_models.dart';
import 'package:retrofit/retrofit.dart';

part 'admin_api.g.dart';

/// Klient Retrofit chronionych endpointów diagnostyki i konserwacji Ops.
@RestApi()
abstract class AdminApi {
  /// Tworzy klienta API administracyjnego.
  factory AdminApi(Dio dio, {String? baseUrl}) = _AdminApi;

  /// Pobiera dashboard diagnostyczny Ops.
  @GET('/api/v1/admin/ops/dashboard')
  Future<AdminOpsDashboardResponse> getDashboard();

  /// Pobiera inspector połączeń i pokoi realtime.
  @GET('/api/v1/admin/ops/realtime')
  Future<AdminRealtimeInspectorResponse> getRealtime();

  /// Pobiera heartbeat monitorowanych workerów.
  @GET('/api/v1/admin/ops/workers')
  Future<List<WorkerHeartbeatResponse>> listWorkers();

  /// Sprawdza stan integracji infrastrukturalnych.
  @GET('/api/v1/admin/ops/integrations')
  Future<AdminIntegrationsResponse> getIntegrations();

  /// Wyszukuje błędy systemowe po filtrach diagnostycznych.
  @GET('/api/v1/admin/ops/errors')
  Future<List<SystemErrorLogResponse>> listErrors({
    @Query('traceId') String? traceId,
    @Query('statusCode') int? statusCode,
    @Query('coreUserId') String? coreUserId,
    @Query('fromUtc') DateTime? fromUtc,
    @Query('toUtc') DateTime? toUtc,
    @Query('includeResolved') bool? includeResolved,
    @Query('limit') int? limit,
  });

  /// Pobiera najnowszy błąd po TraceId.
  @GET('/api/v1/admin/ops/errors/{traceId}')
  Future<SystemErrorLogResponse> getErrorByTrace(
    @Path('traceId') String traceId,
  );

  /// Oznacza błąd systemowy jako rozwiązany.
  @POST('/api/v1/admin/ops/errors/{id}/resolve')
  Future<AdminMaintenanceResultResponse> resolveError(
    @Path('id') String id,
  );

  /// Usuwa pojedynczy wpis błędu systemowego.
  @DELETE('/api/v1/admin/ops/errors/{id}')
  Future<AdminMaintenanceResultResponse> deleteError(@Path('id') String id);

  /// Usuwa stare wpisy błędów zgodnie z retencją.
  @POST('/api/v1/admin/ops/errors/purge')
  Future<AdminMaintenanceResultResponse> purgeErrors(
    @Body() PurgeSystemErrorsPayload payload,
  );

  /// Ponawia wiadomość z kolejki dead-letter.
  @POST('/api/v1/admin/ops/dead-letter/{queueName}/{id}/retry')
  Future<AdminMaintenanceResultResponse> retryDeadLetter(
    @Path('queueName') String queueName,
    @Path('id') String id,
  );

  /// Usuwa wiadomość z kolejki dead-letter.
  @DELETE('/api/v1/admin/ops/dead-letter/{queueName}/{id}')
  Future<AdminMaintenanceResultResponse> deleteDeadLetter(
    @Path('queueName') String queueName,
    @Path('id') String id,
  );

  /// Pobiera wiadomości oczekujące w kolejkach dead-letter.
  @GET('/api/v1/admin/ops/dead-letter')
  Future<List<DeadLetterItemResponse>> listDeadLetters();

  /// Sprawdza dostępność ClamAV.
  @GET('/api/v1/admin/ops/storage/clamav')
  Future<ClamAvProbeResponse> probeClamAv();

  /// Wymusza skanowanie konkretnego pliku lub kolejki oczekujących plików.
  @POST('/api/v1/admin/ops/storage/rescan')
  Future<StorageRescanResponse> rescanStorage(
    @Body() StorageRescanPayload payload,
  );

  /// Wykonuje raport dry-run osieroconych plików Storage.
  @GET('/api/v1/admin/ops/storage/orphaned')
  Future<StorageOrphanScanReportResponse> scanOrphans();

  /// Fizycznie usuwa osierocone pliki Storage.
  @POST('/api/v1/admin/ops/storage/orphaned/clean')
  Future<StorageOrphanPurgeReportResponse> purgeOrphans(
    @Body() StorageOrphanPurgePayload payload,
  );
}
