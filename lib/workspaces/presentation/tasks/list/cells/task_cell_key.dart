import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';

/// Komórka klucza zadania (np. TASK-123).
class TaskCellKey extends StatelessWidget {
  const TaskCellKey({required this.task, super.key});

  final ProjectTaskListItemResponse task;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: TaskListGrid.key,
    child: Padding(
      padding: const .symmetric(horizontal: 12),
      child: Align(
        alignment: .centerLeft,
        child: Text(
          task.key,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.labelMedium?.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  );
}
