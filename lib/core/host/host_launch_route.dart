import 'package:ready_next/app/router/app_deep_link.dart';
import 'package:ready_next/app/router/app_route_paths.dart';

/// Wyznacza wewnętrzną trasę aplikacji z webowego URL-a.
///
/// [path] może zawierać prefiks hosta, np. `/ready-next`, a [fragment]
/// obsługuje starsze adresy w formacie `#/inventory/stock`. Query i fragment
/// zasobu są zachowywane, żeby refresh oraz logowanie nie zmieniały kontekstu.
String resolveWebLaunchLocation({
  required String path,
  String query = '',
  String fragment = '',
}) {
  final legacyLocation = fragment.trim();
  if (legacyLocation.isNotEmpty) {
    return _normalizeLocation(legacyLocation);
  }

  final normalizedPath = path.trim().isEmpty ? '/' : path.trim();
  final location = Uri(
    path: normalizedPath,
    query: query.trim().isEmpty ? null : query.trim(),
  ).toString();
  return _normalizeLocation(location);
}

String _normalizeLocation(String rawLocation) {
  final value = rawLocation.trim();
  if (value.isEmpty) {
    return AppRoutePaths.dashboard;
  }

  final withLeadingSlash = value.startsWith('/') ? value : '/$value';
  final parsed = Uri.tryParse(withLeadingSlash);
  if (parsed == null || parsed.hasAuthority || parsed.hasScheme) {
    return AppRoutePaths.dashboard;
  }

  final candidatePath = _stripHostPrefix(parsed.path);
  if (candidatePath == null) {
    return AppRoutePaths.dashboard;
  }

  final candidate = Uri(
    path: candidatePath,
    query: parsed.query.isEmpty ? null : parsed.query,
    fragment: parsed.fragment.isEmpty ? null : parsed.fragment,
  ).toString();

  if (candidatePath == AppRoutePaths.login) {
    return candidate;
  }

  return AppDeepLink.normalize(candidate) ?? AppRoutePaths.dashboard;
}

String? _stripHostPrefix(String path) {
  if (path == '/') {
    return AppRoutePaths.dashboard;
  }

  for (final route in _staticRoutes) {
    if (path == route || path.endsWith(route)) {
      return route;
    }
  }

  for (final prefix in _dynamicRoutePrefixes) {
    final index = path.indexOf(prefix);
    if (index >= 0) {
      return path.substring(index);
    }
  }

  return null;
}

const _staticRoutes = <String>[
  AppRoutePaths.frameworkComponents,
  AppRoutePaths.inventoryOverview,
  AppRoutePaths.inventoryArchive,
  AppRoutePaths.inventoryStock,
  AppRoutePaths.bhpPositions,
  AppRoutePaths.bhpEquipment,
  AppRoutePaths.bhpUsers,
  AppRoutePaths.notifications,
  AppRoutePaths.workspaces,
  AppRoutePaths.dashboard,
  AppRoutePaths.inventory,
  AppRoutePaths.settings,
  AppRoutePaths.orders,
  AppRoutePaths.login,
  AppRoutePaths.chat,
  AppRoutePaths.inne,
  AppRoutePaths.bhp,
];

const _dynamicRoutePrefixes = <String>[
  '/workspaces/',
  '/storage/files/',
  '/chat/conversations/',
  '/me/',
];
