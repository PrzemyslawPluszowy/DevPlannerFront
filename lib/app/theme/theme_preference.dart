import 'package:flutter/material.dart';

/// Jedyny zapamiętywany wybór wyglądu standalone DevPlanner.
enum DevPlannerThemePreference {
  light,
  dark;

  ThemeMode get themeMode => switch (this) {
    DevPlannerThemePreference.light => ThemeMode.light,
    DevPlannerThemePreference.dark => ThemeMode.dark,
  };

  DevPlannerThemePreference get toggled => switch (this) {
    DevPlannerThemePreference.light => DevPlannerThemePreference.dark,
    DevPlannerThemePreference.dark => DevPlannerThemePreference.light,
  };
}

/// Port persistence preferencji wyglądu, niezależny od widgetów i platformy.
abstract interface class ThemePreferenceStore {
  Future<DevPlannerThemePreference> read();

  Future<void> write(DevPlannerThemePreference preference);
}
