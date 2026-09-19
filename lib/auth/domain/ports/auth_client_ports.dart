import 'package:devplanner/auth/domain/models/auth_models.dart';

/// Client-side authentication boundary selected by the host platform.
///
/// Web implementations keep the session in an HttpOnly BFF cookie. Desktop
/// implementations use the system browser and PKCE; neither implementation
/// exposes an access token to presentation code.
abstract interface class AuthClientPort {
  AuthClientKind get clientKind;

  Future<AuthUser?> restoreSession();

  Future<void> signOut();
}

/// Web BFF contract. The browser owns only the cookie session and CSRF flow;
/// credentials and cookies are handled by the future backend adapter.
abstract interface class WebBffAuthPort implements AuthClientPort {
  Future<AuthUser> signIn(LoginCredentials credentials);
}

/// Desktop system-browser Code + PKCE contract.
abstract interface class DesktopPkceAuthPort implements AuthClientPort {
  Future<AuthUser> authorizeInteractively();

  Future<Uri> beginAuthorization({required Uri callbackUri});

  Future<AuthUser> completeAuthorization({
    required String code,
    required String state,
  });
}

/// OS secure-vault boundary for a desktop refresh credential.
///
/// This interface intentionally has no Hive, browser-storage, or file-backed
/// implementation in the frontend until the backend and platform contracts
/// are published.
abstract interface class SecureRefreshTokenVault {
  Future<String?> read();

  Future<void> write(String refreshToken);

  Future<void> clear();
}
