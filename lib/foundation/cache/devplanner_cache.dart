import 'dart:convert';

import 'package:devplanner/core/storage/hive_helper.dart';
import 'package:hive_ce/hive.dart';

/// Stable namespaces that may be persisted by standalone DevPlanner.
///
/// Auth credentials are intentionally absent. This prevents a cache caller
/// from treating the generic cache as a session/token store by construction.
enum DevPlannerCacheScope {
  profile,
  workspaceSummary,
  notificationPreferences,
  chatDraft,
  uiPreferences,
}

/// Namespaced key for a non-secret cache entry.
final class DevPlannerCacheKey {
  DevPlannerCacheKey({
    required this.userId,
    required this.scope,
    required this.entryId,
  }) {
    _validatePart(userId, 'userId');
    _validatePart(entryId, 'entryId');
  }

  final String userId;
  final DevPlannerCacheScope scope;
  final String entryId;

  String get storageKey =>
      'v$schemaVersion|${_encode(userId)}|${scope.name}|${_encode(entryId)}';

  static const schemaVersion = 1;

  static void _validatePart(String value, String name) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, name, 'must not be empty');
    }
    if (value.contains('|')) {
      throw ArgumentError.value(value, name, 'must not contain |');
    }
  }

  String _encode(String value) => Uri.encodeComponent(value.trim());
}

/// JSON-safe, non-secret cache document.
final class DevPlannerCacheDocument {
  DevPlannerCacheDocument({
    required this.schemaVersion,
    required Map<String, Object?> data,
    DateTime? savedAt,
  }) : data = Map.unmodifiable(Map<String, Object?>.from(data)),
       savedAt = savedAt ?? DateTime.now().toUtc() {
    if (schemaVersion != DevPlannerCacheKey.schemaVersion) {
      throw ArgumentError.value(schemaVersion, 'schemaVersion');
    }
    _CachePayloadGuard.validate(this.data);
  }

  factory DevPlannerCacheDocument.decode(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Cache document must be a JSON object.');
    }
    final schema = decoded['schemaVersion'];
    final data = decoded['data'];
    final savedAtRaw = decoded['savedAt'];
    if (schema is! int || data is! Map<String, dynamic>) {
      throw const FormatException('Cache document has an invalid shape.');
    }
    if (schema != DevPlannerCacheKey.schemaVersion) {
      throw const FormatException('Cache document has an unsupported version.');
    }
    final savedAt = savedAtRaw is String ? DateTime.tryParse(savedAtRaw) : null;
    if (savedAt == null) {
      throw const FormatException('Cache document has an invalid timestamp.');
    }
    return DevPlannerCacheDocument(
      schemaVersion: schema,
      data: data,
      savedAt: savedAt.toUtc(),
    );
  }

  final int schemaVersion;
  final Map<String, Object?> data;
  final DateTime savedAt;

  String encode() => jsonEncode({
    'schemaVersion': schemaVersion,
    'savedAt': savedAt.toUtc().toIso8601String(),
    'data': data,
  });
}

/// Storage boundary for the standalone non-secret cache.
abstract interface class DevPlannerCacheStore {
  Future<DevPlannerCacheDocument?> read(DevPlannerCacheKey key);

  Future<void> write(DevPlannerCacheKey key, Map<String, Object?> data);

  Future<void> delete(DevPlannerCacheKey key);

  Future<void> clearUser(String userId);

  Future<void> close();
}

/// Hive-backed cache using a DevPlanner-only box and versioned values.
///
/// The adapter reads exactly one owned box (`devplanner_cache_v1`) and never
/// performs migration, fallback or lookup in any legacy-service box.
final class HiveDevPlannerCacheStore implements DevPlannerCacheStore {
  HiveDevPlannerCacheStore({required this._box});

  static const boxName = 'devplanner_cache_v1';

  /// Opens the only box owned by this adapter.
  static Future<HiveDevPlannerCacheStore> open() async =>
      HiveDevPlannerCacheStore(
        box: await HiveHelper.openBox<String>(boxName),
      );

  final Box<String> _box;

  @override
  Future<DevPlannerCacheDocument?> read(DevPlannerCacheKey key) async {
    final raw = _box.get(key.storageKey);
    if (raw == null) return null;
    try {
      return DevPlannerCacheDocument.decode(raw);
    } on FormatException {
      // Corrupt/stale cache is disposable; callers must fetch fresh data.
      await _box.delete(key.storageKey);
      return null;
    }
  }

  @override
  Future<void> write(DevPlannerCacheKey key, Map<String, Object?> data) async {
    final document = DevPlannerCacheDocument(
      schemaVersion: DevPlannerCacheKey.schemaVersion,
      data: data,
    );
    await _box.put(key.storageKey, document.encode());
  }

  @override
  Future<void> delete(DevPlannerCacheKey key) => _box.delete(key.storageKey);

  @override
  Future<void> clearUser(String userId) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }
    final prefix =
        'v${DevPlannerCacheKey.schemaVersion}|'
        '${Uri.encodeComponent(userId.trim())}|';
    final keys = _box.keys
        .whereType<String>()
        .where((key) => key.startsWith(prefix))
        .toList(growable: false);
    await _box.deleteAll(keys);
  }

  @override
  Future<void> close() => HiveHelper.closeBox(boxName);
}

/// Validates that the generic cache cannot silently become a secret store.
abstract final class _CachePayloadGuard {
  static const _forbiddenFieldFragments = <String>{
    'access_token',
    'accesstoken',
    'refresh_token',
    'refreshtoken',
    'password',
    'secret',
    'client_secret',
  };

  static void validate(Object? value, [String path = r'$']) {
    if (value is Map) {
      for (final entry in value.entries) {
        if (entry.key is! String) {
          throw ArgumentError('Cache map keys must be strings at $path.');
        }
        final key = (entry.key as String).trim().toLowerCase();
        if (_forbiddenFieldFragments.any(key.contains)) {
          throw ArgumentError(
            'Secret-like cache field is not allowed: $path.$key',
          );
        }
        validate(entry.value, '$path.$key');
      }
      return;
    }
    if (value is Iterable) {
      var index = 0;
      for (final item in value) {
        validate(item, '$path[$index]');
        index++;
      }
      return;
    }
    if (value == null || value is String || value is num || value is bool) {
      return;
    }
    throw ArgumentError('Cache value at $path is not JSON-safe.');
  }
}
