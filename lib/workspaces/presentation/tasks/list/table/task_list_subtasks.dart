import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/inline_create/task_list_inline_create.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_header.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

const List<TaskSavedViewColumn> subtaskTableColumns = [
  TaskSavedViewColumn.title,
  TaskSavedViewColumn.status,
  TaskSavedViewColumn.priority,
  TaskSavedViewColumn.assignees,
  TaskSavedViewColumn.dueAtUtc,
];

/// Tabela podzadań rozwijana pod zadaniem rodzicem.
class TaskListSubtaskTable extends StatefulWidget {
  const TaskListSubtaskTable({
    required this.parent,
    required this.groupKey,
    required this.subtasks,
    required this.hasMore,
    required this.rowBuilder,
    super.key,
    this.columns = subtaskTableColumns,
    this.columnReferences,
    this.columnWidths = const {},
    this.columnWidthsById = const {},
    this.onColumnWidthDelta,
    this.onColumnWidthDeltaById,
    this.onColumnResizeStart,
    this.onColumnResizeUpdate,
    this.onColumnResizeEnd,
    this.errorMessage,
    this.startAdding = false,
    this.onStartAddingHandled,
  });

  final ProjectTaskListItemResponse parent;
  final String groupKey;
  final List<ProjectTaskListItemResponse> subtasks;
  final bool hasMore;
  final String? errorMessage;
  final bool startAdding;
  final VoidCallback? onStartAddingHandled;
  final Widget Function(ProjectTaskListItemResponse task) rowBuilder;
  final List<TaskSavedViewColumn> columns;
  final List<TaskColumnReference>? columnReferences;
  final Map<TaskSavedViewColumn, double> columnWidths;
  final Map<String, double> columnWidthsById;
  final void Function(TaskSavedViewColumn column, double delta)?
  onColumnWidthDelta;
  final void Function(String columnId, double delta)? onColumnWidthDeltaById;
  final void Function(String columnId)? onColumnResizeStart;
  final void Function(String columnId, double delta)? onColumnResizeUpdate;
  final void Function(String columnId)? onColumnResizeEnd;

  @override
  State<TaskListSubtaskTable> createState() => _TaskListSubtaskTableState();
}

