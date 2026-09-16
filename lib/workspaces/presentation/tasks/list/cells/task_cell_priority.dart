import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_priority_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Komórka priorytetu zadania w tabeli.
///
/// Prezentuje kolorową flagę oraz nazwę priorytetu. Kliknięcie otwiera
/// standaryzowane menu wyboru priorytetu.
class TaskCellPriority extends StatelessWidget {
  const TaskCellPriority({
    required this.priority,
    super.key,
    this.onChanged,
  });

  /// Aktualny priorytet zadania.
  final TaskPriority priority;

  /// Callback wywoływany przy zmianie priorytetu przez użytkownika.
  final Future<bool> Function(TaskPriority priority)? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = TaskPriorityVisualHelper.color(priority);
    final icon = TaskPriorityVisualHelper.icon(priority);
    final label = TaskPriorityVisualHelper.label(context, priority);

    return Builder(
      builder: (cellContext) => SizedBox(
        width: TaskListGrid.priority,
        child: Padding(
          padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p6),
          child: InkWell(
            borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
            onTap: onChanged == null
                ? null
                : () => unawaited(
                    TaskPriorityPicker.show(
                      cellContext,
                      selected: priority,
                      onChanged: onChanged!,
                    ),
                  ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                border: Border.all(
                  color: color.withValues(alpha: 0.4),
                  width: 0.8,
                ),
              ),
              child: Padding(
                padding: const .symmetric(horizontal: Sizes.p6),
                child: Center(
                  child: Row(
                    mainAxisSize: .min,
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        icon,
                        size: 14,
                        color: color,
                      ),
                      const SizedBox(width: Sizes.p4),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
