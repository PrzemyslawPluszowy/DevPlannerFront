import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/helpers/task_saved_view_labels.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Sekcja wyboru pola i kierunku sortowania w edytorze zapisanego widoku.
class TaskSavedViewSortSection extends StatelessWidget {
  const TaskSavedViewSortSection({
    required this.sortField,
    required this.sortDirection,
    required this.onSortFieldChanged,
    required this.onSortDirectionChanged,
    super.key,
  });

  final TaskSavedViewSortField sortField;
  final TaskSavedViewSortDirection sortDirection;
  final ValueChanged<TaskSavedViewSortField> onSortFieldChanged;
  final ValueChanged<TaskSavedViewSortDirection> onSortDirectionChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<TaskSavedViewSortField>(
          initialValue: sortField,
          decoration: InputDecoration(
            labelText: l10n.tasksSavedViewsSort,
          ),
          items: [
            for (final item in TaskSavedViewSortField.values)
              DropdownMenuItem(
                value: item,
                child: Text(TaskSavedViewLabels.sortField(context, item)),
              ),
          ],
          onChanged: (value) {
            if (value != null) onSortFieldChanged(value);
          },
        ),
        const SizedBox(height: 12),
        SegmentedButton<TaskSavedViewSortDirection>(
          segments: [
            ButtonSegment(
              value: TaskSavedViewSortDirection.ascending,
              icon: const Icon(Symbols.arrow_upward_rounded),
              label: Text(l10n.tasksSavedViewsAscending),
            ),
            ButtonSegment(
              value: TaskSavedViewSortDirection.descending,
              icon: const Icon(Symbols.arrow_downward_rounded),
              label: Text(l10n.tasksSavedViewsDescending),
            ),
          ],
          selected: {sortDirection},
          onSelectionChanged: (value) => onSortDirectionChanged(value.first),
        ),
      ],
    );
  }
}
