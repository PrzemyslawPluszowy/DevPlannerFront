import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_extended_models.freezed.dart';
part 'storage_extended_models.g.dart';

/// Payload zbiorczego generowania biletów uploadu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkStorageUploadTicketPayload
    with _$BulkStorageUploadTicketPayload {
  /// Przekazuje pliki i kontekst zasobu.
  const factory BulkStorageUploadTicketPayload({
    required List<StorageUploadTicketItemPayload> files,
    required StorageModule module,
    required StorageResourceType resourceType,
    String? resourceId,
    String? workspaceId,
    String? projectId,
  }) = _BulkStorageUploadTicketPayload;

  /// Odtwarza payload z JSON.
  factory BulkStorageUploadTicketPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkStorageUploadTicketPayloadFromJson(json);
}

/// Payload oczyszczenia obrazów Quill z dokumentu.
@freezed
abstract class QuillCleanUnusedImagesPayload
    with _$QuillCleanUnusedImagesPayload {
  /// Wskazuje treść i zasób, z którego należy odczytać referencje.
  const factory QuillCleanUnusedImagesPayload({
    required String deltaJson,
    required StorageResourceType resourceType,
    required String resourceId,
  }) = _QuillCleanUnusedImagesPayload;

  /// Odtwarza payload z JSON.
  factory QuillCleanUnusedImagesPayload.fromJson(Map<String, dynamic> json) =>
      _$QuillCleanUnusedImagesPayloadFromJson(json);
}

/// Payload aktualizacji opisu pliku.
@freezed
abstract class UpdateStorageFileDescriptionPayload
    with _$UpdateStorageFileDescriptionPayload {
  /// Przekazuje opis i token optimistic concurrency.
  const factory UpdateStorageFileDescriptionPayload({
    String? manualDescription,
    String? expectedConcurrencyToken,
  }) = _UpdateStorageFileDescriptionPayload;

  /// Odtwarza payload z JSON.
  factory UpdateStorageFileDescriptionPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateStorageFileDescriptionPayloadFromJson(json);
}

/// Payload zmiany folderu.
@freezed
abstract class UpdateStorageFolderPayload with _$UpdateStorageFolderPayload {
  /// Przekazuje nazwę i folder nadrzędny.
  const factory UpdateStorageFolderPayload({
    String? name,
    String? parentFolderId,
  }) = _UpdateStorageFolderPayload;

  /// Odtwarza payload z JSON.
  factory UpdateStorageFolderPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateStorageFolderPayloadFromJson(json);
}

/// Payload udostępnienia folderu.
@freezed
abstract class CreateStorageFolderSharePayload
    with _$CreateStorageFolderSharePayload {
  /// Wskazuje odbiorcę i poziom dostępu.
  const factory CreateStorageFolderSharePayload({
    required String sharedWithUserId,
    required StorageShareAccessLevel accessLevel,
    DateTime? expiresAtUtc,
  }) = _CreateStorageFolderSharePayload;

  /// Odtwarza payload z JSON.
  factory CreateStorageFolderSharePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateStorageFolderSharePayloadFromJson(json);
}

/// Odpowiedź udostępnienia folderu.
@freezed
abstract class StorageFolderShareResponse with _$StorageFolderShareResponse {
  /// Zawiera odbiorcę, prawa i czas udostępnienia.
  const factory StorageFolderShareResponse({
    required String id,
    required String folderId,
    required String sharedWithUserId,
    required StorageShareAccessLevel accessLevel,
    DateTime? expiresAtUtc,
    required String createdByUserId,
    required DateTime createdAtUtc,
    required StorageEffectiveAccessLevel effectiveAccessLevel,
    required bool canRead,
    required bool canComment,
    required bool canEdit,
    required bool canShare,
    required bool canDelete,
  }) = _StorageFolderShareResponse;

  /// Odtwarza share folderu z JSON.
  factory StorageFolderShareResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFolderShareResponseFromJson(json);
}

