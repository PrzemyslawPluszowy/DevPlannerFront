import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:flutter/material.dart';

/// Standaryzowany picker wyboru priorytetu zadania w tabeli.
abstract final class TaskPriorityPicker {
  /// Otwiera menu kontekstowe wyboru priorytetu zadania.
  static Future<void> show(
    BuildContext context, {
    required TaskPriority selected,
    required Future<bool> Function(TaskPriority value) onChanged,
    Offset? position,
  }) async {
    final value = await AppContextMenu.select<TaskPriority>(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      options: [
        for (final priority in TaskPriority.values)
          AppContextMenuOption(
            value: priority,
            label: TaskPriorityVisualHelper.label(context, priority),
            icon: TaskPriorityVisualHelper.icon(priority),
            iconColor: TaskPriorityVisualHelper.color(priority),
            selected: priority == selected,
          ),
      ],
    );

    if (value != null && value != selected) {
      await onChanged(value);
    }
  }

}
