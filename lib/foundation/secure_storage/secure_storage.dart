/// Capability boundary for secrets held by a platform secure vault.
///
/// Implementations belong in platform adapters. This port intentionally has
/// no Hive/web-storage implementation and is not exposed to presentation.
abstract interface class SecureSecretStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}
