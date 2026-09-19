import 'package:devplanner/foundation/secure_storage/secure_storage.dart';

/// Web/non-IO implementation. Browser storage is intentionally not a secure
/// vault for OAuth credentials, so every operation fails closed.
final class PlatformSecureSecretStore implements SecureSecretStore {
  PlatformSecureSecretStore();

  UnsupportedError get _unavailable => UnsupportedError(
    'DevPlanner secure refresh-token storage is unavailable on this platform.',
  );

  @override
  Future<String?> read(String key) async => throw _unavailable;

  @override
  Future<void> write(String key, String value) async => throw _unavailable;

  @override
  Future<void> delete(String key) async => throw _unavailable;
}
