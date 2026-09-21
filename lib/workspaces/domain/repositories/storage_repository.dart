import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/storage/payloads/storage_payloads.dart';
import 'package:devplanner/workspaces/data/storage/responses/storage_responses.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';

/// Kontrakt repozytorium plików i folderów dla modułu Workspaces.
///
/// Warstwa prezentacji komunikuje się z backendem wyłącznie przez ten interfejs.
abstract interface class StorageRepository {
  /// Pobiera kursorową listę plików w zadanym zakresie.
  Future<Either<ApiError, CursorPageResponse<StorageFileResponse>>> listFiles({
    required StorageScope scope,
    String? folderId,
    String? cursor,
    int? limit,
    String? query,
    StorageBrowserFilter? filter,
  });

  /// Pobiera foldery dostępne w zadanym zakresie.
  Future<Either<ApiError, List<StorageFolderResponse>>> listFolders({
    required StorageScope scope,
    String? parentFolderId,
  });

  /// Pobiera szczegóły pojedynczego folderu wraz z podfolderami i plikami.
  Future<Either<ApiError, StorageFolderResponse>> getFolder(String folderId);

  /// Tworzy nowy wirtualny folder w podanym zakresie.
  Future<Either<ApiError, StorageFolderResponse>> createFolder({
    required StorageScope scope,
    required String name,
    String? parentFolderId,
  });

  /// Aktualizuje nazwę folderu lub jego folder nadrzędny.
  Future<Either<ApiError, StorageFolderResponse>> updateFolder({
    required String folderId,
    String? name,
    String? parentFolderId,
  });

  /// Przenosi folder do innego folderu nadrzędnego.
  Future<Either<ApiError, StorageFolderResponse>> moveFolder({
    required String folderId,
    required String? newParentFolderId,
  });

  /// Usuwa pusty folder.
  Future<Either<ApiError, Unit>> deleteFolder(String folderId);

  /// Pobiera szczegóły pliku, metadane, wersje i uprawnienia.
  Future<Either<ApiError, StorageFileDetailsResponse>> getFileDetails(
    String fileId,
  );

  /// Wydaje bilet pobrania pliku.
  Future<Either<ApiError, StorageDownloadTicketResponse>> getDownloadTicket(
    String fileId,
  );

  /// Exchanges a public share token and optional password for a download ticket.
  Future<Either<ApiError, StorageDownloadTicketResponse>>
  getPublicShareDownloadTicket({
    required String shareToken,
    String? password,
  });

  /// Rezerwuje bilet uploadu pojedynczego pliku.
  Future<Either<ApiError, StorageUploadTicketResponse>> requestUploadTicket(
    StorageUploadTicketPayload payload,
  );

  /// Tworzy pusty dokument w prywatnym, workspace albo projektowym zakresie.
  Future<Either<ApiError, StorageFileResponse>> createStorageDocument({
    required StorageScope scope,
    required String name,
    required StorageDocumentFormat format,

    /// Stabilny klucz jednej próby operacji; nową wartość generuje wyłącznie
    /// właściciel nowej akcji, nigdy warstwa transportowa przy retry.
    required String idempotencyKey,
  });

  /// Rezerwuje zbiorcze bilety uploadu wielu plików.
  Future<Either<ApiError, BulkStorageUploadTicketResponse>>
  requestBulkUploadTickets(
    BulkStorageUploadTicketPayload payload,
  );

  /// Zatwierdza plik po zakończeniu binarnym uploadu do S3/MinIO.
  Future<Either<ApiError, StorageFileResponse>> completeUpload({
    required String fileId,
    required int fileSizeBytes,
  });

  /// Zbiorczo zatwierdza przesłane pliki.
  Future<Either<ApiError, BulkCompleteUploadResponse>> completeBulkUpload(
    BulkCompleteUploadPayload payload,
  );

  /// Przełącza lub ustawia stan ulubionego dla pliku.
  Future<Either<ApiError, StorageFileUserStateResponse>> setFileFavorite({
    required String fileId,
    required bool isFavorite,
  });

