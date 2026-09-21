/// Sposób grupowania kolumn tablicy Kanban.
///
/// Grupowanie jest osobistą preferencją widoku, a nie ustawieniem projektu:
/// przełączenie kolumn w jednym projekcie nie może zmienić tablicy innych osób.
enum TasksBoardGrouping {
  /// Kolumny odpowiadają statusom workflow projektu.
  status('status'),

  /// Kolumny odpowiadają osobom: Nieprzypisane, bieżący użytkownik, pozostali.
  assignee('assignee');

  const TasksBoardGrouping(this.wireValue);

  /// Wartość zapisywana w lokalnej preferencji.
  final String wireValue;

  /// Odczytuje zapis preferencji; nieznana wartość oznacza grupowanie po statusie.
  static TasksBoardGrouping fromWire(String? value) =>
      value == assignee.wireValue ? assignee : status;
}
