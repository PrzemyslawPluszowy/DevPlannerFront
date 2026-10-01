import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:dio/dio.dart';

/// Owns placement lookup, idempotency, and per-item move outcomes.
final class StorageFilePlacementMutations {
  StorageFilePlacementMutations({
    required this.repository,
    required this.isClosed,
  });

  final StorageRepository repository;
  final bool Function() isClosed;
  _PendingPlacementMove? _pendingMove;

  bool get hasPendingMove => _pendingMove != null;

  Future<StorageFileMutationState?> moveFile({
    required String fileId,
    required String targetFolderId,
    String? sourceFolderId,
    required bool Function() isCurrent,
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
    return _execute(_pendingMove!, isCurrent);
  }

  Future<StorageFileMutationState?> retry({
    required bool Function() isCurrent,
  }) async {
    final pending = _pendingMove;
    return pending == null ? null : _execute(pending, isCurrent);
  }

  Future<StorageFileMutationState?> moveMany({
    required List<String> fileIds,
    required String targetFolderId,
    String? sourceFolderId,
    required bool Function() isCurrent,
  }) async {
    if (fileIds.isEmpty) return null;
    final succeeded = <String>[];
    final failed = <String>[];
    final notAttempted = <String>[];
    final errorsById = <String, ApiError>{};
    _PlacementMoveOutcome? lastFailure;

    for (var index = 0; index < fileIds.length; index++) {
      final fileId = fileIds[index];
      if (!isCurrent() || isClosed()) return null;
      final outcome = await _moveOnce(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
        isCurrent: isCurrent,
      );
      if (!isCurrent() || isClosed() || outcome == null) return null;
      if (outcome.isSuccess) {
        succeeded.add(fileId);
      } else {
        failed.add(fileId);
        final error = outcome.apiError;
        if (error != null) errorsById[fileId] = error;
        lastFailure = outcome;
        if (_mustStopBatch(error)) {
          notAttempted.addAll(fileIds.skip(index + 1));
          break;
        }
      }
    }

    if (failed.isEmpty) {
      return StorageFileMutationSuccess(
        type: sourceFolderId == null
            ? StorageFileMutationType.placementCreated
            : StorageFileMutationType.moved,
        affectedCount: succeeded.length,
      );
    }
    if (succeeded.isNotEmpty) {
      return StorageFileMutationPartialSuccess(
        succeededIds: succeeded,
        failedIds: failed,
        errorMessage: lastFailure?.message ?? '',
        messageCode: StorageFileMutationMessage.partialMove,
        apiError: lastFailure?.apiError,
        apiErrorsById: Map.unmodifiable(errorsById),
        notAttemptedIds: List.unmodifiable(notAttempted),
      );
    }
    final failure = lastFailure;
    return StorageFileMutationFailure(
      message: failure?.message ?? '',
      statusCode: failure?.statusCode,
      backendCode: failure?.backendCode,
      apiCode: failure?.apiCode,
      traceId: failure?.traceId,
      apiError: failure?.apiError,
      apiErrorsById: Map.unmodifiable(errorsById),
      notAttemptedIds: List.unmodifiable(notAttempted),
      messageCode: failure?.apiCode == _placementConflictCode
          ? StorageFileMutationMessage.placementConflict
          : StorageFileMutationMessage.partialMove,
    );
  }

  bool _mustStopBatch(ApiError? error) {
    if (error == null) return false;
    if (error.statusCode == 429) return true;
    if (const {
      ApiErrorType.unknown,
      ApiErrorType.connection,
      ApiErrorType.connectionTimeout,
      ApiErrorType.sendTimeout,
      ApiErrorType.receiveTimeout,
      ApiErrorType.canceled,
    }.contains(error.type)) {
      return true;
    }
    final retryAfter = error.retryAfterUtc;
    return retryAfter != null && retryAfter.isAfter(DateTime.now().toUtc());
  }

  Future<StorageFileMutationState?> _execute(
    _PendingPlacementMove pending,
    bool Function() isCurrent,
  ) async {
    final outcome = await _moveOnce(
      fileId: pending.fileId,
      targetFolderId: pending.targetFolderId,
      sourceFolderId: pending.sourceFolderId,
      idempotencyKey: pending.idempotencyKey,
      isCurrent: isCurrent,
    );
    if (!isCurrent() || isClosed() || outcome == null) return null;
    if (outcome.isSuccess) {
      _pendingMove = null;
      return StorageFileMutationSuccess(
        type: outcome.type,
        fileId: pending.fileId,
      );
    }

    return StorageFileMutationFailure(
      message: outcome.message,
      statusCode: outcome.statusCode,
      backendCode: outcome.backendCode,
      apiCode: outcome.apiCode,
      traceId: outcome.traceId,
      apiError: outcome.apiError,
      messageCode: outcome.apiCode == _placementConflictCode
          ? StorageFileMutationMessage.placementConflict
          : null,
    );
  }

  Future<_PlacementMoveOutcome?> _moveOnce({
    required String fileId,
    required String targetFolderId,
    required String? sourceFolderId,
    required bool Function() isCurrent,
    String? idempotencyKey,
  }) async {
    try {
      return await _moveUnchecked(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
        isCurrent: isCurrent,
        idempotencyKey: idempotencyKey,
      );
    } on ApiError catch (error) {
      return _PlacementMoveOutcome.failure(error);
    } on DioException catch (error) {
      return _PlacementMoveOutcome.failure(
        ApiError.fromDioException(
          error,
          fallbackMessage: 'Nie udało się przenieść pliku.',
        ),
      );
    } catch (_) {
      return _PlacementMoveOutcome.failure(
        const ApiError(
          type: ApiErrorType.unknown,
          message:
              'Nie udało się potwierdzić wyniku przenoszenia. Odśwież folder.',
          apiCode: 'storage.action_failed',
          contractCode: 'storage.action_failed',
        ),
      );
    }
  }

  Future<_PlacementMoveOutcome?> _moveUnchecked({
    required String fileId,
    required String targetFolderId,
    required String? sourceFolderId,
    required bool Function() isCurrent,
    String? idempotencyKey,
  }) async {
    final placed = await _resolvePlacement(fileId, sourceFolderId);
    if (!isCurrent() || isClosed()) return null;
    if (placed case Left(value: final error)) {
      return _PlacementMoveOutcome.failure(error);
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
        _PlacementMoveOutcome.failure,
        (_) => const _PlacementMoveOutcome.success(
          StorageFileMutationType.placementCreated,
        ),
      );
    }

    final target = existing.first;
    final version = target.version;
    if (version == null) {
      return const _PlacementMoveOutcome.failureMessage(
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
      _PlacementMoveOutcome.failure,
      (_) => const _PlacementMoveOutcome.success(StorageFileMutationType.moved),
    );
  }

  Future<Either<ApiError, List<StorageFilePlacementResponse>>>
  _resolvePlacement(String fileId, String? sourceFolderId) async {
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
}

const String _placementConflictCode = 'storage.placement_conflict';

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

final class _PlacementMoveOutcome {
  const _PlacementMoveOutcome.success(this.type)
    : isSuccess = true,
      message = '',
      statusCode = null,
      backendCode = null,
      apiCode = null,
      traceId = null,
      apiError = null;

  _PlacementMoveOutcome.failure(ApiError error)
    : isSuccess = false,
      type = StorageFileMutationType.moved,
      message = error.message,
      statusCode = error.statusCode,
      backendCode = error.backendCode,
      apiCode = error.apiCode,
      traceId = error.traceId,
      apiError = error;

  const _PlacementMoveOutcome.failureMessage({
    required this.message,
    this.apiCode,
  }) : isSuccess = false,
       type = StorageFileMutationType.moved,
       statusCode = null,
       backendCode = null,
       traceId = null,
       apiError = null;

  final bool isSuccess;
  final StorageFileMutationType type;
  final String message;
  final int? statusCode;
  final int? backendCode;
  final String? apiCode;
  final String? traceId;
  final ApiError? apiError;
}
