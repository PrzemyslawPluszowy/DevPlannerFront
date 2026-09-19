import 'package:devplanner/auth/data/adapters/desktop_pkce_auth_adapter.dart';
import 'package:devplanner/auth/data/adapters/secure_refresh_token_vault.dart';
import 'package:devplanner/auth/data/adapters/web_bff_auth_adapter.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_client_ports.dart';
import 'package:devplanner/auth/domain/ports/auth_gateway.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/auth/domain/use_cases/auth_use_cases.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';

/// Auth composition for the current frontend slice.
///
/// Composition root auth dla standalone DevPlanner.
///
/// Domyślna kompozycja pozostaje niedostępna. Produkcyjne warianty mogą być
/// złożone tylko z jawnego BFF/cookie albo desktopowego PKCE + OS vault; żaden
/// wariant nie tworzy token store w Hive ani browser storage.
final class AuthComposition {
  AuthComposition({
    required this.session,
    required this.useCases,
    this.client,
    this.desktopAccessTokenProvider,
    this.desktopUnauthorizedRecovery,
  });

  /// Kompozycja webowa oparta wyłącznie o sesję BFF w cookie.
  ///
  /// [httpTransport] musi być transportem webowym bez bearer tokenu ani
  /// secure vaultu. [browserLauncher] jest jedynym seamem do rozpoczęcia
  /// redirectu `/bff/auth/start`; aplikacja nie implementuje OIDC w UI.
  factory AuthComposition.webBff({
    required DevPlannerHttpTransport httpTransport,
    required WebBffBrowserLauncher browserLauncher,
    String returnTo = '/workspaces',
  }) {
    final transport = HttpWebBffSessionTransport(
      httpTransport: httpTransport,
      browserLauncher: browserLauncher,
      returnTo: returnTo,
    );
    return AuthComposition.fromWebBff(transport);
  }

  /// Składa webową kompozycję z wcześniej zweryfikowanego transportu BFF.
  factory AuthComposition.fromWebBff(WebBffSessionTransport transport) {
    return AuthComposition.fromClient(WebBffAuthAdapter(transport: transport));
  }

  /// Kompozycja desktopowa oparta o Authorization Code + PKCE.
  ///
  /// Transport posiada callback systemowej przeglądarki i wymianę code po
  /// stronie adaptera. Refresh credential pozostaje wyłącznie w OS vault.
  factory AuthComposition.desktopPkce({
    required DesktopPkceSessionTransport transport,
    SecureRefreshTokenVault? vault,
  }) {
    return AuthComposition.fromDesktopPkce(
      transport: transport,
      vault: vault,
    );
  }

  /// Składa desktopową kompozycję z hostowego transportu PKCE i OS vaultu.
  factory AuthComposition.fromDesktopPkce({
    required DesktopPkceSessionTransport transport,
    SecureRefreshTokenVault? vault,
  }) {
    final session = AuthSessionController();
    final adapter = DesktopPkceAuthAdapter(
      transport: transport,
      vault: vault ?? PlatformSecureRefreshTokenVault(),
      onSessionExpired: session.setSignedOut,
    );
    return AuthComposition.fromClient(
      adapter,
      sessionController: session,
      desktopAccessTokenProvider: adapter.validAccessToken,
      desktopUnauthorizedRecovery: adapter.recoverAfterUnauthorized,
    );
  }

  /// Składa wspólny gateway i sesję z jednego, platformowego portu auth.
  ///
  /// Host może użyć tej ścieżki dla własnego, zweryfikowanego adaptera bez
  /// dodawania tokenów do warstwy presentation.
  factory AuthComposition.fromClient(
    AuthClientPort client, {
    AuthSessionController? sessionController,
    Future<String?> Function()? desktopAccessTokenProvider,
    Future<String?> Function(String? failedAccessToken)?
    desktopUnauthorizedRecovery,
  }) {
    final session = sessionController ?? AuthSessionController();
    return AuthComposition(
      session: session,
      useCases: AuthUseCases(
        gateway: _ClientAuthGateway(client),
        session: session,
        clientKind: client.clientKind,
      ),
      client: client,
      desktopAccessTokenProvider: desktopAccessTokenProvider,
      desktopUnauthorizedRecovery: desktopUnauthorizedRecovery,
    );
  }

  factory AuthComposition.unavailable() {
    final session = AuthSessionController();
    return AuthComposition(
      session: session,
      useCases: AuthUseCases(
        gateway: const UnavailableAuthGateway(),
        session: session,
      ),
    );
  }

  final AuthSessionController session;
  final AuthUseCases useCases;

  /// Opcjonalny, typowany port platformowy używany przez hosta bootstrapu.
  /// Nie udostępnia tokenów i nie powinien być przekazywany do widgetów.
  final AuthClientPort? client;

  /// Internal composition seam for desktop REST and SignalR only.
  final Future<String?> Function()? desktopAccessTokenProvider;

  /// Internal recovery seam paired with [desktopAccessTokenProvider].
  final Future<String?> Function(String? failedAccessToken)?
  desktopUnauthorizedRecovery;
}

/// Minimalny gateway łączący platformowy port sesji z use cases.
///
/// Operacje lifecycle konta pozostają niedostępne, dopóki backendowy kontrakt
/// i UX tych operacji nie zostaną dostarczone przez osobny adapter.
final class _ClientAuthGateway implements AuthGateway {
  const _ClientAuthGateway(this._client);

  final AuthClientPort _client;

  @override
  Future<AuthUser?> restoreSession() => _client.restoreSession();

  @override
  Future<AuthUser> signIn(LoginCredentials credentials) {
    final client = _client;
    if (client is WebBffAuthPort) return client.signIn(credentials);
    if (client is DesktopPkceAuthPort) return client.authorizeInteractively();
    throw const AuthFailure(
      'Logowanie desktopowe wymaga systemowej przeglądarki i PKCE.',
      code: 'auth.pkce.interactive_required',
    );
  }

  @override
  Future<void> signOut() => _client.signOut();

  @override
  Future<void> activate({required String token, required String password}) =>
      _unsupported('auth.activation.unavailable');

  @override
  Future<void> requestPasswordReset(String loginOrEmail) =>
      _unsupported('auth.recovery.unavailable');

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) => _unsupported('auth.recovery.unavailable');

  @override
  Future<void> verifyMfa(String code) => _unsupported('auth.mfa.unavailable');

  Future<void> _unsupported(String code) async {
    throw AuthFailure(
      'Ta operacja auth nie jest skonfigurowana w aplikacji DevPlanner.',
      code: code,
    );
  }
}
