import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_scope.dart';

/// Koduje zakres Storage w stabilny URL i odtwarza prywatne widoki systemowe.
final class StorageScopeRouteCodec {
  const StorageScopeRouteCodec._();

  /// Osadzony explorer (np. załączniki lub test widgetu) nie wymaga routera.
  static Uri? routeUri(BuildContext context) {
    if (GoRouter.maybeOf(context) == null) return null;
    try {
      return GoRouterState.of(context).uri;
      // GoRouter udostępnia wyjątek Error zamiast nullable lookup dla osadzeń.
      // ignore: avoid_catching_errors
    } on GoError {
      return null;
    }
  }

  /// Widoki globalne zachowują ścieżkę i shell workspace/projektu.
  static String? contextualLocation(StorageScope scope, Uri? current) {
    final target = location(scope);
    if (target == null || current == null) return target;
    final uri = Uri.parse(target);
    if (_isWorkspaceFiles(current) && uri.path == '/me/files') {
      return Uri(
        path: current.path,
        queryParameters: {
          ...uri.queryParameters,
          'view': uri.queryParameters['view'] ?? 'personal',
        },
      ).toString();
    }
    return target;
  }

  /// Odtwarza zakres po deep linku i po Back, bez zmiany kontekstu projektu.
  static StorageScope contextualScope(StorageScope fallback, Uri? uri) {
    if (uri == null) return fallback;
    if (uri.path == '/me/files' ||
        (_isWorkspaceFiles(uri) && uri.queryParameters.containsKey('view'))) {
      return fromPersonalUri(uri);
    }
    return fallback;
  }

  /// Powrót do plików bieżącego workspace, również ze stanu błędu.
  static String? returnLocation(Uri? uri) {
    if (uri == null) return null;
    if (_isWorkspaceFiles(uri) && uri.queryParameters.containsKey('view')) {
      return uri.path;
    }
    final target = Uri.tryParse(uri.queryParameters['returnTo'] ?? '');
    return target != null &&
            !target.hasScheme &&
            !target.hasAuthority &&
            _isWorkspaceFiles(target)
        ? target.toString()
        : null;
  }

  static bool _isWorkspaceFiles(Uri uri) =>
      uri.path.startsWith('/workspaces/') && uri.path.endsWith('/files');

  /// Odtwarza zakres prywatnego ekranu z parametrów query.
  static StorageScope fromPersonalUri(Uri uri) {
    final folderId = uri.queryParameters['folder'];
    return switch (uri.queryParameters['view']) {
      'shared' => StorageScope.shared(folderId: folderId),
      'recent' => const StorageScope.recent(),
      'favorites' => const StorageScope.favorites(),
      'trash' => const StorageScope.trash(),
      _ => StorageScope.personal(folderId: folderId),
    };
  }

  /// Buduje kanoniczną lokalizację dla bieżącego zakresu.
  static String? location(StorageScope scope) {
    final path = switch (scope) {
      StorageWorkspaceScope(:final workspaceId) =>
        '/workspaces/${Uri.encodeComponent(workspaceId)}/files',
      StorageProjectScope(:final workspaceId, :final projectId) =>
        '/workspaces/${Uri.encodeComponent(workspaceId)}/projects/${Uri.encodeComponent(projectId)}/files',
      StorageResourceScope() => null,
      _ => '/me/files',
    };
    if (path == null) return null;

    final query = <String, String>{};
    final view = switch (scope) {
      StorageSharedScope() => 'shared',
      StorageRecentScope() => 'recent',
      StorageFavoritesScope() => 'favorites',
      StorageTrashScope() => 'trash',
      _ => null,
    };
    if (view != null) query['view'] = view;
    if (scope.folderId case final folderId?) query['folder'] = folderId;
    return Uri(
      path: path,
      queryParameters: query.isEmpty ? null : query,
    ).toString();
  }
}
