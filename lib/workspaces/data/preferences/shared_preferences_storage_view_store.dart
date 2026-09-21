import 'dart:convert';

import 'package:devplanner/workspaces/domain/ports/storage_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lokalny adapter preferencji widoku modułu Pliki.
///
/// Klucz zawiera użytkownika i zakres, więc zmiana widoku w jednym zakresie nie
/// przestawia widoku w innym, a zmiana konta na tym samym urządzeniu nie
/// dziedziczy wyboru poprzedniej osoby. Preferencja pozostaje lokalna dla
/// klienta (jak motyw albo widok Zadania): nie jest danymi domenowymi i nie
/// wymaga żądania do Backendu.
///
/// Platforma bez implementacji `shared_preferences` (test widgetowy bez
/// inicjalizacji, build bez pluginu) zgłasza `FlutterError`, czyli `Error`,
/// a nie `Exception`. Ta granica zamienia każdą taką awarię na pusty stan
/// i wpis w logu diagnostycznym.
final class SharedPreferencesStorageViewStore
    implements StorageViewPreferenceStore {
  /// Tworzy adapter z tożsamością czytaną w momencie operacji.
  SharedPreferencesStorageViewStore({required this.currentUserId});

  static const _prefix = 'devplanner.files-view.';

  /// Tożsamość czytana w momencie operacji, a nie raz na starcie klienta.
  ///
  /// Dzięki temu wylogowanie i zalogowanie innego konta w tej samej sesji nie
  /// wymaga restartu, żeby preferencja przestała przeciekać.
  final String? Function() currentUserId;

  final Map<String, StorageViewPreference> _preferences =
      <String, StorageViewPreference>{};

  String? _loadedForUserId;

  /// Kolejka zapisów: dwie szybkie zmiany nie mogą wyprzedzić się w magazynie,
  /// bo ostatni zapis musiałby wtedy nadpisać nowszy stan starszym.
  Future<void> _pendingWrite = Future<void>.value();

  String _key(String userId, String scopeKey) => '$_prefix$userId.$scopeKey';

  String _userPrefix(String userId) => '$_prefix$userId.';

  @override
  StorageViewPreference? preferenceFor({required String scopeKey}) {
    final userId = currentUserId();
    if (userId == null) return null;
    // Cache innego konta nie może oddać cudzego wyboru; świeży zestaw wczytuje
    // właściciel sesji, a nie ten odczyt.
    if (_loadedForUserId != userId) return null;
    return _preferences[_key(userId, scopeKey)];
  }

  @override
  Future<void> load() async {
    final userId = currentUserId();
    if (userId == null) {
      _preferences.clear();
      _loadedForUserId = null;
      return;
    }
    try {
      final preferences = await SharedPreferences.getInstance();
      final userPrefix = _userPrefix(userId);
      _preferences.clear();
      for (final key in preferences.getKeys()) {
        if (!key.startsWith(userPrefix)) continue;
        final raw = preferences.getString(key);
        if (raw == null) continue;
        // Izolacja wpisów: jeden uszkodzony zapis nie może skasować
        // preferencji pozostałych zakresów użytkownika.
        try {
          final decoded = jsonDecode(raw);
          if (decoded is! Map) continue;
          _preferences[key] = StorageViewPreference.fromJson(
            decoded.cast<String, Object?>(),
          );
        } on Object catch (error) {
          _report('decode', error);
        }
      }
      _loadedForUserId = userId;
    } on Object catch (error) {
      _preferences.clear();
      _loadedForUserId = null;
      _report('load', error);
    }
  }

  @override
  Future<void> write({
    required String scopeKey,
    required StorageViewPreference preference,
  }) {
    final userId = currentUserId();
    if (userId == null) return Future<void>.value();
    final key = _key(userId, scopeKey);
    _preferences[key] = preference;
    _loadedForUserId = userId;
    return _pendingWrite = _pendingWrite.then(
      (_) => _persist(key, preference),
    );
  }

  Future<void> _persist(String key, StorageViewPreference preference) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(key, jsonEncode(preference.toJson()));
    } on Object catch (error) {
      _report('write', error);
    }
  }

  void _report(String operation, Object error) {
    if (kDebugMode) {
      debugPrint(
        '[files.view] preference $operation unavailable: ${error.runtimeType}',
      );
    }
  }
}
