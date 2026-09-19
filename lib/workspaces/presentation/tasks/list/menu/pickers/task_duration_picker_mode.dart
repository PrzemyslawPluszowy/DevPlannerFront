/// Klasyfikuje opis pickera czasu bez mieszania tej decyzji z widokiem.
final class TaskDurationPickerMode {
  const TaskDurationPickerMode._();

  static bool isActual(String title) =>
      title.toLowerCase().contains('rzeczywisty') ||
      title.toLowerCase().contains('logged');
}
