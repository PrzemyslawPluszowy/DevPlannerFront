import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
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
    const clearValue = '___CLEAR___';
    final selected = await AppContextMenu.select<String>(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      options: [
        for (final milestone in milestones)
          AppContextMenuOption(
            value: milestone.id,
            label: milestone.name,
            icon: Symbols.flag_circle_rounded,
            iconColor: milestone.status == MilestoneStatus.completed
                ? const Color(0xFF4CAF50)
                : context.colors.primary,
            selected: milestone.id == selectedMilestoneId,
          ),
        if (selectedMilestoneId != null)
          AppContextMenuOption(
            value: clearValue,
            label: context.l10n.tasksListClearValue,
            icon: Symbols.close_rounded,
            iconColor: context.colors.error,
            separatorBefore: true,
          ),
      ],
    );

    if (selected == clearValue) {
      await onSelected(null);
    } else if (selected != null && selected != selectedMilestoneId) {
      await onSelected(selected);
    }
  }
}
