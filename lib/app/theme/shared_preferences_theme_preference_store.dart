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
      _ => DevPlannerThemePreference.light,
    };
  }

  @override
  Future<void> write(DevPlannerThemePreference preference) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, preference.name);
  }
}
