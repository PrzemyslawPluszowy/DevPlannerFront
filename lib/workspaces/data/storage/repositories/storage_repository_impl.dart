import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/storage/payloads/storage_payloads.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_extended_operations.dart';
import 'package:devplanner/workspaces/data/storage/responses/storage_responses.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';

/// Implementacja repozytorium Storage komunikująca się z backendem przez [StorageApi].
final class StorageRepositoryImpl extends ApiRepository
    implements StorageRepository {
  /// Tworzy repozytorium Storage z wstrzykniętym klientem API.
  StorageRepositoryImpl(this._api)
    : _extended = StorageRepositoryExtendedOperations(_api);

  final StorageApi _api;
  final StorageRepositoryExtendedOperations _extended;

  @override
  Future<Either<ApiError, CursorPageResponse<StorageFileResponse>>> listFiles({
    required StorageScope scope,
    String? folderId,
    String? cursor,
    int? limit,
    String? query,
    StorageBrowserFilter? filter,
  }) {
    final effectiveFolderId = folderId ?? scope.folderId;
    final includeDeleted = scope.isTrash ? true : null;

    return guardApiCall(
      () => _api.listFiles(
        module: scope.module?.apiValue,
        resourceType: scope.resourceType?.apiValue,
        resourceId: scope.resourceId,
        cursor: cursor,
        limit: limit,
        view: scope.listView?.apiValue,
        includeDeleted: includeDeleted,
        query: query,
        mimeType: filter?.mimeType,
        extension: filter?.extension,
        aiTag: filter?.aiTag,
        aiStatus: filter?.aiStatus?.apiValue,
        createdFromUtc: filter?.createdFromUtc,
        createdToUtc: filter?.createdToUtc,
        minSizeBytes: filter?.minSizeBytes,
        maxSizeBytes: filter?.maxSizeBytes,
        ownerUserId: filter?.ownerUserId,
        workspaceId: scope.workspaceId,
        projectId: scope.projectId,
        folderId: effectiveFolderId,
      ),
      fallbackMessage: 'Nie udało się pobrać listy plików.',
      parsingMessage: 'Backend zwrócił nieprawidłową listę plików.',
    );
  }

  @override
  Future<Either<ApiError, List<StorageFolderResponse>>> listFolders({
    required StorageScope scope,
    String? parentFolderId,
  }) => guardApiCall(
    () async {
      final folders = await _api.listFolders(
        folderType: scope.folderType?.apiValue,
        workspaceId: scope.workspaceId,
        projectId: scope.projectId,
      );
      return folders
          .where((folder) => folder.parentFolderId == parentFolderId)
          .toList(growable: false);
    },
    fallbackMessage: 'Nie udało się pobrać listy folderów.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę folderów.',
  );

  @override
  Future<Either<ApiError, StorageFolderResponse>> getFolder(String folderId) =>
      guardApiCall(
        () => _api.getFolder(folderId),
        fallbackMessage: 'Nie udało się pobrać folderu.',
        parsingMessage: 'Backend zwrócił nieprawidłowe dane folderu.',
      );

  @override
  Future<Either<ApiError, StorageDownloadTicketResponse>>
  getPublicShareDownloadTicket({
    required String shareToken,
    String? password,
  }) => guardApiCall(
    () => _api.getPublicShareDownloadTicket(
      shareToken,
      PublicShareAccessPayload(password: password),
    ),
    fallbackMessage: 'Nie udało się otworzyć publicznego udostępnienia.',
    parsingMessage: 'Backend zwrócił nieprawidłowy bilet pobierania.',
  );

  @override
  Future<Either<ApiError, StorageFolderResponse>> createFolder({
    required StorageScope scope,
    required String name,
    String? parentFolderId,
  }) {
    final folderType = scope.folderType;
    if (folderType == null) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'W tym widoku nie można tworzyć folderów.',
          ),
        ),
      );
    }
    return guardApiCall(
      () => _api.createFolder(
        CreateStorageFolderPayload(
          name: name,
          folderType: folderType,
          parentFolderId: parentFolderId ?? scope.folderId,
          workspaceId: scope.workspaceId,
          projectId: scope.projectId,
        ),
      ),
      fallbackMessage: 'Nie udało się utworzyć folderu.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane utworzonego folderu.',
    );
  }

  @override
  Future<Either<ApiError, StorageFolderResponse>> updateFolder({
    required String folderId,
    String? name,
    String? parentFolderId,
  }) => guardApiCall(
    () => _api.updateFolder(
      folderId,
      UpdateStorageFolderPayload(
        name: name,
        parentFolderId: parentFolderId,
      ),
    ),
    fallbackMessage: 'Nie udało się zaktualizować folderu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane folderu.',
  );

  @override
  Future<Either<ApiError, StorageFolderResponse>> moveFolder({
    required String folderId,
    required String? newParentFolderId,
  }) => guardApiCall(
    () => _api.moveFolder(
      folderId,
      UpdateStorageFolderPayload(
        parentFolderId: newParentFolderId,
      ),
    ),
    fallbackMessage: 'Nie udało się przenieść folderu.',
    parsingMessage:
        'Backend zwrócił nieprawidłowe dane przeniesionego folderu.',
  );

  @override
  Future<Either<ApiError, Unit>> deleteFolder(String folderId) => guardApiCall(
    () async {
      await _api.deleteFolder(folderId);
      return unit;
    },
    fallbackMessage: 'Nie udało się usunąć folderu.',
    parsingMessage:
        'Backend zwrócił nieprawidłową odpowiedź usunięcia folderu.',
  );

  @override
  Future<Either<ApiError, StorageFileDetailsResponse>> getFileDetails(
    String fileId,
  ) => guardApiCall(
    () => _api.getFileDetails(fileId),
    fallbackMessage: 'Nie udało się pobrać szczegółów pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłowe szczegóły pliku.',
  );

  @override
  Future<Either<ApiError, StorageDownloadTicketResponse>> getDownloadTicket(
    String fileId,
  ) => guardApiCall(
    () => _api.getDownloadTicket(fileId),
    fallbackMessage: 'Nie udało się pobrać biletu pobrania.',
    parsingMessage: 'Backend zwrócił nieprawidłowy bilet pobrania.',
  );

  @override
  Future<Either<ApiError, StorageUploadTicketResponse>> requestUploadTicket(
    StorageUploadTicketPayload payload,
  ) => guardApiCall(
    () => _api.requestUploadTicket(payload),
    fallbackMessage: 'Nie udało się przygotować wysyłki pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłowy bilet wysyłki pliku.',
  );

  @override
  Future<Either<ApiError, StorageFileResponse>> createStorageDocument({
    required StorageScope scope,
    required String name,
    required StorageDocumentFormat format,
    required String idempotencyKey,
  }) {
    final resourceType = scope.uploadResourceType;
    final module = scope.module ?? StorageModule.workspaces;
    if (resourceType == null ||
        !(scope.isPersonal ||
            scope is StorageWorkspaceScope ||
            scope is StorageProjectScope)) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'W tym widoku nie można tworzyć dokumentów.',
          ),
        ),
      );
    }
    return guardApiCall(
      () => _api.createStorageDocument(
        CreateStorageDocumentPayload(
          name: name,
          format: format,
          module: module,
          resourceType: resourceType,
          projectId: scope.projectId,
          workspaceId: scope.workspaceId,
          folderId: scope.folderId,
        ),
        idempotencyKey,
      ),
      fallbackMessage: 'Nie udało się utworzyć dokumentu.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane dokumentu.',
    );
  }

  @override
  Future<Either<ApiError, BulkStorageUploadTicketResponse>>
  requestBulkUploadTickets(
    BulkStorageUploadTicketPayload payload,
  ) => guardApiCall(
    () => _api.requestBulkUploadTickets(payload),
    fallbackMessage: 'Nie udało się przygotować wysyłki plików.',
    parsingMessage: 'Backend zwrócił nieprawidłowe bilety wysyłki plików.',
  );

  @override
  Future<Either<ApiError, StorageFileResponse>> completeUpload({
    required String fileId,
    required int fileSizeBytes,
  }) => guardApiCall(
    () => _api.completeUpload(
      fileId,
      CompleteStorageUploadPayload(fileSizeBytes: fileSizeBytes),
    ),
    fallbackMessage: 'Nie udało się zatwierdzić przesłanego pliku.',
    parsingMessage:
        'Backend zwrócił nieprawidłowe potwierdzenie przesłanego pliku.',
  );

  @override
  Future<Either<ApiError, BulkCompleteUploadResponse>> completeBulkUpload(
    BulkCompleteUploadPayload payload,
  ) => guardApiCall(
    () => _api.completeBulkUpload(payload),
    fallbackMessage: 'Nie udało się zatwierdzić przesłanych plików.',
    parsingMessage:
        'Backend zwrócił nieprawidłowe potwierdzenie przesłanych plików.',
  );

  @override
  Future<Either<ApiError, StorageFileUserStateResponse>> setFileFavorite({
    required String fileId,
    required bool isFavorite,
  }) => guardApiCall(
    () => _api.setFileFavorite(
      fileId,
      SetStorageFileFavoritePayload(isFavorite: isFavorite),
    ),
    fallbackMessage: 'Nie udało się zmienić stanu ulubionego.',
    parsingMessage: 'Backend zwrócił nieprawidłowy stan ulubionego.',
  );

  @override
  Future<Either<ApiError, Unit>> deleteFile(String fileId) => guardApiCall(
    () async {
      await _api.deleteFile(fileId);
      return unit;
    },
    fallbackMessage: 'Nie udało się usunąć pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź usunięcia pliku.',
  );

  @override
  Future<Either<ApiError, StorageFileResponse>> restoreFile(String fileId) =>
      guardApiCall(
        () => _api.restoreFile(fileId),
        fallbackMessage: 'Nie udało się przywrócić pliku.',
        parsingMessage: 'Backend zwrócił nieprawidłowe dane pliku.',
      );

  @override
  Future<Either<ApiError, StorageFileResponse>> updateFileDescription({
    required String fileId,
    required String description,
  }) => guardApiCall(
    () => _api.updateFileDescription(
      fileId,
      UpdateStorageFileDescriptionPayload(manualDescription: description),
    ),
    fallbackMessage: 'Nie udało się zaktualizować opisu pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane pliku.',
  );

  @override
  Future<Either<ApiError, List<StorageFileVersionResponse>>> listFileVersions(
    String fileId,
  ) => guardApiCall(
    () => _api.listFileVersions(fileId),
    fallbackMessage: 'Nie udało się pobrać historii wersji pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę wersji.',
  );

  @override
  Future<Either<ApiError, StorageFileVersionDownloadTicketResponse>>
  getFileVersionDownloadTicket({
    required String fileId,
    required int version,
  }) => guardApiCall(
    () => _api.getFileVersionDownloadTicket(fileId, version),
    fallbackMessage: 'Nie udało się pobrać biletu wersji pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłowy bilet wersji.',
  );

  @override
  Future<Either<ApiError, StorageFileResponse>> restoreFileVersion({
    required String fileId,
    required int version,
    required int expectedVersion,
    String? changeSummary,
  }) => guardApiCall(
    () => _api.restoreFileVersion(
      fileId,
      version,
      RestoreStorageFileVersionPayload(
        expectedVersion: expectedVersion,
        changeSummary: changeSummary,
      ),
    ),
    fallbackMessage: 'Nie udało się przywrócić wersji pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane pliku.',
  );

  @override
  Future<Either<ApiError, OnlyOfficeSessionResponse>> getOfficeSession(
    String fileId,
  ) => _extended.getOfficeSession(fileId);

  @override
  Future<Either<ApiError, StorageFileResponse>> convertToPdf(String fileId) =>
      _extended.convertToPdf(fileId);

  @override
  Future<Either<ApiError, StorageFilePlacementResponse>> createFilePlacement({
    required String fileId,
    required String folderId,
  }) => _extended.createFilePlacement(fileId: fileId, folderId: folderId);

  @override
  Future<Either<ApiError, List<StorageFilePlacementResponse>>>
  listFolderPlacements(String folderId) =>
      _extended.listFolderPlacements(folderId);

  @override
  Future<Either<ApiError, StorageFilePlacementResponse>> moveFilePlacement({
    required String placementId,
    required String targetFolderId,
    required int expectedVersion,
    String? idempotencyKey,
  }) => _extended.moveFilePlacement(
    placementId: placementId,
    targetFolderId: targetFolderId,
    expectedVersion: expectedVersion,
    idempotencyKey: idempotencyKey,
  );

  @override
  Future<Either<ApiError, Unit>> deleteFilePlacement({
    required String fileId,
    required String placementId,
  }) => _extended.deleteFilePlacement(fileId: fileId, placementId: placementId);

  @override
  Future<Either<ApiError, List<StorageFileShareResponse>>> listFileShares(
    String fileId,
  ) => _extended.listFileShares(fileId);

  @override
  Future<Either<ApiError, StorageFileShareResponse>> createFileShare({
    required String fileId,
    required CreateStorageFileSharePayload payload,
  }) => _extended.createFileShare(fileId: fileId, payload: payload);

  @override
  Future<Either<ApiError, Unit>> deleteFileShare({
    required String fileId,
    required String shareId,
  }) => _extended.deleteFileShare(fileId: fileId, shareId: shareId);

  @override
  Future<Either<ApiError, List<int>>> bulkDownloadZip(
    BulkDownloadZipPayload payload,
  ) => _extended.bulkDownloadZip(payload);

  @override
  Future<Either<ApiError, StorageFileResponse>> getCurrentUserAvatar() =>
      _extended.getCurrentUserAvatar();

  @override
  Future<Either<ApiError, StorageUploadTicketResponse>>
  requestAvatarUploadTicket(
    StorageUploadTicketItemPayload payload,
  ) => _extended.requestAvatarUploadTicket(payload);

  @override
  Future<Either<ApiError, StorageFileResponse>> setCurrentUserAvatar(
    String fileId,
  ) => _extended.setCurrentUserAvatar(fileId);

  @override
  Future<Either<ApiError, Unit>> deleteCurrentUserAvatar() =>
      _extended.deleteCurrentUserAvatar();
}