/// Payload dołączenia pliku do projektu.
@freezed
abstract class AttachStorageFileToProjectPayload
    with _$AttachStorageFileToProjectPayload {
  /// Wskazuje folder projektu i nazwę prezentacyjną.
  const factory AttachStorageFileToProjectPayload({
    required String folderId,
    String? displayName,
  }) = _AttachStorageFileToProjectPayload;

  /// Odtwarza payload z JSON.
  factory AttachStorageFileToProjectPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$AttachStorageFileToProjectPayloadFromJson(json);
}

/// Payload anonimowego dostępu do publicznego share'a.
@freezed
abstract class PublicShareAccessPayload with _$PublicShareAccessPayload {
  /// Przekazuje opcjonalne hasło share'a.
  const factory PublicShareAccessPayload({String? password}) =
      _PublicShareAccessPayload;

  /// Odtwarza payload z JSON.
  factory PublicShareAccessPayload.fromJson(Map<String, dynamic> json) =>
      _$PublicShareAccessPayloadFromJson(json);
}

/// Odpowiedź czyszczenia nieużywanych obrazów Quill.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class QuillCleanUnusedImagesResponse
    with _$QuillCleanUnusedImagesResponse {
  /// Zawiera usunięte identyfikatory plików.
  const factory QuillCleanUnusedImagesResponse({
    required List<String> deletedFileIds,
  }) = _QuillCleanUnusedImagesResponse;

  /// Odtwarza raport z JSON.
  factory QuillCleanUnusedImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$QuillCleanUnusedImagesResponseFromJson(json);
}

/// Payload przypisania pliku jako avatara.
@freezed
abstract class SetUserAvatarPayload with _$SetUserAvatarPayload {
  /// Wskazuje plik graficzny avatara.
  const factory SetUserAvatarPayload({required String fileId}) =
      _SetUserAvatarPayload;

  /// Odtwarza payload z JSON.
  factory SetUserAvatarPayload.fromJson(Map<String, dynamic> json) =>
      _$SetUserAvatarPayloadFromJson(json);
}

/// Payload wyniku skanowania antywirusowego.
@freezed
abstract class StorageScanResultPayload with _$StorageScanResultPayload {
  /// Przekazuje status skanowania pliku.
  const factory StorageScanResultPayload({
    required StorageScanStatus scanStatus,
  }) = _StorageScanResultPayload;

  /// Odtwarza payload z JSON.
  factory StorageScanResultPayload.fromJson(Map<String, dynamic> json) =>
      _$StorageScanResultPayloadFromJson(json);
}

/// Wersja pliku Storage.
@freezed
abstract class StorageFileVersionResponse with _$StorageFileVersionResponse {
  /// Zawiera metadane historycznej wersji pliku.
  const factory StorageFileVersionResponse({
    required String id,
    required int version,
    required int fileSizeBytes,
    String? contentSha256,
    required String createdByUserId,
    required DateTime createdAtUtc,
    String? changeSummary,
    @Default(false) bool isCurrent,
    String? changedByUserId,
  }) = _StorageFileVersionResponse;

  /// Odtwarza wersję z JSON.
  factory StorageFileVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFileVersionResponseFromJson(json);
}

/// Payload przywrócenia historycznej wersji pliku.
@freezed
abstract class RestoreStorageFileVersionPayload
    with _$RestoreStorageFileVersionPayload {
  /// Przekazuje wersję bieżącą i opis zmiany.
  const factory RestoreStorageFileVersionPayload({
    required int expectedVersion,
    String? changeSummary,
  }) = _RestoreStorageFileVersionPayload;

  /// Odtwarza payload z JSON.
  factory RestoreStorageFileVersionPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$RestoreStorageFileVersionPayloadFromJson(json);
}

