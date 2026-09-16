import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/storage/ports/download_transport.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';

/// Cubit realizujący mutacje pojedynczych i wielu plików (favorite, rename, delete, restore, ZIP).
final class StorageFileMutationCubit extends Cubit<StorageFileMutationState> {
  /// Tworzy cubit mutacji plików.
  StorageFileMutationCubit({
    required this.repository,
    required this.downloadTransport,
  }) : super(const StorageFileMutationInitial());

  final StorageRepository repository;
  final DownloadTransport downloadTransport;

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

  /// Resetuje stan mutacji po wyświetleniu toasta/sukcesu.
  void reset() {
    emit(const StorageFileMutationInitial());
  }
}
