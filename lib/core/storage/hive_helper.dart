import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ready_next/core/storage/hive_registrar.g.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';

part 'hive_helper.g.dart';

/// Pomocnik inicjalizujący lokalny storage Hive CE.
class HiveHelper {
  /// Tworzy singleton pomocnika Hive.
  factory HiveHelper() => _instance;

  /// Prywatny konstruktor singletona.
  HiveHelper._internal();

  static final HiveHelper _instance = HiveHelper._internal();
  static final Map<String, Future<Box<dynamic>>> _openBoxes = {};

  /// Inicjalizuje Hive CE i rejestruje wszystkie adaptery aplikacji.
  static Future<void> init() async {
    await Hive.initFlutter('ready_next');
    Hive.registerAdapters();
  }

  /// Otwiera wskazany box i współdzieli jego instancję między repozytoriami.
  static Future<Box<T>> openBox<T>(String name) async {
    final existing = _openBoxes[name];
    if (existing != null) {
      return (await existing) as Box<T>;
    }

    final future = Hive.openBox<T>(name);
    _openBoxes[name] = future;
    return future;
  }

  /// Zamyka wskazany box i usuwa go z lokalnego cache helpera.
  static Future<void> closeBox(String name) async {
    final future = _openBoxes.remove(name);
    if (future == null) {
      return;
    }

    final box = await future;
    if (box.isOpen) {
      await box.close();
    }
  }

  /// Zamyka wszystkie boxy zarzadzane przez helper i czysci lokalny cache.
  static Future<void> closeAllBoxes() async {
    final names = _openBoxes.keys.toList(growable: false);
    for (final name in names) {
      await closeBox(name);
    }
  }
}

@GenerateAdapters([
  AdapterSpec<DashboardPreferences>(),
  AdapterSpec<DashboardShortcutPreference>(),
  AdapterSpec<DashboardWidgetPreference>(),
  AdapterSpec<DashboardStartupModule>(),
  AdapterSpec<LocalSettingsModel>(),
  AdapterSpec<AppThemePalette>(),
  AdapterSpec<AppThemeSeedColor>(),
  AdapterSpec<AppLanguage>(),
  AdapterSpec<ThemeMode>(),
], firstTypeId: 41)
// To jest punkt wejścia dla generatora adapterów Hive CE.
// ignore: unused_element
void _() {}