/// Bilet pobrania historycznej wersji pliku.
@freezed
abstract class StorageFileVersionDownloadTicketResponse
    with _$StorageFileVersionDownloadTicketResponse {
  /// Zawiera dane pliku, wersję i URL pobrania.
  const factory StorageFileVersionDownloadTicketResponse({
    required String fileId,
    required int version,
    required String originalFileName,
    required String mimeType,
    required int fileSizeBytes,
    String? contentSha256,
    required String downloadUrl,
    required DateTime expiresAtUtc,
  }) = _StorageFileVersionDownloadTicketResponse;

  /// Odtwarza bilet z JSON.
  factory StorageFileVersionDownloadTicketResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageFileVersionDownloadTicketResponseFromJson(json);
}

/// Uprawnienia bieżącego użytkownika do pliku.
@freezed
abstract class StorageFilePermissionsResponse
    with _$StorageFilePermissionsResponse {
  /// Zawiera poziom i prawa szczegółowe.
  const factory StorageFilePermissionsResponse({
    required StorageEffectiveAccessLevel accessLevel,
    required bool canRead,
    required bool canComment,
    required bool canEdit,
    required bool canShare,
    required bool canDelete,
  }) = _StorageFilePermissionsResponse;

  /// Odtwarza uprawnienia z JSON.
  factory StorageFilePermissionsResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFilePermissionsResponseFromJson(json);
}

/// Pełne szczegóły pliku z historią wersji.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageFileDetailsResponse with _$StorageFileDetailsResponse {
  /// Zawiera snapshot pliku, wersje i uprawnienia.
  const factory StorageFileDetailsResponse({
    required StorageFileResponse file,
    required List<StorageFileVersionResponse> versions,
    required bool canEdit,
    required bool canDelete,
    required bool isOfficeDocument,
    required StorageFilePermissionsResponse permissions,
    @Default(false) bool canOpenResourceChat,
  }) = _StorageFileDetailsResponse;

  /// Odtwarza szczegóły z JSON.
  factory StorageFileDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFileDetailsResponseFromJson(json);
}

/// Placement pliku w wirtualnym folderze.
@freezed
abstract class StorageFilePlacementResponse
    with _$StorageFilePlacementResponse {
  /// Zawiera folder, plik i prawa bieżącego użytkownika.
  const factory StorageFilePlacementResponse({
    required String id,
    required String fileId,
    required String folderId,
    String? displayName,
    String? resourceType,
    String? resourceId,
    required DateTime createdAtUtc,
    String? fileName,
    String? mimeType,
    int? fileSizeBytes,
    StorageFilePermissionsResponse? permissions,
  }) = _StorageFilePlacementResponse;

  /// Odtwarza placement z JSON.
  factory StorageFilePlacementResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFilePlacementResponseFromJson(json);
}

/// Payload utworzenia placementu pliku.
@freezed
abstract class CreateStorageFilePlacementPayload
    with _$CreateStorageFilePlacementPayload {
  /// Wskazuje folder i opcjonalne metadane widoku.
  const factory CreateStorageFilePlacementPayload({
    required String folderId,
    String? displayName,
    String? resourceType,
    String? resourceId,
  }) = _CreateStorageFilePlacementPayload;

  /// Odtwarza payload z JSON.
  factory CreateStorageFilePlacementPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateStorageFilePlacementPayloadFromJson(json);
}

/// Payload masowego dodania plików do folderu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkCreateStorageFilePlacementPayload
    with _$BulkCreateStorageFilePlacementPayload {
  /// Przekazuje identyfikatory plików i wspólny prefiks nazwy.
  const factory BulkCreateStorageFilePlacementPayload({
    required List<String> fileIds,
    String? displayNamePrefix,
  }) = _BulkCreateStorageFilePlacementPayload;

  /// Odtwarza payload z JSON.
  factory BulkCreateStorageFilePlacementPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$BulkCreateStorageFilePlacementPayloadFromJson(json);
}