class _TaskListSubtaskTableState extends State<TaskListSubtaskTable> {
  final ValueNotifier<bool> _isAdding = ValueNotifier(false);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.startAdding) {
      _isAdding.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onStartAddingHandled?.call();
      });
    }
  }

  @override
  void didUpdateWidget(TaskListSubtaskTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.startAdding && widget.startAdding && !_isAdding.value) {
      _isAdding.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onStartAddingHandled?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _isAdding.dispose();
    super.dispose();
  }

  void _cancelAdding() {
    _controller.clear();
    _isAdding.value = false;
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      _cancelAdding();
      return;
    }
    _controller.clear();
    _isAdding.value = false;
    await context.read<ProjectTasksListCubit>().createSubtask(
      parent: widget.parent,
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const .only(left: 36, top: 6, bottom: 8),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLowest,
      borderRadius: const BorderRadius.all(.circular(8)),
      border: Border.all(
        color: context.colors.outlineVariant.withValues(alpha: .5),
      ),
    ),
    clipBehavior: .antiAlias,
    child: Column(
      mainAxisSize: .min,
      children: [
        TaskListTableHeader(
          columns: widget.columns,
          columnReferences: widget.columnReferences,
          columnWidths: widget.columnWidths,
          columnWidthsById: widget.columnWidthsById,
          onColumnWidthDelta: widget.onColumnWidthDelta,
          onColumnWidthDeltaById: widget.onColumnWidthDeltaById,
          onColumnResizeStart: widget.onColumnResizeStart,
          onColumnResizeUpdate: widget.onColumnResizeUpdate,
          onColumnResizeEnd: widget.onColumnResizeEnd,
          height: 36,
          allSelected: context
              .read<ProjectTasksListCubit>()
              .areLoadedSubtasksSelected(widget.parent.id),
          selectionTooltip: context.l10n.tasksSelectLoadedSubtasks,
          onToggleAll: (selected) =>
              context.read<ProjectTasksListCubit>().setLoadedSubtasksSelected(
                widget.parent.id,
                selected: selected,
              ),
        ),
        if (widget.subtasks.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: widget.subtasks.length,
            itemBuilder: (context, index) =>
                widget.rowBuilder(widget.subtasks[index]),
          ),
        if (widget.hasMore)
          SizedBox(
            height: 34,
            child: Align(
              alignment: .centerLeft,
              child: TextButton.icon(
                onPressed: () => unawaited(
                  context.read<ProjectTasksListCubit>().loadMoreSubtasks(
                    widget.parent,
                  ),
                ),
                icon: const Icon(Symbols.expand_more_rounded, size: 16),
                label: const Text('Pokaż kolejne podzadania'),
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.onSurfaceVariant,
                  visualDensity: .compact,
                ),
              ),
            ),
          ),
        if (widget.errorMessage case final error?)
          Container(
            width: double.infinity,
            height: 30,
            color: context.colors.errorContainer.withValues(alpha: .42),
            padding: const .symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  Symbols.error_outline_rounded,
                  size: 15,
                  color: context.colors.error,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Tooltip(
                    message: error,
                    child: Text(
                      error,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelSmall?.copyWith(
                        color: context.colors.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ValueListenableBuilder<bool>(
          valueListenable: _isAdding,
          builder: (context, isAdding, _) => isAdding
              ? TaskListInlineCreateRow(
                  controller: _controller,
                  hintText: 'Nazwa podzadania',
                  onCancel: _cancelAdding,
                  onSubmit: _submit,
                )
              : SizedBox(
                  height: 36,
                  child: Align(
                    alignment: .centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _isAdding.value = true,
                      icon: const Icon(Symbols.add_rounded, size: 16),
                      label: const Text('Dodaj podzadanie'),
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.onSurfaceVariant,
                        visualDensity: .compact,
                        padding: const .only(left: 12, right: 10),
                        textStyle: context.text.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}

/// Cel upuszczenia dla porządkowania podzadań w drzewie.
class TaskListSubtaskDropTarget extends StatelessWidget {
  const TaskListSubtaskDropTarget({
    required this.parent,
    required this.groupKey,
    required this.task,
    required this.child,
    super.key,
  });

  final ProjectTaskListItemResponse parent;
  final String groupKey;
  final ProjectTaskListItemResponse task;
  final Widget child;

  @override
  Widget build(BuildContext context) => DragTarget<ProjectTaskListItemResponse>(
    onWillAcceptWithDetails: (details) => details.data.id != task.id,
    onAcceptWithDetails: (details) {
      unawaited(
        context.read<ProjectTasksListCubit>().moveTask(
          task: details.data,
          targetGroupKey: groupKey,
          parentTaskId: parent.id,
          nextTaskId: task.id,
        ),
      );
    },
    builder: (context, candidates, _) => DecoratedBox(
      decoration: BoxDecoration(
        border: candidates.isEmpty
            ? null
            : Border(
                top: BorderSide(
                  color: context.colors.primary,
                  width: 2,
                ),
              ),
      ),
      child: child,
    ),
  );
}

/// Rysownik linii drzewa hierarchii podzadań.
class TaskListSubtaskTreePainter extends CustomPainter {
  const TaskListSubtaskTreePainter({
    required this.childCount,
    required this.color,
  });

  final int childCount;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (childCount == 0) return;
    final paint = Paint()
      ..color = color.withValues(alpha: .85)
      ..strokeWidth = 1.25
      ..style = PaintingStyle.stroke;
    const trunkX = 22.0;
    const tableX = TaskListGrid.selection;
    const headerHeight = 36.0;
    const rowHeight = 38.0;
    final lastCenter = headerHeight + (childCount - .5) * rowHeight;
    canvas.drawLine(const Offset(trunkX, 0), Offset(trunkX, lastCenter), paint);
    for (var index = 0; index < childCount; index++) {
      final center = headerHeight + (index + .5) * rowHeight;
      canvas.drawLine(
        Offset(trunkX, center),
        Offset(tableX, center),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(TaskListSubtaskTreePainter oldDelegate) =>
      oldDelegate.childCount != childCount || oldDelegate.color != color;
}
