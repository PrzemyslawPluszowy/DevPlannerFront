import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Standaryzowany picker wyboru statusu zadania w tabeli.
///
/// Korzysta ze wspólnej powierzchni `AppContextMenu`.
abstract final class TaskStatusPicker {
  static const _configureWorkflowSentinel = 'CONFIGURE_WORKFLOW_SENTINEL';

  /// Otwiera menu kontekstowe wyboru statusu zadania.
  static Future<void> show(
    BuildContext context, {
    required ProjectTaskStatus selected,
    required Future<bool> Function(ProjectTaskStatus value) onChanged,
    Offset? position,
    bool canManage = false,
    VoidCallback? onConfigureWorkflow,
  }) async {
    final value = await AppContextMenu.select<Object>(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      options: [
        for (final status in ProjectTaskStatus.values)
          AppContextMenuOption(
            value: status,
            label: TaskStatusVisualHelper.label(context, status),
            icon: TaskStatusVisualHelper.icon(status),
            iconColor: TaskStatusVisualHelper.color(status),
            selected: status == selected,
          ),
        if (canManage && onConfigureWorkflow != null)
          const AppContextMenuOption(
            value: _configureWorkflowSentinel,
            label: 'Konfiguruj workflow...',
            icon: Symbols.settings_rounded,
            separatorBefore: true,
          ),
      ],
    );

    if (value == _configureWorkflowSentinel) {
      onConfigureWorkflow?.call();
    } else if (value is ProjectTaskStatus && value != selected) {
      await onChanged(value);
    }
  }

}
