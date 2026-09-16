import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/admin/models/admin_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/storage/ai/models/storage_ai_models.dart';
import 'package:ready_next/workspaces/data/storage/payloads/storage_payloads.dart';
import 'package:ready_next/workspaces/data/storage/responses/storage_responses.dart';
import 'package:retrofit/retrofit.dart';

part 'storage_api.g.dart';

/// Klient Retrofit kontraktów plików, udostępnień i folderów Storage.
///
/// Każda metoda odwzorowuje ścieżkę z `StorageEndpoints.cs`.
@RestApi()
abstract class StorageApi {
  /// Tworzy bilet presigned PUT dla nowego pliku.
  factory StorageApi(Dio dio, {String? baseUrl}) = _StorageApi;

  /// Generuje bilet uploadu pliku do Storage.
  @POST('/api/v1/storage/upload-ticket')
  Future<StorageUploadTicketResponse> requestUploadTicket(
    @Body() StorageUploadTicketPayload payload,
  );

  /// Tworzy pusty dokument TXT, OOXML lub OpenDocument po stronie backendu.
  @POST('/api/v1/storage/files/create')
  Future<StorageFileResponse> createStorageDocument(
    @Body() CreateStorageDocumentPayload payload,
    @Header('Idempotency-Key') String idempotencyKey,
  );

  /// Zatwierdza plik po zakończonym uploadzie do S3/MinIO.
  @POST('/api/v1/storage/complete-upload/{fileId}')
  Future<StorageFileResponse> completeUpload(
    @Path('fileId') String fileId,
    @Body() CompleteStorageUploadPayload payload,
  );

  /// Generuje bilet pobrania gotowego pliku.
  @GET('/api/v1/storage/files/{fileId}/download-ticket')
  Future<StorageDownloadTicketResponse> getDownloadTicket(
    @Path('fileId') String fileId,
  );

  /// Pobiera aktywne udostępnienia pliku.
  @GET('/api/v1/storage/files/{fileId}/shares')
  Future<List<StorageFileShareResponse>> listFileShares(
    @Path('fileId') String fileId,
  );

  /// Tworzy udostępnienie pliku użytkownikowi, workspace, projektowi lub linkowi publicznemu.
  @POST('/api/v1/storage/files/{fileId}/shares')
  Future<StorageFileShareResponse> createFileShare(
    @Path('fileId') String fileId,
    @Body() CreateStorageFileSharePayload payload,
  );

  /// Usuwa konkretne udostępnienie pliku.
  @DELETE('/api/v1/storage/files/{fileId}/shares/{shareId}')
  Future<void> deleteFileShare(
    @Path('fileId') String fileId,
    @Path('shareId') String shareId,
  );

  /// Tworzy wirtualny folder bez kopiowania obiektów w Storage.
  @POST('/api/v1/storage/folders')
  Future<StorageFolderResponse> createFolder(
    @Body() CreateStorageFolderPayload payload,
  );

  /// Pobiera foldery dostępne w wybranym kontekście.
  @GET('/api/v1/storage/folders')
  Future<List<StorageFolderResponse>> listFolders({
    @Query('folderType') String? folderType,
    @Query('workspaceId') String? workspaceId,
    @Query('projectId') String? projectId,
  });

  /// Pobiera szczegóły pojedynczego folderu.
  @GET('/api/v1/storage/folders/{folderId}')
  Future<StorageFolderResponse> getFolder(
    @Path('folderId') String folderId,
  );

  /// Generuje zbiorcze bilety uploadu.
  @POST('/api/v1/storage/bulk-upload-tickets')
  Future<BulkStorageUploadTicketResponse> requestBulkUploadTickets(
    @Body() BulkStorageUploadTicketPayload payload,
  );

  /// Zatwierdza zbiorczo przesłane pliki.
  @POST('/api/v1/storage/bulk-complete-upload')
  Future<BulkCompleteUploadResponse> completeBulkUpload(
    @Body() BulkCompleteUploadPayload payload,
  );

  /// Czyści nieużywane obrazy Quill.
  @POST('/api/v1/storage/quill/clean-unused-images')
  Future<QuillCleanUnusedImagesResponse> cleanUnusedQuillImages(
    @Body() QuillCleanUnusedImagesPayload payload,
  );

  /// Ustawia avatar bieżącego użytkownika.
  @PUT('/api/v1/me/avatar/')
  Future<StorageFileResponse> setCurrentUserAvatar(
    @Body() SetUserAvatarPayload payload,
  );

  /// Usuwa avatar bieżącego użytkownika.
  @DELETE('/api/v1/me/avatar/')
  Future<void> deleteCurrentUserAvatar();

  /// Pobiera avatar bieżącego użytkownika.
  @GET('/api/v1/me/avatar/')
  Future<StorageFileResponse?> getCurrentUserAvatar();

