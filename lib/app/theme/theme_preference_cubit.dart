import 'package:bloc/bloc.dart';
import 'package:devplanner/app/theme/theme_preference.dart';

/// Właściciel wyboru jasnego albo ciemnego motywu dla całej aplikacji.
///
/// Błąd lokalnego storage nie może blokować startu ani zmienić potwierdzonego
/// motywu — aplikacja zachowuje bezpieczny, jasny wariant domyślny.
final class ThemePreferenceCubit extends Cubit<DevPlannerThemePreference> {
  ThemePreferenceCubit(this._store) : super(DevPlannerThemePreference.light);

  final ThemePreferenceStore _store;

  Future<void> load() async {
    try {
      final preference = await _store.read();
      if (!isClosed) emit(preference);
    } catch (_) {
      // Brak lokalnego storage nie jest błędem domeny ani powodem blank page.
    }
  }

  Future<bool> select(DevPlannerThemePreference preference) async {
    if (state == preference) return true;
    try {
      await _store.write(preference);
      if (isClosed) return false;
      emit(preference);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggle() => select(state.toggled);
}
