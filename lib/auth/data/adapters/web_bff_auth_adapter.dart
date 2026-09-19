import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_client_ports.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';

/// Transport contract for the browser BFF session.
///
/// Implementations own the HTTP details and must send requests with browser
/// credentials enabled. A transport must never return an OAuth access or
/// refresh token to this adapter. The contract deliberately does not contain
/// URLs because those belong to the published backend OpenAPI contract.
abstract interface class WebBffSessionTransport {
  Future<AuthUser?> restoreSession();

  Future<AuthUser> signIn(LoginCredentials credentials);

  Future<void> signOut();
}

/// Seam do otwarcia BFF authorization w bieżącej przeglądarce.
///
/// Implementacja hosta nawiguje top-level window do URI `/bff/auth/start`.
/// Nie przekazuje tokenów do Fluttera ani nie używa embedded WebView. Po
/// prawdziwym redirectcie nowy bootstrap odtwarza sesję z cookie.
// Kept as an interface so host/platform adapters stay typed and injectable.
abstract interface class WebBffBrowserLauncher {
  /// Whether [open] returns to the current Flutter document.
  ///
  /// A real top-level redirect returns through a fresh bootstrap, so it is
  /// false. Injectable test launchers may return true to exercise the
  /// post-navigation contract without leaving the test process.
  bool get returnsAfterNavigation;

  Future<void> open(Uri authorizationUri);
}

/// Produkcyjny transport sesji webowej dla backendowego BFF DevPlanner.
///
/// Transport korzysta wyłącznie z cookies przeglądarki oraz synchronizera
/// CSRF obsługiwanego przez [DevPlannerHttpTransport]. Profil użytkownika jest
/// pobierany z autorytatywnego `/api/v1/me`; odpowiedź BFF nie jest używana do
/// odtwarzania loginu ani uprawnień.
final class HttpWebBffSessionTransport implements WebBffSessionTransport {
  HttpWebBffSessionTransport({
    required DevPlannerHttpTransport httpTransport,
    required this.browserLauncher,
    this.returnTo = '/workspaces',
  }) : _httpTransport = _requireBffTransport(httpTransport);

  final DevPlannerHttpTransport _httpTransport;

  /// Launcher dostarczony przez hosta webowego; nie zna żadnych tokenów.
  final WebBffBrowserLauncher browserLauncher;

  /// Bezpieczna wewnętrzna ścieżka po powrocie z BFF.
  final String returnTo;

  @override
  Future<AuthUser?> restoreSession() async {
    final session = await _httpTransport.execute(
      const DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.get,
        path: '/bff/session',
      ),
    );
    if (session.statusCode == 401 || session.statusCode == 403) return null;
    if (session.statusCode != 200 || session.body is! Map) {
      throw _failureFromResponse(session, 'auth.bff.session_unavailable');
    }

    final sessionBody = _stringKeyedMap(session.body!);
    if (sessionBody['authenticated'] != true ||
        sessionBody['csrfTokenAvailable'] != true) {
      // Brak cookie CSRF oznacza niekompletną sesję BFF. Nie próbujemy
      // wykonywać dalszych żądań i nie pokazujemy anonimowych danych.
      return null;
    }