/// Zawartość folderu Storage.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageFolderChildrenResponse
    with _$StorageFolderChildrenResponse {
  /// Zawiera folder bazowy, podfoldery i placementy.
  const factory StorageFolderChildrenResponse({
    required StorageFolderResponse folder,
    required List<StorageFolderResponse> folders,
    required List<StorageFilePlacementResponse> placements,
  }) = _StorageFolderChildrenResponse;

  /// Odtwarza zawartość z JSON.
  factory StorageFolderChildrenResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFolderChildrenResponseFromJson(json);
}

/// Stan ulubionego pliku bieżącego użytkownika.
@freezed
abstract class StorageFileUserStateResponse
    with _$StorageFileUserStateResponse {
  /// Zawiera stan ulubionego i ostatniego dostępu.
  const factory StorageFileUserStateResponse({
    required String fileId,
    required bool isFavorite,
    DateTime? favoritedAtUtc,
    DateTime? lastAccessedAtUtc,
  }) = _StorageFileUserStateResponse;

  /// Odtwarza stan z JSON.
  factory StorageFileUserStateResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFileUserStateResponseFromJson(json);
}

/// Payload ustawienia ulubionego pliku.
@freezed
abstract class SetStorageFileFavoritePayload
    with _$SetStorageFileFavoritePayload {
  /// Ustawia stan ulubionego.
  const factory SetStorageFileFavoritePayload({required bool isFavorite}) =
      _SetStorageFileFavoritePayload;

  /// Odtwarza payload z JSON.
  factory SetStorageFileFavoritePayload.fromJson(Map<String, dynamic> json) =>
      _$SetStorageFileFavoritePayloadFromJson(json);
}

/// Deep link do pliku i jego rozmowy Chat.
@freezed
abstract class StorageFileDeepLinkResponse with _$StorageFileDeepLinkResponse {
  /// Zawiera ścieżkę pliku i ścieżkę Resource Chat.
  const factory StorageFileDeepLinkResponse({
    required String fileId,
    String? workspaceId,
    String? projectId,
    required String filePath,
    required String conversationPath,
  }) = _StorageFileDeepLinkResponse;

  /// Odtwarza deep link z JSON.
  factory StorageFileDeepLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFileDeepLinkResponseFromJson(json);
}

/// Sesja edytora OnlyOffice.
@freezed
abstract class OnlyOfficeSessionResponse with _$OnlyOfficeSessionResponse {
  /// Zawiera konfigurację dokumentu i uprawnienie edycji.
  const factory OnlyOfficeSessionResponse({
    required String fileId,
    required String documentType,
    required String documentServerUrl,
    required String documentKey,
    required String token,
    required bool canEdit,
  }) = _OnlyOfficeSessionResponse;

  /// Odtwarza sesję z JSON.
  factory OnlyOfficeSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$OnlyOfficeSessionResponseFromJson(json);
}

/// Payload callbacku OnlyOffice.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class OnlyOfficeCallbackPayload with _$OnlyOfficeCallbackPayload {
  /// Przekazuje status, URL i dane historii callbacku.
  const factory OnlyOfficeCallbackPayload({
    String? key,
    required int status,
    String? url,
    List<String>? users,
    List<Map<String, dynamic>>? actions,
    Map<String, dynamic>? history,
    String? token,
  }) = _OnlyOfficeCallbackPayload;

  /// Odtwarza callback z JSON.
  factory OnlyOfficeCallbackPayload.fromJson(Map<String, dynamic> json) =>
      _$OnlyOfficeCallbackPayloadFromJson(json);
}

/// Odpowiedź protokołu OnlyOffice.
@freezed
abstract class OnlyOfficeCallbackResponse with _$OnlyOfficeCallbackResponse {
  /// Kod 0 oznacza sukces.
  const factory OnlyOfficeCallbackResponse({required int error}) =
      _OnlyOfficeCallbackResponse;

  /// Odtwarza odpowiedź z JSON.
  factory OnlyOfficeCallbackResponse.fromJson(Map<String, dynamic> json) =>
      _$OnlyOfficeCallbackResponseFromJson(json);
}

