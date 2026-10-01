import 'package:bloc/bloc.dart';
import 'package:devplanner/app/theme/theme_preference.dart';

/// Właściciel systemowego albo jawnego motywu dla całej aplikacji.
///
/// Błąd lokalnego storage nie może blokować startu ani zmienić potwierdzonego
/// motywu — aplikacja zachowuje ustawienie systemowe.
final class ThemePreferenceCubit extends Cubit<DevPlannerThemePreference> {
  ThemePreferenceCubit(this._store) : super(DevPlannerThemePreference.system);

  final ThemePreferenceStore _store;
  int _selectionVersion = 0;

  Future<void> load() async {
    final selectionVersion = _selectionVersion;
    try {
      final preference = await _store.read();
      if (!isClosed && selectionVersion == _selectionVersion) emit(preference);
    } catch (_) {
      // Brak lokalnego storage nie jest błędem domeny ani powodem blank page.
    }
  }

  Future<bool> select(DevPlannerThemePreference preference) async {
    final selectionVersion = ++_selectionVersion;
    try {
      await _store.write(preference);
      if (isClosed || selectionVersion != _selectionVersion) return false;
      emit(preference);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggle() => select(state.toggled);
}
