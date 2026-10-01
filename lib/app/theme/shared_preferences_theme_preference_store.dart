import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lokalny adapter persistence wyboru motywu dla klienta Flutter.
final class SharedPreferencesThemePreferenceStore
    implements ThemePreferenceStore {
  static const _key = 'devplanner.theme-preference';

  @override
  Future<DevPlannerThemePreference> read() async {
    final preferences = await SharedPreferences.getInstance();
    return switch (preferences.getString(_key)) {
      'dark' => DevPlannerThemePreference.dark,
      'light' => DevPlannerThemePreference.light,
      _ => DevPlannerThemePreference.system,
    };
  }

  @override
  Future<void> write(DevPlannerThemePreference preference) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_key, preference.name);
    if (!saved) throw StateError('Theme preference could not be saved');
  }
}