  /// Streamuje plik Storage.
  @GET('/api/v1/storage/files/{fileId}/stream')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> streamFile(@Path('fileId') String fileId);

  /// Streamuje wskazaną wersję pliku.
  @GET('/api/v1/storage/files/{fileId}/versions/{version}/stream')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> streamFileVersion(
    @Path('fileId') String fileId,
    @Path('version') int version,
  );

  /// Pobiera cursorową listę plików.
  @GET('/api/v1/storage/files')
  Future<CursorPageResponse<StorageFileResponse>> listFiles({
    @Query('module') String? module,
    @Query('resourceType') String? resourceType,
    @Query('resourceId') String? resourceId,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('sharedByUserId') String? sharedByUserId,
    @Query('view') String? view,
    @Query('myFilesOnly') bool? myFilesOnly,
    @Query('includeDeleted') bool? includeDeleted,
    @Query('q') String? query,
    @Query('ownerUserId') String? ownerUserId,
    @Query('mimeType') String? mimeType,
    @Query('extension') String? extension,
    @Query('aiTag') String? aiTag,
    @Query('aiStatus') String? aiStatus,
    @Query('createdFromUtc') DateTime? createdFromUtc,
    @Query('createdToUtc') DateTime? createdToUtc,
    @Query('minSizeBytes') int? minSizeBytes,
    @Query('maxSizeBytes') int? maxSizeBytes,
    @Query('workspaceId') String? workspaceId,
    @Query('projectId') String? projectId,
    @Query('folderId') String? folderId,
  });

  /// Wyszukuje semantycznie pliki Storage.
  @GET('/api/v1/storage/files/search/semantic')
  Future<StorageSemanticSearchResponse> searchSemanticFiles(
    @Query('q') String query, {
    @Query('take') int? take,
    @Query('workspaceId') String? workspaceId,
  });

  /// Pobiera szczegóły pliku.
  @GET('/api/v1/storage/files/{fileId}')
  Future<StorageFileDetailsResponse> getFileDetails(
    @Path('fileId') String fileId,
  );

  /// Pobiera bezpieczny deep link pliku.
  @GET('/api/v1/storage/files/{fileId}/deep-link')
  Future<StorageFileDeepLinkResponse> getFileDeepLink(
    @Path('fileId') String fileId,
  );

  /// Ustawia ulubiony stan pliku.
  @PUT('/api/v1/storage/files/{fileId}/favorite')
  Future<StorageFileUserStateResponse> setFileFavorite(
    @Path('fileId') String fileId,
    @Body() SetStorageFileFavoritePayload payload,
  );

  /// Aktualizuje opis pliku.
  @PUT('/api/v1/storage/files/{fileId}/description')
  Future<StorageFileResponse> updateFileDescription(
    @Path('fileId') String fileId,
    @Body() UpdateStorageFileDescriptionPayload payload,
  );

  /// Ponawia analizę AI pliku.
  @POST('/api/v1/storage/files/{fileId}/analysis/retry')
  Future<StorageFileAnalysisJobResponse> retryFileAnalysis(
    @Path('fileId') String fileId,
  );

  /// Pobiera status analizy pliku.
  @GET('/api/v1/storage/files/{fileId}/analysis')
  Future<StorageFileAnalysisStatusResponse> getFileAnalysis(
    @Path('fileId') String fileId,
  );

  /// Pobiera wersje pliku.
  @GET('/api/v1/storage/files/{fileId}/versions')
  Future<List<StorageFileVersionResponse>> listFileVersions(
    @Path('fileId') String fileId,
  );

  /// Generuje bilet pobrania wersji pliku.
  @GET('/api/v1/storage/files/{fileId}/versions/{version}/download-ticket')
  Future<StorageFileVersionDownloadTicketResponse> getFileVersionDownloadTicket(
    @Path('fileId') String fileId,
    @Path('version') int version,
  );

  /// Przywraca wersję pliku.
  @POST('/api/v1/storage/files/{fileId}/versions/{version}/restore')
  Future<StorageFileResponse> restoreFileVersion(
    @Path('fileId') String fileId,
    @Path('version') int version,
    @Body() RestoreStorageFileVersionPayload payload,
  );

  /// Usuwa plik.
  @DELETE('/api/v1/storage/files/{fileId}')
  Future<void> deleteFile(@Path('fileId') String fileId);

  /// Przywraca usunięty plik.
  @POST('/api/v1/storage/files/{fileId}/restore')
  Future<StorageFileResponse> restoreFile(@Path('fileId') String fileId);

  /// Generuje zbiorcze archiwum ZIP.
  @POST('/api/v1/storage/bulk-download-zip')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> bulkDownloadZip(
    @Body() BulkDownloadZipPayload payload,
  );

