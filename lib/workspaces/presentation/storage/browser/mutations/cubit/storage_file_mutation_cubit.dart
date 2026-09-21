import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit realizujący mutacje pojedynczych i wielu plików (favorite, rename, delete, restore, ZIP).
final class StorageFileMutationCubit extends Cubit<StorageFileMutationState> {
  /// Tworzy cubit mutacji plików.
  StorageFileMutationCubit({
    required this.repository,
    required this.downloadTransport,
  }) : super(const StorageFileMutationInitial());

  final StorageRepository repository;
  final DownloadTransport downloadTransport;

  /// Ostatnia intencja przeniesienia: ponowienie używa tego samego klucza
  /// idempotencji, więc nie tworzy drugiego placementu po niepewnej odpowiedzi.
  _PendingPlacementMove? _pendingMove;

  /// Przełącza stan ulubionego pliku.
  Future<void> toggleFavorite(StorageFileResponse file) async {
    emit(const StorageFileMutationLoading());
    final newFavorite = !file.isFavorite;
    final result = await repository.setFileFavorite(
      fileId: file.id,
      isFavorite: newFavorite,
    );
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFileMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
          apiCode: err.apiCode,
          traceId: err.traceId,
        ),
      ),
      (_) {
        final updatedFile = file.copyWith(isFavorite: newFavorite);
        emit(
          StorageFileMutationSuccess(
            type: StorageFileMutationType.favoriteToggled,
            file: updatedFile,
            fileId: file.id,
          ),
        );
      },
    );
  }

  /// Aktualizuje opis pliku.
  Future<void> updateDescription({
    required String fileId,
    required String description,
  }) async {
    emit(const StorageFileMutationLoading());
    final result = await repository.updateFileDescription(
      fileId: fileId,
      description: description.trim(),
    );
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFileMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
          apiCode: err.apiCode,
          traceId: err.traceId,
        ),
      ),
      (updatedFile) => emit(
        StorageFileMutationSuccess(
          type: StorageFileMutationType.descriptionUpdated,
          file: updatedFile,
          fileId: fileId,
        ),
      ),
    );
  }

  /// Usuwa pojedynczy plik do kosza.
  Future<void> deleteFile(String fileId) async {
    emit(const StorageFileMutationLoading());
    final result = await repository.deleteFile(fileId);
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFileMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
          apiCode: err.apiCode,
          traceId: err.traceId,
        ),
      ),
      (_) => emit(
        StorageFileMutationSuccess(
          type: StorageFileMutationType.deleted,
          fileId: fileId,
        ),
      ),
    );
  }

  /// Przywraca plik z kosza.
  Future<void> restoreFile(String fileId) async {
    emit(const StorageFileMutationLoading());
    final result = await repository.restoreFile(fileId);
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFileMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
          apiCode: err.apiCode,
          traceId: err.traceId,
        ),
      ),
      (restoredFile) => emit(
        StorageFileMutationSuccess(
          type: StorageFileMutationType.restored,
          file: restoredFile,
          fileId: fileId,
        ),
      ),
    );
  }

  /// Usuwa masowo pliki i foldery z raportowaniem wyniku częściowego.
  Future<void> bulkDelete({
    required List<String> fileIds,
    List<String> folderIds = const [],
  }) async {
    emit(const StorageFileMutationLoading());

    final succeeded = <String>[];
    final failed = <String>[];
    String? lastError;

    for (final folderId in folderIds) {
      final res = await repository.deleteFolder(folderId);
      if (isClosed) return;
      res.fold(
        (err) {
          failed.add(folderId);
          lastError = err.message;
        },
        (_) => succeeded.add(folderId),
      );
    }

    for (final fileId in fileIds) {
      final res = await repository.deleteFile(fileId);
      if (isClosed) return;
      res.fold(
        (err) {
          failed.add(fileId);
          lastError = err.message;
        },
        (_) => succeeded.add(fileId),
      );
    }

    if (failed.isEmpty) {
      emit(
        StorageFileMutationSuccess(
          type: StorageFileMutationType.bulkDeleted,
          affectedCount: succeeded.length,
        ),
      );
    } else if (succeeded.isNotEmpty) {
      emit(
        StorageFileMutationPartialSuccess(
          succeededIds: succeeded,
          failedIds: failed,
          errorMessage: lastError ?? '',
          messageCode: lastError == null
              ? StorageFileMutationMessage.partialDelete
              : null,
        ),
      );
    } else {
      emit(
        StorageFileMutationFailure(
          message: lastError ?? '',
          messageCode: lastError == null
              ? StorageFileMutationMessage.deleteFailed
              : null,
        ),
      );
    }
  }

  /// Pobiera wybrane pliki spakowane w archiwum ZIP.
  Future<void> downloadZip({
    required List<String> fileIds,
    String zipName = 'pliki.zip',
  }) async {
    emit(const StorageFileMutationLoading());

    final zipResult = await repository.bulkDownloadZip(
      BulkDownloadZipPayload(fileIds: fileIds),
    );
    if (isClosed) return;

    if (zipResult.isLeft()) {
      zipResult.leftMap(
        (err) => emit(
          StorageFileMutationFailure(
            message: err.message,
            statusCode: err.statusCode,
          ),
        ),
      );
      return;
    }

    final bytes = zipResult.getOrElse(() => []);
    final saveResult = await downloadTransport.saveBytes(
      bytes: bytes,
      fileName: zipName,
    );
    if (isClosed) return;

    saveResult.fold(
      (err) => emit(
        StorageFileMutationFailure(message: err.message),
      ),
      (_) => emit(
        StorageFileMutationSuccess(
          type: StorageFileMutationType.zipDownloaded,
          affectedCount: fileIds.length,
        ),
      ),
    );
  }

  /// Pobiera pojedynczy plik przy użyciu biletu downloadUrl.
  Future<void> downloadFile(StorageFileResponse file) async {
    emit(const StorageFileMutationLoading());

    final ticketResult = await repository.getDownloadTicket(file.id);
    if (isClosed) return;

    final ticket = ticketResult.fold(
      (err) {
        emit(
          StorageFileMutationFailure(
            message: err.message,
            statusCode: err.statusCode,
          ),
        );
        return null;
      },
      (t) => t,
    );
    if (ticket == null || isClosed) return;

    final downloadResult = await downloadTransport.downloadUrl(
      downloadUrl: ticket.downloadUrl,
      fileName: file.originalFileName,
    );
    if (isClosed) return;

    downloadResult.fold(
      (err) => emit(
        StorageFileMutationFailure(message: err.message),
      ),
      (_) => emit(
        StorageFileMutationSuccess(
          type: StorageFileMutationType.fileDownloaded,
          file: file,
          fileId: file.id,
        ),
      ),
    );
  }

  /// Przenosi plik do folderu docelowego w tym samym zakresie.
  ///
  /// Plik widoczny wewnątrz folderu jest tam placementem, więc przeniesienie
  /// jest operacją na tym placementcie z jego wersją. Plik widoczny na poziomie
  /// zakresu nie ma jeszcze placementu, więc trafia do folderu jako nowa
  /// referencja — to inna operacja i inny typ wyniku.
  Future<void> moveFileToFolder({
    required String fileId,
    required String targetFolderId,
    String? sourceFolderId,
  }) async {
    final pending = _pendingMove;
    if (pending == null ||
        pending.fileId != fileId ||
        pending.targetFolderId != targetFolderId ||
        pending.sourceFolderId != sourceFolderId) {
      _pendingMove = _PendingPlacementMove(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
        idempotencyKey: _newMoveIdempotencyKey(),
      );
    }
    await _executePlacementMove(_pendingMove!);
  }

  /// Ponawia ostatnie przeniesienie z tym samym kluczem idempotencji.
  Future<void> retryPlacementMove() async {
    final pending = _pendingMove;
    if (pending != null) await _executePlacementMove(pending);
  }

  /// Przenosi wiele plików i raportuje wynik dla każdego elementu.
  ///
  /// Kontrakt przenosi jeden placement na żądanie, więc wynik częściowy jest
  /// jawny: udane elementy zostają przeniesione, a nieudane są nazwane.
  Future<void> moveFilesToFolder({
    required List<String> fileIds,
    required String targetFolderId,
    String? sourceFolderId,
  }) async {
    if (fileIds.isEmpty) return;
    emit(const StorageFileMutationLoading());

    final succeeded = <String>[];
    final failed = <String>[];
    String? lastError;
    String? lastApiCode;

    for (final fileId in fileIds) {
      final outcome = await _moveOnce(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
      );
      if (isClosed) return;
      if (outcome.isSuccess) {
        succeeded.add(fileId);
      } else {
        failed.add(fileId);
        lastError = outcome.message;
        lastApiCode = outcome.apiCode;
      }
    }

    if (failed.isEmpty) {
      emit(
        StorageFileMutationSuccess(
          type: sourceFolderId == null
              ? StorageFileMutationType.placementCreated
              : StorageFileMutationType.moved,
          affectedCount: succeeded.length,
        ),
      );
    } else if (succeeded.isNotEmpty) {
      emit(
        StorageFileMutationPartialSuccess(
          succeededIds: succeeded,
          failedIds: failed,
          errorMessage: lastError ?? '',
          messageCode: StorageFileMutationMessage.partialMove,
        ),
      );
    } else {
      emit(
        StorageFileMutationFailure(
          message: lastError ?? '',
          apiCode: lastApiCode,
          messageCode: lastApiCode == _placementConflictCode
              ? StorageFileMutationMessage.placementConflict
              : StorageFileMutationMessage.partialMove,
        ),
      );
    }
  }

  Future<void> _executePlacementMove(_PendingPlacementMove pending) async {
    emit(const StorageFileMutationLoading());
    final outcome = await _moveOnce(
      fileId: pending.fileId,
      targetFolderId: pending.targetFolderId,
      sourceFolderId: pending.sourceFolderId,
      idempotencyKey: pending.idempotencyKey,
    );
    if (isClosed) return;

    if (outcome.isSuccess) {
      _pendingMove = null;
      emit(
        StorageFileMutationSuccess(
          type: outcome.type,
          fileId: pending.fileId,
        ),
      );
      return;
    }

    emit(
      StorageFileMutationFailure(
        message: outcome.message,
        statusCode: outcome.statusCode,
        backendCode: outcome.backendCode,
        apiCode: outcome.apiCode,
        traceId: outcome.traceId,
        messageCode: outcome.apiCode == _placementConflictCode
            ? StorageFileMutationMessage.placementConflict
            : null,
      ),
    );
  }

  /// Wykonuje pojedyncze przeniesienie i zwraca jego wynik bez emisji stanu.
  Future<_PlacementMoveOutcome> _moveOnce({
    required String fileId,
    required String targetFolderId,
    required String? sourceFolderId,
    String? idempotencyKey,
  }) async {
    final placed = await _resolvePlacement(fileId, sourceFolderId);
    if (placed case Left(value: final error)) {
      // Odczyt placementów nie powiódł się, więc nie wiemy, czy plik już jest
      // referencją w tym folderze. Tworzenie nowej referencji w ciemno
      // dołożyłoby duplikat, dlatego przerywamy z błędem odczytu.
      return _PlacementMoveOutcome.failure(
        message: error.message,
        statusCode: error.statusCode,
        backendCode: error.backendCode,
        apiCode: error.apiCode,
        traceId: error.traceId,
      );
    }

    final existing = placed.getOrElse(
      () => const <StorageFilePlacementResponse>[],
    );
    if (existing.isEmpty) {
      final created = await repository.createFilePlacement(
        fileId: fileId,
        folderId: targetFolderId,
      );
      return created.fold(
        (error) => _PlacementMoveOutcome.failure(
          message: error.message,
          statusCode: error.statusCode,
          backendCode: error.backendCode,
          apiCode: error.apiCode,
          traceId: error.traceId,
        ),
        (_) => const _PlacementMoveOutcome.success(
          StorageFileMutationType.placementCreated,
        ),
      );
    }

    final target = existing.first;
    final version = target.version;
    if (version == null) {
      return const _PlacementMoveOutcome.failure(
        message: 'Nie można potwierdzić wersji powiązania pliku. Odśwież folder i spróbuj ponownie.',
        apiCode: _placementConflictCode,
      );
    }

    final moved = await repository.moveFilePlacement(
      placementId: target.id,
      targetFolderId: targetFolderId,
      expectedVersion: version,
      idempotencyKey: idempotencyKey ?? _newMoveIdempotencyKey(),
    );
    return moved.fold(
      (error) => _PlacementMoveOutcome.failure(
        message: error.message,
        statusCode: error.statusCode,
        backendCode: error.backendCode,
        apiCode: error.apiCode,
        traceId: error.traceId,
      ),
      (_) => const _PlacementMoveOutcome.success(
        StorageFileMutationType.moved,
      ),
    );
  }

  /// Zwraca placementy pliku w folderze źródłowym.
  Future<Either<ApiError, List<StorageFilePlacementResponse>>>
  _resolvePlacement(
    String fileId,
    String? sourceFolderId,
  ) async {
    if (sourceFolderId == null) {
      return const Right<ApiError, List<StorageFilePlacementResponse>>(
        <StorageFilePlacementResponse>[],
      );
    }
    final placements = await repository.listFolderPlacements(sourceFolderId);
    return placements.map(
      (list) => list.where((item) => item.fileId == fileId).toList(),
    );
  }

  String _newMoveIdempotencyKey() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return 'storage-move-${base64UrlEncode(bytes)}';
  }

  /// Resetuje stan mutacji po wyświetleniu toasta/sukcesu.
  void reset() {
    emit(const StorageFileMutationInitial());
  }
}

/// Stabilny kod konfliktu przeniesienia publikowany przez kontrakt.
const String _placementConflictCode = 'storage.placement_conflict';

/// Wynik pojedynczego przeniesienia bez emisji stanu Cubita.
final class _PlacementMoveOutcome {
  const _PlacementMoveOutcome.success(this.type)
    : isSuccess = true,
      message = '',
      statusCode = null,
      backendCode = null,
      apiCode = null,
      traceId = null;

  const _PlacementMoveOutcome.failure({
    required this.message,
    this.statusCode,
    this.backendCode,
    this.apiCode,
    this.traceId,
  }) : isSuccess = false,
       type = StorageFileMutationType.moved;

  final bool isSuccess;
  final StorageFileMutationType type;
  final String message;
  final int? statusCode;
  final int? backendCode;
  final String? apiCode;
  final String? traceId;
}

/// Intencja przeniesienia wraz z kluczem idempotencji.
final class _PendingPlacementMove {
  const _PendingPlacementMove({
    required this.fileId,
    required this.targetFolderId,
    required this.sourceFolderId,
    required this.idempotencyKey,
  });

  final String fileId;
  final String targetFolderId;
  final String? sourceFolderId;
  final String idempotencyKey;
}
