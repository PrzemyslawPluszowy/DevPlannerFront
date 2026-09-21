import 'dart:convert';
import 'dart:math';

import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit tworzący nowy dokument w aktualnym zakresie eksploratora.
final class StorageDocumentMutationCubit
    extends Cubit<StorageDocumentMutationState> {
  /// Tworzy cubit z repozytorium Storage.
  StorageDocumentMutationCubit({required this._repository})
    : super(const StorageDocumentMutationInitial());

  final StorageRepository _repository;
  _PendingCreateDocument? _pending;

  /// Tworzy pusty dokument i zwraca jego metadane przez stan sukcesu.
  Future<void> createDocument({
    required StorageScope scope,
    required String name,
    required StorageDocumentFormat format,
  }) async {
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
        idempotencyKey: _newIdempotencyKey(),
      );
    }
    await _execute(_pending!);
  }

  /// Ponawia ostatnią operację z tym samym kluczem idempotencji.
  Future<void> retry() async {
    final pending = _pending;
    if (pending != null) await _execute(pending);
  }

  Future<void> _execute(_PendingCreateDocument pending) async {
    emit(const StorageDocumentMutationLoading());
    final result = await _repository.createStorageDocument(
      scope: pending.scope,
      name: pending.name,
      format: pending.format,
      idempotencyKey: pending.idempotencyKey,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        StorageDocumentMutationFailure(
          error.message,
          apiCode: error.apiCode,
          traceId: error.traceId,
        ),
      ),
      (file) {
        _pending = null;
        emit(StorageDocumentMutationSuccess(file));
      },
    );
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
    required this.idempotencyKey,
  });

  final StorageScope scope;
  final String name;
  final StorageDocumentFormat format;
  final String idempotencyKey;
}
