import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:flutter/foundation.dart';

/// Niemutowalny snapshot reprezentujący pełną, bieżącą konfigurację widoku listy zadań.
///
/// Zawiera filtry, sortowanie, grupowanie, kolumny systemowe, identyfikatory
/// pól własnych oraz stabilny ciąg kolejności kolumn [columnOrder].
@immutable
final class TaskListViewSnapshot {
  /// Tworzy nowy niemutowalny snapshot konfiguracji widoku.
  TaskListViewSnapshot({
    required this.filter,
    required this.sortField,
    required this.sortDirection,
    required this.groupBy,
    required List<TaskSavedViewColumn> columns,
    required List<String> customFieldIds,
    required List<String> columnOrder,
  }) : columns = List.unmodifiable(columns),
       customFieldIds = List.unmodifiable(customFieldIds),
       columnOrder = List.unmodifiable(columnOrder);

  /// Tworzy snapshot bezpośrednio z kontraktu [TaskSavedViewDefinition].
  factory TaskListViewSnapshot.fromDefinition(TaskSavedViewDefinition def) {
    final effectiveColumnOrder =
        (def.columnOrder != null && def.columnOrder!.isNotEmpty)
        ? def.columnOrder!
        : [
            ...def.columns.map((c) => 'sys:${c.name}'),
            ...def.customFieldIds.map((id) => 'cf:$id'),
          ];
    return TaskListViewSnapshot(
      filter: def.filter,
      sortField: def.sortField,
      sortDirection: def.sortDirection,
      groupBy: def.groupBy,
      columns: def.columns,
      customFieldIds: def.customFieldIds,
      columnOrder: effectiveColumnOrder,
    );
  }

  /// Aktywne filtry listy zadań.
  final TaskSavedViewFilter filter;

  /// Wybrane pole sortowania.
  final TaskSavedViewSortField sortField;

  /// Kierunek sortowania.
  final TaskSavedViewSortDirection sortDirection;

  /// Sposób grupowania wierszy.
  final TaskSavedViewGroupBy groupBy;

  /// Lista widocznych kolumn systemowych.
  final List<TaskSavedViewColumn> columns;

  /// Lista identyfikatorów widocznych pól niestandardowych (custom fields).
  final List<String> customFieldIds;

  /// Stabilny ciąg identyfikatorów kolumn w kolejności wyświetlania (np. `sys:title`, `cf:id`).
  final List<String> columnOrder;

  /// Liczba aktywnych reguł filtrowania w tym snapshocie.
  int get activeFiltersCount {
    var count = 0;
    if (filter.statuses != null && filter.statuses!.isNotEmpty) count++;
    if (filter.priorities != null && filter.priorities!.isNotEmpty) count++;
    if (filter.assigneeUserIds != null && filter.assigneeUserIds!.isNotEmpty) {
      count++;
    }
    if (filter.labelIds != null && filter.labelIds!.isNotEmpty) count++;
    if (filter.parentTaskId != null && filter.parentTaskId!.isNotEmpty) count++;
    if (filter.myInvolvement != null) count++;
    if (filter.dueFromUtc != null || filter.dueToUtc != null) count++;
    if (filter.search != null && filter.search!.trim().isNotEmpty) count++;
    if (filter.pinnedOnly) count++;
    if (filter.includeArchived) count++;
    return count;
  }

  /// Konwertuje snapshot na kontrakt definicji widoku [TaskSavedViewDefinition].
  TaskSavedViewDefinition toDefinition() => TaskSavedViewDefinition(
    filter: filter,
    sortField: sortField,
    sortDirection: sortDirection,
    groupBy: groupBy,
    columns: List<TaskSavedViewColumn>.from(columns),
    customFieldIds: List<String>.from(customFieldIds),
    columnOrder: List<String>.from(columnOrder),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskListViewSnapshot) return false;
    return sortField == other.sortField &&
        sortDirection == other.sortDirection &&
        groupBy == other.groupBy &&
        _deepFilterEquals(filter, other.filter) &&
        listEquals(columns, other.columns) &&
        listEquals(customFieldIds, other.customFieldIds) &&
        listEquals(columnOrder, other.columnOrder);
  }

  @override
  int get hashCode => Object.hash(
    sortField,
    sortDirection,
    groupBy,
    _hashFilter(filter),
    Object.hashAll(columns),
    Object.hashAll(customFieldIds),
    Object.hashAll(columnOrder),
  );

  static bool _deepFilterEquals(
    TaskSavedViewFilter a,
    TaskSavedViewFilter b,
  ) =>
      listEquals(a.statuses, b.statuses) &&
      listEquals(a.priorities, b.priorities) &&
      listEquals(a.assigneeUserIds, b.assigneeUserIds) &&
      listEquals(a.labelIds, b.labelIds) &&
      a.parentTaskId == b.parentTaskId &&
      a.myInvolvement == b.myInvolvement &&
      a.dueFromUtc == b.dueFromUtc &&
      a.dueToUtc == b.dueToUtc &&
      (a.search?.trim().isEmpty ?? true
          ? (b.search?.trim().isEmpty ?? true)
          : a.search?.trim() == b.search?.trim()) &&
      a.includeArchived == b.includeArchived &&
      a.pinnedOnly == b.pinnedOnly;

  static int _hashFilter(TaskSavedViewFilter f) => Object.hash(
    f.statuses == null ? 0 : Object.hashAll(f.statuses!),
    f.priorities == null ? 0 : Object.hashAll(f.priorities!),
    f.assigneeUserIds == null ? 0 : Object.hashAll(f.assigneeUserIds!),
    f.labelIds == null ? 0 : Object.hashAll(f.labelIds!),
    f.parentTaskId,
    f.myInvolvement,
    f.dueFromUtc,
    f.dueToUtc,
    f.search?.trim(),
    f.includeArchived,
    f.pinnedOnly,
  );
}
