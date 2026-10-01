import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Direct priority selection using the same desktop menu as the task board.
final class TaskPriorityHeaderControl extends StatelessWidget {
  const TaskPriorityHeaderControl({
    required this.priority,
    required this.enabled,
    super.key,
  });

  final TaskPriority priority;
  final bool enabled;

  Future<void> _selectPriority(BuildContext context) async {
    if (!enabled) return;
    final source = context.read<TaskDetailsCubit>();
    final selected = await AppContextMenu.select<TaskPriority>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: context.l10n.taskDetailsPriorityField,
      maxWidth: 280,
      options: [
        for (final value in TaskPriority.values)
          AppContextMenuOption(
            value: value,
            label: TaskPriorityVisualHelper.label(context, value),
            icon: TaskPriorityVisualHelper.icon(value),
            iconColor: TaskPriorityVisualHelper.color(value),
            selected: value == priority,
          ),
      ],
    );
    if (!context.mounted ||
        selected == null ||
        source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      return;
    }
    await source.changePriority(selected);
  }

  @override
  Widget build(BuildContext context) => TextButton.icon(
    key: const ValueKey('task-header-priority'),
    onPressed: enabled ? () => unawaited(_selectPriority(context)) : null,
    icon: Icon(
      TaskPriorityVisualHelper.icon(priority),
      size: 14,
      color: enabled
          ? TaskPriorityVisualHelper.color(priority)
          : context.colors.onSurfaceVariant,
    ),
    label: Text(TaskPriorityVisualHelper.label(context, priority)),
    style: TextButton.styleFrom(
      foregroundColor: context.colors.onSurface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      textStyle: context.tasksTheme.controlText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
        side: BorderSide(color: context.tasksTheme.canvasBorder),
      ),
    ),
  );
}
