import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/storage/payloads/storage_payloads.dart';

/// Mniejsze operacje Storage delegowane przez główne repozytorium.
final class StorageRepositoryExtendedOperations extends ApiRepository {
  /// Tworzy grupę operacji opartą o ten sam klient API.
  StorageRepositoryExtendedOperations(this._api);

  final StorageApi _api;

  Future<Either<ApiError, OnlyOfficeSessionResponse>> getOfficeSession(
    String fileId,
  ) => guardApiCall(
    () => _api.getOfficeSession(fileId),
    fallbackMessage: 'Nie udało się utworzyć sesji edycji dokumentu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane sesji edytora.',
  );

  Future<Either<ApiError, StorageFileResponse>> convertToPdf(String fileId) =>
      guardApiCall(
        () => _api.convertToPdf(fileId),
        fallbackMessage: 'Nie udało się przekonwertować dokumentu do PDF.',
        parsingMessage: 'Backend zwrócił nieprawidłowe dane pliku PDF.',
      );

  Future<Either<ApiError, StorageFilePlacementResponse>> createFilePlacement({
    required String fileId,
    required String folderId,
  }) => guardApiCall(
    () => _api.createFilePlacement(
      fileId,
      CreateStorageFilePlacementPayload(folderId: folderId),
    ),
    fallbackMessage: 'Nie udało się dodać pliku do folderu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane powiązania pliku.',
  );

  Future<Either<ApiError, List<StorageFilePlacementResponse>>>
  listFolderPlacements(String folderId) => guardApiCall(
    () => _api.listFolderPlacements(folderId),
    fallbackMessage: 'Nie udało się pobrać zawartości folderu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę powiązań plików.',
  );

  /// Przenosi placement do folderu docelowego z kontrolą wersji.
  Future<Either<ApiError, StorageFilePlacementResponse>> moveFilePlacement({
    required String placementId,
    required String targetFolderId,
    required int expectedVersion,
    String? idempotencyKey,
  }) => guardApiCall(
    () => _api.moveFilePlacement(
      placementId,
      MoveStorageFilePlacementPayload(
        targetFolderId: targetFolderId,
        expectedVersion: expectedVersion,
      ),
      idempotencyKey: idempotencyKey,
    ),
    fallbackMessage: 'Nie udało się przenieść pliku do folderu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane przeniesienia pliku.',
  );

  Future<Either<ApiError, Unit>> deleteFilePlacement({
    required String fileId,
    required String placementId,
  }) => guardApiCall(
    () async {
      await _api.deleteFilePlacement(fileId, placementId);
      return unit;
    },
    fallbackMessage: 'Nie udało się usunąć pliku z folderu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź usunięcia.',
  );

  Future<Either<ApiError, List<StorageFileShareResponse>>> listFileShares(
    String fileId,
  ) => guardApiCall(
    () => _api.listFileShares(fileId),
    fallbackMessage: 'Nie udało się pobrać listy udostępnień pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę udostępnień.',
  );

  Future<Either<ApiError, StorageFileShareResponse>> createFileShare({
    required String fileId,
    required CreateStorageFileSharePayload payload,
  }) => guardApiCall(
    () => _api.createFileShare(fileId, payload),
    fallbackMessage: 'Nie udało się udostępnić pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłowe dane udostępnienia.',
  );

  Future<Either<ApiError, Unit>> deleteFileShare({
    required String fileId,
    required String shareId,
  }) => guardApiCall(
    () async {
      await _api.deleteFileShare(fileId, shareId);
      return unit;
    },
    fallbackMessage: 'Nie udało się cofnąć udostępnienia pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź cofnięcia.',
  );

  Future<Either<ApiError, List<int>>> bulkDownloadZip(
    BulkDownloadZipPayload payload,
  ) => guardApiCall(
    () async {
      final response = await _api.bulkDownloadZip(payload);
      return response.data;
    },
    fallbackMessage: 'Nie udało się pobrać archiwum ZIP.',
    parsingMessage: 'Backend zwrócił nieprawidłowe archiwum ZIP.',
  );

  Future<Either<ApiError, StorageFileResponse>> getCurrentUserAvatar() =>
      guardApiCall(
        () async => (await _api.getCurrentUserAvatar())!,
        fallbackMessage: 'Nie udało się pobrać avatara.',
        parsingMessage: 'Backend zwrócił nieprawidłowy avatar.',
      );

  Future<Either<ApiError, StorageUploadTicketResponse>>
  requestAvatarUploadTicket(
    StorageUploadTicketItemPayload payload,
  ) => guardApiCall(
    () => _api.requestAvatarUploadTicket(payload),
    fallbackMessage: 'Nie udało się przygotować wysyłki avatara.',
    parsingMessage: 'Backend zwrócił nieprawidłowy bilet wysyłki avatara.',
  );

  Future<Either<ApiError, StorageFileResponse>> setCurrentUserAvatar(
    String fileId,
  ) => guardApiCall(
    () => _api.setCurrentUserAvatar(SetUserAvatarPayload(fileId: fileId)),
    fallbackMessage: 'Nie udało się ustawić avatara.',
    parsingMessage: 'Backend zwrócił nieprawidłowy avatar.',
  );

  Future<Either<ApiError, Unit>> deleteCurrentUserAvatar() => guardApiCall(
    () async {
      await _api.deleteCurrentUserAvatar();
      return unit;
    },
    fallbackMessage: 'Nie udało się usunąć avatara.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź usuwania avatara.',
  );
}
