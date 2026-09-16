import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';

/// Cubit zarządzający uprawnieniami i udostępnieniami pojedynczego pliku.
class StorageSharingCubit extends Cubit<StorageSharingState> {
  /// Tworzy instancję cubita z wstrzykniętym repozytorium i identyfikatorem pliku.
  StorageSharingCubit({
    required this.fileId,
    required this.repository,
  }) : super(const StorageSharingInitial());

  /// Identyfikator pliku, którego dotyczą uprawnienia.
  final String fileId;

  /// Repozytorium operacji storage.
  final StorageRepository repository;

  /// Pobiera listę aktywnych udostępnień.
  Future<void> loadShares() async {
    emit(const StorageSharingLoading());
    final result = await repository.listFileShares(fileId);
    if (isClosed) return;

    result.fold(
      (error) => emit(
        StorageSharingFailure(
          message: error.message,
          code: error.backendCode?.toString(),
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
            code: error.backendCode?.toString(),
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
            code: error.backendCode?.toString(),
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
            code: error.backendCode?.toString(),
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
        return true;
      },
    );
  }
}
