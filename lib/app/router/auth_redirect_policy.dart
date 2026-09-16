import 'package:ready_next/app/router/app_deep_link.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/core/auth/auth_state.dart';

const loginRedirectQueryKey = 'redirect';

/// Wybiera adres startowy routera.
///
/// Na Web zachowuje adres z paska przeglądarki, a na desktopie korzysta z
/// trasy przekazanej przez hosta. `Uri.base` na desktopie wskazuje katalog
/// uruchomienia procesu, dlatego nie może być interpretowane jako URL aplikacji.
String resolvePlatformInitialLocation({
  required Uri platformUri,
  required bool isWeb,
  required String launchPath,
}) {
  if (!isWeb) {
    // Desktop zawsze przechodzi przez AppStartupPage. Tam trasa hosta jest
    // zestawiana z zapisaną preferencją modułu użytkownika i stanem sesji.
    return '/';
  }

  final browserLocation = Uri(
    path: platformUri.path.isEmpty ? '/' : platformUri.path,
    query: platformUri.query.isEmpty ? null : platformUri.query,
    fragment: platformUri.fragment.isEmpty ? null : platformUri.fragment,
  ).toString();
  return resolveInitialDeepLinkPath(
    incomingPath: browserLocation,
    launchPath: launchPath,
  );
}

/// Wybiera trasę przeglądarki, o ile nie wskazuje ona głównego `/`.
String resolveInitialDeepLinkPath({
  required String incomingPath,
  required String launchPath,
}) {
  final incoming = incomingPath.trim();
  final incomingUri = Uri.tryParse(incoming);
  if (incoming.isNotEmpty && incomingUri?.path != '/') {
    return incoming;
  }
  return launchPath.trim().isEmpty ? '/' : launchPath.trim();
}

/// Zwraca aktywna sciezke na podstawie routera, fragmentu URL lub path.
String resolveCurrentRoutePath({
  required String routerPath,
  required String fragment,
  required String basePath,
}) {
  final normalizedRouterPath = _normalizeRoutePath(routerPath);
  if (normalizedRouterPath.isNotEmpty) {
    return normalizedRouterPath;
  }

  final normalizedFragment = _normalizeRoutePath(fragment);
  if (normalizedFragment.isNotEmpty) {
    return normalizedFragment;
  }

  return _normalizeRoutePath(basePath);
}

/// Okresla, czy utrata sesji powinna wymusic przekierowanie do logowania.
bool shouldRedirectToLoginOnUnauthenticated({
  required AuthState state,
  required String currentPath,
}) {
  if (state is! AuthUnauthenticated) {
    return false;
  }

  final normalizedPath = _normalizeRoutePath(currentPath);
  return !_isLoginPath(normalizedPath);
}

/// Okresla, czy poprawne logowanie powinno wyprowadzic uzytkownika z ekranu loginu.
bool shouldRedirectFromLoginOnAuthenticated({
  required AuthState state,
  required String currentPath,
}) {
  if (state is! AuthAuthenticated) {
    return false;
  }

  final normalizedPath = _normalizeRoutePath(currentPath);
  return _isLoginPath(normalizedPath);
}

/// Buduje sciezke logowania z opcjonalnym redirectem po poprawnym auth.
String buildLoginPath({String? redirectTo}) {
  final normalizedRedirect = _normalizeRedirectLocation(redirectTo);
  if (normalizedRedirect == null) {
    return _loginPath();
  }

  return Uri(
    path: _loginPath(),
    queryParameters: {loginRedirectQueryKey: normalizedRedirect},
  ).toString();
}

/// Wylicza trase docelowa po poprawnym logowaniu.
String resolvePostLoginPath({
  required String currentLocation,
  required String fallbackPath,
}) {
  final currentUri = Uri.tryParse(currentLocation.trim());
  final requestedRedirect =
      currentUri?.queryParameters[loginRedirectQueryKey]?.trim() ?? '';
  final normalizedRedirect = _normalizeRedirectLocation(requestedRedirect);
  if (normalizedRedirect != null) {
    return normalizedRedirect;
  }

  final normalizedFallback = _normalizeRedirectLocation(fallbackPath);
  if (normalizedFallback != null) {
    return normalizedFallback;
  }

  return '/';
}

String? _normalizeRedirectLocation(String? value) {
  final trimmedValue = value?.trim() ?? '';
  if (trimmedValue.isEmpty) {
    return null;
  }

  final parsedUri = Uri.tryParse(trimmedValue);
  final normalizedPath = _normalizeRoutePath(parsedUri?.path ?? trimmedValue);
  if (normalizedPath.isEmpty || _isLoginPath(normalizedPath)) {
    return null;
  }

  // Redirect z query `redirect` może pochodzić z adresu przeglądarki. Dla
  // tras zasobów stosujemy ten sam allowlist parser, co dla deep linków z API.
  // Root pozostaje specjalnym fallbackiem obsługiwanym przez router.
  if (normalizedPath != '/' && AppDeepLink.parse(trimmedValue) == null) {
    return null;
  }

  final rawQuery = parsedUri?.query.trim() ?? '';
  final normalizedFragment = switch (parsedUri?.fragment.trim()) {
    final fragment? when fragment.isNotEmpty => fragment,
    _ => null,
  };
  final buffer = StringBuffer(normalizedPath);
  if (rawQuery.isNotEmpty) {
    buffer
      ..write('?')
      ..write(rawQuery);
  }
  if (normalizedFragment != null) {
    buffer
      ..write('#')
      ..write(normalizedFragment);
  }

  return buffer.toString();
}

String _normalizeRoutePath(String value) {
  final pathOnly = _normalizePathOnly(value);
  if (pathOnly.isEmpty) {
    return '';
  }

  final loginSegment = _loginPath();
  final loginSegmentIndex = pathOnly.indexOf(loginSegment);
  if (loginSegmentIndex > 0) {
    return pathOnly.substring(loginSegmentIndex);
  }

  return pathOnly;
}

String _normalizePathOnly(String value) {
  final trimmedValue = value.trim();
  if (trimmedValue.isEmpty) {
    return '';
  }

  final route = trimmedValue.startsWith('/') ? trimmedValue : '/$trimmedValue';
  final pathOnly = route.split('?').first;
  if (pathOnly.isEmpty) {
    return '';
  }

  return pathOnly;
}

String _loginPath() => _normalizePathOnly(AppRoutePaths.login);

bool _isLoginPath(String normalizedPath) {
  final loginPath = _loginPath();
  return loginPath.isNotEmpty &&
      (normalizedPath == loginPath || normalizedPath.startsWith('$loginPath/'));
}
