import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/helpers/task_saved_view_labels.dart';

/// Sekcja wyboru grupowania zadań w edytorze zapisanego widoku.
class TaskSavedViewGroupSection extends StatelessWidget {
  const TaskSavedViewGroupSection({
    required this.groupBy,
    required this.onGroupByChanged,
    super.key,
  });

  final TaskSavedViewGroupBy groupBy;
  final ValueChanged<TaskSavedViewGroupBy> onGroupByChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DropdownButtonFormField<TaskSavedViewGroupBy>(
      initialValue: groupBy,
      decoration: InputDecoration(
        labelText: l10n.tasksSavedViewsGroup,
      ),
      items: [
        for (final item in TaskSavedViewGroupBy.values)
          DropdownMenuItem(
            value: item,
            child: Text(TaskSavedViewLabels.groupBy(context, item)),
          ),
      ],
      onChanged: (value) {
        if (value != null) onGroupByChanged(value);
      },
    );
  }
}