  /// Otwiera sesję OnlyOffice dla pliku.
  @GET('/api/v1/storage/files/{fileId}/office-session')
  Future<OnlyOfficeSessionResponse> getOfficeSession(
    @Path('fileId') String fileId,
  );

  /// Konwertuje dokument do PDF.
  @POST('/api/v1/storage/files/{fileId}/convert-to-pdf')
  Future<StorageFileResponse> convertToPdf(@Path('fileId') String fileId);

  /// Generuje bilet uploadu avatara.
  @POST('/api/v1/storage/avatar/upload-ticket')
  Future<StorageUploadTicketResponse> requestAvatarUploadTicket(
    @Body() StorageUploadTicketItemPayload payload,
  );

  /// Pobiera publiczny bilet pobrania.
  @POST('/api/v1/storage/public/shares/{shareToken}/download-ticket')
  Future<StorageDownloadTicketResponse> getPublicShareDownloadTicket(
    @Path('shareToken') String shareToken,
    @Body() PublicShareAccessPayload payload,
  );

  /// Aktualizuje folder.
  @PATCH('/api/v1/storage/folders/{folderId}')
  Future<StorageFolderResponse> updateFolder(
    @Path('folderId') String folderId,
    @Body() UpdateStorageFolderPayload payload,
  );

  /// Przenosi folder.
  @POST('/api/v1/storage/folders/{folderId}/move')
  Future<StorageFolderResponse> moveFolder(
    @Path('folderId') String folderId,
    @Body() UpdateStorageFolderPayload payload,
  );

  /// Usuwa pusty folder.
  @DELETE('/api/v1/storage/folders/{folderId}')
  Future<void> deleteFolder(@Path('folderId') String folderId);

  /// Pobiera dzieci folderu.
  @GET('/api/v1/storage/folders/{folderId}/children')
  Future<StorageFolderChildrenResponse> getFolderChildren(
    @Path('folderId') String folderId,
  );

  /// Pobiera placementy folderu.
  @GET('/api/v1/storage/folders/{folderId}/placements')
  Future<List<StorageFilePlacementResponse>> listFolderPlacements(
    @Path('folderId') String folderId,
  );

  /// Dodaje masowo pliki do folderu.
  @POST('/api/v1/storage/folders/{folderId}/placements/bulk')
  Future<List<StorageFilePlacementResponse>> bulkCreatePlacements(
    @Path('folderId') String folderId,
    @Body() BulkCreateStorageFilePlacementPayload payload,
  );

  /// Tworzy udostępnienie folderu.
  @POST('/api/v1/storage/folders/{folderId}/shares')
  Future<StorageFolderShareResponse> createFolderShare(
    @Path('folderId') String folderId,
    @Body() CreateStorageFolderSharePayload payload,
  );

  /// Listuje udostępnienia folderu.
  @GET('/api/v1/storage/folders/{folderId}/shares')
  Future<List<StorageFolderShareResponse>> listFolderShares(
    @Path('folderId') String folderId,
  );

  /// Usuwa udostępnienie folderu.
  @DELETE('/api/v1/storage/folders/{folderId}/shares/{shareId}')
  Future<void> deleteFolderShare(
    @Path('folderId') String folderId,
    @Path('shareId') String shareId,
  );

  /// Dodaje plik do folderu.
  @POST('/api/v1/storage/files/{fileId}/placements')
  Future<StorageFilePlacementResponse> createFilePlacement(
    @Path('fileId') String fileId,
    @Body() CreateStorageFilePlacementPayload payload,
  );

  /// Usuwa placement pliku.
  @DELETE('/api/v1/storage/files/{fileId}/placements/{placementId}')
  Future<void> deleteFilePlacement(
    @Path('fileId') String fileId,
    @Path('placementId') String placementId,
  );

  /// Dołącza plik do projektu.
  @POST('/api/v1/storage/projects/{projectId}/files/{fileId}/attach')
  Future<StorageFilePlacementResponse> attachFileToProject(
    @Path('projectId') String projectId,
    @Path('fileId') String fileId,
    @Body() AttachStorageFileToProjectPayload payload,
  );

  /// Skanuje osierocone obiekty Storage.
  @POST('/api/v1/storage/admin/orphans/scan')
  Future<StorageOrphanScanReportResponse> scanOrphans(
    @Query('trashRetentionDays') int? trashRetentionDays,
  );

  /// Usuwa wskazane osierocone obiekty Storage.
  @POST('/api/v1/storage/admin/orphans/purge')
  Future<StorageOrphanPurgeReportResponse> purgeOrphans(
    @Body() StorageOrphanPurgePayload payload,
  );

  /// Zapisuje wynik skanowania antywirusowego pliku.
  @POST('/api/v1/storage/admin/files/{fileId}/scan-result')
  Future<StorageFileResponse> updateScanResult(
    @Path('fileId') String fileId,
    @Body() StorageScanResultPayload payload,
  );

