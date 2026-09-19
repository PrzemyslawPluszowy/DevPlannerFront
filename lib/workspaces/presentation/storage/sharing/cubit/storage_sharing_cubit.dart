import 'dart:async';

import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit zarządzający uprawnieniami i udostępnieniami pojedynczego pliku.
class StorageSharingCubit extends Cubit<StorageSharingState> {
  /// Tworzy instancję cubita z wstrzykniętym repozytorium i identyfikatorem pliku.
  StorageSharingCubit({
    required this.fileId,
    required this.repository,
    this.onMutationConfirmed,
  }) : super(const StorageSharingInitial());

  /// Identyfikator pliku, którego dotyczą uprawnienia.
  final String fileId;

  /// Repozytorium operacji storage.
  final StorageRepository repository;

  /// Odświeża właściciela listy Files dopiero po odpowiedzi 2xx mutacji.
  final Future<void> Function()? onMutationConfirmed;

  /// Pobiera listę aktywnych udostępnień.
  Future<void> loadShares() async {
    emit(const StorageSharingLoading());
    final result = await repository.listFileShares(fileId);
    if (isClosed) return;

    result.fold(
      (error) => emit(
        StorageSharingFailure(
          message: error.message,
          code: _errorCode(error),
        ),
      ),
      (shares) => emit(StorageSharingReady(shares: shares)),
    );
  }

  /// Udostępnia plik użytkownikowi.
  Future<bool> shareWithUser({
    required String targetUserId,
    required StorageShareAccessLevel accessLevel,
    DateTime? expiresAtUtc,
  }) async {
    return _createShare(
      CreateStorageFileSharePayload(
        shareType: StorageShareType.user,
        accessLevel: accessLevel,
        sharedWithUserId: targetUserId,
        expiresAtUtc: expiresAtUtc,
      ),
    );
  }

  /// Udostępnia plik całemu workspace.
  Future<bool> shareWithWorkspace({
    required String workspaceId,
    required StorageShareAccessLevel accessLevel,
  }) async {
    return _createShare(
      CreateStorageFileSharePayload(
        shareType: StorageShareType.workspace,
        accessLevel: accessLevel,
        sharedWithWorkspaceId: workspaceId,
      ),
    );
  }

  /// Udostępnia plik projektowi.
  Future<bool> shareWithProject({
    required String projectId,
    required StorageShareAccessLevel accessLevel,
  }) async {
    return _createShare(
      CreateStorageFileSharePayload(
        shareType: StorageShareType.project,
        accessLevel: accessLevel,
        sharedWithProjectId: projectId,
      ),
    );
  }

  /// Tworzy publiczny link do pliku z opcjonalnym hasłem i datą wygaśnięcia.
  Future<String?> createPublicLink({
    required StorageShareAccessLevel accessLevel,
    String? password,
    DateTime? expiresAtUtc,
  }) async {
    final currentState = state;
    if (currentState is StorageSharingReady) {
      emit(currentState.copyWith(isMutating: true));
    }

    final result = await repository.createFileShare(
      fileId: fileId,
      payload: CreateStorageFileSharePayload(
        shareType: StorageShareType.publicLink,
        accessLevel: accessLevel,
        password: password,
        expiresAtUtc: expiresAtUtc,
      ),
    );

    if (isClosed) return null;

    return result.fold(
      (error) {
        emit(
          StorageSharingFailure(
            message: error.message,
            code: _errorCode(error),
          ),
        );
        return null;
      },
      (share) {
        final currentShares = currentState is StorageSharingReady
            ? currentState.shares
            : <StorageFileShareResponse>[];
        emit(
          StorageSharingReady(
            shares: [...currentShares, share],
            createdShareToken: share.shareToken,
          ),
        );
        return share.shareToken;
      },
    );
  }

  /// Usuwa wskazany grant udostępnienia.
  Future<bool> revokeShare(String shareId) async {
    final currentState = state;
    if (currentState is StorageSharingReady) {
      emit(currentState.copyWith(isMutating: true));
    }

    final result = await repository.deleteFileShare(
      fileId: fileId,
      shareId: shareId,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(
          StorageSharingFailure(
            message: error.message,
            code: _errorCode(error),
          ),
        );
        return false;
      },
      (_) {
        if (currentState is StorageSharingReady) {
          final updated = currentState.shares
              .where((s) => s.id != shareId)
              .toList(growable: false);
          emit(StorageSharingReady(shares: updated));
        }
        _notifyMutationConfirmed();
        return true;
      },
    );
  }

  Future<bool> _createShare(CreateStorageFileSharePayload payload) async {
    final currentState = state;
    if (currentState is StorageSharingReady) {
      emit(currentState.copyWith(isMutating: true));
    }

    final result = await repository.createFileShare(
      fileId: fileId,
      payload: payload,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(
          StorageSharingFailure(
            message: error.message,
            code: _errorCode(error),
          ),
        );
        return false;
      },
      (share) {
        final currentShares = currentState is StorageSharingReady
            ? currentState.shares
            : <StorageFileShareResponse>[];
        emit(
          StorageSharingReady(
            shares: [...currentShares, share],
          ),
        );
        _notifyMutationConfirmed();
        return true;
      },
    );
  }

  void _notifyMutationConfirmed() {
    final callback = onMutationConfirmed;
    if (callback != null) unawaited(callback());
  }

  String? _errorCode(ApiError error) =>
      error.backendCode?.toString() ?? error.statusCode?.toString();
}
