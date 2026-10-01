import 'dart:async';

import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:devplanner/app/theme/theme_preference_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domyślnie zachowuje systemowy motyw, gdy storage zawiedzie', () async {
    final cubit = ThemePreferenceCubit(_ThemePreferenceStore(fails: true));
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, DevPlannerThemePreference.system);
  });

  test('odczytuje i zapisuje jawny wariant jasny albo ciemny', () async {
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
    expect(cubit.state, DevPlannerThemePreference.system);
  });

  test('późny odczyt nie nadpisuje wyboru użytkownika', () async {
    final store = _DelayedReadStore();
    final cubit = ThemePreferenceCubit(store);
    addTearDown(cubit.close);
    final loading = cubit.load();
    expect(await cubit.select(DevPlannerThemePreference.light), isTrue);
    store.pendingRead.complete(DevPlannerThemePreference.dark);
    await loading;
    expect(cubit.state, DevPlannerThemePreference.light);
  });
}

final class _DelayedReadStore implements ThemePreferenceStore {
  final pendingRead = Completer<DevPlannerThemePreference>();

  @override
  Future<DevPlannerThemePreference> read() => pendingRead.future;

  @override
  Future<void> write(DevPlannerThemePreference preference) async {}
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
