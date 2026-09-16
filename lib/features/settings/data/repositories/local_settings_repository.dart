import 'package:ready_next/core/storage/hive_helper.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';

/// Repozytorium lokalnych ustawień aplikacji.
abstract class LocalSettingsRepository {
  /// Odczytuje zapisane ustawienia lokalne aplikacji.
  Future<LocalSettingsModel> getSettings();

  /// Zapisuje ustawienia lokalne aplikacji.
  Future<LocalSettingsModel> saveSettings(LocalSettingsModel settings);

  /// Aktualizuje ustawienia na podstawie bieżącego stanu.
  Future<LocalSettingsModel> updateSettings(
    LocalSettingsModel Function(LocalSettingsModel current) update,
  );

  /// Zamyka otwarte zasoby repozytorium.
  Future<void> close();
}

/// Implementacja repozytorium oparta o Hive CE.
class HiveLocalSettingsRepository implements LocalSettingsRepository {
  /// Tworzy repozytorium ustawień lokalnych.
  HiveLocalSettingsRepository();

  static const _boxName = 'local_settings_box';
  static const _settingsKey = 'app_settings';

  @override
  Future<LocalSettingsModel> getSettings() async {
    final box = await HiveHelper.openBox<LocalSettingsModel>(_boxName);
    final stored = box.get(_settingsKey);
    if (stored != null) {
      return _normalizeSettings(stored);
    }

    const defaults = LocalSettingsModel.defaults();
    await box.put(_settingsKey, defaults);
    return defaults;
  }

  @override
  Future<LocalSettingsModel> saveSettings(LocalSettingsModel settings) async {
    final normalized = _normalizeSettings(settings);
    final box = await HiveHelper.openBox<LocalSettingsModel>(_boxName);
    await box.put(_settingsKey, normalized);
    return normalized;
  }

  @override
  Future<LocalSettingsModel> updateSettings(
    LocalSettingsModel Function(LocalSettingsModel current) update,
  ) async {
    final current = await getSettings();
    return saveSettings(update(current));
  }

  @override
  Future<void> close() async {
    await HiveHelper.closeBox(_boxName);
  }

  LocalSettingsModel _normalizeSettings(LocalSettingsModel settings) {
    final normalizedOrders = <String, List<String>>{};
    final normalizedCollapsed = <String, bool>{};

    for (final entry in settings.sideMenuOrders.entries) {
      final menuId = entry.key.trim();
      if (menuId.isEmpty) {
        continue;
      }

      final seen = <String>{};
      final normalizedIds = <String>[];
      for (final rawId in entry.value) {
        final id = rawId.trim();
        if (id.isEmpty || !seen.add(id)) {
          continue;
        }
        normalizedIds.add(id);
      }

      if (normalizedIds.isNotEmpty) {
        normalizedOrders[menuId] = normalizedIds;
      }
    }

    for (final entry in settings.sideMenuCollapsed.entries) {
      final key = entry.key.trim();
      if (key.isNotEmpty) {
        normalizedCollapsed[key] = entry.value;
      }
    }

    return settings.copyWith(
      sideMenuOrders: normalizedOrders,
      sideMenuCollapsed: normalizedCollapsed,
      globalChatWidth: settings.globalChatWidth.clamp(320, 560).toDouble(),
      globalChatLastConversationId: _normalizedConversationId(
        settings.globalChatLastConversationId,
      ),
    );
  }

  String? _normalizedConversationId(String? conversationId) {
    final normalized = conversationId?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}
