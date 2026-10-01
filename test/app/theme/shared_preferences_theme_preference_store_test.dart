import 'package:devplanner/app/theme/shared_preferences_theme_preference_store.dart';
import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const key = 'devplanner.theme-preference';
  final store = SharedPreferencesThemePreferenceStore();

  test('brak albo nierozpoznany zapis używa motywu systemu', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await store.read(), DevPlannerThemePreference.system);
    SharedPreferences.setMockInitialValues({key: 'obsolete'});
    expect(await store.read(), DevPlannerThemePreference.system);
  });

  test(
    'zachowuje jawny wybór i pozwala zapamiętać powrót do systemu',
    () async {
      SharedPreferences.setMockInitialValues({key: 'dark'});
      expect(await store.read(), DevPlannerThemePreference.dark);
      await store.write(DevPlannerThemePreference.light);
      expect(await store.read(), DevPlannerThemePreference.light);
      await store.write(DevPlannerThemePreference.system);
      expect(await store.read(), DevPlannerThemePreference.system);
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString(key), 'system');
    },
  );
}
