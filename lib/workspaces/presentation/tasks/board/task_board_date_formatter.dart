/// Formatuje daty prezentowane przez widoki tablicy bez wprowadzania funkcji
/// globalnej do biblioteki ekranu.
final class TaskBoardDateFormatter {
  const TaskBoardDateFormatter._();

  static String format(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