  /// Obsługuje callback OnlyOffice.
  @POST('/api/v1/storage/office-callback')
  Future<OnlyOfficeCallbackResponse> officeCallback(
    @Body() OnlyOfficeCallbackPayload payload,
  );

  /// Pobiera audyt analiz AI plików.
  @GET('/api/v1/workspaces/{workspaceId}/ai/audit/file-analyses')
  Future<CursorPageResponse<AiFileAnalysisAuditEventResponse>>
  listAiFileAnalysisAudit({
    @Path('workspaceId') required String workspaceId,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('projectId') String? projectId,
    @Query('fileId') String? fileId,
    @Query('eventType') String? eventType,
    @Query('provider') String? provider,
    @Query('failureCode') String? failureCode,
    @Query('occurredFromUtc') DateTime? occurredFromUtc,
    @Query('occurredToUtc') DateTime? occurredToUtc,
  });

  /// Pobiera podsumowanie użycia AI.
  @GET('/api/v1/workspaces/{workspaceId}/ai/audit/usage')
  Future<AiUsageSummaryResponse> getAiUsageSummary(
    @Path('workspaceId') String workspaceId, {
    @Query('fromUtc') DateTime? fromUtc,
    @Query('toUtc') DateTime? toUtc,
    @Query('userId') String? userId,
    @Query('projectId') String? projectId,
    @Query('provider') String? provider,
  });

  /// Pobiera typy raportów AI projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/types')
  Future<List<StorageAiReportTypeResponse>> listAiReportTypes(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Pobiera audyt raportów AI projektu.
  @GET('/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/audit')
  Future<CursorPageResponse<AiReportAuditEventResponse>> listAiReportAudit(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('reportType') String? reportType,
    @Query('contractVersion') String? contractVersion,
    @Query('eventType') String? eventType,
  });

  /// Tworzy raport AI projektu.
  @POST('/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/')
  Future<StorageAiReportResponse> createAiReport(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateStorageAiReportPayload payload,
  );

  /// Pobiera raport AI projektu.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/{reportId}',
  )
  Future<StorageAiReportResponse> getAiReport(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('reportId') String reportId,
  );

  /// Ponawia generowanie raportu AI.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/{reportId}/retry',
  )
  Future<StorageAiReportResponse> retryAiReport(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('reportId') String reportId,
  );

  /// Tworzy harmonogram raportu AI.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules',
  )
  Future<AiReportScheduleResponse> createAiReportSchedule(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Body() CreateAiReportSchedulePayload payload,
  );

  /// Listuje harmonogramy raportów AI.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules',
  )
  Future<List<AiReportScheduleResponse>> listAiReportSchedules(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
  );

  /// Wyłącza harmonogram raportu AI.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules/{scheduleId}',
  )
  Future<AiReportScheduleResponse> disableAiReportSchedule(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('scheduleId') String scheduleId,
  );

  /// Aktualizuje harmonogram raportu AI.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules/{scheduleId}',
  )
  Future<AiReportScheduleResponse> updateAiReportSchedule(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('scheduleId') String scheduleId,
    @Body() UpdateAiReportSchedulePayload payload,
  );

  /// Włącza harmonogram raportu AI.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules/{scheduleId}/enable',
  )
  Future<AiReportScheduleResponse> enableAiReportSchedule(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('scheduleId') String scheduleId,
  );

  /// Uruchamia harmonogram raportu AI natychmiast.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules/{scheduleId}/run-now',
  )
  Future<AiReportScheduleResponse> runAiReportScheduleNow(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('scheduleId') String scheduleId,
  );

  /// Pobiera uruchomienia harmonogramu raportu AI.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules/{scheduleId}/runs',
  )
  Future<CursorPageResponse<AiReportScheduleRunResponse>>
  listAiReportScheduleRuns(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('scheduleId') String scheduleId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('status') String? status,
  });

  /// Pobiera dostarczenia harmonogramu raportu AI.
  @GET(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules/{scheduleId}/deliveries',
  )
  Future<CursorPageResponse<AiReportDeliveryResponse>> listAiReportDeliveries(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('scheduleId') String scheduleId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('channel') String? channel,
    @Query('deliveryStatus') String? deliveryStatus,
  });

  /// Rozwiązuje dostarczenie raportu AI.
  @POST(
    '/api/v1/workspaces/{workspaceId}/projects/{projectId}/ai-reports/schedules/{scheduleId}/deliveries/{deliveryId}/resolve',
  )
  Future<AiReportDeliveryResponse> resolveAiReportDelivery(
    @Path('workspaceId') String workspaceId,
    @Path('projectId') String projectId,
    @Path('scheduleId') String scheduleId,
    @Path('deliveryId') String deliveryId,
    @Body() ResolveAiReportDeliveryPayload payload,
  );
}
