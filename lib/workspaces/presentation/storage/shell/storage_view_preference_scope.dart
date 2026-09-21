import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';

/// Klucz preferencji widoku dla zakresu modułu Pliki.
///
/// Klucz nie zawiera identyfikatora folderu: preferencja dotyczy sposobu
/// przeglądania zakresu, a nie pojedynczego katalogu, więc przejście w głąb
/// drzewa nie gubi wybranego widoku ani gęstości.
abstract final class StorageViewPreferenceScope {
  const StorageViewPreferenceScope._();

  /// Zwraca stabilny klucz zakresu dla trwałej preferencji widoku.
  static String keyOf(StorageScope scope) => switch (scope) {
    StorageWorkspaceScope(:final workspaceId) => 'workspace:$workspaceId',
    StorageProjectScope(:final workspaceId, :final projectId) =>
      'project:$workspaceId:$projectId',
    StorageSharedScope() => 'shared',
    StorageRecentScope() => 'recent',
    StorageFavoritesScope() => 'favorites',
    StorageTrashScope() => 'trash',
    StorageResourceScope(
      :final module,
      :final resourceType,
      :final resourceId,
    ) =>
      'resource:${module.name}:${resourceType.name}:$resourceId',
    _ => 'personal',
  };
}
