import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Standaryzowany picker wyboru kamienia milowego w tabeli zadań.
abstract final class TaskMilestonePicker {
  /// Otwiera menu kontekstowe wyboru kamienia milowego.
  static Future<void> show(
    BuildContext context, {
    required List<MilestoneResponse> milestones,
    required String? selectedMilestoneId,
    required Future<void> Function(String? milestoneId) onSelected,
    Offset? position,
  }) async {
    final menuPosition = position != null
        ? _menuPositionForGlobal(context, position)
        : TaskContextMenu.positionFor(context);

    const clearValue = '___CLEAR___';
    final items = <PopupMenuEntry<String?>>[
      for (final milestone in milestones)
        TaskContextMenuItem<String?>(
          value: milestone.id,
          title: milestone.name,
          icon: Symbols.flag_circle_rounded,
          iconColor: milestone.status == MilestoneStatus.completed
              ? const Color(0xFF4CAF50)
              : context.colors.primary,
          isSelected: milestone.id == selectedMilestoneId,
        ),
      if (selectedMilestoneId != null) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<String?>(
          value: clearValue,
          title: context.l10n.tasksListClearValue,
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
        ),
      ],
    ];

    final selected = await TaskContextMenu.show<String?>(
      context,
      position: menuPosition,
      items: items,
    );

    if (selected == clearValue) {
      await onSelected(null);
    } else if (selected != null && selected != selectedMilestoneId) {
      await onSelected(selected);
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
