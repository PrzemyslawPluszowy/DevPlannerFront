import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/ai/models/storage_ai_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_contract_models.freezed.dart';
part 'storage_contract_models.g.dart';

/// Pojedynczy plik w żądaniu zbiorczego uploadu.
@freezed
abstract class StorageUploadTicketItemPayload
    with _$StorageUploadTicketItemPayload {
  /// Tworzy opis pliku do wygenerowania biletu.
  const factory StorageUploadTicketItemPayload({
    required String fileName,
    required int fileSizeBytes,
    String? mimeType,
    String? contentSha256,
  }) = _StorageUploadTicketItemPayload;

  /// Odtwarza payload z JSON.
  factory StorageUploadTicketItemPayload.fromJson(Map<String, dynamic> json) =>
      _$StorageUploadTicketItemPayloadFromJson(json);
}

/// Payload masowego uploadu załączników zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkTaskUploadTicketPayload with _$BulkTaskUploadTicketPayload {
  /// Tworzy listę plików do wygenerowania biletów.
  const factory BulkTaskUploadTicketPayload({
    required List<StorageUploadTicketItemPayload> files,
  }) = _BulkTaskUploadTicketPayload;

  /// Odtwarza payload z JSON.
  factory BulkTaskUploadTicketPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkTaskUploadTicketPayloadFromJson(json);
}

/// Bilet uploadu pojedynczego pliku.
@freezed
abstract class StorageUploadTicketResponse with _$StorageUploadTicketResponse {
  /// Tworzy odpowiedź z presigned URL.
  const factory StorageUploadTicketResponse({
    required String fileId,
    required String storageObjectKey,
    required String uploadUrl,
    required DateTime expiresAtUtc,
    required bool isAlreadyUploaded,
  }) = _StorageUploadTicketResponse;

  /// Odtwarza bilet z JSON.
  factory StorageUploadTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageUploadTicketResponseFromJson(json);
}

/// Zbiorcza odpowiedź biletów uploadu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkStorageUploadTicketResponse
    with _$BulkStorageUploadTicketResponse {
  /// Tworzy listę wygenerowanych biletów.
  const factory BulkStorageUploadTicketResponse({
    required List<StorageUploadTicketResponse> tickets,
  }) = _BulkStorageUploadTicketResponse;

  /// Odtwarza odpowiedź z JSON.
  factory BulkStorageUploadTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkStorageUploadTicketResponseFromJson(json);
}

/// Pojedyncza pozycja masowego zatwierdzenia uploadu.
@freezed
abstract class BulkCompleteFileItemPayload with _$BulkCompleteFileItemPayload {
  /// Tworzy dane weryfikacji pliku.
  const factory BulkCompleteFileItemPayload({
    required String fileId,
    required int fileSizeBytes,
    String? contentSha256,
    String? changeSummary,
  }) = _BulkCompleteFileItemPayload;

  /// Odtwarza payload z JSON.
  factory BulkCompleteFileItemPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkCompleteFileItemPayloadFromJson(json);
}

/// Payload masowego zatwierdzenia uploadów.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkCompleteUploadPayload with _$BulkCompleteUploadPayload {
  /// Tworzy listę plików do zatwierdzenia.
  const factory BulkCompleteUploadPayload({
    required List<BulkCompleteFileItemPayload> files,
  }) = _BulkCompleteUploadPayload;

  /// Odtwarza payload z JSON.
  factory BulkCompleteUploadPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkCompleteUploadPayloadFromJson(json);
}

/// Bezpieczna odpowiedź pliku Storage.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class StorageFileResponse with _$StorageFileResponse {
  /// Tworzy pełny kontrakt pliku.
  const factory StorageFileResponse({
    required String id,
    required StorageModule module,
    required StorageResourceType resourceType,
    String? resourceId,
    required String originalFileName,
    required String extension,
    required String mimeType,
    required int fileSizeBytes,
    String? contentSha256,
    required int version,
    String? workspaceId,
    String? projectId,
    required String ownerUserId,
    required String createdByUserId,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required bool isDeleted,
    required StorageProcessingStatus processingStatus,
    required StorageScanStatus scanStatus,
    required StorageAiStatus aiStatus,
    String? aiDescription,
    List<String>? aiTags,
    String? aiSummary,
    String? aiOcrText,
    int? mediaDurationSeconds,
    int? mediaWidth,
    int? mediaHeight,
    @Default(StorageEffectiveAccessLevel.none)
    StorageEffectiveAccessLevel accessLevel,
    @Default(false) bool canRead,
    @Default(false) bool canComment,
    @Default(false) bool canEdit,
    @Default(false) bool canShare,
    @Default(false) bool canDelete,
    @Default(false) bool isFavorite,
    DateTime? favoritedAtUtc,
    DateTime? lastAccessedAtUtc,
    String? manualDescription,
    String? manualDescriptionUpdatedByUserId,
    DateTime? manualDescriptionUpdatedAtUtc,
    String? concurrencyToken,
    String? aiLanguage,
    List<AiDetectedEntity>? aiEntities,
    @Default(false) bool canPreview,
    @Default(false) bool canEditOnline,
    @Default(false) bool canDownload,
    @Default(false) bool canManageVersions,
    @Default(false) bool canRestore,
    @Default(false) bool canConvertToPdf,
  }) = _StorageFileResponse;

  /// Odtwarza plik z JSON.
  factory StorageFileResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFileResponseFromJson(json);
}

/// Wynik zatwierdzenia jednego pliku.
@freezed
abstract class BulkCompleteFileItemResult with _$BulkCompleteFileItemResult {
  /// Tworzy wynik weryfikacji pliku.
  const factory BulkCompleteFileItemResult({
    required String fileId,
    required bool success,
    StorageFileResponse? file,
    String? errorCode,
    String? errorMessage,
  }) = _BulkCompleteFileItemResult;

  /// Odtwarza wynik z JSON.
  factory BulkCompleteFileItemResult.fromJson(Map<String, dynamic> json) =>
      _$BulkCompleteFileItemResultFromJson(json);
}

/// Raport masowego zatwierdzania uploadu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkCompleteUploadResponse with _$BulkCompleteUploadResponse {
  /// Tworzy raport wyników per plik.
  const factory BulkCompleteUploadResponse({
    required List<BulkCompleteFileItemResult> results,
    required int totalCount,
    required int successCount,
    required int failedCount,
  }) = _BulkCompleteUploadResponse;

  /// Odtwarza raport z JSON.
  factory BulkCompleteUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkCompleteUploadResponseFromJson(json);
}
