import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/task_context_menu.dart';

/// Standaryzowany picker wyboru statusu zadania w tabeli.
///
/// Wykorzystuje jednolitą typografię `TaskContextMenu` oraz `TaskContextMenuItem`.
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
    final menuPosition = position != null
        ? _menuPositionForGlobal(context, position)
        : TaskContextMenu.positionFor(context);

    final value = await TaskContextMenu.show<Object?>(
      context,
      position: menuPosition,
      items: [
        for (final status in ProjectTaskStatus.values)
          TaskContextMenuItem<ProjectTaskStatus>(
            value: status,
            title: TaskStatusVisualHelper.label(context, status),
            icon: TaskStatusVisualHelper.icon(status),
            iconColor: TaskStatusVisualHelper.color(status),
            isSelected: status == selected,
          ),
        if (canManage && onConfigureWorkflow != null) ...[
          const PopupMenuDivider(height: 8),
          TaskContextMenuItem<String>(
            value: _configureWorkflowSentinel,
            title: 'Konfiguruj workflow...',
            icon: Symbols.settings_rounded,
          ),
        ],
      ],
    );

    if (value == _configureWorkflowSentinel) {
      onConfigureWorkflow?.call();
    } else if (value is ProjectTaskStatus && value != selected) {
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
