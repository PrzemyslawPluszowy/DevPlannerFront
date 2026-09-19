import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_client_ports.dart';

/// Token response from a completed Desktop PKCE exchange.
///
/// The result deliberately does not contain an application user. The adapter
/// must persist a rotated refresh token before making the separate `/me`
/// request, otherwise a temporary profile failure can strand the vault with a
/// refresh token that was already consumed by the authorization server.
final class DesktopTokenResult {
  const DesktopTokenResult({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final Duration expiresIn;
}

/// Backend/OIDC client boundary for a desktop system-browser flow.
///
/// The implementation owns the actual Authorization Code + PKCE protocol and
/// its in-memory access token. This frontend adapter only coordinates the
/// typed result with the secure vault; it does not implement OAuth itself.
abstract interface class DesktopPkceSessionTransport {
  Future<DesktopTokenResult> authorizeInteractively();

  Future<Uri> beginAuthorization({required Uri callbackUri});

  Future<DesktopTokenResult> completeAuthorization({
    required String code,
    required String state,
  });

  Future<DesktopTokenResult?> restoreSession({
    required String refreshToken,
  });

  /// Fetches the authoritative local profile using an in-memory access token.
  Future<AuthUser> fetchCurrentUser({required String accessToken});

  Future<void> revoke({required String refreshToken});
}

/// Desktop adapter coordinating the PKCE transport and OS secure vault.
final class DesktopPkceAuthAdapter implements DesktopPkceAuthPort {
  DesktopPkceAuthAdapter({
    required this._transport,
    required this._vault,
    DateTime Function()? now,
    this._onSessionExpired,
  }) : _now = now ?? (() => DateTime.now().toUtc());

  final DesktopPkceSessionTransport _transport;
  final SecureRefreshTokenVault _vault;
  final DateTime Function() _now;
  final void Function()? _onSessionExpired;
  Future<void> _vaultTail = Future<void>.value();
  bool _signedOut = false;
  String? _accessToken;
  DateTime? _accessTokenExpiresAt;
  DateTime? _accessTokenRefreshAt;
  Future<String?>? _refreshInFlight;
  int _sessionEpoch = 0;

  @override
  AuthClientKind get clientKind => AuthClientKind.desktopPkce;

  /// Provides only an in-memory access token for desktop API and SignalR.
  /// Concurrent callers share a single refresh-token rotation.
  Future<String?> validAccessToken() async {
    if (_signedOut) return null;
    final accessToken = _accessToken;
    final refreshAt = _accessTokenRefreshAt;
    if (accessToken != null &&
        refreshAt != null &&
        _now().isBefore(refreshAt)) {
      return accessToken;
    }
    final current = _refreshInFlight;
    if (current != null) return current;
    final refresh = _refreshAccessToken();
    _refreshInFlight = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_refreshInFlight, refresh)) _refreshInFlight = null;
    }
  }

  /// Forces one coordinated rotation only when [failedAccessToken] is still
  /// the token currently in use. A request that lost a rotation race simply
  /// receives the already-published replacement.
  Future<String?> recoverAfterUnauthorized(String? failedAccessToken) async {
    final current = _accessToken;
    if (current != null && current != failedAccessToken) {
      return validAccessToken();
    }
    _accessTokenRefreshAt = _now();
    return validAccessToken();
  }

  @override
  Future<AuthUser> authorizeInteractively() async {
    final epoch = _beginInteractive();
    final result = await _transport.authorizeInteractively();
    return _persistThenFetchProfile(result, epoch);
  }

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) =>
      _transport.beginAuthorization(callbackUri: callbackUri);

  @override
  Future<AuthUser> completeAuthorization({
    required String code,
    required String state,
  }) async {
    final epoch = _beginInteractive();
    final result = await _transport.completeAuthorization(
      code: code,
      state: state,
    );
    return _persistThenFetchProfile(result, epoch);
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final epoch = _sessionEpoch;
    final token = await validAccessToken();
    if (token == null) return null;
    final user = await _transport.fetchCurrentUser(accessToken: token);
    return epoch == _sessionEpoch ? user : null;
  }

  @override
  Future<void> signOut() async {
    // Invalidates an in-flight refresh before it can publish a newly rotated
    // token after an explicit logout.
    _sessionEpoch++;
    _signedOut = true;
    _accessToken = null;
    _accessTokenExpiresAt = null;
    _accessTokenRefreshAt = null;
    final refreshToken = await _withVault(() async {
      try {
        return await _vault.read();
      } finally {
        await _vault.clear();
      }
    });
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
    final failure = revokeFailure;
    final stack = revokeStack;
    if (failure != null && stack != null) {
      Error.throwWithStackTrace(failure, stack);
    }
  }

  Future<AuthUser> _persistThenFetchProfile(
    DesktopTokenResult result,
    int epoch,
  ) async {
    if (!await _persistAndActivate(result, epoch)) throw _cancelled;
    final user = await _transport.fetchCurrentUser(
      accessToken: result.accessToken,
    );
    if (epoch != _sessionEpoch) throw _cancelled;
    return user;
  }

  AuthFailure get _cancelled => const AuthFailure(
    'Logowanie zostało anulowane.',
    code: 'auth.session.cancelled',
  );

  int _beginInteractive() {
    _signedOut = false;
    _accessToken = null;
    _accessTokenExpiresAt = null;
    _accessTokenRefreshAt = null;
    _refreshInFlight = null;
    return ++_sessionEpoch;
  }

  Future<String?> _refreshAccessToken() async {
    final refreshEpoch = _sessionEpoch;
    final refreshToken = (await _withVault(_vault.read))?.trim();
    if (refreshEpoch != _sessionEpoch) return null;
    if (refreshToken == null || refreshToken.isEmpty) return null;
    final result = await _transport.restoreSession(refreshToken: refreshToken);
    if (refreshEpoch != _sessionEpoch) {
      if (result != null) await _revokeSilently(result.refreshToken);
      return null;
    }
    if (result == null) {
      _accessToken = null;
      _accessTokenExpiresAt = null;
      _accessTokenRefreshAt = null;
      await _withVault(() async {
        if (refreshEpoch != _sessionEpoch) return;
        _signedOut = true;
        _sessionEpoch++;
        _onSessionExpired?.call();
        await _vault.clear();
      });
      return null;
    }
    return await _persistAndActivate(result, refreshEpoch)
        ? result.accessToken
        : null;
  }

  Future<bool> _persistAndActivate(DesktopTokenResult result, int epoch) async {
    final refreshToken = result.refreshToken.trim();
    if (refreshToken.isEmpty) {
      throw const AuthFailure(
        'Serwer nie zwrócił poprawnego refresh tokenu.',
        code: 'auth.refresh_token.missing',
      );
    }

    // Persist before `/me`: the authorization server has already consumed the
    // presented credential and issued this replacement. A temporary profile
    // failure must not leave the vault with the old, unusable token.
    try {
      final active = await _withVault(() async {
        if (epoch != _sessionEpoch) return false;
        await _vault.write(refreshToken);
        return epoch == _sessionEpoch;
      });
      if (!active) {
        await _revokeSilently(refreshToken);
        return false;
      }
    } catch (_) {
      // The new credential cannot be used safely without durable local
      // storage. Best-effort remote revocation reduces the lifetime of that
      // otherwise orphaned token; no token value is exposed to callers.
      try {
        await _transport.revoke(refreshToken: refreshToken);
      } catch (_) {
        // The original vault failure is the actionable error. Remote revoke is
        // deliberately best effort because connectivity may be the cause.
      }
      rethrow;
    }

    if (epoch != _sessionEpoch) {
      await _revokeSilently(refreshToken);
      return false;
    }
    final now = _now();
    _accessToken = result.accessToken;
    _accessTokenExpiresAt = now.add(result.expiresIn);
    final refreshWindow = result.expiresIn < const Duration(seconds: 120)
        ? Duration(microseconds: result.expiresIn.inMicroseconds ~/ 2)
        : const Duration(seconds: 60);
    _accessTokenRefreshAt = _accessTokenExpiresAt!.subtract(refreshWindow);
    return true;
  }

  Future<T> _withVault<T>(Future<T> Function() operation) {
    final result = _vaultTail.then((_) => operation());
    _vaultTail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return result;
  }

  Future<void> _revokeSilently(String refreshToken) async {
    try {
      await _transport.revoke(refreshToken: refreshToken);
    } catch (_) {
      // Logout is already final locally; this is remote cleanup only.
    }
  }
}

/// Explicit fail-closed transport for a desktop build before its OIDC
/// contract and system-browser implementation are wired.
final class UnavailableDesktopPkceSessionTransport
    implements DesktopPkceSessionTransport {
  const UnavailableDesktopPkceSessionTransport();

  @override
  Future<DesktopTokenResult> authorizeInteractively() async =>
      throw _unavailable;

  AuthFailure get _unavailable => const AuthFailure(
    'Logowanie desktopowe PKCE DevPlanner nie jest jeszcze skonfigurowane.',
    code: 'auth.pkce.unavailable',
  );

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) async =>
      throw _unavailable;

  @override
  Future<DesktopTokenResult> completeAuthorization({
    required String code,
    required String state,
  }) async => throw _unavailable;

  @override
  Future<DesktopTokenResult?> restoreSession({
    required String refreshToken,
  }) async => throw _unavailable;

  @override
  Future<AuthUser> fetchCurrentUser({required String accessToken}) async =>
      throw _unavailable;

  @override
  Future<void> revoke({required String refreshToken}) async =>
      throw _unavailable;
}
