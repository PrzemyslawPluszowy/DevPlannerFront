import 'package:devplanner/foundation/http/devplanner_http_transport.dart';

/// Nazwa nagłówka synchronizacyjnego wymaganego przez negotiate SignalR w Web.
///
/// Wartość musi pozostać zgodna z `BffOptions.CsrfHeaderName` w backendzie.
const String workspaceRealtimeCsrfHeaderName = 'X-DevPlanner-CSRF';

/// Rozwiązany materiał handshake'u SignalR dla jednej sesji.
///
/// Desktop używa access tokenu odnawianego przed każdym handshake'em; Web używa
/// nagłówka CSRF przy negotiate, a samo połączenie autoryzuje cookie `HttpOnly`.
final class WorkspaceRealtimeHandshake {
  /// Tworzy materiał handshake'u.
  const WorkspaceRealtimeHandshake({
    this.accessTokenProvider,
    this.headers = const <String, String>{},
  });

  /// Provider access tokenu albo `null`, gdy sesję utrzymuje cookie.
  final Future<String?> Function()? accessTokenProvider;

  /// Nagłówki żądania negotiate.
  final Map<String, String> headers;

  /// Czy materiał pochodzi z tokenu, a nie z cookie przeglądarki.
  bool get usesBearer => accessTokenProvider != null;
}

/// Poświadczenia transportu realtime jednej sesji.
///
/// Jedno źródło sesji oznacza, że poświadczenia pochodzą z tego samego
/// transportu HTTP co REST: desktop z providera sesji PKCE, a Web z cookie BFF
/// i tokenu CSRF. Kod Flutter Web nigdy nie odczytuje access ani refresh tokenu.
sealed class WorkspaceRealtimeCredentials {
  const WorkspaceRealtimeCredentials();

  /// Poświadczenia desktopowe oparte o access token.
  factory WorkspaceRealtimeCredentials.bearer(
    Future<String?> Function() tokenProvider,
  ) = WorkspaceRealtimeBearerCredentials;

  /// Poświadczenia przeglądarkowe oparte o cookie BFF i token CSRF.
  factory WorkspaceRealtimeCredentials.bffCookie(
    Future<String?> Function() csrfTokenProvider,
  ) = WorkspaceRealtimeCookieCredentials;

  /// Wybiera poświadczenia odpowiadające sesji transportu albo `null`, gdy
  /// transport nie ma zaufanego poświadczenia dla tej platformy.
  static WorkspaceRealtimeCredentials? fromTransport(
    DevPlannerHttpTransport transport,
  ) {
    if (transport.isBffCookieTransport) {
      return WorkspaceRealtimeCredentials.bffCookie(
        transport.getRealtimeCsrfToken,
      );
    }
    final tokenProvider = transport.realtimeAccessTokenProvider;
    return tokenProvider == null
        ? null
        : WorkspaceRealtimeCredentials.bearer(tokenProvider);
  }

  /// Rozwiązuje materiał handshake'u.
  ///
  /// Rzuca [StateError], gdy sesja nie ma poświadczenia; połączenie nie może
  /// wtedy powstać anonimowo, a reconnect nie może wpaść w pętlę prób.
  Future<WorkspaceRealtimeHandshake> resolve();
}

/// Poświadczenia desktopowe: access token z sesji PKCE.
final class WorkspaceRealtimeBearerCredentials
    extends WorkspaceRealtimeCredentials {
  /// Tworzy poświadczenia z providerem access tokenu.
  const WorkspaceRealtimeBearerCredentials(this._tokenProvider);

  final Future<String?> Function() _tokenProvider;

  /// Pobiera token i odmawia startu bez aktywnej sesji.
  @override
  Future<WorkspaceRealtimeHandshake> resolve() async {
    final token = (await _tokenProvider())?.trim() ?? '';
    if (token.isEmpty) {
      throw StateError('Nie można uruchomić SignalR bez aktywnej sesji.');
    }
    // Provider pozostaje w handshake'u, żeby SignalR odświeżał token przy
    // kolejnych handshake'ach po reconnect.
    return WorkspaceRealtimeHandshake(accessTokenProvider: _tokenProvider);
  }
}

/// Poświadczenia przeglądarkowe: cookie BFF oraz nagłówek CSRF.
final class WorkspaceRealtimeCookieCredentials
    extends WorkspaceRealtimeCredentials {
  /// Tworzy poświadczenia z providerem tokenu CSRF.
  const WorkspaceRealtimeCookieCredentials(this._csrfTokenProvider);

  final Future<String?> Function() _csrfTokenProvider;

  /// Pobiera token CSRF i odmawia startu bez aktywnej sesji BFF.
  @override
  Future<WorkspaceRealtimeHandshake> resolve() async {
    final csrf = (await _csrfTokenProvider())?.trim() ?? '';
    if (csrf.isEmpty) {
      throw StateError(
        'Nie można uruchomić SignalR bez tokenu CSRF aktywnej sesji.',
      );
    }
    return WorkspaceRealtimeHandshake(
      headers: <String, String>{workspaceRealtimeCsrfHeaderName: csrf},
    );
  }
}
