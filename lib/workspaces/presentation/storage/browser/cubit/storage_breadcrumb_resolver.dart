import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';

/// Odtwarza pełną ścieżkę folderów bez przenoszenia nawigacji do Cubita.
final class StorageBreadcrumbResolver {
  /// Tworzy resolver używający kontraktu Storage.
  const StorageBreadcrumbResolver(this._repository);

  final StorageRepository _repository;

  /// Pobiera bieżący folder i wszystkich dostępnych przodków.
  Future<StorageResolvedBreadcrumbs> resolve(StorageScope scope) async {
    final folders = <StorageFolderResponse>[];
    final visited = <String>{};
    var folderId = scope.folderId;

    while (folderId != null && visited.add(folderId) && folders.length < 64) {
      final result = await _repository.getFolder(folderId);
      final folder = result.getOrElse(
        () => throw const _FolderPathUnavailable(),
      );
      folders.add(folder);
      folderId = folder.parentFolderId;
    }

    return StorageResolvedBreadcrumbs(
      currentFolder: folders.isEmpty ? null : folders.first,
      breadcrumbs: [
        StorageBreadcrumbItem(name: rootName(scope)),
        ...folders.reversed.map(
          (folder) => StorageBreadcrumbItem(
            name: folder.name,
            folderId: folder.id,
          ),
        ),
      ],
    );
  }

  /// Zwraca etykietę korzenia właściwą dla zakresu danych.
  // Root labels are rendered by StorageBreadcrumbs using the active locale.
  // Keep the state value neutral so it can never leak a fallback language.
  String rootName(StorageScope _) => '';
}

/// Wynik odtworzenia ścieżki folderów.
final class StorageResolvedBreadcrumbs {
  /// Tworzy niezmienny wynik resolvera.
  const StorageResolvedBreadcrumbs({
    required this.currentFolder,
    required this.breadcrumbs,
  });

  /// Folder otwarty przez użytkownika.
  final StorageFolderResponse? currentFolder;

  /// Pełna ścieżka od korzenia do otwartego folderu.
  final List<StorageBreadcrumbItem> breadcrumbs;
}

final class _FolderPathUnavailable implements Exception {
  const _FolderPathUnavailable();
}
