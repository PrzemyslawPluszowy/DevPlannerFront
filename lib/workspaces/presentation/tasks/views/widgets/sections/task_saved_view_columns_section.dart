import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/helpers/task_saved_view_labels.dart';

/// Sekcja wyboru i widoczności kolumn w edytorze zapisanego widoku.
///
/// Zachowuje stabilność `columnOrder` — dodane kolumny dopisywane są na końcu,
/// a usunięte są z niego wycofywane bez losowego tasowania.
class TaskSavedViewColumnsSection extends StatelessWidget {
  const TaskSavedViewColumnsSection({
    required this.columns,
    required this.customFieldIds,
    required this.columnOrder,
    required this.availableCustomFields,
    required this.onColumnsChanged,
    required this.onCustomFieldIdsChanged,
    required this.onColumnOrderChanged,
    super.key,
  });

  final List<TaskSavedViewColumn> columns;
  final List<String> customFieldIds;
  final List<String> columnOrder;
  final List<TaskCustomFieldResponse> availableCustomFields;
  final ValueChanged<List<TaskSavedViewColumn>> onColumnsChanged;
  final ValueChanged<List<String>> onCustomFieldIdsChanged;
  final ValueChanged<List<String>> onColumnOrderChanged;

  void _toggleSystemColumn(TaskSavedViewColumn column, bool selected) {
    final id = 'sys:${column.name}';
    final updatedCols = List<TaskSavedViewColumn>.from(columns);
    final updatedOrder = List<String>.from(columnOrder);

    if (selected) {
      if (!updatedCols.contains(column)) updatedCols.add(column);
      if (!updatedOrder.contains(id)) updatedOrder.add(id);
    } else {
      // Wymagamy co najmniej jednej kolumny
      if (updatedCols.length + customFieldIds.length <= 1) return;
      updatedCols.remove(column);
      updatedOrder.remove(id);
    }

    onColumnsChanged(updatedCols);
    onColumnOrderChanged(updatedOrder);
  }

  void _toggleCustomField(String fieldId, bool selected) {
    final id = 'cf:$fieldId';
    final updatedFields = List<String>.from(customFieldIds);
    final updatedOrder = List<String>.from(columnOrder);

    if (selected) {
      if (!updatedFields.contains(fieldId)) updatedFields.add(fieldId);
      if (!updatedOrder.contains(id)) updatedOrder.add(id);
    } else {
      if (columns.length + updatedFields.length <= 1) return;
      updatedFields.remove(fieldId);
      updatedOrder.remove(id);
    }

    onCustomFieldIdsChanged(updatedFields);
    onColumnOrderChanged(updatedOrder);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.tasksSavedViewsColumns,
          style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final col in TaskSavedViewColumn.values)
              FilterChip(
                label: Text(TaskSavedViewLabels.column(context, col)),
                selected: columns.contains(col),
                onSelected: (selected) => _toggleSystemColumn(col, selected),
              ),
          ],
        ),
        if (availableCustomFields.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Pola własne',
            style: context.text.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final field in availableCustomFields)
                FilterChip(
                  label: Text(field.name),
                  selected: customFieldIds.contains(field.id),
                  onSelected: (selected) =>
                      _toggleCustomField(field.id, selected),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