    final profile = await _httpTransport.execute(
      const DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.get,
        path: '/api/v1/me',
      ),
    );
    if (profile.statusCode == 401 || profile.statusCode == 403) return null;
    if (profile.statusCode != 200 || profile.body is! Map) {
      throw _failureFromResponse(profile, 'auth.bff.profile_unavailable');
    }
    return _userFromProfile(_stringKeyedMap(profile.body!));
  }

  @override
  Future<AuthUser> signIn(LoginCredentials _) async {
    final path = AuthReturnTo.sanitize(returnTo) ?? '/workspaces';
    final uri = Uri.parse(_httpTransport.baseUrl)
        .resolve('/bff/auth/start')
        .replace(queryParameters: {'returnTo': path});
    await browserLauncher.open(uri);
    if (!browserLauncher.returnsAfterNavigation) {
      throw const AuthFailure(
        'Trwa przekierowanie do logowania BFF.',
        code: 'auth.bff.redirect_started',
      );
    }
    final user = await restoreSession();
    if (user == null) {
      throw const AuthFailure(
        'Logowanie BFF nie ustanowiło kompletnej sesji.',
        code: 'auth.bff.session_unavailable',
      );
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    final response = await _httpTransport.execute(
      const DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.post,
        path: '/bff/auth/logout',
      ),
    );
    // 401 oznacza, że sesja była już nieważna; lokalny stan może bezpiecznie
    // przejść do signed-out. Pozostałe błędy są jawnie zgłaszane.
    if (response.statusCode != 200 &&
        response.statusCode != 204 &&
        response.statusCode != 401) {
      throw _failureFromResponse(response, 'auth.bff.logout_failed');
    }
  }

  static DevPlannerHttpTransport _requireBffTransport(
    DevPlannerHttpTransport transport,
  ) {
    if (!transport.isBffCookieTransport) {
      throw StateError(
        'HttpWebBffSessionTransport wymaga transportu BFF/cookie bez beareru.',
      );
    }
    return transport;
  }

  static AuthUser _userFromProfile(Map<String, Object?> profile) {
    final userId = _requiredString(profile, 'userId');
    final login = _requiredString(profile, 'login');
    final displayName = _requiredString(profile, 'displayName');
    return AuthUser(
      userId: userId,
      login: login,
      displayName: displayName,
      permissions: _stringSet(profile['permissions']),
    );
  }

  static String _requiredString(Map<String, Object?> body, String key) {
    final value = body[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    throw const AuthFailure(
      'Backend zwrócił niekompletny profil użytkownika.',
      code: 'auth.bff.profile_invalid',
    );
  }

  static Set<String> _stringSet(Object? value) {
    if (value is! List) return <String>{};
    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet();
  }

  static Map<String, Object?> _stringKeyedMap(Object body) {
    if (body is! Map) {
      throw const AuthFailure(
        'Backend zwrócił nieprawidłową odpowiedź sesji.',
        code: 'auth.bff.response_invalid',
      );
    }
    return <String, Object?>{
      for (final entry in body.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }

  static AuthFailure _failureFromResponse(
    DevPlannerHttpResponse response,
    String fallbackCode,
  ) {
    final body = response.body;
    if (body is Map) {
      final map = _stringKeyedMap(body);
      final message = map['message'];
      final code = map['code'];
      if (message is String && message.trim().isNotEmpty) {
        return AuthFailure(
          message.trim(),
          code: code is String && code.trim().isNotEmpty
              ? code.trim()
              : fallbackCode,
        );
      }
    }
    return AuthFailure(
      'Nie udało się ustanowić sesji DevPlanner.',
      code: fallbackCode,
    );
  }
}

/// Web adapter for the local DevPlanner BFF.
///
/// The adapter only forwards the typed session operations. Cookies remain
/// owned by the browser/BFF boundary; no token is cached by Flutter, Hive or
/// browser storage.
final class WebBffAuthAdapter implements WebBffAuthPort {
  WebBffAuthAdapter({required this._transport});

  final WebBffSessionTransport _transport;

  @override
  AuthClientKind get clientKind => AuthClientKind.webBff;

  @override
  Future<AuthUser?> restoreSession() => _transport.restoreSession();

  @override
  Future<AuthUser> signIn(LoginCredentials credentials) =>
      _transport.signIn(credentials);

  @override
  Future<void> signOut() => _transport.signOut();
}

/// Explicit fail-closed transport for a web build without a published BFF
/// contract. It is useful as the default composition until the backend
/// adapter is wired and makes accidental endpoint invention impossible.
final class UnavailableWebBffSessionTransport
    implements WebBffSessionTransport {
  const UnavailableWebBffSessionTransport();

  AuthFailure get _unavailable => const AuthFailure(
    'Sesja BFF DevPlanner nie jest jeszcze skonfigurowana.',
    code: 'auth.bff.unavailable',
  );

  @override
  Future<AuthUser?> restoreSession() async => null;

  @override
  Future<AuthUser> signIn(LoginCredentials credentials) async =>
      throw _unavailable;

  @override
  Future<void> signOut() async {}
}
