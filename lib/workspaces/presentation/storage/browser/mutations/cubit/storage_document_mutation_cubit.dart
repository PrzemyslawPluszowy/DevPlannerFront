import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit tworzący dokument z jawnie powiązanym wynikiem i bezpiecznym retry.
final class StorageDocumentMutationCubit
    extends Cubit<StorageDocumentMutationState> {
  /// Tworzy cubit z repozytorium Storage.
  StorageDocumentMutationCubit({required this._repository})
    : super(const StorageDocumentMutationInitial());

  final StorageRepository _repository;
  _PendingCreateDocument? _pending;
  int _nextOperationId = 0;
  int? _executingOperationId;
  DateTime? _retryAfterUtc;
  bool _isExecuting = false;

  /// Tworzy pusty dokument w zakresie przypisanym do tej intencji.
  Future<void> createDocument({
    required StorageScope scope,
    required String name,
    required StorageDocumentFormat format,
  }) async {
    if (isClosed || _isExecuting || _retryIsBlocked()) return;
    final cleanName = name.trim();
    final pending = _pending;
    if (pending == null ||
        pending.scope != scope ||
        pending.name != cleanName ||
        pending.format != format) {
      _pending = _PendingCreateDocument(
        scope: scope,
        name: cleanName,
        format: format,
        operationId: ++_nextOperationId,
        idempotencyKey: _newIdempotencyKey(),
      );
    }
    await _execute(_pending!);
  }

  /// Ponawia wyłącznie wskazaną operację z jej pierwotnym kluczem.
  Future<void> retry({required int operationId}) async {
    if (isClosed || _isExecuting || _retryIsBlocked()) return;
    final pending = _pending;
    final failure = state;
    if (pending == null ||
        pending.operationId != operationId ||
        failure is! StorageDocumentMutationFailure ||
        failure.operationId != operationId) {
      return;
    }
    await _execute(pending);
  }

  Future<void> _execute(_PendingCreateDocument pending) async {
    if (isClosed || _isExecuting) return;
    _isExecuting = true;
    _executingOperationId = pending.operationId;
    emit(
      StorageDocumentMutationLoading(
        scope: pending.scope,
        operationId: pending.operationId,
      ),
    );
    try {
      final result = await _createDocument(pending);
      if (!_owns(pending)) return;
      result.fold(
        (error) {
          _recordRetryAfter(error.retryAfterUtc);
          emit(
            StorageDocumentMutationFailure(
              error: error,
              scope: pending.scope,
              operationId: pending.operationId,
            ),
          );
        },
        (file) {
          _pending = null;
          emit(
            StorageDocumentMutationSuccess(
              file: file,
              scope: pending.scope,
              operationId: pending.operationId,
            ),
          );
        },
      );
    } finally {
      if (_executingOperationId == pending.operationId) {
        _executingOperationId = null;
        _isExecuting = false;
      }
    }
  }

  Future<Either<ApiError, StorageFileResponse>> _createDocument(
    _PendingCreateDocument pending,
  ) async {
    try {
      return await _repository.createStorageDocument(
        scope: pending.scope,
        name: pending.name,
        format: pending.format,
        idempotencyKey: pending.idempotencyKey,
      );
    } on ApiError catch (error) {
      return Left(error);
    } on DioException catch (error) {
      return Left(
        ApiError.fromDioException(
          error,
          fallbackMessage: 'Nie udało się utworzyć dokumentu.',
        ),
      );
    } on Object {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się utworzyć dokumentu.',
          apiCode: 'storage.document_create_failed',
        ),
      );
    }
  }

  bool _owns(_PendingCreateDocument pending) =>
      !isClosed && _pending?.operationId == pending.operationId;

  bool _retryIsBlocked() {
    final deadline = _retryAfterUtc;
    if (deadline == null) return false;
    if (DateTime.now().toUtc().isBefore(deadline.toUtc())) return true;
    _retryAfterUtc = null;
    return false;
  }

  void _recordRetryAfter(DateTime? candidate) {
    if (candidate == null || !candidate.isAfter(DateTime.now().toUtc())) return;
    final current = _retryAfterUtc;
    if (current == null || candidate.isAfter(current)) {
      _retryAfterUtc = candidate.toUtc();
    }
  }

  String _newIdempotencyKey() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return 'storage-document-${base64UrlEncode(bytes)}';
  }
}

final class _PendingCreateDocument {
  const _PendingCreateDocument({
    required this.scope,
    required this.name,
    required this.format,
    required this.operationId,
    required this.idempotencyKey,
  });

  final StorageScope scope;
  final String name;
  final StorageDocumentFormat format;
  final int operationId;
  final String idempotencyKey;
}
