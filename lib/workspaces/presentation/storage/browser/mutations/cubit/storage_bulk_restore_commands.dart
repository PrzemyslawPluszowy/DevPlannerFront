import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:dio/dio.dart';

/// Przywraca wskazany zestaw, przerywając kolejne żądania po ograniczeniu API.
final class StorageBulkRestoreCommands {
  const StorageBulkRestoreCommands(this.repository);

  final StorageRepository repository;

  Future<StorageFileMutationState?> execute({
    required List<String> fileIds,
    required List<String> folderIds,
    required bool Function() isCurrent,
  }) async {
    final entries = [
      for (final id in folderIds) (id: id, isFolder: true),
      for (final id in fileIds) (id: id, isFolder: false),
    ];
    final succeeded = <String>[];
    final failed = <String>[];
    final notAttempted = <String>[];
    final errors = <String, ApiError>{};
    ApiError? lastError;
    for (var index = 0; index < entries.length; index++) {
      if (!isCurrent()) return null;
      final entry = entries[index];
      final error = await _restore(entry.id, isFolder: entry.isFolder);
      if (!isCurrent()) return null;
      if (error == null) {
        succeeded.add(entry.id);
        continue;
      }
      failed.add(entry.id);
      errors[entry.id] = error;
      lastError = error;
      if (_mustStop(error)) {
        notAttempted.addAll(entries.skip(index + 1).map((entry) => entry.id));
        break;
      }
    }
    if (failed.isEmpty) {
      return StorageFileMutationSuccess(
        type: StorageFileMutationType.bulkRestored,
        affectedCount: succeeded.length,
      );
    }
    if (succeeded.isNotEmpty) {
      return StorageFileMutationPartialSuccess(
        succeededIds: List.unmodifiable(succeeded),
        failedIds: List.unmodifiable(failed),
        notAttemptedIds: List.unmodifiable(notAttempted),
        errorMessage: lastError!.message,
        messageCode: StorageFileMutationMessage.partialRestore,
        apiError: lastError,
        apiErrorsById: Map.unmodifiable(errors),
      );
    }
    return StorageFileMutationFailure(
      message: lastError!.message,
      statusCode: lastError.statusCode,
      backendCode: lastError.backendCode,
      apiCode: lastError.apiCode,
      traceId: lastError.traceId,
      apiError: lastError,
      apiErrorsById: Map.unmodifiable(errors),
      notAttemptedIds: List.unmodifiable(notAttempted),
    );
  }

  Future<ApiError?> _restore(String id, {required bool isFolder}) async {
    try {
      final result = isFolder
          ? await repository.restoreFolder(folderId: id)
          : await repository.restoreFile(id);
      return result.fold<ApiError?>((error) => error, (_) => null);
    } on ApiError catch (error) {
      return error;
    } on DioException catch (error) {
      return ApiError.fromDioException(
        error,
        fallbackMessage: '',
      );
    } catch (_) {
      return const ApiError(
        type: ApiErrorType.unknown,
        message: '',
        apiCode: 'storage.action_failed',
        contractCode: 'storage.action_failed',
      );
    }
  }

  bool _mustStop(ApiError error) {
    final deadline = error.retryAfterUtc;
    return const {
          ApiErrorType.unknown,
          ApiErrorType.connection,
          ApiErrorType.connectionTimeout,
          ApiErrorType.sendTimeout,
          ApiErrorType.receiveTimeout,
          ApiErrorType.canceled,
        }.contains(error.type) ||
        error.statusCode == 429 ||
        (deadline != null && deadline.isAfter(DateTime.now().toUtc()));
  }
}
