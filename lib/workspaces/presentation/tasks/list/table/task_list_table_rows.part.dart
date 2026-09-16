part of 'task_list_table.dart';

/// Intencja zaznaczenia wszystkich widocznych zadań skrótem klawiszowym.
class _SelectAllTasksIntent extends Intent {
  const _SelectAllTasksIntent();
}

/// Bazowy, uszczelniony model wiersza prezentowanego w widoku tabeli zadań.
sealed class _ListRow {
  const _ListRow();
}

/// Nagłówek grupy (np. statusu lub pola własnego) z licznikiem zadań.
final class _ListGroupHeader extends _ListRow {
  const _ListGroupHeader({
    required this.id,
    required this.label,
    required this.count,
    this.status,
  });

  final String id;
  final String label;
  final int count;
  final ProjectTaskStatus? status;
}

/// Nagłówek kolumn renderowany pod nagłówkiem danej grupy.
final class _ListGroupTableHeader extends _ListRow {
  const _ListGroupTableHeader(this.groupKey);

  final String groupKey;
}

/// Wiersz pojedynczego zadania nadrzędnego.
final class _ListTaskRow extends _ListRow {
  const _ListTaskRow(
    this.task, {
    required this.groupKey,
    this.isExpanded = false,
    this.isSubtasksLoading = false,
  });

  final ProjectTaskListItemResponse task;
  final String groupKey;
  final bool isExpanded;
  final bool isSubtasksLoading;
}

/// Wiersz zawierający zagnieżdżoną tabelę podzadań po rozwinięciu zadania nadrzędnego.
final class _ListSubtaskTable extends _ListRow {
  const _ListSubtaskTable({
    required this.parent,
    required this.subtasks,
    required this.groupKey,
    this.hasMore = false,
  });

  final ProjectTaskListItemResponse parent;
  final String groupKey;
  final List<ProjectTaskListItemResponse> subtasks;
  final bool hasMore;
}

/// Przycisk doczytania kolejnej strony zadań wewnątrz danej grupy.
final class _ListGroupLoadMore extends _ListRow {
  const _ListGroupLoadMore(this.groupKey);

  final String groupKey;
}

/// Formularz szybkiego dodawania nowego zadania bezpośrednio wewnątrz grupy.
final class _ListGroupInlineCreate extends _ListRow {
  const _ListGroupInlineCreate(this.groupKey);

  final String groupKey;
}
