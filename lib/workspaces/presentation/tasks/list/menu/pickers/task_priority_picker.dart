import 'package:flutter/material.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/task_context_menu.dart';

/// Standaryzowany picker wyboru priorytetu zadania w tabeli.
abstract final class TaskPriorityPicker {
  /// Otwiera menu kontekstowe wyboru priorytetu zadania.
  static Future<void> show(
    BuildContext context, {
    required TaskPriority selected,
    required Future<bool> Function(TaskPriority value) onChanged,
    Offset? position,
  }) async {
    final menuPosition = position != null
        ? _menuPositionForGlobal(context, position)
        : TaskContextMenu.positionFor(context);

    final value = await TaskContextMenu.show<TaskPriority>(
      context,
      position: menuPosition,
      items: [
        for (final priority in TaskPriority.values)
          TaskContextMenuItem<TaskPriority>(
            value: priority,
            title: TaskPriorityVisualHelper.label(context, priority),
            icon: TaskPriorityVisualHelper.icon(priority),
            iconColor: TaskPriorityVisualHelper.color(priority),
            isSelected: priority == selected,
          ),
      ],
    );

    if (value != null && value != selected) {
      await onChanged(value);
    }
  }

  static RelativeRect _menuPositionForGlobal(
    BuildContext context,
    Offset global,
  ) {
    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    final overlayBox = overlay?.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return RelativeRect.fill;
    final rect = global & const Size(1, 1);
    return RelativeRect.fromRect(rect, Offset.zero & overlayBox.size);
  }
}
