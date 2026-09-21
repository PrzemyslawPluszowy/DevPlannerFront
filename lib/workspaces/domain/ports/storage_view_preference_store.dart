import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';

/// Trwała preferencja widoku modułu Pliki, kluczowana użytkownikiem i zakresem.
///
/// Kontrakt posługuje się identyfikatorem zakresu, a nie enumem prezentacji:
/// warstwa domenowa nie musi znać trasy, a zakresy, które nie są jeszcze trasami,
/// nie wymagają zmiany portu.
///
/// Odczyt jest synchroniczny, bo trasa musi wybrać widok przed pierwszą klatką —
/// wejście w katalog nie może mrugać Listą, gdy użytkownik pracuje w Siatce.
/// Wczytywanie i zapisywanie należy do [load] i [write].
abstract interface class StorageViewPreferenceStore {
  /// Preferencja zapisana dla zakresu albo `null`, gdy jej nie ma.
  ///
  /// Zwraca wyłącznie wartości wczytane przez [load]; nie wykonuje I/O.
  StorageViewPreference? preferenceFor({required String scopeKey});

  /// Wczytuje zapisane preferencje do pamięci podręcznej.
  ///
  /// Wywoływane po ustaleniu tożsamości użytkownika. Awaria persistence nie jest
  /// błędem aplikacji: preferencja pozostaje wtedy pusta i obowiązują wartości
  /// domyślne.
  Future<void> load();

  /// Zapisuje preferencję zakresu.
  ///
  /// Zapis jest best-effort i serializowany: porażka nie może wywrócić modułu
  /// Pliki, a szybka zmiana dwóch ustawień nie może zgubić pierwszej z nich.
  Future<void> write({
    required String scopeKey,
    required StorageViewPreference preference,
  });
}
