import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Udostępnienia jednego pliku, z zachowaniem danych przy błędzie mutacji.
class StorageSharingCubit extends Cubit<StorageSharingState> {
  StorageSharingCubit({
    required this.fileId,
    required this.repository,
    this.onMutationConfirmed,
  }) : super(const StorageSharingInitial());

  final String fileId;
  final StorageRepository repository;
  final Future<void> Function()? onMutationConfirmed;

  int _generation = 0;
  bool _mutationInFlight = false;
  DateTime? _retryAfterUtc;
  Timer? _retryTimer;

  bool get isMutating => _mutationInFlight;
  bool get canMutate {
    final current = state;
    final deadline = _retryAfterUtc;
    return !isClosed &&
        !_mutationInFlight &&
        current is StorageSharingReady &&
        !current.isRefreshing &&
        (deadline == null || !DateTime.now().toUtc().isBefore(deadline));
  }

  /// Wczytuje granty lub odświeża je bez chowania ostatniej poprawnej listy.
  Future<void> loadShares() async {
    if (isClosed || _mutationInFlight || _isCoolingDown) return;
    final generation = ++_generation;
    final previous = state;
    if (previous case final StorageSharingReady ready) {
      emit(ready.copyWith(isRefreshing: true, clearLoadError: true));
    } else {
      emit(const StorageSharingLoading());
    }

    try {
      final result = await repository.listFileShares(fileId);
      if (!_isCurrent(generation)) return;
      result.fold(
        (error) => _emitLoadError(error, previous),
        (shares) => emit(StorageSharingReady(shares: shares)),
      );
    } on Object catch (error) {
      if (!_isCurrent(generation)) return;
      _emitLoadError(_errorFromThrown(error), previous);
    }
  }

  Future<bool> shareWithUser({
    required String targetUserId,
    required StorageShareAccessLevel accessLevel,
    DateTime? expiresAtUtc,
  }) => _createShare(
    CreateStorageFileSharePayload(
      shareType: StorageShareType.user,
      accessLevel: accessLevel,
      sharedWithUserId: targetUserId,
      expiresAtUtc: expiresAtUtc,
    ),
  );

  Future<bool> shareWithWorkspace({
    required String workspaceId,
    required StorageShareAccessLevel accessLevel,
  }) => _createShare(
    CreateStorageFileSharePayload(
      shareType: StorageShareType.workspace,
      accessLevel: accessLevel,
      sharedWithWorkspaceId: workspaceId,
    ),
  );

  Future<bool> shareWithProject({
    required String projectId,
    required StorageShareAccessLevel accessLevel,
  }) => _createShare(
    CreateStorageFileSharePayload(
      shareType: StorageShareType.project,
      accessLevel: accessLevel,
      sharedWithProjectId: projectId,
    ),
  );

  /// Tworzy publiczny grant. Błąd pozostaje w [StorageSharingReady.mutationError].
  Future<String?> createPublicLink({
    required StorageShareAccessLevel accessLevel,
    String? password,
    DateTime? expiresAtUtc,
  }) async {
    final operation = _beginMutation();
    if (operation == null) return null;
    try {
      final result = await repository.createFileShare(
        fileId: fileId,
        payload: CreateStorageFileSharePayload(
          shareType: StorageShareType.publicLink,
          accessLevel: accessLevel,
          password: password,
          expiresAtUtc: expiresAtUtc,
        ),
      );
      if (!_isCurrent(operation.generation)) return null;
      final token = result.fold<String?>(
        (error) {
          _finishMutationError(operation.ready, error);
          return null;
        },
        (share) {
          _finishMutationSuccess(
            operation.ready,
            [...operation.ready.shares, share],
            createdShareToken: share.shareToken,
          );
          _notifyMutationConfirmed();
          return share.shareToken;
        },
      );
      return token;
    } on Object catch (error) {
      if (_isCurrent(operation.generation)) {
        _finishMutationError(operation.ready, _errorFromThrown(error));
      }
      return null;
    } finally {
      _releaseMutation(operation.generation);
    }
  }

