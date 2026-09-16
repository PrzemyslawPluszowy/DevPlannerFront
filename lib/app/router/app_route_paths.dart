/// Zbior znanych sciezek aplikacji.
abstract final class AppRoutePaths {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const inventory = '/inventory';
  static const inventoryOverview = '/inventory/overview';
  static const inventoryStock = '/inventory/stock';
  static const inventoryArchive = '/inventory/archive';
  static const bhp = '/bhp';
  static const workspaces = '/workspaces';
  static const meTasks = '/me/tasks';
  static const meFiles = '/me/files';
  static const notifications = '/notifications';
  static const chat = '/chat';
  static const storageFiles = '/storage/files';
  static const storagePublicShares = '/storage/public';
  static const bhpUsers = '/bhp/users';
  static const bhpPositions = '/bhp/positions';
  static const bhpEquipment = '/bhp/equipment';
  static const orders = '/orders';
  static const inne = '/inne';
  static const settings = '/settings';
  static const frameworkComponents = '/framework/components';

  /// Przekierowuje historyczne prywatne ścieżki poza dynamiczny segment
  /// `/workspaces/:workspaceId`, zachowując parametry zapytania i fragment.
  static String? redirectLegacyPrivatePath(Uri uri) {
    final canonicalPath = switch (uri.path) {
      '/workspaces/private/tasks' => meTasks,
      '/workspaces/private/files' => meFiles,
      _ => null,
    };
    if (canonicalPath == null) return null;
    return uri.replace(path: canonicalPath).toString();
  }
}
