import 'package:devplanner/foundation/secure_storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Native implementation for Windows, macOS and Linux secure stores.
///
/// The plugin is only imported by the `dart.library.io` branch. It is never
/// selected by Flutter Web, where the stub fails closed.
final class PlatformSecureSecretStore implements SecureSecretStore {
  PlatformSecureSecretStore({FlutterSecureStorage? storage})
    // The macOS data-protection keychain requires a signed entitlement that
    // is not available when the app is launched directly from a Flutter
    // debug runner. Use the regular native Keychain in that case; it remains
    // encrypted by macOS and works for both VS Code and packaged builds.
    : _storage =
          storage ??
          const FlutterSecureStorage(
            mOptions: MacOsOptions(usesDataProtectionKeychain: false),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
