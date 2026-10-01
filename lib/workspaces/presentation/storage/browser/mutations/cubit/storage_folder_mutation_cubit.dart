import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit obsługujący tworzenie, zmianę nazwy, przenoszenie i usuwanie folderów.
final class StorageFolderMutationCubit
    extends Cubit<StorageFolderMutationState> {
  StorageFolderMutationCubit({required this.repository})
    : super(const StorageFolderMutationInitial());

  final StorageRepository repository;
  int _generation = 0;
  bool _inFlight = false;
  DateTime? _retryAfterUtc;
  Timer? _retryTimer;

  bool get canMutate =>
      !isClosed &&
      !_inFlight &&
      state is! StorageFolderMutationLoading &&
      !_isCoolingDown;

  Future<void> createFolder({
    required StorageScope scope,
    required String name,
    String? parentFolderId,
  }) => _run<StorageFolderResponse>(
    request: () => repository.createFolder(
      scope: scope,
      name: name.trim(),
      parentFolderId: parentFolderId,
    ),
    onSuccess: (folder) => StorageFolderMutationSuccess(
      type: StorageFolderMutationType.created,
      folder: folder,
      folderId: folder.id,
    ),
  );

  Future<void> renameFolder({
    required String folderId,
    required String newName,
  }) => _run<StorageFolderResponse>(
    request: () => repository.updateFolder(
      folderId: folderId,
      name: newName.trim(),
    ),
    onSuccess: (folder) => StorageFolderMutationSuccess(
      type: StorageFolderMutationType.updated,
      folder: folder,
      folderId: folder.id,
    ),
  );

  Future<void> moveFolder({
    required String folderId,
    required String? newParentFolderId,
  }) => _run<StorageFolderResponse>(
    request: () => repository.moveFolder(
      folderId: folderId,
      newParentFolderId: newParentFolderId,
    ),
    onSuccess: (folder) => StorageFolderMutationSuccess(
      type: StorageFolderMutationType.moved,
      folder: folder,
      folderId: folder.id,
    ),
  );

  Future<void> deleteFolder(String folderId) => _run<Unit>(
    request: () => repository.deleteFolder(folderId),
    onSuccess: (_) => StorageFolderMutationSuccess(
      type: StorageFolderMutationType.deleted,
      folderId: folderId,
    ),
  );

  Future<void> _run<T>({
    required Future<Either<ApiError, T>> Function() request,
    required StorageFolderMutationState Function(T value) onSuccess,
  }) async {
    if (!canMutate) return;
    _inFlight = true;
    final generation = ++_generation;
    emit(const StorageFolderMutationLoading());
    StorageFolderMutationState? outcome;
    try {
      final result = await request();
      if (!_isCurrent(generation)) return;
      outcome = result.fold<StorageFolderMutationState>(
        (error) {
          _recordRetryAfter(error.retryAfterUtc);
          return StorageFolderMutationFailure(error: error);
        },
        onSuccess,
      );
    } on Object catch (error) {
      if (!_isCurrent(generation)) return;
      final apiError = _errorFromThrown(error);
      _recordRetryAfter(apiError.retryAfterUtc);
      outcome = StorageFolderMutationFailure(error: apiError);
    } finally {
      if (_isCurrent(generation)) {
        _inFlight = false;
        if (outcome != null) emit(outcome);
      }
    }
  }

  bool _isCurrent(int generation) => !isClosed && generation == _generation;

  bool get _isCoolingDown {
    final deadline = _retryAfterUtc;
    return deadline != null && DateTime.now().toUtc().isBefore(deadline);
  }

  ApiError _errorFromThrown(Object error) => switch (error) {
    final ApiError apiError => apiError,
    final DioException dioError => ApiError.fromDioException(
      dioError,
      fallbackMessage: '',
    ),
    _ => const ApiError(
      type: ApiErrorType.unknown,
      message: '',
      apiCode: 'storage.unexpected_error',
    ),
  };

  void _recordRetryAfter(DateTime? deadline) {
    if (deadline == null) return;
    final candidate = deadline.toUtc();
    final current = _retryAfterUtc;
    if (current != null && !candidate.isAfter(current)) return;
    _retryAfterUtc = candidate;
    _retryTimer?.cancel();
    final delay = candidate.difference(DateTime.now().toUtc());
    if (delay <= Duration.zero) {
      _retryAfterUtc = null;
      return;
    }
    _retryTimer = Timer(delay, _enableRetryAfter);
  }

  void _enableRetryAfter() {
    _retryTimer = null;
    if (isClosed) return;
    _retryAfterUtc = null;
    final current = state;
    if (current case final StorageFolderMutationFailure failure) {
      emit(
        failure.copyWith(
          retryEnabledRevision: failure.retryEnabledRevision + 1,
        ),
      );
    }
  }

  /// Resetuje stan po obsłużonym sukcesie; nie przerywa aktywnej operacji.
  void reset() {
    if (isClosed || _inFlight) return;
    _generation++;
    emit(const StorageFolderMutationInitial());
  }

  @override
  Future<void> close() {
    _generation++;
    _retryTimer?.cancel();
    return super.close();
  }
}
