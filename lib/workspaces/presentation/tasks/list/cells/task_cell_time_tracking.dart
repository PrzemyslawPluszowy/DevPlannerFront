import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_text_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Edytowalna komórka metryki liczbowej (rozmiar, złożoność, ryzyko, czas).
class TaskCellMetric extends StatelessWidget {
  const TaskCellMetric({
    required this.column,
    required this.title,
    required this.value,
    super.key,
    this.suffix = '',
    this.onChanged,
  });

  final TaskSavedViewColumn column;
  final String title;
  final int? value;
  final String suffix;
  final Future<bool> Function(int? value)? onChanged;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (cellContext) => InkWell(
      onTap: onChanged == null
          ? null
          : () => unawaited(_editValue(cellContext)),
      child: SizedBox(
        width: TaskListGrid.metric,
        child: Padding(
          padding: const .symmetric(horizontal: 12),
          child: Align(
            alignment: .centerLeft,
            child: Text(
              value == null ? '—' : '$value$suffix',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(
                color: value == null
                    ? context.colors.onSurfaceVariant
                    : context.colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _editValue(BuildContext context) async {
    final answer = await editAnchoredText(
      context,
      title: title,
      initialValue: value?.toString() ?? '',
      menuPosition: TaskContextMenu.positionFor(context),
      isNumber: true,
      allowClear: true,
    );
    if (answer == null || onChanged == null) return;
    final normalized = answer.trim();
    if (normalized.isEmpty) {
      await onChanged!(null);
      return;
    }
    final parsed = int.tryParse(normalized);
    if (parsed != null) await onChanged!(parsed);
  }
}
