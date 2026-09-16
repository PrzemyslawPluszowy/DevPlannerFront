import 'package:flutter/foundation.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';

/// Roboczy model formularza konfiguracji zapisanego widoku zadań.
///
/// Używany w edytorze zapisanego widoku, zwalniający dialog z operowania na surowym JSON.
@immutable
final class TaskSavedViewDraft {
  /// Tworzy nowy szkic edycji zapisanego widoku.
  TaskSavedViewDraft({
    required this.name,
    required this.sortField,
    required this.sortDirection,
    required this.groupBy,
    required List<TaskSavedViewColumn> columns,
    required List<String> customFieldIds,
    required List<String> columnOrder,
    required this.filter,
  }) : columns = List.unmodifiable(columns),
       customFieldIds = List.unmodifiable(customFieldIds),
       columnOrder = List.unmodifiable(columnOrder);

  /// Tworzy szkic z istniejącej definicji i opcjonalnej nazwy.
  factory TaskSavedViewDraft.fromDefinition({
    required String name,
    required TaskSavedViewDefinition definition,
  }) {
    final effectiveOrder =
        (definition.columnOrder != null && definition.columnOrder!.isNotEmpty)
        ? definition.columnOrder!
        : [
            ...definition.columns.map((c) => 'sys:${c.name}'),
            ...definition.customFieldIds.map((id) => 'cf:$id'),
          ];
    return TaskSavedViewDraft(
      name: name,
      sortField: definition.sortField,
      sortDirection: definition.sortDirection,
      groupBy: definition.groupBy,
      columns: definition.columns,
      customFieldIds: definition.customFieldIds,
      columnOrder: effectiveOrder,
      filter: definition.filter,
    );
  }

  /// Nazwa widoku.
  final String name;

  /// Pole sortowania.
  final TaskSavedViewSortField sortField;

  /// Kierunek sortowania.
  final TaskSavedViewSortDirection sortDirection;

  /// Sposób grupowania wierszy.
  final TaskSavedViewGroupBy groupBy;

  /// Kolumny systemowe.
  final List<TaskSavedViewColumn> columns;

  /// Identyfikatory pól własnych.
  final List<String> customFieldIds;

  /// Kolejność kolumn.
  final List<String> columnOrder;

  /// Filtr zadań.
  final TaskSavedViewFilter filter;

  /// Kopiuje szkic z nadpisaniem wybranych pól.
  TaskSavedViewDraft copyWith({
    String? name,
    TaskSavedViewSortField? sortField,
    TaskSavedViewSortDirection? sortDirection,
    TaskSavedViewGroupBy? groupBy,
    List<TaskSavedViewColumn>? columns,
    List<String>? customFieldIds,
    List<String>? columnOrder,
    TaskSavedViewFilter? filter,
  }) => TaskSavedViewDraft(
    name: name ?? this.name,
    sortField: sortField ?? this.sortField,
    sortDirection: sortDirection ?? this.sortDirection,
    groupBy: groupBy ?? this.groupBy,
    columns: columns ?? this.columns,
    customFieldIds: customFieldIds ?? this.customFieldIds,
    columnOrder: columnOrder ?? this.columnOrder,
    filter: filter ?? this.filter,
  );

  /// Konwertuje szkic na [TaskSavedViewDefinition].
  TaskSavedViewDefinition toDefinition() => TaskSavedViewDefinition(
    filter: filter,
    sortField: sortField,
    sortDirection: sortDirection,
    groupBy: groupBy,
    columns: List<TaskSavedViewColumn>.from(columns),
    customFieldIds: List<String>.from(customFieldIds),
    columnOrder: List<String>.from(columnOrder),
  );
}
