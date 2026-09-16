import 'package:hive_ce/hive_ce.dart';
import 'package:ready_next/core/storage/hive_helper.dart';

/// Surowy zestaw danych sesji odczytany z trwałego storage.
class StoredAuthSession {
  const StoredAuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.userJson,
    this.rememberedUsername,
  });

  final String accessToken;
  final String refreshToken;
  final String? userJson;
  final String? rememberedUsername;
}

/// Abstrakcja trwałego storage dla danych sesji auth.
abstract class AuthSessionStorage {
  Future<StoredAuthSession?> read();

  Future<String?> readRememberedUsername();

  Future<void> write({
    required String accessToken,
    required String refreshToken,
    String? userJson,
  });

  Future<void> writeRememberedUsername(String username);

  Future<void> clear();
}

/// Prosta implementacja storage sesji auth oparta o `Hive CE`.
class HiveAuthSessionStorage implements AuthSessionStorage {
  /// Tworzy storage sesji oparty o wspólny box Hive.
  HiveAuthSessionStorage();

  static const _boxName = 'auth_session';
  static const _accessTokenKey = 'standalone_access_token';
  static const _refreshTokenKey = 'standalone_refresh_token';
  static const _userKey = 'standalone_user';
  static const _rememberedUsernameKey = 'remembered_username';

  Future<Box<dynamic>> _box() => HiveHelper.openBox<dynamic>(_boxName);

  @override
  Future<StoredAuthSession?> read() async {
    final box = await _box();
    final accessToken = (box.get(_accessTokenKey) as String? ?? '').trim();
    final refreshToken = (box.get(_refreshTokenKey) as String? ?? '').trim();
    final userJson = (box.get(_userKey) as String?)?.trim();
    final rememberedUsername = (box.get(_rememberedUsernameKey) as String?)
        ?.trim();

    if (accessToken.isEmpty &&
        refreshToken.isEmpty &&
        (userJson == null || userJson.isEmpty) &&
        (rememberedUsername == null || rememberedUsername.isEmpty)) {
      return null;
    }

    return StoredAuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userJson: userJson == null || userJson.isEmpty ? null : userJson,
      rememberedUsername:
          rememberedUsername == null || rememberedUsername.isEmpty
          ? null
          : rememberedUsername,
    );
  }

  @override
  Future<String?> readRememberedUsername() async {
    final box = await _box();
    final username = (box.get(_rememberedUsernameKey) as String?)?.trim();
    return switch (username) {
      final value? when value.isNotEmpty => value,
      _ => null,
    };
  }

  @override
  Future<void> write({
    required String accessToken,
    required String refreshToken,
    String? userJson,
  }) async {
    final box = await _box();
    await box.put(_accessTokenKey, accessToken);
    await box.put(_refreshTokenKey, refreshToken);
    if (userJson == null || userJson.trim().isEmpty) {
      await box.delete(_userKey);
      return;
    }
    await box.put(_userKey, userJson);
  }

  @override
  Future<void> writeRememberedUsername(String username) async {
    final normalizedUsername = username.trim();
    final box = await _box();
    if (normalizedUsername.isEmpty) {
      await box.delete(_rememberedUsernameKey);
      return;
    }
    await box.put(_rememberedUsernameKey, normalizedUsername);
  }

  @override
  Future<void> clear() async {
    final box = await _box();
    await box.delete(_accessTokenKey);
    await box.delete(_refreshTokenKey);
    await box.delete(_userKey);
  }
}
