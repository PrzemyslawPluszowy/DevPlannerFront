import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:devplanner/app/theme/theme_preference_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domyślnie zachowuje jasny motyw, gdy storage zawiedzie', () async {
    final cubit = ThemePreferenceCubit(_ThemePreferenceStore(fails: true));
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, DevPlannerThemePreference.light);
  });

  test('odczytuje i zapisuje wyłącznie wariant jasny albo ciemny', () async {
    final store = _ThemePreferenceStore(
      current: DevPlannerThemePreference.dark,
    );
    final cubit = ThemePreferenceCubit(store);
    addTearDown(cubit.close);

    await cubit.load();
    final saved = await cubit.toggle();

    expect(saved, isTrue);
    expect(cubit.state, DevPlannerThemePreference.light);
    expect(store.current, DevPlannerThemePreference.light);
  });

  test('nie publikuje niepotwierdzonego wyboru po błędzie zapisu', () async {
    final cubit = ThemePreferenceCubit(_ThemePreferenceStore(fails: true));
    addTearDown(cubit.close);

    final saved = await cubit.select(DevPlannerThemePreference.dark);

    expect(saved, isFalse);
    expect(cubit.state, DevPlannerThemePreference.light);
  });
}

final class _ThemePreferenceStore implements ThemePreferenceStore {
  _ThemePreferenceStore({
    this.current = DevPlannerThemePreference.light,
    this.fails = false,
  });

  DevPlannerThemePreference current;
  final bool fails;

  @override
  Future<DevPlannerThemePreference> read() async {
    if (fails) throw StateError('storage unavailable');
    return current;
  }

  @override
  Future<void> write(DevPlannerThemePreference preference) async {
    if (fails) throw StateError('storage unavailable');
    current = preference;
  }
}
