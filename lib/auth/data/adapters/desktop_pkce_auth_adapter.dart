import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_client_ports.dart';

/// Result of a completed authorization-code exchange.
///
/// The refresh token is consumed by [DesktopPkceAuthAdapter] and is never
/// exposed to presentation or stored outside [SecureRefreshTokenVault].
final class DesktopAuthorizationResult {
  const DesktopAuthorizationResult({
    required this.user,
    required this.refreshToken,
  });

  final AuthUser user;
  final String refreshToken;
}

/// Backend/OIDC client boundary for a desktop system-browser flow.
///
/// The implementation owns the actual Authorization Code + PKCE protocol and
/// its in-memory access token. This frontend adapter only coordinates the
/// typed result with the secure vault; it does not implement OAuth itself.
abstract interface class DesktopPkceSessionTransport {
  Future<DesktopAuthorizationResult> authorizeInteractively();

  Future<Uri> beginAuthorization({required Uri callbackUri});

  Future<DesktopAuthorizationResult> completeAuthorization({
    required String code,
    required String state,
  });

  Future<DesktopAuthorizationResult?> restoreSession({
    required String refreshToken,
  });

  Future<void> revoke({required String refreshToken});
}

/// Desktop adapter coordinating the PKCE transport and OS secure vault.
final class DesktopPkceAuthAdapter implements DesktopPkceAuthPort {
  DesktopPkceAuthAdapter({
    required this._transport,
    required this._vault,
  });

  final DesktopPkceSessionTransport _transport;
  final SecureRefreshTokenVault _vault;

  @override
  AuthClientKind get clientKind => AuthClientKind.desktopPkce;

  @override
  Future<AuthUser> authorizeInteractively() async {
    final result = await _transport.authorizeInteractively();
    final refreshToken = result.refreshToken.trim();
    if (refreshToken.isEmpty) {
      throw const AuthFailure(
        'Serwer nie zwrócił poprawnego refresh tokenu.',
        code: 'auth.refresh_token.missing',
      );
    }
    await _vault.write(refreshToken);
    return result.user;
  }

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) =>
      _transport.beginAuthorization(callbackUri: callbackUri);

  @override
  Future<AuthUser> completeAuthorization({
    required String code,
    required String state,
  }) async {
    final result = await _transport.completeAuthorization(
      code: code,
      state: state,
    );
    final refreshToken = result.refreshToken.trim();
    if (refreshToken.isEmpty) {
      throw const AuthFailure(
        'Serwer nie zwrócił poprawnego refresh tokenu.',
        code: 'auth.refresh_token.missing',
      );
    }

    // A token that cannot be persisted must not become a usable session. The
    // vault error is intentionally propagated without a plaintext fallback.
    await _vault.write(refreshToken);
    return result.user;
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final refreshToken = (await _vault.read())?.trim();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }
    final result = await _transport.restoreSession(refreshToken: refreshToken);
    if (result == null) {
      // The transport returns null only when the authorization server has
      // rejected the credential as no longer usable. Removing that stale
      // secret prevents every subsequent desktop start from replaying it.
      await _vault.clear();
      return null;
    }
    await _vault.write(result.refreshToken);
    return result.user;
  }

  @override
  Future<void> signOut() async {
    final refreshToken = await _vault.read();
    Object? revokeFailure;
    StackTrace? revokeStack;
    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      try {
        await _transport.revoke(refreshToken: refreshToken);
      } catch (error, stack) {
        revokeFailure = error;
        revokeStack = stack;
      }
    }

    // Local revocation is always completed, even if the remote revoke failed.
    // Do not leave a reusable credential after an explicit sign-out.
    await _vault.clear();
    final failure = revokeFailure;
    final stack = revokeStack;
    if (failure != null && stack != null) {
      Error.throwWithStackTrace(failure, stack);
    }
  }
}

/// Explicit fail-closed transport for a desktop build before its OIDC
/// contract and system-browser implementation are wired.
final class UnavailableDesktopPkceSessionTransport
    implements DesktopPkceSessionTransport {
  const UnavailableDesktopPkceSessionTransport();

  @override
  Future<DesktopAuthorizationResult> authorizeInteractively() async =>
      throw _unavailable;

  AuthFailure get _unavailable => const AuthFailure(
    'Logowanie desktopowe PKCE DevPlanner nie jest jeszcze skonfigurowane.',
    code: 'auth.pkce.unavailable',
  );

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) async =>
      throw _unavailable;

  @override
  Future<DesktopAuthorizationResult> completeAuthorization({
    required String code,
    required String state,
  }) async => throw _unavailable;

  @override
  Future<DesktopAuthorizationResult?> restoreSession({required String refreshToken}) async =>
      throw _unavailable;

  @override
  Future<void> revoke({required String refreshToken}) async =>
      throw _unavailable;
}
