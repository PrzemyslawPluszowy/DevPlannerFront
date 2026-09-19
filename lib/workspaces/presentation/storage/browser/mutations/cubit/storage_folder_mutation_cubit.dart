import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit obsługujący tworzenie, zmianę nazwy, przenoszenie i usuwanie folderów.
final class StorageFolderMutationCubit
    extends Cubit<StorageFolderMutationState> {
  /// Tworzy cubit mutacji folderów.
  StorageFolderMutationCubit({required this._repository})
    : super(const StorageFolderMutationInitial());

  final StorageRepository _repository;

  /// Tworzy nowy folder.
  Future<void> createFolder({
    required StorageScope scope,
    required String name,
    String? parentFolderId,
  }) async {
    emit(const StorageFolderMutationLoading());
    final result = await _repository.createFolder(
      scope: scope,
      name: name.trim(),
      parentFolderId: parentFolderId,
    );
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFolderMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
        ),
      ),
      (folder) => emit(
        StorageFolderMutationSuccess(
          type: StorageFolderMutationType.created,
          folder: folder,
          folderId: folder.id,
        ),
      ),
    );
  }

  /// Zmienia nazwę folderu.
  Future<void> renameFolder({
    required String folderId,
    required String newName,
  }) async {
    emit(const StorageFolderMutationLoading());
    final result = await _repository.updateFolder(
      folderId: folderId,
      name: newName.trim(),
    );
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFolderMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
        ),
      ),
      (folder) => emit(
        StorageFolderMutationSuccess(
          type: StorageFolderMutationType.updated,
          folder: folder,
          folderId: folder.id,
        ),
      ),
    );
  }

  /// Przenosi folder do innego katalogu.
  Future<void> moveFolder({
    required String folderId,
    required String? newParentFolderId,
  }) async {
    emit(const StorageFolderMutationLoading());
    final result = await _repository.moveFolder(
      folderId: folderId,
      newParentFolderId: newParentFolderId,
    );
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFolderMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
        ),
      ),
      (folder) => emit(
        StorageFolderMutationSuccess(
          type: StorageFolderMutationType.moved,
          folder: folder,
          folderId: folder.id,
        ),
      ),
    );
  }

  /// Usuwa wskazany folder.
  Future<void> deleteFolder(String folderId) async {
    emit(const StorageFolderMutationLoading());
    final result = await _repository.deleteFolder(folderId);
    if (isClosed) return;

    result.fold(
      (err) => emit(
        StorageFolderMutationFailure(
          message: err.message,
          statusCode: err.statusCode,
          backendCode: err.backendCode,
        ),
      ),
      (_) => emit(
        StorageFolderMutationSuccess(
          type: StorageFolderMutationType.deleted,
          folderId: folderId,
        ),
      ),
    );
  }

  /// Resetuje stan do początkowego po obsłużeniu sukcesu w UI.
  void reset() {
    emit(const StorageFolderMutationInitial());
  }
}