  /// Usuwa grant wskazany identyfikatorem.
  Future<bool> revokeShare(String shareId) async {
    final operation = _beginMutation();
    if (operation == null) return false;
    try {
      final result = await repository.deleteFileShare(
        fileId: fileId,
        shareId: shareId,
      );
      if (!_isCurrent(operation.generation)) return false;
      final succeeded = result.fold<bool>(
        (error) {
          _finishMutationError(operation.ready, error);
          return false;
        },
        (_) {
          _finishMutationSuccess(
            operation.ready,
            operation.ready.shares
                .where((share) => share.id != shareId)
                .toList(growable: false),
          );
          _notifyMutationConfirmed();
          return true;
        },
      );
      return succeeded;
    } on Object catch (error) {
      if (_isCurrent(operation.generation)) {
        _finishMutationError(operation.ready, _errorFromThrown(error));
      }
      return false;
    } finally {
      _releaseMutation(operation.generation);
    }
  }

  /// Usuwa grant, jeżeli budowanie bezpiecznego URL się nie powiedzie.
  Future<void> revokeShareToken(String token) async {
    final current = state;
    if (current is! StorageSharingReady) return;
    for (final share in current.shares) {
      if (share.shareToken == token) {
        await revokeShare(share.id);
        return;
      }
    }
  }

  Future<bool> _createShare(CreateStorageFileSharePayload payload) async {
    final operation = _beginMutation();
    if (operation == null) return false;
    try {
      final result = await repository.createFileShare(
        fileId: fileId,
        payload: payload,
      );
      if (!_isCurrent(operation.generation)) return false;
      final succeeded = result.fold<bool>(
        (error) {
          _finishMutationError(operation.ready, error);
          return false;
        },
        (share) {
          _finishMutationSuccess(
            operation.ready,
            [...operation.ready.shares, share],
          );
          _notifyMutationConfirmed();
          return true;
        },
      );
      return succeeded;
    } on Object catch (error) {
      if (_isCurrent(operation.generation)) {
        _finishMutationError(operation.ready, _errorFromThrown(error));
      }
      return false;
    } finally {
      _releaseMutation(operation.generation);
    }
  }

  _StorageShareMutation? _beginMutation() {
    final current = state;
    if (!canMutate || current is! StorageSharingReady) {
      return null;
    }
    _mutationInFlight = true;
    final generation = ++_generation;
    final snapshot = current.copyWith(
      isMutating: true,
      clearMutationError: true,
      clearLoadError: true,
    );
    emit(snapshot);
    return _StorageShareMutation(generation, snapshot);
  }

  void _finishMutationError(StorageSharingReady base, ApiError error) {
    if (isClosed) return;
    _recordRetryAfter(error.retryAfterUtc);
    emit(base.copyWith(isMutating: true, mutationError: error));
  }

  void _finishMutationSuccess(
    StorageSharingReady base,
    List<StorageFileShareResponse> shares, {
    String? createdShareToken,
  }) {
    if (isClosed) return;
    emit(
      base.copyWith(
        shares: shares,
        isMutating: true,
        createdShareToken: createdShareToken,
        clearCreatedShareToken: createdShareToken == null,
        clearMutationError: true,
        clearLoadError: true,
      ),
    );
  }

  void _releaseMutation(int generation) {
    if (!_isCurrent(generation)) return;
    _mutationInFlight = false;
    final current = state;
    if (current is StorageSharingReady && current.isMutating) {
      emit(current.copyWith(isMutating: false));
    }
  }

  void _emitLoadError(ApiError error, StorageSharingState previous) {
    _recordRetryAfter(error.retryAfterUtc);
    if (previous case final StorageSharingReady ready) {
      emit(ready.copyWith(isRefreshing: false, loadError: error));
    } else {
      emit(StorageSharingFailure(error));
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
    _retryTimer = Timer(delay, _enableMutationsAfterCooldown);
  }

  void _enableMutationsAfterCooldown() {
    _retryTimer = null;
    if (isClosed) return;
    _retryAfterUtc = null;
    final current = state;
    if (current is StorageSharingReady) {
      emit(
        current.copyWith(
          retryEnabledRevision: current.retryEnabledRevision + 1,
        ),
      );
    }
  }

  void _notifyMutationConfirmed() {
    final callback = onMutationConfirmed;
    if (callback != null) unawaited(callback());
  }

  @override
  Future<void> close() {
    _generation++;
    _retryTimer?.cancel();
    return super.close();
  }
}

final class _StorageShareMutation {
  const _StorageShareMutation(this.generation, this.ready);

  final int generation;
  final StorageSharingReady ready;
}
