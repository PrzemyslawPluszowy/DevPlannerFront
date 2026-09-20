/// Lokalna preferencja widoku modułu Zadania dla pary workspace/projekt.
///
/// Kontrakt posługuje się tokenem widoku z adresu (`?view=`), więc warstwa
/// domenowa nie zna enumu prezentacji i nie tworzy drugiego słownika widoków.
/// Brak wpisu oznacza brak preferencji, a nie „Lista” — wtedy o widoku
/// rozstrzyga trasa.
///
/// Odczyt jest synchroniczny, bo trasa musi wybrać widok przed pierwszą
/// klatką: `/tasks` nie może mrugać Listą, gdy użytkownik pracuje w Kanbanie.
/// Zapisywanie i wczytanie całości należy do [load] i [write].
abstract interface class TasksProjectViewPreferenceStore {
  /// Widok zapisany dla pary workspace/projekt albo `null`.
  ///
  /// Zwraca wyłącznie wartości wczytane przez [load]; nie wykonuje I/O.
  String? viewFor({required String workspaceId, required String projectId});

  /// Wczytuje zapisane preferencje do pamięci podręcznej.
  ///
  /// Wywoływane raz przy starcie klienta. Awaria persistence nie jest błędem
  /// aplikacji: preferencja pozostaje wtedy pusta i obowiązuje widok domyślny.
  Future<void> load();

  /// Zapisuje wybór użytkownika.
  ///
  /// Zapis jest best-effort: porażka nie może wywrócić modułu Zadania, więc
  /// implementacja raportuje ją diagnostycznie i kończy bez wyjątku.
  Future<void> write({
    required String workspaceId,
    required String projectId,
    required String view,
  });
}
