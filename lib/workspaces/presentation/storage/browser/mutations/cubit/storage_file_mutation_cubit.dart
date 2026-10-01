import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_bulk_delete_commands.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_download_commands.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_placement_mutations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for single and bulk storage file mutations.
final class StorageFileMutationCubit extends Cubit<StorageFileMutationState> {
  StorageFileMutationCubit({
    required this.repository,
    required this.downloadTransport,
  }) : super(const StorageFileMutationInitial()) {
    _placementMutations = StorageFilePlacementMutations(
      repository: repository,
      isClosed: () => isClosed,
    );
    _downloadCommands = StorageFileDownloadCommands(
      repository: repository,
      downloadTransport: downloadTransport,
    );
  }

  final StorageRepository repository;
  final DownloadTransport downloadTransport;
  late final StorageFilePlacementMutations _placementMutations;
  late final StorageFileDownloadCommands _downloadCommands;
  int _generation = 0;
  bool _busy = false;

  /// Wspólna blokada UI odpowiadająca busy i najpóźniejszemu RetryAfter.
  bool get canMutate {
    if (isClosed || _busy) return false;
    final retryAfter = _retryAfterOf(state);
    return retryAfter == null || !retryAfter.isAfter(DateTime.now().toUtc());
  }

  Future<void> toggleFavorite(StorageFileResponse file) async {
    await _runMutation((_) async {
      final next = !file.isFavorite;
      final result = await repository.setFileFavorite(
        fileId: file.id,
        isFavorite: next,
      );
      return result.fold(
        StorageFileMutationFailure.fromApiError,
        (_) => StorageFileMutationSuccess(
          type: StorageFileMutationType.favoriteToggled,
          file: file.copyWith(isFavorite: next),
          fileId: file.id,
        ),
      );
    });
  }

  Future<void> dismissSharedFile(String fileId) async {
    await _runMutation((_) async {
      final result = await repository.dismissSharedFile(fileId);
      return result.fold(
        StorageFileMutationFailure.fromApiError,
        (_) => StorageFileMutationSuccess(
          type: StorageFileMutationType.sharedFileDismissed,
          fileId: fileId,
        ),
      );
    });
  }

  Future<void> updateDescription({
    required String fileId,
    required String description,
  }) async {
    await _runMutation((_) async {
      final result = await repository.updateFileDescription(
        fileId: fileId,
        description: description.trim(),
      );
      return result.fold(
        StorageFileMutationFailure.fromApiError,
        (updated) => StorageFileMutationSuccess(
          type: StorageFileMutationType.descriptionUpdated,
          file: updated,
          fileId: fileId,
        ),
      );
    });
  }

  Future<bool> renameFile({
    required StorageFileResponse file,
    required String fileName,
  }) async {
    final result = await _runMutation((_) async {
      final response = await repository.renameFile(
        fileId: file.id,
        fileName: fileName,
        expectedConcurrencyToken: file.concurrencyToken,
      );
      return response.fold(
        StorageFileMutationFailure.fromApiError,
        (renamed) => StorageFileMutationSuccess(
          type: StorageFileMutationType.renamed,
          file: renamed,
          fileId: file.id,
        ),
      );
    });
    return result is StorageFileMutationSuccess &&
        result.type == StorageFileMutationType.renamed;
  }

  Future<void> deleteFile(String fileId) async {
    await _runMutation((_) async {
      final result = await repository.deleteFile(fileId);
      return result.fold(
        StorageFileMutationFailure.fromApiError,
        (_) => StorageFileMutationSuccess(
          type: StorageFileMutationType.deleted,
          fileId: fileId,
        ),
      );
    });
  }

  Future<void> restoreFile(String fileId) async {
    await _runMutation((_) async {
      final result = await repository.restoreFile(fileId);
      return result.fold(
        StorageFileMutationFailure.fromApiError,
        (restored) => StorageFileMutationSuccess(
          type: StorageFileMutationType.restored,
          file: restored,
          fileId: fileId,
        ),
      );
    });
  }

  Future<void> bulkDelete({
    required List<String> fileIds,
    List<String> folderIds = const [],
  }) async {
    await _runMutation(
      (isCurrent) => StorageBulkDeleteCommands(repository).execute(
        fileIds: fileIds,
        folderIds: folderIds,
        isCurrent: isCurrent,
      ),
    );
  }

  Future<void> downloadZip({
    required List<String> fileIds,
    String zipName = 'pliki.zip',
  }) async {
    await _runMutation((isCurrent) async {
      final result = await _downloadCommands.downloadZip(
        fileIds: fileIds,
        zipName: zipName,
        isCurrent: isCurrent,
      );
      return result.fold(
        StorageFileMutationFailure.fromApiError,
        (_) => StorageFileMutationSuccess(
          type: StorageFileMutationType.zipDownloaded,
          affectedCount: fileIds.length,
        ),
      );
    });
  }