/// Payload pobrania wielu plików jako ZIP.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkDownloadZipPayload with _$BulkDownloadZipPayload {
  /// Przekazuje pliki i nazwę archiwum.
  const factory BulkDownloadZipPayload({
    required List<String> fileIds,
    @Default('zalaczniki.zip') String? zipFileName,
  }) = _BulkDownloadZipPayload;

  /// Odtwarza payload z JSON.
  factory BulkDownloadZipPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkDownloadZipPayloadFromJson(json);
}

/// Wynik wyszukiwania semantycznego plików.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageSemanticSearchResponse
    with _$StorageSemanticSearchResponse {
  /// Zawiera status rankingu i trafienia.
  const factory StorageSemanticSearchResponse({
    required String status,
    String? code,
    required String rankingVersion,
    required List<StorageSemanticSearchHitResponse> hits,
  }) = _StorageSemanticSearchResponse;

  /// Odtwarza wynik z JSON.
  factory StorageSemanticSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageSemanticSearchResponseFromJson(json);
}

/// Pojedyncze trafienie wyszukiwania semantycznego.
@freezed
abstract class StorageSemanticSearchHitResponse
    with _$StorageSemanticSearchHitResponse {
  /// Zawiera fragment, wersję i wynik rankingu.
  const factory StorageSemanticSearchHitResponse({
    required String fileId,
    required int fileVersion,
    required int chunkIndex,
    required String text,
    required double distance,
    required double score,
    required bool fullTextMatch,
  }) = _StorageSemanticSearchHitResponse;

  /// Odtwarza trafienie z JSON.
  factory StorageSemanticSearchHitResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageSemanticSearchHitResponseFromJson(json);
}

/// Typ raportu AI dostępny dla projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageAiReportTypeResponse with _$StorageAiReportTypeResponse {
  /// Zawiera wersje, opis i wymagane sekcje raportu.
  const factory StorageAiReportTypeResponse({
    required String reportType,
    required String promptVersion,
    required int schemaVersion,
    required String description,
    @Default('ai.v1') String contractVersion,
    List<String>? requiredSectionKeys,
    @Default(StorageAiReportScopeType.project)
    StorageAiReportScopeType scopeType,
  }) = _StorageAiReportTypeResponse;

  /// Odtwarza typ raportu z JSON.
  factory StorageAiReportTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageAiReportTypeResponseFromJson(json);
}

/// Payload utworzenia raportu AI.
@freezed
abstract class CreateStorageAiReportPayload
    with _$CreateStorageAiReportPayload {
  /// Wskazuje typ, kontrakt i opcjonalny prompt.
  const factory CreateStorageAiReportPayload({
    @Default('project.summary') String reportType,
    @Default('ai.v1') String contractVersion,
    String? promptVersion,
  }) = _CreateStorageAiReportPayload;

  /// Odtwarza payload z JSON.
  factory CreateStorageAiReportPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateStorageAiReportPayloadFromJson(json);
}

/// Źródło użyte w raporcie AI.
@freezed
abstract class StorageAiReportSourceResponse
    with _$StorageAiReportSourceResponse {
  /// Zawiera plik, wersję i hash snapshotu.
  const factory StorageAiReportSourceResponse({
    required String fileId,
    required int fileVersion,
    required String fileName,
    String? contentSha256,
  }) = _StorageAiReportSourceResponse;

  /// Odtwarza źródło z JSON.
  factory StorageAiReportSourceResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageAiReportSourceResponseFromJson(json);
}

/// Sekcja dokumentu raportu AI.
@freezed
abstract class StorageAiReportDocumentSectionResponse
    with _$StorageAiReportDocumentSectionResponse {
  /// Zawiera klucz, tytuł i treść sekcji.
  const factory StorageAiReportDocumentSectionResponse({
    required String key,
    required String title,
    required String content,
    required int order,
  }) = _StorageAiReportDocumentSectionResponse;

  /// Odtwarza sekcję z JSON.
  factory StorageAiReportDocumentSectionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageAiReportDocumentSectionResponseFromJson(json);
}

