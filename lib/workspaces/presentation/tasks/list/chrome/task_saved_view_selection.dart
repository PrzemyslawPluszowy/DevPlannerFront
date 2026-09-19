import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/task_saved_views_export.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Aktywny zapisany widok Listy: to samo źródło dla wiersza poleceń i treści.
final class TaskSavedViewSelection {
  const TaskSavedViewSelection({
    required this.savedViewId,
    required this.groupBy,
    required this.columns,
    required this.customFieldIds,
    required this.columnOrder,
  });

  /// Czyta bieżący widok z [TaskSavedViewsCubit]; poza hostem listy zwraca
  /// wartości domyślne, więc widgety Listy zostają samodzielne.
  factory TaskSavedViewSelection.of(
    BuildContext context, {
    required bool hasCustomWorkflow,
  }) => TaskSavedViewSelection._from(
    hasCustomWorkflow: hasCustomWorkflow,
    state: context.watch<TaskSavedViewsCubit?>()?.state,
  );

  /// Wariant dla `initState`, bez subskrypcji na cubit widoków.
  factory TaskSavedViewSelection.read(
    BuildContext context, {
    required bool hasCustomWorkflow,
  }) => TaskSavedViewSelection._from(
    hasCustomWorkflow: hasCustomWorkflow,
    state: context.read<TaskSavedViewsCubit?>()?.state,
  );

  factory TaskSavedViewSelection._from({
    required bool hasCustomWorkflow,
    required TaskSavedViewsState? state,
  }) {
    final defaultGroupBy = hasCustomWorkflow
        ? TaskSavedViewGroupBy.customStatus
        : TaskSavedViewGroupBy.status;
    final savedViewsState = state;
    if (savedViewsState is! TaskSavedViewsReady) {
      return TaskSavedViewSelection(
        savedViewId: null,
        groupBy: defaultGroupBy,
        columns: defaultTaskListColumns,
        customFieldIds: const [],
        columnOrder: null,
      );
    }
    final activeId = savedViewsState.activeViewId;
    final savedView = savedViewsState.views
        .where((item) => item.id == activeId)
        .firstOrNull;
    return TaskSavedViewSelection(
      savedViewId: activeId,
      groupBy: savedView?.view.groupBy ?? defaultGroupBy,
      columns: savedView?.view.columns ?? defaultTaskListColumns,
      customFieldIds: savedView?.view.customFieldIds ?? const [],
      columnOrder: savedView?.view.columnOrder,
    );
  }

  final String? savedViewId;
  final TaskSavedViewGroupBy groupBy;
  final List<TaskSavedViewColumn> columns;
  final List<String> customFieldIds;
  final List<String>? columnOrder;
}