  /// Usuwa plik do kosza (soft delete).
  Future<Either<ApiError, Unit>> deleteFile(String fileId);

  /// Przywraca plik z kosza.
  Future<Either<ApiError, StorageFileResponse>> restoreFile(String fileId);

  /// Aktualizuje opis pliku.
  Future<Either<ApiError, StorageFileResponse>> updateFileDescription({
    required String fileId,
    required String description,
  });

  /// Pobiera historię wersji pliku.
  Future<Either<ApiError, List<StorageFileVersionResponse>>> listFileVersions(
    String fileId,
  );

  /// Wydaje bilet pobrania konkretnej wersji pliku.
  Future<Either<ApiError, StorageFileVersionDownloadTicketResponse>>
  getFileVersionDownloadTicket({
    required String fileId,
    required int version,
  });

  /// Przywraca plik do wskazanej wersji historycznej.
  Future<Either<ApiError, StorageFileResponse>> restoreFileVersion({
    required String fileId,
    required int version,
    required int expectedVersion,
    String? changeSummary,
  });

  /// Pobiera token sesji OnlyOffice dla pliku.
  Future<Either<ApiError, OnlyOfficeSessionResponse>> getOfficeSession(
    String fileId,
  );

  /// Konwertuje dokument do PDF.
  Future<Either<ApiError, StorageFileResponse>> convertToPdf(String fileId);

  /// Umieszcza plik w wybranym folderze (placement).
  Future<Either<ApiError, StorageFilePlacementResponse>> createFilePlacement({
    required String fileId,
    required String folderId,
  });

  /// Pobiera placementy folderu, czyli referencje plików umieszczonych w nim.
  ///
  /// Lista plików nie niesie identyfikatora placementu, więc przeniesienie
  /// istniejącej referencji wymaga odczytania placementów folderu źródłowego.
  Future<Either<ApiError, List<StorageFilePlacementResponse>>>
  listFolderPlacements(String folderId);

  /// Przenosi istniejący placement do innego folderu w tym samym kontekście.
  ///
  /// [expectedVersion] pochodzi z pola `version` placementu; konflikt wersji
  /// zwraca `storage.placement_conflict`, a nie nadpisuje cudzej zmiany.
  Future<Either<ApiError, StorageFilePlacementResponse>> moveFilePlacement({
    required String placementId,
    required String targetFolderId,
    required int expectedVersion,
    String? idempotencyKey,
  });

  /// Usuwa powiązanie pliku z folderem (placement).
  Future<Either<ApiError, Unit>> deleteFilePlacement({
    required String fileId,
    required String placementId,
  });

  /// Pobiera listę aktywnych udostępnień pliku.
  Future<Either<ApiError, List<StorageFileShareResponse>>> listFileShares(
    String fileId,
  );

  /// Tworzy udostępnienie pliku.
  Future<Either<ApiError, StorageFileShareResponse>> createFileShare({
    required String fileId,
    required CreateStorageFileSharePayload payload,
  });

  /// Usuwa wskazane udostępnienie pliku.
  Future<Either<ApiError, Unit>> deleteFileShare({
    required String fileId,
    required String shareId,
  });

  /// Pobiera archiwum ZIP ze wskazanymi plikami.
  Future<Either<ApiError, List<int>>> bulkDownloadZip(
    BulkDownloadZipPayload payload,
  );

  /// Pobiera avatar aktualnego użytkownika.
  Future<Either<ApiError, StorageFileResponse>> getCurrentUserAvatar();

  /// Rezerwuje bezpieczny upload avatara użytkownika.
  Future<Either<ApiError, StorageUploadTicketResponse>>
  requestAvatarUploadTicket(
    StorageUploadTicketItemPayload payload,
  );

  /// Ustawia zatwierdzony plik jako avatar użytkownika.
  Future<Either<ApiError, StorageFileResponse>> setCurrentUserAvatar(
    String fileId,
  );

  /// Usuwa avatar aktualnego użytkownika.
  Future<Either<ApiError, Unit>> deleteCurrentUserAvatar();
}