/// Źródło sekcji dokumentu AI.
@freezed
abstract class StorageAiReportDocumentSourceResponse
    with _$StorageAiReportDocumentSourceResponse {
  /// Zawiera typ, identyfikator i wersję źródła.
  const factory StorageAiReportDocumentSourceResponse({
    required String sourceType,
    required String sourceId,
    int? version,
    String? contentSha256,
    required String displayName,
  }) = _StorageAiReportDocumentSourceResponse;

  /// Odtwarza źródło z JSON.
  factory StorageAiReportDocumentSourceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageAiReportDocumentSourceResponseFromJson(json);
}

/// Ostrzeżenie dokumentu raportu AI.
@freezed
abstract class StorageAiReportDocumentWarningResponse
    with _$StorageAiReportDocumentWarningResponse {
  /// Zawiera stabilny kod i komunikat.
  const factory StorageAiReportDocumentWarningResponse({
    required String code,
    required String message,
  }) = _StorageAiReportDocumentWarningResponse;

  /// Odtwarza ostrzeżenie z JSON.
  factory StorageAiReportDocumentWarningResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageAiReportDocumentWarningResponseFromJson(json);
}

/// Dokument wynikowy raportu AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageAiReportDocumentResponse
    with _$StorageAiReportDocumentResponse {
  /// Zawiera sekcje, źródła i ostrzeżenia raportu.
  const factory StorageAiReportDocumentResponse({
    required String reportType,
    required String contractVersion,
    required String operationId,
    required String promptVersion,
    required int schemaVersion,
    required DateTime generatedAtUtc,
    required List<StorageAiReportDocumentSectionResponse> sections,
    required List<StorageAiReportDocumentSourceResponse> sources,
    required List<StorageAiReportDocumentWarningResponse> warnings,
    required AiProviderKind provider,
    String? model,
    Map<String, dynamic>? structuredData,
  }) = _StorageAiReportDocumentResponse;

  /// Odtwarza dokument z JSON.
  factory StorageAiReportDocumentResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageAiReportDocumentResponseFromJson(json);
}

/// Asynchroniczny raport AI projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageAiReportResponse with _$StorageAiReportResponse {
  /// Zawiera stan joba, wynik i źródła raportu.
  const factory StorageAiReportResponse({
    required String reportId,
    required StorageAiReportScopeType scopeType,
    required String workspaceId,
    required String projectId,
    required String reportType,
    required String contractVersion,
    required String promptVersion,
    required StorageAiReportJobStatus status,
    required int attemptCount,
    required int maxAttempts,
    required bool retryable,
    AiProviderKind? provider,
    String? outputFileId,
    String? resultDocumentJson,
    StorageAiReportDocumentResponse? resultDocument,
    required List<StorageAiReportSourceResponse> sources,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required DateTime deadlineAtUtc,
    DateTime? nextAttemptAtUtc,
    DateTime? completedAtUtc,
    String? lastError,
    StorageAiReportFailureCode? failureCode,
    String? operationId,
    String? jobId,
    int? schemaVersion,
    String? scopeId,
    String? operationStatus,
    AiOperationStatus? operationLifecycleStatus,
    StorageAiReportErrorResponse? error,
    int? retryAfterSeconds,
  }) = _StorageAiReportResponse;

  /// Odtwarza raport z JSON.
  factory StorageAiReportResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageAiReportResponseFromJson(json);
}

/// Ujednolicony błąd raportu AI.
@freezed
abstract class StorageAiReportErrorResponse
    with _$StorageAiReportErrorResponse {
  /// Zawiera kod, komunikat i informację o retry.
  const factory StorageAiReportErrorResponse({
    required String code,
    required String message,
    required bool retryable,
    int? retryAfterSeconds,
  }) = _StorageAiReportErrorResponse;

  /// Odtwarza błąd z JSON.
  factory StorageAiReportErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageAiReportErrorResponseFromJson(json);
}