  Future<void> downloadFile(StorageFileResponse file) async {
    await downloadFileWithFeedback(file);
  }

  Future<ApiError?> downloadFileWithFeedback(StorageFileResponse file) async {
    if (isClosed) return _localError('storage.action_canceled');
    if (_busy) return _localError('storage.action_busy');
    final retryAfter = _retryAfterOf(state);
    if (retryAfter != null && retryAfter.isAfter(DateTime.now().toUtc())) {
      return _retryAfterErrorOf(state) ?? _localError('storage.action_busy');
    }
    final result = await _runMutation((isCurrent) async {
      final response = await _downloadCommands.downloadFile(
        file,
        isCurrent: isCurrent,
      );
      return response.fold(
        StorageFileMutationFailure.fromApiError,
        (_) => StorageFileMutationSuccess(
          type: StorageFileMutationType.fileDownloaded,
          file: file,
          fileId: file.id,
        ),
      );
    });
    if (result is StorageFileMutationFailure) return result.apiError;
    return result == null ? _localError('storage.action_canceled') : null;
  }

  Future<void> moveFileToFolder({
    required String fileId,
    required String targetFolderId,
    String? sourceFolderId,
  }) async {
    await _runMutation(
      (isCurrent) => _placementMutations.moveFile(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
        isCurrent: isCurrent,
      ),
    );
  }

  Future<void> retryPlacementMove() async {
    if (!_placementMutations.hasPendingMove) return;
    await _runMutation(
      (isCurrent) => _placementMutations.retry(
        isCurrent: isCurrent,
      ),
    );
  }

  Future<void> moveFilesToFolder({
    required List<String> fileIds,
    required String targetFolderId,
    String? sourceFolderId,
  }) async {
    if (fileIds.isEmpty) return;
    await _runMutation(
      (isCurrent) => _placementMutations.moveMany(
        fileIds: fileIds,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
        isCurrent: isCurrent,
      ),
    );
  }

  Future<StorageFileMutationState?> _runMutation(
    Future<StorageFileMutationState?> Function(bool Function() isCurrent)
    action,
  ) async {
    if (isClosed || _busy) return null;
    final retryAfter = _retryAfterOf(state);
    if (retryAfter != null && retryAfter.isAfter(DateTime.now().toUtc())) {
      return state;
    }
    final generation = ++_generation;
    final previousState = state;
    _busy = true;
    emit(const StorageFileMutationLoading());
    try {
      final result = await action(() => !isClosed && generation == _generation);
      if (isClosed || generation != _generation) return null;
      final nextState = result ?? previousState;
      emit(nextState);
      return nextState;
    } catch (_) {
      if (isClosed || generation != _generation) return null;
      final failure = StorageFileMutationFailure.fromApiError(
        _localError('storage.action_failed'),
      );
      emit(failure);
      return failure;
    } finally {
      if (!isClosed && generation == _generation) _busy = false;
    }
  }

  ApiError? _errorOf(StorageFileMutationState current) => switch (current) {
    StorageFileMutationFailure(:final apiError) => apiError,
    StorageFileMutationPartialSuccess(:final apiError) => apiError,
    _ => null,
  };

  DateTime? _retryAfterOf(StorageFileMutationState current) =>
      _retryAfterErrorOf(current)?.retryAfterUtc;

  ApiError? _retryAfterErrorOf(StorageFileMutationState current) {
    final errors = switch (current) {
      StorageFileMutationFailure(:final apiErrorsById) => apiErrorsById.values,
      StorageFileMutationPartialSuccess(:final apiErrorsById) =>
        apiErrorsById.values,
      _ => const <ApiError>[],
    };
    var latest = _errorOf(current);
    for (final error in errors) {
      final deadline = error.retryAfterUtc;
      final currentDeadline = latest?.retryAfterUtc;
      if (deadline != null &&
          (currentDeadline == null || deadline.isAfter(currentDeadline))) {
        latest = error;
      }
    }
    return latest;
  }

  ApiError _localError(String code) => ApiError(
    type: ApiErrorType.unknown,
    message: code,
    apiCode: code,
    contractCode: code,
  );

  void reset() {
    if (isClosed) return;
    _generation++;
    _busy = false;
    emit(const StorageFileMutationInitial());
  }

  @override
  Future<void> close() {
    _generation++;
    _busy = false;
    return super.close();
  }
}
