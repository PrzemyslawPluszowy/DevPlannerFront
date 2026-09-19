/// Kanoniczny kontrakt widoku Tasks: `?view=`, zakładka i zaznaczenie menu.
///
/// Ten plik nie ma zależności, bo korzystają z niego zarówno moduł Tasks, jak i
/// shell. Jedno miejsce rozpoznaje widok z adresu i zapisuje go z powrotem, więc
/// deep link, refresh, historia przeglądarki i sidebar nie mogą wybrać innego
/// widoku niż ten, który wynika z URL.
enum TasksProjectView {
  board,
  list,
  timeline,
  workload,
  recurrence;

  /// Widok kanonicznego adresu `.../tasks` bez zapytania.
  static const TasksProjectView routeDefault = TasksProjectView.list;

  /// Wartość zapytania `?view=` opisująca ten widok.
  ///
  /// Kanban zachowuje historyczny `?view=kanban`, bo ten adres jest publicznym
  /// kontraktem deep linku, menu projektu i zapisanych widoków.
  String get queryValue => switch (this) {
    TasksProjectView.board => 'kanban',
    TasksProjectView.list => 'list',
    TasksProjectView.timeline => 'timeline',
    TasksProjectView.workload => 'workload',
    TasksProjectView.recurrence => 'recurrence',
  };

  /// Rozpoznaje widok z wartości zapytania `?view=`.
  ///
  /// `board` pozostaje aliasem wejściowym wewnętrznej nazwy Kanbanu, a wartość
  /// nierozpoznana i brak zapytania wracają do widoku domyślnego, żeby literówka
  /// w adresie nie przełączała użytkownika w losowy widok.
  static TasksProjectView fromQuery(String? value) =>
      switch (value?.trim().toLowerCase()) {
        'kanban' || 'board' => TasksProjectView.board,
        'list' => TasksProjectView.list,
        'timeline' => TasksProjectView.timeline,
        'workload' => TasksProjectView.workload,
        'recurrence' => TasksProjectView.recurrence,
        _ => routeDefault,
      };

  /// Nazwa parametru zapytania, który wybiera widok Tasks.
  static const String queryParameter = 'view';
}
