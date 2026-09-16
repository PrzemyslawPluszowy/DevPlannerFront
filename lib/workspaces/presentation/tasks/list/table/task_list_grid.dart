import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';

/// Stałe wymiary i szerokości kolumn tabeli zadań.
///
/// Używane zarówno przez nagłówek tabeli, jak i wszystkie wiersze danych,
/// zapewniając idealne wyrównanie komórek w siatce arkusza.
abstract final class TaskListGrid {
  /// Szerokość kolumny zaznaczenia i ikony przeciągania.
  static const selection = 72.0;

  /// Szerokość kolumny klucza zadania (np. PROJ-123).
  static const key = 108.0;

  /// Domyślna szerokość kolumny tytułu zadania z drzewem hierarchii.
  static const task = 300.0;

  /// Szerokość kolumny statusu standardowego i własnego.
  static const status = 148.0;

  /// Szerokość kolumny priorytetu zadania.
  static const priority = 116.0;

  /// Szerokość kolumny osoby przypisanej / właściciela.
  static const assignee = 166.0;

  /// Szerokość kolumn z datami (termin, data rozpoczęcia, data utworzenia).
  static const dueDate = 144.0;

  /// Szerokość kolumny postępu checklisty.
  static const progress = 92.0;

  /// Szerokość kolumn metryk (rozmiar, złożoność, ryzyko, estymaty).
  static const metric = 108.0;

  /// Szerokość kolumny typu zadania.
  static const taskType = 132.0;

  /// Szerokość kolumny etykiet.
  static const labels = 180.0;

  /// Szerokość kolumny kamienia milowego.
  static const milestone = 140.0;

  /// Szerokość kolumny pola niestandardowego.
  static const customField = 160.0;

  /// Szerokość kolumny akcji wiersza (menu z prawej strony).
  static const actions = 52.0;

  /// Minimalna szerokość kolumny przy ręcznym zmienianiu rozmiaru.
  static const minResizableWidth = 72.0;

  /// Maksymalna szerokość kolumny przy ręcznym zmienianiu rozmiaru.
  static const maxResizableWidth = 560.0;

  /// Zwraca bazową szerokość dla danej kolumny widoku.
  static double width(TaskSavedViewColumn column) => switch (column) {
    TaskSavedViewColumn.key => key,
    TaskSavedViewColumn.title => task,
    TaskSavedViewColumn.status => status,
    TaskSavedViewColumn.customStatus => status,
    TaskSavedViewColumn.priority => priority,
    TaskSavedViewColumn.assignees => assignee,
    TaskSavedViewColumn.owner => assignee,
    TaskSavedViewColumn.collaborators => assignee,
    TaskSavedViewColumn.labels => labels,
    TaskSavedViewColumn.milestone => milestone,
    TaskSavedViewColumn.watchers => 96.0,
    TaskSavedViewColumn.dueAtUtc => dueDate,
    TaskSavedViewColumn.checklistProgress => progress,
    TaskSavedViewColumn.updatedAtUtc => dueDate,
    TaskSavedViewColumn.startAtUtc => dueDate,
    TaskSavedViewColumn.createdAtUtc => dueDate,
    TaskSavedViewColumn.taskType => taskType,
    TaskSavedViewColumn.size ||
    TaskSavedViewColumn.complexity ||
    TaskSavedViewColumn.risk ||
    TaskSavedViewColumn.businessValue ||
    TaskSavedViewColumn.estimatedMinutes ||
    TaskSavedViewColumn.actualMinutes => metric,
  };
}

/// Domyślny zestaw pól, gdy użytkownik nie ma zapisanego widoku.
const defaultTaskListColumns = <TaskSavedViewColumn>[
  TaskSavedViewColumn.title,
  TaskSavedViewColumn.status,
  TaskSavedViewColumn.priority,
  TaskSavedViewColumn.owner,
  TaskSavedViewColumn.collaborators,
  TaskSavedViewColumn.labels,
  TaskSavedViewColumn.milestone,
  TaskSavedViewColumn.dueAtUtc,
  TaskSavedViewColumn.checklistProgress,
];

/// Filtruje i waliduje listę widocznych kolumn, gwarantując obecność tytułu.
List<TaskSavedViewColumn> taskListVisibleColumns(
  List<TaskSavedViewColumn> columns,
) {
  const supported = <TaskSavedViewColumn>{
    TaskSavedViewColumn.key,
    TaskSavedViewColumn.title,
    TaskSavedViewColumn.status,
    TaskSavedViewColumn.customStatus,
    TaskSavedViewColumn.priority,
    TaskSavedViewColumn.assignees,
    TaskSavedViewColumn.owner,
    TaskSavedViewColumn.collaborators,
    TaskSavedViewColumn.labels,
    TaskSavedViewColumn.milestone,
    TaskSavedViewColumn.watchers,
    TaskSavedViewColumn.startAtUtc,
    TaskSavedViewColumn.dueAtUtc,
    TaskSavedViewColumn.checklistProgress,
    TaskSavedViewColumn.updatedAtUtc,
    TaskSavedViewColumn.createdAtUtc,
    TaskSavedViewColumn.taskType,
    TaskSavedViewColumn.size,
    TaskSavedViewColumn.complexity,
    TaskSavedViewColumn.risk,
    TaskSavedViewColumn.businessValue,
    TaskSavedViewColumn.estimatedMinutes,
    TaskSavedViewColumn.actualMinutes,
  };
  final result = <TaskSavedViewColumn>[];
  for (final column in columns) {
    if (supported.contains(column) && !result.contains(column)) {
      result.add(column);
    }
  }
  if (!result.contains(TaskSavedViewColumn.title)) {
    result.insert(0, TaskSavedViewColumn.title);
  }
  return result;
}
