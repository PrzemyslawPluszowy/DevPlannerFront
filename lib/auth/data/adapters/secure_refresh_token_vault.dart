import 'package:devplanner/auth/data/adapters/platform_secure_secret_store_stub.dart'
    if (dart.library.io) 'package:devplanner/auth/data/adapters/platform_secure_secret_store_io.dart'
    as platform;
import 'package:devplanner/auth/domain/ports/auth_client_ports.dart';
import 'package:devplanner/foundation/secure_storage/secure_storage.dart';

/// Secure storage key namespace owned exclusively by DevPlanner auth.
final class DevPlannerAuthSecretKeys {
  const DevPlannerAuthSecretKeys._();

  static const refreshToken = 'devplanner.auth.refresh_token.v1';
}

/// Desktop refresh-token vault backed by the platform secure store.
///
/// The web conditional implementation is an explicit unavailable adapter and
/// never instantiates a browser-storage-backed secure-storage plugin. Passing
/// a [SecureSecretStore] makes the class deterministic in unit tests.
final class PlatformSecureRefreshTokenVault implements SecureRefreshTokenVault {
  PlatformSecureRefreshTokenVault({SecureSecretStore? store})
    : _store = store ?? platform.PlatformSecureSecretStore();

  final SecureSecretStore _store;

  @override
  Future<String?> read() => _store.read(DevPlannerAuthSecretKeys.refreshToken);

  @override
  Future<void> write(String refreshToken) async {
    final value = refreshToken.trim();
    if (value.isEmpty) {
      throw ArgumentError.value(refreshToken, 'refreshToken');
    }
    await _store.write(DevPlannerAuthSecretKeys.refreshToken, value);
  }

  @override
  Future<void> clear() => _store.delete(DevPlannerAuthSecretKeys.refreshToken);
}
